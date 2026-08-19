---
title: Get started with F5 WAF for NGINX (PLM)
weight: 199
toc: true
f5-content-type: tutorial
f5-docs: DOCS-000
f5-product: F5 NGINX Gateway Fabric
f5-description: Tutorial for setting up F5 WAF for NGINX with a PLM-based policy workflow in F5 NGINX Gateway Fabric.
f5-keywords: "F5 NGINX Gateway Fabric, F5 WAF for NGINX, policy lifecycle manager, tutorial, step by step, beginner"
f5-summary: >
  Set up and validate a policy lifecycle workflow for F5 WAF for NGINX in F5 NGINX Gateway Fabric.
  Learn how to deploy a sample app, attach a WAFPolicy, and verify policy enforcement.
  This tutorial is for platform engineers and operators with basic Kubernetes and Gateway API knowledge.
f5-audience: operator
---

Use this tutorial to set up end-to-end traffic protection with F5 WAF for NGINX using Policy Lifecycle Management (PLM). By the end, you'll have:

- Deployed the PLM infrastructure (Policy Controller and SeaweedFS storage)
- Connected NGINX Gateway Fabric to PLM storage
- Defined a WAF policy using `APPolicy` and `APLogConf` custom resources
- Attached a `WAFPolicy` to a Gateway and configured HTTPRoutes
- Validated policy compilation and verified that attacks are blocked

PLM is one of four WAF policy source types. With PLM, you define your security posture as `APPolicy` and `APLogConf` custom resources instead of compiling and hosting bundles yourself. For a comparison with the other source types, see [PLM (Policy Lifecycle Management)]({{< ref "/ngf/waf-integration/overview.md#plm-policy-lifecycle-management" >}}).

## Before you begin

Before you start, make sure you have:

- `kubectl` access to a Kubernetes cluster.
- A valid F5 WAF for NGINX subscription. F5 WAF for NGINX is a separate add-on to NGINX Plus and isn't included with the NGINX Plus license.
- Your F5 WAF for NGINX JWT from MyF5. To get it:

  {{< include "/ngf/installation/nginx-plus/download-jwt.md" >}}

- Your private registry credentials Secret for `private-registry.nginx.com`. You'll reference this Secret when you install NGINX Gateway Fabric.

### PLM prerequisites

The following requirements apply to the PLM backend you'll install in this tutorial:

{{< include "waf/plm-prerequisites.md" >}}

### Example values

This tutorial uses the following example values. You can use different values — if you do, replace them consistently throughout.

| Example value | What it represents |
|---|---|
| `plm-system` | Namespace for the PLM backend components |
| `plm` | Helm release name for the PLM installation |
| `{{< version-waf-policy-controller >}}` | F5 WAF for NGINX Policy Controller chart and image version |
| `security` | Namespace for `APPolicy` and `APLogConf` resources |
| `default` | Namespace for the Gateway and `WAFPolicy` |
| `cafe.example.com` | Example hostname for HTTPRoutes |

## Deploy PLM infrastructure

{{< include "waf/plm-deploy-infrastructure.md" >}}

## Connect NGINX Gateway Fabric to PLM storage

NGINX Gateway Fabric fetches compiled bundles from in-cluster PLM storage. You set up storage access once, cluster-wide, at install time. This configuration applies to every `WAFPolicy` that uses `type: PLM`.

Create a `values.yaml` file that enables WAF and sets the PLM storage connection details under `nginxGateway.plmStorage`.

{{<tabs name="plm-storage-endpoint-method">}}

{{%tab name="HTTPS (secure)"%}}

```yaml
nginxGateway:
  plmStorage:
    url: "https://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local"
    credentialsSecretName: "plm-system/plm-f5-waf-seaweedfs-auth"  # contains the seaweedfs_admin_secret field
    tls:
      caSecretName: "plm-ca-secret"  # Secret with ca.crt for verifying the storage service
      clientSSLSecretName: "plm-client-secret"  # Secret with tls.crt/tls.key for mutual TLS
      insecureSkipVerify: false                 # use only for testing
```

{{< call-out class="caution" title="Caution" >}} Always use HTTPS with TLS verification (`caSecretName`) in production. Add `clientSSLSecretName` for mutual TLS in high-security environments, and never set `insecureSkipVerify: true`. {{< /call-out >}}

