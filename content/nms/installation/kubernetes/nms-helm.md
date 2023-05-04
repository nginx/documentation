---
title: "Deploy NGINX Management Suite Using Helm"
date: 2022-12-14T16:28:20-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in the guide to deploy NGINX Management Suite to Kubernetes using a Helm chart."
# Assign weights in increments of 100
weight: 10
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

This tutorial will walk you through setting up the NGINX Management Suite on a Kubernetes cluster. You will learn how to download and load the Docker images, customize the deployment, enable NGINX Management Suite modules, and install the Helm chart.

### What Is a Helm Chart?

Helm charts are packages of pre-configured Kubernetes resources that can be deployed with a single command. Helm charts provide a simple way to define, install, and upgrade complex Kubernetes applications. Each chart comprises a collection of files describing a related set of Kubernetes resources, such as deployments, services, and ingress. Helm charts can be deployed to any Kubernetes cluster, making them a powerful tool for creating, sharing, and managing applications on Kubernetes. Helm charts can also be used to define and manage dependencies between different applications, enabling the creation of complex, multi-tier applications.

---

## Before You Begin

### Requirements for NGINX Management Suite

To deploy NGINX Management Suite using a Helm chart, you need the following:

{{<bootstrap-table "table table-striped table-bordered">}}
| Requirements                                                                        | Notes                                                                                                                                                                                                                                                                                                                                                       |
|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Private Docker registry                                                             | You need to have an externally-accessible [private Docker registry](https://docs.docker.com/registry/deploying/) to which you can push the container images.                                                                                                                                                                                                |
| <span style=" white-space: nowrap;">Kubernetes 1.21.3 or later (linux/amd64)</span> | Ensure your client can [access the Kubernetes API server](https://kubernetes.io/docs/concepts/security/controlling-access/). Note: by default the Helm chart will enable persistent storage using the default storage class configured in your Kubernetes cluster. Documentation around this topic can be found here: [Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/).                                                                                                                                                                                                                                 |
| kubectl 1.21.3 or later                                                             | https://kubernetes.io/docs/tasks/tools/#kubectl                                                                                                                                                                                                                                                                                                             |
| Docker 20.10 or later (linux/amd64)                                                 | https://docs.docker.com/get-docker/                                                                                                                                                                                                                                                                                                                         |
| Helm 3.10.0 or later                                                                | https://helm.sh/docs/intro/install/                                                                                                                                                                                                                                                                                                                         |
| OpenSSL 1.1.1 or later                                                              | https://www.openssl.org/source/                                                                                                                                                                                                                                                                                                                             |
| `tar` 1.20 or later                                                                 | <p>The `tar` archiving tool is usually installed by default. To see which version of `tar` you have installed, run `tar --version`. </p> <p>If `tar` is not installed or the version is too old, follow the instructions for your Linux distribution to install a supported version from a package manager such as YUM (CentOS, RHEL) or APT (Debian, Ubuntu). </p> |
{{</bootstrap-table>}}

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

   - **Product version**: select the latest or a prior version of NGINX Management Suite that you want to install.
       <details open>
      <summary> <i class="fa-solid fa-circle-info"></i> Module compatibility with Instance Manager</summary>

      {{< include "installation/helm/nim/module-compatibility-matrix.md" >}}

      </details>
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

    The extracted files include the following NGINX Management Suite Docker images:

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

1. Load the NGINX Management Suite Docker images:

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

    ```shell
    docker login <my-docker-registry>
    ```

    - Replace `<my-docker-registry>` with your private Docker registry.

1. Tag the NGINX Management Suite images with the version you noted when [loading the Docker images](#load-nms-docker-images) above.

    ```shell
    docker tag nms-apigw:<version> <my-docker-registry>/nms-apigw:<version>
    docker tag nms-core:<version> <my-docker-registry>/nms-core:<version>
    docker tag nms-dpm:<version> <my-docker-registry>/nms-dpm:<version>
    docker tag nms-ingestion:<version> <my-docker-registry>/nms-ingestion:<version>
    docker tag nms-integrations:<version> <my-docker-registry>/nms-integrations:<version>
    ```

    These commands create labels, known as tags, for each of the specified Docker images (such as `nms-apigw`), assigning them to the specified registry (`<my-docker-registry>`) with the specified version number (`<version>`). This allows them to be easily identified and retrieved from the registry in the future.

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker images](#load-nms-docker-images) above.

1. Push the NGINX Management Suite images to your private registry:

    ```shell
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

## Configure Chart to Pull from Private Docker Registry {#configure-chart}

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

### Common Helm Chart Configurations

Choose from the following options to view frequently used configurations for the NGINX Management Suite. To apply one of these configurations, modify the `values.yaml` file accordingly.

{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}

<details>
<summary><i class="fa-solid fa-circle-info"></i> Use your own ClickHouse installation</summary>

#### ClickHouse Server

The NGINX Management Suite requires a [ClickHouse](https://clickhouse.com) database server for storing metrics data. ClickHouse is an open-source, column-based, high-performance analytics database that allows real-time queries on large amounts of data.

The Helm chart installs ClickHouse by default; this setting is enabled in the `values.yaml` file by setting `nms-hybrid.nmsClickhouse.enabled` = `true`.

To use your own ClickHouse installation, take the following steps:

1. Set `nms-hybrid.nmsClickhouse.enabled` = `false`.
2. Add values for `nms-hybrid.externalClickhouse.address`, `.user`, and `.password` matching your ClickHouse installation.

   {{< note >}}`nms-hybrid.externalClickhouse` is required when `nms-hybrid.nmsClickhouse` is disabled.{{</note>}}

</details>

<details>
<summary><i class="fa-solid fa-circle-info"></i> Use your own certificates -- recommended for production deployments</summary>

#### Certificates

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

   </details>

<details>
<summary><i class="fa-solid fa-circle-info"></i> Adjust storage settings or disable persistent storage</summary>

#### Storage Settings

Review the deployment's default resource and storage settings by editing the `values.yaml` file in the helm package you downloaded. Adjust the values to meet your data needs.

Persistent volumes are enabled by default for the ClickHouse database server and `nms-hybrid.core` and `nms-hybrid.dpm` services. To disable persistent storage for a configuration, set `nms-hybrid.persistence.enable` = `false`.

</details>

<details>

<summary><i class="fa-solid fa-circle-info"></i> Use NGINX Plus for API Gateway</summary>

#### Use NGINX Plus for API Gateway {#nginx-plus-apigw}

To use NGINX Plus for the API Gateway, take the following steps:

1. Build your own Docker image for NGINX Plus API Gateway by providing your `nginx-repo.crt` and `nginx-repo.key`. Download the certificate (nginx-repo.crt) and key (nginx-repo.key) from the [MyF5 website](https://my.f5.com) and add them to your build context.

   You can use the following example Docker image and the instructions within it. In this example, we use `apigw:<version>` as the base image, obtained when we completed the [Extract Helm Bundle](#extract-helm-bundle) steps above, which we've extended to use NGINX Plus instead of NGINX OSS.

   <details open>
   <summary>Example Docker image</summary>

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
       KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
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

   </details>

2. Tag the Docker image with the values you noted in the [Load Docker Images](#load-docker-images) step above.

   ```shell
   docker tag apigw-plus <my-docker-registry>/nms-apigw-plus:<version>
   ```

   This command tags the existing Docker image, `apigw-plus`, with a new image name, `<my-docker-registry>/nms-apigw-plus:<version>` and assigns it a specific version number.

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker images](#load-nms-docker-images) above.

3. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry>/nms-apigw-plus:<version>
   ```

   This command pushes the `nms-agipw-plus` Docker image with the specified version to your private Docker registry (`<my-docker-registry>`). The Docker image will be stored in the registry and can be used for future deployments.

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker images](#load-nms-docker-images) above.

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

</details>

---

## Enable NGINX Management Suite Modules {#enable-nms-modules}

When deploying NGINX Management Suite, you can enable the following modules at the same time. Select a tab for the instructions.

{{<note>}}Instance Manager is included with NGINX Manager suite by default. If you're only installing Instance Manager, you can [skip to the next section](#install-the-chart) to continue with the installation.{{</note>}}

<br>

{{<tabs name="enable-nms-modules">}}

{{%tab name="API Connectivity Manager"%}}

<details>
<summary>Enable API Connectivity Manager when installing NGINX Management Suite</summary>

## Enable API Connectivity Manager

Complete the following steps to enable the API Connectivity Manager as part of a **new installation** of NGINX Management Suite.

{{<tip>}}<i class="far fa-lightbulb"></i> If you've already installed NGINX Management Suite and now, at a later time, you want to enable the API Connectivity Manager module, follow the steps in the [Enabling Modules for Existing Deployments]({{< relref "/nms/installation/kubernetes/enable-modules-for-existing-deployments.md" >}}) guide. In that case, you'll enable the module as an upgrade to your existing NGINX Management Suite.{{</tip>}}

### Download API Connectivity Manager Docker Image

{{< include "installation/helm/acm/download-acm-docker-image.md" >}}

### Load Docker Image {#load-acm-docker-image}

{{< include "installation/helm/acm/load-acm-docker-image.md" >}}

### Push Image to Private Registry {#push-image-private-docker-repo}

{{< include "installation/helm/acm/push-acm-docker-imate-private-repo.md" >}}

### Enable API Connectivity Manager

{{< include "installation/helm/acm/edit-values-yaml-to-enable-acm.md" >}}

### Customize Helm Settings for API Connectivity Manager {#configuration-options-acm}

{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md#acm-helm-settings" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}

{{%/tab%}}

{{%tab name="App Delivery Manager"%}}

<details>
<summary>Enable App Delivery Manager when installing NGINX Management Suite</summary>

## Enable App Delivery Manager

Complete the following steps to enable the App Delivery Manager module as part of a **new installation** of NGINX Management Suite.

{{<tip>}}<i class="far fa-lightbulb"></i> If you've already installed NGINX Management Suite and now, at a later time, you want to enable the App Delivery Manager module, follow the steps in the [Enabling Modules for Existing Deployments]({{< relref "/nms/installation/kubernetes/enable-modules-for-existing-deployments.md" >}}) guide. In that case, you'll enable the module as an upgrade to your existing NGINX Management Suite.{{</tip>}}

### Download App Delivery Manager Docker Image

{{< include "installation/helm/adm/download-adm-docker-image.md" >}}

### Load Docker Image {#load-adm-docker-image}

{{< include "installation/helm/adm/load-adm-docker-image.md" >}}

### Push Image to Private Registry {#push-image-private-docker-repo}

{{< include "installation/helm/adm/push-adm-docker-imate-private-repo.md" >}}

### Enable the App Delivery Manager Module

{{< include "installation/helm/adm/edit-values-yaml-to-enable-adm.md" >}}

### Customize Helm Settings for the App Delivery Manager Module {#configuration-options-adm}

{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md#adm-helm-settings" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}

{{%/tab%}}

{{</tabs>}}

---

## Install the Chart {#install-the-chart}

Run the `helm install` command to install NGINX Management Suite from the Helm chart:

```shell
helm install -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms --create-namespace -f <path-to-your-values.yaml> [--version <desired-version>] --wait
```

- Replace `<path-to-your-values.yaml>` with the path to the [values.yaml file you created](#configure-chart).
- Replace "YourPassword123#" with a secure password that contains a combination of uppercase and lowercase letters, numbers, and special characters.
- When specifying a version parameter, replace `<desired-version>` with the version of the NGINX Management Suite chart required.

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

You can access the NGINX Management Suite web interface using the external IP address for the API Gateway.

1. To look up the external IP address for the API Gateway, run the following command:

   ```shell
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

## Upgrade NGINX Management Suite {#helm-upgrade-nms}

To upgrade NGINX Management Suite from a Helm chart, take the following steps:

1. Repeat the steps above to:

   - [Download and extract a newer version of NGINX Management Suite Helm Bundle](#download-nms-helm-bundle).
   - [Load and push the Docker images to your private registry](#prepare-docker-images).
   - [Configure the chart to pull from your private Docker registry](#configure-chart).

2. {{< include "installation/helm/nim/helm-upgrade-nms.md" >}}

3. (Instance Manager 2.6) If you're upgrading to Instance Manager 2.6.0, run these additional commands:

   ```shell
   kubectl -n nms patch deployment core -p '{"spec": {"strategy": {"type": "Recreate", "rollingUpdate": null}}}'
   kubectl -n nms patch deployment dpm -p '{"spec": {"strategy": {"type": "Recreate", "rollingUpdate": null}}}'
   kubectl -n nms patch deployment integrations -p '{"spec": {"strategy": {"type": "Recreate", "rollingUpdate": null}}}'
   ```

   These `kubectl` commands patch the deployment of three applications (`core`, `dpm`, and `integrations`) in the namespace `nms`. Specifically, these commands are setting the deployment strategy for each of the applications to "Recreate" and disabling the rolling update strategy, which allows the deployment to be recreated from scratch instead of being updated incrementally.

---

## Uninstall NGINX Management Suite {#helm-uninstall-nms}

To uninstall NGINX Management Suite from Kubernetes, run the following command:

```shell
helm uninstall --namespace nms nms
```

This helm command uninstalls the app named `nms` from the namespace `nms`. It deletes all of the Kubernetes resources associated with the app, including any deployments, pods, services, and configmaps.

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}

For guidance on how to create a support package containing system and service details to share with NGINX Customer Support, refer to the guide [Create a Support Package from a Helm Installation]({{< relref "/nms/support/k8s-support-package.md" >}}).

---

## What's Next

- [License Instance Manager]({{< relref "/nms/installation/add-license.md" >}})
- [Install and Configure NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}})
- [Set Up Authentication for Instance Manager]({{< relref "/nms/admin-guides/access-control/configure-authentication.md" >}})
