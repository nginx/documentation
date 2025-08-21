Once you have created writable paths in your Kubernetes cluster, you should update your NGINX configuration to use these paths.

The following are fields in `nginx.conf` you should update, which correspond to writable volumes configured during the last step:

```nginx
pid        /tmp/nginx.pid;
...
http {
...
    # Temporary directories for kubernetes "readonlyfilesystem"
    client_body_temp_path /tmp/nginx-client-body;
    proxy_temp_path       /tmp/nginx-proxy;    
    fastcgi_temp_path     /tmp/nginx-fastcgi;    
    uwsgi_temp_path       /tmp/nginx-uwsgi;    
    scgi_temp_path        /tmp/nginx-scgi;
...
}
```

A full example might look like the following:

```nginx
user  nginx;
worker_processes  auto;

# F5 WAF for NGINX
load_module modules/ngx_http_app_protect_module.so;

error_log  /var/log/nginx/error.log debug;
pid        /tmp/nginx.pid; 

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log;

    # Temporary directories for kubernetes "readonlyfilesystem"
    client_body_temp_path /tmp/nginx-client-body;
    proxy_temp_path       /tmp/nginx-proxy;
    fastcgi_temp_path     /tmp/nginx-fastcgi;
    uwsgi_temp_path       /tmp/nginx-uwsgi;
    scgi_temp_path        /tmp/nginx-scgi;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # F5 WAF for NGINX
    app_protect_enforcer_address 127.0.0.1:50000;

    include /etc/nginx/conf.d/*.conf;
}
```