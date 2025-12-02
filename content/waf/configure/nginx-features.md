---
# We use sentence case and present imperative tone
title: "Configure NGINX features with F5 WAF"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document shows example of how to modify your NGINX configuration to enable F5 WAF for NGINX features. 

It is intended as a reference for small, self-contained examples of how F5 WAF for NGINX can be configured. 

Modules requiring the _Range_ header (Such as _Slice_) are unsupported in a scope which enables F5 WAF for NGINX. The examples below work around the contraints of these modules.

For additional information on configuring NGINX, you should view the [NGINX documentation]({{< ref "/nginx/" >}}).

## Internal subrequests

F5 WAF for NGINX will secure and inspect direct client-facing requests, but will not inspect internal subrequests triggered by modules.

This applies to:

* Client authorization (auth_request)
* Mirror (mirror)
* SSI (virtual include)
* njs (r.subrequest)

The following example demonstrates the general rule:

{{< tabs name="subrequest-example" >}}

{{% tab name="nginx.conf" %}}

```nginx
user nginx;
worker_processes  auto;

load_module modules/ngx_http_app_protect_module.so;
load_module modules/ngx_http_js_module.so;

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    js_import main from example.js;

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;
        app_protect_enable on;

        location / {
            proxy_pass    http://127.0.0.1:8080/foo/$request_uri;
        }
    }
    server {
        listen       127.0.0.1:8080;
        server_name  localhost;
        proxy_http_version 1.1;

        location /foo {
            js_content main.fetch_subrequest;
        }

        location / {
            internal;
            return 200  "Hello! I got your URI request - $request_uri\n";
        }
    }
}
```

{{% /tab %}}

{{% tab name="example.js" %}}

```js
async function fetch_subrequest(r) {
    let reply = await r.subrequest('/<script>');
    let response = {
        uri: reply.uri,
        code: reply.status,
        body: reply.responseText,
    };
    r.return(200, JSON.stringify(response));
}

export default {join};
```

{{% /tab %}}

{{< /tabs >}}

If the njs handler triggers an internal subrequest to `/<script>`, it is not inspected by F5 WAF for NGINX and succeeds: 

```shell
curl "localhost/"  
```

```text
{"uri":"/<script>","code":200,"body":"Hello! I got your URI request - /foo//\n"}

```

However, if a direct, client-facing request attempts to trigger the same URL, it is inspected by F5 WAF for NGINX and is blocked according to the security policy.

```shell
curl "localhost/<script>"
```

```text
<html><head><title>Request Rejected</title></head><body>The requested URL was rejected. Please consult with your administrator.

Your support ID is: 123456789

<a href='javascript:history.back();'>[Go Back]</a></body></html>
```

## Static location

```nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            proxy_pass    http://127.0.0.1:8080/proxy/$request_uri;
        }

        location /proxy {
            default_type text/html;
            return 200 "Hello! I got your URI request - $request_uri\n";
        }
    }
}
```

## Range

```nginx
load_module modules/ngx_http_app_protect_module.so;

http {

    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            proxy_pass    http://127.0.0.1:8081$request_uri;
        }
    }

    server {
        listen       127.0.0.1:8081;
        server_name  localhost;

        location / {
            proxy_pass http://1.2.3.4$request_uri;
            proxy_force_ranges on;
        }
    }
}
```

## Slice

```nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen 127.0.0.1:8080;
        server_name localhost;

        location / {
            app_protect_enable on;
            proxy_pass http://127.0.0.1:8081$request_uri;
        }
    }

    server {
        listen 127.0.0.1:8081;
        server_name localhost;

        location / {
            proxy_pass http://1.2.3.4$request_uri;
            slice 2;
            proxy_set_header Range $slice_range;
        }
    }
}
```

## Mirror

```nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    log_format test $uri;

    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            mirror /mirror;
        }

        location /mirror {
            log_subrequest on;
            access_log test$args.log test;
        }
    }
}
```

## njs

```nginx
load_module modules/ngx_http_app_protect_module.so;
load_module modules/ngx_http_js_module.so;

http {
    js_include service.js

    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            proxy_pass    http://127.0.0.1:8081$request_uri;
        }
    }

    server {
        listen       127.0.0.1:8081;
        server_name  localhost;

        location / {
            js_content foo;
        }
    }
}
```

## Client authorization

```nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            auth_request /scan;
            proxy_pass http://localhost:8888;
        }
        location /scan {
            proxy_pass http://localhost:8081$request_uri;
       }
    }

    server {
        listen       127.0.0.1:8081;
        server_name  localhost;

        location /scan {
            app_protect_enable on;
            proxy_pass http://localhost:8888;
        }
    }
}
```