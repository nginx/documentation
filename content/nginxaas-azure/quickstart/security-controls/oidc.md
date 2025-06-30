---
title: Set up OIDC authentication
weight: 300
toc: true
nd-docs: DOCS-1646
url: /nginxaas/azure/quickstart/security-controls/oidc/
type:
- how-to
---

## Overview

Learn how to configure F5 NGINX as a Service (NGINXaaS) for Azure with OpenID Connect (OIDC) authentication.

## Prerequisites

1. Configure an NGINXaaS deployment with [SSL/TLS certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/" >}}).

2. Enable [Runtime State Sharing]({{< ref "/nginxaas-azure/quickstart/runtime-state-sharing.md" >}}) on the NGINXaaS deployment.

3. [Configure the IdP](https://github.com/nginxinc/nginx-openid-connect/blob/main/README.md#configuring-your-idp). For example, you can [register a Microsoft Entra Web application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app) as the IdP.


## Configure NGINX as a Service for Azure with IdP

Configuring NGINXaaS for Azure with OIDC is similar as [Configuring NGINX Plus](https://github.com/nginxinc/nginx-openid-connect/blob/main/README.md#configuring-nginx-plus) in [nginx-openid-connect](https://github.com/nginxinc/nginx-openid-connect) but it also has its own specific configurations that must be completed to work normally.

1. If your IdP supports OpenID Connect Discovery (usually at the URI /.well-known/openid-configuration), use the `configure.sh` script in [nginx-openid-connect](https://github.com/nginxinc/nginx-openid-connect) to complete the configuration. Otherwise, follow [Configuring NGINX Plus](https://github.com/nginxinc/nginx-openid-connect/blob/main/README.md#configuring-nginx-plus) to complete the configuration.

2. Configure NGINXaaS with specific configurations:
    - `openid_connect_configuration.conf`:

        a. Set a proper timeout value for `map $host $zone_sync_leeway`.

        ```nginx
        map $host $zone_sync_leeway {
            # Specifies the maximum timeout for synchronizing ID tokens between cluster
            # nodes when you use shared memory zone content sync. This option is only
            # recommended for scenarios where cluster nodes can randomly process
            # requests from user agents and there may be a situation where node "A"
            # successfully received a token, and node "B" receives the next request in
            # less than zone_sync_interval.
            default 2000; # Time in milliseconds, e.g. (zone_sync_interval * 2 * 1000)
        }
        ```

        b. Set a proper path for `proxy_cache_path`, see [Enable content caching]({{< ref "basic-caching.md" >}}).

        ```nginx
        proxy_cache_path /var/cache/nginx/jwt levels=1 keys_zone=jwk:64k max_size=1m;
        ```

        c. Enable `sync` for the keyval memory zones and specify the state files to persist the current state across NGINX restarts. The state file paths are subject to [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}) and must be placed in a directory accessible to the NGINX worker processes.

        ```nginx
        keyval_zone zone=oidc_id_tokens:1M     state=/opt/oidc_id_tokens.json     timeout=1h sync;
        keyval_zone zone=oidc_access_tokens:1M state=/opt/oidc_access_tokens.json timeout=1h sync;
        keyval_zone zone=refresh_tokens:1M     state=/opt/refresh_tokens.json     timeout=8h sync;
        keyval_zone zone=oidc_pkce:128K timeout=90s sync; # Temporary storage for PKCE code verifier.
        ```

    - `openid_connect.server_conf`:

        Remove the `location /api/` block, since NGINXaaS for Azure currently restricts access to the `api` directive.
        ```nginx
        location /api/ {
            api write=on;
            allow 127.0.0.1; # Only the NGINX host may call the NGINX Plus API
            deny all;
            access_log off;
        }
        ```

    - Modify the root config file `nginx.conf` properly with `frontend.conf` content:

        a. Add `load_module modules/ngx_http_js_module.so;` near the top of the root config file, if it doesn't exist.

        b. Add `include conf.d/openid_connect_configuration.conf;` in the http block before the server block.

    <details close>
    <summary> Example of nginx.conf using the localhost as a upstream server</summary>

    ```nginx
    load_module modules/ngx_http_js_module.so;

    http {

        # This is the backend application we are protecting with OpenID Connect
        upstream my_backend {
            zone my_backend 64k;
            # Reuse the localhost as a upstream server
            # Modify to the real upstream server address if you have
            server 127.0.0.1;
        }

        # A local server block representing the upstream server for testing only
        # Remove if you have the real upstream servers
        server {
            listen 80;
            default_type text/html;
            return 200 '<!DOCTYPE html><h2>This is a site protected by OIDC!</h2>\n';
        }

        # Custom log format to include the 'sub' claim in the REMOTE_USER field
        log_format main_jwt '$remote_addr - $jwt_claim_sub [$time_local] "$request" $status '
                            '$body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"';

        # The frontend server - reverse proxy with OpenID Connect authentication
        #
        include conf.d/openid_connect_configuration.conf;
        server {
            include conf.d/openid_connect.server_conf; # Authorization code flow and Relying Party processing
            error_log /var/log/nginx/error.log debug;  # Reduce severity level as required

            listen 443 ssl; # Use SSL/TLS in production
            ssl_certificate /etc/nginx/ssl/my-cert.crt;
            ssl_certificate_key /etc/nginx/ssl/my-cert.key;

            location / {
                # This site is protected with OpenID Connect
                auth_jwt "" token=$session_jwt;
                error_page 401 = @do_oidc_flow;

                #auth_jwt_key_file $oidc_jwt_keyfile; # Enable when using filename
                auth_jwt_key_request /_jwks_uri; # Enable when using URL

                # Successfully authenticated users are proxied to the backend,
                # with 'sub' claim passed as HTTP header
                proxy_set_header username $jwt_claim_sub;

                # Bearer token is uses to authorize NGINX to access protected backend
                #proxy_set_header Authorization "Bearer $access_token";

                # Intercept and redirect "401 Unauthorized" proxied responses to nginx
                # for processing with the error_page directive. Necessary if Access Token
                # can expire before ID Token.
                #proxy_intercept_errors on;

                proxy_pass http://my_backend; # The backend site/app

                access_log /var/log/nginx/access.log main_jwt;
            }
        }
    }

    stream {
        # Add localhost resolver for internal clustering hostname with resolver metrics collection
        resolver 127.0.0.1:49153 valid=20s status_zone=stream_resolver_zone1;

        server {
            listen 9000;
            zone_sync;
            zone_sync_server internal.nginxaas.nginx.com:9000 resolve;
        }
    }
    ```
    </details>

3. Upload the NGINX configurations. See [Upload an NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/" >}}) for more details.

4. In a web browser, open `https://<nginxaas_deployment_fqdn>/<protected_uri>`. The browser will be redirected to the IdP server. After a successful login using the credentials of a user who has the authorization, the protected URI can be accessed. For example, using the `nginx.conf` in this guide, open `https://<nginxaas_deployment_fqdn>/` and complete the authentication. The browser will show:

    ```text
    This is a site protected by OIDC!
    ```

## Troubleshooting

[Enable NGINX logs]({{< ref "/nginxaas-azure/monitoring/enable-logging/" >}}) and [Troubleshooting](https://github.com/nginxinc/nginx-openid-connect/tree/main?tab=readme-ov-file#troubleshooting) the OIDC issues.

## Monitoring

[Enable monitoring]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}), check [real time monitoring](https://github.com/nginxinc/nginx-openid-connect/blob/main/README.md#real-time-monitoring) to see how OIDC metrics are collected, and use "plus.http.*" metrics filtered with location_zone dimension in [NGINX requests and response statistics]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md#nginx-requests-and-response-statistics" >}}) to check the OIDC metrics.
