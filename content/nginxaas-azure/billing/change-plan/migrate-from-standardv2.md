---
title: Migrate to new pricing plans
weight: 100
toc: true
url: /nginxaas/azure/billing/change-plan/migrate-between-plans/
type:
- how-to
---

## Overview

F5 NGINXaaS for Azure (NGINXaaS) supports in-place migration between certain pricing plans without requiring redeployment. This allows you to upgrade your deployment to access new features and capabilities while maintaining your existing configuration and avoiding downtime.

## Supported migration paths

The following in-place migrations are supported:

- **Basic → Developer**: Upgrade from the Basic plan to the Developer plan to access advanced features
- **Standard → Standard V3**: Upgrade from the legacy Standard plan to the modern Standard V3 plan
- **Standard V2 → Standard V3**: Upgrade from Standard V2 to Standard V3 to access the latest features and pricing model

{{< call-out "important" >}}
If you have a Standard or Standard V2 plan deployment, we encourage you to migrate to the Standard V3 plan as soon as possible. If you have a Basic plan deployment, we encourage you to migrate to the Developer plan as soon as possible. Legacy plans will stop receiving automatic updates that address critical security issues.
{{< /call-out >}}

## Migration steps

### Use the Azure portal

1. Go to the **Overview** page of the NGINXaaS deployment in the Azure portal.
2. Under **Essentials**, find the **Pricing Plan** and select **Click to Upgrade**.
3. Select the target plan you want to migrate to and select **Submit**.

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

2. Modify the SKU in the `azurerm_nginx_deployment` resource to your target plan:
   - For Developer plan: `developer_Monthly`
   - For Standard V3 plan: `standardv3_Monthly`

3. Run `terraform plan` and review the output to ensure your NGINXaaS deployment is being updated (not replaced).
4. Run `terraform apply` to complete the migration.

### Use the Azure CLI

Before running the migration command, ensure you have the latest Azure CLI nginx extension installed:

```shell
az extension update --name nginx --allow-preview true
```

Then run the command below to update your NGINXaaS deployment, replacing the SKU name with your target plan:

```shell
az nginx deployment update --name myDeployment --resource-group myResourceGroup \
  --sku name="<target_sku_name>"
```

Replace `<target_sku_name>` with one of the following:

- `developer_n7ja87drquhy` for Developer plan
- `standardv3_Monthly_n7ja87drquhy` for Standard V3 plan