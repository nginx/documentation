---
# We use sentence case and present imperative tone
title: "Configure NGINX features with F5 WAF"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document shows example of how to modify your NGINX configuration to enable F5 WAF for NGINX features. 

It is intended as a reference for, small self-contained examples of how F5 WAF for NGINX is configured. 

Certain features do not work well with NGINX, such as modules requiring _subrequest_ when calling or being called from a scope that contains `app_protect_enable on`.

Modules requiring the _Range_ header (Such as _Slice_) are also unsupported in a scope which enables F5 WAF for NGINX.

The examples below show work arounds for the limitations of these features.

For information on configuring NGINX, you should view the [NGINX documentation]({{< ref "/nginx/" >}}).

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