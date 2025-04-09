---
description: Learn how to enable Single Sign-On for Developer Portal.
docs: DOCS-928
title: Enable Single Sign-On for Developer Portal
toc: true
weight: 400
type:
- how-to
---

{{< raw-html >}}
<style>
    h2 {
        margin-top: 30px;
    }
    h3 {
        margin-top: 30px;
    }
    h4 {
        font-weight: bold;
        margin-top: 30px;
    }
    hr {
        margin-top: 40px; margin-bottom: 40px;
    }

</style>
{{< /raw-html >}}

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

Single sign-on (SSO) can be enabled on the Developer Portal to secure access to the portal and to allow authenticated API consumers to manage resource credentials. Logged-in consumers can then self-manage resource credentials for the APIs.

Single sign-on is enabled by applying an OpenID Connect (OIDC) policy on the Developer Portal. The OIDC policy sets up the portal proxy to act as a relying party to authenticate users with the OIDC provider.

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running. See [API Connectivity Manager Install Guide]({{< ref "/nim/deploy/_index.md" >}}).
- You have one or more Environments with [API Gateways]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}) or [Developer Portals]({{< ref "/nms/acm/getting-started/add-devportal" >}}).

### Terminology

The following terminology is used in this topic:

{{<bootstrap-table "table table-striped table-bordered">}}

| Term                     | Description                                                                                                                                                                                                                                                                                                                  |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AuthCode                 | Authorization Code.                                                                                                                                                                                                                                                                                                          |
| IDP                      | Identity Provider stores and verifies a user's identity as a service.                                                                                                                                                                                                                                                        |
| IDP Authorization Server | The IDP Authorization Server authenticates and issues access tokens to users.                                                                                                                                                                                                                                                |
| OAuth                    | OAuth is an open-standard authorization protocol.                                                                                                                                                                                                                                                                            |
| OIDC                     | OpenID Connect is an authentication protocol that adds an identity verification layer.                                                                                                                                                                                                                                       |
| PKCE                     | Proof Key for Code Exchange. When public clients request Access Tokens, some additional security concerns are posed that are not mitigated by the Authorization Code Flow alone. PKCE needs the clients app to provide proof to the authorization server, to verify that the authorization code belongs to the clients' app. |
| URI                      | Uniform Resource Indicator. It is a unique character sequence which distinguishes one resource from another.                                                                                                                                                                                                                 |

{{</bootstrap-table>}}

### Supported OIDC Identity Providers

API Connectivity Manager supports all of the same identity providers as F5 NGINX Plus. The following guides describe how to configure NGINX Plus for these identity providers, and outline where to find the information you'll need to configure them for OIDC.

- [Auth0](/nginx/deployment-guides/single-sign-on/auth0/)
- [Amazon Cognito](/nginx/deployment-guides/single-sign-on/cognito)
- [Keycloak](/nginx/deployment-guides/single-sign-on/keycloak)
- [Microsoft Active Directory FS](/nginx/deployment-guides/single-sign-on/active-directory-federation-services)
- [Okta](/nginx/deployment-guides/single-sign-on/okta)
- [OneLogin](/nginx/deployment-guides/single-sign-on/onelogin)
- [Ping Identity](/nginx/deployment-guides/single-sign-on/ping-identity)

## Set up OIDC Policy

You can set up OIDC policy by using either the web interface or the REST API.

### Updating OIDC Policy

{{<tabs name="Setup_OIDC_Policy">}}
    {{%tab name="Web Interface"%}}

1. In the API Connectivity Manager user interface, go to **Infrastructure > Workspaces > Environments** and select the **Edit Advanced Config** from the **Actions** menu for the cluster you want to set up.
2. Select the **Global Policies** tab.
3. For **OpenID Connect Relying Party** select **Add Policy** from the policy's **Actions** menu.
4. Update **Application Settings**.

{{< include "acm/how-to/update-application-settings.md" >}}

5. Update **Authorization Server Settings**

{{< include "acm/how-to/update-authorization-server-settings.md" >}}

6. Update **General Settings**

{{< include "acm/how-to/update-general-settings.md" >}}

7. Update **Custom Error Handling**.

   You can customize how the proxy should handle the following error conditions:

   - when Client ID is not supplied
   - when there is no match for the Client ID

   Specify the HTTP error code in the box next to the error condition. The specified error code will be displayed when the related error condition is true.

8. Select **Add**.
9. Select **Save and Submit** your changes.

    {{%/tab%}}
    {{%tab name="REST API"%}}

1. Send a POST request to add the OIDC policy to the cluster.


   {{<bootstrap-table "table">}}

   | Method      | Endpoint |
   |-------------|----------|
   | POST | `/api/v1/infrastructure/workspaces/{{proxyWorkspaceName}}/environments`|



 {{</bootstrap-table>}}


    ```json
    {
        "name": "test",
        "type": "NON-PROD",
        "functions": [
            "DEVPORTAL"
        ],
        "systemProperties": {
            "acmHostName": "<NMS_FQDN>"
        },
        "proxies": [...],
                "policies": {
                    "oidc-authz": [
                        {
                            "action": {
                                "config": {
                                    "jwksURI": "https://<IDP Authorization server>/v1/keys",
                                    "tokenEndpoint": "https://<IDP Authorization server>/v1/token",
                                    "userInfoEndpoint": "https://<IDP Authorization server>/v1/userinfo",
                                    "authorizationEndpoint": "https://<IDP Authorization server>/v1/authorize",
                                    "logOffEndpoint": "https://<IDP Authorization server>/v1/logout",
                                    "authFlowType": "PKCE"
                                }
                            },
                            "data": [
                                {
                                    "appName": "Myapp",
                                    "clientID": "<clientid>",
                                    "scopes": "apigw+openid+profile+email+offline_access"
                                }
                            ]
                        }
                    ]
                }
            }
        ]
    }
    ```

    {{%/tab%}}
{{</tabs>}}

Single sign-on (SSO) is enabled on the Developer Portal after configuring the OIDC policy. Application developers can log in through the configured centralized identity provider (IDP). After a successful login, they can create resource credentials for the available APIs.

## Known Limitation with the policy

The OIDC policy does not yet support custom DNS for resolution. Only external DNS resolution is supported.
