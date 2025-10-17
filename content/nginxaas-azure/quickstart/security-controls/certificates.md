---
title: Use a certificate from Azure Key Vault
weight: 50
toc: true
url: /nginxaas/azure/quickstart/security-controls/certificates/
type:
- how-to
---

## Overview

This tutorial walks through a complete example of using SSL/TLS certificates from Azure Key Vault in an F5 NGINXaaS for Azure (NGINXaaS) deployment to secure traffic. In this guide, you will create all necessary resources to add a certificate to an NGINXaaS deployment using the [Azure portal](https://portal.azure.com/).

## Create an Azure Key Vault (AKV)

NGINXaaS enables customers to securely store SSL/TLS certificates in Azure Key Vault. If you do not have a key vault, follow these steps to create one:

1. From the Azure portal menu, or from the **Home** page, select **Create a resource**.
1. In the Search box, enter **Key Vault** and select the **Key Vault** service.
1. Select **Create**.
1. On the Create a key vault **Basics** tab, provide the following information:

   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Subscription                | Select the appropriate Azure subscription that you have access to. |
  | Resource group              | Specify whether you want to create a new resource group or use an existing one.<br> For more information, see [Azure Resource Group overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).         |
  | Key vault name              | Provide a unique name for your key vault. For this tutorial, we use `nginxaas-kv`. |
  | Region                      | Select the region you want to deploy to.   |
   {{< /table >}}

   For all other fields, you can leave them set to the default values.
1. Select **Review + Create** and then **Create**.

## Create an NGINXaaS deployment

If you do not have an NGINXaaS deployment, follow the steps in [Deploy using the Azure portal]({{< ref "/nginxaas-azure/getting-started/create-deployment/deploy-azure-portal.md" >}}).

{{< call-out "note" >}} Your NGINXaaS deployment and your key vault must be in the same subscription. {{< /call-out >}}

## Add an SSL/TLS certificate to your key vault

Next, you can add an SSL/TLS certificate to your key vault by following [Azure's documentation to import an existing certificiate](https://learn.microsoft.com/en-us/azure/key-vault/certificates/tutorial-import-certificate?tabs=azure-portal), or you can generate a certificate. This tutorial will generate a self-signed certificate to quickly get started.

1. Go to your key vault, `nginxaas-kv`.
1. Select **Certificates** in the left menu.
1. Select {{< icon "plus">}}**Generate/Import** and provide the following information:

   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Method of Certificate Creation | Select **Generate** |
  | Certificate Name               | Provide a unique name for your certificate. For this tutorial, we use `nginxaas-cert`.       |
  | Type of Certificate Authority (CA) | Select **Self-signed certificate**. |
  | CN                      | Provide the IP address of your NGINXaaS deployment as the CN. For example, `CN=135.237.74.224` |
   {{< /table >}}

   For all other fields, you can leave them set to the default values.

1. Select **Create**.

## Assign a managed identity to your NGINXaaS deployment

In order for your NGINXaaS deployment to access your key vault, it must have an assinged managed idenity with the `Key Vault Secrets User` role. For more information, see [Assign Managed Identities]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}) and [Prerequisites for adding SSL/TLS certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md#prerequisites" >}}).

1. Go to your NGINXaaS deployment.
1. Select **Identity** in the left menu.
1. Under **System assigned**, ensure the status is set to "On".
  {{< call-out "note" >}} When you create a deployment through the Azure portal, a system-assigned managed identity is automatically enabled for your deployment. {{< /call-out >}}
1. Under **System assigned**, select **Azure role assignments**.
1. Select {{< icon "plus">}}**Add role assignment** and provide the following information:

   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Scope                | Select **Key Vault**. |
  | Subscription              | Select the Azure subscription your key vault is in. |
  | Resource              | Select your key vault, `nginxaas-kv`. |
  | Role                      | Select **Key Vault Secrets User**.  |
   {{< /table >}}

1. Select **Save**.

## Add your certificate to your NGINXaaS deployment

Now, you can add your SSL/TLS certificate from your key vault to your NGINXaaS deployment. For more information, see [Add certificates using the Azure portal]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}}).

1. Go to your NGINXaaS deployment.
1. Select **NGINX certificates** in the left menu.
1. Select {{< icon "plus">}}**Add certificate** and provide the following information:
   {{< table >}}
   | Field                       | Description                |
   |---------------------------- | ---------------------------- |
   | Name                        | A unique name for the certificate. For this tutorial, we use `my-cert`. |
   | Certificate path            | Set to `/etc/nginx/ssl/example.crt`. |
   | Key path                    | Set to `/etc/nginx/ssl/example.key`. |
     {{< /table >}}

1. Select **Select certificate** and provide the following information:

     {{< table >}}
   | Field                  | Description                |
   |----------------------- | ---------------------------- |
   | Key vault                   | Select `nginxaas-kv`. |
   | Certificate            | Select `nginxaas-cert`. |
    {{< /table >}}

1. Select **Add certificate**.

## Reference your certificate in your NGINX configuration

