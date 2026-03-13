---
title: Configure F5 WAF for NGINX for NGINX Gateway Fabric
weight: 500
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This document describes how to configure F5 NGINX Gateway Fabric to enable integration with F5 WAF for NGINX and protect your application traffic.

---

## Before you begin

You need:

- Administrator access to a Kubernetes cluster.
- [Helm](https://helm.sh) and [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) installed locally.
- **NGINX Plus** is required for F5 WAF support. You need valid NGINX Plus credentials to pull images from `private-registry.nginx.com`.
- A valid **F5 WAF for NGINX** license.

---

## Set up NGINX Plus credentials

F5 WAF support requires NGINX Plus. Before installing NGINX Gateway Fabric, you need to configure your NGINX Plus credentials as Kubernetes Secrets. See [Install NGINX Gateway Fabric with NGINX Plus]({{< ref "/ngf/install/nginx-plus.md" >}}) for full details. The steps below summarize what is required.

{{< call-out "note" >}} Create these Secrets in the `nginx-gateway` namespace. If the namespace does not yet exist, create it first with `kubectl create namespace nginx-gateway`. {{< /call-out >}}

### Download the JWT from MyF5

{{< include "/ngf/installation/nginx-plus/download-jwt.md" >}}

### Create the Docker registry Secret

{{< include "/ngf/installation/nginx-plus/docker-registry-secret.md" >}}

### Create the NGINX Plus license Secret

{{< include "/ngf/installation/nginx-plus/nginx-plus-secret.md" >}}

---

## Install NGINX Gateway Fabric with PLM

F5 WAF for NGINX relies on the **Policy Lifecycle Manager (PLM)**, which compiles WAF policies and stores them in an in-cluster S3-compatible object store (SeaweedFS). NGINX Gateway Fabric includes PLM as an optional subchart.

### Bootstrap TLS certificates for SeaweedFS

PLM's internal SeaweedFS storage requires TLS certificates. The following steps use [cert-manager](https://cert-manager.io) to generate self-signed certificates as a convenient starting point. In production environments, you can manage TLS secrets with your own certificate infrastructure and skip this section, provided you create secrets with the following names in the `nginx-gateway` namespace:

| Secret name | Purpose |
| --- | --- |
| `ngf-f5-waf-seaweedfs-ca-cert` | CA certificate |
| `ngf-f5-waf-seaweedfs-master-cert` | SeaweedFS master TLS |
| `ngf-f5-waf-seaweedfs-volume-cert` | SeaweedFS volume TLS |
| `ngf-f5-waf-seaweedfs-filer-cert` | SeaweedFS filer TLS |
| `ngf-f5-waf-seaweedfs-client-cert` | Client mTLS certificate |

The secret names are derived from your Helm release name (`ngf` in this guide). If you use a different release name, adjust the names accordingly: `{release-name}-f5-waf-seaweedfs-{component}`.

1. Install cert-manager:

   ```shell
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.4/cert-manager.yaml
   ```

   Wait for the cert-manager pods to be ready before continuing:

   ```shell
   kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=120s
   ```

2. Apply the SeaweedFS certificate resources. This creates a self-signed CA Issuer and TLS certificates for the SeaweedFS master, volume, filer, and client components:

   ```yaml
   kubectl apply -f - <<EOF
   apiVersion: cert-manager.io/v1
   kind: Issuer
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-issuer
     namespace: nginx-gateway
   spec:
     selfSigned: {}
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-ca-cert
     namespace: nginx-gateway
   spec:
     secretName: nginx-gateway-f5-waf-seaweedfs-ca-cert
     commonName: "seaweedfs-root-ca"
     isCA: true
     issuerRef:
       name: nginx-gateway-f5-waf-seaweedfs-issuer
       kind: Issuer
     duration: 87600h  # 10 years
     renewBefore: 720h # 30 days
   ---
   apiVersion: cert-manager.io/v1
   kind: Issuer
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-ca-issuer
     namespace: nginx-gateway
   spec:
     ca:
       secretName: nginx-gateway-f5-waf-seaweedfs-ca-cert
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-master-cert
     namespace: nginx-gateway
   spec:
     secretName: nginx-gateway-f5-waf-seaweedfs-master-cert
     issuerRef:
       name: nginx-gateway-f5-waf-seaweedfs-ca-issuer
       kind: Issuer
     commonName: "SeaweedFS CA"
     dnsNames:
       - '*.nginx-gateway'
       - '*.nginx-gateway.svc'
       - '*.nginx-gateway.svc.cluster.local'
       - '*.seaweedfs-master'
       - '*.seaweedfs-master.nginx-gateway'
       - '*.seaweedfs-master.nginx-gateway.svc'
       - '*.seaweedfs-master.nginx-gateway.svc.cluster.local'
     privateKey:
       algorithm: RSA
       size: 2048
     duration: 2160h  # 90 days
     renewBefore: 360h # 15 days
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-volume-cert
     namespace: nginx-gateway
   spec:
     secretName: nginx-gateway-f5-waf-seaweedfs-volume-cert
     issuerRef:
       name: nginx-gateway-f5-waf-seaweedfs-ca-issuer
       kind: Issuer
     commonName: "SeaweedFS CA"
     dnsNames:
       - '*.nginx-gateway'
       - '*.nginx-gateway.svc'
       - '*.nginx-gateway.svc.cluster.local'
       - '*.seaweedfs-volume'
       - '*.seaweedfs-volume.nginx-gateway'
       - '*.seaweedfs-volume.nginx-gateway.svc'
       - '*.seaweedfs-volume.nginx-gateway.svc.cluster.local'
     privateKey:
       algorithm: RSA
       size: 2048
     duration: 2160h
     renewBefore: 360h
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-filer-cert
     namespace: nginx-gateway
   spec:
     secretName: nginx-gateway-f5-waf-seaweedfs-filer-cert
     issuerRef:
       name: nginx-gateway-f5-waf-seaweedfs-ca-issuer
       kind: Issuer
     commonName: "SeaweedFS CA"
     dnsNames:
       - '*.nginx-gateway'
       - '*.nginx-gateway.svc'
       - '*.nginx-gateway.svc.cluster.local'
       - '*.seaweedfs-filer'
       - '*.seaweedfs-filer.nginx-gateway'
       - '*.seaweedfs-filer.nginx-gateway.svc'
       - '*.seaweedfs-filer.nginx-gateway.svc.cluster.local'
     privateKey:
       algorithm: RSA
       size: 2048
     duration: 2160h
     renewBefore: 360h
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: nginx-gateway-f5-waf-seaweedfs-client-cert
     namespace: nginx-gateway
   spec:
     secretName: nginx-gateway-f5-waf-seaweedfs-client-cert
     issuerRef:
       name: nginx-gateway-f5-waf-seaweedfs-ca-issuer
       kind: Issuer
     commonName: "SeaweedFS CA"
     dnsNames:
       - '*.nginx-gateway'
       - '*.nginx-gateway.svc'
       - '*.nginx-gateway.svc.cluster.local'
       - client
     privateKey:
       algorithm: RSA
       size: 2048
     duration: 2160h
     renewBefore: 360h
   EOF
   ```

   {{< call-out "note" >}} The example uses a self-signed CA. For production use, replace these with certificates from your own CA or certificate management solution. {{< /call-out >}}

### Install NGF with PLM enabled

Install NGINX Gateway Fabric with the PLM subchart enabled. When `f5-waf-plm.enabled=true`, Helm automatically configures the control plane to connect to PLM's SeaweedFS storage — no additional `plmStorage` values are required.

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --namespace nginx-gateway \
  --create-namespace \
  --set nginx.plus=true \
  --set nginx.imagePullSecret=nginx-plus-registry-secret \
  --set f5-waf-plm.enabled=true \
  --set f5-waf-plm.imagePullSecrets[0]=nginx-plus-registry-secret \
  --set f5-waf-plm.seaweedfsOperatorConfig.seaweedfs.certificates.enabled=true
```

The `certificates.enabled=true` flag tells PLM to use the TLS secrets created in the previous step.

Verify that the NGF and PLM pods are running:

```shell
kubectl get pods -n nginx-gateway
```

---

## Deploy the sample application

Deploy a syslog server to receive WAF security event logs, and the sample cafe application. The coffee service is configured to return sensitive data (credit card numbers and SSNs) in its responses — this is intentional, to demonstrate WAF blocking behaviour.

1. Deploy the syslog server:

   ```yaml
   kubectl apply -f - <<EOF
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: syslog
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: syslog
     template:
       metadata:
         labels:
           app: syslog
       spec:
         containers:
           - name: syslog
             image: balabit/syslog-ng:4.11.0
             ports:
               - containerPort: 514
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: syslog-svc
   spec:
     ports:
       - port: 514
         targetPort: 514
         protocol: TCP
     selector:
       app: syslog
   EOF
   ```

2. Deploy the cafe application:

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
           - "-text=Welcome to Coffee Shop!\nCustomer: John Doe\nCredit Card: 4111-1111-1111-1111\nSSN: 123-45-6789\n"
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

## Create the NAP WAF policy resources

Create the `APLogConf` and `APPolicy` resources that define your WAF policy.

1. Create the log configuration, which defines the format and content of WAF security logs:

   ```yaml
   kubectl apply -f - <<EOF
   apiVersion: appprotect.f5.com/v1
   kind: APLogConf
   metadata:
     name: logconf
   spec:
     content:
       format: default
       max_message_size: 64k
       max_request_size: any
     filter:
       request_type: all
   EOF
   ```

2. Create the WAF policy. This `APPolicy` enables Data Guard, which blocks responses containing credit card numbers and US Social Security Numbers:

   ```yaml
   kubectl apply -f - <<EOF
   apiVersion: appprotect.f5.com/v1
   kind: APPolicy
   metadata:
     name: dataguard-blocking
   spec:
     policy:
       name: dataguard_blocking
       template:
         name: POLICY_TEMPLATE_NGINX_BASE
       applicationLanguage: utf-8
       enforcementMode: blocking
       blocking-settings:
         violations:
         - name: VIOL_DATA_GUARD
           alarm: true
           block: true
       data-guard:
         enabled: true
         maskData: true
         creditCardNumbers: true
         usSocialSecurityNumbers: true
         enforcementMode: ignore-urls-in-list
         enforcementUrls: []
   EOF
   ```

---

## Create the Gateway resources

1. Create an `NginxProxy` resource with WAF enabled. Setting `waf: "enabled"` instructs NGINX Gateway Fabric to inject the WAF enforcer and config manager sidecar containers into the NGINX data plane pod when a Gateway references this proxy configuration:

   ```yaml
   kubectl apply -f - <<EOF
   apiVersion: gateway.nginx.org/v1alpha2
   kind: NginxProxy
   metadata:
     name: waf-enabled-proxy
   spec:
     waf: "enabled"
   EOF
   ```

2. Create the `Gateway`, referencing the WAF-enabled `NginxProxy` via `infrastructure.parametersRef`:

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

   After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service to route traffic. Because the `NginxProxy` has `waf: "enabled"`, the NGINX Pod will include two additional WAF sidecar containers alongside the main NGINX container:

   - **waf-enforcer**: enforces WAF policies on traffic passing through NGINX.
   - **waf-config-mgr**: manages the local WAF policy configuration, tracking which compiled policy bundles are available and providing the enforcer with the information it needs to apply them.

   Verify the gateway is created and the status shows `Accepted`:

   ```shell
   kubectl describe gateways.gateway.networking.k8s.io gateway
   ```

   ```text
   Status:
     Addresses:
       Type:   IPAddress
       Value:  10.12.13.141
     Conditions:
       Last Transition Time:  2026-03-12T15:16:03Z
       Message:               The Gateway is accepted
       Observed Generation:   1
       Reason:                Accepted
       Status:                True
       Type:                  Accepted
       Last Transition Time:  2026-03-12T15:16:03Z
       Message:               The Gateway is programmed
       Observed Generation:   1
       Reason:                Programmed
       Status:                True
       Type:                  Programmed
       Last Transition Time:  2026-03-12T15:16:03Z
       Message:               The ParametersRef resource is resolved
       Observed Generation:   1
       Reason:                ResolvedRefs
       Status:                True
       Type:                  ResolvedRefs
   ```

   Save the public IP address and port of the Gateway into shell variables:

   ```shell
   export GW_IP=XXX.YYY.ZZZ.III
   export GW_PORT=<http port number>
   ```

   {{< call-out "note" >}} In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for. {{< /call-out >}}

3. Create the `HTTPRoute` resources for the coffee and tea services:

   ```yaml
   kubectl apply -f - <<EOF
   apiVersion: gateway.networking.k8s.io/v1
   kind: HTTPRoute
   metadata:
     name: coffee
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
           value: /coffee
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
           type: Exact
           value: /tea
       backendRefs:
       - name: tea
         port: 80
   EOF
   ```

---

## Verify traffic without WAF policy

Before applying the WAF binding policy, confirm that the coffee service responds with sensitive data.

Send a request to the coffee service:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

The response contains the sensitive data that the WAF policy will block:

```text
Welcome to Coffee Shop!
Customer: John Doe
Credit Card: 4111-1111-1111-1111
SSN: 123-45-6789
```

---

## Apply the WAFGatewayBindingPolicy

The `WAFGatewayBindingPolicy` binds the compiled `APPolicy` to a Gateway and configures where WAF security logs are sent.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFGatewayBindingPolicy
metadata:
  name: gateway-base-protection
spec:
  targetRefs:
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: gateway
  apPolicySource:
    name: dataguard-blocking
  securityLogs:
    - apLogConfSource:
        name: logconf
      destination:
        type: syslog
        syslog:
          server: syslog-svc.default.svc.cluster.local:514
EOF
```

Verify that the policy is accepted and programmed in the data plane:

```shell
kubectl describe wafgatewaybindingpolicy gateway-base-protection
```

The status conditions should show all three conditions set to `True`:

```text
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       Gateway
      Name:       gateway
      Namespace:  default
    Conditions:
      Last Transition Time:  2026-03-12T15:16:03Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-03-12T15:16:03Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2026-03-12T15:16:03Z
      Message:               Policy is programmed in the data plane
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

---

## Verify WAF is blocking traffic

Send another request to the coffee service. The WAF policy now blocks the response containing sensitive data:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

The request is rejected by the WAF:

```text
<html><head><title>Request Rejected</title></head><body>The requested URL was rejected. Please consult with your administrator.<br><br>Your support ID is: 11294711299894599313<br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>
```

The WAF Data Guard policy has successfully blocked the response containing the credit card number and SSN. Security log events are forwarded to the syslog server deployed earlier.

---

TODO:

1. Add AP* API reference for full configuration options
2. Detail how to configure signature updates (including needing nginx.crt and nginx.key for pulling updates)
3. Document how to configure policies from external resources, if supported, otherwise add note that they are not yet supported as these options are in the CRD
