---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
- content/nic/waf-integration/get-started-plm.md
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

kubectl wait pods \
  --selector app.kubernetes.io/name=seaweedfs \
  --for=condition=Ready \
  --namespace plm-system \
  --timeout=180s
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

Skip this step on a fresh install — Helm installs the CRDs automatically. When upgrading PLM, apply the CRDs manually before running `helm upgrade`:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/waf-policy-controller/{{< version-waf-policy-controller >}}/manifests/1-deploy-crds.yaml
```
