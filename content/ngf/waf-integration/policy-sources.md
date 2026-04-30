---
title: Configure policy sources
weight: 300
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-description: Configure WAFPolicy to fetch compiled bundles from NGINX Instance Manager, F5 NGINX One Console, or an HTTP server.
---

NGINX Gateway Fabric supports three policy source types for fetching compiled WAF bundles. This page covers the NIM and N1C managed sources, as well as HTTP source configuration for production environments. For a quick start walkthrough using the HTTP source, see [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started.md" >}}).

{{< call-out "tip" >}} By default, NGINX Gateway Fabric retries transient fetch failures up to 3 times with exponential backoff, and each fetch attempt times out after 30 seconds. You can tune these using the `retryAttempts` and `timeout` fields on `policySource` or `logSource`. {{< /call-out >}}

---

## NGINX Instance Manager (NIM)

Use this option when you manage WAF policies through NGINX Instance Manager. For details on creating and compiling policies in NIM, see [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}) and [Create a security policy bundle]({{< ref "/nim/waf-integration/policies-and-logs/bundles/create-bundle.md" >}}).

**Workflow:**

1. Author and compile a policy in NIM using the NIM console or API. Verify that compilation succeeded before proceeding — NGINX Gateway Fabric cannot detect compilation failures in NIM.
2. Create a Secret with your NIM credentials.
3. Create a `WAFPolicy` referencing the compiled policy by name.

### Create the credentials Secret

NIM supports HTTP Basic Auth (username and password) or Bearer Token authentication. NGINX Gateway Fabric infers the authentication method from the keys present in the Secret:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: nim-credentials
type: Opaque
stringData:
  username: "<NIM_USERNAME>"
  password: "<NIM_PASSWORD>"
EOF
```

To use a Bearer Token instead, create the Secret with a `token` key:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: nim-credentials
type: Opaque
data:
  token: <BASE64_ENCODED_TOKEN>
EOF
```

### Create a gateway-level WAFPolicy

The following `WAFPolicy` targets the Gateway and protects all attached routes:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: gateway-base-protection
spec:
  type: NIM
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  policySource:
    nimSource:
      url: https://nim.example.com
      policyName: ngfBlocking
    auth:
      secretRef:
        name: nim-credentials
  securityLogs:
  - destination:
      type: syslog
      syslog:
        server: syslog-svc.default.svc.cluster.local:514
    logSource:
      defaultProfile: log_illegal
EOF
```

Replace `https://nim.example.com` with your NIM base URL, and `ngfBlocking` with your compiled policy name.

{{< call-out "tip" >}} To pin a specific policy version, use `policyUID` instead of `policyName`. Find the UID in the NIM console or API. A pinned UID always resolves to the same compiled bundle, so polling should be disabled to avoid unnecessary network requests. {{< /call-out >}}

### Apply a route-level override (optional)

To apply a different policy to a specific route — for example, a data-guard policy — create a route-level `WAFPolicy`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: route-protection-http
spec:
  type: NIM
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: customers
  policySource:
    nimSource:
      url: https://nim.example.com
      policyName: ngfDataguard
    auth:
      secretRef:
        name: nim-credentials
  securityLogs:
  - destination:
      type: syslog
      syslog:
        server: syslog-svc.default.svc.cluster.local:514
    logSource:
      defaultProfile: log_illegal
EOF
```

This policy overrides the gateway-level policy for the `customers` route only. The `tea` route continues to use the gateway-level `ngfBlocking` policy.

---

## F5 NGINX One Console (N1C)

Use this option when you manage WAF policies through F5 NGINX One Console. For details on creating and compiling policies in N1C, see [Manage policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}).

**Workflow:**

1. Author and compile a policy in the N1C console or API. If no compiled bundle for a given policy exists yet, NGINX Gateway Fabric triggers compilation via the N1C API when it first reconciles the WAFPolicy and waits for it to complete.
2. Create a Secret with your N1C API token.
3. Create a `WAFPolicy` referencing the compiled policy.

### Create the credentials Secret

N1C uses APIToken authentication. Create a Secret with a `token` key:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: n1c-credentials
type: Opaque
data:
  token: <BASE64_ENCODED_TOKEN>
EOF
```

