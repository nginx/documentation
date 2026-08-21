---
title: Upgrade NGINX Ingress Controller to F5 WAF for NGINX with PLM
weight: 210
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Ingress Controller
f5-description: >
  Upgrade an existing F5 NGINX Ingress Controller deployment from in-pod App Protect policy compilation (v1beta1 CRDs) to F5 WAF for NGINX with Policy Lifecycle Management (PLM).
f5-audience: operator
---

Use this guide to upgrade an existing F5 NGINX Ingress Controller + F5 WAF for NGINX deployment from in-pod App Protect policy compilation to Policy Lifecycle Management (PLM). PLM compiles `APPolicy` and `APLogConf` resources in a dedicated controller and stores the resulting bundles in an in-cluster S3-compatible object store. NGINX Ingress Controller then fetches the compiled bundles instead of compiling them in the data plane.

Under PLM, the fields you already write on the NGINX Ingress Controller `Policy` resource (`waf.apPolicy` and `waf.securityLogs[].apLogConf`) continue to work unchanged. You don't need to rewrite the `k8s.nginx.org/v1` Policy manifest for a VirtualServer or Ingress during the upgrade.

By the end of this guide, you'll have:

- The PLM backend installed alongside your existing NGINX Ingress Controller deployment.
- NGINX Ingress Controller upgraded to a PLM-capable release with PLM storage configured.
- Existing `APPolicy` and `APLogConf` resources adopted by PLM and compiled into bundles.
- WAF-protected traffic served by NGINX Ingress Controller, with bundles fetched from PLM storage instead of compiled in the data plane.

## Before you begin

Before you start, make sure you have:

- An existing NGINX Ingress Controller + F5 WAF for NGINX deployment running in your cluster.
- Existing `APPolicy` and `APLogConf` resources served by the `appprotect.f5.com/v1beta1` CRDs shipped with your current NGINX Ingress Controller installation.
- `kubectl` and Helm access to the cluster.
- Credentials for `private-registry.nginx.com`.

Record your current values before you begin:

| Value | Where to find it |
|---|---|
| NGINX Ingress Controller release name | `helm list --namespace <NIC_NAMESPACE>` |
| NGINX Ingress Controller chart version | `helm list --namespace <NIC_NAMESPACE>` |
| Existing NGINX Ingress Controller values | `helm get values <NIC_RELEASE> --namespace <NIC_NAMESPACE>` |
| Existing `APPolicy` resources | `kubectl get appolicy --all-namespaces` |
| Existing `APLogConf` resources | `kubectl get aplogconf --all-namespaces` |

This guide uses `nic` as the NGINX Ingress Controller release name, `nginx-ingress` as the NGINX Ingress Controller namespace, `plm-system` as the PLM namespace, and `plm` as the PLM release name. Replace these with your own values consistently throughout.

## Deploy PLM infrastructure

Install the PLM backend into the `plm-system` namespace. The install adds the `appprotect.f5.com/v1` versions to the existing `appprotect.f5.com` CRDs. Because the v1 versions are a superset of v1beta1, adding them doesn't affect NGINX Ingress Controller while it still watches v1beta1.

{{< include "waf/plm-deploy-infrastructure.md" >}}

After the install completes, PLM adopts every existing `APPolicy` and `APLogConf` resource in the cluster. It does this by adding the `appprotect.f5.com/finalizer` finalizer and compiling each resource against its current signature package. Your running NGINX Ingress Controller continues to compile the same resources in-pod. The two mechanisms operate independently until you upgrade NGINX Ingress Controller.

Confirm PLM has compiled the existing resources:

```shell
kubectl get appolicy --all-namespaces \
  --output custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATE:.status.bundle.state'

kubectl get aplogconf --all-namespaces \
  --output custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATE:.status.bundle.state'
```

Every resource should report `STATE: ready`. If any resource isn't `ready`, inspect the PLM policy-controller logs, resolve the compilation errors, and then continue.

## Look up the PLM storage endpoint and credentials