Once a certificate has been added to your NGINXaaS deployment, you can reference it in your NGINX configuration to secure traffic. Refer to [Upload an NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview.md">}}) to add and update NGINX configuration files to your NGINXaaS deployment. The following NGINX configurations show examples of different certificate use cases.

### Use case 1: SSL/TLS termination

NGINXaaS supports SSL/TLS termination by decrypting incoming encrypted traffic before forwarding it on to your upstream servers.

```nginx
http {
    upstream backend {
        server backend1.example.com:8000; # replace with your backend server address and port
    }

    server {
        listen 443 ssl;

        ssl_certificate /etc/nginx/ssl/example.crt;     # must match the Certificate path
        ssl_certificate_key /etc/nginx/ssl/example.key; # must match the Key path

        location / {
            proxy_pass http://backend;
        }
    }
}
```

For more information on using NGINX for SSL/TLS termination, see [NGINX SSL Termination](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/).

### Use case 2: Securing traffic to upstream servers

NGINXaaS supports backend encryption by encrypting traffic between your NGINXaaS deployment and your upstream servers.

```nginx
http {
    upstream backend {
        server backend1.example.com:8443; # replace with your backend server address and port
    }

    server {
        listen 80;

        location / {
            proxy_pass https://backend;
            proxy_ssl_certificate /etc/nginx/ssl/client.crt;     # must match the Certificate path
            proxy_ssl_certificate_key /etc/nginx/ssl/client.key; # must match the Key path
        }
    }
}
```

For more information on using NGINX to secure traffic to upstream servers, refer to [Securing HTTP Traffic to Upstream Servers](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/) and [Securing TCP Traffic to Upstream Servers](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-tcp-traffic-upstream/).


## Restrict Public Access to Key Vault

If you want to restrict public access to your key vault, you can configure:

- a [Network Security Perimeter (NSP)](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts). This will allow you to configure access rules to allow NGINXaaS to fetch certificates from your key vault while ensuring all other public access is denied.

- Allow access from a Virtual Network. This will allow you to configure access from the Virtual Network that is delegated to NGINXaaS while ensuring all other public access is denied.

- Integrate Azure Key Vault with [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview). To enhance network security, you can configure your vault to only allow connections through private endpoints. Traffic between NGINXaaS and AKV traverses over the Microsoft backbone network.

### Configure Network Security Perimeter (NSP)

1. Follow [Azure's documentation on prerequisites](https://learn.microsoft.com/en-us/azure/private-link/create-network-security-perimeter-portal#prerequisites) to ensure you are registed to create an NSP.
1. In the Search box, enter **Network Security Perimeters** and select **Network Security Perimeters** from the search results.
1. Select {{< icon "plus">}}**Create**.
1. In the **Basics** tab, provide the following information:
   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Subscription                | Select the appropriate Azure subscription that you have access to. |
  | Resource group              | Specify whether you want to create a new resource group or use an existing one.<br> For more information, see [Azure Resource Group overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).         |
  | Name              | Provide a unique name for your network security perimeter. For this tutorial, we use `nginxaas-nsp`. |
  | Region                      | Select the region you want to deploy to. |
  | Profile name | Leave the profile name as the default `defaultProfile`. |
   {{< /table >}}
1. In the **Resources** tab, select {{< icon "plus">}}**Add**.
1. Search for your key vault, `nginxaas-kv`, select it, and click **Select**.
1. In the **Inbound access rules** tab, select {{< icon "plus">}}**Add** and provide the following information:
   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Rule Name               | Set to `allow-nginxaas-deployment-sub`. |
  | Source Type              | Select **Subscriptions**. |
  | Allowed sources                      | Select the subscription of your NGINXaaS deployment. |
   {{< /table >}}
1. Select **Review + Create** and then **Create**.

By default, the key vault will be associated to the NSP in [Learning mode](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts#access-modes-in-network-security-perimeter). This means traffic will be evaluated first based on the NSP's access rules. If no rules apply, evaluation will fall back to the key vault's firewall configuration. To fully secure public access, it is reccommended to [transition to Enforced mode](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-transition#transition-to-enforced-mode-for-existing-resources).

1. Go to resource `nginxaas-nsp`.
1. Select **Associated resources** in the left menu.
1. Select the `nginxaas-kv` resource association.
1. Select **Change access mode**, set to **Enforced**, and select **Apply**.

{{< call-out "note" >}} If you are using the Azure portal to add certificates, you will also need to add an inbound access rule to allow your IP address, so the portal can list the certificates in your key vault. {{< /call-out >}}

### Integrate with Private Endpoint

1. Go to your key vault, `nginxaas-kv`.
1. Select **Settings** followed by **Networking** in the left menu.
1. Select the **Private endpoint connections** tab.
1. Select {{< icon "plus">}} **Create**
1. In the **Basics** tab, provide the following information:
   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Subscription                | Select the appropriate Azure subscription that you have access to. |
  | Resource group              | Specify whether you want to create a new resource group or use an existing one.<br> For more information, see [Azure Resource Group overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).         |
  | Name              | Provide a unique name for your private link. For this tutorial, we use `nginxaas-pl`. |
  | Region                      | Select the region you want to deploy to.
   {{< /table >}}

1. In the **Resources** tab, select **Resource Type** as `Microsoft.KeyVault/vaults` and **Resource** as `nginxaas-kv`
1. In the **Virtual Network** tab, provide the following information
   {{< table >}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Virtual network              | Select the virtual network delegated to your NGINXaaS deployment. |
  | Subnet                      | Select a subnet from your virtual network that is not being used.
   {{< /table >}}
1. In the **DNS** tab, use the default settings to integrate your private endpoint with a private DNS zone.
1. Select **Review + Create** and then **Create**.

Once a private link is configured and public access is disabled on Azure Key Vault, any certificates added to the NGINXaaS deployment will be fetched over the private link.

### Allow access from a Virtual Network

1. Go to your key vault, `nginxaas-kv`.
1. Select **Networking** in the left menu.
1. Select {{< icon "plus">}} **Add existing virtual network**.
1. Select the virtual network and subnet that is delegated to the NGINXaaS deployment.

{{< call-out "note" >}} Ensure that the Network Security Group on the subnet delegated to the NGINXaaS deployment allows outbound traffic to the internet{{< /call-out >}}
