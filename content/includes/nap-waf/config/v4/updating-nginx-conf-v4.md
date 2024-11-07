---
docs: "DOCS-1528"
---

In order for NGINX App Protect WAF to load the new user-defined signatures, the user needs to add the directive: `app_protect_user_defined_signatures`. This directive can only be used (multiple times, if needed) in the http context in the nginx.conf file and cannot be used under the server or location contexts. This directive accepts the path of the user-defined signature definition file as an argument. To add multiple definition files, the user will need to add a directive per file. Note that if the file or directory is not accessible by the nginx user, an error message will be displayed, and the policy will fail to compile.

An example configuration file is listed below:

```nginx
user nginx;
worker_processes  4;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections  65536;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    app_protect_enable on;
    app_protect_policy_file "/etc/nginx/user_defined_signatures_policy.json";
    app_protect_user_defined_signatures "/etc/nginx/user_defined_signature_definitions.json";

    app_protect_security_log_enable on;
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:514;

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://127.0.0.1:8080$request_uri;
        }
    }
}
```
