---
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using Okta as the identity provider (IdP).
type:
- how-to
product: NGINX-PLUS
title: Single Sign-On with Okta
toc: true
weight: 700
nd-docs: DOCS-1689
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Okta](https://www.okta.com/) as the Identity Provider (IdP), and NGINX Plus as the Relying Party, or OIDC client application that verifies user identity.

{{< call-out "note" >}} This guide applies to [NGINX Plus Release 34]({{< ref "nginx/releases.md#r34" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. In the latest NGINX Plus version, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /call-out >}}

## Prerequisites

- An [Okta](https://www.okta.com/) administrator account with privileges to create and manage applications.

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 34](({{< ref "nginx/releases.md#r34" >}})) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.


## Configure Okta {#okta-setup}

In Okta, register a new application for NGINX Plus as the OIDC client to obtain the Client ID, Client Secret, and required OIDC endpoints.

1. Log in to your Okta admin console.

2. In the Admin Console, go to **Applications** > **Applications**.

3. Select **Create App Integration**.

4. In **Create a new app integration**, select:

   - **Sign-in method**: `OIDC - OpenID Connect`.

   - **Application type**: `Web Application`.

   - Select **Next**.

5. In **New Web App Integration**:

   - Enter the **Name** for your new application, for example, **Nginx Demo App**.

   -  Add a URI for the OIDC callback in **Sign-in redirect URIs**, for example,   `https://demo.example.com/oidc_callback`.

   - Select **Save**.

6. In **Applications**, select **Nginx Demo App**.

7. In the **General** tab:

   - Copy the **Client ID**. You will need it later when configuring NGINX Plus.

   - Copy the **Client secret**. You will need it later when configuring NGINX Plus.

8. In the **Sign On** tab:

   - Copy the **Okta Issuer (Authorization Server)**, for example:

     `https://dev-123456.oktapreview.com/oauth2/default`

     You will need it later when configuring NGINX Plus.

{{< call-out "note" >}} You will need the values of **Client ID**, **Client Secret**, and **Issuer** in the next steps. {{< /call-out >}}

### Assign Users or Groups

By default, Okta might limit application access to certain users or groups. To add or remove users in Okta:

1. Log in to your Okta admin console.

2. In **Applications**, choose **Nginx Demo App**.

3. Go to **Assignments**.

4. Add or remove users and groups that can access this application.


## Set up NGINX Plus {#nginx-plus-setup}

With Okta configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Rely Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```
    The output should match NGINX Plus Release 34 or later:

    ```none
    nginx version: nginx/1.27.4 (nginx-plus-r34)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained during [Okta Configuration](#okta-setup).

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

    <span id="okta-setup-oidc-provider"></span>
5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the Okta provider named `okta` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider okta {

            # ...

        }
        # ...
    }
    ```

6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - your actual Okta **Client ID** obtained in [Okta Configuration](#okta-setup) with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - your **Client Secret** obtained in [Okta Configuration](#okta-setup) with the [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - the **Issuer** URL obtained in [Okta Configuration](#okta-setup) with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

        The `issuer` is typically your Okta OIDC URL:

        `https://dev-123456.okta.com/oauth2/default`.

    - **Important:** All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate.

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider okta {
            issuer        https://dev-123456.okta.com/oauth2/default;
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

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with Okta OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `okta` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#okta-setup-oidc-provider):

    ```nginx
    # ...
    location / {
         auth_oidc okta;

         # ...

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by Okta:

    - [`$oidc_claim_sub`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - a unique `Subject` identifier assigned for each user by Okta

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable

    ```nginx
    # ...
    location / {
         auth_oidc okta;

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
            return 200 "Hello, $http_name!\nEmail: $http_email\nSub: $http_sub\n";
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

    # Define the OIDC provider block for Okta
    oidc_provider okta {
        # The 'issuer' is your Okta issuer URL
        # For okta dev it looks like: https://dev-123456.okta.com/oauth2/default
        issuer https://dev-123456.okta.com/oauth2/default;

        # Your Okta “Client ID” from the application settings
        client_id <your_client_id>;

        # Your Okta “Client Secret” from the application settings
        client_secret <your_client_secret>;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Enforce OIDC authentication with Okta
            auth_oidc okta;

            # Pass OIDC claims as HTTP headers to the backend
            proxy_set_header sub $oidc_claim_sub;
            proxy_set_header email $oidc_claim_email;
            proxy_set_header name $oidc_claim_name;

            proxy_pass http://127.0.0.1:8080;
        }
    }

    server {
        # Simple backend listening on 8080
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nSub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open `https://demo.example.com/` in a browser. You will be automatically redirected to the Okta sign-in page.

2. Enter valid Okta credentials of a user who has access the application. Upon successful sign-in, Okta redirects you back to NGINX Plus, and you will see the proxied application content (for example, “Hello, Jane Doe!”).

{{< call-out "note" >}}If you restricted access to a group of users, be sure to select a user who has access to the application.{{< /call-out >}}


## Legacy njs-based Okta Solution {#legacy-njs-guide}

If you are running NGINX Plus R33 and earlier or if you still need the njs-based solution, refer to the [Legacy njs-based Okta Guide]({{< ref "nginx/deployment-guides/single-sign-on/oidc-njs/okta.md" >}}) for details. The solution uses the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repository and NGINX JavaScript files.


## See Also

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R34]({{< ref "nginx/releases.md#r34" >}})


## Revision History

- Version 1 (March 2025) – Initial version (NGINX Plus Release 34)

