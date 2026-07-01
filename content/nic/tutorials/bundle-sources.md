---
title: Connect F5 WAF for NGINX to NGINX One Console, NGINX Instance Manager, or HTTPS bundle sources
toc: true
weight: 1800
f5-content-type: how-to
f5-product: INGRESS
---

This document explains how to configure NGINX Ingress Controller to fetch pre-compiled F5 WAF for NGINX policy bundles from a remote source, instead of manually placing bundles on disk.

You can fetch bundles from:

- **NGINX One Console** — for policies compiled and managed through NGINX One Console
- **NGINX Instance Manager** — for policies compiled and managed through NGINX Instance Manager
- **HTTPS** — for compiled `.tgz` bundles hosted on any HTTPS server

{{< call-out class="note" >}} Bundle sources require F5 WAF for NGINX v5 and work with both VirtualServer and Ingress resources. {{< /call-out >}}

Complete NGINX Ingress Controller with F5 WAF for NGINX bundle source examples are available on GitHub: [VirtualServer examples](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/waf-management-plane). Equivalent examples are also available for Ingress resources.

{{<tabs name="bundle-source-setup">}}

{{%tab name="NGINX One Console"%}}

## Before you begin

- NGINX Ingress Controller deployed with [F5 WAF for NGINX v5]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}). You can also [install with Helm]({{< ref "/nic/install/waf-helm.md" >}}).
- An [NGINX One Console]({{< ref "/nginx-one-console/" >}}) account with a published WAF policy. See [Manage policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}).
- A VirtualServer or Ingress resource to attach the WAF policy to.

{{< call-out class="important" >}} NGINX Ingress Controller does not trigger compilation. Compilation happens when a policy is published in NGINX One Console. Ensure the policy has been published and a compiled bundle is available before continuing. {{< /call-out >}}

## Create a credentials Secret

Create a Secret of type `nginx.com/waf-bundle` in the same namespace as the Policy. The Secret must contain a `token` key with your NGINX One Console API token:

```shell
kubectl create secret generic n1c-credentials \
  --type=nginx.com/waf-bundle \
  --from-literal=token=<YOUR_API_TOKEN>
```

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
      policyNamespace: "default"
      secret: "n1c-credentials"
      enablePolling: true
      pollInterval: "5m"
EOF
```

Replace `<tenant>` with your NGINX One Console tenant hostname, `policyName` with the name of your published policy, and `policyNamespace` with the NGINX One Console namespace where the policy resides.

{{< call-out class="note" >}} The field name is `policyName` for both `apBundleSource` and `apLogBundleSource`. In `apBundleSource`, set it to the published WAF policy name. In `apLogBundleSource`, set it to the log profile name (for example, `secops_dashboard`). {{< /call-out >}}

{{< call-out class="caution" >}} To skip TLS verification for testing, add `insecureSkipVerify: true` to the bundle source. Do not use this in production. {{< /call-out >}}

## Apply the policy to a VirtualServer or Ingress

Reference the WAF Policy in your VirtualServer or Ingress resource.

{{<tabs name="n1c-policy-attachment">}}

{{%tab name="VirtualServer"%}}

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

{{%/tab%}}

{{%tab name="Ingress"%}}

```yaml
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp
  annotations:
    nginx.org/policies: "waf-policy"
spec:
  ingressClassName: nginx
  rules:
  - host: webapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-svc
            port:
              number: 80