{{< call-out class="note" title="Note" >}} `credentialsSecretName` and `caSecretName` must reference Secrets in the NGINX Gateway Fabric control plane namespace, unless you prefix them with `<NAMESPACE>/`. {{< /call-out >}}

{{% /tab %}}

{{%tab name="HTTP"%}}

```yaml
nginxGateway:
  plmStorage:
    url: "http://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:8333"
    credentialsSecretName: "plm-system/plm-f5-waf-seaweedfs-auth"  # contains the seaweedfs_admin_secret field
```

{{% /tab %}}

{{</tabs>}}

Install NGINX Gateway Fabric by following [the installation guide]({{< ref "/ngf/install/helm.md" >}}) and using the **NGINX Plus with WAF** tab. Apply this `values.yaml` file in your install or upgrade command by specifying `--values values.yaml`.

The PLM installation creates the credentials Secret automatically, containing the S3 secret access key in the `seaweedfs_admin_secret` field (access key ID `admin` by default):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: plm-storage-credentials
  namespace: nginx-gateway
type: Opaque
data:
  seaweedfs_admin_secret: <BASE64_ENCODED_SECRET_ACCESS_KEY>
```

NGINX Gateway Fabric reloads the PLM credentials and TLS Secrets when they change, so you can rotate credentials without restarting the pod.

## Deploy the sample application

{{< include "waf/plm-sample-app.md" >}}

## Configure security logging (optional)

{{< include "waf/plm-configure-logging.md" >}}

If you skip this section, omit the `securityLogs` field in the `WAFPolicy` resource in the next steps.

## Define the WAF policy

{{< include "waf/plm-define-policy-methods.md" >}}

The `APPolicy` and `APLogConf` are in the `security` namespace, but the `WAFPolicy` you create next targets a Gateway in the `default` namespace. To permit the cross-namespace reference, create a `ReferenceGrant` in the `security` namespace:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: ReferenceGrant
metadata:
  name: allow-wafpolicy-refs
  namespace: security
spec:
  from:
  - group: gateway.nginx.org
    kind: WAFPolicy
    namespace: default
  to:
  - group: appprotect.f5.com
    kind: APPolicy
  - group: appprotect.f5.com
    kind: APLogConf
EOF
```

{{< call-out class="note" title="Note" >}} The `ReferenceGrant` lives in the `security` namespace and must be created by whoever manages that namespace — typically your security team, not the platform engineer deploying the Gateway. Coordinate with them if you don't have access. Without a matching `ReferenceGrant`, the `WAFPolicy` is rejected with `ResolvedRefs=False` and reason `RefNotPermitted`. If you put the `APPolicy` and `APLogConf` in the same namespace as the `WAFPolicy`, you can skip the `ReferenceGrant`. See [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}}) for details. {{< /call-out >}}

## Deploy the Gateway and attach WAFPolicy

Create a Gateway. WAF is already enabled globally, so NGINX Gateway Fabric automatically deploys the WAF sidecar containers alongside the NGINX Pod:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: "*.example.com"
EOF
```

Create a `WAFPolicy` with `type: PLM` that references the `APPolicy` and `APLogConf` by name and namespace, and targets the Gateway:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: gateway-base-protection
spec:
  type: PLM
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  policyRef:
    apPolicyRef:
      name: attack-signatures
      namespace: security
  securityLogs:
  - destination:
      type: syslog
      syslog:
        server: syslog-svc.default.svc.cluster.local:514
    logRef:
      apLogConfRef:
        name: log-illegal
        namespace: security
EOF
```

This `WAFPolicy` protects every route attached to the Gateway. Later changes to the `APPolicy` or `APLogConf` spec trigger recompilation and an automatic re-fetch. You don't need to update the `WAFPolicy`.

## Configure HTTPRoutes

Create two HTTPRoutes — `customers` and `orders` — attached to the Gateway. Because the `WAFPolicy` targets the Gateway, both routes inherit WAF protection automatically:

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
  name: orders
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
        value: /orders
    backendRefs:
    - name: orders
      port: 80
