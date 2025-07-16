---
title: Upgrade channels
weight: 150
toc: true
nd-docs: DOCS-1480
url: /nginxaas/azure/quickstart/upgrade-channels/
type:
- how-to
---

## Overview

Maintaining the latest version NGINX Plus, operating system (OS), and other software dependencies is a key feature offered by F5 NGINX as a Service for Azure (NGINXaaS). The **Upgrade Channel** is an upgrade path to which you can subscribe your NGINXaaS deployment to control the timing of software upgrades. The following channels are available:

{{<bootstrap-table "table table-striped table-bordered">}}
| Channel     | Description               |
|-------------|---------------------------|
| preview     | Selecting this channel automatically upgrades your deployment to the latest supported version of NGINX Plus and its dependencies soon after they become available. We recommend using this setting to try out new capabilities in deployments running in your development, testing, and staging environments. Avoid using it in your production environment. |
| stable      | A deployment running on this channel will receive updates on NGINX Plus and its dependencies at a slower rate than the **Preview** channel. We recommend using this setting for production deployments where you might want stable features instead of the latest ones. This is the **default channel** if you do not specify one for your deployment. |
{{</bootstrap-table>}}

{{<note>}} All channels will receive continuous updates related to OS patches, and security fixes.
{{</note>}}

## Availability of new features

### NGINX Plus and related modules

{{<bootstrap-table "table table-striped table-bordered">}}
| Channel     | Availablity of NGINX Plus and related modules |
|-------------|-----------------------------------------------|
| preview     | No sooner than 14 days of a new NGINX Plus [release](https://docs.nginx.com/nginx/releases/). |
| stable      | No sooner than 45 days of a new NGINX Plus [release](https://docs.nginx.com/nginx/releases/). |
{{</bootstrap-table>}}

A new version of NGINX Plus and its related modules is first introduced to the **preview** channel, where it is goes through our acceptance testing. Once we have baked the software in the **preview** channel for a reasonable time, it is eventually graduated to the **stable** channel. The actual promotion timelines can vary, and you can view our [Changelog]({{< ref "/nginxaas-azure/changelog.md" >}}) for latest updates.

## Changing the upgrade channel

To change the upgrade channel on your deployment using the Azure Portal:

1. Select **NGINX Upgrades** in the left menu.
1. Choose the desired **Upgrade Channel** from the dropdown menu.
1. Click **Submit**.
