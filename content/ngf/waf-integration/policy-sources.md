---
title: Configure policy sources
weight: 300
toc: true
f5-content-type: how-to
f5-product: NGINX Gateway Fabric
description: Configure WAFPolicy to fetch compiled bundles from F5 NGINX Instance Manager, F5 NGINX One Console, or an HTTP server.
---

F5 NGINX Gateway Fabric supports three policy source types for fetching compiled F5 WAF bundles: F5 NGINX Instance Manager, F5 NGINX One Console, and direct HTTP/HTTPS URLs. For a quick start walkthrough using the HTTP source, see [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started-http.md" >}}).

Before you configure a policy source, make sure F5 WAF is turned on for the NginxProxy — either per Gateway or globally through Helm values. For version requirements, see [Technical specifications]({{< ref "/ngf/overview/technical-specifications.md" >}}).

{{< call-out class="tip" title="Tip: Fetch retry behavior" >}} By default, NGINX Gateway Fabric retries transient fetch failures up to 3 times with exponential backoff, and each fetch attempt times out after 30 seconds. You can tune these using the `retryAttempts` and `timeout` fields on `policySource` or `logSource`. {{< /call-out >}}

---

## F5 NGINX Instance Manager

Use this option when you manage F5 WAF policies through F5 NGINX Instance Manager. For details on creating and compiling policies in NGINX Instance Manager, see [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}) and [Create a security policy bundle]({{< ref "/nim/waf-integration/policies-and-logs/bundles/create-bundle.md" >}}).

**Workflow:**

1. Author and compile a policy in NGINX Instance Manager using the NGINX Instance Manager console or API. Verify that compilation succeeded. NGINX Gateway Fabric can't detect compilation failures in NGINX Instance Manager.
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

{{< call-out class="tip" title="Tip: Testing with self-signed certificates" >}} To skip TLS certificate verification when fetching bundles, uncomment `insecureSkipVerify: true`. Don't use this in production. {{< /call-out >}}

{{< call-out class="tip" title="Tip: Pin a policy version" >}} To pin a specific policy version, use `policyUID` instead of `policyName`. Find the UID in the NGINX Instance Manager console or API. A pinned UID always resolves to the same compiled bundle. Turn off polling to avoid unnecessary network requests. {{< /call-out >}}

### Apply a route-level override (optional)

To apply a different policy to a specific route, such as a data-guard policy, create a route-level `WAFPolicy`:

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

If two `WAFPolicy` resources compile to the same logical policy name, NGINX Gateway Fabric rejects the configuration. See [Duplicate policy name error]({{< ref "/ngf/waf-integration/troubleshooting.md#duplicate-policy-name-error" >}}).

---

## F5 NGINX One Console

Use this option when you manage F5 WAF policies through F5 NGINX One Console. For details on creating and compiling policies in NGINX One Console, see [Manage policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}).

**Workflow:**

1. Author and compile a policy in the NGINX One Console or API.
2. If no compiled bundle exists yet, NGINX Gateway Fabric triggers compilation through the NGINX One Console API. This happens the first time NGINX Gateway Fabric reconciles the `WAFPolicy` resource. NGINX Gateway Fabric waits for compilation to finish before continuing.
3. Create a Secret with your NGINX One Console API token.
4. Create a `WAFPolicy` referencing the compiled policy.

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
      url: https://<tenant>.console.ves.volterra.io
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
        url: https://<tenant>.console.ves.volterra.io
        namespace: default
        profileObjectID: "lp_8s8uZxLpThWwEGF7LTn_rA"
      auth:
        secretRef:
          name: n1c-credentials
