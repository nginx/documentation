---
nd-docs: "DOCS-1579"
---

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