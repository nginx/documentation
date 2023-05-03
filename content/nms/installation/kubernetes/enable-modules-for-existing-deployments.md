---
title: "Enabling Modules for Existing Deployments"
date: 2023-01-17T11:55:53-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "To enable specific modules for your existing NGINX Management Suite deployment, refer to the instructions in this guide."
# Assign weights in increments of 100
weight: 20
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1111"
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

{{<custom-styles>}}

---

## Overview

If you’ve already [deployed NGINX Management Suite using Helm]({{< relref "/nms/installation/kubernetes/nms-helm.md" >}}) and would now like to enable a module, simply follow the steps outlined below.

---

## Steps for Enabling Modules

Choose the tab for the module you want to activate and follow the provided instructions.

<br>

{{<tabs name="enable-nms-modules">}}

{{%tab name="API Connectivity Manager"%}}

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

### Download App Delivery Manager Docker Image

{{< include "installation/helm/adm/download-adm-docker-image.md" >}}

### Load Docker Image {#load-adm-docker-image}

{{< include "installation/helm/adm/load-adm-docker-image.md" >}}

### Push Image to Private Registry {#push-image-private-docker-repo}

{{< include "installation/helm/adm/push-adm-docker-imate-private-repo.md" >}}

### Enable App Delivery Manager
{{< include "installation/helm/adm/edit-values-yaml-to-enable-adm.md" >}}

### Customize Helm Settings for App Delivery Manager {#configuration-options-adm}
{{<see-also>}}Refer to the [Configurable Helm Settings]({{< relref "/nms/installation/kubernetes/nms-helm-config-options.md#adm-helm-settings" >}}) reference guide for the complete list of configurable parameters and default values used by the NGINX Management Suite and modules when installing from a Helm chart. {{</see-also>}}


{{%/tab%}}

{{</tabs>}}

---

## Upgrade NGINX Management Suite Deployment

{{< include "installation/helm/nim/helm-upgrade-nms.md" >}}
