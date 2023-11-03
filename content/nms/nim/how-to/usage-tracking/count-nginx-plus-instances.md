---
title: "Tracking NGINX Plus and NGINX App Protect Usage"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to set up NGINX Instance Manager to track the usage of your NGINX Plus and NGINX App Protect deployments. Subscribers to commercial plans, like the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program), are expected to report the number of NGINX Plus instances they use."

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


This guide will help you track the usage of your NGINX Plus and NGINX App Protect deployments. Start by installing NGINX Instance Manager on a dedicated host, and then install NGINX Agent on each NGINX Plus instance you want to track. After doing this, you can view your NGINX Plus inventory in NGINX Instance Manager.

## Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}

## Set up reporting for each NGINX Plus instance {#set-up-reporting}

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

## View NGINX Plus usage in NGINX Instance Manager {#view-nginx-plus-usage}

{{< include "nginx-plus/usage-tracking/view-nginx-plus-count.md" >}}

## Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).