EOF
```

{{%/tab%}}

{{</tabs>}}

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

If the VirtualServer or Ingress returns HTTP 500, the bundle has not been fetched yet. Check the Policy events and status for errors.

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
      policyNamespace: "default"
      secret: "n1c-credentials"
      enablePolling: true
      pollInterval: "5m"
    securityLogs:
    - enable: true
      apLogBundleSource:
        type: N1C
        url: "https://<tenant>.console.ves.volterra.io"
        policyName: "secops_dashboard"
        policyNamespace: "default"
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

- NGINX Ingress Controller deployed with [F5 WAF for NGINX v5]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}). You can also [install with Helm]({{< ref "/nic/install/waf-helm.md" >}}).
- A working [NGINX Instance Manager]({{< ref "/nim/" >}}) instance with a compiled policy bundle. See [Create a security policy bundle]({{< ref "/nim/waf-integration/policies-and-logs/bundles/create-bundle.md" >}}).
- A VirtualServer or Ingress resource to attach the WAF policy to.

{{< call-out class="important" >}} NGINX Ingress Controller does not trigger compilation. Compile the policy using the NGINX Instance Manager UI or `POST /api/platform/v1/security/policies/bundles` and verify compilation succeeded before continuing. {{< /call-out >}}

## Create a credentials Secret

Create a Secret of type `nginx.com/waf-bundle` in the same namespace as the Policy. Use a `token` key for bearer auth, or `username` and `password` keys for basic auth:

{{<tabs name="nim-secret">}}

{{%tab name="Bearer token"%}}

```shell
kubectl create secret generic nim-credentials \
  --type=nginx.com/waf-bundle \
  --from-literal=token=<YOUR_TOKEN>
```

{{% /tab %}}

{{%tab name="Basic auth"%}}

```shell
kubectl create secret generic nim-credentials \
  --type=nginx.com/waf-bundle \
  --from-literal=username=<YOUR_USERNAME> \
  --from-literal=password=<YOUR_PASSWORD>
```

{{% /tab %}}

{{% /tabs %}}

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

## Apply the policy to a VirtualServer or Ingress

Reference the WAF Policy in your VirtualServer or Ingress resource.

{{<tabs name="nim-policy-attachment">}}

{{%tab name="VirtualServer"%}}

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

{{%/tab%}}

{{%tab name="Ingress"%}}

```yaml
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp
  annotations:
    nginx.org/policies: "waf-policy"
spec:
  ingressClassName: nginx
  rules:
  - host: webapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-svc
            port:
              number: 80
EOF
```

{{%/tab%}}

{{</tabs>}}

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

If the VirtualServer or Ingress returns HTTP 500, the bundle has not been fetched yet. Check the Policy events and status for errors.

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

- NGINX Ingress Controller deployed with [F5 WAF for NGINX v5]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}). You can also [install with Helm]({{< ref "/nic/install/waf-helm.md" >}}).
- A compiled `.tgz` policy bundle hosted on an HTTPS server. To compile a policy bundle, see [Compile F5 WAF for NGINX policies]({{< ref "/nic/integrations/app-protect-waf-v5/compile-waf-policies.md" >}}).
- A VirtualServer or Ingress resource to attach the WAF policy to.

## Host compiled bundles on an HTTPS server

The `url` field must point directly to the compiled `.tgz` bundle file — for example, `https://bundles.example.com/waf/my-policy.tgz`. NGINX Ingress Controller downloads the file at this URL and does not follow redirects (3xx responses are treated as errors for SSRF protection).

You can host bundles on any HTTPS-capable server:

- **In-cluster bundle server** — Deploy an NGINX-based server inside your cluster that serves compiled bundles over HTTPS. For an example deployment, see the [bundle server files](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/shared-examples/waf-bundle-server) in the NGINX Ingress Controller repository.
- **Object storage** — Use S3, GCS, Azure Blob Storage, or another object store with HTTPS access.
- **Artifact registry** — Serve bundles from a CI/CD artifact repository or container registry with download URLs.
- **Static file server** — Any HTTPS server (NGINX, Apache, Caddy) that can serve `.tgz` files.

After compiling your policy with the [F5 WAF compiler]({{< ref "/waf/configure/compiler.md" >}}), upload the `.tgz` file to your server and note the full URL.

## Create a TLS Secret (optional)

Skip this step if your HTTPS server uses a publicly trusted certificate.

