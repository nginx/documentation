---
title: "Automate access with client credentials"
description: "Learn how to set up OAuth2 client credentials for automating access to F5 Application Delivery Service."
weight: 400
toc: true
f5-product: F5 Application Delivery Service
f5-content-type: how-to
f5-keywords: "client credentials, OAuth2, automation, Terraform"
f5-summary: >
    Use this guide to create OAuth2 client credentials in the F5 ADS Console.
    Client credentials are currently supported for use with the F5 ADS Terraform provider,
    allowing you to manage Deployments, Configurations, and Certificates.
    Credentials are scoped to a single organization.
f5-audience: operator
---

## Overview

This guide explains how to create and use client credentials for automating access to F5 Application Delivery Service. Client credentials are currently supported for use with the F5 ADS Terraform provider, which uses them to manage certain F5 ADS resources without requiring user login.

Client credentials work the same way regardless of which cloud your F5 ADS organization is associated with.

To authenticate, the Terraform provider exchanges your client credentials (client ID and secret) for a short-lived access token from the F5 ADS token endpoint. Access tokens have limited validity, after which a new one is requested using the same credentials.

Client credentials are scoped to an organization and expire after a set period (up to 1 year, 6 months recommended).

## Before you begin

- You must be logged in to the [F5 ADS Console](https://console.nginxaas.net/).

## Create client credentials

Follow these steps to create a new client credential through the F5 ADS Console:

1. Log in to [F5 ADS Console](https://console.nginxaas.net/).
1. Select **Settings** > **Client Credentials** from the left navigation menu.
1. Select **+ Add Client** to create a new credential.
1. Enter a unique name for your client in the text field that appears.
1. Choose an expiration date (maximum 1 year from today; 6 months is recommended). This setting is immutable after creation.
1. Select **Create**. 
1. A popup window displays your client secret.

{{< call-out class="warning" title="Important: Store Your Client Secret Securely" >}}
The client secret appears only once. Save it immediately in a secure location, such as a password manager or secrets vault.
{{< /call-out >}}

Your client credentials can access the Certificates, Configs, and Deployments resources for your F5 ADS organization.

### Client limits

Organizations are limited to a maximum of 10 client credentials. To request an increase to this limit, contact the [NGINX Support]({{< ref "/f5ads/support.md" >}}).

## Retrieve client information

Follow these steps to view information about your clients:

1. Log in to [F5 ADS Console](https://console.nginxaas.net/).
1. Select **Settings** > **Client Credentials** from the left navigation menu.
1. You can see all the available client credentials for your organization in the **Client Credentials** page. The table shows the following metadata for each credential:
   - Client Name
   - Client ID
   - Token Endpoint
   - Date Created
   - Expires On

1. Check the expiration status indicator next to **Expires On**:
   - **Green dot**: Credential is active and valid
   - **Red dot**: Credential has expired

{{< call-out class="note" >}}
You can only view the client secret once, when they're created. If you need to use credentials again, you must have saved the secret when you initially created the client.
{{< /call-out >}}

## Delete client credentials

Follow these steps to delete a client credential:

1. Log in to [F5 ADS Console](https://console.nginxaas.net/).
1. Select **Settings** > **Client Credentials** from the left navigation menu.
1. Locate the credential to delete in the table.
1. Select the three vertical dots icon (⋮) at the end of the row.
1. Select **Delete** from the menu.

After deletion:

- Existing access tokens continue to work for 1 full hour after they're issued.

{{< call-out class="note" >}}
Expired credentials are not automatically removed. You must manually delete credentials that are past their expiration date.
{{< /call-out >}}

## Use client credentials for authentication

Use client credentials with the [F5 ADS Terraform provider]({{< ref "/f5ads/google/deploy/create-deployment/deploy-terraform.md" >}}).

{{< call-out class="note" >}}
Calling the F5 ADS APIs directly isn't officially supported. If you have questions or issues, [contact F5 support]({{< ref "/f5ads/support.md" >}}).
{{< /call-out >}}

## Security best practices

- **Store secrets securely**: Store client credentials in a secure place
- **Delete unused credentials**: Remove clients that are no longer needed
- **Follow the recommended expiration**: Avoid using clients with a very long expiration, a good default to begin with is 6 months

## Troubleshooting

Common issues when authenticating with client credentials and how to resolve them.

### Invalid or expired credentials

If you attempt to authenticate with invalid or expired credentials, you will receive a `401 Unauthorized` response. In this case:

- Verify your client ID and secret are correct
- Check if the client has expired
- Create new credentials if necessary

## Quick reference

| Property | Value |
|----------|-------|
| Client secret visibility | Only shown once during creation |
| Default expiration | 6 months (recommended) |
| Maximum expiration | 1 year |
| Client limit per organization | 10 clients contact [NGINX Support]({{< ref "/f5ads/support.md" >}}) to increase |
| Access token validity | 1 hour |
| Supported resources | Deployments, Configs, Certificates |
