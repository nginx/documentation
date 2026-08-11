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

This tutorial walks through the complete flow of protecting traffic with F5 WAF for NGINX using Policy Lifecycle Management (PLM). By the end, you will have:

- Deployed the PLM infrastructure (Policy Controller and SeaweedFS storage)
- Connected NGINX Gateway Fabric to PLM storage
- Defined a WAF policy using `APPolicy` and `APLogConf` custom resources
- Attached a `WAFPolicy` to a Gateway and configured HTTPRoutes
- Validated policy compilation and verified that attacks are blocked

PLM is one of four WAF policy source types. With PLM, you define your security posture as `APPolicy` and `APLogConf` custom resources instead of compiling and hosting bundles yourself. For a comparison with the other source types, see [PLM (Policy Lifecycle Management)]({{< ref "/ngf/waf-integration/overview.md#plm-policy-lifecycle-management" >}}).

## Before you begin

- Have `kubectl` access to a Kubernetes cluster.
- Have a valid F5 WAF for NGINX subscription. F5 WAF for NGINX is a separate add-on to NGINX Plus and isn't included with the NGINX Plus license.
- Have your private registry credentials Secret for `private-registry.nginx.com` available. You'll reference this Secret when you install NGINX Gateway Fabric.

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

## Configure NGF to connect to PLM storage

NGINX Gateway Fabric fetches compiled bundles from in-cluster PLM storage. You set up storage access once, cluster-wide, at install time. It applies to every `WAFPolicy` that uses `type: PLM`.

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

{{< call-out "caution" >}} Always use HTTPS with TLS verification (`caSecretName`) in production. Add `clientSSLSecretName` for mutual TLS in high-security environments, and never set `insecureSkipVerify: true`. {{< /call-out >}}

{{< call-out "note" >}} `credentialsSecretName` and `caSecretName` must reference Secrets in the NGINX Gateway Fabric control plane namespace, unless you prefix them with `<NAMESPACE>/`. {{< /call-out >}}

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

Install NGINX Gateway Fabric by following [the installation guide]({{< ref "/ngf/install/helm.md" >}}) and using the **NGINX Plus with WAF** tab, and apply this `values.yaml` file in your install or upgrade command, specifying `--values values.yaml`.

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

NGINX Gateway Fabric watches the PLM credentials and TLS Secrets and rebuilds its storage client when they change, so you can rotate credentials without restarting the pod.

## Deploy the sample application

Deploy the `customers` and `orders` sample applications. The `customers` app returns a response containing fake sensitive data (credit card number and SSN), which you'll use later to demonstrate data guard masking:

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
  name: orders
spec:
  replicas: 1
  selector:
    matchLabels:
      app: orders
  template:
    metadata:
      labels:
        app: orders
    spec:
      containers:
      - name: orders
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: orders
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: orders
EOF
```

## Configure security logging (optional)

This section is typically owned by your security team. If that's not you, share it with them before continuing.

PLM security logging profiles are defined as `APLogConf` custom resources. Create a namespace to hold your security resources, then define a log profile that logs illegal requests:

```shell
kubectl create namespace security
```

```yaml
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APLogConf
metadata:
  name: log-illegal
  namespace: security
spec:
  filter:
    request_type: illegal
  content:
    format: default
    max_request_size: any
    max_message_size: 15k
EOF
```

PLM compiles the log profile automatically. Wait for `status.bundle.state` to report `ready` before referencing it:

```shell
kubectl wait --for=jsonpath='{.status.bundle.state}'=ready aplogconf/log-illegal -n security --timeout=60s
```

If you skip this section, omit the `securityLogs` field in the `WAFPolicy` resource in the next steps.

## Define the WAF policy

This section is typically owned by your security team. They define the policy in the `security` namespace, separate from the Gateway namespace, so that security resources are managed independently from routing configuration. If that's not you, share this section with them — you'll need the `APPolicy` name and namespace before continuing to the next section.

The `APPolicy` resource defines the security policy. The PLM controller watches it, compiles it, and writes `status.bundle` with `state: ready` when the bundle is available.

Use the **Inline** tab for this guide's primary workflow. The other tabs provide alternate policy-source methods.

{{<tabs name="plm-policy-definition-methods">}}

{{%tab name="Inline"%}}

Create an `APPolicy` resource with an inline policy that blocks all attack signatures:

```yaml
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: attack-signatures
  namespace: security
spec:
  policy:
    name: attack-signatures-blocking
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
    signature-sets:
    - name: All Signatures
      block: true
      alarm: true
    cookies:
    - name: "*"
      attackSignaturesCheck: true
      enforcementType: enforce
      maskValueInLogs: false