- **Custom CA certificate** — If your server uses a self-signed or internal CA, create a Secret of type `nginx.org/ca` with a `ca.crt` key, and reference it in `trustedCertSecret`:

  ```shell
  kubectl create secret generic bundle-ca-cert \
    --type=nginx.org/ca \
    --from-file=ca.crt=</path/to/ca.crt>
  ```

- **Client mTLS** — Create a `kubernetes.io/tls` Secret with your client certificate and key, and reference it in `secret`:

  ```shell
  kubectl create secret tls bundle-client-cert \
    --cert=</path/to/tls.crt> \
    --key=</path/to/tls.key>
  ```

## Create a WAF Policy

Create a Policy resource using `apBundleSource` with `type: HTTPS`. The `url` must be the full path to the `.tgz` bundle file:

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

## Apply the policy to a VirtualServer or Ingress

Reference the WAF Policy in your VirtualServer or Ingress resource.

{{<tabs name="https-policy-attachment">}}

{{%tab name="VirtualServer"%}}

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

{{%/tab%}}

{{%tab name="Ingress"%}}

```yaml
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp
  annotations:
    nginx.org/policies: "waf-policy"
spec:
  ingressClassName: nginx
  rules:
  - host: webapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-svc
            port:
              number: 80
EOF
```

{{%/tab%}}

{{</tabs>}}

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

If the VirtualServer or Ingress returns HTTP 500, the bundle has not been fetched yet. Check the Policy events and status for errors.

## Enable polling (optional)

Polling lets NGINX Ingress Controller detect and deploy updated bundles without modifying the Policy resource. For HTTPS sources, NGINX Ingress Controller uses `ETag` and `If-Modified-Since` headers — a `304 Not Modified` response skips the download entirely.

Enable polling on the existing Policy:

```shell
kubectl patch policy waf-policy --type merge -p '{
  "spec": {"waf": {"apBundleSource": {"enablePolling": true, "pollInterval": "10m"}}}
}'
```

`pollInterval` must be at least `1m`. It defaults to `5m` if not set.

## Skip unchanged bundles with checksum verification (optional)

Set `verifyChecksum: true` to have NGINX Ingress Controller skip reloading NGINX if the downloaded bundle has the same SHA-256 hash as the previously fetched bundle. This avoids unnecessary NGINX reloads when polling detects a download but the content has not changed.

```shell
kubectl patch policy waf-policy --type merge -p '{
  "spec": {"waf": {"apBundleSource": {"verifyChecksum": true}}}
}'
```

{{< call-out class="note" >}} For NGINX Instance Manager and NGINX One Console sources, change detection uses native metadata hashes rather than downloading the bundle, making `verifyChecksum` less useful for those source types. {{< /call-out >}}

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

## Telemetry data points

When bundle sources are configured, NGINX Ingress Controller reports additional anonymized telemetry attributes for source type usage:

- `WAFBundleSourceTypes` for policy bundles configured through `waf.apBundleSource`
- `WAFLogBundleSourceTypes` for log profile bundles configured through `waf.securityLogs[].apLogBundleSource`

These attributes report source types (for example `HTTPS`, `NIM`, or `N1C`) and not policy content.

## Failure handling and recovery

### Initial fetch failure

When a bundle cannot be fetched on the first attempt:

- A **Warning** event is emitted on the Policy resource.
- The Policy status is updated with the error details.
- Any VirtualServer or Ingress referencing the Policy returns **HTTP 500** until the bundle arrives.

Check the events for details:

```shell
kubectl describe policy waf-policy
```

### Recovery

Update the Policy with a corrected URL, credentials, or `policyName`. NGINX Ingress Controller detects the change and retries immediately. Once the bundle is fetched, WAF protection becomes active and the VirtualServer or Ingress stops returning 500.

### Stale bundles

If polling is enabled and a poll cycle fails after a previous successful fetch, the existing bundle remains active. WAF protection continues without interruption. A `Warning` event is emitted, and NGINX Ingress Controller retries on the next poll cycle.
