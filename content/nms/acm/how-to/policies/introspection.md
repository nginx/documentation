---
description: API Owners can restrict access to their APIs with OAuth2 tokens. The
  policy is configured to grant access to APIs after having tokens introspected.
docs: DOCS-953
doctypes:
- API Connectivity Manager
- api management
- concept
tags:
- docs
toc: true
weight: 800
Title: Introspection
---

## Overview

API Connectivity Manager API Owners can restrict access to their APIs with OAuth2 tokens by swapping an opaque token for claims or JWT token to be proxied to the backend service. The policy can be configured to grant access to APIs after having the tokens introspected. In addition, the claims in the token can be extracted and forwarded to the backend service.

---

## What is OAuth2?

{{< include "acm/tutorials/what-is-OAuth2.md" >}}

### OAuth2 Roles

The idea of roles is part of the core specification of the OAuth2 Authorization Framework. These define the essential components of an
OAuth2 system:

- **Resource Owner**: An entity capable of granting access to a protected resource. It could be a system or an end-user.
- **Client**: An application making protected resource requests on behalf of the Resource Owner and with its authorization.
- **Authorization Server**: The server that issues access tokens to the client after successfully authenticating the resource owner and
  obtaining authorization. The authorization server exposes two endpoints: the Token endpoint, which is involved in a machine-to-machine interaction for issuing access tokens, and the Introspection endpoint, which is used by the Resource Server to validate client access tokens.
- **Resource Server**: The server protecting the user resources capable of accepting and responding to protected resource requests using
  access tokens. In this guide, NGINX running within the API Connectivity Manager API-Proxy is the Resource Server.

### Token Introspection

