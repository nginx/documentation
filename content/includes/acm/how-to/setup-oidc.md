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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1006 -->