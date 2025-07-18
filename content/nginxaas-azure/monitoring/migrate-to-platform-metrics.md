---
title: Migrate from Custom metrics to Platform metrics
weight: 1000
toc: true
url: /nginxaas/azure/monitoring/migrate-to-platform-metrics/
type:
- how-to
---

## Overview

F5 NGINXaaS for Azure previously supported monitoring through [Custom Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-custom-overview), which is a preview feature in Azure. Support for Custom Metrics will be removed in the future. We've added support for Platform Metrics, which is the recommended way to monitor resources in Azure. We strongly recommend switching your deployment's monitoring to Platform Metrics to take advantage of lower latency and better reliability.

## Migration steps

Follow the steps in this section to migrate your deployment monitoring from Custom metrics to Platform metrics.

1. Verify that your NGINXaaS deployment meets the [pre-requisites]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md#prerequisites">}}) for Platform metrics to work.
2. If the pre-requisites are met, Platform metrics are enabled by default on all NGINXaaS deployment. Verify that you are able to see the new metrics in Azure Monitor under the `Standard Metrics` namespace.
3. Turn off legacy monitoring:

   - Using the Azure portal
     1. In the Azure portal, go to the **NGINX monitoring** page for your NGINXaaS deployment.
     2. Turn off the **Send metrics to Azure Monitor** setting.
     3. Select **Save**.

   - Using Terraform
     1. Set `diagnose_support_enabled` to false in the `azurerm_nginx_deployment` resource.
     2. Run `terraform plan` followed by `terraform apply` to upgrade the deployment.

   - Using the Azure CLI
     Run the following command:
     ```shell
     az nginx deployment update --name myDeployment --resource-group \
     myResourceGroup --enable-diagnostics="false"
     ```