EOF
```

Replace `<tenant>` with your NGINX One Console tenant hostname. The `namespace` field refers to the NGINX One Console namespace where the policy resides.

{{< call-out class="tip" title="Tip: Pin a policy version" >}} To pin a specific policy version, set `policyVersionID`. A pinned version always resolves to the same compiled bundle. Turn off polling to avoid unnecessary network requests. If you use only `policyName` or `policyObjectID` without a version pin, NGINX Gateway Fabric fetches the latest compiled bundle on each reconciliation or poll cycle. {{< /call-out >}}

---

## HTTP/HTTPS server

Use this option when you compile F5 WAF policies using the F5 WAF compiler CLI or a CI/CD pipeline and host the resulting bundle on an HTTP/HTTPS server. For details on using the compiler, see [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}).

For a complete walkthrough including policy compilation and a bundle server deployment, see [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started-http.md" >}}).

In production environments, host compiled bundles on an HTTPS server with authentication. See [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for details on adding credentials, custom CA certificates, and checksum verification to your `policySource`.

---

## Policy Lifecycle Management (PLM)

Use this option when you manage F5 WAF policies as Kubernetes resources with Policy Lifecycle Management (PLM). With PLM, you define your security posture as `APPolicy` and `APLogConf` custom resources instead of `policySource`/`logSource`. The PLM controller compiles these resources automatically and stores the resulting bundles in in-cluster storage. NGINX Gateway Fabric fetches those bundles and deploys them to the data plane. Because PLM is event-driven, you don't need a per-`WAFPolicy` credentials Secret or polling configuration.

For a comparison of PLM with the other source types, see [PLM]({{< ref "/ngf/waf-integration/overview.md#plm-policy-lifecycle-management" >}}). For a complete walkthrough, including PLM storage setup, defining `APPolicy`/`APLogConf` resources, and applying a `WAFPolicy`, see [Get started with F5 WAF for NGINX using PLM]({{< ref "/ngf/waf-integration/get-started-plm.md" >}}).

---

## Policy deployment visibility

NGINX Instance Manager and NGINX One Console don't show which F5 WAF policies are deployed to NGINX Gateway Fabric. Neither console shows which compiled bundle version NGINX Gateway Fabric has fetched.

This is intentional. NGINX Gateway Fabric pulls compiled bundles from the management plane and deploys them directly in Kubernetes using native manifests, not through NGINX Instance Manager or NGINX One Console. This design lets you create and compile policies, then make them available to NGINX Gateway Fabric through the API, without a console-managed deployment step.

F5 plans to add policy association visibility for NGINX Instance Manager and NGINX One Console in a future release. In the meantime, use `kubectl describe wafpolicy <name>` to check deployment status.

---

## Security event monitoring

### NGINX Instance Manager

#### Connect NGINX Gateway Fabric to F5 NGINX Instance Manager

Configure NGINX Gateway Fabric to connect to NGINX Instance Manager before continuing. Follow [Connect NGINX Gateway Fabric to NGINX Instance Manager]({{< ref "/nim/connect-kubernetes/connect-ngf.md" >}}).

#### Export security logs to F5 NGINX Instance Manager

The Security Monitoring dashboard in NGINX Instance Manager doesn't show which F5 WAF policies are deployed to NGINX Gateway Fabric data planes. You can still export F5 WAF security events to NGINX Instance Manager. Exporting these events gives your security operations team visibility into blocked attacks, violations, and traffic patterns directly in the dashboard.

{{< call-out class="important" title="Important: Version requirement" >}}
This integration requires NGINX Instance Manager 2.23 or later.
{{< /call-out >}}

To export these events, configure a `securityLogs` entry on the `WAFPolicy` resource. The entry sends events to the syslog listener that NGINX Agent runs inside the NGINX pod. NGINX Agent's built-in OpenTelemetry collector transforms the events and exports them to NGINX Instance Manager.

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
  type: NIM
  policySource:
    nimSource:
      url: https://nim.example.com
      policyName: "ngfExample"
    auth:
      secretRef:
        name: nim-credentials
  securityLogs:
  - destination:
      type: syslog
      syslog:
        server: localhost:1514
    logSource:
      nimSource:
        url: https://nim.example.com
        profileName: "secops_dashboard_ngf_otel"
      auth:
        secretRef:
          name: nim-credentials
EOF
```

The `localhost:1514` syslog destination points to NGINX Agent's OpenTelemetry collector, which runs as a sidecar in the NGINX pod. NGINX Agent exports the security events to NGINX Instance Manager over gRPC on port `4317`, authenticated using the same NGINX Plus JWT referenced in the NGINX Plus Secret from [Connect NGINX Gateway Fabric to NGINX Instance Manager]({{< ref "/nim/connect-kubernetes/connect-ngf.md" >}}). NGINX Gateway Fabric handles this authentication internally. No separate credential is required for log export.

{{< call-out class="note" title="Note: Network requirements" >}}
- Port `1514` (local syslog): NGINX Agent listens on this port inside the NGINX pod. This traffic doesn't leave the pod.
- Port `4317` (gRPC): NGINX Agent uses this port to export events to NGINX Instance Manager. Make sure this port is reachable from your cluster.
{{< /call-out >}}

{{< call-out class="tip" title="Tip: Testing with self-signed certificates" >}}
To test with self-signed certificates, add `insecureSkipVerify: true` to `policySource` and `logSource`. Don't use this setting in production. See [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}) for adding CA certificates and credentials.
{{< /call-out >}}

### NGINX One Console

#### Connect NGINX Gateway Fabric to F5 NGINX One Console

Configure NGINX Gateway Fabric to connect to NGINX One Console before continuing. Follow [Connect NGINX Gateway Fabric with Helm]({{< ref "/nginx-one-console/k8s/add-ngf-helm.md" >}}) or [Connect NGINX Gateway Fabric with Manifests]({{< ref "/nginx-one-console/k8s/add-ngf-manifests.md" >}}).

#### Export security logs to F5 NGINX One Console

NGINX One Console doesn't show which F5 WAF policies are deployed to NGINX Gateway Fabric data planes. You can still export F5 WAF security events to the NGINX One Console security dashboard. Your security operations team can then view blocked attacks, violations, and traffic patterns directly in the console.

To export these events, configure a `securityLogs` entry that sends events to NGINX Agent's built-in OpenTelemetry collector, which forwards them to NGINX One Console. Use a log profile compiled for the NGINX One Console security dashboard:

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
      url: https://<tenant>.console.ves.volterra.io
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
        url: https://<tenant>.console.ves.volterra.io
        namespace: default
        profileName: "secops_dashboard"
      auth:
        secretRef:
          name: n1c-credentials
EOF
```

The `localhost:1514` syslog destination points to NGINX Agent's OpenTelemetry collector, which runs as a sidecar in the NGINX pod. NGINX Agent forwards the security events to NGINX One Console, where they appear in the security monitoring dashboard.

{{< call-out class="note" title="Note: Log profile must exist in NGINX One Console" >}} The `profileName: "secops_dashboard"` log profile must exist in your NGINX One Console namespace. Events don't appear correctly in the NGINX One Console security dashboard without this profile. {{< /call-out >}}

---

## See also

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}})
- [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started-http.md" >}})
- [Get started with F5 WAF for NGINX using PLM]({{< ref "/ngf/waf-integration/get-started-plm.md" >}})
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}})
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}})
- [Technical specifications]({{< ref "/ngf/overview/technical-specifications.md" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})