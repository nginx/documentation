---
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using Auth0 as the identity provider (IdP).
type:
- how-to
product: NGINX-PLUS
title: Single Sign-On With Auth0
toc: true
weight: 100
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Auth0](https://auth0.com/features/single-sign-on) as the Identity Provider (IdP), and NGINX Plus as the Relying Party, or OIDC client application that verifies user identity.

{{< note >}} This guide applies to [NGINX Plus Release 34]({{< ref "nginx/releases.md#r34" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. In the latest NGINX Plus version, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /note >}}


## Prerequisites

- An [Auth0](https://auth0.com/) tenant with administrator privileges.

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 34](({{< ref "nginx/releases.md#r34" >}})) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.


## Create a new Auth0 Application {#auth0-create}

1. Log in to your Auth0 Dashboard at [manage.auth0.com](https://manage.auth0.com/).

2. Select **Applications > Applications** from the sidebar menu.

3. On the **Applications** screen, select **Create Application**.

4. On the **Create application** screen: 

   - Enter the **Name** for the application, for example, **NGINX Demo App**.

   - In **Application Type**, select **Regular Web Applications**.

   - Select **Create**.

5. On the **Settings** screen of your application:

   - Copy your **Client ID** and **Client Secret** displayed in the **Basic Information** section &mdash; you will need them later when configuring NGINX Plus.

6. On the **Application URIs** section of your application:

   - Add the URI NGINX Plus callback URI in the **Allowed Callback URLs** field, for example:

     `https://demo.example.com/oidc_callback`.

### Get the OpenID Connect Discovery URL

Check the OpenID Connect Discovery URL. By default, Auth0 publishes the `.well-known/openid-configuration` document at the following address:

`https://yourTenantId.us.auth0.com/.well-known/openid-configuration`.

1. Run the following `curl` command in a terminal:

   ```shell
   curl https://yourTenantId.us.auth0.com/.well-known/openid-configuration | jq
   ```
   where:

   - the `yourTenantId` is your Auth0 [Tenant ID](https://auth0.com/docs/get-started/tenant-settings/find-your-tenant-name-or-tenant-id)

   - the `yourTenantId.us.auth0.com/` is your Auth0 server address

   - the `/.well-known/openid-configuration` is the default address for Auth0 for document location

   - the `jq` command (optional) is used to format the JSON output for easier reading and requires the [jq](https://jqlang.github.io/jq/) JSON processor to be installed.


   The configuration metadata is returned in the JSON format:

   ```json
   {
       ...
       "issuer": "https://{yourTenantId}.us.auth0.com/",
       "authorization_endpoint": "https://{yourTenantId}.us.auth0.com/oauth/token",
       "token_endpoint": "https://{yourTenantId}.us.auth0.com/oauth/token",
       "jwks_uri": "https://{yourTenantId}.us.auth0.com/.well-known/jwks.json",
       ...
   }
   ```

   <span id="auth0-setup-issuer"></span>
2. Copy the **issuer** value, you will need it later when configuring NGINX Plus. Typically, the OpenID Connect Issuer for Auth0 is `https://yourTenantId.us.auth0.com/` (including the trailing slash). To verify the accuracy of the endpoints, refer to the [Auth0 official documentation](https://auth0.com/docs/get-started/applications/configure-applications-with-oidc-discovery).

{{< note >}} You will need the values of **Client ID**, **Client Secret**, and **Issuer** in the next steps. {{< /note >}}


## Set up NGINX Plus {#nginx-plus-setup}

With Auth0 configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Rely Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```
    The output should match NGINX Plus Release 34 or later:

    ```none
    nginx version: nginx/1.27.4 (nginx-plus-r34)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained during [Auth0 Configuration](#auth0-setup).

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

    <span id="auth0-setup-oidc-provider"></span>
5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the Auth0 provider named `auth0` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider auth0 {

            # ...

        }
        # ...
    }
    ```

6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - Your actual Auth0 **Client ID** obtained in [Auth0 Configuration](#auth0-create) with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - Your **Client Secret** obtained in [Auth0 Configuration](#auth0-create) with the [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - The **Issuer** URL obtained in [Auth0 Configuration](#auth0-create) with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

      The `issuer` is typically your Auth0 OIDC URL. For Auth0, a trailing slash is included, for example: `https://yourTenantId.us.auth0.com/`.

     - **Important:** All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate.


    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider auth0 {
            issuer        https://yourTenantId.us.auth0.com/;
            client_id     <client_id>;
            client_secret <client_secret>;
        }

        # ...
    }
    ```

7.  Make sure you have configured a [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) that corresponds to `demo.example.com`, and there is a [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) that [points](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) to your application (see [Step 10](#oidc_app)) at `http://127.0.0.1:8080` that is going to be OIDC-protected:

    ```nginx
    http {

        # ...

        server {
            listen      443 ssl;
            server_name demo.example.com;

            ssl_certificate     /etc/ssl/certs/fullchain.pem;
            ssl_certificate_key /etc/ssl/private/key.pem;

            location / {

                # ...

                proxy_pass http://127.0.0.1:8080;
            }
        }
        # ...
    }
    ```

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with Auth0 OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `auth0` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#auth0-setup-oidc-provider):

    ```nginx
    # ...
    location / {
         auth_oidc auth0;

         # ...

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by Auth0:

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable

    ```nginx
    # ...
    location / {
         auth_oidc auth0;

         proxy_set_header sub   $oidc_claim_sub;
         proxy_set_header email $oidc_claim_email;
         proxy_set_header name  $oidc_claim_name;

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

    <span id="oidc_app"></span>
10. Create a simple test application referenced by the `proxy_pass` directive which returns the authenticated user's full name and email upon successful authentication:

    ```nginx
    # ...
    server {
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nAuth0 sub: $http_sub\n";
            default_type text/plain;
        }
    }
    ```
11. Save the NGINX configuration file and reload the configuration:
    ```nginx
    nginx -s reload
    ```

### Complete Example

This configuration example summarizes the steps outlined above. It includes only essential settings such as specifying the DNS resolver, defining the OIDC provider, configuring SSL, and proxying requests to an internal server.

```nginx
http {
    # Use a public DNS resolver for Issuer discovery, etc.
    resolver 10.0.0.1 ipv4=on valid=300s;

    oidc_provider auth0 {
        # Issuer from your Auth0 tenant's .well-known/openid-configuration
        issuer https://yourTenantId.us.auth0.com/;

        # Replace with your actual Client ID and Secret from Auth0
        client_id <client_id>;
        client_secret <client_secret>;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Enforce OIDC for root path with Auth0
            auth_oidc auth0;

            # Forward OIDC claims to the upstream as headers if desired
            proxy_set_header email $oidc_claim_email;
            proxy_set_header name  $oidc_claim_name;

            proxy_pass http://127.0.0.1:8080;
        }
    }

    server {
        # Simple test upstream server
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nAuth0 sub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open `https://demo.example.com/` in a browser. You will be redirected to the Auth0 sign-in page.

2. Enter valid Auth0 credentials of a user who has access the application. Upon successful sign-in, Auth0 redirects you back to NGINX Plus, and you will see the proxied application content (for example, “Hello, Jane Doe!”).


## Legacy njs-based Auth0 Solution {#legacy-njs-guide}

If you are running NGINX Plus R33 and earlier or if you still need the njs-based solution, refer to the [Legacy njs-based Auth0 Guide]({{< ref "nginx/deployment-guides/single-sign-on/oidc-njs/auth0.md" >}}) for details. The solution uses the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repository and NGINX JavaScript files.


## See Also

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R34]({{< ref "nginx/releases.md#r34" >}})


## Revision History

- Version 1 (March 2025) – Initial version (NGINX Plus Release 34)
