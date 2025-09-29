---
description: Enable OpenID Connect-based single sign-on (SSO) for applications proxied by NGINX Plus, using an Identity Provider (IdP).
type:
- task
title: Single Sign-On with OpenID Connect and Identity Providers
toc: true
weight: 550
product: NGINX-PLUS
nd-docs: DOCS-1690
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus using:
- OpenID Connect as the authentication mechanism.
- An external Identity Provider (IdP) such as AD FS, Auth0, Cognito, Entra ID, Keycloak, OneLogin, Okta, Ping Identity and others.
- NGINX Plus as an OIDC client application that verifies user identity (Relying Party).

OpenID Connect is an identity protocol that utilizes the authorization and authentication mechanisms of OAuth 2.0. With it, NGINX Plus can provide a layer of authentication for protected applications that do not natively support it.

NGINX Plus consumes authorization and claims from OpenID Connect Identity Providers by utilizing JWT-based identity tokens that are delivered via the OAuth 2.0 framework. It supports several specific flows suitable for browser-based and desktop/mobile applications. OpenID Connect allows the client (NGINX Plus) to retrieve an ID token in addition to an access token. The ID token provides information about the authenticated user.

For the target client application, OIDC authentication can be enabled with great flexibility on different levels. It can be enabled globally, or more granular at a per-server or a per-location level. Additionally, OIDC supports auto discovery and retrieval of the OpenID provider configuration metadata while also allowing the definition of additional metadata if needed.


## OpenID Connect Workflow and NGINX Plus {#oidc-workflow}

1. A user accesses a protected resource.

2. NGINX Plus redirects the user to the IdP for user authentication and authorization.

3. The IdP collects user credentials and authenticates the user.

4. The IdP redirects the user back to NGINX Plus with an authorization code.

5. NGINX Plus retrieves an `id_token` and access token using the authorization code from the IdP.

6. NGINX Plus validates the `id_token` and retrieves profile data for the user using the `UserInfo` endpoint. The retrieved profile data is validated and the content of the `id_token` and the profile data is used for providing access control to the client application.

7. Upon successful validation, the resource access request is sent to the client application along with the access token.

8. The client application validates the access token and based on the token validation, the resource access request is allowed or denied.

<span style="display: inline-block; margin-top: 20px; margin-bottom: 50px;">
{{< img src="nginx/images/oidc.png">}}
</span>


## Tested Identity Providers {#deployment-guildes}

 NGINX Plus has tested support with the following Identity Providers:

{{<bootstrap-table "table table-striped table-bordered">}}
| IdP Provider    | Resource                              |
|-----------------|-------------------------------------------------------------------------------------------------------------|
| Amazon Cognito  | [Deployment Guide for Amazon Cognito]({{< ref "nginx/deployment-guides/single-sign-on/cognito.md" >}}) |
| Auth0           | [Deployment Guide for Auth0]({{< ref "nginx/deployment-guides/single-sign-on/auth0.md" >}}) |
| Microsoft AD FS | [Deployment Guide for AD FS]({{< ref "nginx/deployment-guides/single-sign-on/active-directory-federation-services.md" >}}) |
| Microsoft Entra / Azure ID| [Deployment Guide for Entra ID]({{< ref "nginx/deployment-guides/single-sign-on/entra-id.md" >}}) |
| Keycloak        | [Deployment Guide for Keycloak]({{< ref "nginx/deployment-guides/single-sign-on/keycloak.md" >}}) |
| OneLogin        | [Deployment Guide for OneLogin]({{< ref "nginx/deployment-guides/single-sign-on/onelogin.md" >}}) |
| Okta            | [Deployment Guide for Okta]({{< ref "nginx/deployment-guides/single-sign-on/okta.md" >}}) |
| Ping Identity   | [Deployment Guide for Ping Identity]({{< ref "nginx/deployment-guides/single-sign-on/ping-identity.md" >}}) |
{{</bootstrap-table>}}


## Prerequisites {#prerequisites}

- An identity provider (IdP) set up on your network or in the cloud. You need admin access to the IdP.