NGINX Ingress Controller connects to PLM's SeaweedFS filer over S3 to fetch compiled bundles. Before you run `helm upgrade`, collect these four values from the PLM installation:

1. **PLM storage URL**: the SeaweedFS filer endpoint (HTTPS or HTTP).
2. **Credentials Secret**: the S3 credentials Secret. The access key ID is `admin` by default. The secret access key is in the `seaweedfs_admin_secret` field.
3. **CA Secret** (HTTPS only): verifies the SeaweedFS filer certificate.
4. **Client TLS Secret** (mutual TLS only): presented by NGINX Ingress Controller when it connects to the filer.

List the Services PLM created and identify the filer:

```shell
kubectl get service --namespace plm-system
```

Expected output includes an entry similar to:

```text
NAME                       TYPE        CLUSTER-IP   PORT(S)
plm-f5-waf-seaweed-filer   ClusterIP   10.0.0.10    8333/TCP,9333/TCP,...
```

Assemble the URL from the service name, namespace, and port. Use `9333` for HTTPS and `8333` for HTTP:

- HTTPS (mTLS): `https://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:9333`
- HTTP: `http://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:8333`

List the Secrets PLM created:

```shell
kubectl get secret --namespace plm-system
```

The default PLM install creates three Secrets that NGINX Ingress Controller references:

- `plm-f5-waf-seaweedfs-auth`: SeaweedFS credentials.
- `plm-f5-waf-seaweedfs-ca-cert`: CA certificate for the HTTPS filer.
- `plm-f5-waf-seaweedfs-client-cert`: client TLS certificate for mTLS.

Record the Secret references in `<namespace>/<name>` form. When you run `helm upgrade`, pass all four values to NGINX Ingress Controller using `--set controller.appprotect.plmStorage.*` flags.

## Apply the NGINX Ingress Controller CRDs

Before you run `helm upgrade`, apply the NGINX Ingress Controller CRDs from the bundled manifest for your target release. The `deploy/crds.yaml` bundle contains every CRD the controller needs (`VirtualServer`, `VirtualServerRoute`, `Policy`, `TransportServer`, `GlobalConfiguration`, `DNSEndpoint`). The bundle deliberately excludes the App Protect CRDs, which PLM owns.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/deploy/crds.yaml
```

## Section 1: Upgrade a VirtualServer-based deployment

Follow this section if your existing NGINX Ingress Controller deployment routes traffic through `k8s.nginx.org/v1` VirtualServer resources that reference a Policy resource with `waf.apPolicy` and `waf.securityLogs[].apLogConf` fields.

### Upgrade NGINX Ingress Controller with PLM storage

Upgrade the NGINX Ingress Controller release. `--reuse-values` preserves your existing configuration. The `--set` flags overlay PLM storage on top. `--skip-crds` prevents Helm from touching CRDs, because you applied the NGINX Ingress Controller CRDs in the previous step and PLM owns the App Protect CRDs.

This example uses HTTPS PLM storage with mutual TLS. For HTTP storage, set `controller.appprotect.plmStorage.url` to `http://<host>:8333` and omit the `caSecret` and `clientSSLSecret` flags.

```shell
helm upgrade nic nginx-stable/nginx-ingress \
  --namespace nginx-ingress \
  --skip-crds \
  --reuse-values \
  --set controller.image.repository="private-registry.nginx.com/nginx-ic-nap-v5/nginx-plus-ingress" \
  --set controller.image.tag="{{< nic-version >}}" \
  --set controller.appprotect.plmStorage.url="https://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:9333" \
  --set controller.appprotect.plmStorage.credentialsSecret="plm-system/plm-f5-waf-seaweedfs-auth" \
  --set controller.appprotect.plmStorage.caSecret="plm-system/plm-f5-waf-seaweedfs-ca-cert" \
  --set controller.appprotect.plmStorage.clientSSLSecret="plm-system/plm-f5-waf-seaweedfs-client-cert" \
  --set controller.appprotect.plmStorage.insecureSkipVerify=false
```

