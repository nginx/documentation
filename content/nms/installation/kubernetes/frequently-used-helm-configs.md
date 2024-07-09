---
description: ''
docs: DOCS-1275
doctypes:
- task
tags:
- docs
title: Frequently Used Helm Configurations
toc: true
weight: 400
---

## Overview

Choose from the following options to view frequently used configurations for the NGINX Management Suite. To apply any of these configurations, modify the `values.yaml` file accordingly.

{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}

---

## Use Your Own ClickHouse Installation

The NGINX Management Suite requires a [ClickHouse](https://clickhouse.com) database server for storing metrics data. ClickHouse is an open-source, column-based, high-performance analytics database that allows real-time queries on large amounts of data.

The Helm chart installs ClickHouse by default; this setting is enabled in the `values.yaml` file by setting `nms-hybrid.nmsClickhouse.enabled` = `true`.

To use your own ClickHouse installation, take the following steps:

1. Set `nms-hybrid.nmsClickhouse.enabled` = `false`.
2. Add values for `nms-hybrid.externalClickhouse.address`, `.user`, and `.password` matching your ClickHouse installation.

   {{< note >}}`nms-hybrid.externalClickhouse` is required when `nms-hybrid.nmsClickhouse` is disabled.{{</note>}}

---

## Use Your Own Certificates

{{< production >}}
The content in this section is recommended for production deployments.
{{< /production>}}


NGINX Management Suite generates a certificate authority and self-signs its certificates by default.

If you'd like to use your own certificates, take the following steps:

1. Open `values.yaml` for editing.
2. Add the name of a Kubernetes secret to `nms-hybrid.apigw.tlsSecret`. The following fields are required:

   - `tls.crt`
   - `tls.key`
   - `ca.pem`

    Example Kubernetes secret

   ```text
   apiVersion: v1
   kind: Secret
   metadata:
      name: apigw-tls
   type: kubernetes.io/tls
   data:
      tls.crt: |
         LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURXakNDQWtLZ0F3SUJBZ0lRSVBFUFduTXVKRGZWbzVTMHJNaTJuREFOQmdrcWhraUc5dzBCQVFzRkFEQU8KTVF3d0NnWURWUVFERXdOdWJYTXdJQmNOTWpJd05ERXlNakV4TkRFeldoZ1BNakV5TWpBMk1qY3lNVEUwTVROYQpNQlF4RWpBUUJnTlZCQU1UQ1dGd2FXZDNMbTV0Y3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDCkFRb0NnZ0VCQU1CdmxtVzZnWTJrTkx4akswMVVIcGQ4MmJDMkg5SDBmMUgzN21XVmdpV2VYWmYrdnRoaG50WDgKVEk1N0ZwMkNyVDhkZy94NDZGYURHa09pcUs4R0ovbzVmeXBCcG0xSnlKWElGWEdWLzZnbGY3NmxhSzQwUTFTYQpDc04xNUx6YjIrVWxQRVBtSnVtajRHcFlPUldUamVxNEtSZ0M3Z2ZKVVdVQStPVFA4OWJxYmtSRmM2TmRvQTEzCmVyZjl5WWVTV1JTOXRheVFObm1xOElWTDN0Q054TUpLVEJ0b0VPME43WjdPZm9vQWlzSW5UbVFIUGtVb3JXcjcKSnVMUlRuNXAyNmYrMVM2N0syZ29wbWxLNkY4SWlGTEZxSnBidXZQZm1nSkZaaVpFU0Y1RjUwTkxkMzRTZ1M5Ygo4Z1ZkMDdFV3dNVDV3VEVvL1k4N2J1eUowTmJXbDNjQ0F3RUFBYU9CcXpDQnFEQU9CZ05WSFE4QkFmOEVCQU1DCkJhQXdIUVlEVlIwbEJCWXdGQVlJS3dZQkJRVUhBd0VHQ0NzR0FRVUZCd01DTUF3R0ExVWRFd0VCL3dRQ01BQXcKSHdZRFZSMGpCQmd3Rm9BVVhvZi91dHNmQVRuT0owMGhCbjFITUxQUFFVSXdTQVlEVlIwUkJFRXdQNElGWVhCcApaM2VDRFdGd2FXZDNMbTV0Y3k1emRtT0NHMkZ3YVdkM0xtNXRjeTV6ZG1NdVkyeDFjM1JsY2k1c2IyTmhiSWNFCkFBQUFBSWNFZndBQUFUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFWdkdMRlJWRjY1Z2xwNUVHSGlxWnNmNXAKS3pKTXczT0RiTVBmVWMxZWtBZDZDYmY0bVJVbTUzeXRWU045Mk1QbzI2ZUFUdk5sekh6d0RvVE9QMm9PRnVMVApackZDVmt0UThHSGlYYVdDdmtkVnVUZ0FUOWZUTkVhcXdneUpsNVpFOU1DNEtwU0EvbjFLbklkc0lTM04vK2tEClgrNWJZcUlEK0d2aDdYWDZUNFpwYzc2M2p6dzZBSHZaK2ZURER4ZGk1MkQzL0ZWTEplMjQvU3l3TUtwRDhhUjQKcFRwMFlISVBjemdrZUcyQVJ5bWNaV1JmNU04MUpsb3VBbkFMTDVyQUU1RU1ZclRsUDN1WUhyZkkrU2pEVXNoQQp4WUVMZWE2amd6emNvbmZydFMxT0VoQWw4OUZUV1JsUlFrYUtZQk55SzQwMkM1RVB4L0JCRFJZNXZNRStkUT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
      tls.key: |
         LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBd0crV1picUJqYVEwdkdNclRWUWVsM3pac0xZZjBmUi9VZmZ1WlpXQ0paNWRsLzYrCjJHR2UxZnhNam5zV25ZS3RQeDJEL0hqb1ZvTWFRNktvcndZbitqbC9La0dtYlVuSWxjZ1ZjWlgvcUNWL3ZxVm8KcmpSRFZKb0t3M1hrdk52YjVTVThRK1ltNmFQZ2FsZzVGWk9ONnJncEdBTHVCOGxSWlFENDVNL3oxdXB1UkVWegpvMTJnRFhkNnQvM0poNUpaRkwyMXJKQTJlYXJ3aFV2ZTBJM0V3a3BNRzJnUTdRM3RuczUraWdDS3dpZE9aQWMrClJTaXRhdnNtNHRGT2ZtbmJwLzdWTHJzcmFDaW1hVXJvWHdpSVVzV29tbHU2ODkrYUFrVm1Ka1JJWGtYblEwdDMKZmhLQkwxdnlCVjNUc1JiQXhQbkJNU2o5anp0dTdJblExdGFYZHdJREFRQUJBb0lCQVFDRC9VV2ordHVYWWpTRgpybU5xQTdPRDVpK09CQzBwSGRFaVVMTGtYRHJMUUtjamRLaEQxQmxVM2x0SU11YmRIRjlsOWdHc2J1VzFTUEQvCnlSWjREZm5ucC80djVwMlhRazloWkw1SWpVQ3dmUi8wakpHVFF1ZVhwSnlUV2s2TXR5UkpORlAwb215NFBoM1QKOHpVY05udlZyWUVLSmlCTG1PcktJM09UeFlxVE1rRTZydWRTdlJyRHZhS3BPQkVpTExQT0tzZHBwODBIMFZibwpqUlhGT2NucVZDVENTeGpxVStVYnNXREZzVzVKdFJOZEo1UEtSaFE1VXhYV0dIQmNWVm1xLzYwdlVXa1RBTDdDCjJXSnRmSG9ySU9rNmVFcHlSamdBVHZtaVByKzAyS0hFVlAyRzFiZ0xzaUJyQ1RzNWxwWDZ3RzcyYk1JSDNoY2YKSSsyeURzVHhBb0dCQU80aVBSbTlXQTlZL0MyeThFSzd6OHcwUlRhL2ZvTklKTmN6Sm00ZTNMbHk2QUlETVhBMQpOYVpNOVM0d1djc2phaVRHdUU3QXVRMkZuSEgxa3F3a2k2WnBwRFh1eDJwN2pkNUdsakx2bTVUOTJkUEJFMzVMCkhMR1U1R2pXNHRIeE1FbldnMThDLzNpZDBVdnp1RllOWVJBM3ZPNkhpVUE3NlllZHQ5eitudFA1QW9HQkFNN2YKcE9vejU4VjRqTWhSdTZ0RUUwdWZqSXowenJ1eXlmT25lRnByT1JsZGFwTkdKU1g4alM0L0lGaVlwamdQSGprOApIRTU3MnJIMVlJaXhJeG45TmVVdy96NUpCV09hSlh5dkFtSHE0T3Z1SzRHWERvU0hMZWZjUmhlSGJmc09RT2xGCnVHcjRMVSt4TUMvdlM3QnBpUk9uM3dWTVp4T1YzMEFEWjh3R1RNTHZBb0dBQWZWZ0lVVVFZMWZ0QXdjMHVLZkkKeHJvclU0N3hvR3pJZU1pZjZVbnhzTWpFSmJnWEFRQS9CN1ljVWh2dHNTRUNiM2orN1E3aXRyekJrNkpjYVhRSApmZi9pYk5zZzRyeFBaMk9YT3FZRDFvN2I2c1Rzdng0cEIwRGRQQXVBWkEraXdRaTFuZU50YkhXSDBpTVlBZ1VzCkpqRC9LY3NOa3V5ck9BVlJETTAvU3lrQ2dZQTlKWGVPVGhkRWsvUXd4WS9OK0lvbmdSby9FNkVEYzc0amlhMlcKTkRrbFdTcEdLNmFSU3N2RURwNlY4VkM0SXlmUXpRYWs0QkR0SnRVSXNpcm81S0lJZzJuK1ZBRUd4cW9yNTJLeAo1SVhrMW5uL2pOR2F0SVlLRVY2YVY4cFhPWWhRS3U1dWw3cDA0cStXaTRsNHRFanpDVnh2S1gwU0dldHA5VmU1CncyYnUrd0tCZ0RXZlFZLzBRcW02Z0VacDMybDdXbjRWT3JvMVBBS3JuU1g2cHFSejVTekF3UVlTYnMvZ2h5d3MKYUIrVG1vWmVkcTlsc1hvUmtLVjlFYkQxTldYa2tHZ05sWmRRQ1l0Y2lDdm9jczYvbmYzemFZTXZENlhGWEhQSApzNXliM3BHcDdhMlpDeFJJR1NkcUxXWjExRW5nRjhwWGMxOUpWNHB4UndzazRrZ3RvMzRvCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
      ca.pem: |
         LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDVENDQWZHZ0F3SUJBZ0lRVFVEVTlNY3puWUZObHJwMDdrSGtWREFOQmdrcWhraUc5dzBCQVFzRkFEQU8KTVF3d0NnWURWUVFERXdOdWJYTXdJQmNOTWpJd05ERXlNakV4TkRFeldoZ1BNakV5TWpBMk1qY3lNVEUwTVROYQpNQTR4RERBS0JnTlZCQU1UQTI1dGN6Q0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCCkFNQWdUVUlvZjZTUnpMTmg2SnlUTTJEazU4VzJvT0dyQUtJS0dHcnJaaWZMSno4V21WNk1jb0RMNU9jdSs1YlIKdk9HMHlOdWdxaWQ0YmhuVHlNWnhlR3p1T09TZ2VSTzA3bE9SNUJCczFDRUFidEtuSUh2d1J2aDRGUXBnbmQvTAo1ek1ZN1FFN0N4TjBXSFRBYWR1Q1M0NEZSVkFkdzVXRzQ5YVFVd3VCajlqRlNlbCtVemxQdkExWGFBTWRrSkF0CktmTDRUY3FuK1JDR2FrYWI3aUg3b25zMHFZdDFTSlJuOENzdFFvbGJ2aXduM2VKTzRtVTFnY1hxRnV6N2ZLZGUKMjk4V3FNaG94NHJib2hTWFlUSXBYTWtMOHhBNU1TeE5WZ1NIM09heDN5ZWpzYy9NZnpjMHA0bEYxVDBLamZJWgpEcjUwL1Z2QXNZc2lUbWF5UktUeU13MENBd0VBQWFOaE1GOHdEZ1lEVlIwUEFRSC9CQVFEQWdLa01CMEdBMVVkCkpRUVdNQlFHQ0NzR0FRVUZCd01CQmdnckJnRUZCUWNEQWpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWQKRGdRV0JCUmVoLys2Mng4Qk9jNG5UU0VHZlVjd3M4OUJRakFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBRmZ5VgpKakptTHcxYzR2ejg2ME12UXpiejZFK0p6NnhmbW5VZHlleEZnQ1Q4Nm1YbCticlNZRjRodS9uOFRicXEzTFRuClFKZlR2a2JUamoydmhyUHdERnVtbXBXQmt1WVVKN2tmN2tpa24rYlkzQnh2OUIyR2x2UDJSWEhhd3pzejdMM1kKVHRRSlExS01IVFpIa0xYRWNDRVdES2dtNEVVK2JRNlBydm5meGk5VlVicHpBc051SU9MMklsUVl0RUxCOEJOYwpsREtLQjBJYVk0TTdmTTkrMjhXVkkyRVJjblJETTAycjVZMXkxaUNvTDZ3TVVuL0FHRjluVU1tZTREcWpLUEVXCnRveGliYmZRUHdaUy9sWmVCV1lpRlo0MVNINGZaeURUVHJVY3lsVk9DU3AzdVAyYlpYM3N0MVl2VGlKS2hxL0MKMUlETWhuWDBiMWhYY1Z5YnhnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
   ```

---

## Adjust storage settings or disable persistent storage


Review the deployment's default resource and storage settings by editing the `values.yaml` file in the helm package you downloaded. Adjust the values to meet your data needs.

Persistent volumes are enabled by default for the ClickHouse database server and `nms-hybrid.core` and `nms-hybrid.dpm` services. To disable persistent storage for a configuration, set `nms-hybrid.persistence.enable` = `false`.

---

## Use NGINX Plus for API Gateway

To use NGINX Plus for the API Gateway, take the following steps:

1. Build your own Docker image for NGINX Plus API Gateway by providing your `nginx-repo.crt` and `nginx-repo.key`. Download the certificate (nginx-repo.crt) and key (nginx-repo.key) from the [MyF5 website](https://my.f5.com) and add them to your build context.

    You can use the following example Docker image and the instructions within it. In this example, we use `apigw:<version>` as the base image, obtained when we completed the [Downloaded and extracted the Helm package]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md#download-helm-package" >}}), which we've extended to use NGINX Plus instead of NGINX OSS.

    <br>

    **Example Docker image**

    ```shell
    # syntax=docker/dockerfile:1

    # NGINX PLUS API-GW
    # NOTE:
     # NMS does not publish this Docker image and are only instructions on how to build API-GW with NGINX-PLUS
     # This docker build should be performed by customer using their own nginx-repo.crt and nginx-repo.key
     # API-GW with NGINX-PLUS to enable OIDC.

     # Download NMS api gateway docker image from MyF5 Downloads, https://docs.nginx.com/nginx-management-suite/installation/helm-chart/
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

    # Remove any previous version of nginx
    RUN apk del nginx*

    # Download certificate and key from the customer portal (https://cs.nginx.com)
    # and copy to the build context
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
    # Bring in tzdata so users could set the timezones through the environment
    # variables
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

   - Replace `<version>` with the tag you noted when following the steps to [Load the Docker Images]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md#load-docker-images" >}}).

3. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry>/nms-apigw-plus:<version>
   ```

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when following the steps to [Load the Docker Images]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md#load-docker-images" >}}).

4. Edit the `values.yaml` file to configure the Helm chart to pull the `apigw` image from your private Docker registry:

   For NGINX Plus, edit the `values.yaml` file and add the following settings:

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

    This configuration specifies the name of the secret that should be used for pulling images (`regcred`) and configures the `apigw` image to be pulled from the `<my-docker-registry>/nms-apigw-plus` repository with the specified version tag.


