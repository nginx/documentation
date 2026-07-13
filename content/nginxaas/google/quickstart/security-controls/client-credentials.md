---
title: "Programmatic authentication with client credentials"
description: "Learn how to set up OAuth2 client credentials for programmatic access to the NGINXaaS API."
weight: 100
toc: true
url: /nginxaas/google/quickstart/security-controls/client-credentials/
f5-product: NGOOGL
f5-content-type: how-to
f5-keywords: "client credentials, OAuth2, programmatic authentication, API"
f5-summary: >
    Use this guide to create OAuth2 client credentials in the NGINXaaS Console and exchange
    them for an access token that authenticates requests to the NGINXaaS API.
    Client credentials enable access for automation toolchains such as CI/CD pipelines,
    allowing you to manage Deployments, Configurations, and Certificates APIs.
    Credentials are scoped to a single organization.
f5-audience: operator
---

## Overview

This guide explains how to create and use client credentials for automating access to NGINXaaS APIs. Client credentials enable automation tools such as CI/CD pipelines to manage certain NGINXaaS resources without requiring user login.

To authenticate, you exchange your client credentials (client ID and secret) for a short-lived access token from the NGINXaaS token endpoint. This access token is then used in the Authorization header of your API requests. Access tokens have limited validity, after which you'll need to request a new one using the same credentials.

Client credentials are scoped to an organization and expire after a set period (up to 1 year, 6 months recommended).

## Before you begin

- You must be logged in to the [NGINXaaS Console](https://console.nginxaas.net/).

## Create client credentials

Follow these steps to create a new client credential through the NGINXaaS console:

1. Log in to [NGINXaaS Console](https://console.nginxaas.net/).
1. Select **Settings** > **Client Credentials** from the left navigation menu.
1. Select **+ Add Client** to create a new credential.
1. Enter a unique name for your client in the text field that appears.
1. Choose an expiration date (maximum 1 year from today; 6 months is recommended). This setting is immutable after creation.
1. Select **Create**. 
1. A popup window displays your client secret.

{{< call-out class="warning" title="Important: Store Your Client Secret Securely" >}}
The client secret appears only once. Save it immediately in a secure location, such as a password manager or secrets vault.
{{< /call-out >}}

Your client credentials can access the following resources:

- [Certificates]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/overview.md" >}})
- [Configs]({{< ref "/nginxaas/google/deploy/nginx-configuration/overview.md" >}})
- [Deployments]({{< ref "/nginxaas/google/deploy/create-deployment/deploy-console.md" >}})

### Client limits

Organizations are limited to a maximum of 10 client credentials. To request an increase to this limit, contact the [NGINX Support]({{< ref "/nginxaas/support.md" >}}).

## Retrieve client information

Follow these steps to view information about your clients:

1. Log in to [NGINXaaS Console](https://console.nginxaas.net/).
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

1. Log in to [NGINXaaS Console](https://console.nginxaas.net/).
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

Learn how to obtain and use access tokens from your client credentials to authenticate API requests.

{{< call-out class="note" >}}
Client credential access to these resources isn’t officially supported yet.
{{< /call-out >}}

### Exchange credentials for an access token

Use the client credentials to obtain an access token from the token endpoint.

**Endpoint**: `POST https://<GEO>.api.nginxaas.net/api/v1/auth/token`

**Example using cURL**:

```bash
curl -X POST "https://<GEO>.api.nginxaas.net/api/v1/auth/token" \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "<CLIENT_ID>",
    "client_secret": "<CLIENT_SECRET>",
    "grant_type": "client_credentials"
  }'
```

**Response**:

```json
{
  "access_token": "<ACCESS_TOKEN>",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

### Use the access token

Include the access token in the Authorization header when making API requests.

**Example**:

```bash
curl -X GET "https://<GEO>.api.nginxaas.net/api/v1/deployments" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

### Access token validity

- **Duration**: Access tokens are valid for 1 hour from issuance
- **Reauthentication**: When a token expires, request a new one using the same client credentials, if the client credentials are still active
- **Scope**: Tokens are also scoped to the organization associated with the client credentials

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

**Example error response**:

```json
{
  "error": "unauthorized",
  "error_description": "token is expired/invalid"
}
```

### Forbidden APIs

Client credentials can only access the Certificates, Configs, and Deployments APIs. Attempting to access any other API with client credentials returns a `403 Forbidden` response. In this case:

- Verify you are using the correct API endpoint
- Ensure the API is one of the supported resources

**Example error response**:

```json
{
  "error": "forbidden",
  "error_description": "Client credentials do not have permission to access this resource"
}
```

## Quick reference

| Property | Value |
|----------|-------|
| Client secret visibility | Only shown once during creation |
| Default expiration | 6 months (recommended) |
| Maximum expiration | 1 year |
| Client limit per organization | 10 clients contact [NGINX Support]({{< ref "/nginxaas/support.md" >}}) to increase |
| Access token validity | 1 hour |
| Supported resources | Deployments, Configs, Certificates |
| Token endpoint | `https://<GEO>.api.nginxaas.net/api/v1/auth/token` |

## What's next

[Manage your NGINXaaS certificates]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/overview.md" >}})

[Manage your NGINX configurations]({{< ref "/nginxaas/google/deploy/nginx-configuration/overview.md" >}})

[Manage your NGINXaaS deployments]({{< ref "/nginxaas/google/deploy/create-deployment/deploy-console.md" >}})