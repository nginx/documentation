---
title: Use a certificate from Azure Key Vault
weight: 50
toc: true
url: /nginxaas/azure/quickstart/security-controls/certificates/
type:
- how-to
---

## Overview

This tutorial walks through a complete example of using SSL/TLS certificates from Azure Key Vault in an F5 NGINX as a Service for Azure (NGINXaaS) deployment to secure traffic. In this guide, you will create all necessary resources to add a certificate to an NGINXaaS deployment using the [Azure portal](https://portal.azure.com/).

## Create an Azure Key Vault (AKV)

NGINXaaS enables customers to securely store SSL/TLS certificates in Azure Key Vault. If you do not have a key vault, follow these steps to create one:

1. From the Azure portal menu, or from the **Home** page, select **Create a resource**.
1. In the Search box, enter **Key Vault** and select the **Key Vault** service.
1. Select **Create**.
1. On the Create a key vault **Basics** tab, provide the following information:

   {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Subscription                | Select the appropriate Azure subscription that you have access to. |
  | Resource group              | Specify whether you want to create a new resource group or use an existing one.<br> For more information, see [Azure Resource Group overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).         |
  | Key vault name              | Provide a unique name for your key vault. For this tutorial, we use `nginxaas-kv`. |
  | Region                      | Select the region you want to deploy to.   |
   {{</bootstrap-table>}}

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

   {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Method of Certificate Creation | Select **Generate** |
  | Certificate Name               | Provide a unique name for your certificate. For this tutorial, we use `nginxaas-cert`.       |
  | Type of Certificate Authority (CA) | Select **Self-signed certificate**. |
  | CN                      | Provide the IP address of your NGINXaaS deployment as the CN. For example, `CN=135.237.74.224` |
   {{</bootstrap-table>}}

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

   {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Scope                | Select **Key Vault**. |
  | Subscription              | Select the Azure subscription your key vault is in. |
  | Resource              | Select your key vault, `nginxaas-kv`. |
  | Role                      | Select **Key Vault Secrets User**.  |
   {{</bootstrap-table>}}

1. Select **Save**.

## Add your certificate to your NGINXaaS deployment

Now, you can add your SSL/TLS certificate from your key vault to your NGINXaaS deployment. For more information, see [Add certificates using the Azure portal]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}}).

1. Go to your NGINXaaS deployment.
1. Select **NGINX certificates** in the left menu.
1. Select {{< icon "plus">}}**Add certificate** and provide the following information:
   {{<bootstrap-table "table table-striped table-bordered">}}
   | Field                       | Description                |
   |---------------------------- | ---------------------------- |
   | Name                        | A unique name for the certificate. For this tutorial, we use `my-cert`. |
   | Certificate path            | Set to `/etc/nginx/ssl/example.crt`. |
   | Key path                    | Set to `/etc/nginx/ssl/example.key`. |
     {{</bootstrap-table>}}

1. Select **Select certificate** and provide the following information:

     {{<bootstrap-table "table table-striped table-bordered">}}
   | Field                  | Description                |
   |----------------------- | ---------------------------- |
   | Key vault                   | Select `nginxaas-kv`. |
   | Certificate            | Select `nginxaas-cert`. |
    {{</bootstrap-table>}}

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

## Configure Network Security Perimeter (NSP)

If you want to disable public access to your key vault, you can configure a [Network Security Perimeter (NSP)](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts). This will allow you to configure access rules to allow NGINXaaS to fetch certificates from your key vault while ensuring all other public access is denied.

1. Follow [Azure's documentation on prerequisites](https://learn.microsoft.com/en-us/azure/private-link/create-network-security-perimeter-portal#prerequisites) to ensure you are registed to create an NSP.
1. In the Search box, enter **Network Security Perimeters** and select **Network Security Perimeters** from the search results.
1. Select {{< icon "plus">}}**Create**.
1. In the **Basics** tab, provide the following information:
   {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Subscription                | Select the appropriate Azure subscription that you have access to. |
  | Resource group              | Specify whether you want to create a new resource group or use an existing one.<br> For more information, see [Azure Resource Group overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).         |
  | Name              | Provide a unique name for your network security perimeter. For this tutorial, we use `nginxaas-nsp`. |
  | Region                      | Select the region you want to deploy to. Refer to any [regional limitations](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts#regional-limitations) NSP has while in public preview. |
  | Profile name | Leave the profile name as the default `defaultProfile`. |
   {{</bootstrap-table>}}
1. In the **Resources** tab, select {{< icon "plus">}}**Add**.
1. Search for your key vault, `nginxaas-kv`, select it, and click **Select**.
1. In the **Inbound access rules** tab, select {{< icon "plus">}}**Add** and provide the following information:
   {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Rule Name               | Set to `allow-nginxaas-deployment-sub`. |
  | Source Type              | Select **Subscriptions**. |
  | Allowed sources                      | Select the subscription of your NGINXaaS deployment. |
   {{</bootstrap-table>}}
1. Select **Review + Create** and then **Create**.

By default, the key vault will be associated to the NSP in [Learning mode](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts#access-modes-in-network-security-perimeter). This means traffic will be evaluated first based on the NSP's access rules. If no rules apply, evaluation will fall back to the key vault's firewall configuration. To fully secure public access, it is reccommended to [transition to Enforced mode](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-transition#transition-to-enforced-mode-for-existing-resources).

1. Go to resource `nginxaas-nsp`.
1. Select **Associated resources** in the left menu.
1. Select the `nginxaas-kv` resource association.
1. Select **Change access mode**, set to **Enforced**, and select **Apply**.

{{< call-out "note" >}} If you are using the Azure portal to add certificates, you will also need to add an inbound access rule to allow your IP address, so the portal can list the certificates in your key vault. {{< /call-out >}}
