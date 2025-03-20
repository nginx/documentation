---
description: Enable OpenID Connect-based single-sign for applications proxied by NGINX
  Plus, using Microsoft AD FS as the identity provider (IdP).
docs: DOCS-463
title: Single Sign-On with Microsoft Active Directory FS
toc: true
weight: 100
type:
- how-to
---

This guide explains how to enable single sign-on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Microsoft Active Directory Federation Services](https://docs.microsoft.com/en-us/windows-server/identity/active-directory-federation-services) (AD FS) as the identity provider (IdP) and NGINX Plus as the relying party.

{{< see-also >}}{{< include "nginx-plus/nginx-openid-repo-note.txt" >}}{{< /see-also >}}

<span id="prereqs"></span>
## Prerequisites

The instructions assume you have the following:

- A running deployment of AD FS, either on‑premises or in Azure.
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

<span id="ad-fs"></span>
## Configuring AD FS

Create an AD FS application for NGINX Plus:

1. Open the AD FS Management window. In the navigation column on the left, right‑click on the **Application Groups** folder and select <span style="white-space: nowrap; font-weight:bold;">Add Application Group</span> from the drop‑down menu.

   The <span style="white-space: nowrap; font-weight:bold;">Add Application Group Wizard</span> window opens. The left navigation column shows the steps you will complete to add an application group.

2. In the **Welcome** step, type the application group name in the **Name** field. Here we are using <span style="color:#666666; font-weight:bolder;">ADFSSSO</span>. In the **Template** field, select **Server application** under <span style="color:#293aa3; font-weight:bolder;">Standalone applications</span>. Click the <span style="background-color:#e1e1e1; white-space: nowrap; font-weight: bolder"> Next > </span> button.

   <img src="/nginx/images/adfs-sso-welcome.png" alt="" width="734" height="597" class="aligncenter size-full wp-image-62013" />

   <span id="ad-fs-server-application"></span>
3. In the **Server application** step:

   1. Make a note of the value in the **Client Identifier** field. You will add it to the NGINX Plus configuration in [Step 4 of _Configuring NGINX Plus_](#nginx-plus-variables).<br/>

   2. In the **Redirect URI** field, type the URI of the NGINX Plus instance including the port number, and ending in **/\_codexch**. Here we’re using <span style="white-space: nowrap; color:#666666; font-weight:bolder;">https://my-nginx.example.com:443/\_codexch</span>. Click the <span style="background-color:#e1e1e1; white-space: nowrap; font-weight: bolder"> Add </span> button.

      **Notes:**

      - For production, we strongly recommend that you use SSL/TLS (port 443).
      - The port number is mandatory even when you're using the default port for HTTP (80) or HTTPS (443).

3. Click the <span style="background-color:#e1e1e1; white-space: nowrap; font-weight: bolder"> Next > </span> button.

   <img src="/nginx/images/adfs-sso-server-application.png" alt="" width="860" height="523" class="aligncenter size-full wp-image-62012" />

   <span id="ad-fs-configure-application-credentials"></span>
4. In the <span style="white-space: nowrap; font-weight:bold;">Configure Application Credentials</span> step, click the <span style="white-space: nowrap; font-weight:bold;">Generate a shared secret</span> checkbox. Make a note of the secret that AD FS generates (perhaps by clicking the <span style="white-space: nowrap; font-weight:bold;">Copy to clipboard</span> button and pasting the clipboard content into a file). You will add the secret to the NGINX Plus configuration in [Step 4 of _Configuring NGINX Plus_](#nginx-plus-variables). Click the <span style="background-color:#e1e1e1; white-space: nowrap; font-weight: bolder"> Next > </span> button.

   <img src="/nginx/images/adfs-sso-configure-application-credentials.png" alt="" width="750" height="432" class="aligncenter size-full wp-image-62011" />

5. In the **Summary** step, verify that the information is correct, make any necessary corrections to previous steps, and click the <span style="background-color:#e1e1e1; white-space: nowrap; font-weight: bolder"> Next > </span> button.


<span id="nginx-plus"></span>
## Configuring NGINX Plus

Configure NGINX Plus as the OpenID Connect relying party:

1. Create a clone of the [<span style="white-space: nowrap; font-weight:bold;">nginx-openid-connect</span>](https://github.com/nginxinc/nginx-openid-connect) GitHub repository.

   ```shell
   git clone https://github.com/nginxinc/nginx-openid-connect
   ```

2. Copy these files from the clone to **/etc/nginx/conf.d**:

   - **frontend.conf**
   - **openid\_connect.js**
   - **openid\_connect.server\_conf**
   - **openid\_connect\_configuration.conf**

   <span id="nginx-plus-urls"></span>
3. Get the URLs for the authorization endpoint, token endpoint, and JSON Web Key (JWK) file from the AD FS configuration. Run the following `curl` command in a terminal, piping the output to the indicated `python` command to output the entire configuration in an easily readable format. We've abridged the output to show only the relevant fields.

   ```shell
   $ curl https://<ADFS-server-address>/oidc/adfs/.well-known/openid-configuration | python -m json.tool
   {
    ...
       "authorization_endpoint": "https://<ADFS-server-address>/oidc/adfs/auth",
       ...
       "jwks_uri": "https://<ADFS-server-address>/oidc/adfs/certs",
       ...
       "token_endpoint": "https://<ADFS-server-address>/oidc/adfs/token",
    ...
   }
   ```

   <span id="nginx-plus-variables"></span>
4. In your preferred text editor, open **/etc/nginx/conf.d/frontend.conf**. Change the "default" parameter value of each of the following [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) directives to the specified value:

   - `map $host $oidc_authz_endpoint` – Value of `authorization_endpoint` from [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<ADFS-server-address>/oidc/adfs/auth`</span>)
   - `map $host $oidc_token_endpoint` – Value of `token_endpoint` from [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<ADFS-server-address>/oidc/adfs/token`</span>)
   - `map $host $oidc_client` – Value in the **Client ID** field from [Step 3 of _Configuring AD FS_](#ad-fs-server-application) (in this guide, <span style="white-space: nowrap;">`3e23f0eb-9329-46ff-9d37-6ad24afdfaeb`</span>)
   - `map $host $oidc_client_secret` – Value in the **Client secret** field from [Step 4 of _Configuring AD FS_](#ad-fs-configure-application-credentials) (in this guide, <span style="white-space: nowrap;">`NUeuULtSCjgXTGSkq3ZwEeCOiig4-rB2XiW_W`</span>)
   - `map $host $oidc_hmac_key` – A unique, long, and secure phrase

5. Configure the JWK file. The procedure depends on which version of NGINX Plus you are using.

   - In <span style="white-space: nowrap;">NGINX Plus R17</span> and later, NGINX Plus can read the JWK file directly from the URL reported as `jwks_uri` in [Step 3](#nginx-plus-urls). Change **/etc/nginx/conf.d/frontend.conf** as follows:

      1. Comment out (or remove) the [auth_jwt_key_file](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) directive.
      2. Uncomment the [auth_jwt_key_request](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directive. (Its parameter, `/_jwks_uri`, refers to the value of the `$oidc_jwt_keyfile` variable, which you set in the next step.)
      3. Change the second parameter of the `set $oidc_jwt_keyfile` directive to the value reported in the `jwks_uri` field in [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<ADFS-server-address>/oidc/adfs/certs`</span>).

   - In <span style="white-space: nowrap;">NGINX Plus R16</span> and earlier, the JWK file must be on the local disk. (You can also use this method with <span style="white-space: nowrap;">NGINX Plus R17</span> and later if you wish.)

       1. Copy the JSON contents from the JWK file named in the `jwks_uri` field in [Step 3](#nginx-plus-urls) (in this guide, <span style="white-space: nowrap;">`https://<ADFS-server-address>/oidc/adfs/certs`</span>) to a local file (for example, `/etc/nginx/my_adfs_jwk.json`).
       2. In **/etc/nginx/conf.d/frontend.conf**, change the second parameter of the <span style="white-space: nowrap;">`set $oidc_jwt_keyfile`</span> directive to the local file path.

6. Confirm that the user named by the [user](http://nginx.org/en/docs/ngx_core_module.html#user) directive in the NGINX Plus configuration (in **/etc/nginx/nginx.conf** by convention) has read permission on the JWK file.

<span id="testing"></span>
## Testing

In a browser, enter the address of your NGINX Plus instance and try to log in using the credentials of a user who has access to the application.

<img src="/nginx/images/adfs-sso-login.png" alt="" width="750" height="414" class="aligncenter size-full wp-image-62002" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="troubleshooting"></span>
## Troubleshooting

See the [**Troubleshooting**](https://github.com/nginxinc/nginx-openid-connect#troubleshooting) section at the <span style="white-space: nowrap; font-weight:bold;">nginx-openid-connect</span> repository on GitHub.

### Revision History

- Version 2 (March 2020) – Updates to _Configuring NGINX Plus_ section
- Version 1 (December 2019) – Initial version (NGINX Plus Release 20)
