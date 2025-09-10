---
title: Add certificates using the Azure portal
weight: 100
toc: true
nd-docs: DOCS-875
url: /nginxaas/azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal/
type:
- how-to
---

## Overview

You can manage SSL/TSL certificates for F5 NGINX as a Service for Azure (NGINXaaS) using the Azure portal.

## Prerequisites

{{< include "/nginxaas-azure/ssl-tls-prerequisites.md" >}}

### Adding an SSL/TLS certificate

Before you begin, refer Azure documentation to [Import a certificate to your Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/certificates/tutorial-import-certificate?tabs=azure-portal#import-a-certificate-to-your-key-vault).

1. Go to your NGINXaaS for Azure deployment.

1. Select **NGINX certificates** in the left menu.

1. Select {{< icon "plus">}}**Add certificate**.

1. Provide the required information:

   {{<bootstrap-table "table table-striped table-bordered">}}
   | Field                       | Description                |
   |---------------------------- | ---------------------------- |
   | Name                        | A unique name for the certificate. |
   | Certificate path            | This path can match one or more `ssl_certificate` directive file arguments in your NGINX configuration.<br>The certificate path must be unique within the same deployment. |
   | Key path                    | This path can match one or more `ssl_certificate_key` directive file arguments in your NGINX configuration.<br> The key path must be unique within the same deployment.<br> The key path and certificate path can be the same within the certificate. |
     {{</bootstrap-table>}}

     - The **Select certificate** button will take you to a new screen where you will need to provide the following information:

     {{<bootstrap-table "table table-striped table-bordered">}}
   | Field                  | Description                |
   |----------------------- | ---------------------------- |
   | Key vault                   | Select from the available key vaults. |
   | Certificate            | Select the certificate you want to add from the previously selected key vault. |
     {{</bootstrap-table>}}

      If you need to create a new key vault or certificate, you can do so by selecting **Create new key vault** or **Create new** under the **Key Vault** and **Certificate** fields, respectively.

      {{< call-out "note" >}}If specifying an absolute file path as the `Certificate path` or `Key path`, see the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}) for the allowed directories the file can be written to.{{< /call-out >}}

      {{< call-out "note" >}}A certificate added to an NGINXaaS for Azure deployment using the Azure Portal refers to an unversioned Azure Key Vault (AKV) secret identifier. To add a certificate with a versioned AKV secret identifier, follow the documented steps with alternative [Client tools]({{< ref "/nginxaas-azure/client-tools/_index.md" >}}) for NGINXaaS for Azure.{{< /call-out >}}

1. Select **Add certificate**.

1. Repeat the same steps to add as many certificates as needed.

1. Now you can [provide an NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}}) that references the certificate you just added by the **path** value.

### View certificate details

1. Go to your NGINXaaS for Azure deployment and select **NGINX certificates** in the left menu.

1. Select the name of the certificate from the list.

1. View the certificate details, including the certificate path, key path, thumbprint, and the certificate's status.
   This view will also show in a red box any errors that occurred during the certificate fetch process.

### Edit an SSL/TLS certificate

1. Go to your NGINXaaS for Azure deployment and select **NGINX certificates** in the left menu.

1. Select the checkbox next to the certificate you want to edit.

1. Select {{< icon "pencil">}} **Edit**.

1. Update the Name, Certificate path, Key path fields as needed.

1. Use the **Select certificate** option to update the Key vault, and Certificate fields as needed.

1. Select **Update**.

### Delete an SSL/TLS certificate

1. Go to your NGINXaaS for Azure deployment and select **NGINX certificates** in the left menu.

1. Select the checkbox next to the certificate you want to delete.

1. Select {{< icon "trash">}}**Delete**.

1. Confirm the delete action.

{{< call-out "warning" >}}Deleting a TLS/SSL certificate currently in-use by the NGINXaaS for Azure deployment will cause an error.{{< /call-out >}}

## What's next

[Upload an NGINX Configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}})
