---
title: "Deploy API Connectivity Manager"
date: 2023-05-09T13:34:26-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
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

Complete the following steps to enable the API Connectivity Manager as part of a **new installation** of NGINX Management Suite.

{{<tip>}}<i class="far fa-lightbulb"></i> If you've already installed NGINX Management Suite and now, at a later time, you want to enable the API Connectivity Manager module, follow the steps in the [Enabling Modules for Existing Deployments]({{< relref "/nms/installation/kubernetes/enable-modules-for-existing-deployments.md" >}}) guide. In that case, you'll enable the module as an upgrade to your existing NGINX Management Suite.{{</tip>}}

## Download API Connectivity Manager Docker Image

1. On the [MyF5 website](https://my.f5.com/manage/s/downloads), select **Resources > NGINX Downloads**.
1. In the **Product Family** list, select **NGINX**.
1. In the **Product Line** list, select **NGINX API Connectivity Manager**.
1. Select the following download options:

   - **Product version**
      <details open>
      <summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manager</summary>

      {{< include "installation/helm/nim/module-compatibility-matrix.md" >}}

      </details>
   - **Linux distribution** -- for example, **ubuntu**
   - **Distribution Version** -- for example, **20.04**
   - **Architecture** -- for example, **amd64**

1. In the **Download Files** section, locate and download the `nms-acm-<version>-img.tar.gz` file.


## Load Docker Image {#load-acm-docker-image}

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

## Push Image to Private Registry {#push-image-private-docker-repo}

After loading the Docker image, you can now tag and push the image to your private Docker registry. Replace `<my-docker-registry>` in the examples below with the path to your private Docker registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry>
   ```

   - Replace `<my-docker-registry>` with your private Docker registry.

1. Tag the image with the values you noted when [loading the Docker image](#load-acm-docker-image) above.

   ```shell
   docker tag nms-acm:<version> <my-docker-registry>/nms-acm:<version>
   ```

   This command creates a new tag for an existing Docker image.

   The first argument, `nms-acm:<version>`, specifies the existing Docker image that will be tagged. The second argument, `<my-docker-registry>/nms-acm:<version>`, specifies the new tag for the image. The new tag will be used to reference the image in the private Docker registry.

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

1. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry>/nms-acm:<version>
   ```

   This command pushes the Docker image `nms-acm` to the specified private Docker registry (`my-docker-registry`). The image will be tagged with the specified version (`<version>`). 

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

## Enable API Connectivity Manager

To enable the API Connectivity Manager Module, take the following steps:

1. Open the `values.yaml` file for editing.
1. Add the following snippet to the `values.yaml` file:

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
               repository: <my-docker-registry>/nms-acm 
               tag: <version>
   ```

   This `values.yaml` file enables the API Connectivity module and specifies the image pull secret, repository, and tag of the image to be used.

   - Replace `<my-docker-registry>` with your private Docker registry.
   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.
   - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

1. Close and save the `values.yaml` file.

## Customize Helm Settings for API Connectivity Manager {#configuration-options-acm}

{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md#acm-helm-settings" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}

## Upgrade NGINX Management Suite Deployment

{{< include "installation/helm/nim/helm-upgrade-nms.md" >}}