---
title: Deploy using the Azure CLI
weight: 200
toc: true
url: /nginxaas/azure/getting-started/create-deployment/deploy-azure-cli/
type:
- how-to
---

## Overview

The Azure CLI has an extension to be used for management of F5 NGINXaaS for Azure (NGINXaaS) deployments whether that be locally or in continuous integration pipelines. This document links you to information around basic NGINXaaS extension usage.

## Prerequisites

- Install [Azure CLI with NGINXaaS extension]({{< ref "/nginxaas-azure/client-tools/cli.md" >}})

## Create a deployment

To create an NGINXaaS for Azure resource use the `az nginx deployment create` command:

```bash
az nginx deployment create --deployment-name
                           --resource-group
                           [--auto-upgrade-profile]
                           [--enable-diagnostics {0, 1, f, false, n, no, t, true, y, yes}]
                           [--identity]
                           [--location]
                           [--logging]
                           [--network-profile]
                           [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                           [--scaling-properties]
                           [--sku]
                           [--tags]
                           [--user-profile]
```

### Examples

- Create a deployment with public IP:

   ```bash
   az nginx deployment create --name myDeployment --resource-group \
      myResourceGroup --location eastus2 --sku name="standardv2_Monthly" \
      --network-profile front-end-ip-configuration="{public-ip-addresses:[{id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/myPublicIP}]}" \
      network-interface-configuration="{subnet-id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet}"
   ```

- Create a deployment with private IP:

   ```bash
   az nginx deployment create --name myDeployment --resource-group \
      myResourceGroup --location eastus2 --sku \
      name="standardv2_Monthly" --network-profile \
      front-end-ip-configuration="{private-ip-addresses:[{private-ip-allocation-method:Static,subnet-id:/subscriptions/mySubscription/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet,private-ip-address:10.0.0.2}]}" \
      network-interface-configuration="{subnet-id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet}"
   ```

   ```bash
   az nginx deployment create --name myDeployment --resource-group \
      myResourceGroup --location eastus2 --sku \
      name="standardv2_Monthly" --network-profile \
      front-end-ip-configuration="{private-ip-addresses:[{private-ip-allocation-method:Dynamic,subnet-id:/subscriptions/mySubscription/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet,private-ip-address:10.0.0.2}]}" \
      network-interface-configuration="{subnet-id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet}"
   ```

- Create a dual-stack (IPv4 + IPv6) NGINXaaS deployment with public IPs:

   ```bash
   az nginx deployment create --name myDeployment --resource-group \
      myResourceGroup --location eastus2 --sku name="standardv2_Monthly" \
      --network-profile front-end-ip-configuration="{public-ip-addresses:[{id:/subscriptions/mySubscription/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/pubIPv4},{id:/subscriptions/mySubscription/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/pubIPv6}]}" \
      network-interface-configuration="{subnet-id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet}"
   ```

- Create a dual-stack (IPv4 + IPv6) NGINXaaS deployment with private IPs:

   ```bash
   az nginx deployment create --name myDeployment --resource-group \
      myResourceGroup --location eastus2 --sku \
      name="standardv2_Monthly" --network-profile \
      front-end-ip-configuration="{private-ip-addresses:[{private-ip-allocation-method:Static,subnet-id:/subscriptions/mySubscription/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet,private-ip-address:10.0.0.2},{private-ip-allocation-method:Static,subnet-id:/subscriptions/mySubscription/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet,private-ip-address:2001:0db8:85a3:0000:0000:8a2e:0370:7334}]}" \
      network-interface-configuration="{subnet-id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet}"
   ```

- Create a deployment with managed identity, storage account and scaling:

   ```bash
   az nginx deployment create --deployment-name myDeployment --resource-group \
      myResourceGroup --location eastus2 --sku name=standardv2_Monthly \
      --network-profile \
      network-interface-configuration='{subnet-id:/subscriptions/subscriptionId/resourcegroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/vnet-azclitest/subnets/mySubnet}' \
      front-end-ip-configuration='{public-ip-addresses:[{id:/subscriptions/subscriptionId/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/myPublicIP}]}' \
      --identity '{"type":"UserAssigned","userAssignedIdentities":{"/subscriptions/subscriptionId/resourcegroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity":{}}}' \
      --logging storage-account='{"account-name":"myStorageAccount","container-name":"myContainer"}' \
      --scaling-properties capacity=10
   ```

See the [Azure CLI Deployment Create Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment#az-nginx-deployment-create) for more details on the required and optional parameters.

## Update a deployment

To update an NGINXaaS for Azure resource use the `az nginx deployment update` command:

```bash
az nginx deployment update [--add]
                           [--auto-upgrade-profile]
                           [--deployment-name]
                           [--enable-diagnostics {0, 1, f, false, n, no, t, true, y, yes}]
                           [--force-string {0, 1, f, false, n, no, t, true, y, yes}]
                           [--identity]
                           [--ids]
                           [--location]
                           [--logging]
                           [--network-profile]
                           [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                           [--remove]
                           [--resource-group]
                           [--scaling-properties]
                           [--set]
                           [--sku]
                           [--subscription]
                           [--tags]
                           [--user-profile]
```

### Example

- Update tags and enable diagnostics support for a deployment:

   ```bash
   az nginx deployment update --name myDeployment --resource-group \
   myResourceGroup --location eastus2 --tags tag1="value1" \
   tag2="value2" --enable-diagnostics
   ```

Update an NGINXaaS deployment to a dual-stack (IPv4 + IPv6) network configuration with public IPs:

   ```bash
   az nginx deployment update --name myDeployment --resource-group myResourceGroup \
      --network-profile front-end-ip-configuration="{public-ip-addresses:[{id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/pubIPv4},{id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/pubIPv6}]}" \
      network-interface-configuration="{subnet-id:/subscriptions/mySubscriptionID/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet}"
   ```

See the [Azure CLI Deployment Update Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment#az-nginx-deployment-update) for more details on the required and optional parameters.


## Delete a deployment

Use the `az nginx deployment delete` command to delete an NGINXaaS for Azure resource:

```bash
az nginx deployment delete [--name]
                           [--ids]
                           [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                           [--resource-group]
                           [--subscription]
                           [--yes]
```

### Example

- Delete a deployment:

   ```bash
   az nginx deployment delete --name myDeployment \
      --resource-group myResourceGroup
   ```

See the [Azure CLI Deployment Delete Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment#az-nginx-deployment-delete) for more details on the required and optional parameters.

## Additional resources

- [Azure CLI Public IP Documentation](https://learn.microsoft.com/en-us/cli/azure/network/public-ip)
- [Azure CLI Storage Container Documentation](https://learn.microsoft.com/en-us/cli/azure/storage/container)
