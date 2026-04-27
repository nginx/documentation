---
title: Use external TLS certificates
toc: true
weight: 500
nd-content-type: how-to
nd-product: NIMNGR
---

## Overview

By default, the F5 NGINX Instance Manager Helm chart generates a self-signed certificate authority (CA) and all required TLS certificates at install time. This works well for development and evaluation, but production deployments typically need certificates from a trusted CA, such as HashiCorp Vault, cert-manager, or your organization's PKI team.

The Bring Your Own Certificates (BYOC) feature lets you supply pre-provisioned TLS certificates for any or all NGINX Instance Manager services. You can replace individual service certificates without changing the chart's default behavior for services you don't override.

New with this feature:

- **Per-service certificate Secrets**: replace individual service certificates independently
- **Custom API Gateway server name**: set a real domain instead of the catch-all `_`
- **TLS auto-reload**: NGINX reloads automatically when a mounted certificate rotates
- **OpenShift compatibility**: `seccompProfile` is no longer set explicitly on OpenShift

---

## Before you begin

Make sure you have:

- **Kubernetes 1.21.3 or later**: With `kubectl` access to the cluster.
- **Helm 3.10.0 or later**: See the [Helm installation guide](https://helm.sh/docs/intro/install/).
- **OpenSSL 1.1.1 or later**: Required for generating certificates.
- **The NGINX Instance Manager Helm chart**: Downloaded and ready to deploy. See [Deploy using Helm]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}).

---

## How NGINX Instance Manager manages certificates

NGINX Instance Manager uses mutual TLS (mTLS) for internal service-to-service communication. The API Gateway also terminates HTTPS for external clients.

**Default flow (chart-generated)**

When you don't set any `externalCerts` values, the chart generates a single Kubernetes Secret named `<release>-internal-certs`. This Secret contains the CA certificate, CA private key, and every service's server and client certificate pair. All pods mount this one Secret. Use this approach for development and evaluation only.

**BYOC flow (external certificates)**

When you set one or more `externalCerts.<service>.enabled` values to `true`, the chart switches to per-service Secrets. The chart only generates Secrets for services where `enabled` is `false`. For services where `enabled` is `true`, you must create the Secret in the cluster before running `helm install` or `helm upgrade`.

{{< call-out "important" >}}
When any `externalCerts.*.enabled` value is `true`, the chart no longer creates the monolithic `nms-internal-certs` Secret. All workloads mount per-service Secrets instead.
{{< /call-out >}}

The API Gateway's external HTTPS certificate is set separately with `apigw.tlsSecret`. This is independent of the internal mTLS certificates.

---

## Secret reference

The following table lists every Secret used by NGINX Instance Manager, its default name (assuming `fullnameOverride: "nms"`), and the required keys.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Secret | Default name | Type | Required keys |
|--------|-------------|------|---------------|
| Monolithic (default flow) | `nms-internal-certs` | `Opaque` | `ca.pem`, `ca.key`, and all service certificate pairs |
| CA | `nms-ca` | `Opaque` | `ca.pem`, `ca.key` |
| core mTLS | `nms-core-certs` | `Opaque` | `core-server.pem`, `core-server.key`, `core-client.pem`, `core-client.key` |
| dpm mTLS | `nms-dpm-certs` | `Opaque` | `dpm-server.pem`, `dpm-server.key`, `dpm-client.pem`, `dpm-client.key` |
| ingestion mTLS | `nms-ingestion-certs` | `Opaque` | `ingestion-server.pem`, `ingestion-server.key`, `ingestion-client.pem`, `ingestion-client.key` |
| integrations mTLS | `nms-integrations-certs` | `Opaque` | `integrations-server.pem`, `integrations-server.key`, `integrations-client.pem`, `integrations-client.key`, `dpm-client.pem`, `dpm-client.key`, `core-client.pem`, `core-client.key` |
| secmon mTLS | `nms-secmon-certs` | `Opaque` | `secmon-server.pem`, `secmon-server.key`, `secmon-client.pem`, `secmon-client.key` |
| apigw client mTLS | `nms-apigw-client-certs` | `Opaque` | `apigw-client.pem`, `apigw-client.key` |
| apigw HTTPS | user-defined (for example, `nim-apigw-tls`) | `kubernetes.io/tls` | `tls.crt`, `tls.key` |
{{< /bootstrap-table >}}

{{< call-out "important" >}}
The `integrations` Secret must also contain `dpm-client.pem`, `dpm-client.key`, `core-client.pem`, and `core-client.key`. The integrations service calls both `dpm` and `core` over mTLS.
{{< /call-out >}}

