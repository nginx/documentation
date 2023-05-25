---
categories:
- installation
- security
date: "2021-12-21T12:00:00-07:00"
description: 'Follow the steps in this guide to configure authentication for Instance Manager.'
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
title: Set Up Authentication
toc: true
versions: []
weight: 200
docs: "DOCS-792"
aliases:
- /nginx-instance-manager/admin-guide/authentication/
- /nginx-instance-manager/admin-guides/access-control/configure-authentication/
- /nim/admin-guide/authentication/

---

{{<custom-styles>}}

{{< shortversions "2.0.0" "latest" "nimvers" >}}

<!-- Editor's Note: This guide should be combined with the add-users doc into a guide for User Management. -->


{{<note>}}
NGINX Plus is provided and intended only to be used with Instance Manager as a frontend. You should not use NGINX Plus for other web applications or instances. Contact your sales team to purchase additional subscriptions for external uses and other systems.
{{</note>}}

## Prerequisites {#prerequisites}

1. Install [NGINX Management Suite]({{<relref "/nms/installation/vm-bare-metal/_index.md">}}).
2. Install [NGINX or NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/).
3. Start and Enable Instance Manager and NGINX Plus (or NGINX).

{{%heading "authentication"%}}

---

## Authentication Options {#auth-options}

The following table shows the authentication options for Instance Manager on NGINX Open Source and NGINX Plus.

**Table: Authentication options**

