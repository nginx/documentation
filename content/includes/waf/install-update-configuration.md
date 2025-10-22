---
nd-docs:
---

Once you have installed F5 WAF for NGINX, you must load it as a module in the main context of your NGINX configuration.

```nginx
load_module modules/ngx_http_app_protect_module.so;
```

The Enforcer address must be added at the _http_ context:

```nginx
app_protect_enforcer_address 127.0.0.1:50000;
```

And finally, F5 WAF for NGINX can enabled on a _http_, _server_ or _location_ context:

```nginx
app_protect_enable on;
```

{{< call-out "warning" >}}

You should only enable F5 WAF for NGINX on _proxy_pass_ and _grpc_pass_ locations.

{{< /call-out >}}

Here are two examples of how these additions could look in configuration files:

{{< tabs name="configuration-examples" >}}

{{% tab name="nginx.conf" %}}

The default path for this file is `/etc/nginx/nginx.conf`.

```nginx {hl_lines=[5, 33]}
user  nginx;
worker_processes  auto;

# F5 WAF for NGINX
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

    # F5 WAF for NGINX
    app_protect_enforcer_address 127.0.0.1:50000;

    include /etc/nginx/conf.d/*.conf;
}
```

{{% /tab %}}

{{% tab name="default.conf" %}}

The default path for this file is `/etc/nginx/conf.d/default.conf`.

```nginx {hl_lines=[10]}
server {
    listen 80;
    server_name domain.com;


    location / {

        # F5 WAF for NGINX
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

{{% /tab %}}

{{< /tabs >}}

Once you have updated your configuration files, you can reload NGINX to apply the changes. You have two options depending on your environment:

- `nginx -s reload`
- `sudo systemctl reload nginx`