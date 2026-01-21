---
title: Azure Resource Health
weight: 50
toc: false
url: /nginxaas/azure/monitoring/azure-resource-health/
nd-content-type: how-to
nd-product: NAZURE
---

## Overview

[Azure Resource Health](https://learn.microsoft.com/en-us/azure/service-health/resource-health-overview) is automatically enabled for all NGINXaaS deployments. It provides an up-to-date overview of deployment status and reveals ways in which NGINXaaS deployments may have become degraded over time. We encourage users to make full use of this functionality to maintain their deployments in a healthy state.

## Portal experience

Users can explore resource health by locating their NGINXaaS deployment in the Azure portal, opening the "Help" section on the Service menu and selecting "Resource health".

The **Resource Health** blade contains the health status of your NGINXaaS deployment as well a list of recent health events (if applicable).

If your deployment is degraded, the Azure Resource Health status message will include actions you can take to repair your deployment.

Users should follow Azure guidance to set up [alerting](https://learn.microsoft.com/en-us/azure/service-health/resource-health-alert-monitor-guide) for resource health events on their NGINXaaS deployments.

## Azure Resource Health API

Users can also interact with the [Azure Resource Health API](https://learn.microsoft.com/en-us/rest/api/resourcehealth/operation-groups) to unlock the functionality of Azure Resource Health.
