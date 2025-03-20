---
docs: DOCS-1268
title: 'Keycloak: Set up OIDC authentication'
toc: true
weight: 400
type:
- tutorial
---

## Overview

This guide explains how to configure Keycloak as an identity provider (IdP) for F5 NGINX Instance Manager. By implementing OIDC for authentication, administrators can simplify user management in NGINX Instance Manager. Instead of creating and managing users individually, administrators can create user groups in NGINX Instance Manager that align with groups in their Identity Provider. Access and permissions for users are determined by the roles assigned to their respective user groups. Users from the Identity Provider who are not part of a group with an assigned role will not have access to NGINX Instance Manager.

We strongly recommend OpenID Connect (OIDC) as the preferred authentication method for NGINX Instance Manager. OIDC brings several benefits, including Single Sign-On (SSO) and simplified user management through user groups.

## Requirements

To follow the instructions in this guide, ensure you have the following setup for your Keycloak server and NGINX Instance Manager host:

### Keycloak Server

- Set up a Keycloak server. Refer to the Keycloak [Getting Started](https://www.keycloak.org/guides#getting-started) and [Server](https://www.keycloak.org/guides#server) documentation for setup instructions. You will need to [create a Realm](https://www.keycloak.org/docs/latest/server_admin/#configuring-realms) with an OpenID Endpoint Configuration enabled.

### NGINX Instance Manager

On the NGINX Instance Manager host, complete the following:

- [Install NGINX Plus R25 or a later version]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). Ensure the server hosting NGINX Plus has a fully qualified domain name (FQDN).
- [Install NGINX Instance Manager]({{< relref "/nim/deploy/vm-bare-metal/install.md" >}}).
- [Install the NGINX JavaScript module (njs)](https://www.nginx.com/blog/introduction-nginscript/). This module is needed for managing communications between NGINX Plus and the identity provider.

## Configure Keycloak {#configure-keycloak}

### Create Keycloak Client

Follow these steps to configure Keycloak.

1. Log in to Keycloak as an administrator.
2. In the navigation menu, select **Clients**.
3. Select **Create**.
4. On the **Add Client** form, in the **Client ID** box, type `nim` as the name for the client.
5. In the **Client Protocol** list, select **openid-connect**.
6. Set the **Root URL** to the URL of the NGINX Instance Manager instance, for example, `https://<your instance IP>:443/_codexch`.
7. Select **Save**.

After the client is created, configure it as follows:

#### For Keycloak versions earlier than 18.x

1. On the **Settings** tab, set **Access Type** to **confidential**.
2. On the **Mappers** tab, select **Add Builtin** and choose **groups** to export Keycloak Realm Role information for NGINX Instance Manager.

#### For Keycloak versions 18.x and later

1. On the **Settings** tab, under **Capability config**, enable **Client authentication**.
2. In the **Authentication flow** section, enable **Direct Access Grants** and **Service Account**.
3. Go to the **Client Scopes** tab.
   - Select the scope named **<client_name>-dedicated (nim-dedicated)**.
   - On the **Mappers** tab, click **Configure new Mapper** and choose **From predefined mappers**.
   - Search for **groups** and select **Add groups mapper**.

### Create Keycloak Roles

NGINX Instance Manager User Groups will map to Keycloak **Realm Roles**; Keycloak Client Roles are **not** mapped. Use Keycloak top-level roles (Realm Roles).

1. In the navigation menu, select **Realm Roles** (or select **Roles** and then the **Realm Roles** tab if using an older version of Keycloak).
2. Select **Create Role**.
3. In the **Role Name** box, type the name of the first group you created in NGINX Instance Manager, for example, `nim-admins`.
4. Select **Save**.
5. Repeat steps 1–3 for all the groups you want to provide access to, for example, `nim-users` and `nim-nap-users`.

### Create Keycloak Users

Create the users that will be allowed to log in to NGINX Instance Manager.

1. In the navigation bar, select **Users**.
2. Select **Add User**.
3. In the **Username** box, type the user's name.
4. In the **Email** box, type the user's email address. NGINX Instance Manager will use this email address as the user's identifier when setting its headers.
5. Select **Save**.
6. After creating the user, go to the **Credentials** tab.
7. Provide a **Password**, confirm it, and select **Set Password**.
8. On the **Role Mappings** tab, select the roles you want to assign, such as `nim-admins`, `nim-users`, or `nim-nap-users`.
9. Select **Add selected**.

## Configure NGINX Instance Manager {#create-roles-user-groups}

### Create Roles in NGINX Instance Manager

{{< include "nim/rbac/create-roles.md" >}}

### Create User Groups in NGINX Instance Manager

{{< include "nim/rbac/create-user-groups.md" >}}

## Configure NGINX Instance Manager to use Keycloak {#configure-nim}

{{<call-out "important" "File naming convention" >}}
Some file names in this guide, such as `nms-http.conf` and directories like `/etc/nms/nginx/`, still use the `nms` naming convention. This is for backward compatibility and does not affect the functionality of NGINX Instance Manager.
{{</call-out>}}

To configure NGINX Instance Manager to use Keycloak as the OIDC identity provider, follow these steps.

### Set Keycloak Secret as an Environment Variable

Set the Keycloak secret as an environment variable on the NGINX Instance Manager host.

{{< call-out "important" "Security consideration" >}}When setting a client secret as an environment variable, ensure that the environment has strict access controls. Only authorized users or processes should be able to view or modify the environment variables. Consider encrypting the value and regularly rotating the client secret.{{</call-out>}}

To copy the Keycloak secret:

1. Open the Keycloak user interface.
2. Select the **Clients** tab, then select the **nim** client.
3. On the **Credentials** tab, copy the **Secret** value.

To set the Keycloak secret as an environment variable:

1. Open an SSH connection to your NGINX Instance Manager host and log in.
2. Run the following command, replacing `<secret>` with the secret value you copied:

    ```bash
    export KEYCLOAK_SECRET=<secret>
    ```

### Configure OIDC Settings

To configure NGINX Instance Manager with the necessary OIDC settings, follow these steps:

- Export the environment variables:

  - **For Keycloak versions earlier than 18.x**:

    ```bash
    # Either the FQDN or the IP address is suitable for these environment variables.
    export KEYCLOAK_IP="<insert-keycloak-IP>"
    export NIM_IP="<insert-NIM-IP>"
    export KEYCLOAK_CLIENT_ID="<insert-keycloak-client-id>"
    export KEYCLOAK_CLIENT_SECRET="<insert-kecloak-client-secret>"

    # Choose an appropriate Hash-Based Message Authentication Code (HMAC)
    export HMAC_KEY="<insert-HMAC>"

    export KEYCLOAK_AUTH_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/<realm-name>/.well-known/openid-configuration" | jq -r ".authorization_endpoint")
    export KEYCLOAK_TOKEN_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/<realm-name>/.well-known/openid-configuration" | jq -r ".token_endpoint")
    export KEYCLOAK_KEYS_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/<realm-name>/.well-known/openid-configuration" | jq -r ".jwks_uri")
    ```

  - **For Keycloak versions 18.x and later**:

    ```bash
    # Either the FQDN or the IP address is suitable for these environment variables.
    export KEYCLOAK_IP="<insert-keycloak-IP>"
    export NIM_IP="<insert-NIM-IP>"
    export KEYCLOAK_CLIENT_ID="<insert-keycloak-client-id>"
    export KEYCLOAK_CLIENT_SECRET="<insert-kecloak-client-secret>"

    # Choose an appropriate Hash-Based Message Authentication Code (HMAC)
    export HMAC_KEY="<insert-HMAC>"

    export KEYCLOAK_AUTH_ENDPOINT=$(curl -k \
      "https://$KEYCLOAK_IP:8443/realms/<realm-name>/.well-known/openid-configuration" | \
      jq -r ".authorization_endpoint")

    export KEYCLOAK_TOKEN_ENDPOINT=$(curl -k \
      "https://$KEYCLOAK_IP:8443/realms/<realm-name>/.well-known/openid-configuration" | \
      jq -r ".token_endpoint")

    export KEYCLOAK_KEYS_ENDPOINT=$(curl -k \
      "https://$KEYCLOAK_IP:8443/realms/<realm-name>/.well-known/openid-configuration" | \
      jq -r ".jwks_uri")
    ```
    
- Back up the original configuration files:

    ```bash
    sudo cp /etc/nms/nginx/oidc/openid_configuration.conf ~/openid_configuration.conf.orig
    sudo cp /etc/nginx/conf.d/nms-http.conf ~/nms-http.conf.orig
    ```

- Copy the OpenID configuration for NGINX to `/tmp` so you can replace the necessary values:

    ```bash
    sudo cp /etc/nms/nginx/oidc/openid_configuration.conf /tmp/openid_configuration.conf
    sudo sed -i'.bak' \
    -e "s%OIDC_CLIENT_ID%${KEYCLOAK_CLIENT_ID}%"  \
    -e "s%SERVER_FQDN%${NIM_IP}%"  \
    -e "s%OIDC_AUTH_ENDPOINT%${KEYCLOAK_AUTH_ENDPOINT}%"  \
    -e "s%OIDC_TOKEN_ENDPOINT%${KEYCLOAK_TOKEN_ENDPOINT}%" \
    -e "s%OIDC_KEYS_ENDPOINT%${KEYCLOAK_KEYS_ENDPOINT}%"  \
    -e "s%OIDC_CLIENT_SECRET%${KEYCLOAK_CLIENT_SECRET}%" \
    -e "s%OIDC_HMAC_KEY%${HMAC_KEY}%" \
    /tmp/openid_configuration.conf
    ```

- Uncomment the relevant Keycloak sections in `/tmp/openid_configuration.conf`:

    ```yaml
    # Enable when using OIDC with keycloak
    map $http_authorization $groups_claim {
        default $jwt_claim_groups;
    }


    map $http_authorization $user_email {
        "~^Bearer.*" '$jwt_clientId@$oidc_domain';
        default $jwt_claim_email;
    }
    ```

- Copy the `nms-http.conf` file to `/tmp` to replace the necessary values:

    ```bash
    sudo cp /etc/nginx/conf.d/nms-http.conf /tmp/nms-http.conf
    ```

- Uncomment the OIDC sections in `nms-http.conf`:

    ```yaml
    # Enable when using OIDC
     log_format oidc_jwt '$remote_addr - $jwt_claim_sub [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" "$http_user_agent" '
                         '"$http_x_forwarded_for"';
    ```

    ```yaml
    # OIDC -- client configuration uncomment include to enable
    include /etc/nms/nginx/oidc/openid_configuration.conf;
    ```

    ```yaml
    ## For OIDC Authentication: authorization code flow and Relying Party processing
    # OIDC - remove comment from following directives to enable
    add_header Nginx-Management-Suite-Auth "OIDC";
    include /etc/nms/nginx/oidc/openid_connect.conf;
    ```

    ```yaml
    # OIDC: use email as a unique identifier
    # NOTE: the username is dependent upon claims provided by your IdP
    proxy_set_header Nginx-Management-Suite-Auth "OIDC";
    proxy_set_header Nginx-Management-Suite-User $user_email;
    proxy_set_header Nginx-Management-Suite-Groups $groups_claim;
    proxy_set_header Nginx-Management-Suite-ExternalId $jwt_claim_sub;
    ```

    Also uncomment all sections starting with `# OIDC authentication (uncomment to enable)`.

- Comment out all the Basic Auth sections in `nms-http.conf`:

    ```yaml
    ## For use with basic auth
    #auth_basic_user_file /etc/nms/nginx/.htpasswd;
    ## auth type indication to the client
    #add_header Nginx-Management-Suite-Auth "Basic";
    ```

    ```yaml
    # HTTP Basic:
    #proxy_set_header Nginx-Management-Suite-User $remote_user;
    #proxy_set_header Nginx-Management-Suite-Groups "";
    #proxy_set_header Nginx-Management-Suite-ExternalId "";
    ```

- Copy the modified configuration files back to their original locations:

    ```bash
    sudo cp /tmp/nms-http.conf /etc/nginx/conf.d/nms-http.conf
    sudo cp /tmp/openid_configuration.conf /etc/nms/nginx/oidc/openid_configuration.conf
    ```

- Run `sudo nginx -t` to verify the config has no errors.
- Reload NGINX by running `sudo nginx -s reload`.

## Troubleshooting

To revert to Basic Auth for troubleshooting authentication issues, run:

```bash
sudo cp ~/openid_configuration.conf.orig /etc/nms/nginx/oidc/openid_configuration.conf
sudo cp ~/nms-http.conf.orig /etc/nginx/conf.d/nms-http.conf
sudo nginx -s reload
```

## Try It Out

Open NGINX Instance Manager by going to `https://<your-nginx-instance-manager>/ui`. You will be redirected to the Keycloak login page. Log in with the credentials you created in Keycloak.
