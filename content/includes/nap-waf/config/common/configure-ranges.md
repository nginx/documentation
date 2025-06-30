---
nd-docs: "DOCS-1544"
---

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