---
title: Build NGINX Gateway Fabric
weight: 500
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-1431
---

## Overview

While most users will install NGINX Gateway Fabric [with Helm]({{< ref "/ngf/install/helm.md" >}}) or [Kubernetes manifests]({{< ref "/ngf/install/manifests.md" >}}), manually building the [NGINX Gateway Fabric and NGINX images]({{< ref "/ngf/overview/gateway-architecture.md#the-nginx-gateway-fabric-pod" >}}) can be helpful for testing and development purposes. Follow the steps in this document to build the NGINX Gateway Fabric and NGINX images.

## Before you begin

Before you can build the NGINX Gateway Fabric and NGINX images, make sure you have the following software
installed on your machine:

- [git](https://git-scm.com/)
- [GNU Make](https://www.gnu.org/software/software.html)
- [Docker](https://www.docker.com/) v18.09+
- [Go](https://go.dev/doc/install) v1.20

If building the NGINX Plus image, you will also need a valid NGINX Plus license certificate (`nginx-repo.crt`) and key (`nginx-repo.key`) in the root of the repo.


## Steps

1. Clone the repo and change into the `nginx-gateway-fabric` directory:

   ```shell
   git clone https://github.com/nginx/nginx-gateway-fabric.git --branch v{{< version-ngf >}}
   cd nginx-gateway-fabric
   ```

1. Build the images:

   - To build both the NGINX Gateway Fabric and NGINX images:

     ```makefile
     make PREFIX=myregistry.example.com/nginx-gateway-fabric build-prod-images
     ```

   - To build both the NGINX Gateway Fabric and NGINX Plus images:

     ```makefile
     make PREFIX=myregistry.example.com/nginx-gateway-fabric build-prod-images-with-plus
     ```

   - To build just the NGINX Gateway Fabric image:

     ```makefile
     make PREFIX=myregistry.example.com/nginx-gateway-fabric build-prod-ngf-image
     ```

   - To build just the NGINX image:

     ```makefile
     make PREFIX=myregistry.example.com/nginx-gateway-fabric build-prod-nginx-image
     ```

   - To build just the NGINX Plus image:

     ```makefile
     make PREFIX=myregistry.example.com/nginx-gateway-fabric/nginx-plus build-prod-nginx-plus-image
     ```

   Set the `PREFIX` variable to the name of the registry you'd like to push the image to. By default, the images will be
   named `nginx-gateway-fabric:{{< version-ngf >}}` and `nginx-gateway-fabric/nginx:{{< version-ngf >}}` or `nginx-gateway-fabric/nginx-plus:{{< version-ngf >}}`.

1. Push the images to your container registry:

   ```shell
   docker push myregistry.example.com/nginx-gateway-fabric:{{< version-ngf >}}
   docker push myregistry.example.com/nginx-gateway-fabric/nginx:{{< version-ngf >}}
   ```

   or

   ```shell
   docker push myregistry.example.com/nginx-gateway-fabric:{{< version-ngf >}}
   docker push myregistry.example.com/nginx-gateway-fabric/nginx-plus:{{< version-ngf >}}
   ```

   Make sure to substitute `myregistry.example.com/nginx-gateway-fabric` with your registry.

## Build a WAF-enabled NGINX Plus image

To use [F5 WAF for NGINX]({{< ref "/ngf/waf-integration/overview.md" >}}) with NGINX Gateway Fabric, you need an NGINX Plus image that includes the F5 WAF module. This image is built from the same Dockerfile as the standard NGINX Plus image, with a build argument that includes the `app-protect-module-plus` package.

{{< call-out "important" >}} The WAF-enabled image can only be built for `amd64` architecture. ARM64 is not supported. {{< /call-out >}}

### Additional prerequisites

In addition to the [prerequisites listed above](#before-you-begin), you need:

- A valid NGINX Plus license certificate (`nginx-repo.crt`) and key (`nginx-repo.key`) in the root of the repo.
- Access to the NGINX Plus and F5 WAF for NGINX package repositories.

### Build the images

1. Build both the NGINX Gateway Fabric and NGINX Plus WAF images:

   ```makefile
   make PREFIX=myregistry.example.com/nginx-gateway-fabric build-images-with-nap-waf
   ```

   The previous `make` command builds:
   - The NGINX Gateway Fabric control plane image: `myregistry.example.com/nginx-gateway-fabric:{{< version-ngf >}}`
   - The NGINX Plus WAF data plane image: `myregistry.example.com/nginx-gateway-fabric/nginx-plus:{{< version-ngf >}}`

   To build only the NGINX Plus WAF image (without the control plane image) use the following command:

   ```makefile
   make PREFIX=myregistry.example.com/nginx-gateway-fabric build-nginx-plus-image-with-nap-waf
   ```

1. Push the images to your container registry:

   ```shell
   docker push myregistry.example.com/nginx-gateway-fabric:{{< version-ngf >}}
   docker push myregistry.example.com/nginx-gateway-fabric/nginx-plus:{{< version-ngf >}}
   ```

### Install with the custom WAF image

When installing with Helm, point the NGINX image to your WAF-enabled image and enable NGINX Plus:

```shell
helm install nginx-gateway oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --set nginx.plus=true \
  --set nginx.image.repository=myregistry.example.com/nginx-gateway-fabric/nginx-plus \
  --set nginx.image.tag={{< version-ngf >}}
```

The WAF sidecar containers (`waf-enforcer` and `waf-config-mgr`) are pulled from the NGINX private container registry by default. To use custom images for the sidecars, configure them in the `NginxProxy` resource. See [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}}) for details on enabling WAF on a Gateway.
