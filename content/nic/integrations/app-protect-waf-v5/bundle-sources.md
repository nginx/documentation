---
title: Fetch WAF bundles from remote sources
weight: 250
toc: true
f5-content-type: how-to
f5-product: INGRESS
f5-description: Configure NGINX Ingress Controller to fetch pre-compiled WAF bundles from NGINX One Console, NGINX Instance Manager, or an HTTPS server, and verify that WAF protection is active.
---

NGINX Ingress Controller can fetch pre-compiled WAF bundles directly from a remote source instead of requiring bundles to be manually placed on disk. This eliminates the need to compile, download, and `kubectl cp` bundles to each pod.

Three source types are supported:

{{% table %}}

| Source type | Description | Authentication |
| ---| ---| --- |
| **NGINX One Console** | A policy compiled and managed through [NGINX One Console]({{< ref "/nginx-one-console/" >}}) | Bearer token via `nginx.com/waf-bundle` Secret |
| **NGINX Instance Manager** | A policy compiled and managed through [NGINX Instance Manager]({{< ref "/nim/" >}}) | Basic auth or bearer token via `nginx.com/waf-bundle` Secret |
| **HTTPS** | A compiled `.tgz` bundle hosted on any HTTPS server | Client mTLS, or `insecureSkipVerify` |

{{% /table %}}

{{< call-out class="note" >}} Bundle sources require F5 WAF for NGINX v5 and work with VirtualServer custom resources only. The deprecated `securityLog` (singular) field does not support bundle sources — use `securityLogs` instead. {{< /call-out >}}

{{<tabs name="bundle-source-setup">}}

{{%tab name="NGINX One Console"%}}

## Before you begin

- A working NGINX Ingress Controller deployment with [F5 WAF for NGINX v5]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}).
- An [NGINX One Console]({{< ref "/nginx-one-console/" >}}) account with a published WAF policy. See [Manage policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}).
- A VirtualServer resource to attach the WAF policy to.

{{< call-out class="important" >}} NGINX Ingress Controller does not trigger compilation. Compilation happens when a policy is published in NGINX One Console. Ensure the policy has been published and a compiled bundle is available before continuing. {{< /call-out >}}

---

## Create a credentials Secret

NGINX One Console uses APIToken authentication. Create a Secret of type `nginx.com/waf-bundle` with a bearer token:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: n1c-credentials
type: nginx.com/waf-bundle
data:
  token: <BASE64_ENCODED_TOKEN>
EOF
```

---

## Create a WAF Policy

Create a Policy resource using `apBundleSource` with `type: N1C`:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
spec:
  waf:
    enable: true
    apBundleSource:
      type: N1C
      url: "https://<tenant>.console.ves.volterra.io"
      policyName: "my-blocking-policy"
      secret: "n1c-credentials"
      enablePolling: true
      pollInterval: "5m"
EOF
```

Replace `<tenant>` with your NGINX One Console tenant hostname and `policyName` with the name of your published policy.

{{< call-out class="caution" >}} To skip TLS verification for testing, add `insecureSkipVerify: true` to the bundle source. Do not use this in production. {{< /call-out >}}

---

## Apply the policy to a VirtualServer

Reference the WAF Policy in your VirtualServer:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: webapp
spec:
  host: webapp.example.com
  policies:
  - name: waf-policy
  upstreams:
  - name: webapp
    service: webapp-svc
    port: 80
  routes:
  - path: /
    action:
      pass: webapp
