---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

The Policy Lifecycle Manager (PLM) backend runs as a Kubernetes operator. It watches WAF custom resources and compiles WAF policies into bundles. The Policy Controller delegates compilation to a separate compiler service over gRPC. The resulting bundles are stored in an embedded SeaweedFS S3-compatible object store.

F5 WAF for NGINX is installed using a separate Helm chart from your NGINX data plane. The steps in this section install only the F5 WAF for NGINX PLM components and do not affect your existing NGINX installation.

### Create the registry pull secret

Create a namespace for the PLM components, store your JWT in a Kubernetes Secret, then create the registry pull secret for the private F5 container registry.

1. Create the namespace and store your JWT. The following commands assume your JWT file is named `license.jwt`:

   ```shell
   kubectl create namespace plm-system

   kubectl create secret generic jwt-reg-secret \
     --namespace plm-system \
     --from-file=license.jwt
   ```

2. Retrieve the JWT from the Secret and create the registry pull secret:

   ```shell
   JWT=$(kubectl get secret jwt-reg-secret \
     --namespace plm-system \
     -o jsonpath='{.data.license\.jwt}' | base64 -d)

   kubectl create secret docker-registry regcred \
     --namespace plm-system \
     --docker-server=private-registry.nginx.com \
     --docker-username="$JWT" \
     --docker-password=none \
     --dry-run=client --output yaml | kubectl apply -f -
   ```

### Install the Policy Controller

Create a values file for the Helm installation.

The `securityUpdatesRepo.cert` and `securityUpdatesRepo.key` fields are optional. They are only required if your signature repository needs certificate-based authentication. The Policy Controller starts successfully with these fields left empty.

If your signature repository requires them, replace `<BASE64_NGINX_REPO_CRT>` and `<BASE64_NGINX_REPO_KEY>` with the base64-encoded contents of your `nginx-repo.crt` and `nginx-repo.key` files. To encode them, run:

```shell
base64 --wrap=0 < nginx-repo.crt
base64 --wrap=0 < nginx-repo.key
```

Create `/tmp/plm-values.yaml`:

```yaml
imagePullSecrets:
  - name: regcred
securityUpdatesRepo:
  cert: "<BASE64_NGINX_REPO_CRT>"  # optional: only needed for authenticated signature repository access
  key: "<BASE64_NGINX_REPO_KEY>"   # optional: only needed for authenticated signature repository access
policyController:
  image:
    tag: "{{< version-waf-policy-controller >}}"
compiler:
  image:
    tag: "{{< version-waf-policy-controller >}}"
seaweedfsOperatorConfig:
  seaweedfs:
    image:
      tag: "{{< version-waf-policy-controller >}}"
seaweedfs-operator:
  image:
    tag: "{{< version-waf-policy-controller >}}"
    pullSecrets: regcred
```

#### Enable TLS for PLM storage (optional)

By default, communication between PLM components and the SeaweedFS object store uses unencrypted HTTP. To enable TLS, add a `certificates` block to `/tmp/plm-values.yaml`:

```yaml
seaweedfsOperatorConfig:
  seaweedfs:
    certificates:
      enabled: true
      caSecretName: plm-system-seaweedfs-ca-cert
      masterSecretName: plm-system-seaweedfs-master-cert
      volumeSecretName: plm-system-seaweedfs-volume-cert
      filerSecretName: plm-system-seaweedfs-filer-cert
      clientSecretName: plm-system-seaweedfs-client-cert
```

{{< call-out class="warning" title="Warning" >}}
The PLM chart does not generate certificates. You must create all five Secrets listed above before running `helm upgrade --install`. If any Secret is missing, the SeaweedFS pods will fail to mount their certificates and will not start.
{{< /call-out >}}

Create the Secrets from your CA and certificate files before installing:

```shell
kubectl create secret generic plm-system-seaweedfs-ca-cert \
  --namespace plm-system \
  --from-file=ca.crt=<PATH/TO/CA_CERT>

kubectl create secret tls plm-system-seaweedfs-master-cert \
  --namespace plm-system \
  --cert=<PATH/TO/MASTER_CERT> \
  --key=<PATH/TO/MASTER_KEY>

kubectl create secret tls plm-system-seaweedfs-volume-cert \
  --namespace plm-system \
  --cert=<PATH/TO/VOLUME_CERT> \
  --key=<PATH/TO/VOLUME_KEY>

kubectl create secret tls plm-system-seaweedfs-filer-cert \
  --namespace plm-system \
  --cert=<PATH/TO/FILER_CERT> \
  --key=<PATH/TO/FILER_KEY>

kubectl create secret tls plm-system-seaweedfs-client-cert \
  --namespace plm-system \
  --cert=<PATH/TO/CLIENT_CERT> \
  --key=<PATH/TO/CLIENT_KEY>
```

Replace each `<PATH/TO/*>` placeholder with the path to the corresponding certificate and key file from your PKI. The CA must sign all component certificates. If you don't have an existing PKI, generate a CA and sign the five component certificates before proceeding.

#### Install the chart

Add the NGINX Helm repository and install the chart:

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update nginx-stable

helm upgrade --install plm nginx-stable/f5-waf-policy-controller \
  --version {{< version-waf-policy-controller >}} \
  --namespace plm-system \
  --values /tmp/plm-values.yaml
