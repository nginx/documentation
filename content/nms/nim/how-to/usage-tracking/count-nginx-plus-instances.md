---
title: "Track NGINX Plus and NGINX App Protect Usage"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This guide will help you track and report your NGINX Plus and NGINX App Protect usage. You may be required to report this information if you are enrolled in a commercial plan such as [F5's Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program)."

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

NGINX Management Suite Instance Manager makes it easy to track and report your NGINX Plus and NGINX App Protect usage. You may be expected to report this information to F5 if you're enrolled in a commercial program, such as the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program).

Start by installing NGINX Instance Manager on a dedicated host. Then configure your NGINX data plane for reporting. After your data plane instances have registered with Instance Manager, you can to view and track your NGINX Plus and NGINX App Protect deployments over time from the web interface. If you [apply a JSON Web Token]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}) as a license for Instance Manager, you can send usage reports to F5 on a regular basis or on-demand when needed.


## Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}

## Set up reporting on each data plane system {#set-up-reporting}

Choose a tab below based on how you'd like to set up reporting for your NGINX data plane systems.

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

## View NGINX Plus and NGINX App Protect usage {#view-nginx-plus-usage}

{{< include "nginx-plus/usage-tracking/view-nginx-plus-count.md" >}}

## Reporting product usage to F5

{{< include "nginx-plus/usage-tracking/reporting-usage.md" >}}

## Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).
