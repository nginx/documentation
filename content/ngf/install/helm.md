---
title: Install NGINX Gateway Fabric with Helm
weight: 200
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1430
---

## Overview

Learn how to install, upgrade, and uninstall NGINX Gateway Fabric in a Kubernetes cluster using Helm.


## Before you begin

To complete this guide, you will need:

- [kubectl](https://kubernetes.io/docs/tasks/tools/), a command-line tool for managing Kubernetes clusters.
- [Helm 3.0 or later](https://helm.sh/docs/intro/install/), for deploying and managing applications on Kubernetes.
- [Add certificates for secure authentication]({{< ref "/ngf/install/secure-certificates.md" >}}) in a production environment.

{{< call-out "important" >}} If you’d like to use NGINX Plus, some additional setup is also required: {{< /call-out >}}

<details closed>
<summary>NGINX Plus JWT setup</summary>

{{< include "/ngf/installation/jwt-password-note.md" >}}

### Download the JWT from MyF5

{{< include "/ngf/installation/nginx-plus/download-jwt.md" >}}

### Create the Docker Registry Secret

{{< include "/ngf/installation/nginx-plus/docker-registry-secret.md" >}}

### Create the NGINX Plus Secret

{{< include "/ngf/installation/nginx-plus/nginx-plus-secret.md" >}}

{{< call-out "note" >}} For more information on why this is needed and additional configuration options, including how to report to NGINX Instance Manager instead, see the [NGINX Plus Image and JWT Requirement]({{< ref "/ngf/install/nginx-plus.md" >}}) document. {{< /call-out >}}

</details>

## Deploy NGINX Gateway Fabric

### Installing the Gateway API resources

{{< include "/ngf/installation/install-gateway-api-resources.md" >}}


### Install from the OCI registry

The following steps install NGINX Gateway Fabric directly from the OCI helm registry. If you prefer, you can [install from sources](#install-from-sources) instead.

{{<tabs name="install-helm-oci">}}

{{%tab name="NGINX"%}}

To install the latest stable release of NGINX Gateway Fabric in the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

{{< call-out "note" >}} If applicable, replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image, and replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials. If your NGINX Plus JWT Secret has a different name than the default `nplus-license`, then define that name using the `nginx.usage.secretName` flag. {{< /call-out >}}

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
```

### Install from sources {#install-from-sources}

If you prefer to install directly from sources, instead of through the OCI helm registry, use the following steps.

{{< include "/ngf/installation/helm/pulling-the-chart.md" >}}

{{<tabs name="install-helm-src">}}

{{%tab name="NGINX"%}}

To install the chart into the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf . --create-namespace -n nginx-gateway
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

{{< call-out "note" >}} If applicable, replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image, and replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials. If your NGINX Plus JWT Secret has a different name than the default `nplus-license`, then define that name using the `nginx.usage.secretName` flag. {{< /call-out >}}

To install the chart into the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf . --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus --set nginx.plus=true --set nginx.imagePullSecret=nginx-plus-registry-secret -n nginx-gateway
```

{{% /tab %}}

{{</tabs>}}

`ngf` is the name of the release, and can be changed to any name you want. This name is added as a prefix to the Deployment name.

To wait for the Deployment to be ready, you can either add the `--wait` flag to the `helm install` command, or run the following after installing:

```shell
kubectl wait --timeout=5m -n nginx-gateway deployment/ngf-nginx-gateway-fabric --for=condition=Available
```

### Custom installation options

#### Service type

By default, the NGINX Gateway Fabric helm chart deploys a LoadBalancer Service.

To use a NodePort Service instead:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway --set nginx.service.type=NodePort
```

#### Experimental features

We support a subset of the additional features provided by the Gateway API experimental channel. To enable the
experimental features of Gateway API which are supported by NGINX Gateway Fabric:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway --set nginxGateway.gwAPIExperimentalFeatures.enable=true
```

{{< call-out "note" >}} Requires the Gateway APIs installed from the experimental channel. {{< /call-out >}}


#### Examples

You can find several examples of configuration options of the `values.yaml` file in the [helm examples](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/helm) directory.

### Access NGINX Gateway Fabric

{{< include "/ngf/installation/expose-nginx-gateway-fabric.md" >}}

## Uninstall NGINX Gateway Fabric

Follow these steps to uninstall NGINX Gateway Fabric and Gateway API from your Kubernetes cluster:

1. **Uninstall NGINX Gateway Fabric:**

   - To uninstall NGINX Gateway Fabric, run:

     ```shell
     helm uninstall ngf -n nginx-gateway
     ```

     If needed, replace `ngf` with your chosen release name.

2. **Remove namespace and CRDs:**

   - To remove the **nginx-gateway** namespace and its custom resource definitions (CRDs), run:

     ```shell
     kubectl delete ns nginx-gateway
     kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
     ```

3. **Remove the Gateway API resources:**

   - {{< include "/ngf/installation/uninstall-gateway-api-resources.md" >}}

## Next steps

- [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}})
- [Routing traffic to applications]({{< ref "/ngf/traffic-management/basic-routing.md" >}})

For a full list of the Helm Chart configuration parameters, read [the NGINX Gateway Fabric Helm Chart](https://github.com/nginx/nginx-gateway-fabric/blob/v{{< version-ngf >}}/charts/nginx-gateway-fabric/README.md#configuration).
