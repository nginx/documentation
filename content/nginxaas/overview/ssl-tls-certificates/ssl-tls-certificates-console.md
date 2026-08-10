---
title: Add certificates using the NGINXaaS Console
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/ssl-tls-certificates/ssl-tls-certificates-console/
f5-content-type: how-to
f5-product: F5 NGINXaaS
contentVars:
  product: NGINXaaS
---

You can manage SSL/TLS certificates for F5 ${product} using the NGINXaaS console.

## Add an SSL/TLS certificate to NGINXaaS

- Select **Certificates** in the left menu.
- Select {{< icon "plus">}} **Add Certificate**.
- In the **Add Certificate** panel, provide the required information:
    {{< table >}}

   | Field                       | Description                  |
   |---------------------------- | ---------------------------- |
   | Name                        | A unique name for the certificate. |
   | Type                        | Select the type of certificate you are adding: SSL certificate and key, or CA certificate bundle. |
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
   | Key File Path               | This path can match one or more ssl_certificate_key directive file arguments in your NGINX configuration. | The key path must be unique within the same deployment. See the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas/overview/nginx-configuration/configuration-rules.md#nginx-filesystem-restrictions" >}}) for the allowed directories the file can be written to. |

    {{< /table >}}
- Update the NGINX configuration to reference the certificate you just added by the path value.
- Select **Continue** and then **Save** to save your changes.

### Edit an SSL/TLS certificate

{{< include "/nginxaas/update-nginx-config.md" >}}

### Delete an SSL/TLS certificate

- Select **Certificates** in the left menu.
- On the list of certificates, select the ellipsis (three dots) icon next to the certificate you want to delete.
- Select **Delete**.
- Confirm that you want to delete the certificate.

{{< call-out class="warning" >}}Deleting a TLS/SSL certificate currently used by a NGINXaaS deployment will cause an error.{{< /call-out >}}
