---
title: Add certificates from Secret Manager
weight: 75
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/ssl-tls-certificates/ssl-tls-certificates-secret-manager/
nd-content-type: how-to
nd-product: NGOOGL
---

F5 NGINXaaS for Google Cloud (NGINXaaS) can fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview) to use as certificates in your NGINX configuration.

## Prerequisites

If you haven't already done so, complete the following prerequisites:

- Enable the [Secret Manager API](https://docs.cloud.google.com/secret-manager/docs/configuring-secret-manager#enable-the-secret-manager-api).
- Configure Workload Identity Federation (WIF). See [our documentation on setting up WIF]({{< ref "/nginxaas-google/getting-started/access-management.md#configure-wif" >}}) for exact steps.

## Add an SSL/TLS certificate to Secret Manager

If you do not have a certificate in one of our [accepted formats]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/overview.md#supported-certificate-types-and-formats" >}}) in Secret Manager, follow Google's [instructions on adding a secret to Secret Manager](https://docs.cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#create-secret-console)

## Use a Secret Manager certificate in an NGINX configuration

To add your Secret Manager certificate to an NGINX configuration in the NGINXaaS console,

- Select **Configurations** in the left menu.
- Select the ellipsis (three dots) next to the configuration you want to edit, and select **Edit**.
- Select **Continue** to open the configuration editor.
- In your configuration, select {{< icon "plus">}} **Add File** and either choose **Google Secret Manager** as the type.
- Provide the required path information:
    {{< table >}}

   | Field                       | Description                  | Note |
   |---------------------------- | ---------------------------- | ---- |
   | Google Secret ID       | This resource name of the secret in Secret Manager | The resource name must match the format `projects/$PROJECT_ID/secrets/$SECRET_ID/versions/$VERSION` where `$VERSION` can be a specific version or an alias such as `latest`. |
   | File Path               | This path can match one or more ssl_certificate or ssl_certificate_key directive file arguments in your NGINX configuration. | The path must be unique within the same deployment. |

    {{< /table >}}
- Update the NGINX configuration to reference the certificate you just added by the path value.
- Select **Continue** and then **Save** to save your changes.

## What's next

[Upload an NGINX Configuration]({{< ref "/nginxaas-google/getting-started/nginx-configuration/nginx-configuration-console.md" >}})