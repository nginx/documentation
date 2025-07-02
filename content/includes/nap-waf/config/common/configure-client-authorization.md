---
nd-docs: "DOCS-1571"
---

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