---
title: "Reporting Usage for NGINX Products"
date: 2023-10-26T10:27:57-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This guide will help you track and report on the number of your NGINX Plus installations -- including for NGINX App Protect, NGINX Ingress Controller, and Kubernetes Connectivity Stack deployments. You may be required to report this information if you are enrolled in a commercial plan such as [F5's Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program)."
# Assign weights in increments of 100
weight: 600
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

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

{{< include "nginx-plus/usage-tracking/overview.md" >}}

## Requirements

### Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}


## Reporting NGINX Plus and NGINX App Protect usage

After you've installed NGINX Instance Manager, the next step is to configure your NGINX Plus data plane for reporting. You can do this by installing NGINX Agent on each instance or by setting up HTTP Health Checks. Both approaches enable your instances to relay data back to Instance Manager for usage tracking.

### Set up usage reporting for NGINX Plus {#set-up-reporting}

Select the tab that matches your preferred method for setting up reporting:

- (recommended) Install NGINX Agent 
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

## Reporting NGINX Ingress Controller usage

You can set up your Kubernetes-based NGINX products, including [NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/) and [Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/), to report data directly to the NGINX Instance Manager API.

### Set up usage reporting for NGINX Ingress Controller

Follow the instructions in the [Enabling Usage Reporting](https://docs.nginx.com/nginx-ingress-controller/usage-reporting/) guide to enable usage reporting for NGINX Ingress Controller.

### Reporting your NGINX Kubernetes clusters to F5

{{< include "nginx-plus/usage-tracking/get-list-k8s-deployments.md" >}}
