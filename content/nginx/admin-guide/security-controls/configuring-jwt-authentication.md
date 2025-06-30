---
description: This article explains how to control authentication of your web resources
  using JWT authentication.
nd-docs: DOCS-429
title: Setting up JWT Authentication
toc: true
weight: 500
type:
- how-to
---

<span id="intro"></span>
## Introduction

With F5 NGINX Plus it is possible to control access to your resources using JWT authentication. JWT is data format for user information in the OpenID Connect standard, which is the standard identity layer on top of the OAuth 2.0 protocol. Deployers of APIs and microservices are also turning to the JWT standard for its simplicity and flexibility. With JWT authentication, a client provides a JSON Web Token, and the token will be validated against a local key file or a remote service.

<span id="prereq"></span>
## Prerequisites

- NGINX Plus [Release 10]({{< ref "nginx/releases.md#r10" >}}) (R10) for native [JWT support](https://www.nginx.com/blog/nginx-plus-r10-released/#r10-jwt)
- NGINX Plus [Release 14]({{< ref "nginx/releases.md#r14" >}}) for access to [nested JWT claims and longer signing keys](https://www.nginx.com/blog/nginx-plus-r14-released/#jwt)
- NGINX Plus [Release 17]({{< ref "nginx/releases.md#r17" >}}) for [getting JSON Web keys from a remote location](https://www.nginx.com/blog/nginx-plus-r17-released/#r17-openid)
- NGINX Plus [Release 24]({{< ref "nginx/releases.md#r24" >}}) (R24) for support of encrypted tokens (JWE)
- NGINX Plus [Release 25]({{< ref "nginx/releases.md#r25" >}}) (R25) for support of Nested JWT, multiple sources of JSON Web keys, condition-based JWT authentication
- NGINX Plus [Release 26]({{< ref "nginx/releases.md#r26" >}}) (R26) for support of [JWT key caching](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache)
- An identity provider (IdP) or service that creates JWT. For manual JWT generation, see "Issuing a JWT to API Clients" section of the [Authenticating API Clients with JWT and NGINX Plus](https://www.nginx.com/blog/authenticating-api-clients-jwt-nginx-plus/) blog post.

<span id="auth_jwt_type"></span>

NGINX Plus supports the following types of JWT:

- JSON Web Signature (JWS) - JWT content is digitally signed. The following algorithms can be used for signing:
  - HS256, HS384, HS512
  - RS256, RS384, RS512
  - ES256, ES384, ES512
  - EdDSA (Ed25519 and Ed448 signatures)

- JSON Web Encryption (JWE) - the contents of JWT is encrypted. The following content encryption algorithms (the "enc" field of JWE header) are supported:
  - A128CBC-HS256, A192CBC-HS384, A256CBC-HS512
  - A128GCM, A192GCM, A256GCM

   The following key management algorithms (the "alg" field of JWE header) are supported:
  - A128KW, A192KW, A256KW
  - A128GCMKW, A192GCMKW, A256GCMKW
  - dir - direct use of a shared symmetric key as the content encryption key
  - RSA-OAEP, RSA-OAEP-256, RSA-OAEP-384, RSA-OAEP-512

- Nested JWT - support for JWS enclosed into JWE

<span id="auth_jwt"></span>
## Configuring NGINX Plus to Authenticate API

Let's assume that NGINX Plus serves as a gateway (`proxy_pass http://api_server`) to a number of API servers (the [`upstream {}`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) block), and requests passed to the API servers should be authenticated:

```nginx
upstream api_server {
    server 10.0.0.1;
    server 10.0.0.2;
}

server {
    listen 80;

    location /products/ {
        proxy_pass http://api_server;
        #...
    }
}
```

To implement JWT for authentication:

1. First, it is necessary to create a JWT that will be issued to a client. You can use your identity provider (IdP) or your own service to create JWTs. For testing purposes, you can create your own JWT, see [Authenticating API Clients with JWT and NGINX Plus](https://www.nginx.com/blog/authenticating-api-clients-jwt-nginx-plus/) blog post for details.

2. Configure NGINX Plus to accept JWT: specify the [`auth_jwt`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt) directive that enables JWT authentication and also defines the authentication area (or "realm", "API" in the example):

   ```nginx
   server {
       listen 80;

       location /products/ {
           proxy_pass http://api_server;
           auth_jwt   "API";
           #...
       }
   }
   ```

   NGINX Plus can also obtain the JWT from a query string parameter. To configure this, include the `token=` parameter to the [`auth_jwt`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt) directive:

   ```nginx
      #...
      auth_jwt "API" token=$arg_apijwt;
      #...
   ```

3. Specify the type of JWT - `signed` (JWS), `encrypted` (JWE) or `nested` (Nested JWT) - with the [`auth_jwt_type`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_type) directive. The default value of the directive is `signed`, so for JWS, the directive can be omitted.

   ```nginx
   server {
       listen 80;

       location /products/ {
           proxy_pass        http://api_server;
           auth_jwt          "API";
           auth_jwt_type     encrypted;
           #...
       }
   }
   ```

4. Specify the path to the [JSON Web Key file](#jwk_create) that will be used to verify JWT signature or decrypt JWT content, depending on what you are using. This can be done with the [`auth_jwt_key_file`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) and/or [`auth_jwt_key_request`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directives. Specifying both directives at the same time will allow you to specify more than one source for keys. If none of the directives are specified, JWS signature verification will be skipped.

   In this scenario, the keys will be taken from two files: the `key.jwk` file and the `keys.json` file:

   ```nginx
   server {
       listen 80;

       location /products/ {
           proxy_pass        http://api_server;
           auth_jwt          "API";
           auth_jwt_type     encrypted;
           auth_jwt_key_file conf/key.jwk;
           auth_jwt_key_file conf/keys.json;
       }
   }
   ```

   In this scenario, there are also two sources for the keys, but the private keys will be taken from the local file `private_jwe_keys.jwk`, while the public keys will be taken from the external identity provider service `https://idp.example.com` in a [subrequest](#auth_jwt_key_request):

   ```nginx
   server {
       listen 80;

       location /products/ {
           proxy_pass           http://api_server;
           auth_jwt             "API";
           auth_jwt_type        encrypted;
           auth_jwt_key_file    private_jwe_keys.jwk;
           auth_jwt_key_request /public_jws_keys;
       }

       location /public_jws_keys {
           proxy_pass "https_//idp.example.com/keys";
       }
   }
   ```

   It is recommended to enable JWT key caching to get the optimal performance from the JWT module. For example, you can use the [`auth_jwt_key_cache`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache) directive for the above configuration, and enable the JWT key caching for one hour. Note that if the [`auth_jwt_key_request`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) or [`auth_jwt_key_file`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) are configured dynamically with variables, [`auth_jwt_key_cache`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache) cannot be used.

   ```nginx
   server {
       listen 80;

       location /products/ {
           proxy_pass           http://api_server;
           auth_jwt             "API";
           auth_jwt_type        encrypted;
           auth_jwt_key_file    private_jwe_keys.jwk;
           auth_jwt_key_request /public_jws_keys;
           auth_jwt_key_cache   1h;
       }

       location /public_jws_keys {
           proxy_pass "https_//idp.example.com/keys";
       }
   }
   ```

<span id="jwt_validate"></span>
## How NGINX Plus Validates a JWT

A JWT is considered to be valid when the following conditions are met:

- The signature can be verified (for JWS) or payload can be decrypted (for JWE) with the key found in the [`auth_jwt_key_file`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) or [`auth_jwt_key_request`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) (matching on the `kid` ("key ID"), if present, and `alg` ("algorithm") header fields).
- The JWT is presented inside the validity period, when defined by one or both of the `nbf` ("not before") and `exp` ("expires") claims.


<span id="jwk_create"></span>
## Creating a JSON Web Key File

In order to validate the signature with a key or to decrypt data, a JSON Web Key (`key.jwk`) should be created. The file format is defined by [JSON Web Key specification](https://tools.ietf.org/html/rfc7517):

```json
{"keys":
    [{
        "k":"ZmFudGFzdGljand0",
        "kty":"oct",
        "kid":"0001"
    }]
}
```

where:

- the `k` field is the generated symmetric key (base64url-encoded) basing on a `secret` (`fantasticjwt` in the example). The secret can be generated with the following command:

```shell
echo -n fantasticjwt | base64 | tr '+/' '-_' | tr -d '='
ZmFudGFzdGljand0
```

- the `kty` field defines the key type as a symmetric key (octet sequence)
- the `kid` (Key ID) field defines a serial number for this JSON Web Key


<span id="auth_jwt_key_request"></span>
## Getting JWKs from Subrequest

NGINX Plus can be configured to fetch JSON Web Keys from the remote location - usually an identity provider, especially when using OpenID Connect. The IdP URI where the subrequest will be sent to is configured with the [`auth_jwt_key_request`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directive:

```nginx
http {
    #...

    server {
        listen 80;
            #...

        location / {
            auth_jwt "closed site";
            auth_jwt_key_request /_jwks_uri; # Keys will be fetched by subrequest

            proxy_pass http://my_backend;
        }
    }
}
```

The URI may refer to an internal location (`_jwks_uri`) so that the JSON Web Key Set can be cached ([`proxy_cache`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache) and [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directives) to avoid validation overhead. Turning on caching is recommended for high-load API gateways even if [JWT key caching](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache) is used as it will help to avoid overwhelming a key server with key requests when a JWT key cache expires.

```nginx
http {
    proxy_cache_path /var/cache/nginx/jwk levels=1 keys_zone=jwk:1m max_size=10m;
    #...

    server {
        listen 80;
            #...

        location = /_jwks_uri {
            internal;
            proxy_method      GET;
            proxy_cache       jwk; # Cache responses
            proxy_cache_valid 200 12h;
            proxy_pass        https://idp.example.com/oauth2/keys; # Obtain keys from here
        }
    }
}
```

The full example of getting JWKs from a subrequest:

```nginx
#
proxy_cache_path /var/cache/nginx/jwk levels=1 keys_zone=jwk:1m max_size=10m;

server {
    listen 80; # Use SSL/TLS in production

    location / {
        auth_jwt             "closed site";
        auth_jwt_key_cache   1h;
        auth_jwt_key_request /_jwks_uri;    # Keys will be fetched by subrequest

        proxy_pass http://my_backend;
    }

    location = /_jwks_uri {
        internal;
        proxy_method      GET;
        proxy_cache       jwk; # Cache responses
        proxy_cache_valid 200 12h;
        proxy_pass        https://idp.example.com/oauth2/keys; # Obtain keys from here
    }
}
```

<span id="auth_jwt_require"></span>
## Arbitrary JWT Claims Validation

During JWT verification, NGINX Plus automatically validates only `nbf` ("not before") and `exp` ("expires") claims. However, in some cases you need to set more conditions for a successful JWT validation, in particular when dealing with application-specific or protocol level claims. For example, OpenID Connect Core requires validation of `iss` ("issuer"), `aud` ("audience"), `sub` ("subject") claims for `ID` token.

Additional conditions for JWT validation can be set as variables with the [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html) module and then evaluated with the [`auth_jwt_require`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require) directive.

In this scenario, we are verifying that:

- the recipient of the token (audience) is our APIs (map rule 1)
- the token was issued by a trusted identity provider (map rule 2)
- scopes in APIs called on behalf of administrators (map rule 3)

The values of three resulting variables are evaluated in the [`auth_jwt_require`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require) directive, and if the value of each variable is `1`, the JWT will be accepted:

```nginx
upstream api_server {
    server 10.0.0.1;
    server 10.0.0.2;
}

map $jwt_claim_aud $valid_app_id {    #map rule 1:
    "~api\d.example.com" 1;           #token issued only for target apps
}

map $jwt_claim_iss $valid_issuer {    #map rule 2:
    "https://idp.example.com/sts" 1;  #token issued by trusted CA
}

map $jwt_claim_scope $valid_scope {   #map rule 3:
    "access_as_admin" 1;              #access as admin only
}

server {
    listen 80;

    location /products/ {
        auth_jwt          "API";
        auth_jwt_key_file conf/api_secret.jwk;
        auth_jwt_require  $valid_app_id $valid_issuer $valid_scope;
        proxy_pass        http://api_server;
    }
}
```

In some cases the [`auth_jwt_require`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require) directive can be specified multiple times, for example, for the purpose of authentication and then for authorization. In case of an error, the `401` code will be displayed. Assigning the custom error code `403` to another `auth_jwt_require` directive makes ti possible to differentiate authentication and authorization usecases and handle corresponding failures appropriately:

```nginx
    location /products/ {
        auth_jwt          "API";
        auth_jwt_key_file conf/api_secret.jwk;
        auth_jwt_require  $valid_app_id $valid_issuer $valid_scope;
        auth_jwt_require  $valid_scope error=403;
        proxy_pass        http://api_server;
    }
```

<span id="nested"></span>
## Nested JWT Extraction

A Nested JWT is a JWS token enclosed into JWE. In a Nested JWT, the sensitive information from JWS is protected with extra encryption of JWE.

Using Nested JWT may be preferable over JWE because:

- in case of JWE, the target application/service needs to decrypt the token first, then verify the signature. Decrypt operation on the application side may be time and resource consuming.

- in case of Nested JWT, as NGINX Plus resides in the same trusted network with the target application, there is no need for token encryption between NGINX Plus and the application. NGINX Plus decrypts the JWE, checks the enclosed JWS, and sends the Bearer Token to the application. This will offload JWE decryption from the application to NGINX Plus.

- if your application doesn't support JWE, using Nested JWT enables full protection for JWS.

To enable Nested tokens:

1. Specify the `nested` type of JWT with the [`auth_jwt_type`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_type) directive.

```nginx
auth_jwt_type nested;
```

2. Pass the decrypted payload (the [`$jwt_payload`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#var_jwt_payload) variable) to the application as the Bearer token value in the `Authorization` header:

```nginx
proxy_set_header Authorization "Bearer $jwt_payload";
```

This example sums up the previous steps into one configuration:

```nginx
upstream api_server {
    server 10.0.0.1;
    server 10.0.0.2;
}

http {
    server {
        listen 80;

        auth_jwt          "API";
        auth_jwt_type     nested;
        auth_jwt_key_file conf/api_secret.jwk;

        proxy_pass       http://api_server;
        proxy_set_header Authorization "Bearer $jwt_payload";
    }
}
```

<span id="see_also"></span>
## See Also

- [Authenticating API Clients with JWT and NGINX Plus](https://www.nginx.com/blog/authenticating-api-clients-jwt-nginx-plus/)
