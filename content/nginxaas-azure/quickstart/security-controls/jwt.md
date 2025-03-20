---
title: Setting up JWT authentication
weight: 200
toc: true
docs: DOCS-1101
url: /nginxaas/azure/quickstart/security-controls/jwt/
type:
- how-to
---

F5 NGINX as a Service for Azure (NGINXaaS) provides the option to control access to your resources using JWT authentication. With JWT authentication, a client provides a JSON Web Token, and the token will be validated against a local key file or a remote service. This document will explain how to validate tokens using Microsoft Entra as the remote service.

For more information on JWT authentication with NGINX+, please refer to [ngx_http_auth_jwt_module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html) and [NGINX Plus Setting up JWT Authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-jwt-authentication/).

## Prerequisites

- Set up a tenant, see [Quickstart: Set up a tenant](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-create-new-tenant).
- URL of the remote service (IdP). In this documentation, we are using Microsoft Entra Signing Keys URL: `https://login.microsoftonline.com/common/discovery/keys`. For more information, see [Signing key rollover in the Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/signing-key-rollover).

## Configuring NGINX for JWT authentication

1. To configure NGINX to use JWT for authentication, you will need to create a JWT that will be issued to a client. You can use your identity provider (IdP) or your own service to create JWTs. For testing purposes, you can create your own JWT, see [Get Microsoft Entra tokens for users by using MSAL](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/app-aad-token) for details. If you wish to use your own local JSON Web Key (JWK) file for authentication, please upload it along with the NGINX configuration. Remember to respect the instance's filesystem restrictions and specify a location for the key file within one of the allowed directories. For details on uploading the configuration and file system restrictions, see [Upload an NGINX Configuration](https://docs.nginx.com/nginxaas/azure/getting-started/nginx-configuration/).

2. Set up an NGINX `location` block that enables the JWT authentication and defines the authentication realm ("API" in the example) with the [auth_jwt](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt) directive. To verify the signature or decrypt the content of JWT, you will need to specify the JWT type using the [auth_jwt_type](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_type) directive, and provide the path to the corresponding JSON Web Key (JWK) file using the [auth_jwt_key_file](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) and/or [auth_jwt_key_request](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directives. Specifying both directives simultaneously will allow you to specify more than one key source. If no directives are specified, JWS signature verification will be skipped.

```nginx
server {
   listen 80;

   location / {
      auth_jwt "API";
      auth_jwt_key_file /srv/key.jwk;
      auth_jwt_key_request /_jwks_uri;
   }

   location = /_jwks_uri {
      proxy_pass https://login.microsoftonline.com/common/discovery/keys;
      subrequest_output_buffer_size 12k;
   }
}
```

{{<warning>}}
When using the common Microsoft Entra signing keys you will need to increase the size of the subrequest output buffer as the key file will not fit in the default buffer.
If the buffer is not sized properly, requests will result in empty responses. If [error logging is enabled]({{< relref "/nginxaas-azure/monitoring/enable-logging/" >}}), you will see an error in the error log.{{</warning>}}

Enabling JWT key caching is recommended to achieve optimal performance. This can be done with the [auth_jwt_key_cache](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache) directive. Note that caching of keys obtained from variables is not supported. If you are using Microsoft Entra as an identity provider for JWT authentication, please be aware that [keys are rotated frequently](https://learn.microsoft.com/en-us/entra/identity-platform/signing-key-rollover), and it is recommended to take that into consideration before using it as a static file or caching the response from the subrequest.

The full example of getting JWT authentication from a subrequest:

```nginx
http {
   upstream my_backend {
      server 10.0.0.1;
      server 10.0.0.2;
   }

   server {
      listen 80;

      location / {
         auth_jwt "API";
         auth_jwt_key_file conf/key.jwk;
         auth_jwt_key_request /_jwks_uri;
         auth_jwt_key_cache 1h;
         proxy_pass http://my_backend;
      }

      location = /_jwks_uri {
         internal;
         proxy_method GET;
         proxy_pass https://login.microsoftonline.com/common/discovery/keys;
         subrequest_output_buffer_size 12k;
      }
   }
}
```

To learn more about configuring JWT in more complex scenarios such as claims validation, see [Arbitrary JWT Claims Validation](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-jwt-authentication/#arbitrary-jwt-claims-validation).
