---
title: Migrate from Custom Metrics to Platform Metrics
weight: 1000
toc: true
url: /nginxaas/azure/getting-started/migrate-to-platform-metrics/
type:
- how-to
---

## Overview
NGINXaaS previously supported monitoring using [Custom Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-custom-overview). Custom metrics is a preview feature in Azure and support for it will be dropped in the future. We have added support for Platform metrics which is the Azure recommended way for monitoring resources, we strongly recommend you to migrate your deployments monitoring to use Platform metrics to take advantage of reduced latency and higher reliability.

## Migration Steps
This section contains instructions on how to migrate your deployment monitoring from Custom Metrics to Platform Metrics.

1. Verify that your NGINXaaS deployment meets the [pre-requisites]({{< relref "/nginxaas-azure/monitoring/enable-monitoring.md#prerequisites">}}) for Platform metrics to work.
2. If the per-requisites are met, Platform metrics are enabled by default on all NGINXaaS deployment. Verify that you are able to see the new metrics in Azure Monitor under the `Standard Metrics` namespace.
3. Turn off legacy monitoring.

   - **Using Portal**  
     1. Go to the **NGINX monitoring** page of the NGINXaaS deployment in the Azure portal.  
     2. Toggle Off the `Send metrics to Azure Monitor` switch.  
     3. Click Save.  

   - **Using Terraform**  
     1. Set `diagnose_support_enabled` to false in the `azurerm_nginx_deployment` resource.  
     2. Run `terraform plan` followed by `terraform apply` to upgrade the deployment.  

   - **Using Azure CLI**  
     Run the command below:  
     ```bash
     az nginx deployment update --name myDeployment --resource-group \
     myResourceGroup --enable-diagnostics="false"
     ```