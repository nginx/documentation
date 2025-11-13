---
title: Single Sign-On with OneLogin
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using OneLogin as the identity provider (IdP).
toc: true
weight: 600
nd-content-type: how-to
nd-product: NPL
nd-docs: DOCS-1687
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [OneLogin](https://www.onelogin.com/) as the Identity Provider (IdP) and NGINX Plus as the Relying Party (RP), or OIDC client application that verifies user identity.

{{< call-out "note" >}} This guide applies to [NGINX Plus Release 35]({{< ref "nginx/releases.md#r35" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. In the latest NGINX Plus version, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /call-out >}}

## Prerequisites

- An [OneLogin](https://www.onelogin.com/) account with administrator privileges.

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 35]({{< ref "nginx/releases.md#r35" >}}) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.

## Configure OneLogin {#onelogin-setup}

### Create a OneLogin OIDC Application

1. Log in to your OneLogin admin console, for example, `https://<subdomain>.onelogin.com`.

2. In the navigation bar, select **Applications**.

3. Click the **Add App** button.

   - On the **Find Applications** page, search for **OpenID Connect (OIDC)** and then select it.

   - Enter a **Display Name**, for example, `NGINX Demo App`.

   - Select **Save**.

4. In the app navigation, select **Configuration**.

   - In **Redirect URIs**, add the callback URI for your NGINX Plus instance, for example, `https://demo.example.com/oidc_callback`.

   - In **Logout URL**, add the post logout redirect URI, for example, `https://demo.example.com/post_logout/`.

   - Select **Save**.

5. In the app navigation, select **SSO**.

   - Copy the **Client ID**. You will need it later when configuring NGINX Plus.

   - Select **Show client secret** and copy the **Client Secret**. You will need it later when configuring NGINX Plus.

   - Copy the **Issuer** URL, or OpenID Connect Discovery URL. You will need it later when configuring NGINX Plus. For OneLogin, the Issuer ID generally structured as:

        `https://<subdomain>.onelogin.com/oidc/2`

        See [Provider Configuration](https://developers.onelogin.com/openid-connect/api/provider-config) for details.

### Get the OpenID Connect Discovery URL

Check the OpenID Connect Discovery URL. By default, OneLogin publishes the `.well-known/openid-configuration` document at the following address:

`https://<subdomain>.onelogin.com/oidc/2/.well-known/openid-configuration`.

1. Run the following `curl` command in a terminal:

   ```shell
   curl https://<subdomain>.onelogin.com/oidc/2/.well-known/openid-configuration | jq
   ```

   Where:

   - the `<subdomain>.onelogin.com` is your OneLogin subdomain

   - the `/oidc/2` is the OneLogin OIDC endpoint version

   - the `/.well-known/openid-configuration` is the default address for OneLogin for document location

   - the `jq` command (optional) is used to format the JSON output for easier reading and requires the [jq](https://jqlang.github.io/jq/) JSON processor to be installed.

   The configuration metadata is returned in the JSON format:

   ```json
   {
       ...
       "issuer": "https://<subdomain>.onelogin.com/oidc/2",
       "authorization_endpoint": "https://<subdomain>.onelogin.com/oidc/2/auth",
       "token_endpoint": "https://<subdomain>.onelogin.com/oidc/2/token",
       "jwks_uri": "https://<subdomain>.onelogin.com/oidc/2/certs",
       "userinfo_endpoint": "https://<subdomain>.onelogin.com/oidc/2/me",
       "end_session_endpoint": "https://<subdomain>.onelogin.com/oidc/2/logout",
       ...
   }
   ```

2. Copy the **issuer** value, you will need it later when configuring NGINX Plus. Typically, the OpenID Connect Issuer for OneLogin is `https://<subdomain>.onelogin.com/oidc/2`.

{{< call-out "note" >}} You will need the values of **Client ID**, **Client Secret**, and **Issuer** in the next steps. {{< /call-out >}}

### Assign Users and Groups

1. In the app navigation, select **Users** > **Roles**.

2. Add users and groups who should have access to this application.

## Set up NGINX Plus {#nginx-plus-setup}

With Onelogin configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Rely Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```

    The output should match NGINX Plus Release 35 or later:

    ```none
    nginx version: nginx/1.29.0 (nginx-plus-r35)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained during [Onelogin Configuration](#onelogin-setup).

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the OneLogin provider named `onelogin` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider onelogin {

            # ...

        }
        # ...
    }
    ```

6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - your actual OneLogin **Client ID** obtained in [OneLogin Configuration](#onelogin-setup) with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - your **Client Secret** obtained in [OneLogin Configuration](#onelogin-setup) with the [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - the **Issuer** URL obtained in [OneLogin Configuration](#onelogin-setup) with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

        The `issuer` is typically your OneLogin OIDC URL:

        `https://<subdomain>.onelogin.com/oidc/2`.

    - The **logout_uri** is URI that a user visits to start an RP‑initiated logout flow.

    - The **post_logout_uri** is absolute HTTPS URL where OneLogin should redirect the user after a successful logout. This value **must also be configured** in the OneLogin application's Logout URL setting.

    - If the **logout_token_hint** directive set to `on`, NGINX Plus sends the user's ID token as a *hint* to OneLogin.
      This directive is **required** by OneLogin when `post_logout_redirect_uri` is used.

    - If the **userinfo** directive is set to `on`, NGINX Plus will fetch `/oidc/2/me` from the OneLogin and append the claims from userinfo to the `$oidc_claims_` variables.

    - {{< call-out "important" >}} All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate. {{< /call-out >}}

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider onelogin {
            issuer            https://<subdomain>.onelogin.com/oidc/2;
            client_id         <client_id>;
            client_secret     <client_secret>;
            logout_uri        /logout;
            post_logout_uri   https://demo.example.com/post_logout/;
            logout_token_hint on;
            userinfo          on;
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

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with OneLogin OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `onelogin` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#onelogin-setup-oidc-provider):

    ```nginx
    # ...
    location / {
         auth_oidc onelogin;

         # ...

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by OneLogin:

    - [`$oidc_claim_sub`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - a unique `Subject` identifier assigned for each user by OneLogin

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable

    ```nginx
    # ...
    location / {
         auth_oidc onelogin;

         proxy_set_header sub   $oidc_claim_sub;
         proxy_set_header email $oidc_claim_email;
         proxy_set_header name  $oidc_claim_name;

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

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
            return 200 "Hello, $http_name!\nEmail: $http_email\nOneLogin sub: $http_sub\n";
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

    oidc_provider onelogin {
        # The 'issuer' is typically your OneLogin OIDC base URL
        # e.g. https://<subdomain>.onelogin.com/oidc/2
        issuer https://<subdomain>.onelogin.com/oidc/2;

        # Replace with your actual OneLogin Client ID and Secret
        client_id <client_id>;
        client_secret <client_secret>;

        # RP‑initiated logout
        logout_uri /logout;
        post_logout_uri https://demo.example.com/post_logout/;
        logout_token_hint on;

        # Fetch userinfo claims
        userinfo on;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Protect this path with OneLogin OIDC
            auth_oidc onelogin;

            # Forward OIDC claims to the upstream as headers if desired
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
            return 200 "Hello, $http_name!\nEmail: $http_email\nOneLogin sub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open `https://demo.example.com/` in a browser. You will be automatically redirected to the OneLogin sign-in page.

2. Enter valid OneLogin credentials of a user who has access the application. Upon successful sign-in, OneLogin redirects you back to NGINX Plus, and you will see the proxied application content (for example, "Hello, Jane Doe!").

3. Navigate to `https://demo.example.com/logout`. NGINX Plus initiates an RP‑initiated logout; OneLogin ends the session and redirects back to `https://demo.example.com/post_logout/`.

4. Refresh `https://demo.example.com/` again. You should be redirected to OneLogin for a fresh sign‑in, proving the session has been terminated.

{{< call-out "note" >}}If you restricted access to a group of users, be sure to select a user who has access to the application.{{< /call-out >}}

## Legacy njs-based OneLogin Solution {#legacy-njs-guide}

If you are running NGINX Plus R33 and earlier or if you still need the njs-based solution, refer to the [Legacy njs-based OneLogin Guide]({{< ref "nginx/deployment-guides/single-sign-on/oidc-njs/onelogin.md" >}}) for details. The solution uses the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repository and NGINX JavaScript files.

## See Also

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R35]({{< ref "nginx/releases.md#r35" >}})

## Revision History

- Version 2 (August 2025) – Added RP‑initiated logout (logout_uri, post_logout_uri, logout_token_hint) and userinfo support.

- Version 1 (March 2025) – Initial version (NGINX Plus Release 34)