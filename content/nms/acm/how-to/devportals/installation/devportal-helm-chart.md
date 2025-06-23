---
description: Follow the steps in the guide to deploy the API Connectivity Manager
  Developer Portal to Kubernetes using a Helm chart.
nd-docs: DOCS-1110
title: Deploy the Developer Portal from a Helm chart
toc: true
weight: 20
type:
- tutorial
---

{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Overview

Follow the steps in this section to install, upgrade, or uninstall the API Connectivity Manager Developer Portal on Kubernetes using Helm.

---

## Before You Begin

To complete the steps in this section, you need the following:

- A working knowledge of Docker and how to build and extend containers
- An installed, licensed, and running version of API Connectivity manager
- A installed version of Helm v3.10.0 or newer
- An [externally-accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to
- Your F5 NGINX Plus certificate and key files, which you can download from [MyF5](https://my.f5.com/manage/s/)

{{< call-out "note" >}}

- Take a few minutes to review the [Configurable Helm Settings](#configuration-options) at the end of this topic. You can change these settings to customize your installation to meet your needs.

- Check out the [Deployment Patterns for Developer Portal]({{< ref "/nms/acm/how-to/infrastructure/configure-devportal-backend.md" >}}) topic if you're considering installing the Developer Portal on a single host or on a cluster for high availability.

{{< /call-out>}}

---

## Download the Developer Portal Container Images {#download-devportal-api-image}

1. On the [MyF5 website](https://my.f5.com/manage/s/downloads), select **Resources > NGINX Downloads**.
2. In the NGINX products list, select **NGINX API Connectivity Manager**.
3. Select the following download options. Pick the version that you require; in this guide, we've chosen 1.3.0 as an example:

    **Product version:** 1.3.0
    **Linux distribution:** Ubuntu
    **Distribution Version:** 20.04
    **Architecture:** amd64

4. Download the `nginx-devportal-api-<version>-img.tar.gz` file.
5. Download the `nginx-devportal-apigw-<version>-img.tar.gz` file.
   {{< call-out "note" >}}
   If you require a version of NGINX Plus other than what is provided, please see the optional section on [building the API Gateway Container Image](#build-apigw-docker-image).
   {{< /call-out >}}

---

## Load Docker Images {#load-docker-image}

1. Change to the directory where you downloaded the Docker images:

   ``` shell
   cd <directory name>
   ```

2. Load the Docker image:

   ``` shell
   docker load -i nginx-devportal-api-<version>-img.tar.gz
   docker load -i nginx-devportal-apigw-<version>-img.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nginx-devportal-api-<version>-img.tar.gz
   f4373956a745: Loading layer [==================================================>]  2.171MB/2.171MB
   95de16926adc: Loading layer [==================================================>]  15.62MB/15.62MB
   Loaded image: nginx-devportal-api:1.5.0
   $ docker load -i nginx-devportal-apigw-<version>-img.tar.gz
   0e2737d1d5b7: Loading layer [==================================================>]  1.097MB/1.097MB
   2b64694bf95f: Loading layer [==================================================>]  83.19MB/83.19MB
   1e8cac41ce82: Loading layer [==================================================>]   2.56kB/2.56kB
   Loaded image: nginx-devportal-apigw:1.5.0-r28
   ```

   {{< call-out "important" >}}
   Take note of the loaded image's name and tag.  You'll need to reference this information in the next section when pushing the image to your private registry.

   In the example output above, `nginx-devportal-api` is the image name and `1.5.0` is the tag for the first image. For the second image `nginx-devportal-apigw` is the image name and `1.5.0-r28` is the tag (where `1.5.0` is the release version and `r28` is the NGINX Plus version). The image names or tags could be different depending on the product version you downloaded from MyF5.
   {{< /call-out >}}

### (Optional) Build the API Gateway Container Image {#build-apigw-docker-image}
   {{< call-out "note" >}}
   This is step is only required for versions of API Connectivity Manager Developer Portal prior to `1.5.0` or if you require a specific release of NGINX Plus that is not provided on MyF5.
   {{< /call-out >}}
   <details closed>
   <summary><i class="fa-solid fa-circle-info"></i> Build the API Gateway Container Image</summary>
   The Developer Portal Helm chart requires a container image that includes the NGINX Plus service and NGINX Agent in order to deploy the chart and have the API Gateway register with the API Connectivity Manager control plane.

In this example, we use Ubuntu (focal), but other supported distributions can be used.

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

</details>

Create a Dockerfile similar to the following example:

1. Create a Dockerfile similar to the following example:

    <details closed>
    <summary><i class="fa-solid fa-circle-info"></i> Example Dockerfile</summary>

    {{< icon "download" >}} {{< link "/acm/containers/devportal/Dockerfile" "Download example Dockerfile" >}}

    ```Dockerfile
    FROM ubuntu:focal

    # NGINX Plus release e.g 27
    ARG NGINX_PLUS_VERSION

    # DEVPORTAL release e.g 1.3.0
    ARG DEVPORTAL_UI_VERSION

    ARG CONTROL_PLANE_IP

    # Install NGINX Plus
    RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
        --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        curl \
        gnupg \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        procps \
    && \
    NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    for server in \
        hkp://keyserver.ubuntu.com:80 \
        pgp.mit.edu; do \
        echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
        gpg --keyserver "$server" \
            --recv-keys "$NGINX_GPGKEY" \
            && break; \
    done \
    # Configure APT repos
    && gpg --export "$NGINX_GPGKEY" > /etc/apt/trusted.gpg.d/nginx.gpg \
    && printf "Acquire::https::pkgs.nginx.com::SslCert \"/etc/ssl/nginx/nginx-repo.crt\";\n" >> /etc/apt/apt.conf.d/90pkgs-nginx \
    && printf "Acquire::https::pkgs.nginx.com::SslKey  \"/etc/ssl/nginx/nginx-repo.key\";\n" >> /etc/apt/apt.conf.d/90pkgs-nginx \
    && printf "deb https://pkgs.nginx.com/plus/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb https://pkgs.nginx.com/nms/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nms.list \
    && apt-get update \
    # Install NGINX Plus & agent\
    && apt-get install -y \
            nginx-plus=${NGINX_PLUS_VERSION}* \
            nginx-plus-module-njs=${NGINX_PLUS_VERSION}* \
            nginx-devportal-ui=${DEVPORTAL_UI_VERSION}* \
    && curl --insecure https://$CONTROL_PLANE_IP/install/nginx-agent | PACKAGE_HOST=${CONTROL_PLANE_IP} sh \
    # Forward request and error logs to docker log collector \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Cleanup \
    && apt-get autoremove --purge -y \
        curl \
        gnupg \
        apt-transport-https \
        lsb-release \
    && rm -rf /root/.gnupg \
    && rm -rf /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nms.list /etc/apt/apt.conf.d/90pkgs-nginx \
    && rm -rf /var/lib/apt/lists/*

    COPY /entrypoint.sh /

    STOPSIGNAL SIGTERM

    CMD bash /entrypoint.sh
    ```

    <br>

    </details>

2. Add an `entrypoint.sh` file similar to the following example to the same directory where you added the Dockerfile:

    <details closed>
      <summary><i class="fa-solid fa-circle-info"></i> Example entrypoint.sh</summary>

    {{< icon "download" >}} {{< link "/acm/containers/devportal/entrypoint.sh" "Download example entrypoint.sh file" >}}

    ```bash
    #!/bin/bash

    set -euxo pipefail

    handle_term()
    {
        echo "received TERM signal"
        echo "stopping nginx-agent ..."
        kill -TERM "${agent_pid}" 2>/dev/null
        echo "stopping nginx ..."
        kill -TERM "${nginx_pid}" 2>/dev/null
    }

    trap 'handle_term' TERM

    if [ -z "${CONTROL_PLANE_IP}" ]; then
        echo "ERROR CONTROL_PLANE_IP environment variable needs to be set."
        exit 1
    fi

    if [ -z "${INSTANCE_GROUP}" ]; then
        echo "ERROR INSTANCE_GROUP environment variable needs to be set."
        exit 1
    fi

    # Launch nginx
    echo "starting nginx ..."
    nginx -g "daemon off;" &

    nginx_pid=$!

    # start nginx-agent, pass args
    echo "starting nginx-agent ..."
    nginx-agent --instance-group "${INSTANCE_GROUP}" --server-host "${CONTROL_PLANE_IP}" &

    agent_pid=$!

    wait_term()
    {
        wait ${agent_pid}
        trap - TERM
        kill -QUIT "${nginx_pid}" 2>/dev/null
        echo "waiting for nginx to stop..."
        wait ${nginx_pid}
    }

    wait_term

    echo "nginx-agent process has stopped, exiting."
    ```

    <br>

    </details>

3. Add your NGINX Plus certificate and key files to the same directory as the Dockerfile. You can download these files from the [MyF5](https://my.f5.com/manage/s/) site.

4. Build the Dockerfile and specify the following settings:

   - `CONTROL_PLANE_IP`: The IP address or hostname of your API Connectivity Manager control plane host
   - `NGINX_PLUS_VERSION`: The version of NGINX Plus that you want to use; for example, `28`
   - `DEVPORTAL_UI_VERSION`: The version of the Developer Portal UI that you want to use; for example, `1.5.0`

    ```bash
    export CONTROL_PLANE_IP=<NGINX-INSTANCE-MANAGER-FQDN>
    export NGINX_PLUS_VERSION=<NGINX-PLUS-VERSION>
    export DEVPORTAL_UI_VERSION=<ACM-VERSION>
    export DEVPORTAL_UI_TAG=${DEVPORTAL_UI_VERSION}-r${NGINX_PLUS_VERSION}
    export DOCKER_BUILDKIT=1
    docker build \
      -t nginx-devportal-apigw:$DEVPORTAL_UI_TAG \
      --build-arg CONTROL_PLANE_IP \
      --build-arg NGINX_PLUS_VERSION \
      --build-arg DEVPORTAL_UI_VERSION \
      --secret id=nginx-crt,src=nginx-repo.crt \
      --secret id=nginx-key,src=nginx-repo.key \
      .
    ```

   </details>

---

## Push Images to Private Registry {#push-images-private-registry}

{{<before-you-begin>}}To complete this step, you need an [externally-accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to.{{</before-you-begin>}}

After building or loading the Docker images, you can now tag and push the images to your private Docker registry. Replace `<my-docker-registry>` in the examples below with the path to your private Docker registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry>
   ```

2. Tag the images with the values you noted when completing the [Load Docker Images](#load-docker-image) steps above.

   ```shell
   docker tag nginx-devportal-apigw:<version> <my-docker-registry>/nginx-devportal-apigw:<version>
   docker tag nginx-devportal-api:<version> <my-docker-registry>/nginx-devportal-api:<version>
   ```

3. Push the images to your private registry:

   ```shell
   docker push <my-docker-registry>/nginx-devportal-apigw:<version>
   docker push <my-docker-registry>/nginx-devportal-api:<version>
   ```

---

## Add Helm Repository {#add-helm-repository}

Run the following commands to install the NGINX Management Suite chart from the Helm repository:

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

The first command, `helm repo add nginx-stable https://helm.nginx.com/stable`, adds the `nginx-stable` repository to your local Helm repository list. This repository contains the Helm charts for deploying NGINX Management Suite.

The second command, `helm repo update`, updates the local Helm repository list with the newest versions of the charts from the `nginx-stable` repository. This command ensures you have the most up-to-date version of the charts available for installation.

---

## Configure Chart to Pull from Private Docker Registry {#configure-chart}

A Helm `values.yaml` file is a configuration file you can use to customize the installation of a Helm chart without actually editing the chart itself, allowing for faster and more efficient deployments. Values can be used to specify different image repositories and tags, set environment variables, configure resource requests and limits, and more.

1. Create a `values.yaml` file similar to the following example. This file is used to customize the configuration of the NGINX Developer Portal chart located in the `nginx-stable` Helm repository that you [added above](#add-helm-repository).

    ```yaml
   # values.yaml
   imagePullSecrets:
     - name: regcred
   apigw:
     acmService:
       enabled: true
       type: LoadBalancer
     image:
       repository: <my-docker-registry>/nginx-devportal-apigw
       tag: <version>
     controlPlane:
       host: <my-control-plane-host>
       instanceGroup: <my-instance-group>
     service:
       type: LoadBalancer
   api:
     image:
       repository: <my-docker-registry>/nginx-devportal-api
       tag: <version>
     db:
       type: <database-type>
     acm:
       client:
         caSecret:
           name: acm-tls
           key: ca.crt

    ```

    - Replace `<my-docker-registry>` with your private Docker registry.
    - Replace `<version>` with the tag you used when [pushing the images to your private registry](#push-images-private-registry).
    - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

   {{< call-out "note" >}}The contents of `api.acm.client.caSecret.key` can be obtained from the `/etc/nms/certs/apigw/ca.pem` on the control plane.{{< /call-out >}}

    This `values.yaml` file specifies the Docker images to be used for the NGINX Developer Portal `apigw` and `api` components, including the repository (`<my-docker-registry>`) and tag (`version`) of each image. It also specifies that a secret called `regcred` should be used for image pulls.

    {{< call-out "note" >}}For instructions on creating a secret, see the Kubernetes topic [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).{{< /call-out>}}

2. Save and close the `values.yaml` file.

## Install the Chart

The Developer Portal does not require (although it is recommended) a dedicated namespace for the data plane. You can create this namespace yourself, or you can allow Helm to create it for you by using the `--create-namespace` flag when installing.

{{< call-out "note" >}}
If persistent storage is not configured in your cluster, set the `apigw.persistence.enabled` and `api.persistence.enabled` values to `false` either in the values file or using the `--set` helm commands.
{{< /call-out >}}

To install the chart with the release name `devportal` and namespace `devportal`, run the following command:

```bash
helm install devportal nginx-stable/nginx-devportal --namespace devportal --create-namespace -f <path-to-your-values.yaml> [--version <desired-version>] --wait
```

---

## Upgrade the Chart {#upgrade-the-chart}

You can upgrade to the latest Helm chart from the version immediately before it. For example, you can upgrade from v1.3.0 to v1.3.1.

### Upgrade the Release

To upgrade the release `devportal` in the `devportal` namespace, run the following command:

```bash
helm upgrade devportal nginx-stable/nginx-devportal --namespace devportal -f <path-to-your-values.yaml> [--version <desired-version>] --wait
```

### Change Configuration Options

You can use the `helm upgrade` command to change or apply additional configurations to the release.

To change a configuration, use `--set` commands or `-f <my-values-file>`, where `my-values-file` is a path to a values file with your desired configuration.

---

## Uninstall the Chart

To uninstall and delete the release `devportal` in the `devportal` namespace, take the following step:

```bash
helm uninstall devportal --namespace devportal
```

This command removes all of the Kubernetes components associated with the Developer Portal release. The namespace is not deleted.

---

## Configurable Helm Settings {#configuration-options}

{{< include "installation/helm/acm/dev-portal-helm-configurations/configuration-options.md" >}}

<br>

## Common Deployment Configurations

Select from the following options to view some of the commonly used configurations for the Developer Portal. To apply these configurations, edit the `values.yaml` file as needed.

### Deploy Developer Portal with an SQLite database

{{< call-out "note" >}}
This configuration is recommended for proof of concept installations and not for production deployments.
{{< /call-out >}}

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-helm-devportal-sqlite.md" >}}

### Deploy Developer Portal with an embedded PostgreSQL database

{{< call-out "note" >}}
This configuration is recommended for proof of concept installations and not for production deployments.
{{< /call-out >}}

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-embedded-postgres.md" >}}

### Deploy Developer Portal with an external PostgreSQL database

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-external-postgres.md" >}}

### Deploy Developer Portal using TLS for the backend API service

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-api-mtls.md" >}}
