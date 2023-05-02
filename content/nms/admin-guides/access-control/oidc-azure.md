---
title: "Set up OIDC Authentication with Azure AD"
date: 2021-12-21T12:00:00-07:00
draft: false
description: "This guide explains how to configure OpenID Connect (OIDC) with Azure Active Directory as the identity provider."
# Assign weights in increments of 100
weight: 400
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
docs: "DOCS-795"
aliases:
- /nginx-instance-manager/admin-guide/oidc-azure/
---

{{< shortversions "2.1.0" "latest" "nimvers" >}}

## Overview

Complete the steps in this guide to secure Instance Manager with OpenID Connect (OIDC) using Azure Active Directory (AD) as the identity provider. As an administrator, when you integrate OpenID authentication with Instance Manager, you can use role-based access control (RBAC) to limit user access to NGINX instances.

There are five steps to configuring Instance Manager to use OIDC and Azure Active Directory:

1. Add users, including their email addresses, to Azure Active Directory.
2. Add groups and assign user membership in Azure Active Directory.
3. Create an Application Registration for the NGINX Management Suite.
4. Add groups to Instance Manager, using the same Azure Active Directory group names configured in step 2.
5. Configure NGINX Plus in Instance Manager to use Azure Active Directory as the designated identity provider.

---

## Before You Begin

To complete the instructions in this guide, you'll need to perform the following tasks:

