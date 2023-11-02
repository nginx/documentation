---
title: "Tracking Usage for NGINX Plus and NGINX App Protect"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to set up NGINX Instance Manager and NGINX Agent to track and report your NGINX Plus instances. If you're enrolled in a commercial plan like the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program), you'll need to report your instance count. This guide shows you how to view your NGINX Plus inventory in Instance Manager."

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

This guide will help you track your NGINX Plus instances and their usage. Get started by installing NGINX Instance Manager on a dedicated host and NGINX Agent on each NGINX Plus instance you want to track. You can then use the NGINX Instance Manager web interface to view your NGINX Plus inventory and export the list of your NGINX Plus instances if needed.


## Install NGINX Instance Manager on a dedicated host {#install-instance-manager}

{{< include "nginx-plus/usage-tracking/install-nim.md" >}}

## Install NGINX Agent on each NGINX Plus instance {#install-nginx-agent}

{{< include "nginx-plus/usage-tracking/install-nginx-agent.md" >}}

## Viewing tracked NGINX Plus instances in NGINX Instance Manager {#view-nginx-plus-inventory}

{{< include "nginx-plus/usage-tracking/view-nginx-plus-count.md" >}}

## Special Considerations

### How to track NGINX Plus instances without using NGINX Agent {#track-nginx-plus-without-nginx-agent}

{{<include "nginx-plus/usage-tracking/http-health-check.md" >}}

## Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).
