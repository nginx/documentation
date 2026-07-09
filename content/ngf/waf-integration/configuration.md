---
title: Configure WAF settings
weight: 400
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-description: Configure security logging, polling, TLS, authentication, cookie seed, bundle integrity, fail-open behavior, and WAF container settings for F5 WAF for NGINX.
---

This page covers operational configuration for F5 WAF for NGINX in NGINX Gateway Fabric: security logging, automatic policy updates, TLS and authentication, bundle integrity verification, cookie seed management, fetch failure handling, and WAF container settings.

---

## Configure security logging

The `securityLogs` field on a `WAFPolicy` supports multiple log destinations. Each entry generates an `app_protect_security_log` directive in the NGINX configuration.

### Log destinations

| Destination type | Description                                         |
|------------------|-----------------------------------------------------|
| `stderr`         | Write to standard error (appears in container logs) |
| `file`           | Write to a file path inside the NGINX container     |
| `syslog`         | Send to a syslog server                             |

### Log source types

Each log entry must specify a log source. For the `HTTP`, `NIM`, and `N1C` policy types, use `logSource` with one of:

| Field            | Description                                      |
|------------------|--------------------------------------------------|
| `defaultProfile` | A built-in WAF log profile name                  |
| `httpSource`     | URL to a compiled log profile bundle             |
| `nimSource`      | NGINX Instance Manager log profile configuration |
| `n1cSource`      | NGINX One Console log profile configuration      |

For the `PLM` policy type, use `logRef` instead of `logSource`:

| Field          | Description                                                 |
|----------------|-------------------------------------------------------------|
| `apLogConfRef` | Reference to an `APLogConf` custom resource compiled by PLM |

**Built-in log profiles:** `log_default`, `log_all`, `log_blocked`, `log_illegal`, `log_grpc_all`, `log_grpc_blocked`, `log_grpc_illegal`

### Example: multiple log destinations

```yaml
securityLogs:
- destination:
    type: stderr
  logSource:
    defaultProfile: log_all
- destination:
    type: file
    file:
      path: "/var/log/app_protect/security.log"
  logSource:
    httpSource:
      url: https://bundles.example.com/waf/custom-log-profile.tgz
    auth:
      secretRef:
        name: bundle-credentials
    validation:
      verifyChecksum: true
- destination:
    type: syslog
    syslog:
      server: syslog-svc.default.svc.cluster.local:514
  logSource:
    defaultProfile: log_blocked
```

---

## Configure automatic policy updates (polling)

Polling enables NGINX Gateway Fabric to detect and deploy updated policy bundles without modifying the `WAFPolicy` resource. This is useful when the same URL or policy name always resolves to the latest compiled bundle — for example, in a CI/CD workflow that overwrites the bundle file in place.

{{< call-out "note" >}} Polling applies only to the `HTTP`, `NIM`, and `N1C` policy types. The `PLM` type is event-driven: NGINX Gateway Fabric watches the referenced `APPolicy` and `APLogConf` resources and re-fetches automatically when their compiled bundles change, so no polling configuration is needed. {{< /call-out >}}

Enable polling on a `policySource` or `logSource`:

```yaml
policySource:
  nimSource:
    url: https://nim.example.com
    policyName: ngfBlocking
  auth:
    secretRef:
      name: nim-credentials
  polling:
    enabled: true
    interval: 10m   # optional; defaults to 5m
```

**How polling works by source type:**

- **NGINX Instance Manager and NGINX One Console**: NGINX Gateway Fabric first fetches only the bundle checksum or metadata. The full bundle is downloaded only if the checksum has changed, avoiding unnecessary traffic.
- **HTTP**: NGINX Gateway Fabric sends a conditional GET using the stored `ETag` or `Last-Modified` header from the previous fetch. A `304 Not Modified` response skips the download entirely.

**When not to enable polling:** If you pin a specific version — `policyUID` for NGINX Instance Manager, `policyVersionID` for NGINX One Console, or a version-specific URL for HTTP — the source always returns the same bundle. Every poll will detect "unchanged" and trigger no action. In that case, disable polling to avoid unnecessary network requests.

**On poll failure:** If a poll attempt fails, the existing deployed bundle remains active. WAF protection is not interrupted. The error is recorded in the `WAFPolicy` status with reason `StaleBundleWarning`.

---

## Configure PLM storage access