---

## Certificate requirements

All certificates must be signed by the same CA. The following table lists the minimum Subject Alternative Names (SANs) for each certificate.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Certificate | CN | SANs (DNS) | SANs (IP) | Key usage |
|-------------|----|-----------|-----------|-----------|
| `core-server` | `core.<namespace>` | `core`, `core.<ns>.svc`, `core.<ns>.svc.cluster.local` | `0.0.0.0`, `127.0.0.1` | `serverAuth`, `clientAuth` |
| `core-client` | `core-client` | `core-api-service`, `core-grpc-service` | — | `clientAuth` |
| `dpm-server` | `dpm.<namespace>` | `dpm`, `dpm.<ns>.svc`, `dpm.<ns>.svc.cluster.local` | `0.0.0.0`, `127.0.0.1` | `serverAuth`, `clientAuth` |
| `dpm-client` | `dpm-client` | `dpm-api-service`, `dpm-grpc-service` | — | `clientAuth` |
| `ingestion-server` | `ingestion.<namespace>` | `ingestion`, `ingestion.<ns>.svc`, `ingestion.<ns>.svc.cluster.local` | `0.0.0.0`, `127.0.0.1` | `serverAuth`, `clientAuth` |
| `ingestion-client` | `ingestion-client` | `ingestion-api-service`, `ingestion-grpc-service` | — | `clientAuth` |
| `integrations-server` | `integrations.<namespace>` | `integrations`, `integrations.<ns>.svc`, `integrations.<ns>.svc.cluster.local` | `0.0.0.0`, `127.0.0.1` | `serverAuth`, `clientAuth` |
| `integrations-client` | `integrations-client` | `integrations-api-service`, `integrations-grpc-service` | — | `clientAuth` |
| `secmon-server` | `secmon.<namespace>` | `secmon`, `secmon.<ns>.svc`, `secmon.<ns>.svc.cluster.local` | `0.0.0.0`, `127.0.0.1` | `serverAuth`, `clientAuth` |
| `secmon-client` | `secmon-client` | `secmon-api-service`, `secmon-grpc-service` | — | `clientAuth` |
| `apigw-client` | `apigw-client` | `apigw-api-service`, `apigw-grpc-service` | — | `clientAuth` |
| apigw HTTPS | Your domain (for example, `nim.example.com`) | Your public domain(s) | Optional | `serverAuth` |
{{< /bootstrap-table >}}

---

## Helm settings

The following table lists the Helm values added by the BYOC feature. All fields default to `false` or an empty string.

For the complete list of Helm settings, see [Configurable Helm settings]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md" >}}).

{{< bootstrap-table "table table-striped table-bordered" >}}
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `externalCerts.ca.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the CA Secret. You must create it before installation. |
| `externalCerts.ca.secretName` | `string` | `""` (`nms-ca`) | Overrides the default CA Secret name. |
| `externalCerts.core.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the `core` mTLS Secret. |
| `externalCerts.core.secretName` | `string` | `""` (`nms-core-certs`) | Overrides the default `core` Secret name. |
| `externalCerts.dpm.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the `dpm` mTLS Secret. |
| `externalCerts.dpm.secretName` | `string` | `""` (`nms-dpm-certs`) | Overrides the default `dpm` Secret name. |
| `externalCerts.ingestion.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the `ingestion` mTLS Secret. |
| `externalCerts.ingestion.secretName` | `string` | `""` (`nms-ingestion-certs`) | Overrides the default `ingestion` Secret name. |
| `externalCerts.integrations.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the `integrations` mTLS Secret. |
| `externalCerts.integrations.secretName` | `string` | `""` (`nms-integrations-certs`) | Overrides the default `integrations` Secret name. |
| `externalCerts.secmon.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the `secmon` mTLS Secret. |
| `externalCerts.secmon.secretName` | `string` | `""` (`nms-secmon-certs`) | Overrides the default `secmon` Secret name. |
| `externalCerts.apigw.enabled` | `bool` | `false` | When `true`, the chart doesn't generate the `apigw` client mTLS Secret. |
| `externalCerts.apigw.secretName` | `string` | `""` (`nms-apigw-client-certs`) | Overrides the default `apigw` client Secret name. |
| `apigw.tlsSecret` | `string` | `""` | Name of a `kubernetes.io/tls` Secret for the external HTTPS endpoint. Leave empty to use the chart's self-signed certificate. |
| `apigw.serverName` | `string` | `""` | The NGINX `server_name` value. Accepts a single domain or space-separated list. Defaults to `_` (catch-all) when empty. |
| `apigw.tlsReload.enabled` | `bool` | `false` | When `true`, a watcher monitors the mounted certificate volume and sends `SIGHUP` to NGINX when the certificate rotates. |
{{< /bootstrap-table >}}

