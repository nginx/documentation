---
title: "Authentication"
date: 2020-12-27T20:56:49-07:00
draft: false
description: "An NGINX Instance Manager authentication document."
# Assign weights in increments of 100
weight: 500
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "security"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
docs: "DOCS-624"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

<style>table, th, td {  border: 1px solid #CCC;  border-collapse: collapse;}th, td {  padding: 6px;}th {  text-align: center;}</style>

{{%heading "overview"%}}

This document helps you get NGINX Instance Manager secured by utilizing authentication.

{{<note>}}
NGINX Plus is provided and intended only to be used with NGINX Instance Manager as a frontend. You should not use NGINX Plus for other web applications or instances. For external uses and other systems, contact your sales team to purchase additional subscriptions.
{{</note>}}

## Prerequisites {#prerequisites}

1. Install [NGINX Instance Manager Server]({{<relref "install.md#install-server">}}).
2. Install [NGINX or NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/).
3. Start and Enable Instance Manager and NGINX Plus (or NGINX).

{{%heading "authentication"%}}

## Authentication Options {#auth-options}

The table below summarizes the key differences between NGINX Open Source and NGINX Plus (for authentication options with NGINX Instance Manager).

| Security Method | nginx-oss | nginx-plus |
|--|--|--|
| [Audit Log](#audit-log) | Included | Included |
| Commercial Support | Included | Included |
| [Basic Authentication](#basic-auth) | Included | Included |
| [JWT Authentication](#jwt-auth) | N/A | Included |
| [OpenID Connect/OAuth2](#oidc-auth) | N/A | Supported |
| Denylisting IPs | N/A | Supported |
| [Rate-Limiting](#rate-limiting) | Included | Included |
| [Role Based Access Control](#rbac) | N/A | Supported |

## Common NGINX Snippets {#common}

### Audit Log {#audit-log}

Instance Manager listens on two ports. The gRPC communication listens only on `127.0.0.1` and is on `10000` by default. The browser interface and API listen on `127.0.0.1` and is `11000` by default. By using NGINX we follow our own guidance for any web application. You may use NGINX Open Source ("NGINX OSS") or NGINX Plus for the forward proxy. We provide an instance of NGINX Plus with NGINX Instance Manager. You can use it to proxy and secure NGINX Instance Manager.

We use the username and role headers to log to the audit log. You can configure the audit log by adding the option on the nginx-manager.conf file.

Note: Adding the audit log option will log every API call made to the API. It is recommended not to add this entry if you are not using the auditing log feature.

<details>
    <summary>/etc/nginx-manager/nginx-manager.conf</summary>

{{<fa "download">}} {{<link "/nim/previous-versions/static/previous-versions/v1/getting-started/auth/audit/nginx-manager.conf" "nginx-manager.conf">}}

```yaml {hl_lines=[36]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager

# bind address for all service ports (default "127.0.0.1")
bind_address: 127.0.0.1
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL server name for use with cert and key below (optional)
# server_name: nginx-manager.example.com
# path to x.509 certificate file (optional)
# cert: /etc/ssl/nginx-manager/nginx-manager.crt
# path to x.509 certificate key file (optional)
# key: /etc/ssl/nginx-manager/nginx-manager.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/

# Path to license file
license: /etc/nginx-manager/nginx-manager.lic

# rbac enables enforcement of roles and users (nginx proxy required, ensure you have an admin account working before enabling)
# rbac: true

# Audit Log will log ALL api calls with username header (default: not defined)
audit_log: /var/log/nginx-manager/audit.log

# vim: syntax=nginx
```

</details><br/>

### Upstreams {#common-upstreams}

The examples below make reference to an upstream group nginx-manager_servers. You can create the same with a conf file similar to the one below.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-upstreams.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-upstreams.conf" "nginx-manager-upstreams.conf">}}

```nginx
# nginx-manager-upstreams.conf
# Upstreams for NGINX Instance Manager Server API/UI

upstream nginx-manager_servers {
        zone nginx-manager_servers 64k;
        server 127.0.0.1:11000;
        keepalive 64;
}

# vim: syntax=nginx
```

</details><br/>

### Status Page {#common-status}

NGINX Plus uses a status page. The following example shows a default configuration on port `8080`. Adjust the port to your desired one and add SSL if wanted (or other restrictions like rate limiting).

<details>
  <summary>/etc/nginx/conf.d/status-api.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/status-api.conf" "status-api.conf">}}

```nginx
# This sample NGINX Plus configuration enables the NGINX Plus API, for live 
# activity monitoring and the built-in dashboard, dynamic configuration of 
# upstream groups, and key-value stores. Keep in mind that any features 
# added to the API in future NGINX Plus releases are enabled 
# automatically by this file.
# Created in May 2018 by NGINX, Inc. for NGINX Plus R14 and later.

# Documentation: 
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/
# https://www.nginx.com/blog/live-activity-monitoring-nginx-plus-3-simple-steps

# To conform with the conventional configuration scheme, place this file in 
# the /etc/nginx/conf.d directory and add an 'include' directive that 
# references it in the main configuration file, /etc/nginx/nginx.conf, 
# either by name or with a wildcard expression. Then confirm and reload
# the configuration, for example with this command:
#
#     nginx -t && nginx -s reload

# Additional directives are required in other parts of the 
# configuration:
#
# To collect metrics for an HTTP or TCP/UDP virtual server, you must 
# include the 'status_zone' directive in its 'server' block. See: 
# http://nginx.org/r/status_zone
#
# Similarly, to collect metrics for an upstream server group, you 
# must include the 'zone' directive in the 'upstream' block. See:
# http://nginx.org/r/zone
#
# For more information and instructions, see:
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring#status_data

# It is recommended to restrict access to the NGINX Plus API so 
# that only authorized users can view metrics and configuration, change 
# configuration, or both. Here are a few options:
#
# (1) Configure your firewall to limit access to port 8080.
#
# (2) Use SSL/TLS client certificates. See:
#    https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/
#
# (3) Enable HTTP Basic authentication (RFC 7617) by uncommenting the 
#    'auth_basic*' directives in the 'server' block below. You can add users 
#    with an htpasswd generator, which is readily available, or reuse an 
#    existing htpasswd file (from an Apache HTTP Server, for example). See: 
#    http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html
#
# (4) Enable access from a defined network and disable it from all others, 
#    by uncommenting the 'allow' and 'deny' directives in the 'server' block
#    below and specifying the appropriate network ranges. See: 
#    http://nginx.org/en/docs/http/ngx_http_access_module.html
#
# You can create further restrictions on write operations, to distinguish
# between users with read permission and those who can change configuration.
# Uncomment the sample 'limit_except' directive in the 'location api' 
# block below. In addition to the HTTP Basic authentication shown, other 
# authentication schemes are supported. See: 
# http://nginx.org/r/limit_except

server {
    # Conventional port for the NGINX Plus API is 8080
    listen 8080;

    access_log off; # Don't log access here (test env)
    
    # Uncomment to use HTTP Basic authentication; see (3) above
    #auth_basic "NGINX Plus API";
    #auth_basic_user_file /etc/nginx/users;

    # Uncomment to use permissions based on IP address; see (4) above
    #allow 10.0.0.0/8;
    #deny all;

    # Conventional location for accessing the NGINX Plus API 
    location /api/ {
        # Enable in read-write mode
        api write=on;

        # Uncomment to further restrict write permissions; see note above
        #limit_except GET {
            #auth_basic "NGINX Plus API";
            #auth_basic_user_file /etc/nginx/admins;
        #}
    }

    location /nginx_status {
        stub_status;
    }
    
    # Conventional location of the NGINX Plus dashboard
    location = /dashboard.html {
        root /usr/share/nginx/html;
    }

    # Redirect requests for "/" to "/dashboard.html"
    location / {
        root /usr/share/nginx/html;
        index dashboard.html;
    }

    # Swagger-UI exposure
    location /swagger-ui {
        root /usr/share/nginx/html;
    }

    # Redirect requests for pre-R14 dashboard
    location /status.html {
        return 301 /dashboard.html;
    }
}

# vim: syntax=nginx
```

</details><br/>

### Stub Page {#common-stub}

NGINX Open Source uses a stub status page. The following example shows a default configuration on port `8080`. Adjust the port to your desired one and add SSL if wanted (or other restrictions like rate limiting).

Please note: You need to compile NGINX Open Source with the --with-http_stub_status_module parameter

<details>
    <summary>/etc/nginx/conf.d/stub-status.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/stub-status.conf" "stub-status.conf">}}

```nginx
# ngx_http_stub_status_module (Available in NGINX F/OSS)
# provides Basic Status information http://nginx.org/en/docs/http/ngx_http_stub_status_module.html

server {
    listen 127.0.0.1:80;
    server_name 127.0.0.1;
    access_log off; # Don't log access here (test env)
    location /nginx_status {
        stub_status on;
        allow 127.0.0.1;
        deny all;
    }
}

# vim: syntax=nginx
```

</details><br/>

## Basic Authentication {#basic-auth}

Basic auth is not secure and should not be used for production environments. This is not an effective way to secure or authenticate users.

Basic authentication uses a username and password that you can set locally in an `.htpasswd` file. The following example looks like the SSL example and also uses the `.htpasswd` file under the default location.

Follow the guide on nginx.com to [create an .htpasswd file](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/#creating-a-password-file).

{{<tabs name="basic-auth-conf">}}
{{%tab name="NGINX Plus"%}}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-basicauth.conf</summary>

{{<fa "download">}} [nginx-manager-basicauth.conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-basicauth.conf)

```nginx {hl_lines=["34-35","37-38"]}
# nginx-manager-basicauth.conf
# Proxy UI/API with basic auth to 127.0.0.1 on nginx-manager
# You must create the .htpasswd file and add user/password for this to work
# Include the nginx-manager-upstreams.conf for the proxy_pass to work

server {
    listen  443 http2 ssl;

    status_zone nginx-manager_basicauth_https;
    server_name nginx-manager.example.com;

    # Optional log locations
    # access_log /var/log/nginx/nginx-manager-basicauth-access.log info;
    # error_log /var/log/nginx/nginx-manager-basicauth-error.log;

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;
    
    location / {
        proxy_pass http://nginx-manager_servers;
        health_check uri=/swagger-ui/;

        ## Use htpasswd basic auth
        auth_basic "nginx-manager API";
        auth_basic_user_file /etc/nginx/.htpasswd;

        proxy_set_header Authorization "";
        proxy_set_header username   $remote_user;

        client_max_body_size 0;
    }

}
# vim: syntax=nginx
```

</details><br/>

{{%/tab%}}
{{%tab name="NGINX OSS"%}}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-basicauth.conf</summary>

{{<fa "download">}} [nginx-manager-basicauth.conf](https://docs.nginx.com/nginx-management-suite/nim/previous-versions/v1/getting-started/auth/nginx-manager-basicauth.conf)

```nginx {hl_lines=["33-34","36-37"]}
# nginx-manager-basicauth.conf
# Proxy UI/API with basic auth to 127.0.0.1 on nginx-manager
# You must create the .htpasswd file and add user/password for this to work
# Include the nginx-manager-upstreams.conf for the proxy_pass to work

server {
    listen  443 http2 ssl;

    server_name nginx-manager.example.com;

    # Optional log locations
    # access_log /var/log/nginx/nginx-manager-basicauth-access.log info;
    # error_log /var/log/nginx/nginx-manager-basicauth-error.log;

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;
    
    location / {
        proxy_pass http://nginx-manager_servers;
        health_check uri=/swagger-ui/;

        ## Use htpasswd basic auth
        auth_basic "nginx-manager API";
        auth_basic_user_file /etc/nginx/.htpasswd;

        proxy_set_header Authorization "";
        proxy_set_header username   $remote_user;

        client_max_body_size 0;
    }

}
# vim: syntax=nginx
```

</details><br/>

{{%/tab%}}
{{</tabs>}}

You can use different `.htpasswd` files in different locations, or even restrict by IP addresses, if desired. For more information about this feature, refer to the guide [Restricting Access with HTTP Basic Authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/).

## JWT Authentication {#jwt-auth}

You can just JWT Authentication with NGINX Plus and Instance Manager. You need to create the JWT or use an identity provider (idP) to generate the JWT. For more examples on this, refer to the NGINX documentation [Setting up JWT Authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-jwt-authentication/).

Below is an example NGINX conf for using JWT.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-jwt.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-jwt.conf">}}

```nginx {hl_lines=["7-11","15-17","44-46","48-50",52,"59-62",64]}
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
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
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
        proxy_set_header username $jwt_claim_sub;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;

        access_log /var/log/nginx/nginx-manager-jwt-access.log jwt;
    }

}

# vim: syntax=nginx
```

</details><br/>

## OpenID Connect/OAuth2 {#oidc-auth}

To use OpenID Connect and OAuth2 functions, follow the [NGINX OpenID Connect guide](https://github.com/nginxinc/nginx-openid-connect). The following example file would function as the `frontend.conf` in the GitHub example.

{{<note>}}
You need to also include the njs module and follow the instructions from our openidconnect repo. <https://github.com/nginxinc/nginx-openid-connect>
Please ensure you select the correct branch/tag for the NGINX Plus version you use. We default to the latest (R23 as of January 1, 2021).
Adjust and add the files according to the instructions. Use the nginx-manager-oauth.conf for the frontend.conf section.
{{</note>}}

Hints:

- Use private browsing or incognito mode for all testing.
- Close and restart your browser for new sessions.
- Check time and date on the server for expired token issues.
- Pull the specific tag/branch for the NGINX Plus version on the git repo.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-oauth.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-oauth.conf" "nginx-manager-oauth.conf">}}

```nginx {hl_lines=["8-9","14-15","37-38","40-41",47,"49-51",53]}
# nginx-manager-oauth.conf
# Proxy UI/API with Oauth2/OIDC to 127.0.0.1 on nginx-manager
# Include the nginx-manager-upstreams.conf for the proxy_pass to work
# Use files from <https://github.com/nginxinc/nginx-openid-connect> to complete
# Ensure you have permissions set in the directories
# Ensure you have included load_module modules/ngx_http_js_module.so; in nginx.conf 

log_format main_jwt '$remote_addr - $jwt_claim_sub [$time_local] "$request" $status '
                    '$body_bytes_sent "$http_referrer" "$http_user_agent" "$http_x_forwarded_for"';

# reverse proxy with OpenID Connect authentication
#
server {
    include conf.d/openid_connect.server_conf;              # Authorization code flow and Relying Party processing
    # error_log /var/log/nginx/nginx-manager-oauth-error.log debug; # Reduce severity level as required

    listen  443 ssl;

    status_zone nginx-manager_oauth_https;
    server_name nginx-manager.example.com;

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;

    location / {
        # This site is protected with OpenID Connect
        auth_jwt "" token=$session_jwt;
        error_page 401 = @do_oidc_flow;

        #auth_jwt_key_file $oidc_jwt_keyfile; # Enable when using filename
        auth_jwt_key_request /_jwks_uri; # Enable when using URL

        proxy_pass http://nginx-manager_servers;

        # Successfully authenticated users are proxied to the backend,
        # with 'sub' claim passed as HTTP header
        proxy_set_header username $jwt_claim_sub;
        # proxy_set_header API-Client $jwt_claim_sub;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;

        access_log /var/log/nginx/nginx-manager-oauth-access.log main_jwt;
    }
}

# vim: syntax=nginx
```

</details><br/>

## gRPC Metadata {#grpc-metadata}

You can use advanced NGINX Plus features such as [JWT and gRPC](https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-3-publishing-grpc-services/#Authenticating-Clients-with-gRPC-Metadata) by following the guides on the NGINX blog. Use the [encryption guide]({{< relref "/nms/nim/previous-versions/v1/getting-started/encrypt.md#grpc" >}}) for setting up gRPC on NGINX Instance Manager.

## Rate-Limiting {#rate-limiting}

Enabling rate-limiting can help mitigate and prevent DDoS attacks and should be enabled for the API and UI listeners. Using a configuration file similar to the one below can be leverage with other authentication and encryption methods.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-jwt.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-jwt.conf" "nginx-manager-jwt.conf">}}

```nginx {hl_lines=[13,52]}
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
               '$status $body_bytes_sent "$http_referrer" "$http_user_agent" '
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
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
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
        proxy_set_header username $jwt_claim_sub;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;

        access_log /var/log/nginx/nginx-manager-jwt-access.log jwt;
    }

}

# vim: syntax=nginx
```

</details><br/>

## Role Based Access Control {#rbac}

{{<note>}}**TECH PREVIEW**: RBAC is in Technical Preview mode with best effort support for paid subscribers.{{</note>}}

Instance Manager has added tagging and rbac for v1.0.0+ and NGINX Plus proxy users. You need to have authentication setup and pass the `username` header (examples above).

Roles and access control work with tagging (introduced in version 1.0) that allows instances to have a tag of any name applied in the UI or added to the `nginx-agent.conf` for the particular instance. In the picture below, the `Finance` tag is applied to two servers.

{{<note>}}**IMPORTANT NOTE**: Create an admin user and role before you enable the rbac variable in the `nginx-manager.conf`.{{</note>}}

### Creating Roles {#roles}

Under Settings, you can access the `Users` and `Roles` tabs. Navigate to `Roles` and you can configure a new Role.
You can assign the following fields:

- Role Name: The name of the Role used.
- Display Name: A longer name that can help identify the role (optional).
- Access Level: (Read Only, Regular (read/write), or Admin (full access to everything, no limits))
- Tags: What tags the Role has access to (this is ignored for Admin roles).

Roles are a construct of a name, access type and one or more tags.

### Creating Users {#users}

Also under Settings, you can access the `Users` tab to add users and associate them with a role.
You can assign the following fields:

- User Name: exact `$username` header that matches the User
- Display Name: A longer name that can help identify the user (optional)
- Email: Email for the user (reserved for future use)
- Role: Matches a Role you have created (create the Role first)

### Enabling RBAC {#enablerbac}

Enabling RBAC will enforce using the `$username` header for all requests. Without passing this header, access will be denied. A proxy must be used to secure access this way (otherwise you can pass in anything if directly accessing nginx-manager without a proxy.)  For further security, you can use a socket instead of `127.0.0.1` by specifying a file path and using NGINX to proxy to a socket instead of `127.0.0.1`.

To enable rbac, add and enable the following variable in the `nginx-manager.conf` file.

{{<note>}}There is an API call to enable and disable RBAC. `(POST|DELETE)/api/v0/auth/enable`, respectively.{{</note>}}

{{<warning>}}If you did not configure an administrator or test that authentication works, you could lock yourself out of nginx-manager with the `rbac: true` option below. Make sure you test your login first before enabling `rbac: true`.{{</warning>}}

<details>
    <summary>/etc/nginx-manager/nginx-manager.conf</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/getting-started/auth/nginx-manager.conf" "nginx-manager.conf">}}

```yaml {hl_lines=["32-33"]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager

# bind address for all service ports (default "127.0.0.1")
bind_address: 127.0.0.1
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL server name for use with cert and key below (optional)
# server_name: nginx-manager.example.com
# path to x.509 certificate file (optional)
# cert: /etc/ssl/nginx-manager/nginx-manager.crt
# path to x.509 certificate key file (optional)
# key: /etc/ssl/nginx-manager/nginx-manager.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/

# Path to license file
license: /etc/nginx-manager/nginx-manager.lic

# rbac enables enforcement of roles and users (nginx proxy required, ensure you have an admin account working before enabling)
rbac: true

# Audit Log will log ALL api calls with username header (default: not defined)
audit_log: /var/log/nginx-manager/audit.log

# vim: syntax=nginx
```

</details><br/>

Then restart the nginx-manager service.

```bash
sudo systemctl restart nginx-manager
```
