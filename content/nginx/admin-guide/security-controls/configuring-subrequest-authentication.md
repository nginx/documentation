---
description: Authenticate clients during request processing by making a subrequest
  to an external authentication service, such as LDAP or OAuth.
docs: DOCS-430
title: Authentication Based on Subrequest Result
toc: true
weight: 400
type:
- how-to
---

<span id="intro"></span>
## Introduction

NGINX and F5 NGINX Plus can authenticate each request to your website with an external server or service. To perform authentication, NGINX makes an HTTP subrequest to an external server where it is verified. Such type of authentication allows implementing various authentication schemes, such as multifactor authentication, or allows implementing LDAP or OAuth authentication.

## Response Codes

Subrequest Response Codes:

- 2xx - access is allowed
- 401, 403 - access is denied

## Prerequisites

- NGINX Plus or NGINX Open Source
- External authentication server or service

<span id="config"></span>
## Configuring NGINX and NGINX Plus

1. Make sure your NGINX Open Source is compiled with the `with-http_auth_request_module` configuration option. Run this command and verify that  the output includes  <span style="white-space: nowrap;">`--with-http_auth_request_module`</span>:

    ```none
    nginx -V 2>&1 | grep -- 'http_auth_request_module'
    ```

    Skip this step for NGINX Plus as it already includes the auth_request module.

2. In the location that requires request authentication, specify the [auth_request](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html#auth_request) directive and specify an internal location where an authorization subrequest will be forwarded to:

    ```nginx
    location /private/ {
        auth_request /auth;
        #...
    }
    ```

    Here, for each request to **/private**, a subrequest to the internal **/auth** location will be made.

3. Specify an internal location and the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive inside this location that will proxy authentication subrequests to an authentication server or service:

    ```nginx
    location = /auth {
        internal;
        proxy_pass http://auth-server;
        #...
    }
    ```

4. As the request body is discarded for authentication subrequests, set the [proxy_pass_request_body](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_request_body) directive to `off` and also set the `Content-Length` header to a null string:

    ```nginx
    location = /auth {
        internal;
        proxy_pass              http://auth-server;
        proxy_pass_request_body off;
        proxy_set_header        Content-Length "";
        #...
    }
    ```

5. Pass the full original request URI with arguments with the [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive:

    ```nginx
    location = /auth {
        internal;
        proxy_pass              http://auth-server;
        proxy_pass_request_body off;
        proxy_set_header        Content-Length "";
        proxy_set_header        X-Original-URI $request_uri;
    }
    ```

6. As an option, you can set a variable value basing on the result of the subrequest with the [auth_request_set](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html#auth_request_set) directive:

    ```nginx
    location /private/ {
        auth_request        /auth;
        auth_request_set $auth_status $upstream_status;
    }
    ```

<span id="example"></span>
## Complete Example

This example sums up the previous steps into one configuration:

```nginx
http {
    #...
    server {
    #...
        location /private/ {
            auth_request     /auth;
            auth_request_set $auth_status $upstream_status;
        }

        location = /auth {
            internal;
            proxy_pass              http://auth-server;
            proxy_pass_request_body off;
            proxy_set_header        Content-Length "";
            proxy_set_header        X-Original-URI $request_uri;
        }
    }
}
```