---

## Supply a BYO HTTPS certificate for the API Gateway

{{< production >}}
This procedure is recommended for production deployments.
{{< /production >}}

Use this procedure when you want a trusted TLS certificate for the external HTTPS endpoint (for example, `nim.example.com`) but want the chart to manage all internal mTLS certificates.

1. Create the Kubernetes TLS Secret:

   ```shell
   kubectl create secret tls nim-apigw-tls \
     --cert=path/to/nim.example.com.crt \
     --key=path/to/nim.example.com.key \
     --namespace nms
   ```

2. Install the chart:

   ```shell
   helm upgrade --install nms ./nim-chart \
     --namespace nms --create-namespace \
     --set adminPasswordHash=<bcrypt-hash> \
     --set apigw.tlsSecret=nim-apigw-tls \
     --set apigw.serverName=nim.example.com
   ```

   Or, set the values in `values.yaml`:

   ```yaml
   adminPasswordHash: "<bcrypt-hash>"
   apigw:
     tlsSecret: "nim-apigw-tls"
     serverName: "nim.example.com"
   ```

---

## Supply all certificates externally

{{< production >}}
This procedure is recommended for production deployments.
{{< /production >}}

Use this procedure when all certificates are managed by your PKI, cert-manager, or a secrets manager such as HashiCorp Vault. The chart generates no certificates.

### Generate certificates

The following script generates a CA and all required service certificates using OpenSSL. Replace `nim.example.com` with your domain. Set `NAMESPACE` to match your deployment namespace.

```bash
#!/bin/bash
set -euo pipefail

OUTDIR="/tmp/nim-certs"
DAYS=3650
NS="${NAMESPACE:-nms}"

mkdir -p "$OUTDIR" && cd "$OUTDIR"

# CA
openssl genrsa -out ca.key 4096 2>/dev/null
openssl req -new -x509 -days $DAYS -key ca.key -subj "/CN=nim-ca" -out ca.pem

# Helper: server certificate
gen_server() {
  local name="$1"; shift; local sans="$*"
  openssl genrsa -out "${name}-server.key" 2048 2>/dev/null
  local san_str="IP:0.0.0.0,IP:127.0.0.1"
  for s in $sans; do san_str="${san_str},DNS:${s}"; done
  openssl req -new -key "${name}-server.key" -subj "/CN=${name}.${NS}" \
    -out "${name}-server.csr"
  openssl x509 -req -days $DAYS -in "${name}-server.csr" \
    -CA ca.pem -CAkey ca.key -CAcreateserial \
    -extfile <(printf "subjectAltName=%s\nextendedKeyUsage=serverAuth,clientAuth" "$san_str") \
    -out "${name}-server.pem" 2>/dev/null
  rm -f "${name}-server.csr"
}

# Helper: client certificate
gen_client() {
  local name="$1"; shift; local sans="$*"
  openssl genrsa -out "${name}-client.key" 2048 2>/dev/null
  local san_str=""
  local sep=""
  for s in $sans; do san_str="${san_str}${sep}DNS:${s}"; sep=","; done
  openssl req -new -key "${name}-client.key" -subj "/CN=${name}-client" \
    -out "${name}-client.csr"
  openssl x509 -req -days $DAYS -in "${name}-client.csr" \
    -CA ca.pem -CAkey ca.key -CAcreateserial \
    -extfile <(printf "subjectAltName=%s\nextendedKeyUsage=clientAuth" "$san_str") \
    -out "${name}-client.pem" 2>/dev/null
  rm -f "${name}-client.csr"
}

# Per-service certificates
for svc in core dpm ingestion integrations secmon; do
  gen_server "$svc" "$svc" "${svc}.${NS}.svc" "${svc}.${NS}.svc.cluster.local"
  gen_client "$svc" "${svc}-api-service" "${svc}-grpc-service"
done

# apigw client certificate (internal mTLS)
gen_client "apigw" "apigw-api-service" "apigw-grpc-service"

# apigw HTTPS certificate (external endpoint)
openssl genrsa -out apigw-tls.key 2048 2>/dev/null
openssl req -new -key apigw-tls.key -subj "/CN=nim.example.com" -out apigw-tls.csr
openssl x509 -req -days $DAYS -in apigw-tls.csr \
  -CA ca.pem -CAkey ca.key -CAcreateserial \
  -extfile <(printf "subjectAltName=DNS:nim.example.com,IP:127.0.0.1\nextendedKeyUsage=serverAuth") \
  -out apigw-tls.crt 2>/dev/null
rm -f apigw-tls.csr

echo "Done. Files in $OUTDIR:"
ls -1 *.pem *.key *.crt 2>/dev/null
```