{{<bootstrap-table "table table-striped table-bordered">}}
| Security Method                     | NGINX OSS | NGINX Plus |
| ----------------------------------- | --------- | ---------- |
| Commercial Support                  | Included  | Included   |
| Denylisting IPs                     | N/A       | Supported  |
| [Basic Authentication](#basic-auth) | Included  | Included   |
| [JWT Authentication](#jwt-auth)     | N/A       | Included   |
| [OpenID Connect/OAuth2](#oidc-auth) | N/A       | Supported  |
| [Rate-Limiting](#rate-limiting)     | Included  | Included   |
| [Role Based Access Control](#rbac)  | N/A       | Supported  |
{{</bootstrap-table>}}

---

## Basic Authentication {#basic-auth}

{{< warning >}}Basic authentication is not considered secure and should not be used in production environments. Instead, we recommend using [OpenID Connect (OIDC)](#oidc-auth) or another secure authentication method for production purposes.{{< /warning >}}

By default, NGINX Management Suite has basic authentication enabled. During the installation process, a default username called `admin` is created with a randomly generated password, which is displayed in the installation output. To change the default password for the `admin` user, you can use the `basic_passwords.sh script` provided with NGINX Management Suite; refer to [the steps below](#change-basic-password).

Initially, only the `admin` user has a role assigned. To grant access to additional users in NGINX Management Suite, you need to add them and assign appropriate roles.


### Create New Users {#create-users}

{{< include "admin-guides/access-control/add-users.md" >}}

### Set or Change User Passwords {#change-basic-password}

You can use the `basic_passwords.sh` script to add a user's encrypted password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Management Suite server. 

{{<note>}}The `basic_passwords.sh` script requires the OpenSSL package. We strongly recommend OpenSSL version 1.1.1 or later.{{</note>}}

The steps are as follows:

1. Open an SSH connection to your NGINX Management Suite host and log in.
2. Run the `basic_passwords.sh` script, providing the username you want to update and the desired password. Make sure to enclose the password in single quotation marks.

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh <username> '<desired password>'
    ```

    For example:

    ```bash
    sudo bash /etc/nms/scripts/basic_passwords.sh johndoe 'jelly22fi$h'
    ```

---

## JWT Authentication {#jwt-auth}

You can use JSON Web Token (JWT) Authentication with NGINX Plus and Instance Manager. You need to create the JWT or use an identity provider (idP) to generate the JWT. For more examples, refer to the NGINX documentation [Setting up JWT Authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-jwt-authentication/).

Below is an example NGINX conf for using JWT.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-jwt.conf</summary>

{{<fa "download">}} {{<link "/getting-started/auth/nginx-manager-jwt.conf" "nginx-manager-jwt.conf">}}

```yaml {hl_lines=["7-11","15-17","44-46","48-50",52,"59-62",64]}
# nginx-manager-jwt.conf
# Proxy API with JWT to 127.0.0.1 on nginx-manager
# Include the nginx-manager-upstreams.conf for the proxy_pass to work
# Ensure you have permissions set in the directories
# More information is available <https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-jwt-authentication/>

map $jwt_claim_sub $jwt_status {
    "quotes" "revoked";
    "test"   "revoked";
    default  "";
}

limit_req_zone $jwt_claim_sub zone=10rps_per_client:1m rate=10r/s;

log_format jwt '$remote_addr - $remote_user [$time_local] "$request" '
               '$status $body_bytes_sent "$http_referer" "$http_user_agent" '
               '$jwt_header_alg $jwt_claim_uid $jwt_claim_url' ;

# reverse proxy with JWT authentication
#
server {
    listen      443 http2 ssl;
    status_zone nginx-manager_oauth_https;
    server_name nginx-manager.example.com;

    # Optional log locations
    # error_log /var/log/nginx/nginx-manager-jwt-error.log debug; # Reduce severity level as required   

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/nms/certs/manager-server.crt;
    ssl_certificate_key         /etc/nms/certs/manager-server.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;
    
    # Could change to /api for multiple methods of auth
    location / {
        # JWT validation
        auth_jwt "JWT Test Realm" token=$arg_myjwt;    # Change to realm you use or "" for no realm
        auth_jwt_key_file /etc/nginx/api_secret.jwk;

        if ( $jwt_status = "revoked" ) {
            return 403;
        }

        limit_req zone=10rps_per_client;

        proxy_pass http://nginx-manager_servers;
        health_check uri=/swagger-ui/;

        # Successfully authenticated users are proxied to the backend,
        # with 'sub' claim passed as HTTP header
        proxy_set_header Nginx-Management-Suite-User $jwt_claim_sub;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;

        access_log /var/log/nginx/nginx-manager-jwt-access.log jwt;
    }

}

# vim: syntax=nginx
```

</details>

---

## OpenID Connect {#oidc-auth}

You can enable OpenID Connect (OIDC) for Instance Manager for production environments that require secure authentication.

{{< warning >}}Before switching from Basic Auth to OIDC, make sure to add at least one admin user to your identity provider. A failure to do so may lock admin users out of Instance Manager when you enable OIDC. If that happens, you can revert to Basic Auth to restore access. {{< /warning >}}

{{< see-also >}} Follow the steps in [Configure OIDC with Azure Active Directory]({{< relref "/nms/admin-guides/access-control/oidc-azure.md" >}}) to secure Instance Manager with OpenID Connect (OIDC) using Azure Active Directory (AD) as the identity provider. {{< /see-also >}}

### Prerequisites

To use OIDC with Instance Manager, you need to perform the following:

- [Install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) on [NGINX Plus R21 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/). The server hosting NGINX Plus must have a FQDN (Fully Qualified Domain Name).

- Install the [NGINX JavaScript module](https://www.nginx.com/blog/introduction-nginscript/) (njs). This module is required for handling interactions between NGINX Plus and the identity provider.

- Configure an Identity Provider (IdP) for authentication services.

### Enable OIDC

The OIDC configuration file (`openid_configuration.conf`) includes placeholder default values in `map` blocks that need to be updated for OIDC to work.

1. Open the OIDC configuration file `/etc/nms/nginx/oidc/openid_configuration.conf` for editing and update the placeholder values with the information for your identity provider (See variable 
   descriptions below). Save the changes.

2. Open the NGINX Management Suite configuration file `/etc/nginx/conf.d/nms-http.conf` for editing and uncomment the `OIDC` settings beginning with `#OIDC` and comment out the settings for `Basic 
   Auth`. Save the changes.

3. If you are running additional modules, such as API Connectivity Manager, you will need to modify module-specific configuration files.

    - Open the API Connectivity Manager configuration file `/etc/nms/nginx/locations/nms-acm.conf` for editing, uncomment the `OIDC` settings beginning with `#OIDC`, and comment out the settings for `Basic Auth`. Save the changes.

4. Run `sudo nginx -t` to verify the config has no errors.

5. Run `sudo nginx -s reload` to reload and apply the config.

The following information is needed to configure the service:

**Table: OIDC Metadata via Well-Known Endpoints**

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable                           | Description                                                                                                           |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| `$oidc_authz_endpoint`             | URL of the IdP's OAuth 2.0 Authorization endpoint.                                                                    |
| `$oidc_jwt_keyfile`                | URL of the IdP's JSON Web Key Set document.                                                                           |
| `$oidc_logout_endpoint`            | URL of the IdP's end_session endpoint.                                                                                |
| `$oidc_token_endpoint`             | URL of the IdP's OAuth 2.0 Token endpoint.                                                                            |
| `$oidc_userinfo_endpoint`          | URL of the IdP's UserInfo endpoint.                                                                                   |
| `$oidc_host`                       | URL of the IdP's application. For example, `https://{my-app}.okta.com`                                                |
| `$oidc_scopes`                     | List of the OAuth 2.0 scope values that this server supports. <br> For example, `openid+profile+email+offline_access` |
{{< /bootstrap-table >}}

**Table: OIDC Custom Configuration for Well-Known Endpoints**

{{% table %}}

| Variable                           | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `$oidc_authz_path_params_enable`   | `1`: Enable custom path params when `{arbitrary param-name}` is in the `$oidc_authz_endpoint`. <br> `0`: Disable it.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `$oidc_authz_path_params`          | Use for when `$oidc_authz_path_params_enable` is enabled. <br><br> **Example:** <br><pre>map $host $oidc_authz_endpoint { <br>    default "https://{my-app}.okta.com/oauth2/{version}/authorize"; <br>} <br>map $host $oidc_authz_path_params { <br>    default '{ "my-app": "{my-app}", "version": "v1" }'; <br>}</pre>                                                                                                                                                                                                                                                                                                                                                     |
| `$oidc_authz_query_params_enable`  | `1`: Enable additional query params when the `$oidc_authz_endpoint` needs them. <br> `0`: Disable it.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `$oidc_authz_query_params`         | Use for when `$oidc_authz_query_params_enable` is enabled. <br><br> **Example:** <br><pre> map $host $oidc_authz_query_params { <br> default '{ <br>     "response_type": "code", <br>     "scope"        : "$oidc_scopes", <br>     "client_id"    : "$oidc_client", <br>     "redirect_uri" : "$redirect_base$redir_location", <br>     "nonce"        : "$nonce_hash", <br>     "state"        : 0 <br> }'; <br>                                                                                                                                                                                                                                                          |
| `$oidc_logout_path_params_enable`  | `1`: Enable custom path params when `{arbitrary param-name}` is in the `$oidc_logout_endpoint`. <br> `0`: Disable it.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `$oidc_logout_path_params`         | Use for when `$oidc_logout_path_params_enable` is enabled. <br><br> **Example:** <br><pre>map $host $oidc_logout_endpoint { <br>    default "https://{my-app}.okta.com/oauth2/{version}/logout"; <br>} <br>map $host $oidc_authz_path_params { <br>    default '{ "my-app": "{my-app}", "version": "v1" }'; <br>}</pre>                                                                                                                                                                                                                                                                                                                                                      |
| `$oidc_logout_query_params_enable` | `1`: Enable additional query params when the IdP doesn't support [OIDC RP-initiated logout](https://openid.net/specs/openid-connect-rpinitiated-1_0.html#RPLogout). <br> `0`: [OIDC RP-initiated logout](https://openid.net/specs/openid-connect-rpinitiated-1_0.html#RPLogout).                                                                                                                                                                                                                                                                                                                                                                                             |
| `$oidc_logout_query_params`        | Use for when `$oidc_logout_query_params_enable` is enabled. <br><br>**Example:**<pre> map $host $oidc_logout_query_params {<br>    # example 1. AWS Cognito Logout & prompt a user to sign in as another user.<br>    default '{<br>        "response_type": "code",<br>        "client_id"    : "$oidc_client",<br>        "redirect_uri" : "$redirect_base$redir_location",<br>        "state"        : "STATE",<br>        "scope"        : "$oidc_scopes"<br>    }';<br><br>    # example 2. AWS Cognito Logout & redirect back to client. <br>    default '{<br>        "client_id"    : "$oidc_client",<br>        "logout_uri"   : "$redirect_base/_logout"<br>    }';</pre><br> |
| `$oidc_token_path_params_enable`   | `1`: Enable custom path params when `{arbitrary param-name}` is in the `$oidc_token_endpoint`. <br> `0`: Disable it.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `$oidc_token_path_params`          | Use for when `$oidc_token_path_params_enable` is enabled. <br><br> **Example:** <br><pre>map $host $oidc_token_endpoint { <br>    default "https://{my-app}.okta.com/oauth2/{version}/token"; <br>} <br>map $host $oidc_authz_path_params { <br>    default '{ "my-app": "{my-app}", "version": "v1" }'; <br>}</pre>                                                                                                                                                                                                                                                                                                                                                                 |
| `$oidc_token_query_params_enable`  | `1`: Enable additional query params when the `$oidc_token_endpoint` needs them. <br> `0`: Disable it.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `$oidc_token_query_params`         | Use for when `$oidc_token_query_params_enable` is enabled. <br><br> **Example:** <br><pre>map $host $oidc_token_query_params { <br>    default '{ "example": "data" }'; <br>}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |

{{% /table %}}

**Table: OIDC Advanced Configuration**

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable                           | Description                                                                                                                                                                                                                                                         |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `$oidc_client`                     | IdP's client ID which is a public identifier for the client that is required for all OAuth flows.                                                                                                                                                                   |
| `$oidc_client_secret`              | IdP's client secret which is used by the client to exchange an authorization code for a token. <br> It should be an empty value with `""` when PKCE is enabled.                                                                                                     |
| `$oidc_hmac_key`                   | Hash-based Message Authentication Code (or HMAC) is a cryptographic technique that combines public keys, private keys, and a hash into a mix hackers can't unpack. <br> It should be unique for every NGINX instance/cluster.                                       |
| `$oidc_logout_redirect`            | URI to be redirected by the IdP after successful logout from the IdP. <br> This should be configured in your IdP.                                                                                                                                                   |
| `$oidc_pkce_enable`                | PKCE is an OAuth 2.0 security extension for public clients on mobile devices or single page apps intended to avoid a malicious programme creeping into the same computer from intercepting the authorization code. <br><br> `1`: Enable PKCE <br> `0`: Disable PKCE |
| `$oidc_app_name`                   | IdP's application name.                                                                                                                                                                                                                                             |

{{< /bootstrap-table >}}

---

## gRPC Metadata {#grpc-metadata}

You can use advanced NGINX Plus features such as [JWT and gRPC](https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-3-publishing-grpc-services/#Authenticating-Clients-with-gRPC-Metadata) by following the guides on the NGINX blog. Use the [encryption guide]({{< relref "/nms/admin-guides/configuration/secure-traffic.md" >}}) for setting up gRPC on Instance Manager.

---

## Rate-Limiting {#rate-limiting}

Enabling rate-limiting can help mitigate and prevent DDoS attacks and should be enabled for the API and web interface listeners.  Using a configuration file similar to the one below can be leveraged with other authentication and encryption methods.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-jwt.conf</summary>

{{<fa "download">}} {{<link "/getting-started/auth/nginx-manager-jwt.conf" "nginx-manager-jwt.conf">}}

```yaml {hl_lines=[13,52]}
# nginx-manager-jwt.conf
# Proxy API with JWT to 127.0.0.1 on nginx-manager
# Include the nginx-manager-upstreams.conf for the proxy_pass to work
# Ensure you have permissions set in the directories
# More information is available <https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-jwt-authentication/>

map $jwt_claim_sub $jwt_status {
    "quotes" "revoked";
    "test"   "revoked";
    default  "";
}

limit_req_zone $jwt_claim_sub zone=10rps_per_client:1m rate=10r/s;

log_format jwt '$remote_addr - $remote_user [$time_local] "$request" '
               '$status $body_bytes_sent "$http_referer" "$http_user_agent" '
               '$jwt_header_alg $jwt_claim_uid $jwt_claim_url' ;

# reverse proxy with jwt authentication
#
server {
    listen      443 http2 ssl;
    status_zone nginx-manager_oauth_https;
    server_name nginx-manager.example.com;

    # Optional log locations
    # error_log /var/log/nginx/nginx-manager-jwt-error.log debug; # Reduce severity level as required   

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/nms/certs/manager-server.crt;
    ssl_certificate_key         /etc/nms/certs/manager-server.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;
    
    # Could change to /api for multiple methods of auth
    location / {
        # JWT validation
        auth_jwt "JWT Test Realm" token=$arg_myjwt;    # Change to realm you use or "" for no realm
        auth_jwt_key_file /etc/nginx/api_secret.jwk;

        if ( $jwt_status = "revoked" ) {
            return 403;
        }

        limit_req zone=10rps_per_client;

        proxy_pass http://nginx-manager_servers;
        health_check uri=/swagger-ui/;

        # Successfully authenticated users are proxied to the backend,
        # with 'sub' claim passed as HTTP header
        proxy_set_header Nginx-Management-Suite-User $jwt_claim_sub;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;

        access_log /var/log/nginx/nginx-manager-jwt-access.log jwt;
    }

}

# vim: syntax=nginx
```

</details>

---

## Role-Based Access Control {#rbac}

For instruction on how to limit access to features using role-based access control, see the [Set Up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac" >}}) tutorial.

---

## What's Next

- [Add Users]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md#add-users" >}})
- [Set up Azure Active Directory as an OIDC Identity Provider]({{< relref "/nms/admin-guides/access-control/oidc-azure" >}})
- [Set Up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac" >}})
