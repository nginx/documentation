---
nd-docs: DOCS-1439
nd-files:
- content/ngf/install/helm.md
- content/ngf/install/upgrade-version.md
- content/nginx-one-console/k8s/add-ngf-helm.md
---

```shell
helm pull oci://ghcr.io/nginx/charts/nginx-gateway-fabric --untar
cd nginx-gateway-fabric
```

For the latest version from the **main** branch, add _--version 0.0.0-edge_ to your pull command.