When you use the `PLM` policy type, NGINX Gateway Fabric fetches compiled bundles from PLM's in-cluster storage. Access to that storage is configured once, cluster-wide, at install time — it is not set per `WAFPolicy`. This configuration applies to all `WAFPolicy` resources that use `type: PLM`.

{{< call-out "note" >}} This section covers only the NGINX Gateway Fabric side of PLM configuration. Installing the PLM system and authoring `APPolicy`/`APLogConf` resources are covered in the [F5 WAF PLM documentation]({{< ref "/waf/" >}}). <!-- TODO: confirm PLM docs link --> {{< /call-out >}}

### Helm values

Set the PLM storage values under `nginxGateway.plmStorage`:

```yaml
# values.yaml
nginxGateway:
  plmStorage:
    url: "https://plm-storage-service.plm-system.svc.cluster.local"
    credentialsSecretName: "plm-storage-credentials"  # contains the seaweedfs_admin_secret field
    tls:
      caSecretName: "plm-ca-secret"             # Secret with ca.crt for server verification
      clientSSLSecretName: "plm-client-secret"  # Secret with tls.crt/tls.key for mutual TLS
      insecureSkipVerify: false                 # use only for testing
```

The equivalent control plane CLI flags for manifest installs are:

| Flag                               | Description                                                            | Required when PLM is used |
|------------------------------------|------------------------------------------------------------------------|---------------------------|
| `--plm-storage-url`                | PLM storage service URL (HTTP or HTTPS)                                | Yes                       |
| `--plm-storage-credentials-secret` | Secret containing the S3 secret access key (`seaweedfs_admin_secret`)  | No                        |
| `--plm-storage-ca-secret`          | Secret containing the CA certificate (`ca.crt`)                        | No                        |
| `--plm-storage-client-ssl-secret`  | Secret containing the client certificate and key (`tls.crt`/`tls.key`) | No                        |
| `--plm-storage-skip-verify`        | Skip TLS certificate verification (testing only)                       | No                        |

Secret names may include a namespace prefix (`namespace/name`). If no namespace is given, the NGINX Gateway Fabric control plane namespace is assumed.

### Credentials Secret

The credentials Secret is created automatically by the PLM installation. It contains the S3 secret access key in the `seaweedfs_admin_secret` field; the access key ID is `admin` by default:

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

NGINX Gateway Fabric watches the PLM credentials and TLS Secrets and rebuilds its storage client when they change, so credentials can be rotated without restarting the pod.

{{< call-out "caution" >}} For production, always use HTTPS with TLS verification by providing `caSecretName`. Enable mutual TLS with `clientSSLSecretName` for high-security environments. Never set `insecureSkipVerify: true` (or `--plm-storage-skip-verify=true`) in production. {{< /call-out >}}

---

## Configure the WAF cookie seed

When WAF is enabled, NGINX Gateway Fabric automatically sets the `app_protect_cookie_seed` NGINX directive to a stable value derived from the Gateway's UID. This ensures that WAF session cookies issued by one NGINX replica can be validated by any other replica in the same deployment. Without this, each replica generates its own random seed at startup, which causes cross-replica cookie validation failures.

If you have pre-compiled the cookie seed into your WAF policy bundles using the [compiler global settings]({{< ref "/waf/configure/compiler.md" >}}), disable the automatic cookie seed in the NginxProxy CRD to avoid conflicting with the compiled-in value:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: waf-enabled-proxy
spec:
  waf:
    enable: true
    disableCookieSeed: true
```

{{< call-out "note" >}} Only set `disableCookieSeed: true` if your compiled bundles already contain a cookie seed. If neither the bundle nor NGINX Gateway Fabric provides a seed, each replica generates its own random value, which breaks WAF session cookie validation in multi-replica deployments. {{< /call-out >}}

---

## Configure TLS and authentication

### Custom CA certificate

If your policy server uses a self-signed certificate or an internal CA, provide the CA certificate in a Secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: custom-ca-secret
type: Opaque
data:
  ca.crt: <BASE64_ENCODED_CA_CERT>
```

Reference it on the `policySource`:

```yaml
policySource:
  httpSource:
    url: https://internal-server.example.com/policy.tgz
  tlsSecret:
    name: custom-ca-secret
```

The CA certificate is appended to the system CA pool. This is supported for all source types.

