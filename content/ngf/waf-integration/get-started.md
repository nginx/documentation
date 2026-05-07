---
title: Get started with F5 WAF for NGINX
weight: 200
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-description: Quick start guide for protecting traffic with F5 WAF for NGINX in NGINX Gateway Fabric.
f5-summary: >
  Deploy a sample application, compile a WAF policy, and apply it to a Gateway using NGINX Gateway Fabric.
  This walkthrough uses the HTTP source type to demonstrate the full flow from policy compilation to attack blocking.
---

This guide walks through the complete flow of protecting traffic with F5 WAF for NGINX: deploy a sample application, compile a WAF policy, apply it to a Gateway, and verify that attacks are blocked.

For an overview of WAF concepts and architecture, see [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}}).

---

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus.
- Have a valid F5 WAF for NGINX subscription. F5 WAF for NGINX is a separate add-on to NGINX Plus and is not included with the NGINX Plus license.
- Have NGINX Gateway Fabric configured with an `imagePullSecret` for the NGINX private container registry (`private-registry.nginx.com`), either through Helm values or deployment manifests. When a Gateway is deployed, NGINX Gateway Fabric automatically creates the registry secret in the Gateway's namespace with the naming convention `<gateway-name>-nginx-<image-pull-secret-name>. The bundle server Deployment in this guide references the same secret for pulling the F5 WAF compiler image, be sure to update the secret name to match your environment.

---

## Deploy the sample application

Deploy the `customers` and `tea` sample applications. The `customers` app is configured to return a response containing fake sensitive data (credit card number and SSN), which is used later to demonstrate data guard masking:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: customers
spec:
  replicas: 1
  selector:
    matchLabels:
      app: customers
  template:
    metadata:
      labels:
        app: customers
    spec:
      containers:
      - name: customers
        image: hashicorp/http-echo:latest
        args:
        - "-listen=:8080"
        - "-text=Customer List:\n\nName: John Doe\nCredit Card: 4111-1111-1111-1111\nSSN: 123-45-6789\n"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: customers
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: customers
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: tea
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
EOF
```

---

## Create the Gateway with WAF enabled

Create an `NginxProxy` with `waf.enable: true` and a Gateway that references it. This instructs NGINX Gateway Fabric to deploy the WAF sidecar containers alongside the NGINX Pod for this Gateway:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: waf-enabled-proxy
spec:
  waf:
    enable: true
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  infrastructure:
    parametersRef:
      name: waf-enabled-proxy
      group: gateway.nginx.org
      kind: NginxProxy
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: "*.example.com"
EOF
```

{{< call-out "tip" >}} This creates a per-Gateway NginxProxy. You can also enable WAF for all Gateways at once using the GatewayClass-level NginxProxy or Helm values. See [Enable WAF on the NginxProxy]({{< ref "/ngf/waf-integration/overview.md#enable-waf-on-the-nginxproxy" >}}) for details, including custom WAF container images and additional settings. {{< /call-out >}}

---

## Create the HTTPRoutes

Create two HTTPRoutes — `customers` and `tea` — attached to the Gateway:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: customers
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /customers
    backendRefs:
    - name: customers
      port: 80
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: tea
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /tea
    backendRefs:
    - name: tea
      port: 80
EOF
```

---

## Create policy definitions

Create a `ConfigMap` containing the WAF policy definitions used in this guide. The bundle server will compile these into `.tgz` [bundles]({{< ref "/ngf/waf-integration/overview.md#bundles" >}}) at startup.

The first policy (`attack-signatures-blocking`) blocks common attack signatures such as cross-site scripting (XSS) and SQL injection. The second policy (`dataguard-blocking`) masks sensitive data such as credit card numbers and Social Security numbers in response bodies.

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: waf-policy-definitions
data:
  attack-signatures-blocking.json: |
    {
      "policy": {
        "name": "attack-signatures-blocking",
        "template": {
          "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
          {
            "name": "All Signatures",
            "block": true,
            "alarm": true
          }
        ]
      }
    }
  dataguard-blocking.json: |
    {
      "policy": {
        "name": "dataguard-blocking",
        "template": {
          "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "data-guard": {
          "enabled": true,
          "creditCardNumbers": true,
          "usSocialSecurityNumbers": true
        }
      }
    }
EOF
```

---

## Deploy the bundle server

Deploy a bundle server that compiles the policy definitions into `.tgz` bundles using [F5 WAF compiler]({{< ref "/waf/configure/compiler.md" >}}) init containers, then serves them over HTTP:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bundle-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bundle-server
  template:
    metadata:
      labels:
        app: bundle-server
    spec:
      imagePullSecrets:
      - name: gateway-nginx-nginx-plus-registry-secret
      initContainers:
      - name: compile-attack-signatures
        image: private-registry.nginx.com/nap/waf-compiler:{{< ngf-waf-release-version >}}
        args:
        - -p
        - /policies/attack-signatures-blocking.json
        - -o
        - /bundles/attack-signatures-blocking.tgz
        volumeMounts:
        - name: policies
          mountPath: /policies
        - name: bundles
          mountPath: /bundles
      - name: compile-dataguard
        image: private-registry.nginx.com/nap/waf-compiler:{{< ngf-waf-release-version >}}
        args:
        - -p
        - /policies/dataguard-blocking.json
        - -o
        - /bundles/dataguard-blocking.tgz
        volumeMounts:
        - name: policies
          mountPath: /policies
        - name: bundles
          mountPath: /bundles
      containers:
      - name: bundle-server
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: bundles
          mountPath: /usr/share/nginx/html
      volumes:
      - name: policies
        configMap:
          name: waf-policy-definitions
      - name: bundles
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: bundle-server
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: bundle-server
EOF
```

{{< call-out "note" >}} The compiler image tag must match the F5 WAF for NGINX version supported by your NGINX Gateway Fabric release. See the [Technical specifications]({{< ref "/ngf/overview/technical-specifications.md" >}}) for the supported version. The `imagePullSecrets` name must match the secret configured for accessing the NGINX private container registry. See [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}) for full compiler usage details. {{< /call-out >}}

Wait for the init containers to compile the policies and the bundle server to start:

```shell
kubectl wait --for=condition=Available deployment/bundle-server --timeout=120s
```

---

## Apply WAF protection

Create a `WAFPolicy` that fetches the compiled bundle from the in-cluster bundle server and protects all routes attached to the Gateway:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: gateway-base-protection
spec:
  type: HTTP
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  policySource:
    httpSource:
      url: http://bundle-server.default.svc.cluster.local/attack-signatures-blocking.tgz
  securityLogs:
  - destination:
      type: stderr
    logSource:
      defaultProfile: log_blocked
EOF
```

