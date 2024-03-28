---
description: ''
docs: DOCS-1267
doctypes:
- tutorial
tags:
- docs
title: Getting Started with OIDC
toc: true
weight: 1
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

We highly recommend using Open ID Connect (OIDC) as the preferred authentication method for the NGINX Management Suite. OIDC offers several advantages, including a Single Sign-On (SSO) experience for users and simplified user management for administrators through the use of user groups. OIDC allows for easy scalability and streamlined administration of user access.

NGINX Management Suite's implementation of OpenID Connect (OIDC) is designed to work with any Identity Provider (IdP) that supports the OIDC protocol. The instructions provided below are general and can be applied to any IdP.

<br>

{{<call-out "tip" "Do you need to configure a specific IdP?">}}To learn how to configure OpenID Connect (OIDC) with a specific identity provider, refer to the linked topics in the [Set Up Specific IdPs for OIDC](#oidc-specific-idps) section at the bottom of this page.{{</call-out>}}

## Create Roles and User Groups in NGINX Management Suite {#configure-nms}

When using OIDC for authentication, administrators don't need to create and manage users in NGINX Management Suite. Instead, they can make user groups in NGINX Management Suite that match groups in their Identity Provider. The roles assigned to the user group set the access level and permissions for users according to their group membership. Users from the Identity Provider who aren't in a group with an assigned role won't have access to NGINX Management Suite.

To grant users access using OIDC, simply follow these steps:

1. Create a role in NGINX Management Suite,
2. Create a user group and assign a role to it. **Important**: The group name must exactly match a group name in your IdP.
3. Set up OIDC.

### Create a Role {#create-role}

{{< include "admin-guides/rbac/create-roles.md" >}}

#### Next Steps

After creating a role, you'll want to assign it to a user group within NGINX Management Suite that matches a group in your IdP. Proceed to the [Create a User Group with an Assigned Role](#create-user-group) section for detailed instructions.

### Create a User Group with an Assigned Role {#create-user-group}



{{< include "admin-guides/auth/create-user-groups.md" >}}

#### Next Steps

Now that you have created a user group and assigned a role in NGINX Management Suite, continue to the [Configure OIDC](#configure-oidc) section of this document. These instructions will help you complete the integration with your Identity Provider and ensure your user groups and permissions work as expected.

## Configure OIDC {#configure-oidc}

### Before You Begin


{{<warning>}}
Before switching from Basic Authentication to OIDC, make sure to add at least one admin user to your identity provider. Failure to do so can result in admin users being locked out of NGINX Management Suite. If this occurs, you can restore access by reverting back to Basic Authentication.
{{</warning>}}

When you configure OIDC authentication for NGINX Management Suite, Basic Authentication will be disabled for all users, including the default `admin` user. To ensure uninterrupted access, you need to create a user group in NGINX Management Suite that corresponds to a group in your Identity Provider (IdP) and assign the appropriate roles.

- Follow the instructions above to [grant users access](#granting-users-access) before proceeding.


### Requirements

The following requirements must be met before you can use OIDC with NGINX Management Suite:

1. [Install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/install-nim.md" >}}) on a server that also has [NGINX Plus R21 or a newer version installed]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). Make sure the server hosting NGINX Plus has a fully qualified domain name (FQDN).

2. [Install the NGINX JavaScript module (njs)](https://www.nginx.com/blog/introduction-nginscript/) on the same server as Instance Manager. This module is necessary for managing communications between NGINX Plus and the identity provider.

3. Configure an Identity Provider (IdP) to provide authentication services. This involves setting up the necessary authentication policies, scopes, and client credentials within your IdP.

### Enable OIDC

To enable OIDC functionality, you must update the placeholder default values in the OIDC configuration file (`openid_configuration.conf`). Follow these steps:

1. Open the OIDC configuration file `/etc/nms/nginx/oidc/openid_configuration.conf` using a text editor and update the default placeholder values with the relevant information for your identity provider. (To learn more about the variables, refer to the [OIDC Settings](#oidc-variables) below.) Save the changes.

2. Using a text editor, open the `/etc/nginx/conf.d/nms-http.conf` configuration file and uncomment the OIDC settings starting with `#OIDC`. Comment out the Basic Authentication settings. Save the changes.

3. If you have additional modules installed, such as API Connectivity Manager, you need to modify their specific configuration files as well.

   Open the API Connectivity Manager configuration file `/etc/nms/nginx/locations/nms-acm.conf` in an app-developer and uncomment the OIDC settings starting with `#OIDC`. Comment out the settings for Basic Authentication. Save the changes.

4. Run the command `sudo nginx -t` to validate the configuration and ensure there are no errors.

5. Finally, reload NGINX and apply the new configuration by running the command `sudo nginx -s reload`.


### OIDC Configuration Values {#oidc-variables}

Select the links below to view the OIDC configuration values and descriptions.

<details closed>
<summary>Metadata from Well-Known Endpoints</summary>


{{< bootstrap-table "table table-striped table-bordered" >}}

| Variable                | Description                                                                                                           |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------|
| $oidc_authz_endpoint    | URL of the IdP’s OAuth 2.0 Authorization endpoint.                                                                    |
| $oidc_jwt_keyfile       | URL of the IdP’s JSON Web Key Set (JWKS) document.                                                                    |
| $oidc_logout_endpoint   | URL of the IdP’s end_session endpoint.                                                                                |
| $oidc_token_endpoint    | URL of the IdP’s OAuth 2.0 Token endpoint.                                                                            |
| $oidc_userinfo_endpoint | URL of the IdP’s UserInfo endpoint.                                                                                   |
| $oidc_host              | URL of the IdP’s application.<br>For example, `https://{my-app}.okta.com`.                                            |
| $oidc_scopes            | List of the OAuth 2.0 scope values that this server supports. <br> For example, `openid+profile+email+offline_access` |

{{< /bootstrap-table >}}


</details>

<details closed>
<summary>Custom Configuration for Well-Known Endpoints</summary>


{{< bootstrap-table "table table-striped table-bordered" >}}
<table>
<thead>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
<tr>
<td>Variable<br></td>
<td>Description<br></td>
</tr>
<tr>
<td>$oidc_authz_path_params_enable</td>
<td>

`1`: Enable custom path params when `{arbitrary param-name}` is in the `$oidc_authz_endpoint.`<br>`0`: Disable the setting.

</td>
</tr>
<tr>
<td>$oidc_authz_path_params</td>
<td>Use for when $oidc_authz_path_params_enable is enabled.<br><br>Example:<br>

``` yaml
map $host $oidc_authz_endpoint {
    default "https://{my-app}.okta.com/oauth2/{version}/authorize";
}
map $host $oidc_authz_path_params {
    default '{ "my-app": "{my-app}", "version": "v1" }';
}
```

</td>
</tr>
<tr>
<td>$oidc_authz_query_params_enable</td>
<td>

`1`: Enable additional query params when the `$oidc_authz_endpoint` needs them.<br>`0`: Disable the setting.

</td>
</tr>
<tr>
<td>$oidc_authz_query_params</td>
<td>Use for when $oidc_authz_query_params_enable is enabled.<br><br>Example:<br>

```yaml
 map $host $oidc_authz_query_params {
 default '{
     "response_type": "code",
     "scope"        : "$oidc_scopes",
     "client_id"    : "$oidc_client",
     "redirect_uri" : "$redirect_base$redir_location",
     "nonce"        : "$nonce_hash",
     "state"        : 0
 }';
 ```

</td>
</tr>
<tr>
<td>$oidc_logout_path_params_enable</td>
<td>

`1`: Enable custom path params when {arbitrary param-name} is in the $oidc_logout_endpoint.<br>`0`: Disable the setting.

</td>
</tr>
<tr>
<td>$oidc_logout_path_params</td>
<td>Use for when $oidc_logout_path_params_enable is enabled.<br><br>Example:<br>

```yaml
map $host $oidc_logout_endpoint {
    default "https://{my-app}.okta.com/oauth2/{version}/logout";
}
map $host $oidc_authz_path_params {
    default '{ "my-app": "{my-app}", "version": "v1" }';
}
```

</td>
</tr>
<tr>
<td>$oidc_logout_query_params_enable</td>
<td>

`1`: Enable additional query params when the IdP doesn’t support OIDC RP-initiated logout.<br>`0`: OIDC RP-initiated logout.

</td>
</tr>
<tr>
<td>$oidc_logout_query_params</td>
<td>Use for when $oidc_logout_query_params_enable is enabled.<br><br>Example:<br>

```yaml
 map $host $oidc_logout_query_params {
    # example 1. AWS Cognito Logout & prompt a user to sign in as another user.
    default '{
        "response_type": "code",
        "client_id"    : "$oidc_client",
        "redirect_uri" : "$redirect_base$redir_location",
        "state"        : "STATE",
        "scope"        : "$oidc_scopes"
    }';

    # example 2. AWS Cognito Logout & redirect back to client.
    default '{
        "client_id"    : "$oidc_client",
        "logout_uri"   : "$redirect_base/_logout"
    }';
```

</td>
</tr>
<tr>
<td>$oidc_token_path_params_enable</td>
<td>

`1`: Enable custom path params when {arbitrary param-name} is in the $oidc_token_endpoint.<br>`0`: Disable the setting.

</td>
</tr>
<tr>
<td>$oidc_token_path_params</td>
<td>Use for when $oidc_token_path_params_enable is enabled.<br><br>Example:<br>

```yaml
map $host $oidc_token_endpoint {
    default "https://{my-app}.okta.com/oauth2/{version}/token";
}
map $host $oidc_authz_path_params {
    default '{ "my-app": "{my-app}", "version": "v1" }';
}
```

</td>
</tr>
<tr>
<td>$oidc_token_query_params_enable</td>
<td>

`1`: Enable additional query params when the $oidc_token_endpoint needs them.<br>`0`: Disable the setting.

</td>
</tr>
<tr>
<td>$oidc_token_query_params</td>
<td>Use for when $oidc_token_query_params_enable is enabled.<br><br>Example:<br>

```yaml
map $host $oidc_token_query_params {
    default '{ "example": "data" }';
}
```

</td>
</tr>
</tbody>
</table>
{{< /bootstrap-table >}}


</details>

<details closed>
<summary>Advanced Configuration Options</summary>


{{< bootstrap-table "table table-striped table-bordered" >}}

| Variable              | Description                                                                                                                                                                                                                                                                                                                                           |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| $oidc_client          | IdP’s client ID, which is a public identifier for the client that is required for all OAuth flows.                                                                                                                                                                                                                                                    |
| $oidc_client_secret   | IdP’s client secret, which is used by the client to exchange an authorization code for a token. This should be an empty value with `""` when PKCE is enabled.                                                                                                                                                                                         |
| $oidc_hmac_key        | [HMAC (Keyed-Hash Message Authentication Code)](https://datatracker.ietf.org/doc/html/rfc2104.html) is a cryptographic technique that combines a hash function with a secret key to verify the integrity and authenticity of a message or data. The HMAC should be unique for every NGINX instance and cluster.                                                                                             |
| $oidc_logout_redirect | URI to be redirected to after successfully logging out from the IdP. This should be configured in your IdP.                                                                                                                                                                                                                                           |
| $oidc_pkce_enable     | [PKCE (Proof Key for Code Exchange)](https://datatracker.ietf.org/doc/html/rfc7636) is a security extension for OAuth 2.0 that provides additional protection for public clients, such as mobile devices or single-page apps. Its purpose is to prevent a malicious program from intercepting the authorization code during the authorization process.<br><br> `1`: Enable PKCE <br> `0`: Disable PKCE |
| $oidc_app_name        | IdP’s application name.                                                                                                                                                                                                                                                                                                                               |

{{< /bootstrap-table >}}


</details>

## Set Up Specific IdPs for OIDC {#oidc-specific-idps}

Select from the following options to set up OIDC for a specific identity provider:

- [Set up Microsoft Entra as an OIDC identity provider]({{< relref "/nms/admin-guides/authentication/oidc/oidc-entra.md" >}})
- [Set up Keycloak as an OIDC Identity Provider]({{< relref "/nms/admin-guides/authentication/oidc/oidc-keycloak.md" >}})
