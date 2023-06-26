---
title: "Deploy API Connectivity Manager on Kubernetes"
date: 2023-05-09T13:34:26-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "The guide provides step-by-step instructions to deploy NGINX API Connectivity Manager on Kubernetes using a Helm chart."
# Assign weights in increments of 100
weight: 2
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{< custom-styles >}}

## Requirements

Review the following requirements for API Connectivity Manager before continuing.

### Install Instance Manager

{{< important >}}To install API Connectivity Manager, you must first install Instance Manager. This is because API Connectivity Manager relies on features that are included with Instance Manager.{{< /important >}}

- [Deploy Instance Manager on Kubernetes]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}})

### Dependencies with Instance Manager

Refer to the following table to see the module compatibility for each NGINX Management Suite chart.

{{< include "installation/helm/nms-chart-supported-module-versions.md" >}}


---

## Download Docker Image {#download-docker-image}

Follow these steps to download the Docker image for API Connectivity Manager:

1. Go to the [MyF5 website](https://my.f5.com/manage/s/downloads), then select **Resources > Downloads**.
1. In the **Select Product Family** list, select **NGINX**.
1. In the **Product Line** list, select **NGINX API Connectivity Manager**.
1. Select the following download options:

   - **Product version** -- Select the version of API Connectivity Manager you want to install. Make sure this version is compatible with the version of Instance Manager you installed as a prerequisite. Refer to the [Dependencies with Instance Manager](#dependencies-with-instance-manager) section above.
   - **Linux distribution** -- Select the Linux distribution you're deploying to. For example, **ubuntu**.
   - **Distribution Version** -- Select the Linux distribution's version. For example, **20.04**.
   - **Architecture** -- Select the architecture. For example, **amd64**.

1. In the **Download Files** section, download the `nms-acm-<version>-img.tar.gz` file.

---

## Load Docker Image {#load-docker-image}

{{< note >}} To complete the commands in this section, you need to have [Docker 20.10 or later](https://docs.docker.com/get-docker/) installed. {{< /note >}}


1. Change to the directory where you downloaded the Docker image:

   ``` shell
   cd <directory name>
   ```

1. Load the Docker image from the `nms-acm-<version>-img.tar.gz` archive:

   ``` shell
   docker load -i nms-acm-<version>-img.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-acm-<version>-img.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-acm:1.5.0
   ```

   {{<important>}}
   Take note of the loaded image's name and tag.  You'll need to reference this information in the next section when pushing the image to your private registry.

   In the example output above, `nms-acm` is the image name and `1.5.0` is the tag.  The image name or tag could be different depending on the product version you downloaded from MyF5.
   {{</important>}}

---

## Push Image to Private Registry {#push-docker-image}

{{<note>}}To complete the steps in this section, you need an [externally-accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to.{{</note>}}

To push the Docker images to your private registry, take the following steps:

- Replace `<my-docker-registry:port>` with your private Docker registry and port (if needed).

- Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry:port>
   ```

2. Tag the image with the image name and version you noted when [loading the Docker image](#load-acm-docker-image).

   ```shell
   docker tag nms-acm:<version> <my-docker-registry:port>/nms-acm:<version>
   ```

   For example:

   ```shell
   docker tag nms-acm:1.5 myregistryhost:5000/nms-acm:1.5
   ```

3. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry:port>/nms-acm:<version>
   ```

   For example:

   ```shell
   docker push nms-acm:1.5 myregistryhost:5000/nms-acm:1.5
   ```

---

## Enable API Connectivity Manager

To enable the API Connectivity Manager Module, take the following steps:

1. Open the `values.yaml` file for editing.
1. Add the following snippet to the `values.yaml` file:

   - Replace `<my-docker-registry:port>` with your private Docker registry and port (if needed).
   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.
   - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

   ```yaml
   # values.yaml
   global:
       nmsModules:
           nms-acm:
               enabled: true
   nms-acm:
       imagePullSecrets:
       - name: regcred
       acm:
           image:
               repository: <my-docker-registry:port>/nms-acm 
               tag: <version>
   ```

1. Close and save the `values.yaml` file.

---

## Upgrade NGINX Management Suite Deployment {#upgrade-nms}

{{<note>}}To complete the steps in this section, you need to have [OpenSSL 1.1.1](https://www.openssl.org/source/) or later installed.{{</note>}}

{{< include "installation/helm/helm-upgrade-nms.md" >}}

### Upgrade Existing API Connectivity Manager Deployment {#upgrade-acm-helm}

If you've already deployed API Connectivity Manager and would like to upgrade to a newer version, take the following steps:

1. Repeat the steps above to:

   - [Download Newer Docker Image](#download-docker-image)
   - [Load Docker Image](#load-docker-image)
   - [Push Image to Private Docker Registry](#push-docker-image)

2. Run the `helm upgrade` command above to [upgrade the NGINX Management Suite deployment](#upgrade-nms).

---

## Access Web Interface

{{< include "installation/helm/access-webui-helm.md" >}}

---

## Add License

A valid license is required in order to use API Connectivity Manager.

### Download License

{{< include "installation/download-trial-license.md" >}}

### Apply License

{{< include "installation/add-license.md" >}}

---

## Configurable Helm Settings

{{< include "installation/helm/acm/configuration-options.md" >}}

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}

For guidance on how to create a support package containing system and service details to share with NGINX Customer Support, refer to the guide [Create a Support Package from a Helm Installation]({{< relref "/nms/support/k8s-support-package.md" >}}).

---

## What's Next

### Deploy Other NGINX Management Suite Modules

- [Deploy App Delivery Manager on Kubernetes]({{< relref "/nms/installation/kubernetes/deploy-app-delivery-manager.md" >}})