EOF
```

Wait for the bundle to become ready:

```shell
kubectl wait --for=jsonpath='{.status.bundle.state}'=ready appolicy/attack-signatures -n security --timeout=60s
```

Because the `APPolicy` and `APLogConf` live in the `security` namespace but the `WAFPolicy` you create next targets a Gateway in the `default` namespace, create a `ReferenceGrant` in the `security` namespace to permit the cross-namespace reference:

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

{{< call-out "note" >}} The `ReferenceGrant` lives in the `security` namespace and must be created by whoever manages that namespace — typically your security team, not the platform engineer deploying the Gateway. Coordinate with them if you don't have access. Without a matching `ReferenceGrant`, the `WAFPolicy` is rejected with `ResolvedRefs=False` and reason `RefNotPermitted`. If you put the `APPolicy` and `APLogConf` in the same namespace as the `WAFPolicy`, you can skip the `ReferenceGrant`. See [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}}) for details. {{< /call-out >}}

{{% /tab %}}

{{%tab name="Git reference"%}}

Store your policy JSON in a Git repository and reference it from `APPolicy`.

#### Public repository

Create an `APPolicy` resource that references the policy file by path. Replace `<POLICY_NAME>`, `<NAMESPACE>`, `<PATH/TO/POLICY.JSON>`, `<ORG>`, `<REPO>`, and `<TAG_OR_COMMIT>` with your values:

```shell
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: <NAMESPACE>
spec:
  policy:
    $ref: <PATH/TO/POLICY.JSON>
    externalReferenceDetails:
      repositoryDetails:
        repository: https://github.com/<ORG>/<REPO>.git
        ref: "<TAG_OR_COMMIT>"
EOF
```

{{< call-out class="note" title="Note" >}}
Pin `ref` to a tag or commit SHA rather than a branch name in production environments.
{{< /call-out >}}

Check that the bundle compiled successfully:

```shell
kubectl get appolicy <POLICY_NAME> \
  --namespace <NAMESPACE> \
  --output jsonpath='State:    {.status.bundle.state}{"\n"}Bundle:   {.status.bundle.location}{"\n"}Compiler: {.status.bundle.compilerVersion}{"\n"}'
```

The output should show `State: ready`.

#### Private repository

For private repositories, create a Kubernetes secret with your personal access token (PAT):

```shell
kubectl create secret generic git-token-secret \
  --namespace <NAMESPACE> \
  --from-literal=token=<GIT_PERSONAL_ACCESS_TOKEN>
```

Then reference the secret in the `APPolicy` resource:

```shell
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: <NAMESPACE>
spec:
  policy:
    $ref: <PATH/TO/POLICY.JSON>
    externalReferenceDetails:
      repositoryDetails:
        repository: https://github.com/<ORG>/<REPO>.git
        ref: "<TAG_OR_COMMIT>"
      authentication:
        token: git-token-secret
EOF
```

#### Update a Git-referenced policy

The Policy Controller does not poll the Git repository for changes. To pick up changes to the referenced policy file, re-apply the `APPolicy` resource (or update its revision annotation) after you push changes to the repository.

{{% /tab %}}

{{%tab name="Precompiled bundle"%}}

{{< include "waf/plm-define-policy-bundle-method.md" >}}

{{% /tab %}}

{{</tabs>}}

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

This `WAFPolicy` protects every route attached to the Gateway. Later changes to the `APPolicy` or `APLogConf` spec trigger recompilation and an automatic re-fetch — no change to the `WAFPolicy` is required.

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

Confirm the Gateway was assigned an IP address and reports `Programmed=True`:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

```text
Addresses:
  Type:   IPAddress
  Value:  192.0.2.1
```

Save the public IP address and port of the Gateway into shell variables:

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

**Verify the `orders` route is also protected.** Since the policy targets the Gateway, all attached routes inherit protection:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP "http://cafe.example.com:$GW_PORT/orders?x=</script>"
```

```text
<html>
<head><title>Request Rejected</title></head>
...
```

{{< call-out "note" >}} The exact blocking response depends on your WAF policy configuration. Check the security log for a corresponding blocked event using `kubectl logs <nginx-pod-name> -c waf-enforcer`. {{< /call-out >}}

## Apply a route-level override (optional)

In the previous step, you saw that the `customers` route returns sensitive data (credit card numbers and SSNs) in the response body. The gateway-level policy blocks inbound attacks, but doesn't inspect outbound responses.

This pattern is a good example of a SecOps and app team collaboration: the security team defines a stricter policy for a specific service, and the platform engineer or app developer attaches it as a route-level override. The override applies only to the `customers` route — other routes continue using the gateway-level policy.

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

The credit card number and SSN are now masked in the response:

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
