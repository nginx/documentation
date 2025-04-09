---
description: Learn about the policies available for use in the F5 NGINX Controller.
docs: DOCS-568
title: Learn About Policies
toc: true
weight: 130
type:
- concept
---

## Overview

F5 NGINX Controller provides a set of policies that allow you to protect and secure your services (APIs for API Management module deployments, and Apps for App Delivery module deployments) and their data. The available policies fall under two basic categories:

- Authentication policies
- Rate Limiting policies

## Authentication Policies

Authentication policies allow to you restrict access to your APIs by determining the identity of the caller. There are two types of authentication policies: API Key and JWT.

**API Key** is usually a long, pseudo-random string included in the request header or request URL. It is a shared secret between the API client and the API gateway. The server allows the client to access data only after the client authenticates the API Key.

You can specify the way API clients present their credentials:

- HTTP request header
- Query string parameter

When using API keys for authentication, the API key is written to the NGINX Plus config as cryptographically-protected hashes.

To use API key authentication for any element of NGINX Controller, you must install the `njs` module on all NGINX Plus instances.

If you do not install the `njs` module and use API key authentication, whether for API Management or elsewhere, the system may experience errors that are not reported in the user interface.

> See the [NGINX Admin Guide](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) for `njs` installation instructions.

**JWT** authentication uses JSON Web Tokens to validate clients. JWT authentication is set up by providing a JSON Web Key (JWK) set. A JWK set is a JSON representation of one or more cryptographic signing keys, as used by JWTs. The signing keys allow NGINX Plus to validate the signature of a JWT. A detailed overview is available in [Authenticating API Clients with JWT and NGINX Plus](https://www.nginx.com/blog/authenticating-api-clients-jwt-nginx-plus).

You can specify the way API clients present a JWT:

- HTTP request header
- Query string parameter
- Bearer token
- Cookie

{{<note>}} The Bearer token option configures NGINX Plus to verify the JWT in the Authorization Bearer header, which is present in HTTP requests. The Bearer token is the default NGINX Plus use case for JWT. {{</note>}}

A JWK set consists of three parts:

- **Header** - The JSON object that contains parameters describing cryptographic operations. It consists of two parts: the token type (JWT) and the signing algorithm that is being used.
- **Payload** - The arbitrary sequence of messages.
- **Signature** - Digital signature over Header and Payload.

During the authentication process, a user or application will log in using the appropriate credentials. The authorization server then returns a JSON Web Token, which the user or application can use to access the API. In other words, the authorization is granted. At this point, the application can use the JWT to access the protected resource (API).

Regardless of the method used to generate the JWT, you must use Base64URL encoding, which correctly handles padding (done with the `=` character) as well as other non‑HTTP compliant characters typically used in Base64 encoding.

The following JWT signatures are currently supported:

- HS256, HS384, HS512
- RS256, RS384, RS512
- ES256, ES384, ES512
- EdDSA (Ed25519 and Ed448 signatures) (1.15.7)

The detailed list of algorithms is available in the [NGINX JWT module documentation](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html).

API keys are convenient for testing and small-scale deployments, while JWTs are more appropriate for production use against an external Identity Provider.

{{< see-also >}}

To create an Identity Provider by using a JWK set, see [Add an Identity Provider]({{< ref "/controller/services/manage-identity-providers.md#add-an-identity-provider" >}}).

{{< /see-also >}}

### Conditional Access

Conditional Access provides access at the root level for Authentication policies. It can be toggled **On/Off**.

You can set the following Conditional Access options:

- Policy Type: 'Allow when' or 'Deny when'
- Source Data Type
- Source Data Value

The **Source Data Type** dropdown menu contains the **JWT claim** option if the Authentication Policy uses JWT authentication. This option is disabled for API Authentication Policies.

You can use the Comparison Type and Value fields to specify the conditions that will trigger the policy.

Options for Comparison Type are:

- Equals
- Not Equals
- Is one of
- Contains

When you select Comparison Type 'Is one of', the Value field supports multiple values. Using the Failure Response field, you can set up the failure response code. Once the set up is complete, you can save the Component and successfully publish the API with the Conditional Access policy.

## Rate Limiting Policies

A Rate Limiting Policy limits the number of requests the API will accept within a set time frame. Setting a rate-limiting policy protects your upstream application servers from receiving too many user requests at the same time. It also helps protect your services (APIs or Apps) against DDoS attacks or slow down brute-force password-guessing attacks.​

{{< see-also >}}

Want to find out more? See [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/)

{{< /see-also >}}

You can set the following rate limiting options within the component::

- The number of requests allowed (per second or per minute).
- How to handle excessive requests:
  - Reject immediately;
  - Allow until requests reach a pre-determined **burst** value.
- The HTTP code that should be returned for calls that exceeded the request limit.

Rate limits are associated with a specific identifier that is unique to each client. You can associate a rate limit with any of the following identifiers:

- Client IP address
- User agent
- URI
- NGINX variable

{{< versions "3.6" "3.18" "ctrlvers" >}}
{{< versions "3.22" "latest" "adcvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
