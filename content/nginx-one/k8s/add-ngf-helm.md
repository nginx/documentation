---
title: Connect NGINX Gateway Fabric with Helm
toc: true
weight: 300
nd-content-type: how-to
nd-product: NGINX One
---

This document explains how to connect F5 NGINX Gateway Fabric to F5 NGINX One Console with Helm.
Connecting NGINX Gateway Fabric to NGINX One Console enables centralized monitoring of all controller instances.

Once connected, you'll see a **read-only** configuration of NGINX Gateway Fabric. For each instance, you can review:

- Read-only configuration file
- Unmanaged SSL/TLS certificates for Control Planes

## Before you begin

Log in to NGINX One Console. If you need more information, review our [Get started guide]({{< ref "/nginx-one/getting-started.md#before-you-begin" >}}).

You also need:

- Administrator access to a Kubernetes cluster.
- If you use [Helm](https://helm.sh) and [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl), install them locally.

### Create a data plane key

{{< include "/nginx-one/how-to/generate-data-plane-key.md" >}}

### Create a Kubernetes secret with the data plane key

{{< include "/nginx-one/how-to/k8s-secret-dp-key.md" >}}

## Install Gateway API resources
<!-- Corresponds to step 2 in the UX -->
{{< include "/ngf/installation/install-gateway-api-resources.md" >}}

## Install from the OCI registry
<!-- Corresponds to step 3 in the UX -->

The following steps install NGINX Gateway Fabric directly from the OCI helm registry. If you prefer, you can [install from sources](#install-from-sources) instead.

{{<tabs name="install-helm-oci">}}

{{%tab name="NGINX"%}}

To install the latest stable release of NGINX Gateway Fabric in the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --set nginx.nginxOneConsole.dataplaneKeySecretName=<data_plane_key_secret_name> \
  -n nginx-gateway
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

{{< call-out "note" >}} 

If applicable, replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image, and replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials. If your NGINX Plus JWT Secret has a different name than the default `nplus-license`, then define that name using the `nginx.usage.secretName` flag. 

{{< /call-out >}}

To install the latest stable release of NGINX Gateway Fabric in the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus \
  --set nginx.plus=true \
  --set nginx.imagePullSecret=nginx-plus-registry-secret -n nginx-gateway \
  --set nginx.nginxOneConsole.dataplaneKeySecretName=<data_plane_key_secret_name> 
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
<!-- Corresponds to step 4 in the UX -->
If you prefer to install directly from sources, instead of through the OCI helm registry, use the following steps.

{{< include "/ngf/installation/helm/pulling-the-chart.md" >}}

{{<tabs name="install-helm-src">}}

{{%tab name="NGINX"%}}

To install the chart into the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf .  \
  --set nginx.nginxOneConsole.dataplaneKeySecretName=<data_plane_key_secret_name> \
  -n nginx-gateway
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

{{< call-out "note" >}} 

If applicable, replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image, and replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials. If your NGINX Plus JWT Secret has a different name than the default `nplus-license`, then define that name using the `nginx.usage.secretName` flag. 

{{< /call-out >}}

To install the chart into the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf . \
  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus \
  --set nginx.nginxOneConsole.dataplaneKeySecretName=<data_plane_key_secret_name> \
  --set nginx.plus=true \
  --set nginx.imagePullSecret=nginx-plus-registry-secret \
  -n nginx-gateway
```

{{% /tab %}}

{{</tabs>}}

`ngf` is the name of the release, and can be changed to any name you want. This name is added as a prefix to the Deployment name.

To wait for the Deployment to be ready, you can either add the `--wait` flag to the `helm install` command, or run the following after installing:

```shell
kubectl wait --timeout=5m -n nginx-gateway deployment/ngf-nginx-gateway-fabric --for=condition=Available
```

## Verify a connection to NGINX One Console

{{< include "/nginx-one/how-to/verify-connection.md" >}}

## Troubleshooting

{{< include "/nginx-one/how-to/ngf-troubleshooting.md" >}}
