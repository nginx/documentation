---
description: This guide provides step-by-step instructions on configuring Keycloak
  as an OpenID Connect (OIDC) identity provider (IdP) for F5 NGINX Management Suite.
  By using OpenID authentication with NGINX Management Suite, you can implement role-based
  access control (RBAC) to limit user access to specific features available in NGINX
  Management Suite.
docs: DOCS-1268
doctypes:
- tutorial
tags:
- docs
title: Set up Keycloak as an OIDC Identity Provider
toc: true
weight: 400
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

This guide explains how to configure Keycloak as an identity provider (IdP) for F5 NGINX Management Suite. By implementing OIDC for authentication, administrators can simplify user management in NGINX Management Suite. Instead of creating and managing users individually, administrators can create user groups in NGINX Management Suite that align with groups in their Identity Provider. Access and permissions for users are determined by the roles assigned to their respective user groups. Users from the Identity Provider who are not part of a group with an assigned role will not have access to NGINX Management Suite.

We strongly recommend Open ID Connect (OIDC) as the preferred authentication method for the NGINX Management Suite. OIDC brings several benefits, including Single Sign-On (SSO) and simplified user management through user groups.

## Requirements

To successfully follow the instructions in this guide, complete the following requirements for your Keycloak server and NGINX Management Suite host:

### Keycloak Server