{{< call-out "caution" >}} Do not set `insecureSkipVerify: true` in production environments. This disables TLS certificate verification and should be used only for local testing. {{< /call-out >}}

### Authentication methods

NGINX Gateway Fabric infers the authentication method from the keys present in the Secret referenced by `auth.secretRef`:

| Secret keys             | Authentication method                                                 |
|-------------------------|-----------------------------------------------------------------------|
| `username` + `password` | HTTP Basic Auth                                                       |
| `token`                 | Bearer Token (NGINX Instance Manager) or APIToken (NGINX One Console) |
| (none)                  | No authentication header                                              |

Secrets must be in the same namespace as the `WAFPolicy`.

---

## Configure bundle integrity verification

### HTTP source

Set `validation.verifyChecksum: true` to have NGINX Gateway Fabric fetch a companion `<url>.sha256` file and compare its SHA-256 digest against the downloaded bundle. Any mismatch prevents the bundle from being deployed and sets `Programmed=False` with reason `IntegrityError`.

Generate the companion file:

```shell
sha256sum compiled-policy.tgz > compiled-policy.tgz.sha256
```

Upload both files to the same location. NGINX Gateway Fabric appends `.sha256` to the bundle URL automatically.

### Known-checksum enforcement

For any source type, you can pin an expected SHA-256 checksum to reject bundles that do not match:

```yaml
policySource:
  nimSource:
    url: https://nim.example.com
    policyName: ngfBlocking
  validation:
    expectedChecksum: "abc1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd"
```

The `expectedChecksum` must be a 64-character hexadecimal SHA-256 digest.

{{< call-out "note" >}} `verifyChecksum` and `expectedChecksum` are mutually exclusive. You can use one or the other on the same policy source, but not both. {{< /call-out >}}

### PLM source

For the `PLM` policy type, integrity verification is automatic and requires no configuration. NGINX Gateway Fabric verifies the downloaded bundle against `status.bundle.sha256` from the referenced `APPolicy` or `APLogConf` resource. A mismatch prevents the bundle from being deployed and sets `Programmed=False` with reason `IntegrityError`.

---

## Policy fetch failure handling

When a WAF policy bundle cannot be fetched — for example, due to a network error, authentication failure, or the bundle not yet being compiled — the behaviour of NGINX Gateway Fabric depends on whether this is the **first** fetch or a **subsequent** update.

### First-time fetch failure

When the bundle has never been successfully fetched, you can control whether NGINX Gateway Fabric withholds the configuration push or allows traffic to flow unprotected while waiting for the bundle. This is configured using `waf.bundleFailOpen` on the `NginxProxy` resource:

**Fail-closed (default, `bundleFailOpen: false`):**

NGINX Gateway Fabric withholds the NGINX configuration push entirely until the bundle is available. No configuration changes — including unrelated route additions — are applied to the data plane while any pending bundle exists for the Gateway. The `app_protect_policy_file` directive is not emitted. The WAFPolicy status reflects the withheld push with `Programmed=False`.

This is the safe default: the operator must resolve the bundle fetch failure before traffic is served.

**Fail-open (`bundleFailOpen: true`):**

NGINX Gateway Fabric pushes the NGINX configuration normally, but omits the pending WAFPolicy from the generated config — no `app_protect_policy_file` directive is emitted, so NGINX loads successfully without WAF protection. Traffic flows unprotected until the bundle becomes available, at which point NGINX Gateway Fabric includes the policy in the next configuration push.

The WAFPolicy status continues to show `Programmed=False` while the bundle is pending, so operators are aware that WAF protection is not yet active.

To enable fail-open, set `waf.bundleFailOpen: true` on the `NginxProxy`:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: waf-enabled-proxy
spec:
  waf:
    enable: true
    bundleFailOpen: true