EOF
```

---

## Verify the bundle was fetched

1. Check the Policy events for a successful fetch:

   ```shell
   kubectl describe policy waf-policy
   ```

   Look for a `Normal` event confirming the bundle was fetched. If you see a `Warning` event, check the message for the cause — common issues include an incorrect `policyName`, an invalid token, or a policy that has not been published yet.

1. Send a legitimate request to confirm traffic flows normally:

   ```shell
   curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
     http://webapp.example.com:$IC_HTTP_PORT/
   ```

1. Send a malicious request to confirm WAF is blocking:

   ```shell
   curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
     "http://webapp.example.com:$IC_HTTP_PORT/<script>"
   ```

   Expected response:

   ```text
   <html><head><title>Request Rejected</title></head><body>
   ```

If the VirtualServer returns HTTP 500, the bundle has not been fetched yet. Check the Policy events and status for errors.

---

## Confirm polling is working

When `enablePolling: true` is set, NGINX Ingress Controller periodically checks whether a new bundle is available. For NGINX One Console, it uses a compile status hash — the full bundle is only downloaded when a new compilation is detected.

Check that polls are running without error:

```shell
kubectl describe policy waf-policy
```

Look for recent `Normal` events that confirm a poll completed. A `Warning` event means the last poll failed, but the existing bundle remains active — WAF protection is not interrupted.

To adjust the poll interval on an existing Policy:

```shell
kubectl patch policy waf-policy --type merge -p '{
  "spec": {"waf": {"apBundleSource": {"pollInterval": "10m"}}}
}'
```

`pollInterval` must be at least `1m`. It defaults to `5m` if not set.

---

## Add a security log bundle source (optional)

Security log profile bundles can also be fetched from NGINX One Console using `apLogBundleSource` in `securityLogs[]`:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
spec:
  waf:
    enable: true
    apBundleSource:
      type: N1C
      url: "https://<tenant>.console.ves.volterra.io"
      policyName: "my-blocking-policy"
      secret: "n1c-credentials"
      enablePolling: true
      pollInterval: "5m"
    securityLogs:
    - enable: true
      apLogBundleSource:
        type: N1C
        url: "https://<tenant>.console.ves.volterra.io"
        policyName: "secops_dashboard"
        secret: "n1c-credentials"
        enablePolling: true
        pollInterval: "5m"
      logDest: "syslog:server=syslog-svc.default:514"
EOF
```

Verify log events are arriving at your syslog destination:

```shell
kubectl exec -it <SYSLOG_POD> -- cat /var/log/messages
```

{{%/tab%}}

{{%tab name="NGINX Instance Manager"%}}

## Before you begin

- A working NGINX Ingress Controller deployment with [F5 WAF for NGINX v5]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}).
- A working [NGINX Instance Manager]({{< ref "/nim/" >}}) instance with a compiled policy bundle. See [Create a security policy bundle]({{< ref "/nim/waf-integration/policies-and-logs/bundles/create-bundle.md" >}}).
- A VirtualServer resource to attach the WAF policy to.

{{< call-out class="important" >}} NGINX Ingress Controller does not trigger compilation. Compile the policy using the NGINX Instance Manager UI or `POST /api/platform/v1/security/policies/bundles` and verify compilation succeeded before continuing. {{< /call-out >}}

---

## Create a credentials Secret

NGINX Instance Manager requires a Secret of type `nginx.com/waf-bundle`. Create it with either basic auth credentials or a bearer token:

{{<tabs name="nim-secret">}}

{{%tab name="Basic auth"%}}

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: nim-credentials
type: nginx.com/waf-bundle
stringData:
  username: "<NIM_USERNAME>"
  password: "<NIM_PASSWORD>"
EOF
```

{{% /tab %}}

{{%tab name="Bearer token"%}}

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: nim-credentials
type: nginx.com/waf-bundle
data:
  token: <BASE64_ENCODED_TOKEN>
EOF
```

{{% /tab %}}

{{% /tabs %}}

---

## Create a WAF Policy

Create a Policy resource using `apBundleSource` with `type: NIM`:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
spec:
  waf:
    enable: true
    apBundleSource:
      type: NIM
      url: "https://nim.example.com"
      policyName: "my-blocking-policy"
      secret: "nim-credentials"
      enablePolling: true
      pollInterval: "5m"
EOF
```

Replace `url` with your NGINX Instance Manager base URL and `policyName` with the name of your compiled policy.

{{< call-out class="caution" >}} To skip TLS verification for testing, add `insecureSkipVerify: true` to the bundle source. Do not use this in production. {{< /call-out >}}

---

## Apply the policy to a VirtualServer

Reference the WAF Policy in your VirtualServer:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: webapp
spec:
  host: webapp.example.com
  policies:
  - name: waf-policy
  upstreams:
  - name: webapp
    service: webapp-svc
    port: 80
  routes:
  - path: /
    action:
      pass: webapp
EOF
```

---

## Verify the bundle was fetched

1. Check the Policy events for a successful fetch:

   ```shell
   kubectl describe policy waf-policy
   ```

   Look for a `Normal` event confirming the bundle was fetched. If you see a `Warning` event, check the message for the cause — common issues include an incorrect `policyName`, authentication failure, or a bundle that has not been compiled yet.