- An [NGINX Plus subscription](https://www.f5.com/products/nginx/nginx-plus) and NGINX Plus [Release 34]({{< ref "nginx/releases.md#r34" >}}) or later.
  To install NGINX Plus, follow the steps in [Installing NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

- A domain name that points to your NGINX Plus instance (for example, `demo.example.com`).


## Set up your identity provider (IdP) {#idp-setup}

The setup steps are similar for most identity providers, but some details may differ.

1. Log in to your IdP's admin console.

2. Create a new OpenID Connect (OIDC) application.

   - Give the app a name.
   - Add the users or groups who need access.

3. Find the **Client ID** and **Client Secret** for your app.
   You'll need these later when you [set up NGINX Plus as the relying party](#setup-oidc-provider2).

4. Find the **issuer** value.

   You can find the issuer value in your IdP app settings or at the standard discovery URL:

   `https://your-idp-domain/.well-known/openid-configuration`

   where:

   - the `your-idp-domain` is your IdP's server address

   - the `.well-known/openid-configuration` is the default address for IdPs for the `.well-known` document

   - the `userinfo_endpoint` is URI that a user visits to start an RP‑initiated logout flow.

   - the `end_session_endpoint` is the URL where your IdP should redirect the user after a successful logout.

   The IdP configuration metadata is returned in the JSON format, for example:

   ```json
   {
       ...
       "issuer": "https://your-idp-domain/idp",
       "authorization_endpoint": "https://your-idp-domain/idp/oauth2/authorize/",
       "token_endpoint": "https://your-idp-domain/idp/oauth2/token/",
       "jwks_uri": "https://your-idp-domain/idp/discovery/keys",
       "userinfo_endpoint": "https://your-idp-domain/idp/userinfo",
       "end_session_endpoint": "https://your-idp-domain/idp/oauth2/logout",
       ...
   }
   ```

  Copy the **issuer** value. You will need it later when [configuring NGINX Plus as the Relying Party](#setup-oidc-provider2).

5. Configure a logout URI - a URI that a user visits to initiate an RP‑initiated logout flow, for example, `https://demo.example.com/post_logout/`. (Optional, supported since [NGINX Plus R35]({{< ref "nginx/releases.md#r35" >}})).


## Configure the Relying Party (NGINX Plus) {#rp-setup}

With your IdP configured, you can enable OIDC on NGINX Plus. NGINX Plus serves as the Rely Party (RP) client service that verifies user identity.

1.  Ensure that you are using the latest version of NGINX Plus by running the `nginx -v` command in a terminal:

    ```shell
    nginx -v
    ```
    The output should match NGINX Plus Release 35:

    ```none
    nginx version: nginx/1.29.0 (nginx-plus-r35)
    ```

2.  Ensure that you have the values of the **Client ID**, **Client Secret**, and **Issuer** obtained from your IdP Provider.

3.  In your preferred text editor, open the NGINX configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

4.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, make sure your public DNS resolver is specified with the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive: By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        # ...
    }
    ```

    <span id="setup-oidc-provider"></span>
5.  In the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context, define the IdP provider named `my_idp` by specifying the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider my_idp {

            # ...

        }
        # ...
    }
    ```

    <span id="setup-oidc-provider2"></span>
6.  In the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context, specify:

    - Your actual **Client ID** obtained from your IdP with the [`client_id`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_id) directive

    - Your **Client Secret** obtained from your IdP with the [`client_secret`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

    - The **Issuer** URL obtained from your IdP with the [`issuer`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#client_secret) directive

     By default, NGINX Plus creates the metadata URL by appending the `/.well-known/openid-configuration` part to the Issuer URL. If your Issuer is different, you can explicitly specify the metadata document with the [`config_url`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#config_url) directive.

    - A valid system CA bundle with the [`ssl_trusted_certificate`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#ssl_trusted_certificate) so that NGINX Plus could validate the IdP TLS certificates:

    ```nginx
    http {
        resolver 10.0.0.1 ipv4=on valid=300s;

        oidc_provider my_idp {
            issuer        https://your-idp-domain/idp;
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

8.  Protect this [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with IdP OIDC by specifying the [`auth_oidc`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#auth_oidc) directive that will point to the `my_idp` configuration specified in the [`oidc_provider {}`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#oidc_provider) context in [Step 5](#setup-oidc-provider):

    ```nginx
    # ...
    location / {
         auth_oidc my_idp;

         # ...

         proxy_pass http://127.0.0.1:8080;

    }
    # ...
    ```

9.  Pass the OIDC claims as headers to the application ([Step 10](#oidc_app)) with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. These claims are extracted from the ID token returned by the IdP:

    - [`$oidc_claim_sub`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - a unique `Subject` identifier assigned for each user by the IdP

    - [`$oidc_claim_email`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) the e-mail address of the user

    - [`$oidc_claim_name`](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) - the full name of the user

    - Any other OIDC claim using the [`$oidc_claim_ `](https://nginx.org/en/docs/http/ngx_http_oidc_module.html#var_oidc_claim_) variable


    ```nginx
    # ...
    location / {
         auth_oidc my_idp;

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
            return 200 "Hello, $http_name!\nEmail: $http_email\nIdP sub sub: $http_sub\n";
            default_type text/plain;
        }
    }
    ```
11. Save the NGINX configuration file and reload the configuration:
    ```nginx
    nginx -s reload
    ```

### Complete Example {#example}

This configuration example summarizes the steps outlined above. It includes only essential settings such as specifying the DNS resolver, defining the OIDC provider, configuring SSL, and proxying requests to an internal server.

```nginx
http {
    # Use a public DNS resolver for Issuer discovery, etc.
    resolver 10.0.0.1 ipv4=on valid=300s;

    oidc_provider my_idp {
        # The 'issuer' typically matches your IdP's base URL
        issuer https://<idp-server>/idp;

        # Provide a CA bundle for certificate validation
        ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;

        # Replace with your actual IdP's client_id and secret
        client_id <client_id>;
        client_secret <client_secret>;

        # RP‑initiated logout
        logout_uri        /logout;
        post_logout_uri   https://demo.example.com/post_logout/;
        logout_token_hint on;

        # Fetch userinfo claims
        userinfo on;

        # If the .well-known endpoint cannot be derived automatically,
        # specify config_url:
        # config_url https://<idp-server>/auth/realms/main/.well-known/openid-configuration;
    }

    server {
        listen 443 ssl;
        server_name demo.example.com;

        ssl_certificate     /etc/ssl/certs/fullchain.pem;
        ssl_certificate_key /etc/ssl/private/key.pem;

        location / {
            # Protect this location with OIDC
            auth_oidc my_idp;

            # Forward OIDC claims as headers if desired
            proxy_set_header sub   $oidc_claim_sub;
            proxy_set_header email $oidc_claim_email;
            proxy_set_header name  $oidc_claim_name;

            proxy_pass http://127.0.0.1:8080;
        }

            location /post_logout/ {
                return 200 "You have been logged out.\n";
                default_type text/plain;
            }
    }

    server {
        # simple test oidc-protected application
        listen 8080;

        location / {
            return 200 "Hello, $http_name!\nEmail: $http_email\nIdP sub: $http_sub\n";
            default_type text/plain;
        }
    }
}
```

### Testing {#testing}

1. Open https://demo.example.com/ in a browser. You should be redirected to your IdP's login page.

2. Enter valid IdP credentials for a user assigned to the `nginx-demo-app` client.
Upon successful sign-in, the IdP redirects you back to NGINX Plus, and you will see the proxied application content (for example, “Hello, Jane Doe!”).


## Glossary {#glossary}


{{<bootstrap-table "table table-striped table-bordered">}}
| Term                    | Description                                        |
|-------------------------|----------------------------------------------------|
| Identity Provider (IdP) | A service that authenticates users and verifies their identity for client applications. |
| Protected Resource      | A resource that is hosted by the resource server and requires an access token to be accessed. |
| Relying Party (RP)      | A client service required to verify user identity. |
| JSON Web Token (JWT)    | An open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. |
| ID Token                | Specific to OIDC, the primary use of the token in JWT format is to provide information about the authentication operation's outcome. |
| Access Token            | Defined in OAuth2, this (optional) short lifetime token provides access to specific user resources as defined in the scope values in the request to the authorization server (can be a JSON token as well). |
| Refresh Token           | Coming from OAuth2 specs, the token is usually long-lived and may be used to obtain new access tokens. |
{{</bootstrap-table>}}


## See Also {#see-also}

- [Simplifying OIDC and SSO with the New NGINX Plus R34 OIDC Module blog post](https://community.f5.com/kb/technicalarticles/simplifying-oidc-and-sso-with-the-new-nginx-plus-r34-oidc-module/340552)

- [NGINX Plus Native OIDC Module Reference documentation](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)

- [Release Notes for NGINX Plus R34]({{< ref "nginx/releases.md#r34" >}})