- Create an [Azure Active Directory developer account](https://azure.microsoft.com/en-us/free/).
- [Install Instance Manager]({{< relref "/admin-guides/installation/on-prem/install-guide.md" >}}) on [NGINX Plus R25 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).
- Install the [NGINX JavaScript module](https://www.nginx.com/blog/introduction-nginscript/) (njs). This module is required for handling interactions between NGINX Plus and the identity provider.  

---

## Set up Azure Active Directory {#configure-azure-ad}

To set up Azure Active Directory as the identity provider, take the following steps:

{{< note >}}The steps to configure Azure Active Directory require a premium account. If you have a free or standard account, you'll need to [upgrade](https://azure.microsoft.com/en-us/pricing/details/active-directory/).{{< /note >}}

### Register an Application

1. If you don't already use Azure, [create an account](https://azure.microsoft.com/en-us/free/).
1. Log in to the [Azure portal](https://portal.azure.com/#home).
1. Select **Azure Active Directory** from the list of Azure services.
1. On the left navigation menu, in the **Manage** section, select **App registrations**.
1. Select **New registration**.
1. Complete the following:

   - In the **Name** box, type the name of the application. For example, "Instance Manager".
   - In the list of account types, select **Account in this organizational directory only**.
   - In the **Redirect URI** section, select **Web** and then type the redirect URI. For example, `https://<my-nginx-instance-manager>/_codexch`.

   {{< img src="/security/oidc/azure-register-app.png" alt="Azure: register an application." width="600" height="415" >}}</br>

1. Select **Register**.
1. On the confirmation page, make a note of the following information. You'll need to provide this information later to complete the setup.

   - Application (client) ID
   - Directory (tenant) ID

### Create Client Secret

1. On the left navigation menu, in the **Manage** section, select **Certificates & secrets**.
1. Select **New client secret**.
1. In the **Description** box, type a description for the client secret.
1. Select **Add**. The client secret is added to the list with a secret string value and ID.
1. Copy the **Value** for the client secret.

   {{< important >}}Save the client secret value in a safe location for future reference. Once you leave the page, you won't be able to retrieve this value again.{{< /important >}}

### Add Owners

1. On the left navigation menu, in the **Manage** section, select **Owners**.
1. Select **Add owners**.
1. Search for the user you want to add, then select **Select**. Repeat this step for each user you're adding.

    {{< warning >}}Make sure to add at least one user with administrative privileges. Failure to do so may lock admin users out of Instance Manager. If that happens, revert to Basic Auth to restore access. {{< /warning >}}

---

### Add Group Claim to Token

Azure Active Directory can provide the user's group membership information to the token for authentication and authorization.

1. On the left navigation menu, in the **Manage** section, select **Token configuration**.
1. Select **Add groups claim**.
1. Select **Groups assigned to the application**.
1. Select **Add**.

	{{< important >}}The only supported group claim format for groups created in Azure Active Directory are Azure AD group ObjectId.{{< /important >}}

### Assign Group to Application

By assigning a group to the application you can grant all members of that group the same access to the NMS application.

1. On the left navigation menu, in the **Manage** section, select **Overview**.
1. In the **Essentials** section, select the link to the right of **Managed application in local directory**.
1. In the **Getting Started** section, select the **Assign users and groups**.
1. Select **Add user/group**
1. On the **Add Assignment** form, in the **Users and groups** section, select **None Selected**.
1. On the **Users and groups** drawer, in the **Search** box, type the name of the group you want to associate with the application.
1. Select the group from the list of names, and select **Select**.
1. Select **Assign**.

## Create User Groups in Instance Manager

Create user groups in Instance Manager using the same group names you created in Azure Active directory.

1. Log in to Instance Manager as `admin` using a Basic Auth account.
1. Select the **Settings** gear icon.
1. In the **Settings** menu, select **User Groups**.
1. Select **Create**.
1. On the **Create Group** form, in the **Group Name** box, type the Object ID of the group with associated users you created in Azure Active Directory.
1. In the **Display Name** box, type the group name.
1. Select **Save**.
1. Repeat steps 5–6 until you've recreated all the groups you want to provide access for.


</br>

---

## Set Up NGINX Plus to Interact with the Identity Provider

Configure NGINX Plus to use Azure Active Directory as the identity provider.

1. Run the following command for your distribution to install the NGINX JavaScript module (njs), which is required to handle the interaction between NGINX Plus and the identity provider.

   {{<tabs name="install_njs">}}
    {{%tab name="CentOS, RHEL"%}}

```bash
sudo yum install nginx-plus-module-njs
```

    {{%/tab%}}
    {{%tab name="Debian, Ubuntu"%}}

```bash
sudo apt install nginx-plus-module-njs
```

    {{%/tab%}}
    {{</tabs>}}

1. On the NGINX Management Suite, open the `/etc/nginx/nginx.conf` file for editing and add the following directive to the top-level ("main") section to load the NGINX JavaScript module:

      ```nginx
      load_module modules/ngx_http_js_module.so;
      ```

1. Open the `/etc/nms/nginx/oidc/openid_configuration.conf` file for editing. Using the example `openid_configuration.conf` below as a reference, replace the following variables in the file with the values you saved when [configuring Azure Active Directory](#configure-azure-ad).

   - `{tenant_key}`: The Directory (tenant) ID (see [Register an Application, Step 8](#register-an-application))
   - `{client_key}`: The Application (client) ID (see [Register an Application, Step 8](#configure-azure-ad))
   - `{client_secret}`: The encoded client secret (see [Create Client Secret, Step 5](#create-client-secret))

    <br>
    <details>
        <summary>example openid_configuration.conf</summary>

    ``` yaml
    # NGINX Management Suite - OpenID Connect configuration
    # Created for v. 2.0
    # (c) NGINX, Inc. 2021
    #
    # Each map block allows multiple values so that multiple IdPs can be supported,
    # the $host variable is used as the default input parameter but can be changed.
    #
    # Adapted from: https://github.com/nginxinc/nginx-openid-connect/blob/main/openid_connect_configuration.conf
    #
    # NOTE: This requires NGINX Plus with the NJS module installed and enabled
    # NOTE: The entries below need to be updated with values relevant to your environment and IdP
    #
    #       SERVER_FQDN is the Fully Qualified Domain Name of this server, e.g., nms.example.com
    #
    #       For more information about configuration and troubleshooting OIDC,
    #       refer to the reference repository at https://github.com/nginxinc/nginx-openid-connect

    map $host $oidc_authz_endpoint {
        SERVER_FQDN OIDC_AUTH_ENDPOINT;

        #default "http://127.0.0.1:8080/auth/realms/master/protocol/openid-connect/auth";
        default "https://login.microsoftonline.com/{tenant_key}/oauth2/v2.0/authorize";
    }

    map $host $oidc_token_endpoint {
        SERVER_FQDN OIDC_TOKEN_ENDPOINT;

        #default "http://127.0.0.1:8080/auth/realms/master/protocol/openid-connect/token";
        default "https://login.microsoftonline.com/{tenant_key}/oauth2/v2.0/token";
    }

    map $host $oidc_jwt_keyfile {
        SERVER_FQDN OIDC_KEYS_ENDPOINT;

        #default "http://127.0.0.1:8080/auth/realms/master/protocol/openid-connect/certs";
        default "https://login.microsoftonline.com/{tenant_key}/discovery/v2.0/keys";
    }

    map $host $oidc_client {
        SERVER_FQDN OIDC_CLIENT_ID;
        # replace with OIDC specific setting
        default "my-client-id";
    }

    map $host $oidc_pkce_enable {
        default 0;
    }

    map $host $oidc_client_secret {
        SERVER_FQDN OIDC_CLIENT_SECRET;
        # replace with OIDC specific setting
        default "my-not-very-secret-client-secret";
    }

    map $host $oidc_scopes {
        default "openid+profile+email+offline_access";
    }

    map $host $oidc_logout_redirect {
        # Where to send browser after requesting /logout location. This can be
        # replaced with a custom logout page, or complete URL.
        default "/_logout"; # Built-in, simple logout page
    }

    map $host $oidc_hmac_key {
        SERVER_FQDN OIDC_HMAC_KEY;

        # This should be unique for every NGINX instance/cluster
        default "ChangeMe";
    }

    map $proto $oidc_cookie_flags {
        http  "Path=/; SameSite=lax;"; # For HTTP/plaintext testing
        https "Path=/; SameSite=lax; HttpOnly; Secure;"; # Production recommendation
    }

    map $http_x_forwarded_port $redirect_base {
        ""      $proto://$host:$server_port;
        default $proto://$host:$http_x_forwarded_port;
    }

    map $http_x_forwarded_proto $proto {
        ""      $scheme;
        default $http_x_forwarded_proto;
    }

    # ADVANCED CONFIGURATION BELOW THIS LINE
    # Additional advanced configuration (server context) in openid_connect.conf

    # JWK Set will be fetched from $oidc_jwks_uri and cached here - ensure writable by nginx user
    proxy_cache_path /var/cache/nginx/jwk levels=1 keys_zone=jwk:64k max_size=1m;

    # Change timeout values to at least the validity period of each token type
    keyval_zone zone=oidc_id_tokens:1M state=/var/run/nms/nginx_oidc_id_tokens.json timeout=1h;
    keyval_zone zone=refresh_tokens:1M state=/var/run/nms/nginx_refresh_tokens.json timeout=8h;
    keyval_zone zone=oidc_pkce:128K timeout=90s; # Temporary storage for PKCE code verifier.

    keyval $cookie_auth_token $session_jwt zone=oidc_id_tokens;   # Exchange cookie for JWT
    keyval $cookie_auth_token $refresh_token zone=refresh_tokens; # Exchange cookie for refresh token
    keyval $request_id $new_session zone=oidc_id_tokens; # For initial session creation
    keyval $request_id $new_refresh zone=refresh_tokens; # ''
    keyval $pkce_id $pkce_code_verifier zone=oidc_pkce;

    auth_jwt_claim_set $jwt_claim_groups groups; # For optional claim groups
    auth_jwt_claim_set $jwt_claim_sub sub; # Subject unique identifier
    auth_jwt_claim_set $jwt_audience aud; # In case aud is an array
    js_import oidc from /etc/nms/nginx/oidc/openid_connect.js;

    # vim: syntax=nginx

    ```

    </details>
    <br/>

1. Open the `/etc/nginx/conf.d/nms-http.conf` file for editing. Using the example `nms-http.conf` below as a reference, uncomment each of the `OIDC` settings and comment out the settings for `Basic Auth`.

    <br>
    <details>
        <summary>example nms-http.conf</summary>

    ``` yaml
    # NGINX Management Suite - Instance Manager configuration
    # Created for v. 2.0
    # (c) NGINX, Inc. 2021

    # If you choose to modify this file, create a backup of your changes.
    # This configuration file at its default location might be replaced by the
    # package management during upgrades

    # NOTE: enabling OIDC authentication requires using NGINX Plus
    #       with NJS installed and the module loaded in the config

   # Enable when using OIDC
   log_format oidc_jwt '$remote_addr - $jwt_claim_sub [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" "$http_user_agent" '
                       '"$http_x_forwarded_for"';
   
    # Main routing logic
    map $uri $mapped_upstream {
        "~^/api/platform/v1/analytics"          core-api-service;
        "~^/api/platform/v1/license"            core-api-service;
        "~^/api/platform/v1/roles"              core-api-service;
        "~^/api/platform/v1/userinfo"           core-api-service;
        "~^/api/platform/v1/users"              core-api-service;

        "~^/api/platform/v1/analysis"           dpm-api-service;
        "~^/api/platform/v1/certs"              dpm-api-service;
        "~^/api/platform/v1/configs"            dpm-api-service;
        "~^/api/platform/v1/instance-groups"    dpm-api-service;
        "~^/api/platform/v1/instances"          dpm-api-service;
        "~^/api/platform/v1/servers"            dpm-api-service;
        "~^/api/platform/v1/systems"            dpm-api-service;

        default                                 core-api-service;
    }

    # REST to core services
    upstream core-api-service {
        zone core-api-service 64k;

        # Unix socket by default, optional TCP needs configuration in /etc/nms/nms.conf
        server unix:/var/run/nms/core.sock;
        #server 127.0.0.1:8033;

        keepalive 32;
    }

    # REST to DPM services
    upstream dpm-api-service {
        zone dpm-api-service 64k;

        # Unix socket by default, optional TCP needs configuration in /etc/nms/nms.conf
        server unix:/var/run/nms/dpm.sock;
        #server 127.0.0.1:8034;

        keepalive 32;
    }

    # gRPC to ingestion services
    upstream ingestion-grpc-service {
        zone ingestion-grpc-service 64k;

        # Unix socket by default, optional TCP needs configuration in /etc/nms/nms.conf
        server unix:/var/run/nms/ingestion.sock;
        #server 127.0.0.1:8035;

        keepalive 32;
    }

    # gRPC to DPM services
    upstream dpm-grpc-service {
        zone dpm-grpc-service 64k;

        # Unix socket by default, optional TCP needs configuration in /etc/nms/nms.conf
        server unix:/var/run/nms/am.sock;
        #server 127.0.0.1:8036;

        keepalive 32;
    }

    # WebSocket config, comment out if this section is duplicate via other config files
    map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
    }

    # shared rate limiting memory zone definitions
    limit_req_zone $binary_remote_addr zone=nms-ratelimit:10m rate=20r/s;
    limit_req_zone $binary_remote_addr zone=nms-strict-ratelimit:10m rate=1r/s;

    # Additional upstreams provided by other modules
    include /etc/nms/nginx/upstreams/*.conf;

    # OIDC -- client configuration uncomment include to enable
    include /etc/nms/nginx/oidc/openid_configuration.conf;

    # Main external HTTPS server, needs port 443
    server {
        listen 443 ssl http2;
        root /var/www/nms;
        server_name _;

        # ssl_protocols       TLSv1.1 TLSv1.2 TLSv1.3; # TODO support for TLSv1.3?
        ssl_protocols       TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;

        ssl_certificate         /etc/nms/certs/manager-server.pem;
        ssl_certificate_key     /etc/nms/certs/manager-server.key;
        ssl_client_certificate  /etc/nms/certs/ca.pem;

        # OIDC Authentication: authorization code flow and Relying Party processing
        # OIDC remove comment from following include statement to enable
        include /etc/nms/nginx/oidc/openid_connect.conf;

        # Enable ONE of the two options according to HTTP Basic or OIDC authentication:
        # HTTP Basic:
        #proxy_set_header Nginx-Controller-User $remote_user;
        # OIDC:
        proxy_set_header Nginx-Controller-User $jwt_claim_unique_name;
        # NOTE: the username is dependent upon claims provided by your IdP

        # Optional OIDC settings: additional debug log
        error_log /var/log/nginx/oidc.log debug; # Reduce severity level as required

        keepalive_timeout       75s;
        client_max_body_size    50M; # Increase in case of large configuration files
        error_page 401 /401.json;
        error_page 403 /403.json;

        include /etc/nms/nginx/errors.http_conf;
        include /etc/nms/nginx/errors-grpc.server_conf;

        # Additional locations provided by other modules
        include /etc/nms/nginx/locations/*.conf;

        add_header X-Frame-Options sameorigin;
        add_header X-Content-Type-Options nosniff;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        proxy_hide_header X-Powered-By;
        proxy_set_header Host $host;
        proxy_ssl_protocols TLSv1.1 TLSv1.2;
        proxy_headers_hash_max_size 512;
        proxy_headers_hash_bucket_size 128;

        ## For use with basic auth
        #auth_basic_user_file /etc/nms/nginx/.htpasswd;

        # For use with basic auth (comment out if using OIDC)
        #proxy_set_header Nginx-Controller-User $remote_user;
        # OIDC auth (uncomment to enable)
        proxy_set_header Nginx-Management-Suite-Auth "OIDC";
        proxy_set_header Nginx-Management-Suite-User $jwt_claim_email;
        proxy_set_header Nginx-Management-Suite-Groups $jwt_claim_groups;
        proxy_set_header Nginx-Management-Suite-ExternalId $jwt_claim_sub;

        # Optional OIDC settings: additional debug log
        #error_log /var/log/nginx/oidc.log debug; # Reduce severity level as required

        proxy_set_header Authorization "";
        server_tokens off;

        # Object and method headers for Role-Based Access Control
        proxy_set_header object $request_uri;
        proxy_set_header http-method $request_method;

        # Redirect from / to /ui/
        location = / {
            absolute_redirect off;
            return 302 "/ui/";
        }

        location /api {
            # HTTP Basic authentication (disable if using OIDC)
            #auth_basic "Nginx Management Suite";
            # OIDC authentication (uncomment to enable)
            auth_jwt "" token=$session_jwt;
            auth_jwt_key_request /_jwks_uri;

            # Disabled proxy_ssl_* directives due to plaintext proxy_pass.
            # Re-enable them in case of advanced, customized multi-server installation.
            # proxy_ssl_trusted_certificate /etc/nms/certs/ca.pem;
            # proxy_ssl_certificate         /etc/nms/certs/manager-client.pem;
            # proxy_ssl_certificate_key     /etc/nms/certs/manager-client.key;
            # proxy_ssl_verify        on;
            # proxy_ssl_name          platform;
            # proxy_ssl_server_name   on;

            # Request limiting. Adjust limit_req_zone directive according to the server load
            limit_req zone=nms-ratelimit burst=10 nodelay;
            limit_req_status 429;

            # Dynamic proxying to the correct service, based on the corresponding map above
            proxy_pass http://$mapped_upstream;
        }

        # NGINX Management Suite modules service endpoint, provides inventory for the UI
        location = /modules {
            proxy_pass http://core-api-service/api/platform/v1/modules;
        }

        # Installation script for NGINX Agent packages
        # NGINX Agent must be installed from this location to support local repository and offline environments
        location = /agent/install {
            return 302 '/install/nginx-agent';
        }

        location = /install/nginx-agent {
            sub_filter_types *;
            sub_filter '"CTR_FQDN"' '"$host"';
            # sub_filter_once on;
        }

        # UI static assets
        location /ui {
            # HTTP Basic authentication (comment if using OIDC auth)
            #auth_basic "Nginx Management Suite";
            # OIDC authentication (uncomment to enable)
            error_page 401 = @do_oidc_flow;
            auth_jwt "" token=$session_jwt;
            auth_jwt_key_request /_jwks_uri;

            gzip_static on;
            add_header Cache-Control "private; max-age=86400";
            try_files $uri $uri/ /ui/index.html;
        }

        # Disabled authentication for UI manifest.json, loader can not provide auth at this time
        # TODO: move the file to /manifest.json URL, then remove this section
        location /ui/manifest.json {
            auth_basic off;
        }

        # gRPC service for metric ingestion
        location /f5.nginx.agent.sdk.MetricsService {
            include /etc/nms/nginx/errors-grpc.loc_conf;
            grpc_socket_keepalive on;
            grpc_read_timeout 5m;
            grpc_send_timeout 5m;
            client_body_timeout 10m;
            grpc_pass grpc://ingestion-grpc-service;
        }

        # gRPC service for DPM
        location /f5.nginx.agent.sdk.Commander {
            include /etc/nms/nginx/errors-grpc.loc_conf;
            grpc_socket_keepalive on;
            grpc_read_timeout 5m;
            grpc_send_timeout 5m;
            client_body_timeout 10m;
            grpc_pass grpc://dpm-grpc-service;
        }
    }
    ```

    </details>
    <br/>

1. Run `sudo nginx -t` to verify the config has no errors.
1. Run `sudo nginx -s reload` to reload and apply the config.

---

## Try It Out

Open Instance Manager by going to `https://<your-nginx-instance-manager>/ui`.

You should be redirected to Azure Active Directory. Log in with your Azure Active Directory email and password.