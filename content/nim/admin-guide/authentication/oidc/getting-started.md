---
description: ''
docs: DOCS-1267
title: Get started with OIDC
toc: true
weight: 1
type:
- tutorial
---

## Overview

We recommend using OpenID Connect (OIDC) as the preferred authentication method for NGINX Instance Manager. OIDC offers several advantages, including Single Sign-On (SSO) for users and simplified user management for administrators through user groups. OIDC also enables easy scalability and streamlined user access management.

NGINX Instance Manager’s implementation of OIDC is designed to work with any Identity Provider (IdP) that supports the OIDC protocol. The instructions below are general and can be applied to any IdP.

{{<call-out "tip" "Do you need to configure a specific IdP?">}}To learn how to configure OIDC with a specific identity provider, refer to the linked topics in the [Set up specific IdPs for OIDC](#oidc-specific-idps) section at the bottom of this page.{{</call-out>}}

{{<call-out "important" "OIDC is not supported in forward-proxy mode" "fa-solid fa-triangle-exclamation" >}}OpenID Connect (OIDC) authentication is not supported when NGINX Instance Manager is running in [forward-proxy mode]({{< ref "nim/system-configuration/configure-forward-proxy.md" >}}). OIDC is configured on the NGINX Plus layer and cannot pass authentication requests through a forward proxy.{{</call-out>}}

## Create roles and user groups in NGINX Instance Manager {#configure-nim}

When using OIDC for authentication, administrators don't need to create and manage users in NGINX Instance Manager. Instead, they create user groups in NGINX Instance Manager that match groups in their IdP. The roles assigned to the user group set the access level and permissions for users based on their group membership. Users who aren't in a group with an assigned role won't have access to NGINX Instance Manager.

To grant users access using OIDC, follow these steps:

1. Create a role in NGINX Instance Manager.
2. Create a user group and assign a role to it. **Important**: The group name must exactly match a group name in your IdP.
3. Set up OIDC.

### Create a role {#create-role}

{{< include "nim/rbac/create-roles.md" >}}

#### Next steps

After creating a role, assign it to a user group within NGINX Instance Manager that matches a group in your IdP. Proceed to the [create a user group with an assigned role](#create-user-group) section for detailed instructions.

### Create a user group with an assigned role {#create-user-group}

{{< include "nim/rbac/create-user-groups.md" >}}

#### Next steps

Now that you've created a user group and assigned a role in NGINX Instance Manager, continue to the [configure OIDC](#configure-oidc) section. These instructions will help you integrate with your IdP and ensure user groups and permissions work as expected.

## Configure OIDC {#configure-oidc}

### Before you begin

{{<warning>}}
Before switching from basic authentication to OIDC, make sure to add at least one admin user to your IdP. Failure to do so can result in admin users being locked out of NGINX Instance Manager. If this occurs, you can restore access by reverting back to basic authentication.
{{</warning>}}

When you configure OIDC for NGINX Instance Manager, basic authentication will be disabled for all users, including the default `admin` user. To ensure uninterrupted access, create a user group in NGINX Instance Manager that corresponds to a group in your IdP and assign the appropriate roles.

- Follow the instructions above to [grant users access](#granting-users-access) before proceeding.

### Requirements

The following requirements must be met before you can use OIDC with NGINX Instance Manager:

1. [Install Instance Manager]({{< ref "/nim/deploy/vm-bare-metal/install.md" >}}) on a server that also has [NGINX Plus R21 or newer]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) installed. Ensure the server hosting NGINX Plus has a fully qualified domain name (FQDN).

2. [Install the NGINX JavaScript module (njs)](https://www.nginx.com/blog/introduction-nginscript/) on the same server as Instance Manager. This module is required for managing communications between NGINX Plus and the identity provider.

3. Configure an IdP to provide authentication services. This includes setting up authentication policies, scopes, and client credentials within your IdP.

### Enable OIDC

To enable OIDC, follow these steps to update the OIDC configuration file:

1. Open `/etc/nms/nginx/oidc/openid_configuration.conf` in a text editor and replace the default placeholder values with the relevant information for your IdP. (For more information on the variables, refer to the [OIDC configuration values](#oidc-variables).) Save the changes.

1. Open `/etc/nginx/conf.d/nms-http.conf` in a text editor and uncomment the OIDC settings that begin with `#OIDC`. Comment out the basic authentication settings. Save the changes.

1. Run `sudo nginx -t` to validate the configuration and ensure there are no errors.

1. Reload NGINX and apply the new configuration with `sudo nginx -s reload`.

### OIDC configuration values {#oidc-variables}

The sections below provide detailed descriptions of the OIDC configuration values.

#### Metadata from well-known endpoints

- **$oidc_authz_endpoint**: The URL of the IdP’s OAuth 2.0 Authorization endpoint.
- **$oidc_jwt_keyfile**: The URL of the IdP’s JSON Web Key Set (JWKS) document.
- **$oidc_logout_endpoint**: The URL of the IdP’s end_session endpoint.
- **$oidc_token_endpoint**: The URL of the IdP’s OAuth 2.0 Token endpoint.
- **$oidc_userinfo_endpoint**: The URL of the IdP’s UserInfo endpoint.
- **$oidc_host**: The URL of the IdP’s application (for example, `https://{my-app}.okta.com`).
- **$oidc_scopes**: List of OAuth 2.0 scope values supported by the server (for example, `openid+profile+email+offline_access`).

#### Custom configuration for well-known endpoints

For custom settings, adjust parameters such as `$oidc_authz_path_params_enable`, `$oidc_logout_query_params`, and others to match your IdP’s needs.


## Set up specific IdPs for OIDC {#oidc-specific-idps}

For specific IdP setup instructions, refer to the following:

- [Set up Microsoft Entra as an OIDC identity provider]({{< ref "/nim/admin-guide/authentication/oidc/microsoft-entra-setup.md" >}})
- [Set up Keycloak as an OIDC identity provider]({{< ref "/nim/admin-guide/authentication/oidc/keycloak-setup.md" >}})
