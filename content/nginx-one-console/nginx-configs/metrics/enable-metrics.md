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
nd-product: NONECO
---

The NGINX One Console dashboard and metrics views present system metrics and detailed NGINX metrics gathered through the NGINX Plus API or the Stub Status API and NGINX access log (for NGINX Open Source).

## Enable NGINX Plus Metrics

### Enable NGINX Plus API and dashboard

{{<tabs name="enable-nginx-metrics" >}}

{{%tab name="without SSL"%}}
{{< include "/use-cases/monitoring/enable-nginx-plus-api.md" >}}

{{% /tab %}}
{{%tab name="with SSL"%}}

{{< include "/use-cases/monitoring/enable-nginx-plus-api-with-ssl.md" >}}

{{% /tab %}}
{{% /tabs %}}

### Enable NGINX Plus API and dashboard with Config Sync Groups

To enable the NGINX Plus API and dashboard with [Config Sync Groups]({{< ref "/nginx-one-console/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}), add a file named `/etc/nginx/conf.d/dashboard.conf` to your shared group config. Any instance you add to that group automatically uses those settings.

{{< include "use-cases/monitoring/enable-nginx-plus-api-with-config-sync-group.md" >}}

### Enable NGINX Plus Metric Collection

{{< include "/use-cases/monitoring/enable-nginx-plus-status-zone-limited.md" >}}

After saving the changes, reload NGINX to apply the new configuration:

```shell
nginx -s reload
```

## Enable NGINX Open Source Metrics

{{< include "/use-cases/monitoring/enable-nginx-oss-metrics.md" >}}