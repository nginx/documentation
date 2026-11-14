---
title: Frequently used Helm configurations
toc: true
weight: 400
f5-content-type: how-to
f5-product: NGINX Instance Manager
description: "Common Helm chart configuration examples for F5 NGINX Instance Manager, covering ingress, persistence, resource limits, and other frequently needed settings."
f5-summary: >
  Apply common Helm chart configurations for F5 NGINX Instance Manager by modifying the values.yaml file.
  This guide covers the most frequently needed settings, including ingress configuration, persistent storage, and resource limits.
---

## Overview

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

This guide provides frequently used configurations for F5 NGINX Instance Manager. To apply any of these configurations, modify the `values.yaml` file accordingly.

Refer to [Configurable Helm settings]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md" >}}) for chart parameters, defaults, and version-specific limitations.

---

## Use your own ClickHouse installation

NGINX Instance Manager uses [ClickHouse](https://clickhouse.com) to store metrics. Lightweight mode doesn't use ClickHouse and doesn't collect metrics.

By default, the Helm chart installs ClickHouse, which is enabled in the `values.yaml` file by setting `nmsClickhouse.mode` to `internal`.

For chart 2.3.1, use these settings to connect to your own ClickHouse server:

```yaml
nmsClickhouse:
  mode: external
externalClickhouse:
  address: "<CLICKHOUSE_HOST>:<PORT>"
  auth:
    username: "<CLICKHOUSE_USER>"
    existingSecret: "<CLICKHOUSE_PASSWORD_SECRET>"
    existingSecretKey: "<PASSWORD_KEY>"
```

Replace `<CLICKHOUSE_HOST>` and `<PORT>` with the server address and native protocol port. Replace `<CLICKHOUSE_USER>` with your ClickHouse username.

Create the password Secret in the deployment namespace before installation. Replace `<CLICKHOUSE_PASSWORD_SECRET>` with its name and `<PASSWORD_KEY>` with the key that contains the password.

Alternatively, set `externalClickhouse.auth.password` and leave both existing-Secret settings empty. The older `externalClickhouse.user` and `externalClickhouse.password` paths don't apply to chart 2.3.1.

`externalClickhouse.address` is required only when `nmsClickhouse.mode` is `external`. It isn't required when the mode is `disabled`.

---

## Use your own certificates

{{< production >}}
This section is recommended for production deployments.
{{< /production >}}

By default, NGINX Instance Manager generates a self-signed certificate authority (CA) and all required TLS certificates. For production, you can supply your own certificates instead.

The Bring Your Own Certificates (BYOC) feature lets you replace certificates for any or all NIM services — including individual service mTLS certificates and the API Gateway's external HTTPS certificate.

For full instructions, see [Use external TLS certificates]({{< ref "/nim/deploy/kubernetes/configure-external-certs.md" >}}).

---

## Adjust storage settings or disable persistent storage

You can review and adjust the deployment's default resource and storage settings by editing the `values.yaml` file in the Helm package you downloaded. Adjust the values to meet your data needs.

Persistent storage is on by default for internal ClickHouse and the `core`, `dpm`, and `integrations` services. Set `<SERVICE>.persistence.enabled` to `false` to turn it off. Replace `<SERVICE>` with `nmsClickhouse`, `core`, `dpm`, or `integrations`.

See the [storage examples]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md#nim-dqlite-storage-configuration" >}}) for service-specific claim sizes. Include the complete claim array when you override it.

---

## Use NGINX Plus for API Gateway

To use NGINX Plus for the API Gateway, follow these steps:

1. Build your own Docker image for the NGINX Plus API Gateway by providing your `nginx-repo.crt` and `nginx-repo.key`. Download the certificate and key from the [MyF5 website](https://my.f5.com) and add them to your build context.

   Use the following example Dockerfile to build the image. In this example, we use `apigw:<VERSION>` as the base image, which you obtained when you [downloaded the Helm package]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#download-helm-package" >}}).

   **Example Dockerfile:**

   ```dockerfile
   # syntax=docker/dockerfile:1
   
   # NGINX PLUS API-GW
   # NOTE:
   # NMS does not publish this Docker image and these are only instructions on how to build API-GW with NGINX-PLUS.
   # This Docker build should be performed by the customer using their own nginx-repo.crt and nginx-repo.key.
   # API-GW with NGINX-PLUS is needed to enable OIDC.

   # Download NMS API gateway Docker image from MyF5 Downloads, https://docs.nginx.com/nginx-management-suite/installation/helm-chart/
   # Replace "apigw:<VERSION>" with a known release tag.
   # For example: apigw:2.6.0
   
   FROM apigw:<VERSION> as apigw-plus
   
   ARG REPO_PATH=.
   
   # Define NGINX versions for NGINX Plus and NGINX Plus modules
   # Uncomment this block and the versioned nginxPackages in the main RUN
   # instruction to install a specific release
   # ENV NGINX_VERSION 21
   # ENV NJS_VERSION   0.3.9
   # ENV PKG_RELEASE   1
   
   USER root
   
   # Replace the OSS nginx packages from the base image with NGINX Plus and njs.
   RUN apk del nginx*
   
   COPY ${REPO_PATH}/nginx-repo.crt /etc/apk/cert.pem
   COPY ${REPO_PATH}/nginx-repo.key /etc/apk/cert.key
   
   RUN set -x \
       && nginxPackages=" \
           nginx-plus \
           nginx-plus-module-njs \
       " \
       && KEY_SHA512="de7031fdac1354096d3388d6f711a508328ce66c168967ee0658c294226d6e7a161ce7f2628d577d56f8b63ff6892cc576af6f7ef2a6aa2e17c62ff7b6bf0d98 *stdin" \
       && apk add --no-cache --virtual .cert-deps \
           openssl \
       && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
       && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
           echo "key verification succeeded!"; \
           mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
       else \
           echo "key verification failed!"; \
           exit 1; \
       fi \
       && apk del .cert-deps \
       && apk add -X "https://pkgs.nginx.com/plus/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
       && rm -f /etc/nginx/conf.d/default.conf \
       && rm -f /etc/apk/keys/nginx_signing.rsa.pub /etc/apk/cert.key /etc/apk/cert.pem
   
   # Restore writable paths needed by nginx when running as a non-root user.
   RUN mkdir -p \
           /var/cache/nginx/client_temp \
           /var/cache/nginx/proxy_temp \
           /var/cache/nginx/fastcgi_temp \
           /var/cache/nginx/uwsgi_temp \
           /var/cache/nginx/scgi_temp \
           /var/log/nginx && \
          chown -R 101:0 /var/cache/nginx /var/log/nginx && \
          chmod -R g+rwX /var/cache/nginx /var/log/nginx && \
          chmod -R g+s /var/cache/nginx /var/log/nginx

   USER nginx
   
   CMD ["nginx", "-g", "daemon off;"]
   
   # vim:syntax=Dockerfile
   ```

2. Tag the Docker image:

   ```shell
   docker tag apigw-plus <MY_DOCKER_REGISTRY>/nms-apigw-plus:<VERSION>
   ```

   - Replace `<MY_DOCKER_REGISTRY>` with your private Docker registry.
   - Replace `<VERSION>` with the version tag.

3. Push the image to your private registry:

   ```shell
   docker push <MY_DOCKER_REGISTRY>/nms-apigw-plus:<VERSION>
   ```

4. Edit the `values.yaml` file to configure the Helm chart to pull the `apigw` image from your private Docker registry:

   ```yaml
   # values.yaml
   imagePullSecrets:
       - name: regcred
   apigw:
       image:
           repository: <MY_DOCKER_REGISTRY>/nms-apigw-plus
           tag: <VERSION>
   ```

This configuration specifies the name of the secret that should be used for pulling images (`regcred`) and configures the `apigw` image to be pulled from your private Docker registry.