EOF
```

## Validate policy compilation and application

Confirm the `APPolicy` and `APLogConf` bundles compiled successfully:

```shell
kubectl get appolicy attack-signatures -n security -o jsonpath='{.status.bundle.state}{"\n"}'
kubectl get aplogconf log-illegal -n security -o jsonpath='{.status.bundle.state}{"\n"}'
```

Both commands should print `ready`.

Verify the `WAFPolicy` has been accepted and programmed:

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

Verify that the NGINX Pod has all three containers running:

```shell
kubectl get pods -l app.kubernetes.io/name=gateway-nginx
```

Each NGINX Pod should show `3/3` in the `READY` column, indicating the main NGINX container, `waf-enforcer`, and `waf-config-mgr` are all running:

```text
NAME                             READY   STATUS    RESTARTS   AGE
gateway-nginx-7f9b8d6c4d-xxxxx  3/3     Running   0          2m
```

## Test deployment and policy enforcement

Confirm the Gateway has an IP address assigned and reports `Programmed=True`:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

```text
Addresses:
  Type:   IPAddress
  Value:  192.0.2.1
```


Save the public IP address and port of the Gateway to shell variables:

```text
GW_IP=192.0.2.1
GW_PORT=<port number>
```

**Verify normal traffic flows.** Send a request to the `customers` route — the response contains the fake sensitive data from the `customers` backend:

{{< call-out class="note" title="Note" >}} If you have a DNS record for `cafe.example.com`, you can send the request directly to that hostname without `--resolve`. {{< /call-out >}}

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/customers
```

```text
Customer List:

Name: John Doe
Credit Card: 4111-1111-1111-1111
SSN: 123-45-6789
```

The sensitive data passes through because the gateway-level `attack-signatures` policy only inspects inbound requests for attack patterns — it doesn't mask outbound response data.

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

**Verify the `orders` route is also protected.** Because the policy targets the Gateway, all attached routes inherit protection:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP "http://cafe.example.com:$GW_PORT/orders?x=</script>"
```

```text
<html>
<head><title>Request Rejected</title></head>
...
```

{{< call-out class="note" title="Note" >}} The exact blocking response depends on your WAF policy configuration. Check the security log for a corresponding blocked event using `kubectl logs <NGINX_POD_NAME> -c waf-enforcer`. {{< /call-out >}}

## Apply a route-level override (optional)

The `customers` route returns sensitive data (credit card numbers and SSNs) in the response body. The gateway-level policy blocks inbound attacks but doesn't inspect outbound responses.

This is a common pattern for SecOps and app team collaboration: the security team defines a stricter policy for a specific service, and the platform engineer or app developer attaches it as a route-level override. The override applies only to the `customers` route — other routes continue using the gateway-level policy.

To protect sensitive data in responses, define a **data guard** `APPolicy` and apply it as a route-level override on the `customers` route:

```yaml
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-blocking
  namespace: security
spec:
  policy:
    name: dataguard-blocking
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
    data-guard:
      enabled: true
      creditCardNumbers: true
      usSocialSecurityNumbers: true
EOF
```

Wait for the bundle to become ready, then create the route-level `WAFPolicy`:

```shell
kubectl wait --for=jsonpath='{.status.bundle.state}'=ready appolicy/dataguard-blocking -n security --timeout=60s
```

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: customers-strict-protection
spec:
  type: PLM
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: customers
  policyRef:
    apPolicyRef:
      name: dataguard-blocking
      namespace: security
EOF
```

This policy overrides the gateway-level policy for the `customers` route only. Other routes attached to the Gateway continue to use the gateway-level policy.

Wait for the policy to be `Programmed`, then send the same request to the `customers` route:

```shell
kubectl wait --for=jsonpath='{.status.ancestors[0].conditions[?(@.type=="Programmed")].status}'=True wafpolicy/customers-strict-protection --timeout=60s
```

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/customers
```

WAF now masks the credit card number and SSN in the response:

```text
Customer List:

Name: John Doe
Credit Card: ***************1111
SSN: *******6789
```

## Next steps

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}}) for architecture and policy lifecycle concepts.
- [Configure policy sources]({{< ref "/ngf/waf-integration/policy-sources.md" >}}) for the other policy source types.
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for TLS, authentication, fail-open behavior, and WAF container settings.
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}}) if a condition is `False`.
