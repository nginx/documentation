---
title: 'Microsoft Entra: Set up OIDC authentication'
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIM
nd-docs: DOCS-795
---

## Overview

This guide explains how to configure Microsoft Entra (AD) as an identity provider (IdP) for F5 NGINX Instance Manager. By implementing OIDC for authentication, administrators can simplify user management in NGINX Instance Manager. Instead of creating and managing users individually, administrators can create user groups in NGINX Instance Manager that align with groups in their Identity Provider. Access and permissions for users are determined by the roles assigned to their respective user groups. Users from the Identity Provider who are not part of a group with an assigned role will not have access to NGINX Instance Manager.

We strongly recommend Open ID Connect (OIDC) as the preferred authentication method for the NGINX Instance Manager. OIDC brings several benefits, including Single Sign-On (SSO) and simplified user management through user groups.

To configure Microsoft Entra as an OIDC IdP, follow these steps:

**Configure Microsoft Entra:**

1. Create an Application Registration for NGINX Instance Manager.
1. Add owners (users) and their email addresses to Microsoft Entra.
1. Create groups in Microsoft Entra and assign user membership.

**Configure NGINX Instance Manager:**

1. Add user groups to NGINX Instance Manager, using the same group names as in Microsoft Entra.
1. Configure NGINX Plus in NGINX Instance Manager to use Microsoft Entra as the designated identity provider.

## Before you begin

To successfully follow the instructions in this guide, you must complete the following requirements:

1. Create a [Microsoft Entra premium account](https://azure.microsoft.com/en-us/pricing/details/active-directory/). If you have a standard account, you'll need to upgrade.
1. [Install Instance Manager]({{< ref "/nim/deploy/vm-bare-metal/install.md" >}}) on a server that also has [NGINX Plus R25 or a newer version installed]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). Make sure the server hosting NGINX Plus has a fully qualified domain name (FQDN).
1. [Install the NGINX JavaScript module (njs)](https://www.nginx.com/blog/introduction-nginscript/) on the same server as Instance Manager. This module is necessary for managing communications between NGINX Plus and the identity provider.

## Configure Microsoft Entra {#configur-entra}

Complete the steps in the section to configure Microsoft Entra for use with NGINX Instance Manager.

### Register Application {#az-ad-register-app}

To register an application with Microsoft Entra:

1. Go to the [Azure portal](https://portal.azure.com/#home) and log in.
1. Select **Microsoft Entra** from the list of Azure services.
1. On the left navigation menu, under the **Manage** section, select **App registrations**.
1. Select **New registration**.
1. Provide the following details:
   - Enter a name for the application in the **Name** field, such as "NGINX Instance Manager".
   - Select **Account in this organizational directory only** from the list of account types.
   - Under the **Redirect URI** section, choose **Web** and enter the redirect URI, for example, `https://<my-nginx-instance-manager>/_codexch`.

   {{< img src="/security/oidc/azure-register-app.png" alt="Azure: register an application." width="600" height="415" >}}

1. Select **Register**.
1. On the confirmation page, make a note of the following information. You'll need to provide this information later to complete the setup:
   - Application (client) ID
   - Directory (tenant) ID

### Create Client Secret {#az-ad-client-secret}

{{< call-out "important" >}}Make sure to save the value of the client secret in a secure location for future reference. Once you navigate away from the page, the value cannot be retrieved again.{{< /call-out >}}

To create a client secret:

1. On the left navigation menu, under the **Manage** section, select **Certificates & secrets**.
1. Select **New client secret**.
1. In the **Description** box, type a description for the client secret.
1. Select **Add**. The client secret will be added to the list with a unique secret string value and ID.
1. Copy the value for the client secret.

### Add Owners {#az-ad-owners}

{{< call-out "important" >}}Make sure to add at least one user with administrative privileges. Failure to do so may lock admin users out of NGINX Instance Manager. If that happens, revert to Basic Auth to restore access.{{< /call-out >}}

To add owners (users):

1. On the left navigation menu, under the **Manage** section, select **Owners**.
2. Select **Add owners**.
3. Search for the user you want to add, then select **Select**. Repeat this step for each user you want to add.

### Add Group Claim to Token {#az-ad-group-claim}

{{< call-out "note" >}}The only supported group claim format for groups created in Microsoft Entra is **Microsoft Entra group ObjectId**.{{< /call-out >}}

To include the user's group membership information in the token for authentication and authorization, follow these steps:

1. On the left navigation menu, under the **Manage** section, select **Token configuration**.
1. Select **Add groups claim**.
1. Select **Groups assigned to the application**.
1. Select **Add**.

### Assign Group to Application {#az-ad-group}

{{< call-out "note" >}}By default, tokens expire after 60 minutes. You can find instructions on configuring token expiration in the Microsoft Entra topic [Configurable token lifetime properties](https://learn.microsoft.com/en-us/azure/active-directory/develop/Active-directory-configurable-token-lifetimes#configurable-token-lifetime-properties).{{< /call-out >}}

Adding a group to the registered application will give all group members the same access.

1. On the left navigation menu, under the **Manage** section, select **Overview**.
1. In the **Essentials** section, select the link next to **Managed application in local directory**.
1. In the **Getting Started** section, select **Assign users and groups**.
1. Select **Add user/group**.
1. On the **Add Assignment** form, under the **Users and groups** section, select **None Selected**.
1. In the search box in the **Users and groups** drawer, type the name of the group you want to associate with the application.
1. Select the group from the list, and select **Select**.
1. Finally, select **Assign**.

## Configure NGINX Instance Manager {#configure-nginx-instance-manager}

### Create Roles in NGINX Instance Manager

{{< include "nim/rbac/create-roles.md" >}}

### Create User Groups in NGINX Instance Manager

{{< include "nim/rbac/create-user-groups.md" >}}

### Configure NGINX Plus with Microsoft Entra as Identity Provider {#configure-nginx-plus}

Configure NGINX Plus to use Microsoft Entra as the identity provider.

1. Install the NGINX JavaScript module (njs) on your NGINX Instance Manager server by running the appropriate command. This module is required for handling the interaction between NGINX Plus and Microsoft Entra (IdP).

   - CentOS, RHEL:
     ```shell
     sudo yum install nginx-plus-module-njs
     ```

   - Debian, Ubuntu:
     ```shell
     sudo apt install nginx-plus-module-njs
     ```

2. Open the `/etc/nginx/nginx.conf` file in a text editor and add the following directive to the top-level ("main") section to load the NGINX JavaScript module:
   ```nginx
   load_module modules/ngx_http_js_module.so;
   ```

3. Open the `/etc/nms/nginx/oidc/openid_configuration.conf` file in a text editor. Replace the following variables in the file with the values you saved when [configuring Microsoft Entra](#configure-entra). Save the changes:
   - `{client_key}`: Replace with the **Application (client) ID** obtained when [registering the application](#az-ad-register-app).
   - `{tenant_key}`: Replace with the **Directory (tenant) ID** obtained when [registering the application](#az-ad-register-app).
   - `{client_secret}`: Replace with the encoded client secret that was generated when [creating the client secret](#az-ad-client-secret).

    {{< details summary="Example openid_configuration.conf" >}}

    ```yaml
    # NGINX Instance Manager - OpenID Connect configuration
    # Created for v. 2.0
    # (c) NGINX, Inc. 2021

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
    map $host $oidc_authz_endpoint {
        default "https://login.microsoftonline.com/{tenant_key}/oauth2/v2.0/authorize";
    }
    map $host $oidc_token_endpoint {
        default "https://login.microsoftonline.com/{tenant_key}/oauth2/v2.0/token";
    }
    map $host $oidc_jwt_keyfile {
        default "https://login.microsoftonline.com/{tenant_key}/discovery/v2.0/keys";
    }
    ```

    {{< /details >}}

4. Using a text editor, open the `/etc/nginx/conf.d/nms-http.conf` configuration file and uncomment the OIDC settings starting with `#OIDC`. Comment out the Basic Authentication settings. Save the changes.

    {{< details summary="Example nms-http.conf" >}}

    ```yaml
    # NGINX Instance Manager - Instance Manager configuration
    # Created for v. 2.0
    # (c) NGINX, Inc. 2021

    # OIDC: use email as a unique identifier
    proxy_set_header Nginx-Management-Suite-User $user_email;
    proxy_set_header Nginx-Management-Suite-Groups $groups_claim;
    proxy_set_header Nginx-Management-Suite-ExternalId $jwt_claim_sub;

    # OIDC authentication
    include /etc/nms/nginx/oidc/openid_connect.conf;
    ```

    {{< /details >}}

5. Verify that the configuration file does not contain any errors:
   ```shell
   sudo nginx -t
   ```

6. Reload NGINX and apply the configuration:
   ```shell
   sudo nginx -s reload
   ```

## Test Entrana OIDC

1. Open a web browser and go to the FQDN of your NGINX Instance Manager host. You will be redirected to the Microsoft Entra login page.
1. Enter your Microsoft Entra email address and password to log in.