### Create a WAFPolicy

The following example uses `policyObjectID` to reference the policy directly. You can use `policyName` instead if you prefer to reference by name:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: gateway-base-protection
spec:
  type: N1C
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  policySource:
    n1cSource:
      url: https://<tenant>.volterra.us
      namespace: default
      policyObjectID: pol_12345_WTHGmDEX9qnbVjQ
      policyVersionID: pv_Tm__12345oWmJgwxiKlHAg
    auth:
      secretRef:
        name: n1c-credentials
  securityLogs:
  - destination:
      type: syslog
      syslog:
        server: syslog-svc.default.svc.cluster.local:514
    logSource:
      n1cSource:
        url: https://<tenant>.volterra.us
        namespace: default
        profileObjectID: "lp_8s8uZxLpThWwEGF7LTn_rA"
      auth:
        secretRef:
          name: n1c-credentials
EOF
```

Replace `<tenant>` with your N1C tenant hostname. The `namespace` field refers to the N1C namespace where the policy resides.

{{< call-out "tip" >}} To pin a specific policy version, set `policyVersionID`. A pinned version always resolves to the same compiled bundle, so polling should be disabled to avoid unnecessary network requests. If you use only `policyName` or `policyObjectID` without a version pin, the latest compiled bundle is fetched on each reconciliation or poll cycle. {{< /call-out >}}

---

## HTTP/HTTPS server

Use this option when you compile WAF policies using the F5 WAF compiler CLI or a CI/CD pipeline and host the resulting bundle on an HTTP/HTTPS server. For details on using the compiler, see [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}).

For a complete walkthrough including policy compilation and a bundle server deployment, see [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started.md" >}}).

For production environments, you would typically host compiled bundles on an HTTPS server with authentication. See [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for details on adding credentials, custom CA certificates, and checksum verification to your `policySource`.

---

## Management console visibility

When using NIM or N1C as your policy source, be aware that neither management console currently displays WAF policy deployments to NGINX Gateway Fabric, nor does it show which compiled bundle versions NGINX Gateway Fabric has fetched.

This is by design: NGINX Gateway Fabric pulls compiled bundles from the management plane using a pull model and deploys them directly in Kubernetes using native Kubernetes manifests, rather than through the NIM or N1C console. This workflow ensures that policies can be created, compiled, and made available to NGINX Gateway Fabric via API without requiring console-managed deployment flows.

Policy association visibility for NIM and N1C will be added in a future release. In the meantime, use `kubectl describe wafpolicy <name>` to check deployment status.

### Export security logs to F5 NGINX One Console

Although the N1C console does not display which policies are deployed to NGINX Gateway Fabric data planes, you can export WAF security events to the N1C security dashboard. This gives your security operations team visibility into blocked attacks, violations, and traffic patterns directly in the console.

To enable this, configure a `securityLogs` entry that sends events to the NGINX Agent's built-in OpenTelemetry collector, which forwards them to N1C. Use a log profile compiled for the N1C security dashboard:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: WAFPolicy
metadata:
  name: gateway-base-protection
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  type: N1C
  policySource:
    n1cSource:
      url: https://<tenant>.volterra.us
      namespace: default
      policyName: "ngfExample"
    auth:
      secretRef:
        name: n1c-credentials
  securityLogs:
  - destination:
      type: syslog
      syslog:
        server: localhost:1514
    logSource:
      n1cSource:
        url: https://<tenant>.volterra.us
        namespace: default
        profileName: "secops_dashboard"
      auth:
        secretRef:
          name: n1c-credentials
EOF
```

The `localhost:1514` syslog destination points to the NGINX Agent's OpenTelemetry collector receiver, which runs as a sidecar in the NGINX Pod. The agent forwards the security events to the N1C console, where they appear in the security monitoring dashboard.

{{< call-out "note" >}} The `profileName: "secops_dashboard"` log profile must exist in your N1C namespace. This profile is required for events to appear correctly in the N1C security dashboard. {{< /call-out >}}

---

## See also

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}})
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}})
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})
