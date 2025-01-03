---
description: Tracking your [NGINX Plus]({{< relref "nginx/" >}}) installations is
  straightforward with [NGINX Instance Manager]({{< relref "nim/"
  >}}). If you're enrolled in a commercial program like the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program),
  you'll need to regularly report this data to F5.
docs: DOCS-934
doctypes:
- task
tags:
- docs
title: Tracking NGINX Plus installations for compliance
toc: true
weight: 1000
draft: true
---

## Overview

Tracking your [NGINX Plus]({{< relref "nginx/" >}}) installations is
  straightforward with [NGINX Instance Manager]({{< relref "nim/"
  >}}). If you're enrolled in a commercial program like the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program),
  you'll need to regularly report this data to F5.

{{< include "nginx-plus/usage-tracking/overview.md" >}}

## Prerequisites

### Install F5 NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}


## View your NGINX Plus and NGINX App Protect Inventory

After you've installed NGINX Instance Manager, the next step involves configuring your NGINX Plus data plane to report back. This can be done in two ways. First, you can install NGINX Agent on each instance. Alternatively, for an agentless approach, you can set up HTTP Health Checks, which don't require additional installations. Both methods enable your instances to communicate with Instance Manager.

### Set up instance reporting for NGINX Plus {#set-up-reporting}

Select the tab that matches your preferred method for setting up reporting:

- Configure native usage reporting (since NGINX Plus [Release 31]({{< relref "/nginx/releases.md#nginxplusrelease-31-r31" >}}))
- Install NGINX Agent
- Configure HTTP Health Check for NGINX Plus without NGINX Agent

{{<tabs name="configure-reporting">}}

{{%tab name="Native Usage Reporting"%}}

{{< include "nginx-plus/usage-tracking/agentless-reporting.md" >}}

{{%/tab%}}

{{%tab name="NGINX Agent"%}}

{{< include "nginx-plus/usage-tracking/install-nginx-agent.md" >}}

{{%/tab%}}

{{%tab name="HTTP Health Check"%}}

{{< include "nginx-plus/usage-tracking/http-health-check.md" >}}

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
