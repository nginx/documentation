---
nd-docs: "DOCS-0000"
files:
  - content/nginx-one/k8s/add-ngf.md
  - content/ngf/install/helm.md
---

The following steps install NGINX Gateway Fabric directly from the OCI helm registry. If you prefer, you can [install from sources](#install-from-sources) instead.

{{<tabs name="install-helm-oci">}}

{{%tab name="NGINX"%}}

To install the latest stable release of NGINX Gateway Fabric in the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

{{< note >}} If applicable, replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image, and replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials. If your NGINX Plus JWT Secret has a different name than the default `nplus-license`, then define that name using the `nginx.usage.secretName` flag. {{< /note >}}

To install the latest stable release of NGINX Gateway Fabric in the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus --set nginx.plus=true --set nginx.imagePullSecret=nginx-plus-registry-secret -n nginx-gateway
```

{{% /tab %}}

{{</tabs>}}

`ngf` is the name of the release, and can be changed to any name you want. This name is added as a prefix to the Deployment name.

If you want the latest version from the **main** branch, add `--version 0.0.0-edge` to your install command.

To wait for the Deployment to be ready, you can either add the `--wait` flag to the `helm install` command, or run the following after installing:

```shell
kubectl wait --timeout=5m -n nginx-gateway deployment/ngf-nginx-gateway-fabric --for=condition=Available
