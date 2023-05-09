---
title: "Deploy Instance Manager"
date: 2022-12-14T16:28:20-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in the guide to deploy Instance Manager to Kubernetes using a Helm chart."
# Assign weights in increments of 100
weight: 2
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1113"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
aliases:
- /installation/helm-chart/

---

{{<custom-styles>}}

## Overview

This tutorial will walk you through setting up Instance Manager on a Kubernetes cluster. You will learn how to download and load the Docker images, customize the deployment, enable NGINX Management Suite modules, and install the Helm chart.

### What Is a Helm Chart?

Helm charts are packages of pre-configured Kubernetes resources that can be deployed with a single command. Helm charts provide a simple way to define, install, and upgrade complex Kubernetes applications. Each chart comprises a collection of files describing a related set of Kubernetes resources, such as deployments, services, and ingress. Helm charts can be deployed to any Kubernetes cluster, making them a powerful tool for creating, sharing, and managing applications on Kubernetes. Helm charts can also be used to define and manage dependencies between different applications, enabling the creation of complex, multi-tier applications.

---

### Requirements

To deploy Instance Manager using a Helm chart, you need the following:

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Requirements                                                                        | Notes                                                                                                                                                                                                                                                                                                                                                                                                                   |
|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Private&nbsp;Docker&nbsp;registry&nbsp;                                             | You need to have an externally-accessible [private Docker registry](https://docs.docker.com/registry/deploying/) to which you can push the container images.                                                                                                                                                                                                                                                            |
| Docker 20.10 or later (linux/amd64)                                                 | https://docs.docker.com/get-docker/                                                                                                                                                                                                                                                                                                                                                                                     |
| <span style=" white-space: nowrap;">Kubernetes 1.21.3 or later (linux/amd64)</span> | Ensure your client can [access the Kubernetes API server](https://kubernetes.io/docs/concepts/security/controlling-access/). Note: by default the Helm chart will enable persistent storage using the default storage class configured in your Kubernetes cluster. Documentation around this topic can be found here: [Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). |
| kubectl 1.21.3 or later                                                             | https://kubernetes.io/docs/tasks/tools/#kubectl                                                                                                                                                                                                                                                                                                                                                                         |
| Helm 3.10.0 or later                                                                | https://helm.sh/docs/intro/install/                                                                                                                                                                                                                                                                                                                                                                                     |
| OpenSSL 1.1.1 or later                                                              | https://www.openssl.org/source/                                                                                                                                                                                                                                                                                                                                                                                         |
| `tar` 1.20 or later                                                                 | <p>The `tar` archiving tool is usually installed by default. To see which version of `tar` you have installed, run `tar --version`. </p> <p>If `tar` is not installed or the version is too old, follow the instructions for your Linux distribution to install a supported version from a package manager such as YUM (CentOS, RHEL) or APT (Debian, Ubuntu). </p>                                                     |
{{< /bootstrap-table >}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## Add Helm Repository {#add-helm-repository}

{{< include "installation/helm/add-helm-repo.md" >}}

---

## Get Helm Bundle {#get-helm-bundle}

### Download NGINX Management Suite Helm Bundle  {#download-nms-helm-bundle}

Download the NGINX Management Suite Helm bundle to your virtual machine:

1. On the [MyF5 website](https://my.f5.com/manage/s/downloads), select **Resources > Downloads**.
1. In the **Product Family** list, select **NGINX**.
1. In the **Product Line** list, select **NGINX Instance Manager**.
1. Select the following download options:

   - **Product version**: select the version of NGINX Management Suite that you want to install.
   - **Linux distribution**: select `helmchart`.
   - **Distribution Version**: defaults to the helmchart version corresponding to the **Product Version**.
   - **Architecture**: defaults to `k8`.

1. In the **Download Files** section, locate and download the `nms-helm-<version>.tar.gz` file.

### Extract Helm Bundle {#extract-helm-bundle}

The `nms-helm-<version>.tar.gz` file includes several Docker container images and the Helm package tarball. To extract these files, take the following steps:

1. Make a directory to extract the package into:

   ``` shell
   mkdir -p <directory name>
   ```

2. Extract the package into the target directory:

    ``` shell
    tar -xzf nms-helm-<version>.tar.gz -C <directory name>
    ```

    <br>

    The extracted files include the following Docker images:

    **Docker images**

    - `nms-apigw-<version>.tar.gz`
    - `nms-core-<version>.tar.gz`
    - `nms-dpm-<version>.tar.gz`
    - `nms-ingestion-<version>.tar.gz`
    - `nms-integrations-<version>.tar.gz`

---

## Prepare Docker Images

### Load Docker Images {#load-nms-docker-images}

1. Change to the directory where you [extracted the Docker images](#extract-helm-bundle):

   ``` shell
   cd <directory name>
   ```

1. Load the Docker images:

   ``` shell
   docker load -i nms-apigw-<version>.tar.gz
   docker load -i nms-core-<version>.tar.gz
   docker load -i nms-ingestion-<version>.tar.gz
   docker load -i nms-dpm-<version>.tar.gz
   docker load -i nms-integrations-<version>.tar.gz
   ```

   This set of commands loads the Docker images from the specified `tar.gz` archives. Replace `<version>` with the product version you specified when downloading the Helm bundle.

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-apigw-<version>.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-apigw:2.6.0
   ```

   {{<important>}}For the output of each `docker load` command, note the loaded image's name and tag. You'll need to reference these images and tags in the next section when pushing the images to your private registry.

   For example, in the output directly above, `nms-apigw` is the image name and `2.6.0` is the tag.  The tag `2.6.0` could differ depending on the product version you [downloaded from MyF5](#download-nms-helm-bundle).{{</important>}}

### Push Images to Private Registry {#push-images-private-registry}

{{<before-you-begin>}}To complete this step, you need an [externally-accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to.{{</before-you-begin>}}

1. Log in to your private registry:

    ```bash
    docker login <my-docker-registry>
    ```

    - Replace `<my-docker-registry>` with your private Docker registry.

1. Tag the images with the version you noted when [loading the Docker images](#load-nms-docker-images) above.

    ```bash
    docker tag nms-apigw:<version> <my-docker-registry>/nms-apigw:<version>
    docker tag nms-core:<version> <my-docker-registry>/nms-core:<version>
    docker tag nms-dpm:<version> <my-docker-registry>/nms-dpm:<version>
    docker tag nms-ingestion:<version> <my-docker-registry>/nms-ingestion:<version>
    docker tag nms-integrations:<version> <my-docker-registry>/nms-integrations:<version>
    ```

    These commands create labels, known as tags, for each of the specified Docker images (such as `nms-apigw`), assigning them to the specified registry (`<my-docker-registry>`) with the specified version number (`<version>`). This allows them to be easily identified and retrieved from the registry in the future.

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker images](#load-nms-docker-images) above.

1. Push the images to your private registry:

    ```bash
    docker push <my-docker-registry>/nms-apigw:<version>
    docker push <my-docker-registry>/nms-core:<version>
    docker push <my-docker-registry>/nms-dpm:<version>
    docker push <my-docker-registry>/nms-ingestion:<version>
    docker push <my-docker-registry>/nms-integrations:<version>
    ```

    This set of commands pushes Docker images for `nms-apigw`, `nms-core`, `nms-dpm`, `nms-ingestion` and `nms-integrations` to your private registry (`<my-docker-registry>`) with a specified version tag (`<version>`)

    - Replace `<my-docker-registry>` with your private Docker registry.

    - Replace `<version>` with the tag you noted when [loading the Docker images](#load-nms-docker-images) above.

---

## Configure Chart {#configure-chart}

A Helm `values.yaml` file is a configuration file you can use to customize the installation of a [Helm chart](#what-is-a-helm-chart) without actually editing the chart itself, allowing for faster and more efficient deployments. Values can be used to specify different image repositories and tags, set environment variables, configure resource requests and limits, and more.

1. Create a `values.yaml` file similar to the following example. This file is used to customize the configuration of the NGINX Management Suite chart located in the `nginx-stable` Helm repository that you [added above](#add-helm-repository).

    ```yaml
    # values.yaml
    nms-hybrid:
        imagePullSecrets:
            - name: regcred
        apigw:
            image:
                repository: <my-docker-registry>/nms-apigw
                tag: <version>
        core:
            image:
                repository: <my-docker-registry>/nms-core
                tag: <version>
        dpm:
            image:
                repository: <my-docker-registry>/nms-dpm
                tag: <version>
        ingestion:
            image:
                repository: <my-docker-registry>/nms-ingestion
                tag: <version>
        integrations:
            image:
                repository: <my-docker-registry>/nms-integrations
                tag: <version>
    ```

    - Replace `<my-docker-registry>` with your private Docker registry.
    - Replace `<version>` with the tag you used when [pushing the images to your private registry](#push-images-private-registry).
    - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

    This `values.yaml` file specifies the Docker images to be used for the `apigw`, `core`, `dpm`, `ingestion`, and `integrations` components, including the repository (`<my-docker-registry>`) and tag (`version`) of each image. It also specifies that a secret called `regcred` should be used for image pulls.

    {{<see-also>}}For instructions on creating a secret, see the Kubernetes topic [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).{{</see-also>}}

2. Save and close the `values.yaml` file.

---

## Install Chart {#install-chart}

Run the `helm install` command to install Instance Manager from the Helm chart:

```bash
helm install -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms --create-namespace -f <path-to-your-values.yaml> [--version <desired-version>] --wait
```

- Replace `<path-to-your-values.yaml>` with the path to the [values.yaml file you created](#configure-chart).
- Replace "YourPassword123#" with a secure password that contains a combination of uppercase and lowercase letters, numbers, and special characters.
- When specifying a version parameter, replace `<desired-version>` with the version of the Instance Manager chart required.

This command performs a Helm install of the `nginx-stable/nms` package into a namespace called `nms`, setting the `nms-hybrid.adminPasswordHash` to a hashed value of "YourPassword123#". The `values.yaml` file located at `<path-to-your-values.yaml>` is used to provide additional configuration parameters for the installation. The `--create-namespace` flag is used to ensure that the specified namespace (in this case `nms`) is created if it does not already exist.


{{< important >}}Make sure to copy and save the password for future reference. Only the encrypted password is stored in Kubernetes. There's no way to recover or reset a lost password.{{< /important >}}

---

## Validate Deployment {#validate-deployment}

Run the following command to check the status of the deployment:

``` shell
helm -n nms status nms
```

This `helm` command shows the status of the app called `nms` in the namespace `nms`. The command displays the release name, chart version, last deployment time, and current status.

The status should be `STATUS: deployed` if the deployment was successful.

---

## Access Web Interface

You can access the Instance Manager web interface using the external IP address for the API Gateway.

1. To look up the external IP address for the API Gateway, run the following command:

   ```bash
   kubectl -n nms get svc apigw
   ```

   This `kubectl` command retrieves the service named `apigw` from the namespace `nms`. It outputs the details of the service, such as its type, port, cluster and external IP addresses.

   The output looks similar to the following example. Note the value in the `EXTERNAL-IP` column.

   ```text
   NAME    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
   apigw   LoadBalancer   10.100.153.15   localhost     443:30414/TCP   2m1s
   ```

1. Using the value from the previous step, go to `https://<apigw-EXTERNAL-IP>:443/ui`.

   For example, `https://localhost:443/ui`.

---

## Upgrade Instance Manager {#helm-upgrade-nim}

To upgrade Instance Manager, take the following steps:

1. Repeat the steps above to:

   - [Download and extract a newer version of NGINX Management Suite Helm Bundle](#download-nms-helm-bundle).
   - [Load and push the Docker images to your private registry](#prepare-docker-images).
   - [Configure the chart to pull from your private Docker registry](#configure-chart).

2. {{< include "installation/helm/nim/helm-upgrade-nms.md" >}}

---

## Uninstall Instance Manager {#helm-uninstall-nim}

To uninstall Instance Manager from Kubernetes, run the following command:

```bash
helm uninstall --namespace nms nms
```

This helm command uninstalls the app named `nms` from the namespace `nms`. It deletes all of the Kubernetes resources associated with the app, including any deployments, pods, services, and configmaps.

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}

For guidance on how to create a support package containing system and service details to share with NGINX Customer Support, refer to the guide [Create a Support Package from a Helm Installation]({{< relref "/nms/support/k8s-support-package.md" >}}).


