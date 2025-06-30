---
nd-docs: "DOCS-1585"
---

A new directive `app_protect_custom_log_attribute` will be added to the `nginx.conf` file. You can set this directive at all scopes: http, server and location. The setting at the location scope overrides the setting in the server and/or http scopes and the server scope overrides the http scope. The `app_protect_custom_log_attribute` directive syntax will consist of a **name/value** or **key/value** pair i.e. "app_protect_custom_log_attribute <name> <value>".

Example Configuration:

In the below example, we are configuring the `app_protect_custom_log_attribute` directive at the server and location level where we define the **key/value** pair as one string.

```nginx

user nginx;
load_module modules/ngx_http_app_protect_module.so;
error_log /var/log/nginx/error.log debug;

events {
    worker_connections  65536;
}
server {

        listen       80;

        server_name  localhost;
        proxy_http_version 1.1;
        app_protect_custom_log_attribute ‘environment' 'env1';

        location / {

            app_protect_enable on;
            app_protect_custom_log_attribute gateway gway1;
            app_protect_custom_log_attribute component comp1;
            proxy_pass http://172.29.38.211:80$request_uri;
        }
    }
```

The **key/value** pair will be 'environment env1', ‘gateway gway1’ and ‘component comp1’ in the above examples, i.e.

- app_protect_custom_log_attribute environment env1;
- app_protect_custom_log_attribute gateway gway1;
- app_protect_custom_log_attribute component comp1;

The above key/value pair will be parsed as below:

```shell
"customLogAttributes": [
    {
        "name": "gateway",
        "value": "gway1"
    },
    {
        "name": "component",
        "value": "comp1"
    },
]
```