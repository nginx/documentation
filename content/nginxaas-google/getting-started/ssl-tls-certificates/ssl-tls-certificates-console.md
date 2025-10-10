---
title: Add certificates using the Console
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/ssl-tls-certificates/ssl-tls-certificates-console/
type:
- how-to
---

You can manage SSL/TSL certificates for F5 NGINXaaS for Google Cloud (NGINXaaS) using the NGINXaaS console.

## Prerequisites

If you haven't already done so, complete the following prerequisites:

- Subscribe to the NGINXaaS for Google Cloud offer. See [Subscribe to the NGINXaaS for Google Cloud offer]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}}).
- Create a deployment. See [Deploy using the console]({{< ref "/nginxaas-google/getting-started/create-deployment/deploy-console.md" >}}).
- Access the console visiting [https://console.nginxaas.net/](https://console.nginxaas.net/).
- Log in to the NGINXaaS console with your Google credentials.

## Add an SSL/TLS certificate to NGINXaaS

- Select **Certificates** in the left menu.
- Select {{< icon "plus">}} **Add Certificate**.
- In the **Add Certificate** panel, provide the required information:
    {{< table >}}

   | Field                       | Description                  |
   |---------------------------- | ---------------------------- |
   | Name                        | A unique name for the certificate. |
   | Type                        | Select the type of certificate you are adding. SSL certificate and key, or CA certificate bundle. |
   | Certificate Import Options  | Choose how you want to import the certificate. Enter the certificate text or upload a file. |

     {{< /table >}}

- Repeat the same steps to add as many certificates as needed.

### Use a certificate in an NGINX configuration

To use a certificate in an NGINX configuration, follow these steps:

- Select **Configurations** in the left menu.
- Select the ellipsis (three dots) next to the configuration you want to edit, and select **Edit**.
- Select **Continue** to open the configuration editor.
- In your configuration, select {{< icon "plus">}} **Add File** and either choose to use an existing certificate or add a new one.
   - If you want to add a new certificate, select **New SSL Certificate or CA Bundle** and follow the steps mentioned in [Add an SSL/TLS certificate to NGINXaaS](#add-an-ssltls-certificate-to-nginxaas).
   - If you want to use an existing certificate, select **Existing SSL Certificate or CA Bundle** and use the menu to choose a certificate from the list of certificates you have already added.
- Provide the required path information:
    {{< table >}}

   | Field                       | Description                  | Note |
   |---------------------------- | ---------------------------- | ---- |
   | Certificate File Path       | This path can match one or more ssl_certificate directive file arguments in your NGINX configuration. | The certificate path must be unique within the same deployment. |
   | Key File Path               | This path can match one or more ssl_certificate_key directive file arguments in your NGINX configuration. | The key path must be unique within the same deployment. |

    {{< /table >}}
- Update the NGINX configuration to reference the certificate you just added by the path value.
- Select **Continue** and then **Save** to save your changes.

### Edit an SSL/TLS certificate

{{< include "/nginxaas-google/update-nginx-config.md" >}}

### Delete an SSL/TLS certificate

- Select **Certificates** in the left menu.
- On the list of certificates, select the ellipses (three dots) icon next to the certificate you want to delete.
- Select **Delete**.
- Confirm that you want to delete the certificate.

{{< call-out "warning" >}}Deleting a TLS/SSL certificate currently in-use by the NGINXaaS for Google Cloud deployment will cause an error.{{< /call-out >}}


## What's next

[Upload an NGINX Configuration]({{< ref "/nginxaas-google/getting-started/nginx-configuration/nginx-configuration-console.md" >}})
