---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
- content/nic/waf-integration/get-started-plm.md
---

The Policy Lifecycle Manager (PLM) backend runs as a Kubernetes operator. It watches WAF custom resources and compiles WAF policies into bundles. The Policy Controller delegates compilation to a separate compiler service over gRPC. The resulting bundles are stored in an embedded SeaweedFS S3-compatible object store.

F5 WAF for NGINX is installed using a separate Helm chart from your NGINX data plane. The steps in this section install only the F5 WAF for NGINX PLM components and do not affect your existing NGINX installation.

### Install the CRDs

Install the four custom resource definitions (CRDs) that the Policy Controller manages:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/waf-policy-controller/main/manifests/1-deploy-crds.yaml
```

Confirm all four CRDs are present:

```shell
kubectl get crd | grep appprotect.f5.com
```

Expected output:

```text
appolicies.appprotect.f5.com
aplogconfs.appprotect.f5.com
apsignatures.appprotect.f5.com
apusersigs.appprotect.f5.com
```

### Create the registry pull secret

Create a namespace for the PLM components, then create the registry pull secret using the credentials from the previous section.

Replace `<NAMESPACE>` with your chosen namespace name, and `<JWT>` with your F5 WAF for NGINX JWT.

<!-- TODO (TECHDOCS-5342 / Prerequisites): The Story 3 AC lists four credentials: JWT, certificate, key, and registry token. Confirm with SME what the registry token is and whether it's passed separately in the Helm install or covered by the JWT above. -->

```shell
kubectl create namespace <NAMESPACE>

kubectl create secret docker-registry regcred \
  --namespace <NAMESPACE> \
  --docker-server=private-registry.nginx.com \
  --docker-username=<JWT> \
  --docker-password=none \
  --dry-run=client --output yaml | kubectl apply -f -
```

### Install the Policy Controller

Create a values file for the Helm installation. Replace `<NAMESPACE>`, `<CHART_VERSION>`, `<IMAGE_TAG>`, `<BASE64_NGINX_REPO_CRT>`, and `<BASE64_NGINX_REPO_KEY>` with your values. `<CHART_VERSION>` is the Helm chart version (for example, `5.14.0`). `<IMAGE_TAG>` is the container image tag, which typically matches the chart version.

`<BASE64_NGINX_REPO_CRT>` and `<BASE64_NGINX_REPO_KEY>` are the base64-encoded contents of your `nginx-repo.crt` and `nginx-repo.key` files. To encode them, run:

```shell
base64 --wrap=0 < nginx-repo.crt
base64 --wrap=0 < nginx-repo.key
```

Create `/tmp/plm-values.yaml`:

```yaml
imagePullSecrets:
  - name: regcred
securityUpdatesRepo:
  cert: "<BASE64_NGINX_REPO_CRT>"
  key: "<BASE64_NGINX_REPO_KEY>"
policyController:
  image:
    tag: "<IMAGE_TAG>"
compiler:
  image:
    tag: "<IMAGE_TAG>"
seaweedfsOperatorConfig:
  seaweedfs:
    image:
      tag: "<IMAGE_TAG>"
seaweedfs-operator:
  image:
    tag: "<IMAGE_TAG>"
    pullSecrets: regcred
```

Add the NGINX Helm repository and install the chart:

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update nginx-stable

helm upgrade --install <RELEASE_NAME> nginx-stable/f5-waf-policy-controller \
  --version <CHART_VERSION> \
  --namespace <NAMESPACE> \
  --values /tmp/plm-values.yaml
```

Replace `<RELEASE_NAME>` with a name for the Helm release (for example, `plm`).

### Verify the deployment

Wait for all PLM components to become ready. The Policy Controller's init container waits for both the compiler service and the SeaweedFS S3 endpoint to be available before it starts, so the controller pod will show `Init:0/1` until SeaweedFS is ready.

Wait for the SeaweedFS storage backend:

```shell
kubectl rollout status deployment/<RELEASE_NAME>-seaweedfs-operator \
  --namespace <NAMESPACE> --timeout=120s

kubectl wait pods \
  --selector app.kubernetes.io/name=seaweedfs \
  --for=condition=Ready \
  --namespace <NAMESPACE> \
  --timeout=180s
```

Wait for the Policy Controller:

```shell
kubectl rollout status deployment/<RELEASE_NAME>-f5-waf-policy-controller \
  --namespace <NAMESPACE> --timeout=180s
```

Confirm all eight pods are running:

```shell
kubectl get pods --namespace <NAMESPACE>
```

Expected output:

```text
NAME                                               READY   STATUS    RESTARTS
<release>-f5-waf-compiler-service-xxxxx            1/1     Running   0
<release>-f5-waf-policy-controller-xxxxx           1/1     Running   0
<release>-seaweedfs-operator-xxxxx                 1/1     Running   0
<release>-f5-waf-seaweed-master-0                  1/1     Running   0
<release>-f5-waf-seaweed-filer-0                   1/1     Running   0
<release>-f5-waf-seaweed-volume-0                  1/1     Running   0
<release>-f5-waf-seaweed-volume-1                  1/1     Running   0
<release>-f5-waf-seaweed-volume-2                  1/1     Running   0
```

Confirm the four CRDs are present:

```shell
kubectl get crd | grep appprotect.f5.com
```
