---
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using Ping Identity as the identity provider (IdP).
type:
- how-to
product: NGINX-PLUS
title: Single Sign-On with Ping Identity
toc: true
weight: 800
nd-docs: DOCS-1684
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Ping Identity](https://www.pingidentity.com/en.html) (PingFederate or PingOne) as the Identity Provider (IdP), and NGINX Plus as the Relying Party.

{{< note >}} This guide applies to [NGINX Plus Release 34]({{< ref "nginx/releases.md#r34" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. In the latest NGINX Plus version, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /note >}}


## Prerequisites

- [PingFederate](https://docs.pingidentity.com/pingfederate/latest/pf_pf_landing_page.html) Enterprise Federation Server or [PingOne](https://docs.pingidentity.com/pingone/p1_cloud__platform_main_landing_page.html) Cloud deployment with a Ping Identity account.

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 34](({{< ref "nginx/releases.md#r34" >}})) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.


## Configure PingFederate or PingOne for Enterprise {#ping-create}

{{< note >}} These steps outline an example with the cloud offering of **PingOne**. If you are using the on‑premises PingFederate, the user interface might slightly differ. {{< /note >}}

Create a new application for NGINX Plus:

1. Log in to your Ping Identity admin console.

2. Go to **Applications** > **Applications**.

3. Click the **+** (plus) symbol to create a new OIDC Application.

4. On the New Application screen:

   - Enter the Name of your application, for example, `nginx-demo-app`.

   - Select the Application Type **OIDC Web App**.

   - Select **Save**.

5. In your OIDC application, Select the **Overview** tab:

   - in the **General** section, copy your **Client ID** and **Client Secret** values. You will need then later when configuring NGINX Plus.

   - In the **Connection Details** section, copy your **Issuer ID**. You will need it later when configuring NGINX Plus.

     For PingOne Cloud, the Issuer ID generally structured as `https://auth.pingone.com/<environment_id>/as`.

     For PingFederate, the Issuer ID generally structured as `https://pingfederate.example.com:9031` appended with the realm path of your environment.

6. On the **Configuration** tab of your OIDC application:

   - In the **Redirect URIs** field, add the NGINX Plus callback URI, for example:

    `https://demo.example.com/oidc_callback`.

   - Select **Save**.

7. Assign the application to the appropriate **Groups** or **Users** who will be allowed to log in.

{{< note >}} You will need the values of **Client ID**, **Client Secret**, and **Issuer** in the next steps. {{< /note >}}


## Set up NGINX Plus {#nginx-plus-setup}

With PingOne or PingFederate configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Rely Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```
    The output should match NGINX Plus Release 34 or later:

    ```none
    nginx version: nginx/1.27.4 (nginx-plus-r34)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained during [PingOne or PingFederate Configuration](#ping-setup).

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

    <span id="ping-setup-oidc-provider"></span>
5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the PingOne or PingFederate provider named `ping` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider ping {

            # ...
        }
        # ...
    }
    ```

6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - your actual Ping **Client ID** obtained in [Ping Configuration](#ping-create) with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - your **Client Secret** obtained in [Ping Configuration](#ping-create) with the [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - the **Issuer** URL obtained in [Ping Configuration](#ping-create) with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

        The `issuer` is typically your Ping Identity OIDC URL.

        For PingOne Cloud, the URL is `https://auth.pingone.com/<environment_id>/as`.

        For PingFederate, the URL is `https://pingfederate.example.com:9031` followed by your environment’s realm path.

        By default, NGINX Plus creates the OpenID metadata URL by appending the `/.well-known/openid-configuration` part to the Issuer URL. If your metadata URL is different, you can explicitly specify the metadata document with the [`config_url`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#config_url) directive.

    - **Important:** All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate.


    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider ping {
            issuer        https://auth.pingone.com/<environment_id>/as;
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

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with Ping Identity OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `ping` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#ping-setup-oidc-provider):

    ```nginx
    # ...
    location / {
         auth_oidc ping;

         # ...

         proxy_pass http://127.0.0.1:8080;
    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by Ping:

    - [`$oidc_claim_sub`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - a unique `Subject` identifier assigned for each user by Ping Identity

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable

    {{< note >}} Ensure the `openid`, `profile`, `email` Scopes are enabled in Ping Identity.{{< /note >}}

    ```nginx
    # ...
    location / {
         auth_oidc ping;

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

    oidc_provider ping {
        # The issuer is typically something like:
        # https://auth.pingone.com/<environment_id>/as
        issuer https://auth.pingone.com/<environment_id>/as;

        # Your Ping Identity Client ID and Secret
        client_id <client_id>;
        client_secret <client_secret>;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Enforce OIDC with Ping Identity
            auth_oidc ping;

            # Forward OIDC claims as headers if desired
            proxy_set_header sub $oidc_claim_sub;
            proxy_set_header email $oidc_claim_email;
            proxy_set_header name $oidc_claim_name;

            proxy_pass http://127.0.0.1:8080;
        }
    }

    server {
        # Simple backend application for demonstration
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nSub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open `https://demo.example.com/` in a browser. You will be automatically redirected to the PingOne sign-in page.

2. Enter valid Ping Identity credentials of a user who has access the application. Upon successful sign-in, PingOne redirects you back to NGINX Plus, and you will see the proxied application content (for example, “Hello, Jane Doe!”).


## Legacy njs-based Ping Identity Solution {#legacy-njs-guide}

If you are running NGINX Plus R33 and earlier or if you still need the njs-based solution, refer to the [Legacy njs-based Ping Identity Guide]({{< ref "nginx/deployment-guides/single-sign-on/oidc-njs/ping-identity.md" >}}) for details. The solution uses the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repository and NGINX JavaScript files.


## See Also

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R34]({{< ref "nginx/releases.md#r34" >}})


## Revision History

- Version 1 (March 2025) – Initial version for NGINX Plus Release 34
