---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  secure API Gateways by applying an OAuth2 JSON Web Token (JWT) Assertion policy.
docs: DOCS-1119
toc: true
weight: 900
title: JWT Assertion
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## OAuth2 JWT Assertion

Authentication & authorization policies allow a user to restrict access to their APIs by determining the caller's identity and access level. There are several API Gateway authentication/authorization policy types supported by API Connectivity Manager: API key authentication, basic authentication, OAuth2 JWT assertion, and OAuth2 token introspection. This guide focuses specifically on OAuth2 JWT Assertion.

[JSON Web Tokens](https://datatracker.ietf.org/doc/html/rfc7519) (JWTs, pronounced “jots”) are a compact and highly portable means of exchanging identity information. JWTs can be used for client authorization and are a better way to control access to web‑based APIs than traditional API keys. Using JWTs as API keys provides a high‑performance alternative to traditional API keys, combining best‑practice authorization technology with a standards‑based schema for exchanging identity attributes.

API Connectivity Manager API owners can restrict access to their APIs with JWTs. The API Proxy Policy can be configured to grant access to APIs only after validating a client's JWT.

{{<img src="/acm/jwt-validation-flow.png" alt="OAuth2 JWT Assertion Flow." >}}

---

## Anatomy of a JWT

JWTs have three parts: a header, a payload, and a signature. In transmission, they look like the following (line breaks have been added for readability, the actual JWT is a single string):

```jwt
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

A period (`.`) separates the header, payload, and signature. The header and payload are [Base64‑encoded](https://www.rfc-editor.org/rfc/rfc4648#section-5) JSON objects. The signature is encrypted using the algorithm specified by the alg header, which we can see when we decode our sample JWT:


{{<bootstrap-table "table">}}

|         | Encoded | Decoded |
|---------|---------|---------|
| Header  | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9` | `{`<br>&nbsp;&nbsp;&nbsp;&nbsp;`"alg": "HS256",`<br>&nbsp;&nbsp;&nbsp;&nbsp;`"typ": "JWT"`<br>`}` |
| Payload | `eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6`<br>`IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ`= | `{`<br>&nbsp;&nbsp;&nbsp;&nbsp;`"sub": "1234567890",`<br>&nbsp;&nbsp;&nbsp;&nbsp;`"name": "John Doe",`<br>&nbsp;&nbsp;&nbsp;&nbsp;`"iat": 1516239022`<br>`}` |

{{</bootstrap-table>}}


The [JWT standard](https://www.rfc-editor.org/rfc/rfc7519) defines several signature algorithms. The value HS256 in the example refers to HMAC SHA‑256. F5 NGINX Plus supports the HSxxx, RSxxx, and ESxxx [signature algorithms](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html) that are defined in the [standard](https://www.rfc-editor.org/rfc/rfc7518#section-3.1). The ability to cryptographically sign JWTs makes them ideal to be used for client authorization.

---

## How NGINX Plus Validates a JWT

A JWT is considered to be valid when the following conditions are met:

1. The signature can be verified with a local or remote [JSON Web Key](https://datatracker.ietf.org/doc/html/rfc7517) (matching on the `kid` (“key ID”), if present, and `alg` (“algorithm”) header fields).
2. The JWT is presented inside the validity period when defined by one or both of the `nbf` (“not before”) and `exp` (“expires”) claims.

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with an [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have published one or more [API Gateways]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}})

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

### How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

---

## Create an OAuth2 JWT Assertion Policy

Take the steps in this section if you would like to restrict access to APIs to clients with a valid JWT. You can set up an OAuth2 JWT Assertion policy using either the web interface or the REST API.

{{<tabs name="add_jwt_policy">}}
{{%tab name="API"%}}

Send a `POST` request to add the OAuth2 JWT Assertion policy to the API Proxy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


{{< warning >}} Local JSON Web Key usage with the policy configuration value `jwksKeys[]` is recommended for test/debugging environments only. For production environments, `jwksURI` should be used for remote JSON Web Key retrieval. {{< /warning >}}
{{< note >}} While all request body configuration values are presented in the request body structure example below, not all configuration values are compatible. See the configuration value description table for further information. {{< /note >}}

```json
{
	"policies": {
		"oauth2-jwt-assertion": [
			{
				"action": {
					"jwksURI": "https://idp.io:8443/oauth/certs",
					"cacheKeysDuration": "12h",
					"jwksKeys": [
						{
							"k": "bXlzZWNyZXQ",
							"kid": "0001",
							"kty": "oct"
						}
					],
					"tokenName": "Authorization",
					"tokenSuppliedIn": "HEADER",
					"errorReturnConditions": {
						"notSupplied": {
							"returnCode": 401
						},
						"noMatch": {
							"returnCode": 403
						}
					}
				}
			}
		]
	}
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field | Type | Possible Values | Description | Required | Default value |
|---|---|---|---|---|---|
| `jwksURI` | string | Example:<br>`https://idp.io:8443/oauth/certs` | URI endpoint that contains public keys used to verify the JWT signature.<br><br>Not required if `jwksKeys[]` is populated. | Semi-optional | N/A |
| `cacheKeysDuration` | string | Example: `12h` | Specifies how long the keys will be cached. Keys will be refreshed from the URI endpoint after the duration. <br><br>Only valid for `jwksURI`, not applicable for `jwksKeys[]`. Follows [NGINX configuration time measurement](http://nginx.org/en/docs/syntax.html) units syntax. | No | `"12h"` |
| `jwksKeys[]` | array of JSON Web Keys | Example in policy request body. | Keys to be used to verify JWT signatures. User should supply key data in valid JSON Web Key format. See related standards for [JWK](https://datatracker.ietf.org/doc/html/rfc7517), [JWK Set Format](https://datatracker.ietf.org/doc/html/rfc7517#section-5), and the [jwksKeys parameter](https://datatracker.ietf.org/doc/html/rfc7517#section-5.1).<br><br>Not required if `jwksURI` is populated. | Semi-optional | N/A |
| `tokenName` | string | Example: `Authorization` | The name of the header or query parameter where the JWT will be located in the API request.<br><br>In the case of default case of `Authorization` Header, the JWT token is required to adhere to the [Bearer Token usage](https://www.rfc-editor.org/rfc/rfc6750) standard.<br><br>Example: `Authorization: Bearer <access token>` where `<access token>}` is the Base64 encoded Client JWT. | No | `"Authorization"` |
| `tokenSuppliedIn` | string | One of: [`"HEADER"`, `"QUERY"`] | Specifies where the access token is supplied in the incoming user request. | No | `"HEADER"` |
| `errorReturnConditions`<br>`.notSupplied`<br>`.returnCode` | int | In range `400-599` | The error code that is returned from the API Proxy when an JWT is not supplied. | No | 401 |
| `errorReturnConditions`<br>`.noMatch`<br>`.returnCode` | int | In range `400-599` | The error code that is returned from the API Proxy when an invalid JWT is supplied. | No | 403 |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Services > \{your workspace}**, where "your workspace" is the workspace that contains the API Proxy.
2. Select **Edit Proxy** from the **Actions** menu for the desired API Proxy.
3. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **JSON Web Token Assertion**.
4. Choose the **JSON Web Key Set (JWKS) source**, for remote JWKS select **Enter a URI**, for local JWKS select **Enter a JWKS**.
   - For JWKS Uri enter the JWKS URI as **URI location** and specify for how long the API Proxy should **cache the keys**, set to **0** to disable.
   - For JWKS add an array of JSON Web Keys in JSON Web Key Set format. See related standards for [JWK](https://datatracker.ietf.org/doc/html/rfc7517), [JWK Set Format](https://datatracker.ietf.org/doc/html/rfc7517#section-5), and the [Keys](https://datatracker.ietf.org/doc/html/rfc7517#section-5.1) parameter. Example usage:

    ```json
    {
        "keys": [
            {
                "k": "bXlzZWNyZXQ",
                "kid": "0001",
                "kty": "oct"
            }
        ]
    }
    ```

5. Specify **how the token is presented** in the request, either in the request **Headers** or as a **Query** parameter..
6. Set custom error return code conditions if an JWT is **not supplied** or **validation fails**.
7. Select **Add** to apply the OAuth2 JWT Assertion policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

## Related Links

- [NGINX Blog: Authenticating API Clients with JWT and NGINX Plus](https://www.nginx.com/blog/authenticating-api-clients-jwt-nginx-plus/#Configuring-NGINX&nbsp;Plus-as-an-Authenticating-API-Gateway)
- [[RFC-6749] The OAuth 2.0 Authorization Framework](https://www.rfc-editor.org/rfc/rfc6749)
- [[RFC-6750] The OAuth 2.0 Authorization Framework: Bearer Token Usage](https://www.rfc-editor.org/rfc/rfc6750)
- [[RFC-7517] JSON Web Key (JWK)](https://datatracker.ietf.org/doc/html/rfc7517)
- [[RFC-7519] JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [[RFC-7521] Assertion Framework for OAuth 2.0 Client Authentication and Authorization Grants](https://www.rfc-editor.org/rfc/rfc7521)
- [[RFC-7523] JSON Web Token (JWT) Profile for OAuth 2.0 Client Authentication and Authorization Grants](https://www.rfc-editor.org/rfc/rfc7523)
