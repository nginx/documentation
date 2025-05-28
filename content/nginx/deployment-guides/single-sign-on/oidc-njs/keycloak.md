---
description: Enable OpenID Connect-based single-sign for applications proxied by NGINX
  Plus, using Keycloak as the identity provider (IdP).
docs: DOCS-465
type:
- how-to
title: Single Sign-On with Keycloak and njs
toc: false
weight: 100
product: NGINX-PLUS
---

{{< note >}} This guide applies to NGINX Plus [Release 15]({{< ref "nginx/releases.md#r15" >}}) and later, based on the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repo. Starting with NGINX Plus [Release 34]({{< ref "nginx/releases.md#r34" >}}), use the simpler solution with the [native OpenID connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html).

See [Single Sign-On With Keycloak]({{< ref "nginx/deployment-guides/single-sign-on/keycloak.md" >}}) for details.{{< /note >}}

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Keycloak](https://www.keycloak.org/) as the identity provider (IdP), and NGINX Plus as the relying party.

{{< see-also >}}{{< readfile file="includes/nginx-openid-repo-note.txt" markdown="true" >}}{{< /see-also >}}


<span id="prereqs"></span>
## Prerequisites

The instructions assume you have the following:

- A running Keycloak server. See the Keycloak documentation for [Getting Started](https://www.keycloak.org/guides#getting-started) and [Server](https://www.keycloak.org/guides#server) configuration instructions.
- An NGINX Plus subscription and <span style="white-space: nowrap;">NGINX Plus R15</span> or later. For installation instructions, see the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).
- The [NGINX JavaScript module](https://www.nginx.com/blog/introduction-nginscript/) (njs), required for handling the interaction between NGINX Plus and the IdP. After installing NGINX Plus, install the module with the command for your operating system.

   For Debian and Ubuntu:

   ```none
   sudo apt install nginx-plus-module-njs
   ```

   For CentOS, RHEL, and Oracle Linux:

   ```shell
   sudo yum install nginx-plus-module-njs
   ```

- The following directive included in the top-level ("main") configuration context in **/etc/nginx/nginx.conf**, to load the NGINX JavaScript module:

   ```nginx
   load_module modules/ngx_http_js_module.so;
   ```

<span id="keycloak"></span>
## Configuring Keycloak

**Note:** The following procedure reflects the Keycloak GUI at the time of publication, but the GUI is subject to change. Use this guide as a reference and adapt to the current Keycloak GUI as necessary.

Create a Keycloak client for NGINX Plus in the Keycloak GUI:

1. Access the Keycloak Admin Console at **http://_keycloak-server-address_:8080/auth/admin/** and log in.

2. In the left navigation column, click **Clients**. On the **Clients** page that opens, click the **Create** button in the upper right corner.

   <span id="keycloak-client-id"></span>
3. On the **Add Client** page that opens, enter or select these values, then click the <span style="background-color:#009edc; color:white;"> Save </span> button.

   - **Client ID** – The name of the application for which you're enabling SSO (Keycloak refers to it as the “client”). Here we're using **NGINX&#8209;Plus**.
   - **Client Protocol** – **openid&#8209;connect**.

   <img src="/nginx/images/keycloak-add-client.png" alt="" width="1024" height="490" class="aligncenter size-full wp-image-62013" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. On the **NGINX Plus** page that opens, enter or select these values on the <span style="color:#48a5e2;">Settings</span> tab:

   - **Access Type** – **confidential**
   - **Valid Redirect URIs** – The URI of the NGINX Plus instance, including the port number, and ending in **/\_codexch** (in this guide it is **https://my&#8209;nginx.example.com:443/_codexch**)

     **Notes:**

     - For production, we strongly recommend that you use SSL/TLS (port 443).
     - The port number is mandatory even when you're using the default port for HTTP (80) or HTTPS (443).

   <img src="/nginx/images/keycloak-settings-tab.png" alt="" width="1024" height="706" class="aligncenter size-full wp-image-62011" style="border:2px solid #666666; padding:2px; margin:2px;" />

   <span id="keycloak-secret"></span>
5. Click the <span style="color:#48a5e2;">Credentials</span> tab and make a note of the value in the **Secret** field. You will copy it into the NGINX Plus configuration file in [Step 4 of _Configuring NGINX Plus_](#nginx-plus-variables).

   <img src="/nginx/images/keycloak-credentials-tab.png" alt="" width="1024" height="414" class="aligncenter size-full wp-image-62010" style="border:2px solid #666666; padding:2px; margin:2px;" />

6. Click the <span style="color:#48a5e2;">Roles</span> tab, then click the **Add Role** button in the upper right corner of the page that opens.

7. On the **Add Role** page that opens, type a value in the **Role Name** field (here it is **nginx&#8209;keycloak&#8209;role**) and click the <span style="background-color:#009edc; color:white;"> Save </span> button.

   <img src="/nginx/images/keycloak-add-role.png" alt="" width="1024" height="480" class="aligncenter size-full wp-image-62006" style="border:2px solid #666666; padding:2px; margin:2px;" />

8. In the left navigation column, click **Users**. On the **Users** page that opens, either click the name of an existing user, or click the **Add user** button in the upper right corner to create a new user. For complete instructions, see the [Keycloak documentation](https://www.keycloak.org/docs/latest/server_admin/index.html#user-management).

   <span id="keycloak-users"></span>
9. On the management page for the user (here, **user01**), click the <span style="white-space: nowrap; color:#48a5e2;">Role Mappings</span> tab. On the page that opens, select **NGINX&#8209;Plus** on the **Client Roles** drop‑down menu. Click **nginx&#8209;keycloak&#8209;role** in the **Available Roles** box, then click the **Add selected** button below the box. The role then appears in the **Assigned Roles** and **Effective Roles** boxes, as shown in the screenshot.

   <img src="/nginx/images/keycloak-role-mappings-tab.png" alt="" width="1024" height="526" class="aligncenter size-full wp-image-62008" style="border:2px solid #666666; padding:2px; margin:2px;" />


<span id="nginx-plus"></span>
## Configuring NGINX Plus

Configure NGINX Plus as the OpenID Connect relying party:

1. Create a clone of the [**nginx&#8209;openid&#8209;connect**](https://github.com/nginxinc/nginx-openid-connect) GitHub repository.

   ```shell
   git clone https://github.com/nginxinc/nginx-openid-connect
   ```

2. Copy these files from the clone to **/etc/nginx/conf.d**:

   - **frontend.conf**
   - **openid\_connect.js**
   - **openid\_connect.server\_conf**
   - **openid\_connect\_configuration.conf**

   <span id="nginx-plus-urls"></span>
3. Get the URLs for the authorization endpoint, token endpoint, and JSON Web Key (JWK) file from the Keycloak configuration. Run the following `curl` command in a terminal, piping the output to the indicated `python` command to output the entire configuration in an easily readable format. We've abridged the output to show only the relevant fields.

   ```shell
   $ curl https://<keycloak-server-address>/realms/master/.well-known/openid-configuration | python -m json.tool
   ...
   {
       "authorization_endpoint": "https://<keycloak-server-address>/realms/master/protocol/openid-connect/auth",
       ...
       "jwks_uri": "https://<keycloak-server-address>/realms/master/protocol/openid-connect/certs",
       ...
       "token_endpoint": "https://<keycloak-server-address>/realms/master/protocol/openid-connect/token",
    ...
    }
    ```

   <span id="nginx-plus-variables"></span>
4. Using your preferred text editor, open **/etc/nginx/conf.d/openid_connect_configuration.conf**. Change the "default" parameter value of each of the following [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) directives to the specified value:

   - `map $host $oidc_authz_endpoint` – Value of `authorization_endpoint` from [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<keycloak-server-address>/realms/master/protocol/openid-connect/auth`</span>)
   - `map $host $oidc_token_endpoint` – Value of `token_endpoint` from [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<keycloak-server-address>/realms/master/protocol/openid-connect/token`)</span>
   - `map $host $oidc_client` – Value in the **Client ID** field from [Step 3 of _Configuring Keycloak_](#keycloak-client-id) (in this guide, `NGINX Plus`)
   - `map $host $oidc_client_secret` – Value in the **Secret** field from [Step 5 of _Configuring Keycloak_](#keycloak-secret) (in this guide, <span style="white-space: nowrap;">`<oidc client secret>`)</span>
   - `map $host $oidc_hmac_key` – A unique, long, and secure phrase

5. Configure the JWK file. The procedure depends on which version of NGINX Plus you are using.

   - In <span style="white-space: nowrap;">NGINX Plus R17</span> and later, NGINX Plus can read the JWK file directly from the URL reported as `jwks_uri` in [Step 3](#nginx-plus-urls). Change **/etc/nginx/conf.d/frontend.conf** as follows:

      1. Comment out (or remove) the [auth_jwt_key_file](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) directive.

      2. Uncomment the [auth_jwt_key_request](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directive. (Its parameter, `/_jwks_uri`, refers to the value of the `$oidc_jwt_keyfile` variable, which you set in the next step.)
      3. Change the "default" parameter of the `map $host $oidc_jwt_keyfile` directive to the value reported in the `jwks_uri` field in [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<keycloak-server-address>/realms/master/protocol/openid-connect/certs`)</span>.

   - In <span style="white-space: nowrap;">NGINX Plus R16</span> and earlier, the JWK file must be on the local disk. (You can also use this method with <span style="white-space: nowrap;">NGINX Plus R17</span> and later if you wish.)

      1. Copy the JSON contents from the JWK file named in the `jwks_uri` field in [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<keycloak-server-address>/realms/master/protocol/openid-connect/certs`)</span> to a local file (for example, `/etc/nginx/my_keycloak_jwk.json`).
      2. In **/etc/nginx/conf.d/openid_connect_configuration.conf**, change the "default" parameter of the <span style="white-space: nowrap;">`map $host $oidc_jwt_keyfile`</span> directive to the local file path.

6. Confirm that the user named by the [user](http://nginx.org/en/docs/ngx_core_module.html#user) directive in the NGINX Plus configuration (in **/etc/nginx/nginx.conf** by convention) has read permission on the JWK file.

<span id="testing"></span>
## Testing

In a browser, enter the address of your NGINX Plus instance and try to log in using the credentials of a user mapped to the role for NGINX Plus (see [Step 9 of _Configuring Keycloak_](#keycloak-users)).

<img src="/nginx/images/keycloak-log-in.png" alt="" width="792" height="768" class="aligncenter size-full wp-image-62002" />

<span id="troubleshooting"></span>
## Troubleshooting

See the [**Troubleshooting**](https://github.com/nginxinc/nginx-openid-connect#troubleshooting) section at the **nginx&#8209;openid&#8209;connect** repository on GitHub.

### Revision History

- Version 2 (March 2020) – Updates to _Configuring NGINX Plus_ section
- Version 1 (November 2019) – Initial version (NGINX Plus Release 19)
