---
title: Configure policy sources
weight: 300
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-description: Configure WAFPolicy to fetch compiled bundles from F5 NGINX Instance Manager, F5 NGINX One Console, or an HTTP server.
---

NGINX Gateway Fabric supports three policy source types for fetching compiled WAF bundles: F5 NGINX Instance Manager, F5 NGINX One Console, and direct HTTP/HTTPS URLs. For a quick start walkthrough using the HTTP source, see [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started.md" >}}).

Before configuring a policy source, ensure that WAF is [enabled on the NginxProxy]({{< ref "/ngf/waf-integration/overview.md#enable-waf-on-the-nginxproxy" >}}) — either per Gateway or globally via Helm values.

{{< call-out "tip" >}} By default, NGINX Gateway Fabric retries transient fetch failures up to 3 times with exponential backoff, and each fetch attempt times out after 30 seconds. You can tune these using the `retryAttempts` and `timeout` fields on `policySource` or `logSource`. {{< /call-out >}}

---

## NGINX Instance Manager (NGINX Instance Manager)

Use this option when you manage WAF policies through NGINX Instance Manager. For details on creating and compiling policies in NGINX Instance Manager, see [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}) and [Create a security policy bundle]({{< ref "/nim/waf-integration/policies-and-logs/bundles/create-bundle.md" >}}).

**Workflow:**

1. Author and compile a policy in NGINX Instance Manager using the NGINX Instance Manager console or API. Verify that compilation succeeded before proceeding — NGINX Gateway Fabric cannot detect compilation failures in NGINX Instance Manager.
2. Create a Secret with your NGINX Instance Manager credentials.
3. Create a `WAFPolicy` referencing the compiled policy by name.

### Create the credentials Secret

NGINX Instance Manager supports HTTP Basic Auth (username and password) or Bearer Token authentication. NGINX Gateway Fabric infers the authentication method from the keys present in the Secret:

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
    # insecureSkipVerify: true # testing only - do not use in production
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

Replace `https://nim.example.com` with your NGINX Instance Manager base URL, and `ngfBlocking` with your compiled policy name.

{{< call-out "tip" >}} To skip TLS certificate verification when fetching bundles (for testing only - not recommended for production), uncomment 'insecureSkipVerify: true'. {{< /call-out >}}

{{< call-out "tip" >}} To pin a specific policy version, use `policyUID` instead of `policyName`. Find the UID in the NGINX Instance Manager console or API. A pinned UID always resolves to the same compiled bundle, so polling should be disabled to avoid unnecessary network requests. {{< /call-out >}}

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

This policy overrides the gateway-level policy for the `customers` route only. Any other routes attached to the gateway continue to use the gateway-level `ngfBlocking` policy.

---

## F5 NGINX One Console

Use this option when you manage WAF policies through F5 NGINX One Console. For details on creating and compiling policies in NGINX One Console, see [Manage policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}).

**Workflow:**

1. Author and compile a policy in the NGINX One Console console or API. If no compiled bundle for a given policy exists yet, NGINX Gateway Fabric triggers compilation via the NGINX One Console API when it first reconciles the WAFPolicy and waits for it to complete.
2. Create a Secret with your NGINX One Console API token.
3. Create a `WAFPolicy` referencing the compiled policy.

### Create the credentials Secret

NGINX One Console uses APIToken authentication. Create a Secret with a `token` key:

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

Replace `<tenant>` with your NGINX One Console tenant hostname. The `namespace` field refers to the NGINX One Console namespace where the policy resides.

{{< call-out "tip" >}} To pin a specific policy version, set `policyVersionID`. A pinned version always resolves to the same compiled bundle, so polling should be disabled to avoid unnecessary network requests. If you use only `policyName` or `policyObjectID` without a version pin, the latest compiled bundle is fetched on each reconciliation or poll cycle. {{< /call-out >}}

---

## HTTP/HTTPS server

Use this option when you compile WAF policies using the F5 WAF compiler CLI or a CI/CD pipeline and host the resulting bundle on an HTTP/HTTPS server. For details on using the compiler, see [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}).

For a complete walkthrough including policy compilation and a bundle server deployment, see [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started.md" >}}).

For production environments, you would typically host compiled bundles on an HTTPS server with authentication. See [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for details on adding credentials, custom CA certificates, and checksum verification to your `policySource`.

---

## Management console visibility

When using NGINX Instance Manager or NGINX One Console as your policy source, be aware that neither management console currently displays WAF policy deployments to NGINX Gateway Fabric, nor does it show which compiled bundle versions NGINX Gateway Fabric has fetched.

This is by design: NGINX Gateway Fabric pulls compiled bundles from the management plane using a pull model and deploys them directly in Kubernetes using native Kubernetes manifests, rather than through the NGINX Instance Manager or NGINX One Console console. This workflow ensures that policies can be created, compiled, and made available to NGINX Gateway Fabric via API without requiring console-managed deployment flows.

Policy association visibility for NGINX Instance Manager and NGINX One Console will be added in a future release. In the meantime, use `kubectl describe wafpolicy <name>` to check deployment status.

### Export security logs to F5 NGINX One Console

Although the NGINX One Console console does not display which policies are deployed to NGINX Gateway Fabric data planes, you can export WAF security events to the NGINX One Console security dashboard. This gives your security operations team visibility into blocked attacks, violations, and traffic patterns directly in the console.

To enable this, configure a `securityLogs` entry that sends events to the NGINX Agent's built-in OpenTelemetry collector, which forwards them to NGINX One Console. Use a log profile compiled for the NGINX One Console security dashboard:

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

The `localhost:1514` syslog destination points to the NGINX Agent's OpenTelemetry collector receiver, which runs as a sidecar in the NGINX Pod. The agent forwards the security events to the NGINX One Console console, where they appear in the security monitoring dashboard.

{{< call-out "note" >}} The `profileName: "secops_dashboard"` log profile must exist in your NGINX One Console namespace. This profile is required for events to appear correctly in the NGINX One Console security dashboard. {{< /call-out >}}

---

## See also

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}})
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}})
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})
