---
description: As an Infrastructure Administrator, use this guide to configure OpenID
  Connect policy to enable Single Sign On for the gateways.
docs: DOCS-1134
title: OpenID Connect
toc: true
weight: 910
type:
- how-to
- reference
---

---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About OpenID Connect Policy

OpenID Connect (OIDC) builds on OAuth 2.0 to offer an identity layer and a unified authentication process for securing APIs, native apps, and web applications. Clients can authenticate an end-user's identity by using an Authorization Server. End-user information is communicated using claims in a security token called an identity token.

The OpenID Connect policy for API Connectivity Manager provides users with a convenient and secure single sign-on experience, allowing them to log in to multiple OAuth-enabled applications with a single set of credentials. This policy can be easily integrated with any compatible identity provider, providing single sign-on access to both API gateways and Developer Portals.

### Intended Audience

{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## Before You Begin

Before configuring API gateways and Developer Portals as OpenID Connect relying parties (RPs), you need to gather the necessary Identity provider (IDP) details:

- IDP's well-known endpoints
- Client ID
- Client Secret (needed depending on the OAuth flow)

{{< note >}}

The Developer Portal supports both PCKE and AuthCode [authorization code flows](https://auth0.com/docs/get-started/authentication-and-authorization-flow/authorization-code-flow).

{{< /note >}}

---

## Workflow for Applying Policy

To apply the OpenID Connect (OIDC) policy or make changes to it, here's what you need to do:

- [Edit an existing environment or create a new one]({{< ref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-environment" >}}).
- Select the cluster on which to apply the policy.
- Check the advanced settings to see if the policy has been applied.
- Edit the policy as needed.
- Save and publish the changes.

---

## Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}
<table>
<thead>
<tr>
<th>Field</th>
<th>Type</th>
<th>Possible Values</th>
<th><div style="width:400px">Description</div></th>
<th>Required</th>
<th>Default</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>authFlowType</code></td>
<td>string</td>
<td><code>AUTHCODE</code><br><code>PCKE</code></td>
<td>PKCE is an OAuth 2.0 security extension for public clients on mobile devices intended to avoid a malicious programme creeping into the same computer from intercepting the authorisation code.</td>
<td>No</td>
<td><code>AUTHCODE</code></td>
</tr>
<tr>
<td><code>authorizationEndpoint</code></td>
<td>string</td>
<td>Example:<br><a href="https://accounts.google.com/o/oauth2/v2/auth">https://accounts.google.com/o/oauth2/v2/auth</a></td>
<td>URL of the IdP's OAuth 2.0 Authorization Endpoint.</td>
<td>Yes</td>
<td>N/A</td>
</tr>
<tr>
<td><code>authzParams.key</code></td>
<td>string</td>
<td>Between 1 and 128 characters</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>authzParams.paramType</code></td>
<td>string</td>
<td>QUERY. PATH, HEADER</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>authzParams.value</code></td>
<td>string</td>
<td>Between 1 and 128 characters</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>errorReturnConditions.</code><br><code>noMatch.</code><br><code>returnCode</code></td>
<td>integer</td>
<td>In range <code>100-599</code></td>
<td>The error code that needs to be used by the nginx data-plane when basic auth is invalid or not supplied.</td>
<td>No</td>
<td><code>403</code></td>
</tr>
<tr>
<td><code>errorReturnConditions.</code><br><code>notSupplied.</code><br><code>returnCode</code></td>
<td>Integer</td>
<td>In range <code>100-599</code></td>
<td>The error code that needs to be used by the nginx data-plane when invalid clientID is supplied.</td>
<td>No</td>
<td><code>401</code></td>
</tr>
<tr>
<td><code>jwksURI</code></td>
<td>string</td>
<td>Example:<br><a href="https://www.googleapis.com/oauth2/v3/certs">https://www.googleapis.com/oauth2/v3/certs</a></td>
<td></td>
<td>Yes</td>
<td>N/A</td>
</tr>
<tr>
<td><code>logOffEndpoint</code></td>
<td>string</td>
<td>Example:<br><a href="https://oauth2.googleapis.com/revoke">https://oauth2.googleapis.com/revoke</a></td>
<td></td>
<td>Yes</td>
<td>N/A</td>
</tr>
<tr>
<td><code>logOutParams.key</code></td>
<td>string</td>
<td>Between 1 and 128 characters</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>logOutParams.paramType</code></td>
<td>string</td>
<td>QUERY, PATH, HEADER</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>logOutParams.value</code></td>
<td>string</td>
<td>Between 1 and 512 characters</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>resolver.enableIPv6</code></td>
<td>boolean</td>
<td>true/false</td>
<td></td>
<td>No</td>
<td>false</td>
</tr>
<tr>
<td><code>resolver.servers.hostname</code></td>
<td>string</td>
<td>Between 1 and 253 characters</td>
<td></td>
<td>Yes</td>
<td>N/A</td>
</tr>
<tr>
<td><code>resolver.servers.port</code></td>
<td>integer</td>
<td>In range <code>1-65535</code></td>
<td></td>
<td>Yes</td>
<td>80</td>
</tr>
<tr>
<td><code>resolver.timeout</code></td>
<td>string</td>
<td>Example: 30s<br>Between 2 and 14 characters</td>
<td></td>
<td>No</td>
<td>30s</td>
</tr>
<tr>
<td><code>resolver.valid</code></td>
<td>string</td>
<td>Example: 24s<br>Between 2 and 14 characters</td></td>
<td></td>
<td>No</td>
<td>30s</td>
</tr>
<tr>
<td><code>returnTokenToClientOnLogin</code></td>
<td>string</td>
<td>id_token, none</td>
<td>Optionally return token as a query param to the app after successful login.</td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>tokenEndpoint</code></td>
<td>string</td>
<td>Example:<br><a href="https://oauth2.googleapis.com/token">https://oauth2.googleapis.com/token</a></td>
<td>URL of the IdP's OAuth 2.0 Token Endpoint.</td>
<td>Yes</td>
<td>N/A</td>
</tr>
<tr>
<td><code>tokenParams.key</code></td>
<td>string</td>
<td>Between 1 and 128 characters</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>tokenParams.paramType</code></td>
<td>string</td>
<td>QUERY, PATH, HEADER</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>tokenParams.value</code></td>
<td>string</td>
<td>Between 1 and 512 characters</td>
<td></td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>uris.loginURI</code></td>
<td>string</td>
<td>Example: <code>/login</code></td>
<td>This location is called by frontend for logging-in IDP using OpenID Connect.</td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>uris.logoutURI</code></td>
<td>string</td>
<td>Example: <code>/logout</code></td>
<td>This location is called by UI to handle OIDC logout with IDP as per: https://openid.net/specs/openid-connect-rpinitiated-1_0.html#RPLogout</td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>uris.redirectURI</code></td>
<td>string</td>
<td>Example: <code>/_codexch</code></td>
<td>This location is called by the IdP after successful authentication.</td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>uris.userInfoURI</code></td>
<td>string</td>
<td>Example: <code>/userinfo</code></td>
<td>This location is called by frontend to retrieve user info via the IDP.</td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>userInfoEndpoint</code></td>
<td>string</td>
<td>Example:<br><a href="https://openidconnect.googleapis.com/v1/userinfo">https://openidconnect.googleapis.com/v1/userinfo</a></td>
<td>URL of the IdP's UserInfo Endpoint.</td>
<td>Yes</td>
<td>N/A</td>
</tr>
<tr>
<td><code>userRegistration</code></td>
<td>string</td>
<td></td>
<td>User registration URLs, can be used to specify customer or workforce registration URLs.</td>
<td>No</td>
<td>N/A</td>
</tr>
<tr>
<td><code>wellKnownEndpoint</code></td>
<td>string</td>
<td>Example:<br><a href="https://accounts.google.com/.well-known/openid-configuration">https://accounts.google.com/.well-known/openid-configuration</a></td>
<td>OIDC .well-known configuration endpoint. The well-known endpoint returns OpenID Connect metadata about the authorization server.</td>
<td>No</td>
<td>N/A</td>
</tr>
</tbody>
</table>


{{</bootstrap-table>}}


---

You can set up an OIDC policy by using either the web interface or the REST API.

## Applying the Policy

{{<tabs name="apply_policy">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To apply the OpenID Connect policy using the REST API, send an HTTP `POST` request to the Environments endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                              |
|--------|-----------------------------------------------------------------------|
| POST   | `/api/v1/infrastructure/workspaces/{proxyWorkspaceName}/environments` |

{{</bootstrap-table>}}


<detals>
<summary>JSON request</summary>

```json
{
  "policies": {
    "oidc-authz": [
      {
        "action": {
          "authFlowType": "PKCE",
          "authorizationEndpoint": "https://<IDP Domain>/v1/Authorize",
          "jwksURI": "https://<IDP Domain>/v1/keys",
          "logOffEndpoint": "https://<IDP Domain>/v1/logout",
          "tokenEndpoint": "https://<IDP Domain>/v1/Token",
          "userInfoEndpoint": "https://<IDP Domain>/v1/userinfo",
          "uris": {
            "loginURI": "/login",
            "logoutURI": "/logout",
            "redirectURI": "/_codexch",
            "userInfoURI": "/userinfo"
          },
          "returnTokenToClientOnLogin": "none",
          "forwardTokenToBackend": "access_token",
          "errorReturnConditions": {
            "noMatch": {
              "returnCode": 403
            },
            "notSupplied": {
              "returnCode": 401
            }
          }
        },
        "data": [
          {
            "clientID": "myclientID1234",
            "scopes": "email+openid+profile"
          }
        ]
      }
    ]
  }
}
```

This JSON defines an OpenID Connect (OIDC) authorization policy. It specifies the URL endpoints for the authorization, token, and user info services, as well as the URIs for login, logout, and redirect activities. It also defines that the client ID and scopes are "myclientID1234" and "email+openid+profile", respectively. Additionally, it specifies how to handle errors, such as returning a 403 code when there is no match and a 401 code when the data is not supplied.

</details>

{{%/tab%}}

{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md" >}}
1. On the left menu, select **Infrastructure**.
1. From the list of workspaces, select the workspace for your cluster's environment.
1. From the list of environments, select the environment for your cluster.
1. From the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Advanced Config**.
1. On the left menu, select **Global Policies**.
1. Locate the **OpenID Connect Relying Party** policy in the list of policies. On the **Actions** menu (represented by an ellipsis, `...`), select **Add Policy**.
1. In the API Connectivity Manager user interface, go to **Infrastructure > Workspaces > Environments** and select the **Edit Advanced Config** from the **Actions** menu for the cluster you want to set up.
1. Select the **Global Policies** tab.
1. For **OpenID Connect Relying Party** select **Add Policy** from the policy's **Actions** menu.
1. Update **Application Settings**.

{{< include "acm/how-to/update-application-settings.md" >}}

12. Update **Authorization Server Settings**

{{< include "acm/how-to/update-authorization-server-settings.md" >}}

13. Update **General Settings**

{{< include "acm/how-to/update-general-settings.md" >}}

14. Update **Custom Error Handling**.

   You can customize how the proxy should handle the following error conditions:

- when Client ID is not supplied
- when there is no match for the Client ID

   Specify the HTTP error code in the box next to the error condition. The specified error code will be displayed when the related error condition is true.

15. Select **Add**.
1. Select **Save and Submit** your changes.

{{%/tab%}}

{{</tabs>}}
