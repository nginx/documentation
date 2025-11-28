---
nd-docs: DOCS-000
nd-files:
- content/nginx-one-console/k8s/add-ngf-manifests.md
---

#### Stable release

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

#### Edge version

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/main/deploy/crds.yaml
```
