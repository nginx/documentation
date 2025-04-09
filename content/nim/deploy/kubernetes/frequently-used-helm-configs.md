---
docs: DOCS-1275
title: Frequently used Helm configurations
toc: true
weight: 400
type:
- how-to
---

## Overview

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

This guide provides frequently used configurations for NGINX Instance Manager. To apply any of these configurations, modify the `values.yaml` file accordingly.

Refer to the [configurable Helm settings]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md" >}}) guide for a complete list of configurable parameters and default values used by NGINX Instance Manager and its modules when installing from a Helm chart.

---

## Use your own ClickHouse installation

NGINX Instance Manager requires a [ClickHouse](https://clickhouse.com) database server for storing metrics data. ClickHouse is an open-source, column-based, high-performance analytics database that allows real-time queries on large amounts of data.

By default, the Helm chart installs ClickHouse, which is enabled in the `values.yaml` file by setting `nms-hybrid.nmsClickhouse.enabled` to `true`.

To use your own ClickHouse installation, follow these steps:

1. Set `nms-hybrid.nmsClickhouse.enabled` to `false`.
2. Add values for `nms-hybrid.externalClickhouse.address`, `.user`, and `.password` that match your ClickHouse installation.

   {{< note >}}The `nms-hybrid.externalClickhouse` field is required when `nms-hybrid.nmsClickhouse` is disabled.{{</ note >}}

---

## Use your own certificates

{{< production >}}
This section is recommended for production deployments.
{{< /production >}}

NGINX Instance Manager generates a certificate authority and self-signs its certificates by default.

To use your own certificates, follow these steps:

1. Open `values.yaml` for editing.
2. Add the name of a Kubernetes secret to `nms-hybrid.apigw.tlsSecret`. The following fields are required:

   - `tls.crt`
   - `tls.key`
   - `ca.pem`

   **Example Kubernetes secret:**

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
      name: apigw-tls
   type: kubernetes.io/tls
   data:
      tls.crt: |
         <base64-encoded-certificate>
      tls.key: |
         <base64-encoded-key>
      ca.pem: |
         <base64-encoded-ca>
   ```

---

## Adjust storage settings or disable persistent storage

You can review and adjust the deployment's default resource and storage settings by editing the `values.yaml` file in the Helm package you downloaded. Adjust the values to meet your data needs.

Persistent volumes are enabled by default for the ClickHouse database server and the `nms-hybrid.core` and `nms-hybrid.dpm` services. To disable persistent storage for a configuration, set `nms-hybrid.persistence.enabled` to `false`.

---

## Use NGINX Plus for API Gateway

To use NGINX Plus for the API Gateway, follow these steps:

1. Build your own Docker image for the NGINX Plus API Gateway by providing your `nginx-repo.crt` and `nginx-repo.key`. Download the certificate and key from the [MyF5 website](https://my.f5.com) and add them to your build context.

   Use the following example Dockerfile to build the image. In this example, we use `apigw:<version>` as the base image, which you obtained when you [downloaded the Helm package]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#download-helm-package" >}}).

   **Example Dockerfile:**

   ```dockerfile
   # syntax=docker/dockerfile:1

   # NGINX PLUS API-GW
   # NOTE:
   # NMS does not publish this Docker image and these are only instructions on how to build API-GW with NGINX-PLUS.
   # This Docker build should be performed by the customer using their own nginx-repo.crt and nginx-repo.key.
   # API-GW with NGINX-PLUS is needed to enable OIDC.

   # Download NMS API gateway Docker image from MyF5 Downloads, https://docs.nginx.com/nginx-management-suite/installation/helm-chart/
   # Replace "apigw:<version>" with a known release tag.
   # For example: apigw:2.6.0

   FROM apigw:<version> as apigw-plus

   ARG REPO_PATH=.

   # Define NGINX versions for NGINX Plus and NGINX Plus modules
   # Uncomment this block and the versioned nginxPackages in the main RUN
   # instruction to install a specific release
   # ENV NGINX_VERSION 21
   # ENV NJS_VERSION   0.3.9
   # ENV PKG_RELEASE   1

   # Remove any previous version of NGINX
   RUN apk del nginx*

   # Download certificate and key from the customer portal (https://cs.nginx.com)
   # and copy them to the build context
   COPY ${REPO_PATH}/nginx-repo.crt /etc/apk/cert.pem
   COPY ${REPO_PATH}/nginx-repo.key /etc/apk/cert.key

   RUN set -x \
   # Install the latest release of NGINX Plus and/or NGINX Plus modules
   # Uncomment individual modules if necessary
   # Use versioned packages over defaults to specify a release
      && nginxPackages=" \
          nginx-plus \
          # nginx-plus=${NGINX_VERSION}-${PKG_RELEASE} \
          nginx-plus-module-njs \
          # nginx-plus-module-lua \
          # nginx-plus-module-xslt \
          # nginx-plus-module-xslt=${NGINX_VERSION}-${PKG_RELEASE} \
          # nginx-plus-module-geoip \
          # nginx-plus-module-geoip=${NGINX_VERSION}-${PKG_RELEASE} \
          # nginx-plus-module-image-filter \
          # nginx-plus-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE} \
          # nginx-plus-module-perl \
          # nginx-plus-module-perl=${NGINX_VERSION}-${PKG_RELEASE} \
          # nginx-plus-module-njs=${NGINX_VERSION}.${NJS_VERSION}-${PKG_RELEASE} \
      " \
      KEY_SHA512="de7031fdac1354096d3388d6f711a508328ce66c168967ee0658c294226d6e7a161ce7f2628d577d56f8b63ff6892cc576af6f7ef2a6aa2e17c62ff7b6bf0d98 *stdin" \
      && apk add --no-cache --virtual .cert-deps \
          openssl vim \
      && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
      && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
          echo "key verification succeeded!"; \
          mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
      else \
          echo "key verification failed!"; \
          exit 1; \
      fi \
      && apk del .cert-deps \
      && apk add -X "https://plus-pkgs.nginx.com/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
      && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
      && if [ -n "/etc/apk/cert.key" && -n "/etc/apk/cert.pem"]; then rm -f /etc/apk/cert.key /etc/apk/cert.pem; fi \
   # Bring in gettext so we can get `envsubst`, then throw
   # the rest away. To do this, we need to install `gettext`
   # then move `envsubst` out of the way so `gettext` can
   # be deleted completely, then move `envsubst` back.
      && apk add --no-cache --virtual .gettext gettext \
      && mv /usr/bin/envsubst /tmp/ \
      \
      && runDeps="$( \
          scanelf --needed --nobanner /tmp/envsubst \
              | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
              | sort -u \
              | xargs -r apk info --installed \
              | sort -u \
      )" \
      && apk add --no-cache $runDeps \
      && apk del .gettext \
      && mv /tmp/envsubst /usr/local/bin/ \
   # Bring in tzdata so users can set timezones through environment variables
      && apk add --no-cache tzdata \
   # Bring in curl and ca-certificates to make registering on DNS SD easier
      && apk add --no-cache curl ca-certificates \
   # Forward request and error logs to Docker log collector
      && ln -sf /dev/stdout /var/log/nginx/access.log \
      && ln -sf /dev/stderr /var/log/nginx/error.log

   CMD ["nginx", "-g", "daemon off;"]

   # vim:syntax=Dockerfile
   ```

2. Tag the Docker image:

   ```shell
   docker tag apigw-plus <my-docker-registry>/nms-apigw-plus:<version>
   ```

   - Replace `<my-docker-registry>` with your private Docker registry.
   - Replace `<version>` with the version tag.

3. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry>/nms-apigw-plus:<version>
   ```

4. Edit the `values.yaml` file to configure the Helm chart to pull the `apigw` image from your private Docker registry:

   ```yaml
   # values.yaml
   nms-hybrid:
       imagePullSecrets:
           - name: regcred
       apigw:
           image:
               repository: <my-docker-registry>/nms-apigw-plus
               tag: <version>
   ```

This configuration specifies the name of the secret that should be used for pulling images (`regcred`) and configures the `apigw` image to be pulled from your private Docker registry.
