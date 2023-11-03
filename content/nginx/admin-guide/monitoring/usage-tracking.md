---
title: "Tracking Usage for NGINX Products"
date: 2023-10-26T10:27:57-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to set up NGINX Instance Manager to track and report your NGINX products' usage. If you're enrolled in a commercial plan like the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program), you'll need to report these metrics."
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

With NGINX Management Suite Instance Manager, you can track and report on your NGINX products' usage; this is often required for commercial programs such as the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program). Once you've set up Instance Manager, you can configure your NGINX products to begin reporting. You can then view your deployments and track their usage over time. When you [apply a JSON Web Token]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}) from MyF5 to Instance Manager, you can send usage reports to F5 on a regular basis or on-demand when needed.

## Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}


## Tracking NGINX Plus and NGINX App Protect Deployments

After you've installed NGINX Instance Manager, the next step is to configure your NGINX Plus instances to report usage metrics. You can do this by installing NGINX Agent on each instance or by setting up HTTP Health Checks. Both approaches enable your instances to relay data back to Instance Manager for detailed usage tracking. 

### Set up reporting for each NGINX Plus instance {#set-up-reporting}

Select the tab that matches your preferred method for configuring reporting:

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



### View NGINX Plus usage in NGINX Instance Manager {#view-nginx-plus-usage}

{{< include "nginx-plus/usage-tracking/view-nginx-plus-count.md" >}}

### Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).

## Tracking NGINX Ingress Controller and Kubernetes Connectivity Stack Deployments

You can set up your Kubernetes-based NGINX products, including [NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/) and [Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/), to report data directly to the NGINX Instance Manager API.

To configure reporting for your NGINX Kubernetes products, follow these steps:

1. **Configure usage reporting for NGINX Kubernetes**: Follow the instructions in the [Enabling Usage Reporting](https://docs.nginx.com/nginx-ingress-controller/usage-reporting/) guide to enable usage reporting for NGINX Ingress Controller.
2. **Query the Kubernetes Usage API**: Use the following `curl` command to get a list of clusters and relevant deployment information, including node and pod counts:

   ```sh
   curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
   ```

3. **Apply a JWT License (Optional)**: Follow these steps to [apply a JWT license]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}). 

   To compare your usage with your entitled capacity, go to the **Settings > License** page in the NGINX Management Suite.

   You have the option to regularly send usage data to F5 by enabling **Continuous Connection** on the **Licensing** page. Alternatively, you can submit data on-demand by selecting the **Send Usage to F5** button.


## Reporting NGINX Product Usage to F5
