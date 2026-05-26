---
title: Overview
weight: 50
toc: true
url: /nginxaas/google/getting-started/ssl-tls-certificates/overview/
f5-content-type: reference
f5-product: NGOOGL
---


F5 NGINXaaS for Google Cloud (NGINXaaS) enables customers to secure traffic by adding SSL/TLS certificates to a deployment.

This document provides details about using SSL/TLS certificates with your F5 NGINXaaS for Google Cloud deployment.

## Supported certificate types and formats

NGINX supports the following certificate formats:

- PEM format certificates.

NGINXaaS allows you to upload these certificates as text, as files, and as secrets from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA

## Add SSL/TLS certificates

Add a certificate to your NGINXaaS deployment using your preferred client tool:

- [Add certificates from Secret Manager]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}})
- [Add certificates using the NGINXaaS Console]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})

## Rotate a Secret Manager certificate (manual)

To immediately refetch secrets without editing your NGINX configuration, use **Sync Configuration**. This is useful in two scenarios:

- **New secret version**: You've uploaded a new certificate and want NGINXaaS to use it right away.
- **WIF or permissions fix**: You've updated a WIF provider or granted Secret Manager permissions and want NGINXaaS to retry immediately.

To reapply your configuration:

1. In the NGINXaaS console, go to your deployment.
2. Open the **Configuration Info** panel.
3. Select **Reapply Configuration**.

NGINXaaS reapplies your current configuration version and immediately refetches all referenced secrets.

## Rotate a Secret Manager certificate (automatic)

If your configuration references secrets using the `versions/latest` alias, NGINXaaS automatically picks up new certificate versions. When you add a new secret version in Secret Manager, the next scheduled sync fetches it and reloads NGINX. No configuration changes are required.

### Rotation timeline

New secret versions are usually applied to your deployment within approximately 4 hours.

To rotate your certificate:

1. Generate your new certificate and key.
2. Add the updated certificate and key as new secret versions in Secret Manager. No configuration changes are needed.
3. Wait for NGINXaaS to apply the updated certificate. Rotation is complete when the new certificate serial number appears on your NGINX endpoint and in the NGINXaaS **Certificates** list.

{{< call-out "note" >}}

Automatic rotation only works when the Google Secret ID uses the `latest` version alias. If you've pinned a specific version number, manually rotate using **Reapply Configuration**.

{{< /call-out >}}

## Monitor secret fetch events

NGINXaaS generates an event each time it fetches — or fails to fetch — a certificate or key from Secret Manager. Use these events to track successful rotations and troubleshoot access failures.

### Event types

{{< table >}}

| Event type | Description |
|---|---|
| Successful Secret Fetch from Google | The secret was fetched from Secret Manager and applied to NGINX. |
| Failed Secret Fetch from Google | NGINXaaS couldn't fetch the secret. The event message includes the error details. |

{{< /table >}}

### View events in the console

- Select **Overview** in the left menu, then select **Events**.
- To narrow results to a specific deployment, filter by its object ID using the controls at the top of the page.
- For a summary of recent events, select **Deployments**, select the deployment, and look for the **Recent Events** card. Select **See Events Details** to go to the full Events page pre-filtered for that deployment.

### Common failure messages and remediation

{{< table >}}

| Message | Likely cause | Remediation |
|---|---|---|
| `Failed to fetch secret ... PermissionDenied: Permission 'secretmanager.versions.access' denied` | The Workload Identity Federation principal doesn't have the required IAM role on the secret. | Verify the WIF principal has the Secret Manager Secret Accessor role on the project or secret. |
| `Failed to fetch secret ... NotFound: Secret [...] has no alias [latest]` | No versions exist for the referenced secret, or the specified version alias or number doesn't exist. | Confirm the secret has at least one enabled version and that the resource name in your configuration uses a valid version or alias. |

{{< /table >}}