{{< call-out "note" >}} If you deployed the resources in a different namespace, replace `default` in the bundle server URL with your namespace: `http://bundle-server.<namespace>.svc.cluster.local/attack-signatures-blocking.tgz`. {{< /call-out >}}

---

## Verify WAF protection

### Verify the WAF containers are running

Verify that the NGINX Pod has all three containers running:

```shell
kubectl get pods -l app.kubernetes.io/name=gateway-nginx
```

Each NGINX Pod should show `3/3` in the `READY` column, indicating the main NGINX container, `waf-enforcer`, and `waf-config-mgr` are all running:

```text
NAME                             READY   STATUS    RESTARTS   AGE
gateway-nginx-7f9b8d6c4d-xxxxx  3/3     Running   0          2m
```

If a container is not starting, check its logs:

```shell
kubectl logs <pod-name> -c nginx
kubectl logs <pod-name> -c waf-enforcer
kubectl logs <pod-name> -c waf-config-mgr
```

### Check WAFPolicy status

Verify the WAFPolicy has been accepted and programmed:

```shell
kubectl describe wafpolicy gateway-base-protection
```

Look for three conditions in the output:

```text
Status:
  Conditions:
    Message:               The Policy is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Message:               All references are resolved
    Observed Generation:   1
    Reason:                ResolvedRefs
    Status:                True
    Type:                  ResolvedRefs
    Message:               Policy is programmed in the data plane
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

If any condition is `False`, the message field describes the problem. See [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}}) for guidance.

### Test WAF protection

Confirm the Gateway was assigned an IP address and reports a `Programmed=True` status with `kubectl describe`:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

```text
Addresses:
  Type:   IPAddress
  Value:  10.96.20.187
```

Save the public IP address and port(s) of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

**Verify normal traffic flows.** Send a request to the `customers` route — the response contains the fake sensitive data from the `customers` backend:

{{< call-out "note" >}} If you have a DNS record allocated for `cafe.example.com`, you can send the request directly to that hostname, without needing to resolve. {{< /call-out >}}

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/customers
```

```text
Customer List:

Name: John Doe
Credit Card: 4111-1111-1111-1111
SSN: 123-45-6789
```

The sensitive data passes through because the gateway-level `attack-signatures-blocking` policy only inspects inbound requests for attack patterns — it does not mask outbound response data.

**Verify attacks are blocked.** Send a request with a cross-site scripting (XSS) payload:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP "http://cafe.example.com:$GW_PORT/customers?x=</script>"
```

The WAF detects the attack signature and rejects the request:

```text
<html>
<head><title>Request Rejected</title></head>
...
```

**Verify the `tea` route is also protected.** Since the policy targets the Gateway, all attached routes inherit protection:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP "http://cafe.example.com:$GW_PORT/tea?x=</script>"
```

```text
<html>
<head><title>Request Rejected</title></head>
...
```

{{< call-out "note" >}} The exact blocking response depends on your WAF policy configuration. Check the security log (stderr in this example) for a corresponding blocked event using `kubectl logs <nginx-pod-name> -c waf-enforcer`. {{< /call-out >}}

---

## Apply a route-level override

In the previous step, you saw that the `customers` route returns sensitive data (credit card numbers and SSNs) in the response body. The gateway-level `attack-signatures-blocking` policy blocks inbound attacks, but does not inspect outbound responses.

To protect sensitive data in responses, apply a **data guard** policy as a route-level override on the `customers` route. This policy masks credit card numbers and Social Security numbers in response bodies. The `dataguard-blocking` bundle was already compiled by the bundle server init container at startup — no additional compilation is needed.

### Apply the route-level WAFPolicy

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: customers-strict-protection
spec:
  type: HTTP
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: customers
  policySource:
    httpSource:
      url: http://bundle-server.default.svc.cluster.local/dataguard-blocking.tgz
  securityLogs:
  - destination:
      type: stderr
    logSource:
      defaultProfile: log_all
EOF
```

### Verify data guard masking

Wait for the policy to be `Programmed`, then send the same request to the `customers` route:

```shell
kubectl wait --for=jsonpath='{.status.ancestors[0].conditions[?(@.type=="Programmed")].status}'=True wafpolicy/customers-strict-protection --timeout=60s
```

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/customers
```

The credit card number and SSN are now masked in the response:

```text
Customer List:

Name: John Doe
Credit Card: ***************1111
SSN: *******6789
```

---

## Next steps

- [Configure policy sources (NIM and NGINX One Console)]({{< ref "/ngf/waf-integration/policy-sources.md" >}}) for managed policy workflows.
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for polling, TLS, authentication, security logging, and fail-open behavior.
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}}) if a condition is `False`.
