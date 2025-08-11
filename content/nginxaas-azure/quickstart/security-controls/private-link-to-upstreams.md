---
title: Connect to upstreams with Azure Private Link
weight: 400
toc: true
url: /nginxaas/azure/quickstart/security-controls/private-link-to-upstreams/
type:
- how-to
---

[Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) eliminates exposure to the public internet by handling traffic over Microsoft's backbone network. This is especially useful if your NGINXaaS deployment and your upstreams are in different virtual networks.

{{< call-out "note" >}}Depending on your use-case, we recommend using [virtual network peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) instead of a Private Link service to maintain NGINX's load balancing capabilities.{{< /call-out >}}

To set up a Private Link between your NGINXaaS deployment and your upstreams, you'll need two resources:

- [Private Link service](https://learn.microsoft.com/en-us/azure/private-link/private-link-service-overview)
- [private endpoint](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview)

## Create a Private Link service

A Private Link service is an Azure resource that enables Private Link access to your application. If your upstream is an Azure PaaS service (for example, Azure Storage), then you do not need a Private Link service. To create a Private Link service,

1. Configure your upstream to run behind a Standard Load Balancer.
1. Add load balacing rules per upstream server port.
1. Create a Private Link service and attach it to the Standard Load Balancer.

The following example demonstrates this process using an existing virtual machine as the upstream.

<details close>
<summary>Create a Private Link service - Azure CLI</summary>

### Prerequisites

- Resource Group
- Virtual Network
- Subnet
- Workload Virtual Machine

Please ensure the following environment variables are exported before copying the below Azure CLI commands.

{{<bootstrap-table "table table-striped table-bordered">}}
  | Name              | Description       |
  |------------------ | ----------------- |
  | APP_LOCATION          | Location of the resource group
  | APP_RESOURCE_GROUP    | Name of the resource group the virtual machine is in          |
  | APP_VNET_NAME         | Name of the virtual network the virtual machine is in         |
  | APP_SUBNET_NAME       | Name of the subnet the virtual machine is in                  |
  | APP_VM_NAME           | Name of the workload virtual machine                          |
  | APP_NIC_NAME          | Name of the network interface of the virtual machine          |
  | APP_IP_CONFIG_NAME    | Name of the IP configuration associated with the NIC          |
{{</bootstrap-table>}}

### Create a load balancer

```bash
$ az network lb create \
    --resource-group $APP_RESOURCE_GROUP \
    --name load-balancer \
    --sku Standard \
    --vnet-name $APP_VNET_NAME \
    --subnet $APP_SUBNET_NAME \
    --frontend-ip-name frontend \
    --backend-pool-name backend-pool
```

### Create health probes and load balancing rules

Depending on your NGINX configuration, you will need to add a load balancing rule and health probe for each port your upstream servers are listening on. For example, given the following NGINX configuration snippet,

```nginx
upstream {
    server 10.0.1.4:8000;
}
```

Create a health probe monitoring on port `8000`:

```bash
$ az network lb probe create \
    --resource-group $APP_RESOURCE_GROUP \
    --lb-name load-balancer \
    --name 8000-probe \
    --protocol tcp \
    --port 8000
```

Create a load balancing rule listening on port `8000`:

```bash
$ az network lb rule create \
    --resource-group $APP_RESOURCE_GROUP \
    --lb-name load-balancer \
    --name 8000-rule \
    --protocol tcp \
    --frontend-port 8000 \
    --backend-port 8000 \
    --frontend-ip-name frontend \
    --backend-pool-name backend-pool \
    --probe-name 8000-probe \
    --idle-timeout 15 \
    --enable-tcp-reset true
```

### Configure the workload VM behind the load balancer

```bash
$ az network nic ip-config address-pool add \
  --address-pool backend-pool \
  --ip-config-name $APP_IP_CONFIG_NAME \
  --nic-name $APP_NIC_NAME \
  --resource-group $APP_RESOURCE_GROUP \
  --lb-name load-balancer
```

### Disable network policy

The `privateLinkServiceNetworkPolicies` setting must be disabled to add a private link service in a virtual network.

```bash
$ az network vnet subnet update \
    --name $APP_SUBNET_NAME \
    --vnet-name $APP_VNET_NAME \
    --resource-group $APP_RESOURCE_GROUP \
    --disable-private-link-service-network-policies yes
```

### Create a private link service

```bash
$ az network private-link-service create \
    --resource-group $APP_RESOURCE_GROUP \
    --name private-link-service \
    --vnet-name $APP_VNET_NAME \
    --subnet $APP_SUBNET_NAME \
    --lb-name load-balancer \
    --lb-frontend-ip-configs frontend \
    --location $APP_LOCATION
```

</details>

## Create a private endpoint

A private endpoint is a network interface that connects to a service powered by Azure Private Link. To connect your NGINXaaS to your upstreams using a private endpoint,

1. Add a new, non-delegated subnet in your NGINXaaS deployment's virtual network.
1. Create a private endpoint.
1. Update your NGINX configuration to reference the private endpoint.

The following example demonstrates this process using an existing NGINXaaS deployment and a Private Link service.

<details close>
<summary>Create a private endpoint - Azure CLI</summary>

### Prerequisites

- Resource Group
- Virtual Network
- NGINXaaS deployment
- Private Link service

Please ensure the following environment variables are exported before copying the below Azure CLI commands.

{{<bootstrap-table "table table-striped table-bordered">}}
  | Name              | Description       |
  |------------------ | ----------------- |
  | DEP_RESOURCE_GROUP                      | Name of the resource group the NGINXaaS deployment is in          |
  | DEP_VNET_NAME                           | Name of the virtual network the NGINXaaS deployment is in         |
  | PRIVATE_ENDPOINT_SUBNET_ADDRESS_SPACE   | Desired address space of the private endpoint's subnet            |
  | PRIVATE_LINK_SERVICE_ID                 | Resource ID of the Private Link service                           |
{{</bootstrap-table>}}

### Create a new subnet

You must create a new subnet for the private endpoint because the existing NGINXaaS deployment's subnet is already delegated.

```bash
$ az network vnet subnet create \
  --resource-group $DEP_RESOURCE_GROUP \
  --vnet-name $DEP_VNET_NAME \
  --name subnet-priv-endpoint \
  --address-prefix $PRIVATE_ENDPOINT_SUBNET_ADDRESS_SPACE
```

### Create a private endpoint

```bash
$ az network private-endpoint create \
    --connection-name connection-1 \
    --name private-endpoint \
    --private-connection-resource-id $PRIVATE_LINK_SERVICE_ID \
    --resource-group $DEP_RESOURCE_GROUP \
    --subnet subnet-priv-endpoint \
    --manual-request false \
    --vnet-name $DEP_VNET_NAME
```

### Update your NGINXaaS configuration with the private endpoint's IP address

First, get the IP address of the private endpoint:

```bash
$ export nic_id=$(az network private-endpoint show \
    --resource-group $DEP_RESOURCE_GROUP \
    --name private-endpoint \
    --query "networkInterfaces[0].id" \
    --output tsv)

$ az network nic show \
    --ids $nic_id \
    --query "ipConfigurations[0].privateIPAddress" \
    --output tsv
```

Then, reference it in your NGINX configuration's upstream servers. For example:

```nginx
upstream {
    server <private endpoint IP address>:8000;
}
```

</details>


## Additional Resources

The following guides provide step-by-step instructions to create a Private Link service and a private endpoint with your preferred client tool:


* [Azure portal](https://learn.microsoft.com/en-us/azure/private-link/create-private-link-service-portal?tabs=dynamic-ip)
* [Azure CLI](https://learn.microsoft.com/en-us/azure/private-link/create-private-link-service-cli)
* [ARM template](https://learn.microsoft.com/en-us/azure/private-link/create-private-link-service-template)

