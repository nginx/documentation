---
title: Download NGINX Ingress Controller from the F5 Registry
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIC
nd-docs: DOCS-605
---

This page describes how to download an F5 NGINX Plus Ingress Controller image from the official F5 Docker registry.

The F5 Registry images include versions with NGINX App Protect WAF and F5 DoS for NGINX.

## Before you begin

To follow these steps, you will need the following pre-requisites:

- [Docker v18.09 or higher](https://docs.docker.com/engine/release-notes/18.09/)

You can also get the NGINX Ingress Controller image using the following alternate methods:

- [Add an NGINX Ingress Controller image to your cluster]({{< ref "/nic/installation/nic-images/add-image-to-cluster.md" >}})
- [Build NGINX Ingress Controller]({{< ref "/nic/installation/build-nginx-ingress-controller.md" >}}) 
- For NGINX Open Source, you can pull [an image from DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/)

### Download your subscription credential files

{{< include "use-cases/credential-download-instructions.md" >}}

### Set up Docker for the F5 Container Registry

{{< include "use-cases/docker-registry-instructions.md" >}}

## Pull the image

Identify which image you need using the [Technical specifications]({{< ref "/nic/technical-specifications.md#images-with-nginx-plus" >}}) topic.

Next, pull the image from `private-registry.nginx.com`. 

Replace `<version-tag>` with the specific version you need, for example, `{{< nic-version >}}`.

- For NGINX Plus Ingress Controller, run:

  ```shell
  docker pull private-registry.nginx.com/nginx-ic/nginx-plus-ingress:<version-tag>
  ```

- For NGINX Plus Ingress Controller with NGINX App Protect WAF, run:

   ```shell
   docker pull private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress:<version-tag>
   ```

- For NGINX Plus Ingress Controller with NGINX App Protect WAF v5, run:

   ```shell
   docker pull private-registry.nginx.com/nginx-ic-nap-v5/nginx-plus-ingress:<version-tag>
   ```

   ```shell
   docker pull private-registry.nginx.com/nap/waf-config-mgr:<waf-version-tag>
   ```

   ```shell
   docker pull private-registry.nginx.com/nap/waf-enforcer:<waf-version-tag>
   ```

- For NGINX Plus Ingress Controller with F5 DoS for NGINX, run:

   ```shell
   docker pull private-registry.nginx.com/nginx-ic-dos/nginx-plus-ingress:<version-tag>
   ```

- For NGINX Plus Ingress Controller with NGINX App Protect WAF and F5 DoS for NGINX, run:

   ```shell
   docker pull private-registry.nginx.com/nginx-ic-nap-dos/nginx-plus-ingress:<version-tag>
   ```

You can use the Docker registry API to list the available image tags by running the following commands. Replace `<path-to-client.key>` with the location of your client key and `<path-to-client.cert>` with the location of your client certificate. 

The `jq` command was used in these examples to make the JSON output easier to read.

```shell
curl https://private-registry.nginx.com/v2/nginx-ic/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```
```json
{
  "name": "nginx-ic/nginx-plus-ingress",
  "tags": [
    "{{< nic-version >}}-alpine",
    "{{< nic-version >}}-alpine-fips",
    "{{< nic-version >}}-ubi",
    "{{< nic-version >}}"
  ]
}
```

```shell
curl https://private-registry.nginx.com/v2/nginx-ic-nap/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```
```json
{
  "name": "nginx-ic-nap/nginx-plus-ingress",
  "tags": [
    "{{< nic-version >}}-alpine-fips",
    "{{< nic-version >}}-ubi",
    "{{< nic-version >}}"
  ]
}
```

```shell
curl https://private-registry.nginx.com/v2/nginx-ic-dos/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```
```json
{
  "name": "nginx-ic-dos/nginx-plus-ingress",
  "tags": [
    "{{< nic-version >}}-ubi",
    "{{< nic-version >}}"
  ]
}
```

## Push to your private registry

After pulling the image, tag it and upload it to your private registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry>
   ```

1. Tag and push the image. Replace `<my-docker-registry>` with your registry's path and `<version-tag>` with the version you're using, for example `{{< nic-version >}}`:

   - For NGINX Plus Ingress Controller, run:

      ```shell
      docker tag private-registry.nginx.com/nginx-ic/nginx-plus-ingress:<version-tag> <my-docker-registry>/nginx-ic/nginx-plus-ingress:<version-tag>
      docker push <my-docker-registry>/nginx-ic/nginx-plus-ingress:<version-tag>
      ```

   - For NGINX Controller with NGINX App Protect WAF, run:

      ```shell
      docker tag private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress:<version-tag> <my-docker-registry>/nginx-ic-nap/nginx-plus-ingress:<version-tag>
      docker push <my-docker-registry>/nginx-ic-nap/nginx-plus-ingress:<version-tag>
      ```

      - For NGINX Controller with NGINX App Protect WAF v5, run:

      ```shell
      docker tag private-registry.nginx.com/nginx-ic-nap-v5/nginx-plus-ingress:<version-tag> <my-docker-registry>/nginx-ic-nap/nginx-plus-ingress:<version-tag>
      docker push <my-docker-registry>/nginx-ic-nap/nginx-plus-ingress:<version-tag>
      ```

      ```shell
      docker tag private-registry.nginx.com/nap/waf-config-mgr:<waf-version-tag> <my-docker-registry>/nap/waf-config-mgr:<waf-version-tag>
      docker push <my-docker-registry>/nap/waf-config-mgr:<waf-version-tag>
      ```

      ```shell
      docker tag private-registry.nginx.com/nap/waf-enforcer:<waf-version-tag> <my-docker-registry>/nap/waf-enforcer:<waf-version-tag>
      docker push <my-docker-registry>/nap/waf-enforcer:<waf-version-tag>
      ```

   - For NGINX Controller with F5 DoS for NGINX, run:

      ```shell
      docker tag private-registry.nginx.com/nginx-ic-dos/nginx-plus-ingress:<version-tag> <my-docker-registry>/nginx-ic-dos/nginx-plus-ingress:<version-tag>
      docker push <my-docker-registry>/nginx-ic-dos/nginx-plus-ingress:<version-tag>
      ```

## Troubleshooting

If you encounter issues while following this guide, here are some possible solutions:

- **Certificate errors**
  - **Likely Cause**: Incorrect certificate or key location, or using an NGINX Plus certificate.
  - **Solution**: Verify you have the correct NGINX Ingress Controller certificate and key. Place them in the correct directory and ensure the certificate has a *.cert* extension.

- **Docker version compatibility**
  - **Likely Cause**: Outdated Docker version.
  - **Solution**: Make sure you're running [Docker v18.09 or higher](https://docs.docker.com/engine/release-notes/18.09/). Upgrade if necessary.

- **Can't pull the image**
  - **Likely Cause**: Mismatched image name or tag.
  - **Solution**: Double-check the image name and tag matches the [Technical specifications]({{< ref "/nic/technical-specifications.md#images-with-nginx-plus" >}}) document.

- **Failed to push to private registry**
  - **Likely Cause**: Not logged into your private registry or incorrect image tagging.
  - **Solution**: Verify login status and correct image tagging before pushing. Consult the [Docker documentation](https://docs.docker.com/docker-hub/repos/) for more details.