```

{{< call-out "caution" >}} `bundleFailOpen: true` means traffic is served without WAF protection if the initial bundle fetch fails. Use this only when availability is more critical than security posture during startup. Monitor the WAFPolicy status to confirm when the bundle becomes active. {{< /call-out >}}

{{< call-out "note" >}} The first-time fetch rules apply whenever NGINX Gateway Fabric starts without an already-fetched bundle. This includes upgrades, control plane pod restarts, and new Gateway deployments, because policy bundles are not persisted across pod restarts. With the default fail-closed setting, configuration pushes are withheld until all bundles have been re-fetched after each restart. Set `bundleFailOpen: true` if you need traffic to flow immediately after a restart and can accept a brief window without WAF protection. {{< /call-out >}}

In both cases, the WAFPolicy status condition is set to `Programmed=False` with reason `Pending` until the bundle is successfully fetched.

### Subsequent fetch failures

If a bundle fetch fails after a policy has already been successfully deployed — for example, during a polling cycle or after a WAFPolicy update — the **existing deployed bundle remains active**. WAF protection is not interrupted.

The failure is reflected in the WAFPolicy status with `Programmed=True` and reason `StaleBundleWarning`, indicating that the previously fetched bundle is still in use:

```text
- Type:    Programmed
  Status:  True
  Reason:  StaleBundleWarning
  Message: policy bundle fetch failed; using previously fetched bundle: connection timeout
```

NGINX Gateway Fabric retries on the next reconciliation or poll cycle. No manual intervention is required unless the error persists.

---

## Configure WAF containers

When WAF is enabled, NGINX Gateway Fabric deploys two sidecar containers — `waf-enforcer` and `waf-config-mgr` — alongside the main NGINX container.

These settings are configured under `spec.kubernetes.deployment.wafContainers` (or `spec.kubernetes.daemonSet.wafContainers` for DaemonSet mode) in the NginxProxy resource. This follows the same infrastructure configuration pattern described in [Configure infrastructure-related settings]({{< ref "/ngf/how-to/data-plane-configuration.md#configure-infrastructure-related-settings" >}}). For the full list of configurable fields, see the `NginxProxy` spec in the [API reference]({{< ref "/ngf/reference/api.md" >}}).

Each container (`enforcer` and `configManager`) supports the following fields:

- **`image`**: Override the default image repository, tag, and pull policy. If not specified, NGINX Gateway Fabric uses the defaults from the F5 Container registry. For the default images, see [Supported container images]({{< ref "/ngf/overview/technical-specifications.md#supported-container-images" >}}).
- **`resources`**: Set CPU and memory requests and limits.
- **`volumeMounts`**: Add extra volume mounts. NGINX Gateway Fabric automatically configures the shared volumes required for communication between the NGINX, `waf-enforcer`, and `waf-config-mgr` containers. Additional mounts are appended to these defaults.

The following example uses custom images from a private registry and sets resource requirements for both containers:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: waf-enabled-proxy
spec:
  waf:
    enable: true
  kubernetes:
    deployment:
      wafContainers:
        enforcer:
          image:
            repository: registry.example.com/nap/waf-enforcer
            tag: "{{< ngf-waf-release-version >}}"
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: "1"
              memory: 1Gi
        configManager:
          image:
            repository: registry.example.com/nap/waf-config-mgr
            tag: "{{< ngf-waf-release-version >}}"
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
            limits:
              cpu: 500m
              memory: 256Mi
```

When installing with Helm, set the equivalent values under `nginx.wafContainers`:

```yaml
# values.yaml
nginx:
  config:
    waf:
      enable: true
  wafContainers:
    enforcer:
      image:
        repository: registry.example.com/nap/waf-enforcer
        tag: "{{< ngf-waf-release-version >}}"
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
    configManager:
      image:
        repository: registry.example.com/nap/waf-config-mgr
        tag: "{{< ngf-waf-release-version >}}"
      resources:
        requests:
          cpu: 50m
          memory: 64Mi
```

{{< call-out "note" >}} Image pull Secrets for private registries must be configured at install time using the `nginx.imagePullSecret` or `nginx.imagePullSecrets` Helm values (or the `--nginx-docker-secret` flag for manifest installs). The control plane copies these Secrets into any namespace where NGINX is deployed. For details, see [Install NGINX Gateway Fabric with NGINX Plus]({{< ref "/ngf/install/nginx-plus.md" >}}). {{< /call-out >}}

---

## See also

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}})
- [Configure policy sources (NGINX Instance Manager and NGINX One Console)]({{< ref "/ngf/waf-integration/policy-sources.md" >}})
- [Configure infrastructure-related settings]({{< ref "/ngf/how-to/data-plane-configuration.md#configure-infrastructure-related-settings" >}})
- [Troubleshoot WAFPolicy status]({{< ref "/ngf/waf-integration/troubleshooting.md" >}})
- [Supported container images]({{< ref "/ngf/overview/technical-specifications.md#supported-container-images" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})
- [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}})
