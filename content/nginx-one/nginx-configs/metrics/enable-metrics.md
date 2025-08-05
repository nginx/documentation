---
# We use sentence case and present imperative tone
title: "Enable metrics"
# Weights are assigned in increments of 100: determines sorting order
weight: i00
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: tutorial
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGINX-One
---

The NGINX One Console dashboard relies on APIs for NGINX Plus and NGINX Open Source Stub Status to report traffic and system metrics. The following sections show you how to enable those metrics.

## Enable NGINX Plus API and dashboard

{{< include "/use-cases/monitoring/enable-nginx-plus-api.md" >}}

## Enable NGINX Plus API and dashboard with Config Sync Groups

To enable the NGINX Plus API and dashboard with [Config Sync Groups]({{< ref "nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}), add a file named `/etc/nginx/conf.d/dashboard.conf` to your shared group config. Any instance you add to that group automatically uses those settings.

{{< include "use-cases/monitoring/enable-nginx-plus-api-with-config-sync-group.md" >}}

## Enable NGINX Open Source Stub Status API 

{{< include "/use-cases/monitoring/enable-nginx-oss-stub-status.md" >}}