```

To see all available configuration options for the PLM chart, run:

```shell
helm show values nginx-stable/f5-waf-policy-controller --version {{< version-waf-policy-controller >}}
```

### Verify the deployment

Wait for all PLM components to become ready. The Policy Controller's init container waits for both the compiler service and the SeaweedFS S3 endpoint to be available before it starts, so the controller pod will show `Init:0/1` until SeaweedFS is ready.

Wait for the SeaweedFS storage backend:

```shell
kubectl rollout status deployment/plm-seaweedfs-operator \
  --namespace plm-system --timeout=120s
```

The SeaweedFS operator creates the SeaweedFS pods after it reconciles the SeaweedFS custom resource, so there is a window where the operator deployment is ready but no SeaweedFS pods exist yet. Poll until the pods appear and are ready:

```shell
end=$((SECONDS + 300))
until kubectl wait pods \
    --selector app.kubernetes.io/name=seaweedfs \
    --for=condition=Ready \
    --namespace plm-system \
    --timeout=10s 2>/dev/null; do
  if [ $SECONDS -ge $end ]; then
    echo "Timed out waiting for SeaweedFS pods"
    exit 1
  fi
  sleep 5
done
```

Wait for the Policy Controller:

```shell
kubectl rollout status deployment/plm-f5-waf-policy-controller \
  --namespace plm-system --timeout=180s
```

Confirm all pods are running:

```shell
kubectl get pods --namespace plm-system
```

Example output:

```text
NAME                                               READY   STATUS    RESTARTS
plm-f5-waf-compiler-service-xxxxx                  1/1     Running   0
plm-f5-waf-policy-controller-xxxxx                 1/1     Running   0
plm-seaweedfs-operator-xxxxx                       1/1     Running   0
plm-f5-waf-seaweed-master-0                        1/1     Running   0
plm-f5-waf-seaweed-filer-0                         1/1     Running   0
plm-f5-waf-seaweed-volume-0                        1/1     Running   0
plm-f5-waf-seaweed-volume-1                        1/1     Running   0
plm-f5-waf-seaweed-volume-2                        1/1     Running   0
```

Confirm the CRDs are present:

```shell
kubectl get crd | grep appprotect.f5.com
```

Expected output:

```text
aplogconfs.appprotect.f5.com
appolicies.appprotect.f5.com
apsignatures.appprotect.f5.com
apusersigs.appprotect.f5.com
```

All eight pods running and all four CRDs present confirms the PLM backend is ready.

### Update the CRDs

{{< call-out class="note" title="Note" >}}
Skip this step on a fresh install — Helm installs the CRDs automatically. Only follow these steps when upgrading an existing PLM installation.
{{< /call-out >}}

When upgrading PLM, apply the CRDs manually before running `helm upgrade`:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/waf-policy-controller/{{< version-waf-policy-controller >}}/manifests/1-deploy-crds.yaml
```

### Troubleshoot the deployment

These are the most common failures during PLM installation, roughly in order of likelihood.

{{< details summary="Pods stuck in `ImagePullBackOff`" >}}

The JWT is wrong, expired, or contains a line break. Check the events log:

```shell
kubectl get events --namespace plm-system --field-selector reason=Failed
```

Use the full JWT string as the registry username. Use the literal string `none` as the password.

{{< /details >}}

{{< details summary="Policy Controller stuck in `Init:0/1`" >}}

The `Init:0/1` state is expected during startup. The init container waits for the compiler service and the S3 endpoint before it starts. If the pod stays in `Init:0/1` for more than a few minutes, check that the SeaweedFS pods are `Running`:

```shell
kubectl get pods --namespace plm-system --selector app.kubernetes.io/name=seaweedfs
```

The most common cause is PVCs stuck in `Pending` because the cluster has no default StorageClass.

{{< /details >}}

{{< details summary="SeaweedFS pods `Pending`" >}}

SeaweedFS pods stay `Pending` when the cluster has no default StorageClass or insufficient capacity. Check the PVCs and available storage classes:

```shell
kubectl get pvc --namespace plm-system
kubectl get storageclass
```

{{< /details >}}

{{< details summary="`APPolicy` shows `invalid` with `unexpected EOF` after enabling TLS" >}}

Enabling TLS on an existing installation restarts the storage backend. Objects written before TLS was enabled can become orphaned. Check the filer log:

```shell
kubectl logs --namespace plm-system plm-f5-waf-seaweed-filer-0 | grep "not found"
```

If the output contains `volume N not found`, orphaned objects exist. Delete the affected `APPolicy` resource and reapply it. The Policy Controller regenerates the bundle.

{{< /details >}}

{{< details summary="Helm install fails on a ClusterRole" >}}

If the error references `seaweed-editor-role` or `seaweed-viewer-role`, another PLM installation already exists in the cluster. Only one PLM installation is supported per cluster. Remove the existing release before installing.

{{< /details >}}

#### Check the Policy Controller logs

Use the Policy Controller logs to diagnose any policy-related failure:

```shell
kubectl logs --namespace plm-system deploy/plm-f5-waf-policy-controller -c policy-controller
```

{{< call-out class="note" title="Note" >}} The `-c policy-controller` flag is required because the pod has more than one container. The containers are distroless, so `kubectl exec` isn't available for interactive debugging. {{< /call-out >}}
