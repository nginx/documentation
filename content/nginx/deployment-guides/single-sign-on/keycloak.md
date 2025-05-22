---
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using Keycloak as the identity provider (IdP).
type:
- how-to
product: NGINX-PLUS
title: Single Sign-On with Keycloak
toc: true
weight: 500
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Keycloak](https://www.keycloak.org/) as the Identity Provider (IdP), and NGINX Plus as the Relying Party, or OIDC client application that verifies user identity.

{{< note >}} This guide applies to [NGINX Plus Release 34]({{< ref "nginx/releases.md#r34" >}}) and later. In earlier versions, NGINX Plus relied on an [njs-based solution](#legacy-njs-guide), which required NGINX JavaScript files, key-value stores, and advanced OpenID Connect logic. In the latest NGINX Plus version, the new [OpenID Connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) simplifies this process to just a few directives.{{< /note >}}


## Prerequisites

- A running [Keycloak](https://www.keycloak.org/) server version compatible with OIDC.

- An NGINX Plus [subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 34](({{< ref "nginx/releases.md#r34" >}})) or later. For installation instructions, see [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name pointing to your NGINX Plus instance, for example, `demo.example.com`.


## Configure Keycloak {#keycloak-setup}

{{<tabs name="configure-keycloak">}}

{{%tab name="Standard OIDC"%}}

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

    - Add a **Redirect URI**, for example:
     ```
     https://demo.example.com/oidc_callback
     ```
   - Select **Save**.

6. In the **Credentials** tab, make note of the **Client Secret**. You will need it later when configuring NGINX Plus.

{{%/tab%}}

{{%tab name="Using PKCE"%}}

1. Log in to your Keycloak admin console, for example, `https://<keycloak-server>/auth/admin/`.

2. In the left navigation, go to **Clients**, then

3. Select **Create client** and provide the following details:

    - Set **Client type** to **OpenID Connect**.

    - Enter a **Client ID**, for example, `nginx-demo-app`. You will need it later when configuring NGINX Plus.

    - Select **Next**.

4. In the **Capability Config** section:

    - Set **Client Authentication** to **Off**. This sets the client type to **public**.

    - Unselect the **Direct access grants** in the **Authentication Flow** section.

    - Select **Next**

5. In the **Login Settings** section:

    - Add a **Redirect URI**, for example:
     ```
     https://demo.example.com/oidc_callback
     ```
    - Select **Save**.

6. In the **Advanced** tab, under the **Advanced Settings** section set the **Proof Key for Code Exchange Code Challenge Method** to **S256**.

7. Note that as opposed to standard OIDC flow, PKCE does not use Client Secrets, so there is no Credentials tab. This is expected.

{{%/tab%}}

{{</tabs>}}

### Assign Users or Groups

This step is optional, and is necessary if you need to restrict or organize user permissions.

1. In the **Roles** tab, add a **Client Role**, for example, `nginx-keycloak-role`.

2. Under **Users**, create a new user or select a user.

3. In **Role Mappings**, assign a role to the user within the `nginx-demo-app` client.

{{< note >}} You will need the values of **Client ID**, **Client Secret**, and **Issuer** in the next steps. {{< /note >}}


## Set up NGINX Plus {#nginx-plus-setup}

With Keycloak configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Relying Party (RP) application &mdash; a client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```
    The output should match NGINX Plus Release 34 or later:

    ```none
    nginx version: nginx/1.27.4 (nginx-plus-r34)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained during 
    [Keycloak Configuration](#keycloak-setup) if applicable. PKCE will not have a **Client Secret**.

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

    - **Important:** All interaction with the IdP is secured exclusively over SSL/TLS, so NGINX must trust the certificate presented by the IdP. By default, this trust is validated against your system’s CA bundle (the default CA store for your Linux or FreeBSD distribution). If the IdP’s certificate is not included in the system CA bundle, you can explicitly specify a trusted certificate or chain with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) directive so that NGINX can validate and trust the IdP’s certificate.

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider keycloak {
            issuer        https://<keycloak-server>/realms/<realm_name>;
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

    oidc_provider keycloak {
        # The 'issuer' typically matches your Keycloak realm's base URL:
        # For example: https://<keycloak-server>/realms/<realm_name>
        issuer https://<keycloak-server>/realms/master;

        # Replace with your actual Keycloak client_id and secret
        client_id <client_id>;
        client_secret <client_secret>;

        # If the .well-known endpoint can’t be derived automatically,
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
    }

    server {
        # Simple test backend
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nSub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing

1. Open https://demo.example.com/ in a browser. You should be redirected to Keycloak’s login page for your realm.

2. Enter valid Keycloak credentials for a user assigned to the `nginx-demo-app` client.
Upon successful sign-in, Keycloak redirects you back to NGINX Plus, and you will see the proxied application content (for example, “Hello, Jane Doe!”).


## Legacy njs-based Keycloak Solution {#legacy-njs-guide}

If you are running NGINX Plus R33 and earlier or if you still need the njs-based solution, refer to the [Legacy njs-based Keycloak Guide]({{< ref "nginx/deployment-guides/single-sign-on/oidc-njs/keycloak.md" >}}) for details. The solution uses the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repository and NGINX JavaScript files.


## See Also

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R34]({{< ref "nginx/releases.md#r34" >}})


## Revision History

- Version 1 (March 2025) – Initial version (NGINX Plus Release 34)
