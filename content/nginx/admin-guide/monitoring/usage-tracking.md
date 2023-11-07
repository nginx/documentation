---
title: "Tracking Usage for NGINX Products"
date: 2023-10-26T10:27:57-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This guide will help you track the usage of your NGINX Plus, NGINX App Protect, NGINX Ingress Controller, and Kubernetes Connectivity Stack deployments. You may be required to report this information if you are enrolled in a commercial plan such as [F5's Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program)."
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

NGINX Management Suite Instance Manager makes it easy to track and report your NGINX product usage. You may be expected to report this information to F5 if you're enrolled in a commercial program, such as the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program).

Start by installing NGINX Instance Manager on a dedicated host. Then configure your NGINX deployments for reporting. After your deployments have registered with Instance Manager, you can view and track your usage over time from the web interface. If you [apply a JSON Web Token]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}) as a license for Instance Manager, you can send usage reports to F5 on a regular basis or on-demand when needed.

## Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}


## Tracking NGINX Plus and NGINX App Protect deployments

After you've installed NGINX Instance Manager, the next step is to configure your NGINX data plane to report usage metrics. You can do this by installing NGINX Agent on each instance or by setting up HTTP Health Checks. Both approaches enable your instances to relay data back to Instance Manager for detailed usage tracking. 

### Set up reporting on each instance {#set-up-reporting}

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

### View NGINX Plus and NGINX App Protect usage in NGINX Instance Manager {#view-nginx-plus-usage}

{{< include "nginx-plus/usage-tracking/view-nginx-plus-count.md" >}}

### Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).

## Tracking NGINX Ingress Controller and Kubernetes Connectivity Stack deployments

You can set up your Kubernetes-based NGINX products, including [NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/) and [Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/), to report data directly to the NGINX Instance Manager API.

To configure reporting for your NGINX Kubernetes products, follow these steps:

1. **Configure usage reporting for NGINX Kubernetes**: Follow the instructions in the [Enabling Usage Reporting](https://docs.nginx.com/nginx-ingress-controller/usage-reporting/) guide to enable usage reporting for NGINX Ingress Controller.
2. **Query the Kubernetes Usage API**: Use the following `curl` command to get a list of clusters and relevant deployment information, including node and pod counts:

   ```sh
   curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
   ```

3. **Apply a JWT License (Optional)**: Follow these steps to [apply a JWT license]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}). 

   To compare your usage with your entitled capacity, go to the **Settings > License** page in NGINX Management Suite.

   You have the option to regularly send usage data to F5 by enabling **Continuous Connection** on the **Licensing** page. Alternatively, you can submit data on-demand by selecting the **Send Usage to F5** button.


## Reporting product usage to F5

{{< include "nginx-plus/usage-tracking/reporting-usage.md" >}}
