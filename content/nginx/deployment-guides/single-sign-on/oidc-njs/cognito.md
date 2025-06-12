---
description: Enable OpenID Connect-based single-sign for applications proxied by NGINX
  Plus, using Amazon Cognito as the identity provider (IdP).
docs: DOCS-464
type:
- how-to
title: Single Sign-On with Amazon Cognito and njs
toc: false
weight: 100
product: NGINX-PLUS
---

{{< note >}} This guide applies to NGINX Plus [Release 15]({{< ref "nginx/releases.md#r15" >}}) and later, based on the [`nginx-openid-connect`](https://github.com/nginxinc/nginx-openid-connect) GitHub repo. Starting with NGINX Plus [Release 34]({{< ref "nginx/releases.md#r34" >}}), use the simpler solution with the [native OpenID connect module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html).

See [Single Sign-On With Amazon Cognito]({{< ref "nginx/deployment-guides/single-sign-on/cognito.md" >}}) for details.{{< /note >}}

This guide explains how to enable single sign‑on (SSO) for applications being proxied by F5 NGINX Plus. The solution uses OpenID Connect as the authentication mechanism, with [Amazon Cognito](https://aws.amazon.com/cognito/) as the identity provider (IdP), and NGINX Plus as the relying party.

{{< see-also >}}{{< readfile file="includes/nginx-openid-repo-note.txt" markdown="true" >}}{{< /see-also >}}


<span id="prereqs"></span>
## Prerequisites

The instructions assume you have the following:

- An [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).
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

<span id="cognito"></span>
## Configuring Amazon Cognito

**Note:** The following procedure reflects the Cognito GUI at the time of publication, but the GUI is subject to change. Use this guide as a reference and adapt to the current Cognito GUI as necessary.

Create a new application for NGINX Plus in the Cognito GUI:

1. Log in to your AWS account, open the AWS Management Console ([console.aws.amazon.com](https://console.aws.amazon.com)), and navigate to the Cognito dashboard (you can, for example, click **Cognito** in the **Security, Identity, & Compliance** section of the **Services** drop‑down menu).

2. On the Cognito dashboard, click **Manage User Pools** to open the **Your User Pools** window. Click the <span style="background-color:#479bd4; color:white; white-space: nowrap;"> Create a user pool </span> button or the highlighted phrase.

   <img src="/nginx/images/cognito-sso-your-user-pools.png" alt="" width="1024" height="212" class="aligncenter size-full wp-image-63792" />

3. In the **Create a user pool** window that opens, type a value in the **Pool name** field (in this guide, it's {{<nb>}}**nginx-plus-pool**{{</nb>}}), then click the <span style=" color:#479bd4; font-weight: bold; white-space: nowrap;">Review defaults</span> button.

   <img src="/nginx/images/cognito-sso-create-name-tab.png" alt="" width="1024" height="808" class="aligncenter size-full wp-image-63953" />

   <span id="cognito-review-tab"></span>
4. On the **Review** tab which opens, click <span style=" color:#479bd4; font-weight: bolder; white-space: nowrap;">Add app client...</span> in the **App clients** field near the bottom.

   <img src="/nginx/images/cognito-sso-create-review-tab.png" alt="" width="1024" height="677" class="aligncenter size-full wp-image-63789" />

5. On the **App clients** tab which opens, click <span style=" color:#479bd4; font-weight: bolder; white-space: nowrap;">Add an app client</span>.

6. On the **Which app clients will have access to this user pool?** window which opens, enter a value (in this guide, {{<nb>}}**nginx-plus-app**{{</nb>}}) in the {{<nb>}}**App client name**{{</nb>}} field. Make sure the {{<nb>}}**Generate client secret**{{</nb>}} box is checked, then click the <span style="background-color:#479bd4; color:white; white-space: nowrap;"> Create app client </span> button.

   <img src="/nginx/images/cognito-sso-create-app-clients-tab.png" alt="" width="1024" height="942" class="aligncenter size-full wp-image-63788" />

7. On the confirmation page which opens, click {{<nb>}}**Return to pool details**{{</nb>}} to return to the **Review** tab. On that tab click the <span style="background-color:#479bd4; color:white; white-space: nowrap;"> Create pool </span> button at the bottom. (The screenshot in [Step 4](#cognito-review-tab) shows the button.)

   <span id="cognito-pool-id"></span>
8. On the details page which opens to confirm the new user pool was successfully created, make note of the value in the **Pool Id** field; you will add it to the NGINX Plus configuration in [Step 3 of _Configuring NGINX Plus_](#nginx-plus-variables).

   <img src="/nginx/images/cognito-sso-config-general-settings-tab.png" alt="'General settings' tab in Amazon Cognito GUI" width="1024" height="435" class="aligncenter size-full wp-image-63787" />

   <span id="cognito-users"></span>
9. Click {{<nb>}}**Users and groups**{{</nb>}} in the left navigation column. In the interface that opens, designate the users (or group of users, on the **Groups** tab) who will be able to use SSO for the app being proxied by NGINX Plus. For instructions, see the Cognito documentation about [creating users](https://docs.aws.amazon.com/cognito/latest/developerguide/how-to-create-user-accounts.html), [importing users](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-using-import-tool.html), or [adding a group](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html).

   <img src="/nginx/images/cognito-sso-config-users-tab.png" alt="'Users and groups' tab in Amazon Cognito GUI" width="1023" height="466" class="aligncenter size-full wp-image-63786" />

10. Click **App clients** in the left navigation bar. On the tab that opens, click the <span style=" color:#479bd4; font-weight: bold; white-space: nowrap;">Show Details</span> button in the box labeled with the app client name (in this guide, {{<nb>}}**nginx-plus-app**{{</nb>}}).

    <img src="/nginx/images/cognito-sso-config-app-clients-tab.png" alt="'App clients' tab in Amazon Cognito GUI" width="1024" height="497" class="aligncenter size-full wp-image-63785" />

    <span id="cognito-app-client-id-secret"></span>
11. On the details page that opens, make note of the values in the {{<nb>}}**App client id**{{</nb>}} and {{<nb>}}**App client secret**{{</nb>}} fields. You will add them to the NGINX Plus configuration in [Step 3 of _Configuring NGINX Plus_](#nginx-plus-variables).

    <img src="/nginx/images/cognito-sso-config-app-clients-details.png" alt="" width="1024" height="672" class="aligncenter size-full wp-image-63784" />

12. Click {{<nb>}}**App client settings**{{</nb>}} in the left navigation column. In the tab that opens, perform the following steps:

    1. In the {{<nb>}}**Enabled Identity Providers**{{</nb>}} section, click the {{<nb>}}**Cognito User Pool**{{</nb>}} checkbox (the **Select all** box gets checked automatically).
    2. In the **Callback URL(s)** field of the {{<nb>}}**Sign in and sign out URLs**{{</nb>}} section, type the URI of the NGINX Plus instance including the port number, and ending in **/\_codexch**. Here we’re using {{<nb>}}**https://my-nginx-plus.example.com:443/_codexch**{{</nb>}}.

       **Notes:**

       - For production, we strongly recommend that you use SSL/TLS (port 443).
       - The port number is mandatory even when you're using the default port for HTTP (80) or HTTPS (443).

    3. In the **OAuth 2.0** section, click the {{<nb>}}**Authorization code grant**{{</nb>}} checkbox under {{<nb>}}**Allowed OAuth Flows**{{</nb>}} and the **email**, **openid**, and **profile** checkboxes under {{<nb>}}**Allowed OAuth Scopes**{{</nb>}}.
    4. Click the <span style="background-color:#479bd4; color:white; white-space: nowrap;"> Save changes </span> button.

    <img src="/nginx/images/cognito-sso-config-app-client-settings-tab.png" alt="" width="1024" height="1181" class="aligncenter size-full wp-image-63783" />

    <span id="cognito-domain-name"></span>
13. Click **Domain name** in the left navigation column. In the tab that opens, type a domain prefix in the **Domain prefix** field under {{<nb>}}**Amazon Cognito domain**{{</nb>}} (in this guide, {{<nb>}}**my-nginx-plus**{{</nb>}}). Click the <span style="background-color:#479bd4; color:white; white-space: nowrap;"> Save changes </span> button.

    <img src="/nginx/images/cognito-sso-config-domain-name-tab.png" alt="" width="1024" height="817" class="aligncenter size-full wp-image-63782" />

<span id="nginx-plus"></span>
## Configuring NGINX Plus

Configure NGINX Plus as the OpenID Connect relying party:

1. Create a clone of the {{<nb>}}[**nginx-openid-connect**](https://github.com/nginxinc/nginx-openid-connect){{</nb>}} GitHub repository.

   ```shell
   git clone https://github.com/nginxinc/nginx-openid-connect
   ```

2. Copy these files from the clone to **/etc/nginx/conf.d**:

   - **frontend.conf**
   - **openid_connect.js**
   - **openid_connect.server\_conf**

   <span id="nginx-plus-variables"></span>
3. In your preferred text editor, open **/etc/nginx/conf.d/frontend.conf**. Change the second parameter of each of the following [set](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set) directives to the specified value.

   The `<My-Cognito-Domain-Name>` variable is the full value in the **Domain prefix** field in [Step 13 of _Configuring Amazon Cognito_](#cognito-domain-name). In this guide it is {{<nb>}}**https://my-nginx-plus.auth.us-east-2.amazoncognito.com**{{</nb>}}.

   - `set $oidc_authz_endpoint` – `<My-Cognito-Domain-Name>/oauth2/authorize`
   - `set $oidc_token_endpoint` – `<My-Cognito-Domain-Name>/oauth2/token`
   - `set $oidc_client` – Value in the {{<nb>}}**App client id**{{</nb>}} field from [Step 11 of _Configuring Amazon Cognito_](#cognito-app-client-id-secret) (in this guide, `2or4cs8bjo1lkbq6143tqp6ist`)
   - `set $oidc_client_secret` – Value in the {{<nb>}}**App client secret**{{</nb>}} field from [Step 11 of _Configuring Amazon Cognito_](#cognito-app-client-id-secret) (in this guide, `1k63m3nrcnu...`)
   - `set $oidc_hmac_key` – A unique, long, and secure phrase

4. Configure the JWK file. The file's URL is

   <span style="white-space: nowrap;">**https://cognito-idp.**_region_**.amazonaws.com/**_User-Pool-ID_**/.well-known/jwks.json**</span>

   where

   - _region_ is the same AWS region name as in the <span style="white-space: nowrap;">`<My-Cognito-Domain-Name>`</span> variable used in [Step 3](#nginx-plus-variables)
   - _User-Pool-ID_ is the value in the **Pool Id** field in [Step 8 of _Configuring Amazon Cognito_](#cognito-pool-id)

   In this guide, the URL is

   {{<nb>}}**https://cognito-idp.us-east-2.amazonaws.com/us-east-2_mLoGHJpOs/.well-known/jwks.json**{{</nb>}}.

   The method for configuring the JWK file depends on which version of NGINX Plus you are using:

   - In <span style="white-space: nowrap;">NGINX Plus R17</span> and later, NGINX Plus can read the JWK file directly. Change **/etc/nginx/conf.d/frontend.conf** as follows:

      1. Comment out (or remove) the [auth_jwt_key_file](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) directive.
      2. Uncomment the [auth_jwt_key_request](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directive. (Its parameter, `/_jwks_uri`, refers to the value of the `$oidc_jwt_keyfile` variable, which you set in the next step.)
      3. Change the second parameter of the `set $oidc_jwt_keyfile` directive to the URL of the JWK file (`https://cognito-idp.../.well-known/jwks.json`).

   - In <span style="white-space: nowrap;">NGINX Plus R16</span> and earlier, the JWK file must be on the local disk. (You can also use this method with <span style="white-space: nowrap;">NGINX Plus R17</span> and later if you wish.)

      1. Copy the JSON contents from the JWK file (**<https://cognito-idp.../.well-known/jwks.json>**) to a local file (for example, **/etc/nginx/my\_cognito\_jwk.json**).
      2. In **/etc/nginx/conf.d/frontend.conf**, change the second parameter of the `set $oidc_jwt_keyfile` directive to the local file path.

5. At the time of publication, Cognito does not support the OpenID  **offline_access** scope. Open **/etc/nginx/conf.d/openid\_connect.server\_conf** in a text editor and remove `+offline_access` from the list of scopes on line 10, so that it looks like this:

   ```nginx
   return 302 "$oidc_authz_endpoint?response_type=code&scope=openid+profile+email&client_id=$oidc_clientaws...;
   ```

6. Confirm that the user named by the [user](http://nginx.org/en/docs/ngx_core_module.html#user) directive in the NGINX Plus configuration (in **/etc/nginx/nginx.conf** by convention) has read permission on the JWK file.

<span id="testing"></span>
## Testing

In a browser, enter the address of your NGINX Plus instance and try to log in using the credentials of a user assigned to the application (see [Step 9 in _Configuring Amazon Cognito_](#cognito-users)). The NGINX logo that appears in the screenshot was added on Cognito's **UI customization** tab (not shown in this guide).

<img src="/nginx/images/cognito-sso-login.png" alt="" width="734" height="864" class="aligncenter size-full wp-image-63793" />

<span id="troubleshooting"></span>
## Troubleshooting

See the [**Troubleshooting**](https://github.com/nginxinc/nginx-openid-connect#troubleshooting) section at the {{<nb>}}**nginx-openid-connect**{{</nb>}} repository on GitHub.

### Revision History

- Version 1 (March 2020) – Initial version (NGINX Plus Release 20)
