---
title: Get started with F5 WAF for NGINX
weight: 200
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-description: Quick start guide for protecting traffic with F5 WAF for NGINX in NGINX Gateway Fabric.
nd-summary: >
  Deploy a sample application, compile a WAF policy, and apply it to a Gateway using NGINX Gateway Fabric.
  This walkthrough uses the HTTP source type to demonstrate the full flow from policy compilation to attack blocking.
---

This guide walks through the complete flow of protecting traffic with F5 WAF for NGINX: deploy a sample application, compile a WAF policy, apply it to a Gateway, and verify that attacks are blocked.

For an overview of WAF concepts and architecture, see [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}}).

---

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus.
- A valid F5 WAF for NGINX subscription. F5 WAF for NGINX is a separate add-on to NGINX Plus and is not included with the NGINX Plus license.
- Ensure an imagePullSecret is available to pull the images from the NGINX private container registry, or that the NGINX Plus WAF image (`nginx-plus-waf`) and the WAF sidecar images (`waf-enforcer`, `waf-config-mgr`) are available in your container registry.
- Install [Docker](https://docs.docker.com/get-started/get-docker/) to run the F5 WAF compiler.

---

## Deploy the sample application

Deploy the `coffee` and `tea` sample applications. The `coffee` app is configured to return a response containing fake sensitive data (credit card number and SSN), which is used later to demonstrate data guard masking:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
spec:
  replicas: 1
  selector:
    matchLabels:
      app: coffee
  template:
    metadata:
      labels:
        app: coffee
    spec:
      containers:
      - name: coffee
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
  name: coffee
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
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

## Enable WAF on the NginxProxy

Create a `NginxProxy` resource with `waf.enable: true`. This instructs NGINX Gateway Fabric to deploy the `waf-enforcer` and `waf-config-mgr` sidecar containers alongside the NGINX Pod for any Gateway that references this `NginxProxy`.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: waf-enabled-proxy
spec:
  waf:
    enable: true
EOF
```

{{< call-out "note" >}} If you use custom container images for the WAF sidecars or NGINX Plus, specify them in `spec.kubernetes.deployment.wafContainers` and `spec.kubernetes.deployment.container.image`. See the [NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}}) for details. {{< /call-out >}}

---

## Create the Gateway

Create a Gateway that references the WAF-enabled `NginxProxy`:

```yaml
kubectl apply -f - <<EOF
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
    - name: coffee
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

## Deploy a bundle server

Deploy a simple NGINX-based server inside your cluster to host compiled bundles:

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
      containers:
      - name: bundle-server
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: bundles
          mountPath: /usr/share/nginx/html
      volumes:
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

Wait for the bundle server pod to be ready:

```shell
kubectl wait --for=condition=Available deployment/bundle-server --timeout=60s
```

---

## Compile a policy and upload it

Create a policy definition that blocks common attack signatures:

```json
cat > attack-signatures-blocking.json <<'EOF'
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
EOF
```

Compile the policy definition into a `.tgz` bundle using the F5 WAF compiler:

```shell
docker run --rm \
  -v "$(pwd):/work" \
  private-registry.nginx.com/nap/waf-compiler:5.12.1 \
  -p /work/attack-signatures-blocking.json \
  -o /work/attack-signatures-blocking.tgz
```

{{< call-out "note" >}} The compiler image requires access to the NGINX private container registry. Replace `5.12.1` with the F5 WAF for NGINX version that matches your WAF sidecar images. See [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}) for full compiler usage details. {{< /call-out >}}

Copy the compiled bundle into the bundle server pod:

```shell
BUNDLE_POD=$(kubectl get pods -l app=bundle-server -o jsonpath='{.items[0].metadata.name}')
kubectl cp attack-signatures-blocking.tgz "${BUNDLE_POD}:/usr/share/nginx/html/attack-signatures-blocking.tgz"
```

Verify the bundle is being served:

```shell
kubectl exec "${BUNDLE_POD}" -- ls -la /usr/share/nginx/html/
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

Save the Gateway's external IP and port:

```shell
GW_IP=$(kubectl get gateway gateway -o jsonpath='{.status.addresses[0].value}')
GW_PORT=80
```

**Verify normal traffic flows.** Send a request to the `customers` route — the response contains the fake sensitive data from the `coffee` backend:

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

{{< call-out "note" >}} The exact blocking response depends on your WAF policy configuration. Check the security log (stderr in this example) for a corresponding blocked event using `kubectl logs <nginx-pod-name> -c nginx`. {{< /call-out >}}

---

## Apply a route-level override

In the previous step, you saw that the `customers` route returns sensitive data (credit card numbers and SSNs) in the response body. The gateway-level `attack-signatures-blocking` policy blocks inbound attacks, but does not inspect outbound responses.

To protect sensitive data in responses, apply a **data guard** policy as a route-level override on the `customers` route. This policy masks credit card numbers and Social Security numbers in response bodies.

### Compile the data guard policy

```json
cat > dataguard-blocking.json <<'EOF'
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

Compile and upload:

```shell
docker run --rm \
  -v "$(pwd):/work" \
  private-registry.nginx.com/nap/waf-compiler:5.12.1 \
  -p /work/dataguard-blocking.json \
  -o /work/dataguard-blocking.tgz

kubectl cp dataguard-blocking.tgz "${BUNDLE_POD}:/usr/share/nginx/html/dataguard-blocking.tgz"
```

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

Wait for the policy to be programmed, then send the same request to the `customers` route:

```shell
kubectl wait --for=jsonpath='{.status.ancestors[0].conditions[?(@.type=="Accepted")].status}'=True wafpolicy/customers-strict-protection --timeout=60s
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

- [Configure policy sources (NIM and N1C)]({{< ref "/ngf/waf-integration/policy-sources.md" >}}) for managed policy workflows.
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for polling, TLS, authentication, security logging, and fail-open behavior.
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}}) if a condition is `False`.
