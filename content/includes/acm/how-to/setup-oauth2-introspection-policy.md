You can set up OAuth2 Introspection policy by using either the web interface or the REST API.

### Edit the API-Proxy Settings

{{<tabs name="setup_introspection_policy">}}
 {{%tab name="Web Interface"%}}

1. In the API Connectivity Manager user interface, select **Services > API Proxies**click the **...** icon in the **Actions** column for the API proxy that you want to enable the OAuth2 Introspection policy for, select **Edit Proxy**.
2. Under the **Advanced** section select **Policies**.
3. Under the **API Proxy** tab, locate the **OAuth2 Introspection** policy and click the **...** icon, select **Add Policy**.
4. Update **Client Request** settings.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Specifies the token's location in incoming user request | Specifies where the access token is supplied in the incoming user request and the key from which the access token can be extracted. The default behavior is as a Bearer token in the Authorization request header. |

{{</bootstrap-table>}}

5. Update **Introspection Request** settings.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|-------------------------------------------------------- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Enter the introspection endpoint | The IdP OAuth2 Token Introspection endpoint [[RFC 7662]](https://www.rfc-editor.org/rfc/rfc7662) where NGINX IdP client will send client `access_token`. |
| Enable SNI | Enables or disables passing of the server name through TLS Server Name Indication extension (SNI), [[RFC 6066]](https://www.rfc-editor.org/rfc/rfc6066) when establishing a connection with the proxied HTTPS server. |
| Override the default server name | Allows overriding the server name used to verify the certificate of the proxied HTTPS server and to be passed through SNI when establishing a connection with the proxied HTTPS server. By default, the host part of the `proxy_pass` URL is used. |

{{</bootstrap-table>}}

6. Update **Credentials**.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|----------------------------- |--------------------------------------------------------------------------|
| Enter Client Application ID | Identifies the IdP Client making the token introspection request. |
| Enter Client Secret/Password | The IdP Client secret/password. |

{{</bootstrap-table>}}

7. Update **Introspection Response** settings.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|-------------------------------------------------------- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Specify the introspection response type | Whether the token introspection endpoint should respond with a JSON object or JSON Web Token (JWT). The default is application/json. |
| Specify the list of claims to forward as headers to the backend | Forward claims from the token introspection response in the proxy header to the backend service. <br><br>Can only be applied if the introspection response is configured to application/json. |
| Enable JWT token forwarding to backend | Forward introspection token response to backend service. <br><br>Can only be applied if the introspection response is configured to application/jwt. |
| Specify how long introspected tokens will be cached | Specifies how long the introspected tokens will be cached. Tokens will be refreshed from the URI endpoint after the duration. Set as **0** to disable. <br><br>Follows [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html). |
| Specify OAuth2 Token Type Hint | A hint about the token type submitted for introspection. The protected resource can pass this parameter to help the authorization server optimize the token lookup. Values for this field are defined in [[RFC6749]](https://www.rfc-editor.org/rfc/rfc6749). |

{{</bootstrap-table>}}

8. Enable Introspection Token **Claim Verification**. To add a claim to verify click **+ Add a claim**, to add more than one claim to verify click the same symbol. To delete a claim click the **trash can** symbol for that claim.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|------ |---------------------------------------------------------------|
| Claim | The claim name. If the claim is nested, layers of depth are indicated with periods, example: `resource_access.account.roles`. |
| Type | The claim data type. |
| Delimiter | The claim value delimiter if value is a delimited string. |
| Value | The claim value to verify. |

{{</bootstrap-table>}}

9. Enable **Resolver** if external DNS required.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|---------------------- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Time Out | By default, NGINX caches answers using the TTL value of a response. The valid parameter allows overriding it. <br><br>Follows [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html). |
| Valid For | Sets a timeout for name resolution. <br><br>Follows [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html). |
| Hostname | The DNS Hostname or IP Address. Multiple DNS Resolvers can be added for a given OAuth2 Introspection Policy. |
| Listened Port | The DNS Port number |

{{</bootstrap-table>}}

10. Update **Error Handling**.

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration Setting | Description |
|---------------------------------------------------- |-------------------------------------------------------------------------------------------------------------------------------------- |
| Specify authorization failed error code | The error code that needs to be used by the NGINX data plane when the backend service cannot find a token match or access is forbidden. |
| Specify authorization token not provided error code | The error code that needs to be used by the NGINX data plane when the backend service when a token is not supplied. |

{{</bootstrap-table>}}

11. Select **Add**.
12. Select **Save and Submit**.

 {{%/tab%}}
 {{%tab name="REST API"%}}

Send a POST request to add the OAuth2 Introspection policy to the API-Proxy.


{{<bootstrap-table "table">}}

| Method | Endpoint |
|--------|---------------------------------------------------------|
| POST | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


{{< note >}} While all request body configuration values are presented in the request body structure example below, not all configuration
    values are compatible. Please see the configuration value description table for further information. {{< /note >}}

<details open>
<summary>JSON request</summary>

```json
{
   "name": "{{proxyName}}",
   "version": "v1",
   "proxyConfig": {
       "hostname": "{{environmentHostname}}",
       "ingress": {
           "basePath": "/api"
       },
       "backends": [
           {
               "serviceName": "backend-svc",
               "serviceTargets": [
                   {
                       "hostname": "10.0.0.10"
                   }
               ]
           }
       ],
       "policies": {
           "oauth2-introspection": [
               {
                   "action": {
                       "introspectionEndpoint": "https://example.idp.com:8443/oauth/v2/oauth-introspect",
                       "enableSNI": true,
                       "proxyTLSName": "test.oauth.com",
                       "introspectionResponse": "application/json",
                       "cacheIntrospectionResponse": "5m",
                       "clientTokenSuppliedIn": "HEADER",
                       "clientTokenName": "Authorization",
                       "authzServerTokenHint": "ACCESS_TOKEN",
                       "forwardToken": false,
                       "forwardedClaimsInProxyHeader": [
                           "username",
                           "exp",
                           "scope"
                       ],
					   "verifyClaims": [
						   {
							   "claim": "sub",
							   "type": "STRING",
							   "value": "a95117bf-1a2e-4d46-9c44-5fdee8dddd11"
						   },
						   {
							   "claim": "scope",
							   "type": "STRING",
							   "value": "read write email",
							   "delimiter": "SPACE"
						   },
						   {
							   "claim": "aud",
							   "type": "ARRAY",
							   "value": ["https://protected.example.net/resource"]
						   },
						   {
							   "claim": "resource_access.account.groups",
							   "type": "STRING",
							   "value": "default-group"
						   },
						   {
							   "claim": "resource_access.account.roles",
							   "type": "ARRAY",
							   "value": [
								   "default-roles",
								   "offline_access",
							   ]
						   },
						   {
							   "claim": "email_verified",
							   "type": "BOOLEAN",
							   "value": true
						   },
						   {
							   "claim": "user-group",
							   "type": "INTEGER",
							   "value": 42
						   }
					   ],
                       "resolver": {
                           "valid": "30s",
                           "timeout": "30s",
                           "servers": [
                               {
                                   "hostname": "example.com"
                               },
                               {
                                   "hostname": "10.0.0.11",
                                   "port": 53
                               }
                           ]
                       },
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
                           "clientAppID": "idp-client-app-id",
                           "clientSecret": "dbdaa3e1-f100-420x-bfd0-875bd8a77cd7"
                       }
                   ]
               }
           ]
       }
   }
}
```

</details>


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field | Datatype | Possible Values | Description | Required | Default value |
|--------------------------------------- |------------------ |---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |---------- |-------------------------------------------- |
| `introspectionEndpoint` | string | Example: <br>`"https://idp.com/introspect"` | The IdP OAuth2 Token Introspection endpoint [[RFC 7662]](https://www.rfc-editor.org/rfc/rfc7662) where NGINX IdP client will send client `access_token`. | True | N/A |
| `enableSNI` | boolean | `true`/`false` | Enables or disables passing of the server name through TLS Server Name Indication extension (SNI), [[RFC 6066]](https://www.rfc-editor.org/rfc/rfc6066) when establishing a connection with the proxied HTTPS server. | False | `false` |
| `proxyTLSName` | string | Example: `test.oauth.com` | Allows overriding the server name used to verify the certificate of the proxied HTTPS server and to be passed through SNI when establishing a connection with the proxied HTTPS server. By default, the host part of the `proxy_pass` URL is used. | False | Host part of `introspectionRequest` |
| `introspectionResponse` | string | One of: <br>[`"application/json"`, <br>`"application/jwt"`] | Whether the token introspection endpoint should respond with a JSON object or JSON Web Token (JWT). | False | `"application/json"` |
| `cacheIntrospectionResponse` | string | Example: `"5m"` | Specifies how long the introspected tokens will be cached. Tokens will be refreshed from the URI endpoint after the duration. Set as `0s-m-h` to disable. <br><br>Follows [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html). | False | `"5m"` |
| `clientTokenSuppliedIn` | string | One of: <br>[`"HEADER"`, `"QUERY"`] | Specifies where the access token is supplied in the incoming user request. | False | `"HEADER"` |
| `clientTokenName` | string | Example: <br>`"Authorization"` | Specifies the key under which the access token can be extracted from in the incoming user request. <br><br>Note: To maintain Bearer token behavior, `clientTokenSuppliedIn` must be set to `HEADER`, and `clientTokenName` must be set to `Authorization`. This is the default behavior of the Introspection Policy. | False | `"Authorization"` |
| `authzServerTokenHint` | string | One of: <br>[`"ACCESS_TOKEN"`, <br>`"REFRESH_TOKEN"`] | A hint about the type of the token submitted for introspection. The protected resource can pass this parameter to help the authorization server optimize the token lookup. Values for this field are defined in [[RFC6749]](https://www.rfc-editor.org/rfc/rfc6749). | False | N/A |
| `forwardToken` | boolean | `true`/`false` | Forward introspection token response to backend service. <br><br>Can only be applied if the `introspectionResponse` is set to `application/jwt`. | False | `true` |
| `forwardedClaimsInProxyHeader` | array of strings | Standard claims can be found in <br>_OAuth2 Token Introspection_ <br>[[RFC 7662]](https://www.rfc-editor.org/rfc/rfc7662). <br><br>This is not an exhaustive list, <br>IdPs and Resource Owners can <br>configure their own claims. | Forward claims from the token introspection response in the proxy header to the backend service. <br><br>Can only be applied if the `introspectionResponse` is set to `application/json`. | False | `["scope",` <br>`"username",` <br>`"exp"]` |
| `verifyClaims[].claim` | string | Example: <br>`"resource_access.account.roles"`  | The claim name. If the claim is nested, layers of depth are indicated with periods. | True | N/A |
| `verifyClaims[].type` | string | One of: <br>[`"STRING"`, `"ARRAY"`, `"BOOLEAN"`, `"INTEGER"`] | The claim data type. | True | N/A |
| `verifyClaims[].delimiter` | string | One of: <br>[`"SPACE"`, `"COMMA"`, `"PERIOD"`, `"PLUS"`, `"COLON"`, `"SEMI-COLON"`, `"VERTICAL-BAR"`, `"FORWARD-SLASH"`, `"BACK-SLASH"`, `"HYPHEN"`, `"UNDERSCORE"`] | The claim value delimiter if value is a delimited string. | Semi-Optional | N/A |
| `verifyClaims[].value` | - | Examples: <br>`"test-user-1"` <br>`"read write email"` <br>`["default-roles","offline_access"]` <br>`42` <br>`true` | The claim value to verify. | True | N/A |
| `resolver.valid` | string | Example: `"30s"` | By default, NGINX caches answers using the TTL value of a response. The `valid` parameter allows overriding it. <br><br>Follows [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html). | False | `"30s"` |
| `resolver.timeout` | string | Example: `"30s"` | Sets a timeout for name resolution. <br><br>Follows [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html). | False | `"30s"` |
| `resolver.servers[].hostname` | string | Valid hostname or IP Address | The DNS Hostname. | True | N/A |
| `resolver.servers[].port` | int32 | Valid 32-bit integer | The DNS Port number. | False | N/A |
| `errorReturnConditions.noMatch` | integer | In range: `400` - `599` | The error code that needs to be used by the NGINX data plane when the backend service cannot find a token match or access is forbidden. | False | `403` |
| `errorReturnConditions.notSuppplied` | integer | In range: `400` - `599` | The error code that needs to be used by the NGINX data plane when the backend service when a token is not supplied. | False | `401` |
| `data.clientAppID` | string | Example: <br>`"nginx-docs-client"` | Identifies the IdP Client making the token introspection request. | True | N/A |
| `data.clientSecret` | string | Example: <br>`"db3e1-f100-420x-bfd0"` | The IdP Client secret/password. | True | N/A |

{{< /bootstrap-table >}}


{{%/tab%}}
{{</tabs>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1022 -->