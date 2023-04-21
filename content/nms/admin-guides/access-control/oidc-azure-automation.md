---
title: "Set up OIDC for use with automation and Azure AD"
description: "This guide explains how to configure OpenID Connect (OIDC) to use with automation services and Azure Active Directory as the identity provider."
weight: 410
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "security"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops"]
docs: "DOCS-1162"
aliases:
- /nginx-instance-manager/admin-guide/oidc-azure-automation/
---

{{< shortversions "2.9.0" "latest" "nimvers" >}}

## Overview

Complete the steps in this guide to secure NGINX Management Suite Instance Manager with OpenID Connect (OIDC) using Azure Active Directory (AD) as the identity provider for use with automation, such as in CI/CD pipelines. 

## Before you begin

First, secure Instance Manager with OpenID Connect (OIDC) using Azure Active Directory (AD) as the identity provider. To do so, complete the steps in the [Set up OIDC Authentication with Azure AD]({{< relref "/admin-guides/access-control/oidc-azure.md" >}}) guide. After following the steps in that guide, you'll have a registered application (named "Instance Manager" in the guide's example) in Azure AD and a client ID and secret that you can use to configure automation. 

## Configure Azure

### Register a New Application for Your Automation

1. Log in to the [Azure portal](https://portal.azure.com/#home).
1. Select **Azure Active Directory** from the list of Azure services.
1. On the left navigation menu, in the **Manage** section, select **App registrations**.
1. Select **New registration**.
1. Complete the following:

   - In the **Name** box, type the name of the application. For example, "Automation".
   - In the list of account types, select **Account in this organizational directory only**.
   - Leave the **Redirect URI** section unchanged (empty).

1. Select **Register**.
1. On the confirmation page, make a note of the following information. You'll need to provide this information later to complete the setup.

   - Application (client) ID
   - Directory (tenant) ID

### Expose the Application API

1. On the left navigation menu, in the **Manage** section, select **Expose an API**.
1. Select **Set** next to **Application ID URI**.
1. Optionally, in the **Application ID URI** box, type a friendly URI for the application. You can leave the default value (Application ID).
1. Select **Save**.

### Create an App Role

1. On the left navigation menu, in the **Manage** section, select **App roles**.
1. Select **Create app role**.
1. Complete the new role form. You should use the details from an existing NGINX Management Suite user group, such as the one created in the [Create User Groups in Instance Manager]({{< relref "/admin-guides/access-control/oidc-azure.md#create-user-groups-in-instance-manager" >}}) step. For example :

   - In the **Display name** box, type a name for the role. For example, "Admin".
   - In the **Allowed member types** section, select **Applications**.
+   - In the **Value** box, type a value for the role. This needs to match the user-group in NGINX Management Suite. For example, the ID of the name group.
   - In the **Description** box, type a description for the role.

1. Select **Save**.

### Assign the App Role to the Application
1. On the **App registrations** page, select the first application you created in the [Before you begin](#before-you-begin) section. (In the example, it was named "Instance Manager").
1. On the left navigation menu, in the **Manage** section, select **API Permissions**.
1. Select **Add a permission**.
1. In the **Request API permissions** section, select **My APIs**.
1. From the list of APIs, select the app name you created in the [Register a New Application for Your Automation](#register-a-new-application-for-your-automation) steps. (In the example, it was named "Automation").
1. In the **Application permissions** section, select the role you created in the [Create an App Role](#create-an-app-role) steps. (In the example, it was named "Admin").
1. Select **Add permissions**.

  {{< note >}}If the permission created in the preceding step is not granted, try contacting the Azure AD administrator of your tenant about granting it.{{< /note >}}

## Configure NGINX OIDC to use Azure AD IdP

Complete the steps in the [Set Up NGINX Plus to Interact with the Identity Provider]({{< relref "/admin-guides/access-control/oidc-azure.md#set-up-nginx-plus-to-interact-with-the-identity-provider" >}}) topic. Please note that you might have already completed these steps as part of the [Before you begin](#before-you-begin) section of this guide.

Additionally, you will need to complete the following steps:

1. Add the domain of your Azure AD tenant to the `/etc/nms/nginx/oidc/openid_configuration.conf` file. For example, to use the `f5.com` domain for your Azure AD tenant, update the `oidc_domain` value in the file as follows:

    ```nginx
    ...
    map $host $oidc_domain {
        SERVER_FQDN OIDC_DOMAIN;
        # replace with OIDC specific setting
        default "f5.com";
    }
    ...
    ```

1. In the same file, uncomment the map sections corresponding to OIDC with Azure AD:
    
    ```nginx
    ...
    # Enable when using OIDC with Azure AD
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


## Get an Access Token from Azure AD

1. Send a POST request to the Azure AD token endpoint, for example:
    ```bash
    https://login.microsoftonline.com/<your-azure-tenant-id>/oauth2/v2.0/token
    ```

   Provide the following keys:

    - `client_id`: The client ID of the application you created in the [Before You Begin](#before-you-begin) section. In the example, we used "Instance manager".
    - `client_secret`: The client secret of the same application.
    - `scope`: The scope of the application. For example, `api://<client ID of app registration with app role(Admin)>/.default`.
    - `grant_type`: Use `client_credentials`.


1. The response contains an access token. Running a jwt decoder on the access token will return something similar to:

    HEADER:

    ```json
    {
        "alg": "RS256",
        "x5t": "-KI3Q9nNR7bR0fxmeZ0XqbHZGew" ,
        "kid": "-KI3Q9nNR7bR0fxmeZ0XqbHZGew"
    }
    ```

    PAYLOAD:
    
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
    {{< note >}}The `roles` claim contains the role ID of the role you created in the [Create an App Role](#create-an-app-role) steps. (In the example, it was named "Admin").{{< /note >}}

## Access NMS API Using the Access Token

To access the NMS API using the access token, you must send the access token in the `Authorization` header of the request as a Bearer token. For example, using `curl`:

```bash
curl -v -k --header "Authorization: Bearer <access token>" https://<nms-ip>/api/platform/v1/userinfo
```

Replacing `<access token>` with the access token you obtained in the [Get an Access Token from Azure AD](#get-an-access-token-from-azure-ad) steps and `<nms-ip>` with the IP address of your NMS instance.