1. Send a legitimate request to confirm traffic flows normally:

   ```shell
   curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
     http://webapp.example.com:$IC_HTTP_PORT/
   ```

1. Send a malicious request to confirm WAF is blocking:

   ```shell
   curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
     "http://webapp.example.com:$IC_HTTP_PORT/<script>"
   ```

   Expected response:

   ```text
   <html><head><title>Request Rejected</title></head><body>
   ```

If the VirtualServer returns HTTP 500, the bundle has not been fetched yet. Check the Policy events and status for errors.

---

## Confirm polling is working

When `enablePolling: true` is set, NGINX Ingress Controller periodically checks whether a new bundle is available. For NGINX Instance Manager, it uses a metadata hash comparison — the full bundle is only downloaded when the hash has changed.

Check that polls are running without error:

```shell
kubectl describe policy waf-policy
```

Look for recent `Normal` events that confirm a poll completed. A `Warning` event means the last poll failed, but the existing bundle remains active — WAF protection is not interrupted.

To adjust the poll interval on an existing Policy:

```shell
kubectl patch policy waf-policy --type merge -p '{
  "spec": {"waf": {"apBundleSource": {"pollInterval": "10m"}}}
}'
```

`pollInterval` must be at least `1m`. It defaults to `5m` if not set.

---

## Add a security log bundle source (optional)

Security log profile bundles can also be fetched from NGINX Instance Manager using `apLogBundleSource` in `securityLogs[]`:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
spec:
  waf:
    enable: true
    apBundleSource:
      type: NIM
      url: "https://nim.example.com"
      policyName: "my-blocking-policy"
      secret: "nim-credentials"
      enablePolling: true
      pollInterval: "5m"
    securityLogs:
    - enable: true
      apLogBundleSource:
        type: NIM
        url: "https://nim.example.com"
        policyName: "secops_dashboard"
        secret: "nim-credentials"
        enablePolling: true
        pollInterval: "5m"
      logDest: "syslog:server=syslog-svc.default:514"
EOF
```

Verify log events are arriving at your syslog destination:

```shell
kubectl exec -it <SYSLOG_POD> -- cat /var/log/messages
```

{{%/tab%}}

{{%tab name="HTTPS"%}}

## Before you begin

- A working NGINX Ingress Controller deployment with [F5 WAF for NGINX v5]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}).
- A compiled `.tgz` policy bundle hosted on an HTTPS server. To compile a policy bundle, see [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}).
- A VirtualServer resource to attach the WAF policy to.

---

## Create a TLS Secret (optional)

Skip this step if your HTTPS server uses a publicly trusted certificate and no authentication.

If your server uses a self-signed or internal CA certificate, create an Opaque Secret containing the CA cert:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: bundle-ca-cert
type: Opaque
data:
  ca.crt: <BASE64_ENCODED_CA_CERT>
EOF
```

---

## Create a WAF Policy

Create a Policy resource using `apBundleSource` with `type: HTTPS`:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
spec:
  waf:
    enable: true
    apBundleSource:
      type: HTTPS
      url: "https://bundles.example.com/waf/my-policy.tgz"
      trustedCertSecret: "bundle-ca-cert"
      enablePolling: false
EOF
```

Replace `url` with the full URL of your compiled bundle. Remove `trustedCertSecret` if your server uses a publicly trusted certificate.

{{< call-out class="caution" >}} To skip TLS verification for testing, add `insecureSkipVerify: true` to the bundle source. Do not use this in production. {{< /call-out >}}

---

## Apply the policy to a VirtualServer

Reference the WAF Policy in your VirtualServer:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: webapp
spec:
  host: webapp.example.com
  policies:
  - name: waf-policy
  upstreams:
  - name: webapp
    service: webapp-svc
    port: 80
  routes:
  - path: /
    action:
      pass: webapp
EOF
```

---

## Verify the bundle was fetched

1. Check the Policy events for a successful fetch:

   ```shell
   kubectl describe policy waf-policy
   ```

   Look for a `Normal` event confirming the bundle was fetched. If you see a `Warning` event, check the message for the cause — common issues include an unreachable URL or a TLS certificate error.

