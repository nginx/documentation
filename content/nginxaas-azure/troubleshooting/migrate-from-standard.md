---
title: "Migrating from Standard to Standard V2"
weight: 200
categories: ["tasks"]
toc: true
url: /nginxaas/azure/troubleshooting/migrate-from-standard/
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) now supports in-place migration from Standard plan to the Standard V2 plan, we encourage you to upgrade your deployment to the Standard V2 plan as soon as possible. **The Standard plan is scheduled for retirement on May 1, 2025**. If you fail to migrate by May 1, 2025, your NGINXaaS deployment will stop receiving automatic updates that address critical security issues.

The Standard V2 plan maintains the same price as the Standard plan for existing capabilities. Enabling new capabilities such as NGINX App Protect WAF or additional listen ports that were added as part of Standard V2 will incur additional charges.

{{< note >}} We currently only support in-place migration from Standard plan to the Standard V2 plan. Please avoid updating your Basic plan deployments to Standard V2 plan using this guide. {{< /note >}}

## Migration Steps

### Using the Portal

1. Go to the **Overview** page of the NGINXaaS deployment in the Azure portal.
2. Under **Essentials**, find the **Pricing Tier** and select **Click to Upgrade**.
3. Select the Standard V2 plan and select Submit.

### Using Terraform

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

2. Modify the SKU to `standardv2_Monthly` in the azurerm_nginx_deployment resource.
3. Run `terraform plan`. Look at the output of terraform plan to ensure that your NGINXaaS deployment is not being replaced.
4. Run `terraform apply` to upgrade the deployment.

### Using Azure-cli

Run the below command to update your NGINXaaS deployment.

```bash
   az nginx deployment update --name myDeployment --resource-group \
   myResourceGroup --sku name="standardv2_Monthly_gmz7xq9ge3py"
```
