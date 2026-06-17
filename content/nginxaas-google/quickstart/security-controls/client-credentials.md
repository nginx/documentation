---
title: "Programmatic Authentication With Client Credentials"
description: "Learn how to set up OAuth2 client credentials for programmatic access to the NGINXaaS API."
weight: 100
toc: true
url: /nginxaas/google/quickstart/security-controls/client-credentials/
f5-product: NGOOGL
f5-content-type: how-to
f5-keywords: "client credentials, OAuth2, programmatic authentication, API"
---

## Overview

This guide explains how to create and use client credentials to manage some NGINXaaS for Google Cloud APIs programmatically. This allows machine users such as Terraform, CI/CD pipelines, or other automation tools to authenticate and interact with the NGINXaaS API securely.

Client credentials are scoped to an organization and enable programmatic access to manage Deployments, Configurations, and Certificates APIs.

## Key features

- **Secure programmatic access**: Enables programmatic access for machine clients with tokens minted using client credentials
- **Configurable Expiration controls**: Configurable expiration with recommended best practices
- **Limited scope**: Client credentials can only manage Deployments, Configs, and Certificates

## Prerequisites

- You must be logged into NGINXaaS Console [https://console.nginxaas.net/](https://console.nginxaas.net/)

## Creating client credentials

Follow these steps to create a new client credential through the NGINXaaS console:

1. Log in to [NGINXaaS Console](https://console.nginxaas.net/) using your Google credentials.
2. Select **Settings** > **Client Credentials** from the left navigation menu.
3. Select **+ Add Client** to create a new credential.
4. Enter a unique name for your client in the text field that appears.
5. Choose an expiration date (maximum 1 year from today; 6 months is recommended). This setting is immutable after creation.
6. Select **Create**. A popup window displays your client secret.

{{< call-out class="warning" title="Important: Store Your Client Secret Securely" >}}
The client secret appears only once. Save it immediately in a secure location, such as a password manager or secrets vault. If you lose the secret, you must delete this credential and create a new one.
{{< /call-out >}}

Your client credentials can access the following APIs programmatically:

- Certificates API
- Configs API
- Deployments API

### Client limits

Organizations are limited to a maximum of 10 client credentials. To request an increase to this limit, contact the NGINX Support team.

## Retrieving client information

Follow these steps to view your client credentials:

1. Log in to [NGINXaaS Console](https://console.nginxaas.net/).
2. Select **Settings** > **Client Credentials** from the left navigation menu.
3. The **Client Credentials** page displays all available client credentials for your organization. The table shows the following metadata for each credential:
   - Client Name
   - Client ID
   - Token Endpoint
   - Date Created
   - Expires On

4. Check the expiration status indicator next to **Expires On**:
   - **Green dot**: Credential is active and valid
   - **Red dot**: Credential has expired

{{< call-out class="note" >}}
Client secrets are not displayed after creation. If you need to use credentials again, you must have saved the secret when you initially created the client.
{{< /call-out >}}

## Deleting client credentials

Follow these steps to delete a client credential:

1. Log in to [NGINXaaS Console](https://console.nginxaas.net/).
2. Select **Settings** > **Client Credentials** from the left navigation menu.
3. Locate the credential to delete in the table.
4. Select the three vertical dots icon (⋮) at the end of the row.
5. Select **Delete** from the menu.

After deletion:

- The client can no longer request new access tokens using this credential
- Existing access tokens continue to work until they expire (1 hour from issuance)
- The client ID and secret become permanently invalid

{{< call-out class="note" >}}
Expired credentials are not automatically removed. You must manually delete credentials that are past their expiration date.
{{< /call-out >}}

## Using client credentials for authentication

### Exchange credentials for an access token

Use the client credentials to obtain an access token from the token endpoint.

**Endpoint**: `POST https://us.api.nginxaas.net/api/v1/marketplace/auth/token`

**Example using cURL**:

```bash
curl -X POST "https://us.api.nginxaas.net/api/v1/marketplace/auth/token" \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "client_abc123",
    "client_secret": "superSecret",
    "grant_type": "client_credentials"
  }'
```

**Response**:

```json
{
  "access_token": "<access_token>",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

### Use the access token

Include the access token in the Authorization header when making API requests.

**Example**:

```bash
curl -X GET "https://us.api.nginxaas.net/api/v1/deployments" \
  -H "Authorization: Bearer <access_token>"
```

### Access token validity

- **Duration**: Access tokens are valid for 1 hour from issuance
- **Reauthentication**: When a token expires, request a new one using the same client credentials, if the client credentials are still active
- **Scope**: Tokens are also scoped to the organization associated with the client credentials

## Security best practices

- **Use separate credentials for different environments**: Create distinct clients for various scopes to keep things logically separate
- **Store secrets securely**: Never commit client secrets to version control
- **Delete unused credentials**: Remove clients that are no longer needed
- **Follow the recommended expiration**: Unless you have a specific reason, use the recommended 6-month expiration

## Error handling

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
- Ensure the API is one of the supported resources (Deployments, Configs, or Certificates)

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
| Client limit per organization | 10 clients (contact NGINX Support to increase) |
| Access token validity | 1 hour |
| Supported resources | Deployments, Configs, Certificates |
| Token endpoint | `https://{region}.api.nginxaas.net/api/v1/marketplace/auth/token` |