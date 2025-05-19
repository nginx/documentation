---
title: Overview and prerequisites
weight: 100
toc: true
docs: DOCS-880
url: /nginxaas/azure/getting-started/prerequisites/
type:
- how-to
---

## NGINX Plus users

If you are an existing F5 NGINX Plus user and you want to migrate to F5 NGINX as a Service for Azure (NGINXaaS), you need to know the following:

- In NGINX Plus, you SSH into the NGINX Plus system, store your certificates in the file system, and configure the network and subnet to connect to NGINX Plus.

- For NGINXaaS, you need to store your certificates in Azure Key Vault and configure NGINXaaS in the same VNet or peer to the VNet in which NGINXaaS is deployed.

You will need to move your certificates from NGINX Plus to the Azure Key Vault. You can do this by using the [Azure CLI]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-azure-cli.md" >}}) or the [Azure portal]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}}).

## Before you begin

Before you deploy NGINXaaS you need to meet the following prerequisites:

- An Azure account with an active subscription (if you don’t have one, [create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F)).

- [Confirm that you have the appropriate access](https://docs.microsoft.com/en-us/azure/role-based-access-control/check-access) before starting the setup:

  - The simplest approach is to use Azure’s built-in [Owner](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) role on either a specific resource group or the subscription.

  - It's possible to complete a limited setup with the built-in [Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) role.


- The specific Azure permissions required to deploy NGINXaaS are:

   - microsoft.network/publicIPAddresses/join/action
   - nginx.nginxplus/nginxDeployments/Write
   - microsoft.network/virtualNetworks/subnets/join/action
   - nginx.nginxplus/nginxDeployments/configurations/Write
   - nginx.nginxplus/nginxDeployments/certificates/Write

- Additionally, if you are creating the Virtual Network or IP address resources that NGINXaaS for Azure will be using, then you probably also want those permissions as well.

- Note that assigning the managed identity permissions normally requires an "Owner" role.

## What's next

[Create a Deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment/" >}})