Wait for the rollout to complete:

```shell
kubectl rollout status deployment/nic-nginx-ingress-controller \
  --namespace nginx-ingress \
  --timeout=180s
```

Confirm NGINX Ingress Controller is watching the v1 CRDs by inspecting the controller log:

```shell
kubectl logs deployment/nic-nginx-ingress-controller \
  --namespace nginx-ingress \
  --container nginx-ingress | grep 'appprotect.f5.com/v'
```

Expected output includes:

```text
Using appprotect.f5.com/v1 CRDs
```

### Verify Policy status

Check each WAF Policy referenced by a VirtualServer:

```shell
kubectl get policy --all-namespaces \
  --output custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATE:.status.state,REASON:.status.reason'
```

Expected output after the first successful fetch:

```text
NAMESPACE   NAME         STATE   REASON
default     waf-policy   Valid   AddedOrUpdated
```

If a Policy remains in `Warning` with `BundlePending`, the referenced `APPolicy` or `APLogConf` isn't yet `ready` in PLM. Confirm that PLM has compiled the resource, then retry.

### Verify traffic

Send a normal request to the VirtualServer and confirm the application responds:

```shell
curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
  http://webapp.example.com:$IC_HTTP_PORT/
```

Then send a request that triggers the configured WAF violation and confirm the response is `Request Rejected`.

### Confirm bundles come from PLM storage

Check the bundle files in the ingress controller pod:

```shell
NIC_POD=$(kubectl get pods --namespace nginx-ingress \
  --selector app.kubernetes.io/name=nginx-ingress \
  --output jsonpath='{.items[0].metadata.name}')

kubectl exec --namespace nginx-ingress $NIC_POD --container nginx-ingress -- \
  ls -l /etc/app_protect/bundles/
```

Files named `fetched_<namespace>_<policy-name>_policy.tgz` and `fetched_<namespace>_<policy-name>_log_<index>.tgz` confirm that the bundles were fetched from PLM storage.

## Section 2: Upgrade an Ingress-based deployment

Follow this section if your existing NGINX Ingress Controller deployment routes traffic through Kubernetes Ingress resources. The procedure is the same as Section 1, with one additional Ingress-specific step.

### Audit Ingress annotations

Under PLM, NGINX Ingress Controller doesn't support the App Protect Ingress annotations:

- `appprotect.f5.com/app-protect-policy`
- `appprotect.f5.com/app-protect-security-log`
- `appprotect.f5.com/app-protect-security-log-enable`

An Ingress that uses these annotations is accepted but produces a warning after the upgrade. WAF isn't applied to that route. Before you turn on PLM storage, migrate every such Ingress to a `k8s.nginx.org/v1` Policy resource.

### Upgrade NGINX Ingress Controller with PLM storage

Run the same `helm upgrade` command shown in [Section 1, step 1](#1-upgrade-nginx-ingress-controller-with-plm-storage).

### Verify Ingress traffic

For each Ingress, send a normal request and confirm the application responds. Then send a request that matches a WAF violation and confirm the response is `Request Rejected`.

### Confirm bundles come from PLM storage

Use the same procedure as [Section 1, step 4](#4-confirm-bundles-come-from-plm-storage).

## Troubleshooting

- **Policy stays in `BundlePending` after the upgrade.** The referenced `APPolicy` or `APLogConf` isn't `ready` in PLM. Run `kubectl describe appolicy <name>` and inspect the PLM policy-controller logs.
- **NGINX Ingress Controller reports the referenced namespace isn't watched.** If the deployment sets `controller.watchNamespace`, include the namespace of every `APPolicy` and `APLogConf` resource. Also include the PLM namespace in `controller.watchSecretNamespace` so NGINX Ingress Controller can observe storage Secret rotation.
- **Helm upgrade fails with a CRD conflict.** Confirm PLM is installed and its v1 CRDs are present, then run the upgrade with `--skip-crds`.
