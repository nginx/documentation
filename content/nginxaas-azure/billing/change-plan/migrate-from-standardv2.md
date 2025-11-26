---
title: Migrate from Standard V2 to Standard V3
weight: 100
toc: true
url: /nginxaas/azure/billing/change-plan/migrate-from-standardv2/
type:
- how-to
---

## Overview

F5 NGINXaaS for Azure (NGINXaaS) now supports in-place migration from Standard V2 plan to the Standard V3 plan, we encourage you to upgrade your deployment to the Standard V3 plan as soon as possible. If you fail to migrate, your NGINXaaS deployment will stop receiving automatic updates that address critical security issues.

The Standard V3 plan is an upgraded, purpose-built solution for modern enterprises looking to simplify application traffic management and scale workloads effortlessly. The Standard V3 pricing model is designed to optimize efficiency and transparency: customers benefit from an affordable fixed price per deployment ($0.25/hour) that covers baseline overhead, while NCU usage ($0.008/hour/unit) and data processing ($0.005/GB) allow costs to scale precisely with demand.

{{< call-out "note" >}} 
We currently only support in-place migration from Standard V2 plan to the Standard V3 plan and from Standard to Standard V3 plan. You cannot update your Basic plan deployments to Standard V3 plan using this guide.
{{< /call-out >}}

## Migration Steps

### Use the Azure the Portal

1. Go to the **Overview** page of the NGINXaaS deployment in the Azure portal.
2. Under **Essentials**, find the **Pricing Tier** and select **Click to Upgrade**.
3. Select the Standard V3 plan and select Submit.

### Use Terraform

1. Update the Terraform AzureRM provider to 4.6.0 or above.

```
terraform {
  required_version = "~> 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.6.0"
    }
  }
}
```

2. Modify the SKU to `standardv3_Monthly` in the azurerm_nginx_deployment resource.
3. Run `terraform plan`. Look at the output of terraform plan to ensure that your NGINXaaS deployment is not being replaced.
4. Run `terraform apply` to upgrade the deployment.

### Use the Azure-cli

Run the below command to update your NGINXaaS deployment.

```shell
   az nginx deployment update --name myDeployment --resource-group \
   myResourceGroup --sku name="standardv3_Monthly_n7ja87drquhy"
```
