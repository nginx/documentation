---
title: Single Sign-On with Keycloak
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using Keycloak as the identity provider (IdP).
toc: true
weight: 500
nd-content-type: how-to
nd-product: NPL
nd-docs: DOCS-1682
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Keycloak](https://www.keycloak.org/) as the Identity Provider (IdP), and NGINX Plus as the Relying Party, or OIDC client application that verifies user identity.

{{< call-out "note" >}} This guide applies to [NGINX Plus Release 36]({{< ref "nginx/releases.md#r36" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. Starting from NGINX Plus version R34, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /call-out >}}

## Prerequisites

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 36]({{< ref "nginx/releases.md#r36" >}}) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.

## Configure Keycloak {#keycloak-setup}

1. Log in to your Keycloak admin console, for example, `https://<keycloak-server>/admin/master/console/`.

2. In the left navigation, go to **Clients**, then

3. Select **Create client** and provide the following details:

    - Set **Client type** to **OpenID Connect**.

    - Enter a **Client ID**, for example, `nginx-demo-app`. You will need it later when configuring NGINX Plus.

    - Select **Next**.

4. In the **Capability Config** section:

    - Set **Client Authentication** to **On**. This sets the client type to **confidential**.

    - Select **Next**.

5. In the **Login Settings** section:

    Add a **Redirect URI**, for example:

     ```text
     https://demo.example.com/oidc_callback
     ```

    Add a **Post Logout Redirect URI** to support RP-initiated logout, for example:

     ```text
     https://demo.example.com/post_logout/
     ```

   - Select **Save**.

6. In the **Credentials** tab, make note of the **Client Secret**. You will need it later when configuring NGINX Plus.

### Configure Logout and Front-Channel Single Logout (optional) {#keycloak-frontchannel-logout}

Front-channel logout allows Keycloak to notify NGINX Plus when a user signs out of the realm or another application that participates in Single Logout (SLO). Keycloak sends a front-channel HTTP request (typically loaded in a hidden iframe) to a logout URL that you configure for the client.

1. In the Keycloak admin console, go to **Clients** and select your `nginx-demo-app` client.

2. On the **Settings** tab, scroll to the **Logout settings** section.

3. Configure front-channel logout for this client:

   - Set **Front channel logout** to **On**.

   - In **Front-channel Logout URL**, enter the NGINX Plus front-channel logout endpoint, for example:

     ```text
     https://demo.example.com/front_logout
     ```

   - Enable **Front-channel logout session required**. With this option enabled, Keycloak includes both the session identifier (`sid`) and issuer (`iss`) parameters in the front-channel logout request that it sends to NGINX Plus, as defined by the OpenID Connect Front-Channel Logout specification. NGINX Plus uses these parameters to identify and clear the corresponding user session.

### Assign Users or Groups

This step is optional, and is necessary if you need to restrict or organize user permissions.

1. In the **Roles** tab, add a **Client Role**, for example, `nginx-keycloak-role`.

2. Under **Users**, create a new user or select a user.

3. In **Role Mappings**, assign a role to the user within the `nginx-demo-app` client.

### Get the OpenID Connect Discovery URL

Check the OpenID Connect Discovery URL. By default, Keycloak publishes the `.well-known/openid-configuration` document at the following address:

`https://<keycloak-server>/realms/<realm_name>/.well-known/openid-configuration`.

1. Run the following `curl` command in a terminal:

   ```shell
   curl https://<keycloak-server>/realms/<realm_name>/.well-known/openid-configuration | jq
   ```

   Where:

   - the `<keycloak-server>` is your Keycloak server address

   - the `<realm_name>` is your Keycloak realm name

   - the `/.well-known/openid-configuration` is the default address for Keycloak for document location

   - the `jq` command (optional) is used to format the JSON output for easier reading and requires the [jq](https://jqlang.github.io/jq/) JSON processor to be installed.

   The configuration metadata is returned in the JSON format:

   ```json
   {
       ...
       "issuer": "https://<keycloak-server>/realms/<realm_name>",
       "authorization_endpoint": "https://<keycloak-server>/realms/<realm_name>/protocol/openid-connect/auth",
       "token_endpoint": "https://<keycloak-server>/realms/<realm_name>/protocol/openid-connect/token",
       "jwks_uri": "https://<keycloak-server>/realms/<realm_name>/protocol/openid-connect/certs",
       "userinfo_endpoint": "https://<keycloak-server>/realms/<realm_name>/protocol/openid-connect/userinfo",
       "end_session_endpoint": "https://<keycloak-server>/realms/<realm_name>/protocol/openid-connect/logout",
       ...
   }
   ```

2. Copy the **issuer** value, you will need it later when configuring NGINX Plus. Typically, the OpenID Connect Issuer for Keycloak is `https://<keycloak-server>/realms/<realm_name>`.

{{< call-out "note" >}} You will need the values of **Client ID**, **Client Secret**, and **Issuer** in the next steps. {{< /call-out >}}

## Set up NGINX Plus {#nginx-plus-setup}

With Keycloak configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Relying Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```

    The output should match NGINX Plus Release 36 or later:

    ```none
    nginx version: nginx/1.29.3 (nginx-plus-r36)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained during [Keycloak Configuration](#keycloak-setup).

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

    <span id="keycloak-setup-oidc-provider"></span>
5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the Keycloak provider named `keycloak` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider keycloak {

            # ...

        }
        # ...
    }
    ```

6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - your actual Keycloak **Client ID** obtained in [Keycloak Configuration](#keycloak-setup) with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - (if not using PKCE) your **Client Secret** obtained in [Keycloak Configuration](#keycloak-setup) with the
      [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - the **Issuer** URL obtained in [Keycloak Configuration](#keycloak-setup) with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

        The `issuer` is typically your Keycloak OIDC URL:

        `https://<keycloak-server>/realms/<realm_name>`.

        By default, NGINX Plus creates the metadata URL by appending the `/.well-known/openid-configuration` part to the Issuer URL. If your metadata URL is different, you can explicitly specify it with the [`config_url`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#config_url) directive.

    - The **logout_uri** is URI that a user visits to start an RP‑initiated logout flow.

    - The **post_logout_uri** is absolute HTTPS URL where Keycloak should redirect the user after a successful logout. This value **must also be configured** in the Keycloak client's Post Logout Redirect URIs.

    - If the **logout_token_hint** directive set to `on`, NGINX Plus sends the user's ID token as a *hint* to Keycloak.
      This directive is **optional**, however, if it is omitted the Keycloak may display an extra confirmation page asking the user to approve the logout request.

    - The **frontchannel_logout_uri** directive defines the URI on NGINX Plus that receives OpenID Connect front-channel logout requests from Keycloak. This path must be an HTTPS endpoint and must match the **Front-channel Logout URL** configured for the client in Keycloak. When a front-channel logout request is sent (typically in a hidden iframe), Keycloak includes the session identifier and issuer (the `sid` and `iss` parameters, when **Front-channel logout session required** is enabled); the OIDC module uses these values to locate and clear the corresponding local session.

    - If the **userinfo** directive is set to `on`, NGINX Plus will fetch `/protocol/openid-connect/userinfo` from the Keycloak and append the claims from userinfo to the `$oidc_claims_` variables.

    - PKCE (Proof Key for Code Exchange) is automatically enabled when Keycloak's OpenID Connect discovery document advertises the `S256` code challenge method in the `code_challenge_methods_supported` field. You can override this behavior with the [`pkce`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#pkce) directive: set `pkce off;` to disable PKCE even when `S256` is advertised, or `pkce on;` to force PKCE even if the IdP metadata does not list `S256`.

    - The module automatically selects the client authentication method for the token endpoint based on the provider metadata `token_endpoint_auth_methods_supported`. When only `client_secret_post` is advertised, NGINX Plus uses the `client_secret_post` method and sends the client credentials in the POST body. When both `client_secret_basic` and `client_secret_post` are present, the module prefers HTTP Basic (`client_secret_basic`), which remains the default for Keycloak.

    - {{< call-out "important" >}} All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate. {{< /call-out >}}

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider keycloak {
            issuer            https://<keycloak-server>/realms/<realm_name>;
            client_id         <client_id>;
            client_secret     <client_secret>;
            logout_uri        /logout;
            post_logout_uri   https://demo.example.com/post_logout/;
            logout_token_hint on;
            frontchannel_logout_uri /front_logout;
            userinfo          on;

            # Optional: PKCE configuration. By default, PKCE is automatically
            # enabled when the IdP advertises the S256 code challenge method.
            # pkce on;
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

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with Keycloak OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `keycloak` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#keycloak-setup-oidc-provider):

    ```nginx
    # ...
    location / {
         auth_oidc keycloak;

         # ...

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by Keycloak:

    - [`$oidc_claim_sub`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - a unique `Subject` identifier assigned for each user by Keycloak

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable

    ```nginx
    # ...
    location / {
         auth_oidc keycloak;

         proxy_set_header sub   $oidc_claim_sub;
         proxy_set_header email $oidc_claim_email;
         proxy_set_header name  $oidc_claim_name;

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

    <span id="oidc_app"></span>
10. Provide endpoint for completing logout:

    ```nginx
    # ...
    location /post_logout/ {
         return 200 "You have been logged out.\n";
         default_type text/plain;
    }
    # ...
    ```

11. Create a simple test application referenced by the `proxy_pass` directive which returns the authenticated user's full name and email upon successful authentication:

    ```nginx
    # ...
    server {
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nKeycloak sub: $http_sub\n";
            default_type text/plain;
        }
    }
    ```
    
12. Save the NGINX configuration file and reload the configuration:

    ```nginx
    nginx -s reload
    ```

### Complete Example

This configuration example summarizes the steps outlined above. It includes only essential settings such as specifying the DNS resolver, defining the OIDC provider, configuring SSL, and proxying requests to an internal server.

```nginx
http {
    # Use a public DNS resolver for Issuer discovery, etc.
    resolver 10.0.0.1 ipv4=on valid=300s;

    oidc_provider keycloak {
        # The 'issuer' typically matches your Keycloak realm's base URL:
        # For example: https://<keycloak-server>/realms/<realm_name>
        issuer https://<keycloak-server>/realms/master;

        # Replace with your actual Keycloak client_id and secret
        client_id <client_id>;
        client_secret <client_secret>;

        # RP‑initiated logout
        logout_uri /logout;
        post_logout_uri https://demo.example.com/post_logout/;
        logout_token_hint on;

        # Front-channel logout (OP‑initiated single sign-out)
        frontchannel_logout_uri /front_logout;

        # Fetch userinfo claims
        userinfo on;

        # Optional: PKCE configuration
        # pkce on;

        # If the .well-known endpoint can't be derived automatically,
        # specify config_url:
        # config_url https://<keycloak-server>/realms/master/.well-known/openid-configuration;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Protect this location with Keycloak OIDC
            auth_oidc keycloak;

            # Forward OIDC claims as headers if desired
            proxy_set_header sub $oidc_claim_sub;
            proxy_set_header email $oidc_claim_email;
            proxy_set_header name $oidc_claim_name;

            proxy_pass http://127.0.0.1:8080;
        }

        location /post_logout/ {
            return 200 "You have been logged out.\n";
            default_type text/plain;
        }
    }

    server {
        # Simple test upstream server
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nKeycloak sub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open https://demo.example.com/ in a browser. You should be redirected to Keycloak's login page for your realm.

2. Enter valid Keycloak credentials for a user assigned to the `nginx-demo-app` client.
Upon successful sign-in, Keycloak redirects you back to NGINX Plus, and you will see the proxied application content (for example, "Hello, Jane Doe!").

3. Navigate to `https://demo.example.com/logout`. NGINX Plus initiates an RP‑initiated logout; Keycloak ends the session and redirects back to `https://demo.example.com/post_logout/`.

4. Refresh `https://demo.example.com/` again. You should be redirected to Keycloak for a fresh sign‑in, proving the session has been terminated.

## Legacy njs-based Keycloak Solution {#legacy-njs-guide}

If you are running NGINX Plus R33 and earlier or if you still need the njs-based solution, refer to the [Legacy njs-based Keycloak Guide]({{< ref "nginx/deployment-guides/single-sign-on/oidc-njs/keycloak.md" >}}) for details. The solution uses the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repository and NGINX JavaScript files.

## See Also

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R36]({{< ref "nginx/releases.md#r36" >}})

## Revision History

- Version 3 (November 2025) – Updated for NGINX Plus R36; added front-channel logout support (`frontchannel_logout_uri`), PKCE configuration (`pkce` directive), and the `client_secret_post` token endpoint authentication method.

- Version 2 (August 2025) – Updated for NGINX Plus R35; added RP‑initiated logout (`logout_uri`, `post_logout_uri`, `logout_token_hint`) and `userinfo` support.

- Version 1 (March 2025) – Initial version (NGINX Plus Release 34).
