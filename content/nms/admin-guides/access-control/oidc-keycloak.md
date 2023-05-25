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

Complete the steps in this guide to secure Instance Manager with OpenID Connect (OIDC) using Keycloak as the identity provider. As an administrator, when you integrate OpenID authentication with Instance Manager, you can use role-based access control (RBAC) to limit user access to NGINX instances.

---

## Before You Begin

To complete the instructions in this guide, you'll need the following:

- A running Keycloak server. See the Keycloak documentation for [Getting Started](https://www.keycloak.org/guides#getting-started) and [Server](https://www.keycloak.org/guides#server) configuration instructions.
- [Install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) on [NGINX Plus R25 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).
- Install the [NGINX JavaScript module](https://www.nginx.com/blog/introduction-nginscript/) (njs). This module is required for handling interactions between NGINX Plus and the identity provider.  

---
## Create User Groups in Instance Manager {#create-user-groups}

Create user groups in Instance Manager. These User Groups will be mapped from Keycloak **Realm Roles** by name. 

1. Log in to Instance Manager as `admin` using a Basic Auth account.
1. Select the **Settings** gear icon.
1. In the **Settings** menu, select **User Groups**.
1. Select **Create**.
1. On the **Create Group** form, in the **Group Name** box, type the group name.
1. In the **Display Name** box, type the group name.
1. Select **Save**.
1. Repeat steps 5–6 until you've recreated all the groups you want to provide access to, for example "nms-admins", "nms-users", and "nms-nap-users".


## Set up Keycloak {#configure-keycloak}

Follow these steps to configure Keycloak.

1. Log in to Keycloak as an administrator.
1. Select the **Clients** tab.
1. Select **Create**.
1. On the **Add Client** form, in the **Client ID** box, type "nms" as name for the client.
1. On the **Client Protocol** drop-down list, select **openid-connect**.
1. Set the **Root URL** to the URL of the NGINX Management Suite instance, for example, `https://<your instance IP>:443/_codexch`.
1. Select **Save**.

After the client has been created, add the following configuration:


1. On the **Settings** tab, in the **Access Type** drop-down list, select **confidential**.
1. On the **Mapper** tab, select **Add Builtin**, select **groups**, and then select **Add Selected**. This will export the user's Keycloak Realm Role information for NGINX Management Suite to use.

NGINX Management Suite User Groups will be mapped from Keycloak **Realm Roles**; Keycloack Client Roles are **not** mapped. Make sure to use Keycloack top level roles (Realm Roles).

1. On the **Realm Roles** tab, select **Create Role**.
1. In the **Role Name** box, type the name of the first group you created in Instance Manager, for example "nms-admins".
1. Select **Save**.
1. Repeat steps 1–3 until you've recreated all the groups you want to provide access to, for example "nms-users" and "nms-nap-users".

Create the users that will be allowed to log in to Instance Manager.

1. On the **Users** tab, select **Add User**.
1. In the **Username** box, type the user name.
1. In the **Email** box, type the user's email address. NGINX Management Suite will use this email address as the user's identifier when setting its headers.
1. In the **Password** box, type the user's password.
1. Under **Role Mappings** > **Available Roles**, select the groups you want to provide access to, for example "nms-admins", "nms-users", or "nms-nap-users".
1. Select **Add selected**.
1. Select **Save**.

Enable the Service Account for the client.

1. On the **Clients** tab, select the **nms** client.
1. On the **Service Account** tab, select **On**.
1. On the **Service Account Roles** tab, select **Add Roles**.
1. In the **Available Roles** list, select the NGINX Management Suite user group that you have created in Instance Manager, for example "nms-users".
1. Select **Add selected**.
1. Select **Save**.

To get the access token, send a POST request to `https://<keycloak-ip>:<port>/auth/realms/<realms-name>/protocol/openid-connect/token` with the following urlencoded args:

- client_id = name of the client created
- client_secret = secret value
- grant_type = client_credentials


Use the access the resulting token as Bearer token in the Authorization header before sending any NGINX Management Suite or App Delivery Manager API calls for authentication.

</br>

---

## Configure NGINX Management Suite to use Keycloak {#configure-nms}

Obtain the secret from Keycloak and set it as an environment variable on your NGINX Management Suite instance.

On the Keycloak user interface:

1. Select the **Clients** tab, and then select the **nms** client.
1. On the **Credentials** tab, copy the **Secret** value.

On your NGINX Management Suite instance, 

1. Set the following environment variable: `export KEYCLOAK_SECRET=<secret>`
1. Create a copy of the NGINX Management Suite OIDC configuration and update it with the appropriate values:
    ```bash
    scp -F /tmp/ssh-config-${NMS_STACK_ID} ubuntu@${CTRL_IP}:/etc/nms/nginx/oidc/openid_configuration.conf /tmp/openid_configuration.conf.${NMS_RANDOM_ID}
    gsed -i'.bak' \
    -e "s%OIDC_CLIENT_ID%nms%"  \
    -e "s%SERVER_FQDN%${CTRL_IP}%"  \
    -e "s%OIDC_AUTH_ENDPOINT%${KEYCLOAK_AUTH_ENDPOINT}%"  \
    -e "s%OIDC_TOKEN_ENDPOINT%${KEYCLOAK_TOKEN_ENDPOINT}%" \
    -e "s%OIDC_KEYS_ENDPOINT%${KEYCLOAK_KEYS_ENDPOINT}%"  \
    -e "s%OIDC_CLIENT_SECRET%${KEYCLOAK_CLIENT_SECRET}%" \
    -e "s%OIDC_HMAC_KEY%somerandomstring%" \
    /tmp/openid_configuration.conf.${NMS_RANDOM_ID}
    ```
    {{<note>}}the `gsed` command used above is GNU sed, which is installed on the NGINX Management Suite instance. If you are using a different version of sed, you may need to adjust the command accordingly.{{</note>}}
1. Update NGINX Management Suite and enable OIDC. Copy a version of `nms-http.conf` to `~/OIDC` where the OIDC configurations have been uncommented and the Basic Auth parts have been commented out.
    ```bash
    ssh -F /tmp/ssh-config-${NMS_STACK_ID} ubuntu@${CTRL_IP} 'cp /etc/nms/nginx/oidc/openid_configuration.conf ~/openid_configuration.conf.orig'
    ssh -F /tmp/ssh-config-${NMS_STACK_ID} ubuntu@${CTRL_IP} 'cp /etc/nginx/conf.d/nms-http.conf ~/nms-http.conf.orig'
    scp -F /tmp/ssh-config-${NMS_STACK_ID} /tmp/openid_configuration.conf.${NMS_RANDOM_ID} ubuntu@${CTRL_IP}:/etc/nms/nginx/oidc/openid_configuration.conf
    scp -F /tmp/ssh-config-${NMS_STACK_ID} ~/OIDC/nms-http.conf ubuntu@${CTRL_IP}:/etc/nginx/conf.d/nms-http.conf
1. Restart NGINX
    ```bash
    ssh -F /tmp/ssh-config-${NMS_STACK_ID} ubuntu@${CTRL_IP} sudo nginx -s reload
    ```

---

## Try It Out

Open Instance Manager by going to `https://<your-nginx-instance-manager>/ui`.

You should be redirected to the Keycloak login page. Log in with the credentials you created in Keycloak.