- Set up a Keycloak server. See the Keycloak [Getting Started](https://www.keycloak.org/guides#getting-started) and [Server](https://www.keycloak.org/guides#server) documentation for configuration instructions. You will need to [create a Realm](https://www.keycloak.org/docs/latest/server_admin/#configuring-realms) with an OpenID Endpoint Configuration enabled.

### NGINX Management Suite

On the NGINX Management Suite host, take the following steps:

- [Install NGINX Plus R25 or a later release]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). Make sure the server hosting NGINX Plus has a fully qualified domain name (FQDN).
- [Install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/install-nim.md" >}}).
- [Install the NGINX JavaScript module (njs)](https://www.nginx.com/blog/introduction-nginscript/). This module is necessary for managing communications between NGINX Plus and the identity provider.

## Configure Keycloak {#configure-keycloak}

### Create Keycloak Client

Follow these steps to configure Keycloak.

1. Log in to Keycloak as an administrator.
1. On the navigation menu, select **Clients**.
1. Select **Create**.
1. On the **Add Client** form, in the **Client ID** box, type "nms" as name for the client.
1. On the **Client Protocol** list, select **openid-connect**.
1. Set the **Root URL** to the URL of the NGINX Management Suite instance, for example, `https://<your instance IP>:443/_codexch`.
1. Select **Save**.

After the client has been created, add the following configuration:

1. On the **Settings** tab, in the **Access Type** list, select **confidential**.
1. On the **Mappers** tab, select **Add Builtin**, and select **groups**. This will export the user's Keycloak Realm Role information for NGINX Management Suite to use.

### Create Keycloak Roles

NGINX Management Suite User Groups will be mapped from Keycloak **Realm Roles**; Keycloak Client Roles are **not** mapped. Make sure to use Keycloak top-level roles (Realm Roles).

1. On the navigation menu, select **Realm Roles**  (or select **Roles** and then the **Realm Roles** tab if you are in an older version of Keycloak).
1. Select **Create Role**.
1. In the **Role Name** box, type the name of the first group you created in NGINX Management Suite, for example "nms-admins".
1. Select **Save**.
1. Repeat steps 1–3 until you've recreated all the groups you want to provide access to, for example "nms-users" and "nms-nap-users".

### Create Keycloak Users

Create the users that will be allowed to log in to NGINX Management Suite.

1. On the navigation bar, select **Users**.
1. Select **Add User**.
1. In the **Username** box, type the user name.
1. In the **Email** box, type the user's email address. NGINX Management Suite will use this email address as the user's identifier when setting its headers.
1. Select **Save**.
1. After creating the user, select the **Credentials** tab.
1. Provide a **Password**, confirm it, and select **Set Password**.
1. On the **Role Mappings** tab, select the desired roles from the list, for example, "nms-admins", "nms-users", or "nms-nap-users".
1. Select **Add selected**.

## Configure NGINX Management Suite {#create-roles-user-groups}

### Create Roles in NGINX Management Suite

{{< include "admin-guides/rbac/create-roles.md" >}}

### Create User Groups in NGINX Management Suite

{{< include "admin-guides/auth/create-user-groups.md" >}}

## Configure NGINX Management Suite to Use Keycloak {#configure-nms}

To configure NGINX Management Suite to use Keycloak as the OIDC identity provider, take the following steps.

### Set Keycloak Secret as an Environment Variable

Set the Keycloak secret as an environment variable on the NGINX Management Suite host.

{{< call-out "important" "Security consideration" >}}When setting a client secret as an environment variable, ensure that the environment where the variable is set has strict access controls. Only authorized users or processes should have access to view or modify the environment variables. You may want to take other precautions as well, such as encrypting the value and regularly rotating the client secret.{{</call-out>}}

To copy the Keycloak secret:

1. Open the Keycloak user interface.
2. Select the **Clients** tab, and then select the **nms** client.
3. On the **Credentials** tab, copy the **Secret** value.

To set the Keycloak secret as an environment variable:

1. Open an SSH connection to your NGINX Management Suite host and log in.
2. Run the following command, replacing `<secret>` with the secret value you copied above:

    ```bash
    export KEYCLOAK_SECRET=<secret>
    ```

### Configure OIDC Settings

In this section, we will show you how to update NGINX Management Suite OIDC configuration with the appropriate values.

Connect to your NGINX Management Suite instance and run the following commands:

- Export the environment variables:

    ```bash
    # Either the FQDN or the IP address is suitable for these environment variables.
    export KEYCLOAK_IP="<insert-keycloak-IP>"
    export NMS_IP="<insert-NMS-IP>"

    export KEYCLOAK_CLIENT_ID="<insert-keycloak-client-id>"
    export KEYCLOAK_CLIENT_SECRET="<insert-kecloak-client-secret>"

    # Choose an appropriate Hash-Based Message Authentication Code (HMAC)
    export HMAC_KEY="<insert-HMAC>"

    export KEYCLOAK_AUTH_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/<realm-name>/.well-known/openid-configuration" | jq -r ".authorization_endpoint")
    export KEYCLOAK_TOKEN_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/<realm-name>/.well-known/openid-configuration" | jq -r ".token_endpoint")
    export KEYCLOAK_KEYS_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/<realm-name>/.well-known/openid-configuration" | jq -r ".jwks_uri")
    ```

- Back up the original configuration files.

    ```bash
    sudo cp /etc/nms/nginx/oidc/openid_configuration.conf ~/openid_configuration.conf.orig
    sudo cp /etc/nginx/conf.d/nms-http.conf ~/nms-http.conf.orig
    ```

- Copy the OpenID configuration for NGINX to `/tmp` so you can replace the necessary values.

    ```bash
    sudo cp /etc/nms/nginx/oidc/openid_configuration.conf /tmp/openid_configuration.conf

    sudo sed -i'.bak' \
    -e "s%OIDC_CLIENT_ID%${KEYCLOAK_CLIENT_ID}%"  \
    -e "s%SERVER_FQDN%${NMS_IP}%"  \
    -e "s%OIDC_AUTH_ENDPOINT%${KEYCLOAK_AUTH_ENDPOINT}%"  \
    -e "s%OIDC_TOKEN_ENDPOINT%${KEYCLOAK_TOKEN_ENDPOINT}%" \
    -e "s%OIDC_KEYS_ENDPOINT%${KEYCLOAK_KEYS_ENDPOINT}%"  \
    -e "s%OIDC_CLIENT_SECRET%${KEYCLOAK_CLIENT_SECRET}%" \
    -e "s%OIDC_HMAC_KEY%${HMAC_KEY}%" \
    /tmp/openid_configuration.conf
    ```

- Uncomment the section of `/tmp/openid_configuration.conf` required for Keycloak as in the following example:

    ```text
    # Enable when using OIDC with keycloak
    map $http_authorization $groups_claim {
        default $jwt_claim_groups;
    }


    map $http_authorization $user_email {
        "~^Bearer.*" '$jwt_clientId@$oidc_domain';
        default $jwt_claim_email;
    }
    ```

- Copy the `nms-http.conf` file to `/tmp` so you can replace the necessary values.

    ```bash
    sudo cp /etc/nginx/conf.d/nms-http.conf /tmp/nms-http.conf
    ```

- Uncomment the OIDC sections in `nms-http.conf` as in the following examples:

    ```text
    # Enable when using OIDC
     log_format oidc_jwt '$remote_addr - $jwt_claim_sub [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" "$http_user_agent" '
                         '"$http_x_forwarded_for"';
    ```

    ```text
    # OIDC -- client configuration uncomment include to enable
    include /etc/nms/nginx/oidc/openid_configuration.conf;
    ```

    ```text
    ## For OIDC Authentication: authorization code flow and Relying Party processing
    # OIDC - remove comment from following directives to enable
    add_header Nginx-Management-Suite-Auth "OIDC";
    include /etc/nms/nginx/oidc/openid_connect.conf;
    ```

    ```text
    # OIDC: use email as a unique identifier
    # NOTE: the username is dependent upon claims provided by your IdP
    proxy_set_header Nginx-Management-Suite-Auth "OIDC";
    proxy_set_header Nginx-Management-Suite-User $user_email;
    proxy_set_header Nginx-Management-Suite-Groups $groups_claim;
    proxy_set_header Nginx-Management-Suite-ExternalId $jwt_claim_sub;
    ```

    Also uncomment all the sections starting with `# OIDC authentication (uncomment to enable)`.

- Comment out all the Basic Auth sections in `nms-http.conf` as in the following examples:

    ```text
    ## For use with basic auth
    #auth_basic_user_file /etc/nms/nginx/.htpasswd;
    ## auth type indication to the client
    #add_header Nginx-Management-Suite-Auth "Basic";
    ```

    ```text
    # HTTP Basic:
    #proxy_set_header Nginx-Management-Suite-User $remote_user;
    #proxy_set_header Nginx-Management-Suite-Groups "";
    #proxy_set_header Nginx-Management-Suite-ExternalId "";
    ```

    Also comment out all the sections starting with `# HTTP Basic authentication (comment if using OIDC auth)` or `# HTTP Basic authentication (disable if using OIDC)`.

- Copy the modified configuration files back to their original locations.

    ```bash
    sudo cp /tmp/nms-http.conf /etc/nginx/conf.d/nms-http.conf
    sudo cp /tmp/openid_configuration.conf /etc/nms/nginx/oidc/openid_configuration.conf
    ```

- Run `sudo nginx -t` to verify the config has no errors.

- Reload NGINX running `sudo nginx -s reload`.

## Troubleshooting

You can revert to Basic Auth to troubleshoot authentication issues by running the following commands:

```bash
sudo cp ~/openid_configuration.conf.orig /etc/nms/nginx/oidc/openid_configuration.conf
sudo cp ~/nms-http.conf.orig /etc/nginx/conf.d/nms-http.conf

sudo nginx -s reload
```

## Try It Out

Open NGINX Management Suite by going to `https://<your-nginx-instance-manager>/ui`.

You should be redirected to the Keycloak login page. Log in with the credentials you created in Keycloak.
