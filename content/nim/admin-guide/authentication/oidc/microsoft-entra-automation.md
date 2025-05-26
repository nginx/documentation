---
docs: DOCS-1197
title: Automate OIDC with Microsoft Entra
toc: true
weight: 300
type:
- tutorial
---

## Overview

This guide explains how to secure NGINX Instance Manager with OpenID Connect (OIDC) using the client credentials flow and Microsoft Entra as the identity provider. You can use this setup for automation services, such as in CI/CD pipelines.

## Before you begin

{{<call-out "important" "Required steps">}}
Before proceeding, first secure NGINX Instance Manager with OpenID Connect (OIDC) using Microsoft Entra as the identity provider. Complete the steps in the [Set up OIDC authentication with Microsoft Entra]({{< ref "/nim/admin-guide/authentication/oidc/microsoft-entra-setup.md" >}}) guide. Afterward, you'll have a registered application (for example, "NGINX Instance Manager") in Microsoft Entra, as well as a client ID and secret to configure automation.
{{</call-out>}}

## Configure Azure

### Register a new application for your automation

1. Log in to the [Azure portal](https://portal.azure.com/#home).
2. Select **Microsoft Entra** from the list of Azure services.
3. In the left navigation menu, under **Manage**, select **App registrations**.
4. Select **New registration**.
5. Complete the following:
   - In the **Name** field, enter the name of the application (for example, "Automation").
   - Select **Accounts in this organizational directory only** for account types.
   - Leave **Redirect URI** blank.
6. Select **Register**.
7. On the confirmation page, note the following information for later use:
   - **Application (client) ID**
   - **Directory (tenant) ID**

### Expose the application API

1. In the left navigation menu, under **Manage**, select **Expose an API**.
2. Select **Set** next to **Application ID URI**.
3. Optionally, enter a friendly URI for the application, or leave the default value.
4. Select **Save**.

### Create an app role {#create-app-role}

1. In the left navigation menu, under **Manage**, select **App roles**.
2. Select **Create app role**.
3. Fill in the role details. Use the information from an existing user group in NGINX Instance Manager, such as from the [Create user groups in Instance Manager]({{< ref "/nim/admin-guide/authentication/oidc/microsoft-entra-setup.md#create-user-groups-in-nginx-instance-manager" >}}) step:
   - In the **Display name** field, enter a role name (for example, "Admin").
   - In **Allowed member types**, select **Applications**.
   - In the **Value** field, enter the value for the role. This must match the user group in NGINX Management Suite.
   - Provide a description for the role.
4. Select **Save**.

### Assign the app role to the application

1. On the **App registrations** page, select the first application you created (for example, "Instance Manager").
2. In the left navigation menu, under **Manage**, select **API permissions**.
3. Select **Add a permission**.
4. In the **Request API permissions** section, select **My APIs**.
5. Select the app name you created for automation (for example, "Automation").
6. Under **Application permissions**, select the role you created earlier (for example, "Admin").
7. Select **Add permissions**.

{{< note >}}If the permission is not granted, contact your Microsoft Entra administrator to approve it.{{< /note >}}

## Configure NGINX OIDC to use Microsoft Entra as the IdP

Complete the steps in the [Configure NGINX Plus with Microsoft Entra as Identity Provider]({{< ref "/nim/admin-guide/authentication/oidc/microsoft-entra-setup.md#configure-nginx-plus" >}}) topic. Note that you may have already completed some of these steps in the [Before you begin](#before-you-begin) section of this guide.

Additionally, complete the following steps:

1. Add your Microsoft Entra tenant domain to the `/etc/nms/nginx/oidc/openid_configuration.conf` file. For example, if your tenant domain is `f5.com`, update the `oidc_domain` setting like this:

    ```nginx
    ...
    map $host $oidc_domain {
        SERVER_FQDN OIDC_DOMAIN;
        # replace with OIDC specific setting
        default "f5.com";
    }
    ...
    ```

2. Uncomment the relevant OIDC sections in the `/etc/nginx/conf.d/nms-http.conf` file:

    ```nginx
    ...
    # Enable when using OIDC with Microsoft Entra
    map $http_authorization $groups_claim {
        "~^Bearer.*" $jwt_claim_roles;
        default $jwt_claim_groups;
    }

    map $jwt_audience $jwt_aud_client {
        default  $jwt_audience;
        ~^api://(.+)$ $1;
    }

    map $http_authorization $user_email {
        "~^Bearer.*" '$jwt_aud_client@$oidc_domain';
        default $jwt_claim_email;
    }
    ...
    ```

## Get an access token from Microsoft Entra

1. Send a `POST` request to the Microsoft Entra token endpoint:

    ```bash
    https://login.microsoftonline.com/<your-azure-tenant-id>/oauth2/v2.0/token
    ```

2. Include the following in your request body:
    - `client_id`: The client ID of the application you created.
    - `client_secret`: The client secret for the application.
    - `scope`: The application scope (for example, `api://<client-id>/.default`).
    - `grant_type`: Use `client_credentials`.

3. The response will contain an access token. Decoding the token should give you a result similar to:

    **Header:**

    ```json
    {
        "alg": "RS256",
        "x5t": "-KI3Q9nNR7bR0fxmeZ0XqbHZGew",
        "kid": "-KI3Q9nNR7bR0fxmeZ0XqbHZGew"
    }
    ```

    **Payload:**

    ```json
    {
        "aud": "api://f834b49c-a56e-4fde-9caa-641-bOc26fb8a",
        "iss": "https://sts.windows.net/d3dfd2f-6a3b-40d1-9beO-b8f327d81c50/",
        "iat": 1593640000,
        "nbf": 1593640000,
        "exp": 1593643600,
        "aio": "42+E2ZYHBXei7VKmxxHzn7h1",
        "appid": "374cc05e-aaa1-408f-9348-a83d6b4d8ea6",
        "appidacr": "1",
        "idp": "https://sts.windows.net/d3dfd2f-6a3b-40d1-9beO-b8f327d81c5/",
        "oid": "2db3db56-f58b-455a-9ff5-4e1e8b17a171",
        "rh": "0.AQABA_893Ttq0UCb4L0QwQ-DJ9QgcILmngha-4Q",
        "roles":    [
            "28a3143e-4217-485e-9fOf-092abc01239b01"
        ],
        "sub": "2db3db56-f58b-455a-9ff5-4e1e8b17a1a71",
        "tid": "dd3dfd2f-6a3b-40d1-9bee-bfaqw27d81c5e",
        "uti": "EmqiFiTC-kACZqN5vrKd8AQ" ,
    }
    ```

    {{< note >}}The `roles` claim will contain the role ID of the role you created in the [Create an app role](#create-app-role) step.{{< /note >}}

## Access NGINX Management Suite API using the access token

To access the NGINX Management Suite API using the access token, send the token in the `Authorization` header of the request as a Bearer token. For example, using `curl`:

```bash
curl -v -k --header "Authorization: Bearer <access-token>" https://<nms-ip>/api/platform/v1/userinfo
```

Replace `<access-token>` with the token you obtained from Microsoft Entra and `<nms-ip>` with the IP address of your NGINX Management Suite instance.