### Verify all certificates chain to the CA

Each line must end with `OK`:

```shell
cd /tmp/nim-certs
for pem in *-server.pem *-client.pem apigw-tls.crt; do
  echo -n "$pem: "
  openssl verify -CAfile ca.pem "$pem"
done
```

### Create Kubernetes Secrets

Run the following commands before running `helm install`. The namespace must already exist.

```shell
NS=nms
cd /tmp/nim-certs

kubectl create namespace $NS --dry-run=client -o yaml | kubectl apply -f -

# CA
kubectl create secret generic nms-ca \
  --from-file=ca.pem=ca.pem \
  --from-file=ca.key=ca.key \
  --namespace $NS

# core
kubectl create secret generic nms-core-certs \
  --from-file=core-server.pem --from-file=core-server.key \
  --from-file=core-client.pem --from-file=core-client.key \
  --namespace $NS

# dpm
kubectl create secret generic nms-dpm-certs \
  --from-file=dpm-server.pem --from-file=dpm-server.key \
  --from-file=dpm-client.pem --from-file=dpm-client.key \
  --namespace $NS

# ingestion
kubectl create secret generic nms-ingestion-certs \
  --from-file=ingestion-server.pem --from-file=ingestion-server.key \
  --from-file=ingestion-client.pem --from-file=ingestion-client.key \
  --namespace $NS

# integrations (also needs dpm-client and core-client)
kubectl create secret generic nms-integrations-certs \
  --from-file=integrations-server.pem --from-file=integrations-server.key \
  --from-file=integrations-client.pem --from-file=integrations-client.key \
  --from-file=dpm-client.pem --from-file=dpm-client.key \
  --from-file=core-client.pem --from-file=core-client.key \
  --namespace $NS

# secmon
kubectl create secret generic nms-secmon-certs \
  --from-file=secmon-server.pem --from-file=secmon-server.key \
  --from-file=secmon-client.pem --from-file=secmon-client.key \
  --namespace $NS

# apigw client (internal mTLS)
kubectl create secret generic nms-apigw-client-certs \
  --from-file=apigw-client.pem --from-file=apigw-client.key \
  --namespace $NS

# apigw HTTPS (external endpoint)
kubectl create secret tls nim-apigw-tls \
  --cert=apigw-tls.crt --key=apigw-tls.key \
  --namespace $NS
```

### Install the chart

```shell
helm upgrade --install nms ./nim-chart \
  --namespace nms \
  --set adminPasswordHash=<bcrypt-hash> \
  --set externalCerts.ca.enabled=true \
  --set externalCerts.core.enabled=true \
  --set externalCerts.dpm.enabled=true \
  --set externalCerts.ingestion.enabled=true \
  --set externalCerts.integrations.enabled=true \
  --set externalCerts.secmon.enabled=true \
  --set externalCerts.apigw.enabled=true \
  --set apigw.tlsSecret=nim-apigw-tls \
  --set apigw.serverName=nim.example.com
```

Or, set the values in `values.yaml`:

```yaml
adminPasswordHash: "<bcrypt-hash>"
apigw:
  tlsSecret: "nim-apigw-tls"
  serverName: "nim.example.com"
externalCerts:
  ca:
    enabled: true
    secretName: "nms-ca"
  core:
    enabled: true
    secretName: "nms-core-certs"
  dpm:
    enabled: true
    secretName: "nms-dpm-certs"
  ingestion:
    enabled: true
    secretName: "nms-ingestion-certs"
  integrations:
    enabled: true
    secretName: "nms-integrations-certs"
  secmon:
    enabled: true
    secretName: "nms-secmon-certs"
  apigw:
    enabled: true
    secretName: "nms-apigw-client-certs"
```

### Verify the deployment

```shell
# All pods should be Running
kubectl get pods -n nms

# Confirm the chart didn't create any cert Secrets
kubectl get secrets -n nms | grep -E 'internal-certs|core-certs|dpm-certs'
# Expected: no output
```

---

## Mix external and chart-generated certificates

Use this approach when your PKI team manages only some certificates and you want the chart to handle the rest.

For example, to supply the CA and `core` certificates externally while the chart generates the rest:

```yaml
externalCerts:
  ca:
    enabled: true
    secretName: "nms-ca"
  core:
    enabled: true
    secretName: "nms-core-certs"
  # dpm, ingestion, integrations, secmon, apigw — chart generates these
```

{{< call-out "important" >}}
When `externalCerts.ca.enabled` is `true` and any service's `enabled` value is `false`, the chart signs the remaining service certificates with your CA private key. The CA Secret must contain both `ca.pem` and `ca.key`. Without `ca.key`, `helm upgrade` fails with an error.
{{< /call-out >}}

---

## Set up TLS auto-reload for the API Gateway

When an external tool such as cert-manager or Vault Agent Injector manages your certificates, the mounted Secret volume updates automatically when a certificate rotates. NGINX doesn't detect file changes on its own. It needs a reload signal (`SIGHUP`).

Setting `apigw.tlsReload.enabled: true` starts a lightweight watcher inside the API Gateway container. The watcher polls the Kubernetes projected volume symlink every 10 seconds. When it detects that the symlink target has changed, it sends `SIGHUP` to the NGINX master process, triggering a graceful reload.

To turn on TLS auto-reload:

```yaml
apigw:
  tlsSecret: "nim-apigw-tls"
  serverName: "nim.example.com"
  tlsReload:
    enabled: true
```

**How it works:**

- NGINX starts as the main process (PID 1).
- The watcher runs as a background shell process in the same container.
- When a certificate rotates, NGINX performs a graceful reload. Existing connections drain before workers restart.
- A brief interruption (typically less than 1 second) is expected during reload.
- The watcher logs rotation events to stdout: `cert-reload: cert rotated (...), reloading NGINX...`

{{< call-out "note" >}}
Auto-reload applies only to the API Gateway's external HTTPS certificate (`apigw.tlsSecret`). Internal mTLS certificates reload when the respective service pods restart.
{{< /call-out >}}

---

## Set a custom API Gateway server name

By default, the NGINX API Gateway uses `server_name _`, which accepts requests for any hostname. For production, set `apigw.serverName` to restrict which hostnames NGINX responds to.

**Single domain:**

```yaml
apigw:
  serverName: "nim.example.com"
```

**Multiple domains (space-separated):**

```yaml
apigw:
  serverName: "nim.example.com nim-dr.example.com"
```

{{< call-out "important" >}}
The TLS certificate in `apigw.tlsSecret` must be valid for every domain listed in `apigw.serverName`. Use a SAN certificate or a wildcard certificate.
{{< /call-out >}}

---

## OpenShift considerations

On OpenShift, the `restricted-v2` Security Context Constraint (SCC) manages `seccompProfile` for pods automatically. Setting `seccompProfile` explicitly in the pod spec isn't supported on OpenShift 4.10 and earlier, and causes pod scheduling failures.

The NGINX Instance Manager Helm chart detects OpenShift deployments through the `openshift.enabled` value and omits the `seccompProfile` field automatically.

```yaml
openshift:
  enabled: true
```

All certificate scenarios (default, BYOC, and mixed) are fully supported on OpenShift.

---

## Troubleshooting

### `helm upgrade` fails with a CA key error

**Symptom**: `helm upgrade` fails with an error about a missing CA key.

**Cause**: `externalCerts.ca.enabled` is `true`, but the `nms-ca` Secret doesn't contain `ca.key`.

**Fix**: Add `ca.key` to the CA Secret. When the chart generates any service certificate, it needs the CA private key to sign it.

### Pods fail to start after installation

**Symptom**: Pods are in `CrashLoopBackOff` or `Error` state after installation.

**Cause**: A required Secret is missing or contains incorrect keys.

**Fix**: Check that all Secrets listed in the [Secret reference](#secret-reference) exist in the correct namespace and contain the required keys.

```shell
kubectl get secrets -n nms
kubectl describe secret <secret-name> -n nms
```

### Certificate verification fails

**Symptom**: The `openssl verify` command returns an error for one or more certificates.

**Cause**: The certificate wasn't signed by the CA in `ca.pem`, or the SAN values don't match what NGINX Instance Manager expects.

**Fix**: Regenerate the certificate. Make sure you use the same `ca.pem` and `ca.key` for all certificates. Check the [Certificate requirements](#certificate-requirements) table for the required SAN values.

---

## References

- [Deploy using Helm]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}})
- [Configurable Helm settings]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md" >}})
- [Frequently used Helm configurations]({{< ref "/nim/deploy/kubernetes/frequently-used-helm-configs.md" >}})
