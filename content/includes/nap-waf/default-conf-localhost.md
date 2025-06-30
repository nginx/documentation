---
nd-docs: "DOCS-1515"
---

```nginx
server {
    listen 80;
    server_name domain.com;

    proxy_http_version 1.1;

    location / {

        # NGINX App Protect WAF
        app_protect_enable on;

        client_max_body_size 0;
        default_type text/html;
        proxy_pass http://127.0.0.1:8080/;
    }
}

server {
    listen 8080;
    server_name localhost;


    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```
