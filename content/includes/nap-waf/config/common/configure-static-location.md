---
nd-docs: "DOCS-1581"
---

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