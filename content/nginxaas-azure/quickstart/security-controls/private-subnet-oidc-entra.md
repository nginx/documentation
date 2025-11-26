---
title: OIDC with Microsoft Entra ID in Private Subnets
url: /nginxaas/azure/quickstart/security-controls/private-subnet-oidc-entra/
toc: true
weight: 350
nd-content-type: how-to
nd-product: NAZURE
---

## Overview

Learn how to configure F5 NGINXaaS for Azure with OpenID Connect (OIDC) authentication using Microsoft Entra ID when your NGINXaaS deployment is in a private subnet. This guide addresses the networking requirements to enable authentication traffic to reach Microsoft Entra ID endpoints while maintaining security controls.

When NGINXaaS is deployed in a private subnet, authentication traffic must reach external Microsoft Entra ID endpoints at `login.microsoftonline.com`. This guide provides the following solutions to enable this connectivity while controlling outbound traffic:

1. **Azure NAT Gateway with NSG rules** - Lower cost, simpler configuration
1. **Azure Firewall** - Higher security, more granular control

## Before you begin

To complete this guide, you need to set up the following:

- [An NGINXaaS deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment" >}}) with a private IP address
- A configured Microsoft Entra ID application registration. See [Configure Entra ID]({{< ref "/nginx/deployment-guides/single-sign-on/entra-id/#entra-setup" >}}) for detailed setup instructions.
- [SSL/TLS certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/" >}}) configured for your NGINXaaS deployment
- [Runtime State Sharing]({{< ref "/nginxaas-azure/quickstart/runtime-state-sharing.md" >}}) enabled on the NGINXaaS deployment

## Solution comparison

Choose the networking solution that best fits your security and cost requirements:

{{< table >}}
| Feature | Azure NAT Gateway | Azure Firewall |
|---------|-------------------|----------------|
| **Hourly cost** | Lower - see [NAT Gateway pricing](https://azure.microsoft.com/en-us/pricing/details/azure-nat-gateway/) | Higher - see [Firewall pricing](https://azure.microsoft.com/en-us/pricing/details/azure-firewall/) |
| **Address space** | Less required | More required (2 additional /26 subnets) |
| **Security** | Less secure - broader IP range filtering | More secure - precise FQDN-based filtering |
| **Configuration** | Simple setup, less overhead | More complex configuration, more overhead |
| **Public IPs** | 1 required | 2 required |
| **Filtering precision** | Generic rules enabling broader filtering | Surgical precision for traffic filtering |
{{< /table >}}

## Common configuration steps

Both solutions require these initial steps:

### Configure OIDC in NGINXaaS

1. Follow the standard [OIDC authentication]({{< ref "/nginxaas-azure/quickstart/security-controls/oidc/" >}}) guide with these Microsoft Entra ID specific considerations.

1. Set the `oidc_jwt_keyfile` endpoint in your `openid_connect_configuration.conf`:

   ```nginx
   # Use the correct Microsoft Entra ID keys endpoint
   map $host $oidc_jwt_keyfile {
       default "https://login.microsoftonline.com/<tenant-id>/discovery/v2.0/keys";
   }
   ```

   {{< call-out "note" >}}The `oidc_jwt_keyfile` endpoint is not listed in the Microsoft App Registration's endpoints pane but is required for proper OIDC configuration.{{< /call-out >}}

1. Configure DNS resolution appropriately:
   - For dual-stack subnets, ensure both IPv4 and IPv6 address spaces are configured
   - Use Azure DNS (127.0.0.1:49153) or configure firewall rules for your preferred DNS service

   ```nginx
   http {
       # For IPv4-only deployments
       resolver 127.0.0.1:49153 ipv4=on ipv6=off valid=300s;

       # For dual-stack deployments
       resolver 127.0.0.1:49153 ipv4=on valid=300s;
   }
   ```

   {{< call-out "important" >}}If you plan to use IPv6 addresses on the frontend, ensure your subnet is dual-stack with both IPv4 and IPv6 address spaces. For IPv4-only deployments, set `ipv6=off` in your resolver configuration.{{< /call-out >}}

## Configure connectivity using Azure NAT Gateway

This solution uses Azure NAT Gateway with Network Security Group (NSG) rules to enable controlled outbound connectivity.

### Configure NSG rules

When you create an NGINXaaS deployment, Azure automatically creates and attaches an NSG to the delegated subnet. You need to modify this NSG to allow Microsoft Entra ID connectivity.

1. Add Microsoft IP address ranges to NSG rules:

   Navigate to your NGINXaaS subnet's NSG and add inbound and outbound rules for the Microsoft IP addresses listed in the [Microsoft 365 URLs and IP address ranges documentation](https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide#microsoft-365-common-and-office-online) under section #56.

1. Create a custom outbound rule to deny general internet access:

   - **Priority**: Higher numerical value (lower priority) than the Microsoft IP rules
   - **Action**: Deny
   - **Destination**: Internet
   - **Purpose**: Override the default `AllowInternetOutBound` rule

   {{< call-out "important" >}}The default `AllowInternetOutBound` rule cannot be edited, so you must create a higher-priority rule to deny general internet access while allowing the specific Microsoft IP ranges. The priority of the custom deny rule should be a higher numerical value (lower priority) than the Microsoft IP allow rules.{{< /call-out >}}

### Create and configure Azure NAT Gateway

1. Create an Azure NAT Gateway:

   ```bash
   # Create Azure NAT Gateway
   az network nat gateway create \
     --resource-group <resource-group> \
     --name <nat-gateway-name> \
     --location <location> \
     --public-ip-addresses <public-ip-name>
   ```

1. Associate the Azure NAT Gateway with your NGINXaaS subnet:

   ```bash
   # Associate Azure NAT Gateway with subnet
   az network vnet subnet update \
     --resource-group <resource-group> \
     --vnet-name <vnet-name> \
     --name <nginxaas-subnet-name> \
     --nat-gateway <nat-gateway-name>
   ```

This configuration allows NGINXaaS to reach Microsoft Entra ID endpoints while blocking general internet access.

{{< call-out "note" >}}Using Azure NAT Gateway with NSG rules still requires allowing broad IP address ranges. Based on Microsoft's documentation, you need to allow at least two /18 subnets and two /19 subnets for complete Microsoft Entra ID connectivity. For more precise filtering, consider using Azure Firewall instead.{{< /call-out >}}

## Configure connectivity using Azure Firewall

This solution provides more granular control using Azure Firewall with DNS-based filtering.

{{< call-out "note" >}}Azure Firewall provides DNS-based filtering capabilities but comes at a significantly higher cost compared to Azure NAT Gateway (approximately 28x cost increase). However, it enables more precise firewall rules for better security.{{< /call-out >}}

### Create firewall subnets

Create two new subnets in your virtual network:

1. **Azure Firewall subnet**:
   - Name: `AzureFirewallSubnet` (immutable)
   - Address space: /26 subnet
   - Purpose: Azure Firewall

1. **Firewall Management subnet**:
   - Name: `AzureFirewallManagementSubnet` (immutable)
   - Address space: /26 subnet
   - Purpose: Firewall Management

```bash
# Create Azure Firewall subnet
az network vnet subnet create \
  --resource-group <resource-group> \
  --vnet-name <vnet-name> \
  --name AzureFirewallSubnet \
  --address-prefixes <firewall-subnet-cidr>

# Create Firewall Management subnet
az network vnet subnet create \
  --resource-group <resource-group> \
  --vnet-name <vnet-name> \
  --name AzureFirewallManagementSubnet \
  --address-prefixes <management-subnet-cidr>
```

### Create Azure Firewall

1. Create the firewall with Standard SKU (required for DNS proxy functionality):

   ```bash
   # Create public IPs for firewall
   az network public-ip create \
     --name <firewall-public-ip> \
     --resource-group <resource-group> \
     --allocation-method Static \
     --sku Standard

   az network public-ip create \
     --name <firewall-mgmt-public-ip> \
     --resource-group <resource-group> \
     --allocation-method Static \
     --sku Standard

   # Create firewall with new policy
   az extension add --name azure-firewall
   az network firewall create \
     --name <firewall-name> \
     --resource-group <resource-group> \
     --vnet-name <vnet-name> \
     --public-ip <firewall-public-ip> \
     --firewall-policy <firewall-policy-name>
   ```

   {{< call-out "note" >}}The Standard SKU is required at minimum because it allows Azure Firewall to be configured as a DNS proxy, which is necessary for FQDN-based filtering. During creation, choose to create a new Firewall Policy and use your existing virtual network that contains the NGINXaaS subnet.{{< /call-out >}}

### Configure firewall policy

1. Enable DNS proxy in the firewall policy:

   ```bash
   # Enable DNS proxy
   az network firewall policy update \
     --name <firewall-policy-name> \
     --resource-group <resource-group> \
     --enable-dns-proxy true \
     --dns-servers 168.63.129.16
   ```

1. Configure private IP ranges to avoid SNAT for internal traffic:

   Navigate to your firewall policy in the Azure portal and under **Private IP ranges**, select "Always" or specify your NGINXaaS subnet IP addresses.

### Create network rules

Create a network rule collection to allow NGINXaaS subnet access to Microsoft Entra ID:

```bash
# Create network rule collection
az network firewall policy rule-collection-group create \
  --name NetworkRuleCollectionGroup \
  --policy-name <firewall-policy-name> \
  --resource-group <resource-group> \
  --priority 200

# Add network rule for Microsoft Entra ID
az network firewall policy rule-collection-group collection add-filter-collection \
  --name EntraIDAccess \
  --policy-name <firewall-policy-name> \
  --resource-group <resource-group> \
  --collection-priority 100 \
  --rule-collection-group-name NetworkRuleCollectionGroup \
  --action Allow \
  --rule-name AllowEntraID \
  --rule-type NetworkRule \
  --protocols TCP \
  --source-addresses <nginxaas-subnet-cidr> \
  --destination-fqdns login.microsoftonline.com \
  --destination-ports 443
```

### Configure route table

Direct NGINXaaS subnet traffic through the firewall:

1. Note the private IP address of your Azure Firewall (found in the firewall's overview page).

1. Create a route table:

   ```bash
   # Create route table
   az network route-table create \
     --name <route-table-name> \
     --resource-group <resource-group> \
     --location <location>

   # Add default route pointing to firewall
   az network route-table route create \
     --route-table-name <route-table-name> \
     --resource-group <resource-group> \
     --name DefaultRoute \
     --address-prefix 0.0.0.0/0 \
     --next-hop-type VirtualAppliance \
     --next-hop-ip-address <firewall-private-ip>
   ```

1. Associate the route table with the NGINXaaS subnet:

   ```bash
   # Associate route table with NGINXaaS subnet
   az network vnet subnet update \
     --resource-group <resource-group> \
     --vnet-name <vnet-name> \
     --name <nginxaas-subnet-name> \
     --route-table <route-table-name>
   ```

## Testing the configuration

After implementing either solution, test the OIDC authentication:

1. Access your NGINXaaS deployment URL.
1. Verify you are redirected to Microsoft Entra ID for authentication.
1. Complete the login process and confirm successful authentication.
1. Check NGINXaaS logs for any connectivity issues.

### Troubleshooting

If authentication fails, check the following:

1. **DNS Resolution**: Ensure your firewall rules allow DNS queries.
1. **Certificate Validation**: Verify that the firewall allows HTTPS traffic to Microsoft endpoints.
1. **Timeout Settings**: Increase timeout values if experiencing slow authentication responses.
1. **Route Configuration**: Confirm the route table is properly associated with the NGINXaaS subnet.

## To secure your systems, address the following:

- **Principle of Least Privilege**: Both solutions limit outbound connectivity to only required Microsoft endpoints.
- **Monitoring**: Implement logging and monitoring for authentication traffic.
- **Regular Updates**: Keep Microsoft IP address ranges updated in your NSG rules.
- **Network Segmentation**: Consider additional network segmentation for enhanced security.

## To optimize your systems, we recommend:

- **Azure NAT Gateway**: More cost-effective for basic filtering needs.
- **Azure Firewall**: Better ROI when you need advanced filtering capabilities.
- **Public IP Management**: Minimize the number of public IP addresses to reduce costs.

Both solutions enable the minimal connectivity required between NGINXaaS and Microsoft Entra ID for OIDC authentication while maintaining security controls appropriate to your requirements.

## See also

- [Set up OIDC authentication]({{< ref "/nginxaas-azure/quickstart/security-controls/oidc/" >}})
- [Single Sign-On with Microsoft Entra ID]({{< ref "/nginx/deployment-guides/single-sign-on/entra-id.md" >}})
- [Private Link to Upstreams]({{< ref "/nginxaas-azure/quickstart/security-controls/private-link-to-upstreams.md" >}})
- [Microsoft 365 URLs and IP address ranges](https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges)
