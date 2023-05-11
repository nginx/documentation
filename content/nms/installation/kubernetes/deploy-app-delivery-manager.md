---
title: "Deploy App Delivery Manager on Kubernetes"
date: 2023-05-09T13:34:35-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "The guide provides step-by-step instructions to deploy NGINX App Delivery Manager on Kubernetes using a Helm chart."
# Assign weights in increments of 100
weight: 3
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

{{< important >}}To install App Delivery Manager, you must first install Instance Manager. This is because App Delivery Manager relies on features that are included with Instance Manager.{{< /important >}}

- [Deploy Instance Manager on Kubernetes]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}})


---

{{< custom-styles >}}

## Requirements

{{< important >}}To install App Delivery Manager, you must first install Instance Manager. This is because App Delivery Manager relies on features that are included with Instance Manager.{{< /important >}}

- [Deploy Instance Manager on Kubernetes]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}})


---


Complete the following steps to enable the App Delivery Manager as part of a **new installation** of NGINX Management Suite.

## Download Docker Image

Follow these steps to download the Docker image for App Delivery Manager:

1. Go to the [MyF5 website](https://my.f5.com/manage/s/downloads), then select **Resources > Downloads**.
1. In the **Select Product Family** list, select **NGINX**.
1. In the **Product Line** list, select **NGINX App Delivery Manager**.
1. Select the following download options:

   - **Product version** -- Select the version of App Delivery Manager you want to install. Make sure this version is compatible with the version of Instance Manager you installed as a prerequisite. Refer to the [Dependencies with Instance Manager](#dependencies-with-instance-manager) section above.
   - **Linux distribution** -- Select the Linux distribution you're deploying to. For example, **ubuntu**.
   - **Distribution Version** -- Select the Linux distribution's version. For example, **20.04**.
   - **Architecture** -- Select the architecture. For example, **amd64**.

1. In the **Download Files** section, download the `nms-adm-<version>-img.tar.gz` file.


## Load Docker Image {#load-acm-docker-image}

1. Change to the directory where you downloaded the Docker image:

   ``` shell
   cd <directory name>
   ```

1. Load the Docker image from the `nms-adm-<version>-img.tar.gz` archive:

   ``` shell
   docker load -i nms-adm-<version>-img.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-adm-<version>-img.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-adm:4.0
   ```

   {{<important>}}
   Take note of the loaded image's name and tag.  You'll need to reference this information in the next section when pushing the image to your private registry.

   In the example output above, `nms-adm` is the image name and `4.0` is the tag.  The image name or tag could be different depending on the product version you downloaded from MyF5.
   {{</important>}}

## Push Image to Private Registry {#push-image-private-docker-repo}

After loading the Docker image, you can now tag and push the image to your private Docker registry. Replace `<my-docker-registry:port>` in the examples below with the path to your private Docker registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry:port>
   ```

   - Replace `<my-docker-registry:port>` with your private Docker registry.

1. Tag the image with the values you noted when [loading the Docker image](#load-acm-docker-image) above.

   ```shell
   docker tag nms-adm:<version> <my-docker-registry:port>/nms-adm:<version>
   ```

   - Replace `<my-docker-registry:port>` with your private Docker registry hostname and port (if needed).

   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

   For example:

   ```shell
   docker tag nms-adm:4.0 myregistryhost:5000/nms-adm:4.0
   ```
   

2. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry:port>/nms-adm:<version>
   ```

   This command pushes the Docker image `nms-adm` to the specified private Docker registry (`my-docker-registry`). The image will be tagged with the specified version (`<version>`). 

   - Replace `<my-docker-registry:port>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

## Enable App Delivery Manager

To enable the App Delivery Manager Module, take the following steps:

1. Open the `values.yaml` file for editing.
1. Add the following snippet to the `values.yaml` file:

   ```yaml
   # values.yaml
   global:
       nmsModules:
           nms-adm:
               enabled: true
   nms-adm:
       imagePullSecrets:
       - name: regcred
       acm:
           image:
               repository: <my-docker-registry:port>/nms-adm 
               tag: <version>
   ```

   This `values.yaml` file enables the API Connectivity module and specifies the image pull secret, repository, and tag of the image to be used.

   - Replace `<my-docker-registry:port>` with your private Docker registry.
   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.
   - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

1. Close and save the `values.yaml` file.

## Customize Helm Settings for App Delivery Manager {#configuration-options-acm}

{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md#acm-helm-settings" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}

## Upgrade NGINX Management Suite Deployment

{{< include "installation/helm/nim/helm-upgrade-nms.md" >}}
