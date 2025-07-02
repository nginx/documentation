---
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using Microsoft Entra ID (formerly Azure Active Directory) as the identity provider (IdP).
type:
- how-to
product: NGINX-PLUS
title: Single Sign-On with Microsoft Entra ID
toc: true
weight: 400
nd-docs: DOCS-1688
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Microsoft Entra ID](https://www.microsoft.com/en-us/security/business/identity-access/microsoft-entra-id) as the Identity Provider (IdP), and NGINX Plus as the Relying Party, or OIDC client application that verifies user identity.

{{< note >}} This guide applies to [NGINX Plus Release 34]({{< ref "nginx/releases.md#r34" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. In the latest NGINX Plus version, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /note >}}


## Prerequisites

- A Microsoft Entra tenant with admin access.

- Azure CLI. For installation instructions, see [How to install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 34](({{< ref "nginx/releases.md#r34" >}})) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.


## Configure Entra ID {#entra-setup}

Register a new application in Microsoft Entra ID that will represent NGINX Plus as an OIDC client. This is necessary to obtain unique identifiers and secrets for OIDC, as well as to specify where Azure should return tokens. Ensure you have access to the Azure Portal with Entra ID app administrator privileges.

### Register new Azure Web Application

1. Log in to Azure CLI:

   ```bash
   az login
   ```
   This command will open your default browser for authentication.

2. Register a New Application.

   - Create a new application, for example, "Nginx Demo App", with NGINX callback URI `/oidc_callback`:

     ```bash
     az ad app create --display-name "Nginx Demo App" --web-redirect-uris "https://demo.example.com/oidc_callback"
     ```

   - From the command output, copy the `appId` value which represents your **Client ID**. You will need it later when configuring NGINX Plus.

3. Generate a new Client Secret.

   - Create a client secret for your application by running:

     ```bash
     az ad app credential reset --id <appId>
     ```

    - Replace the `<appId>` with the value obtained in the previous step.

    - From the command output, copy the the `password` value which represents your **Client Secret**. You will need it later when configuring NGINX Plus. Make sure to securely save the generated client secret, as it will not be displayed again.

    - From the same command output, copy the the `tenant` value which represents your **Tenant ID**. You will need it later when configuring NGINX Plus.

{{< note >}} You will need the values of **Client ID**, **Client Secret**, and **Tenant ID** in the next steps. {{< /note >}}

## Set up NGINX Plus {#nginx-plus}

With Microsoft Entra ID configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Rely Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```
    The output should match NGINX Plus Release 34 or later:

    ```none
    nginx version: nginx/1.27.4 (nginx-plus-r34)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Tenant ID** obtained during [Microsoft Entra ID Configuration](#entra-setup).

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

    <span id="entra-setup-oidc-provider"></span>
5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the Entra ID provider named `entra` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider entra {

            # ...

        }
        # ...
    }
    ```

6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - your **Client ID** obtained in [Entra ID Configuration](#entra-setup) with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - your **Client Secret** obtained in [Entra ID Configuration](#entra-setup) with the [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - the **Issuer** URL obtained in [Entra ID Configuration](#entra-setup) with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

        The `issuer` is typically:

        `https://login.microsoftonline.com/<tenant_id>/v2.0`.

        By default, NGINX Plus creates the metadata URL by appending the `/.well-known/openid-configuration` part to the Issuer URL. If your metadata URL is different, you can explicitly specify it with the [`config_url`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#config_url) directive.

    - **Important:** All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate.

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider entra {
            issuer        https://login.microsoftonline.com/<tenant_id>/v2.0;
            client_id     <client_id>;
            client_secret <client_secret>;

            ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
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

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with Entra ID OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `entra` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#entra-setup-oidc-provider):

    ```nginx
    # ...
    location / {

         auth_oidc entra;

         # ...

         proxy_pass http://127.0.0.1:8080;

    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by Entra ID:

    - [`$oidc_claim_sub`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - a unique `Subject` identifier assigned for each user by Entra ID

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable


    ```nginx
    # ...
    location / {

         auth_oidc entra;

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

    oidc_provider entra {
        # The issuer is typically something like:
        # https://login.microsoftonline.com/<tenant_id>/v2.0
        issuer https://login.microsoftonline.com/<tenant_id>/v2.0;

        # Replace with your actual Entra client_id and client_secret
        client_id <client_id>;
        client_secret <client_secret>;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Protect this location with Entra OIDC
            auth_oidc entra;

            # Forward OIDC claims as headers if desired
            proxy_set_header sub $oidc_claim_sub;
            proxy_set_header email $oidc_claim_email;
            proxy_set_header name $oidc_claim_name;

            proxy_pass http://127.0.0.1:8080;
        }
    }

    server {
        listen 8080;

        location / {
            return 200 "Hello, $http_username!\n Your email is $http_email\n Your unique id is $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open `https://demo.example.com/` in a browser. You will be automatically redirected to the Enra ID sign-in page.

2. Enter valid Entra ID credentials of a user who has access the application. Upon successful sign-in, Entra ID redirects you back to NGINX Plus, and you will see the proxied application content (for example, “Hello, Jane Doe!”).

{{<note>}}If you restricted access to a group of users, be sure to select a user who has access to the application.{{</note>}}


## See Also

- [Microsoft identity platform documentation](https://learn.microsoft.com/en-us/entra/identity-platform/)

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R34]({{< ref "nginx/releases.md#r34" >}})

## Revision History

- Version 1 (March 2025) – Initial version (NGINX Plus Release 34)
