---
nd-docs: "DOCS-1561"
---

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