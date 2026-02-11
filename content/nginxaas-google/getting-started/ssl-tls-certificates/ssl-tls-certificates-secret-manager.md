---
title: Add certificates from Secret Manager
weight: 75
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/ssl-tls-certificates/ssl-tls-certificates-secret-manager/
nd-content-type: how-to
nd-product: NGOOGL
---

F5 NGINXaaS for Google Cloud (NGINXaaS) can fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview) to use as certificates and keys in your NGINX configuration, ensuring your credentials remain securely within Google Cloud.

## Prerequisites

If you haven't already done so, complete the following prerequisites:

- Enable the [Secret Manager API](https://docs.cloud.google.com/secret-manager/docs/configuring-secret-manager#enable-the-secret-manager-api).
- [Create an NGINXaaS deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/deploy-console.md" >}}).
- Configure Workload Identity Federation (WIF). See [our documentation on setting up WIF]({{< ref "/nginxaas-google/getting-started/access-management.md#configure-wif" >}}) for exact steps.
  - [Grant access to the WIF principal]({{< ref "/nginxaas-google/getting-started/access-management.md#grant-access-to-the-wif-principal-with-your-desired-roles" >}}) with the **Secret Manager Secret Accessor** role.

## Add an SSL/TLS certificate to Secret Manager

To add an SSL/TLS certificate and key as a secret to Secret Manager, 

- Ensure your certificate and key file(s) are in one of our [accepted formats]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/overview.md#supported-certificate-types-and-formats" >}}).
- Follow Google's [instructions to upload your certificate and key file(s) to Secret Manager](https://docs.cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#console_1).

{{< call-out "note" >}}

There are many ways to manage your SSL/TLS certificates and keys. For example, one option is to include the PEM certificate data in the same secret as your private key because NGINX's `ssl_certificate` directive supports a single file containing multiple certificates and a key. See NGINX's [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html) guide for more details.

{{< /call-out >}}

## Use a Secret Manager certificate in an NGINX configuration

To add your Secret Manager certificate and key to an NGINX configuration in the NGINXaaS console,

- Select **Configurations** in the left menu.
- Select the ellipsis (three dots) next to the configuration you want to edit, and select **Edit**.
- Select {{< icon "plus">}} **Add File**.
- Select **Google Secret Manager** as the type of file you want to add.
- Provide the required information:
    {{< table >}}

   | Field                       | Description                  | Note |
   |---------------------------- | ---------------------------- | ---- |
   | Google Secret ID       | The resource name of the secret in Secret Manager | The resource name must match the format `projects/$PROJECT_ID/secrets/$SECRET_ID/versions/$VERSION` where `$VERSION` can be a specific version or an alias such as `latest`. |
   | File Path               | The secret will be written to this file path so it can be used with NGINX directives such as ssl_certificate or ssl_certificate_key in your NGINX configuration. | The path must be unique within the configuration. |

    {{< /table >}}
- Update the NGINX configuration to reference the certificate you just added by the path value.
- Select **Add**, **Next**, and then **Save** to save your changes.

## Update your NGINXaaS deployment's NGINX configuration

Before updating your NGINXaaS deployment to use your new NGINX configuration, ensure your deployment already has a [workload identity pool provider set up]({{< ref "/nginxaas-google/getting-started/access-management.md#configure-wif" >}}) with the **Secret Manager Secret Accessor** role granted, so it can fetch certificates. Then, in the NGINXaaS console:

- Select **Deployments**.
- Select the deployment you want to edit.
- In the **Configuration Info** panel, select **Edit**.
- Select the configuration and configuration version created in the last section.
- Select **Update Configuration**.

## What's next

[Upload an NGINX Configuration]({{< ref "/nginxaas-google/getting-started/nginx-configuration/nginx-configuration-console.md" >}})