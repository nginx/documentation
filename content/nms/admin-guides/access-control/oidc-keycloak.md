---
title: "Set up OIDC Authentication with Keycloak"
description: "This guide explains how to configure OpenID Connect (OIDC) with Keycloak as the identity provider."
# Assign weights in increments of 100
weight: 450
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "security"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops"]
versions: []
authors: []
aliases:
- /nginx-instance-manager/admin-guide/oidc-keycloak/
---

{{< shortversions "2.1.0" "latest" "nimvers" >}}

## Overview

Complete the steps in this guide to secure Instance Manager with OpenID Connect (OIDC) using the authorization code flow method and [Keycloak](https://www.keycloak.org) as the identity provider. As an administrator, when you integrate OpenID authentication with Instance Manager, you can use role-based access control (RBAC) to limit user access to NGINX instances.

---

## Before You Begin

To complete the instructions in this guide, you'll need the following:

- A running Keycloak server. See the Keycloak documentation for [Getting Started](https://www.keycloak.org/guides#getting-started) and [Server](https://www.keycloak.org/guides#server) configuration instructions. You will need to [create a Realm](https://www.keycloak.org/docs/latest/server_admin/#configuring-realms) with an OpenID Endpoint Configuration enabled.
- [Install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) on [NGINX Plus R25 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).
- Install the [NGINX JavaScript module](https://www.nginx.com/blog/introduction-nginscript/) (njs). This module is required for handling interactions between NGINX Plus and the identity provider.  

---
## Create Roles and User Groups in Instance Manager {#create-roles-user-groups}

By default, Instance Manager includes a single role called `admin`. Depending on your requirements, you might need to create **additional roles** for the different User Groups, such as "user" and "nap-user".

{{< include "admin-guides/access-control/create-role.md" >}}

Create user groups in Instance Manager, for example, "nms-admins", "nms-users", and "nms-nap-users".  These User Groups will be mapped from Keycloak Realm Roles by name. 

{{< include "admin-guides/access-control/create-group.md" >}}

## Set up Keycloak {#configure-keycloak}

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

NGINX Management Suite User Groups will be mapped from Keycloak **Realm Roles**; Keycloack Client Roles are **not** mapped. Make sure to use Keycloack top-level roles (Realm Roles).

1. On the navigation menu, select **Realm Roles**  (or select **Roles** and then the **Realm Roles** tab if you are in an older version of Keycloak).
1. Select **Create Role**.
1. In the **Role Name** box, type the name of the first group you created in Instance Manager, for example "nms-admins".
1. Select **Save**.
1. Repeat steps 1–3 until you've recreated all the groups you want to provide access to, for example "nms-users" and "nms-nap-users".

Create the users that will be allowed to log in to Instance Manager.

1. On the navigation bar, select **Users**. 
1. Select **Add User**.
1. In the **Username** box, type the user name.
1. In the **Email** box, type the user's email address. NGINX Management Suite will use this email address as the user's identifier when setting its headers.
1. Select **Save**.
1. After creating the user, select the **Credentials** tab.
1. Provide a **Password**, confirm it, and select **Set Password**.
1. On the **Role Mappings** tab, select the desired roles from the list, for example, "nms-admins", "nms-users", or "nms-nap-users".
1. Select **Add selected**.


Enable the Service Account for the client.

1. On the navigation bar, select **Clients**.
1. Select "Confidential" from the **Access Type** list.
1. Select the "nms" client.
1. On the **Service Account** tab, select **On**.
1. Select **Save**.
1. On the **Service Account Roles** tab, in the **Available Roles** list, select the NGINX Management Suite user group that you have created in Instance Manager, for example "nms-users".
1. Select **Add selected**.
1. Select **Save**.

---

## Configure NGINX Management Suite to use Keycloak {#configure-nms}

- Copy the secret from Keycloak and set it as an environment variable on your NGINX Management Suite instance.

    On the Keycloak user interface:

    1. Select the **Clients** tab, and then select the **nms** client.
    1. On the **Credentials** tab, copy the **Secret** value.

    On your NGINX Management Suite instance, 

    1. Set the following environment variable: `export KEYCLOAK_SECRET=<secret>`
    1. Update the NGINX Management Suite OIDC configuration and with the appropriate values:

Connect to your NGINX Management Suite instance and run the following commands:

- Export the environment varibles:

    ```bash
    # Either the FQDN or the IP address is suitable for these environment variables.
    export KEYCLOAK_IP="<insert-keycloak-IP>"
    export NMS_IP="<insert-NMS-IP>"

    export KEYCLOAK_CLIENT_ID="<insert-keycloak-client-id>"
    export KEYCLOAK_CLIENT_SECRET="<insert-kecloak-client-secret>"

    # Choose an appropriate HMAC
    export HMAC_KEY="<insert-HMAC>"

    export KEYCLOAK_AUTH_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/nginx/.well-known/openid-configuration" | jq -r ".authorization_endpoint")
    export KEYCLOAK_TOKEN_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/nginx/.well-known/openid-configuration" | jq -r ".token_endpoint")
    export KEYCLOAK_KEYS_ENDPOINT=$(curl -k "https://$KEYCLOAK_IP:8443/auth/realms/nginx/.well-known/openid-configuration" | jq -r ".jwks_uri")
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

- Copy the nms-http.conf file to `/tmp` so you can replace the necessary values.

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
sudo cp ~/openid_configuration.conf.orig etc/nms/nginx/oidc/openid_configuration.conf
sudo cp ~/nms-http.conf.orig /etc/nginx/conf.d/nms-http.conf

sudo nginx -s reload
```

## Try It Out

Open Instance Manager by going to `https://<your-nginx-instance-manager>/ui`.

You should be redirected to the Keycloak login page. Log in with the credentials you created in Keycloak.