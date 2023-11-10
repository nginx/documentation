---
title: "Reporting NGINX Plus Installation Counts for Compliance"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This guide will help you count and report the number of NGINX Plus installations you have to F5 -- including for NGINX App Protect, NGINX Ingress Controller, and Kubernetes Connectivity Stack deployments. You may be required to report this information if you are enrolled in a commercial plan such as [F5's Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program)."

# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-934"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["Installation"]
doctypes: ["task"]
aliases:
- /nim/how-to/count-nginx-plus-instances/
---

{{< custom-styles >}}

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

{{< include "nginx-plus/usage-tracking/overview.md" >}}

## Prerequisites

### Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}


## View your NGINX Plus and NGINX App Protect Inventory

After you've installed NGINX Instance Manager, the next step is to configure your NGINX Plus data plane for reporting. You can do this by [installing NGINX Agent]({{< relref "nms/nginx-agent/install-nginx-agent.md" >}}) on each instance or by setting up [HTTP Health Checks]({{< relref "nginx/admin-guide/load-balancer/http-health-check.md" >}}). Both approaches enable your instances to relay data back to Instance Manager for usage tracking.

### Set up instance reporting for NGINX Plus {#set-up-reporting}

Select the tab that matches your preferred method for setting up reporting:

- Install NGINX Agent 
- Configure an HTTP Health Check

{{<tabs name="configure-reporting">}}

{{%tab name="Install NGINX Agent"%}}

{{< include "nginx-plus/usage-tracking/install-nginx-agent.md" >}}

{{%/tab%}}

{{%tab name="Configure HTTP Health Check"%}}

{{<include "nginx-plus/usage-tracking/http-health-check.md" >}}

{{%/tab%}}

{{</tabs>}}

### Reporting your NGINX Plus inventory to F5 {#view-nginx-plus-usage}

{{< include "nginx-plus/usage-tracking/view-nginx-plus-count.md" >}}

## View your NGINX Ingress Controller instances and nodes

You can set up your Kubernetes-based NGINX Plus products, including [NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/) and [Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/), to report usage data to NGINX Instance Manager.

### Set up usage reporting for NGINX Ingress Controller

Follow the instructions in the [Enabling Usage Reporting](https://docs.nginx.com/nginx-ingress-controller/usage-reporting/) guide to enable usage reporting for NGINX Ingress Controller.

### Reporting your NGINX Ingress Controller clusters to F5

{{< include "nginx-plus/usage-tracking/get-list-k8s-deployments.md" >}}