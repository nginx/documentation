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

Refer to the [configurable Helm settings]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md" >}}) guide for a complete list of configurable parameters and default values used by NGINX Instance Manager and its modules when installing from a Helm chart.

---

## Use your own ClickHouse installation

NGINX Instance Manager requires a [ClickHouse](https://clickhouse.com) database server for storing metrics data. ClickHouse is an open-source, column-based, high-performance analytics database that allows real-time queries on large amounts of data.

By default, the Helm chart installs ClickHouse, which is enabled in the `values.yaml` file by setting `nmsClickhouse.mode` to `internal`.

To use your own ClickHouse installation, follow these steps:

1. Set `nmsClickhouse.mode` to `external`.
2. Add values for `externalClickhouse.address`, `.user`, and `.password` that match your ClickHouse installation.

   {{< call-out class="note" >}}The `externalClickhouse` field is required when `nmsClickhouse.mode` is disabled.{{< /call-out >}}

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

Persistent volumes are on by default for the ClickHouse database server and the `core` and `dpm` services. To turn off persistent storage, set `<SERVICE>.persistence.enabled` to `false`, where `<SERVICE>` is the service name, such as `core` or `dpm`.

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
# NGINX Instance Manager does not publish this Docker image and these are
# instructions on how to build API-GW with NGINX Plus.
# This Docker build should be performed by the customer using their own
# nginx-repo.crt and nginx-repo.key.
# API-GW with NGINX Plus and the njs module is needed to enable OIDC.

# Replace "apigw:<VERSION>" with a known release tag.
# For example: apigw:2.6.0

FROM apigw:<VERSION> as apigw-plus

ARG REPO_PATH=.

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