1. Send a legitimate request to confirm traffic flows normally:

   ```shell
   curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
     http://webapp.example.com:$IC_HTTP_PORT/
   ```

1. Send a malicious request to confirm WAF is blocking:

   ```shell
   curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
     "http://webapp.example.com:$IC_HTTP_PORT/<script>"
   ```

   Expected response:

   ```text
   <html><head><title>Request Rejected</title></head><body>
   ```

If the VirtualServer returns HTTP 500, the bundle has not been fetched yet. Check the Policy events and status for errors.

---

## Enable polling (optional)

Polling lets NGINX Ingress Controller detect and deploy updated bundles without modifying the Policy resource. For HTTPS sources, NGINX Ingress Controller uses `ETag` and `If-Modified-Since` headers — a `304 Not Modified` response skips the download entirely.

Enable polling on the existing Policy:

```shell
kubectl patch policy waf-policy --type merge -p '{
  "spec": {"waf": {"apBundleSource": {"enablePolling": true, "pollInterval": "10m"}}}
}'
```

`pollInterval` must be at least `1m`. It defaults to `5m` if not set.

---

## Verify bundle integrity (optional)

Set `verifyChecksum: true` to have NGINX Ingress Controller fetch a companion `<url>.sha256` file and compare the SHA-256 digest against the downloaded bundle. The bundle is rejected if the digest does not match.

1. Generate the checksum file alongside your bundle:

   ```shell
   sha256sum my-policy.tgz > my-policy.tgz.sha256
   ```

1. Upload both files to the same location on your HTTPS server.

1. Update the Policy to enable verification:

   ```shell
   kubectl patch policy waf-policy --type merge -p '{
     "spec": {"waf": {"apBundleSource": {"verifyChecksum": true}}}
   }'
   ```

NGINX Ingress Controller appends `.sha256` to the bundle URL automatically.

{{< call-out class="note" >}} `verifyChecksum` is only supported for HTTPS sources. NGINX Instance Manager and NGINX One Console sources use native integrity checks. {{< /call-out >}}

---

## Add a security log bundle source (optional)

Security log profile bundles can also be fetched from a remote source using `apLogBundleSource` in `securityLogs[]`:

```yaml
kubectl apply -f - <<EOF
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
spec:
  waf:
    enable: true
    apBundleSource:
      type: HTTPS
      url: "https://bundles.example.com/waf/my-policy.tgz"
      enablePolling: true
      pollInterval: "5m"
    securityLogs:
    - enable: true
      apLogBundleSource:
        type: HTTPS
        url: "https://bundles.example.com/waf/my-log-profile.tgz"
        enablePolling: true
        pollInterval: "5m"
      logDest: "syslog:server=syslog-svc.default:514"
EOF
```

Verify log events are arriving at your syslog destination:

```shell
kubectl exec -it <SYSLOG_POD> -- cat /var/log/messages
```

{{%/tab%}}

{{</tabs>}}

## Failure handling and recovery

### Initial fetch failure

When a bundle cannot be fetched on the first attempt:

- A **Warning** event is emitted on the Policy resource.
- The Policy status is updated with the error details.
- Any VirtualServer referencing the Policy returns **HTTP 500** until the bundle arrives.

Check the events for details:

```shell
kubectl describe policy waf-policy
```

### Recovery

Update the Policy with a corrected URL, credentials, or `policyName`. NGINX Ingress Controller detects the change and retries immediately. Once the bundle is fetched, WAF protection becomes active and the VirtualServer stops returning 500.

### Stale bundles

If polling is enabled and a poll cycle fails after a previous successful fetch, the existing bundle remains active. WAF protection continues without interruption. A `Warning` event is emitted, and NGINX Ingress Controller retries on the next poll cycle.

---

## See also

- [Policy resource — WAF field reference]({{< ref "/nic/configuration/policy-resource.md#waf" >}})
- [Configure F5 WAF for NGINX with NGINX Ingress Controller]({{< ref "/nic/integrations/app-protect-waf-v5/configuration.md" >}})
- [Compile F5 WAF for NGINX policies using NGINX Instance Manager]({{< ref "/nic/integrations/app-protect-waf-v5/compile-waf-policies.md" >}})
- [Troubleshoot F5 WAF for NGINX]({{< ref "/nic/integrations/app-protect-waf-v5/troubleshoot-app-protect-waf.md" >}})
- [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}})
