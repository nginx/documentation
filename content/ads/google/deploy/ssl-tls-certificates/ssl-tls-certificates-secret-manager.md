---
title: Add certificates from Secret Manager
weight: 75
toc: true
f5-docs: DOCS-000
url: /application-delivery-service/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager/
f5-content-type: how-to
f5-product: F5 Application Delivery Service for Google Cloud
---

F5 Application Delivery Service for Google Cloud can fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview) to use as certificates and keys in your NGINX configuration, ensuring your credentials remain securely within Google Cloud.

## Prerequisites

If you haven't already done so, complete the following prerequisites:

- Enable the [Secret Manager API](https://docs.cloud.google.com/secret-manager/docs/configuring-secret-manager#enable-the-secret-manager-api).
- [Create an F5 Application Delivery Service for Google Cloud deployment]({{< ref "/ads/google/deploy/create-deployment/deploy-console.md" >}}).
- Configure Workload Identity Federation (WIF). See [the documentation on setting up WIF]({{< ref "/ads/google/deploy/access-management.md#configure-wif" >}}) for exact steps.
  - [Grant access to the WIF principal]({{< ref "/ads/google/deploy/access-management.md#grant-access-to-the-wif-principal-with-your-desired-roles" >}}) with the **Secret Manager Secret Accessor** role.

## Add an SSL/TLS certificate to Secret Manager

To add an SSL/TLS certificate and key as a secret to Secret Manager, 

1. Make sure your certificate and key file(s) are in one of the [accepted formats]({{< ref "/ads/google/deploy/ssl-tls-certificates/overview.md#supported-certificate-types-and-formats" >}}).
1. Follow Google's [instructions to upload your certificate and key file(s) to Secret Manager](https://docs.cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#console_1).

{{< call-out class="note" title="Note" >}}

There are many ways to manage your SSL/TLS certificates and keys. For example, you can include the PEM certificate data in the same secret as your private key. The ssl_certificate directive supports a single file containing multiple certificates and a key. See NGINX's [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html) guide for more details.

{{< /call-out >}}

## Use a Secret Manager certificate in an NGINX configuration

To add your Secret Manager certificate and key to an NGINX configuration in the F5 Application Delivery Service for Google Cloud console,

1. Select **Configurations** in the left menu.
2. Select the ellipsis (three dots) next to the configuration you want to edit, and select **Edit**.
3. Select {{< icon "plus">}} **Add File**.
4. Select **Cloud Provider Secret** as the type of file you want to add.
5. Select **Google Secret Manager** as the **Cloud Secret Manager**.
6. Provide the required information:
    {{< table >}}

   | Field                       | Description                  | Note |
   |---------------------------- | ---------------------------- | ---- |
   | Google Secret ID       | The resource name of the secret in Secret Manager | The resource name must match the format `projects/$PROJECT_ID/secrets/$SECRET_ID/versions/$VERSION`, where `$VERSION` can be a specific version ID (for example, `3`), a custom alias, or the special version ID `latest`. |
   | File Path               | The secret will be written to this file path, so it can be used with NGINX directives such as `ssl_certificate` or `ssl_certificate_key` in your NGINX configuration. | The path must be unique within the configuration. See the [NGINX Filesystem Restrictions table]({{< ref "/ads/google/deploy/nginx-configuration/configuration-rules.md#nginx-filesystem-restrictions" >}}) for the allowed directories the file can be written to. |

    {{< /table >}}

{{< call-out "tip" "Enable automatic rotation with latest" >}}
If you set `$VERSION` to `latest`, F5 Application Delivery Service for Google Cloud automatically picks up any new secret version you add to Secret Manager without a configuration change. F5 Application Delivery Service for Google Cloud applies new versions within four hours. See [Rotate a Secret Manager certificate (automatic)](#rotate-a-secret-manager-certificate-automatic) for details.
{{< /call-out >}}

7. Update the NGINX configuration to reference the certificate you just added by the path value.
8. Select **Add**, **Next**, and then **Save** to save your changes.

## Update your F5 Application Delivery Service for Google Cloud deployment's NGINX configuration

Before updating your F5 Application Delivery Service for Google Cloud deployment to use your new NGINX configuration, make sure your deployment already has a [workload identity pool provider set up]({{< ref "/ads/google/deploy/access-management.md#configure-wif" >}}) with the **Secret Manager Secret Accessor** role granted, so it can fetch certificates. Then, in the F5 Application Delivery Service for Google Cloud console:

1. Select **Deployments**.
1. Select the deployment you want to edit.
1. In the **Configuration Info** panel, select **Edit**.
1. Select the configuration and configuration version created in the last section.
1. Select **Update Configuration**.

{{< call-out class="note" title="Note" >}}

Configurations with Google Secret Manager secrets can only be added to Google deployments.

{{< /call-out >}}

## Rotate a Secret Manager certificate (automatic)

If you set the version ID of your secret to `latest`, F5 Application Delivery Service for Google Cloud fetches the latest secret version. When you [add a new secret version in Secret Manager](https://docs.cloud.google.com/secret-manager/docs/add-secret-version#add-a-secret-version), F5 Application Delivery Service for Google Cloud automatically picks up that version within four hours.

If you set the version ID of your secret to a custom alias, F5 Application Delivery Service for Google Cloud fetches the secret version the alias points to. When you [update the alias to point to a different version in Secret Manager](https://docs.cloud.google.com/secret-manager/docs/assign-alias-to-secret-version), F5 Application Delivery Service for Google Cloud automatically picks up that version within four hours.

No configuration changes are required in either case. To confirm your deployment is using an updated certificate, check the **Certificates** list for the new serial number or inspect the certificate at your deployment's endpoint.

## Rotate a Secret Manager certificate (manual)

To immediately refetch secrets without editing your NGINX configuration, use **Reapply Configuration**. This is useful in the following scenarios:

- **New secret version**: You've uploaded a new certificate and want F5 Application Delivery Service for Google Cloud to use it right away.
- **WIF or permissions fix**: You've updated a WIF provider or granted Secret Manager permissions and want F5 Application Delivery Service for Google Cloud to retry immediately.

To reapply your configuration:

1. In the F5 Application Delivery Service for Google Cloud console, go to your deployment.
2. Select **Reapply Configuration** in the **Configuration Info** panel.

F5 Application Delivery Service for Google Cloud reapplies your current configuration version and immediately refetches all referenced secrets.

## Monitor secret fetch events

F5 Application Delivery Service for Google Cloud generates an event each time it fetches or fails to fetch a secret from Secret Manager. Use these events to track successful rotations and diagnose access failures.

### Event types

{{< table >}}
| Event type | Description |
|---|---|
| Successful Secret Fetch from Google | The secret was fetched from Secret Manager and applied to NGINX. |
| Failed Secret Fetch from Google | F5 Application Delivery Service for Google Cloud couldn't fetch the secret. The event message includes the error details. |
{{< /table >}}

### View events in the console

- Select **Overview** in the left menu, then select **Events**. To narrow results to a specific deployment, filter by its object ID using the controls at the top of the page.
- For a summary of recent events for a specific deployment, select **Deployments**, select the deployment, and look for the **Recent Events** card. Select **See Events Details** to go to the full Events page pre-filtered for that deployment.

### Common failure messages and remediation

{{< table >}}
| Message | Likely cause | Remediation |
|---|---|---|
| `Failed to fetch secret ... PermissionDenied: Permission 'secretmanager.versions.access' denied` | The Workload Identity Federation principal doesn't have the required IAM role on the secret. | Verify the WIF principal has the Secret Manager Secret Accessor role on the project or secret. |
| `Failed to fetch secret ... NotFound: Secret [...] has no alias [latest]` | No versions exist for the referenced secret, or the specified version alias or number doesn't exist. | Confirm the secret has at least one enabled version and that the resource name in your configuration uses a valid version or alias. |
{{< /table >}}

## What's next

[Upload an NGINX Configuration]({{< ref "/ads/google/deploy/nginx-configuration/nginx-configuration-console.md" >}})