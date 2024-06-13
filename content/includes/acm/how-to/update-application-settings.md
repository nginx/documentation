#
   {{<bootstrap-table "table table-striped table-bordered">}}


   | Variable                         | Description                                                                                                                                                                           |
   |----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
   | (Optional) Choose an OAuth Flow  | OAuth flows are authorization and authentication processes.                                                                                                                           |
   | (Optional) App Name              | Name the application.                                                                                                                                                                 |
   | Client ID                        | Client ID is a public identifier for the client that is required for all OAuth flows.                                                                                                 |
   | Client Secret                    | Client Secret is used by the client to exchange an authorization code for a token. <br> It should be an empty value with `""` when PKCE is enabled.                                   |
   | Scopes                           | List of the OAuth 2.0 scope values that this server supports. <br>For example, `openid+profile+email+offline_access`.                                                                 |
   | (Optional) Sign-Out Redirect URI | Signout Redirect URI refers to the URI the user gets redirected to after a successful logout.                                                                                         |
   | (Optional) Redirect URI          | Redirect URI is called by the IDP after successful authentication.                                                                                                                    |
   | (Optional) User Info URI         | User Info URI is called by the front end to retrieve the user's info via the IDP.                                                                                                     |
   | (Optional) Login URI             | Login URI is called by the front end for logging-in IDP using OpenID Connect.                                                                                                         |
   | (Optional) Logout URI            | Logout URI is called by the front end to handle OIDC logout with the IDP. See [RPLogout](https://openid.net/specs/openid-connect-rpinitiated-1_0.html#RPLogout) for more information. |



 {{</bootstrap-table>}}

   <!-- Do not remove. Keep this code at the bottom of the include -->
   <!-- DOCS-1007 -->