The standard method for validating access tokens with an IdP is called _Token Introspection_. _OAuth2 Token Introspection_
[[RFC 7662]](https://www.rfc-editor.org/rfc/rfc7662) is now a widely supported standard that describes a JSON/REST interface that a Resource Server uses to present a token to the IdP, and describes the structure of the response. It is supported by many of the leading IdP vendors and cloud providers.

NGINX can be used to validate access tokens on behalf of backend services. This has several benefits:

- Requests reach the backend services only when the client has presented a valid token
- Existing backend services can be protected with access tokens without requiring code changes
- Only the NGINX instance (not every app) needs to be registered with the IdP
- Behavior is consistent for every error condition, including missing or invalid tokens

The _OAuth2 Token Introspection_ flow includes the following steps:

{{<img src="/acm/oauth2-introspection-flow.png" alt="OAuth2 Token Introspection Flow." >}}

---

## Set up OAuth2 Introspection Policy

{{< include "acm/how-to/setup-oauth2-introspection-policy.md" >}}

---

## Enabling Server Name Indication

A generic solution for running several HTTPS servers on a single IP address is the [TLS Server Name Indication (SNI)](https://en.wikipedia.org/wiki/Server_Name_Indication) extension [[RFC 6066]](https://www.rfc-editor.org/rfc/rfc6066), which allows a client to pass a requested server name during the SSL
handshake. This solution lets the server know which certificate it should use for the client connection.

Some Authorization Servers require SNI to be enabled during the OAuth Introspection request SSL handshake. When an Authorization server needs SNI, the following error messages will appear in the NGINX error logs on the data plane proxy host.

```log
2022/12/04 15:24:43 [warn] 9501#9501: *73 upstream server temporarily disabled while SSL
handshaking to upstream, client: 10.0.0.1, server: api.io,
request: "GET /api HTTP/1.1", subrequest: "/_oauth2_send_introspection_request_0a2f6842_default",
upstream: "https://test.oauth.com:443/test/oauth2/introspect", host: "api.io"

2022/12/04 15:24:43 [error] 9501#9501: *73 js: OAuth unexpected response from introspection server
(HTTP 502): {"message":"Bad Gateway","status":"502"}

2022/12/04 15:25:27 [error] 9500#9500: *79 SSL_do_handshake() failed (SSL: error:14094410:SSL
routines:ssl3_read_bytes:sslv3 alert handshake failure:SSL alert number 40) while SSL handshaking
to upstream, client: 10.0.0.1, server: api.io, request: "GET /api HTTP/1.1",
subrequest: "/_oauth2_send_introspection_request_0a2f6842_default",
upstream: "https://test.oauth.com:443/test/oauth2/introspect", host: "api.io"
```

To enable sending the SNI with the OAuth Introspection request, set the `oauth-introspection` policy `action.enableSNI` value to `true`. By default, the host part of the `action.introspectionRequest` value is used. To override the default behavior and send a different server name through SNI, set `action.proxyTLSName` as the server name required to verify the certificate of the Authorization Server.

<details open>
<summary>JSON request</summary>

```json
{
    "policies": {
        "oauth2-introspection": [
            {
                "action": {
                    "introspectionEndpoint": "https://example.idp.com:8443/oauth/v2/oauth-introspect",
                    "enableSNI": true,
                    "proxyTLSName": "test.oauth.com"
                }
            }
        ]
    }
}
```

</details>

If the override value provided in `action.proxyTLSName` is incorrect, the Authorization Server should respond with a `4xx` client error code. The following error log is an example of an incorrect override `action.proxyTLSName` found in the NGINX error logs on the data plane proxy host.

```log
2022/12/04 15:27:12 [error] 7477#7477: *50 js: OAuth unexpected response from
introspection server (HTTP 403): Forbidden
```

In this example, the end user also gets a `403 Forbidden` response from the data plane proxy. If `action.cacheIntrospectionResponse` is enabled and `action.proxyTLSName` is changed from a correct value to an incorrect value, the cached access token is valid until it expires. When the cached access token expires, end users will see their requests to the data plane proxy return with `403 Forbidden` responses.

The NGINX OAuth2 Introspection configuration used by API Connectivity Manager does not cache tokens if the introspection request status code is anything other than `200 Success`. Any introspection requests with user access tokens returning `4xx` or `5xx` response codes will work once the policy introspection configuration is corrected and the Authorization Server responds with status code `200`.

## Policy Interoperability Considerations

It is only possible to configure one OAuth2 Introspection Policy per Proxy in API Connectivity Manager. Only one set of `clientAppId` credentials can be
configured per OAuth2 Introspection Policy.

While an OAuth2 Introspection policy is configured for a Proxy in API Connectivity Manager it is not possible to configure any of the following policies on
the same Proxy:

1. API Key Authentication
2. Basic Authentication
3. JWT Assertion

Similarly, if any of the above three policies are configured for a Proxy in API Connectivity Manager, it is not possible to additionally configure an OAuth
2.0 Introspection Policy.

## Security Considerations

### Token Caching

Consumers of the introspection endpoint may wish to cache the response of the endpoint for performance reasons. As such, it is important
to consider the performance and security trade-offs when deciding to cache the values. For example, shorter cache expiration times will
result in higher security since the resource servers will have to query the introspection endpoint more frequently, but will result in an
increased load on the endpoint. Longer expiration times leave a window open where a token may actually be expired or revoked, but still be
able to be used at a resource server for the remaining duration of the cache time.

One way to mitigate this problem is for consumers to never cache the value beyond the expiration time of the token, which would have been
returned in the `“exp”` parameter of the introspection response.

### JWT Introspection Responses

The introspection response type `application/jwt`, configured through `action.introspectionResponse`, has not had its security protocol
specification finalised at the time of development and writing it remains in **DRAFT** state. The draft specification _JWT Response for_
_OAuth Token Introspection_ can be found [here](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-jwt-introspection-response).

While in this state the specification is likely to change at any time, and how we implement it in API Connectivity Manager may change to meet the requirements of
the specification. We recommend that the default OAuth2 Introspection response type `application/json` is used for all production
scenarios.

## Related Links

- [RFC-6749: The OAuth2 Authorization Framework](https://www.rfc-editor.org/rfc/rfc6749)
- [RFC 7662: OAuth2 Token Introspection](https://www.rfc-editor.org/rfc/rfc7662)
- [IETF-Draft: JWT Response for OAuth Token Introspection](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-jwt-introspection-response)
- [NGINX time measurement syntax](http://nginx.org/en/docs/syntax.html)
