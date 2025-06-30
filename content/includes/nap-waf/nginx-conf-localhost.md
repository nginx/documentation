---
nd-docs: "DOCS-1518"
---

```nginx
user  nginx;
worker_processes  auto;

# NGINX App Protect WAF
load_module modules/ngx_http_app_protect_module.so;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # NGINX App Protect WAF
    app_protect_enforcer_address 127.0.0.1:50000;

    include /etc/nginx/conf.d/*.conf;
}
```
