---
title: Custom dimensions for log entries
toc: false
weight: 200
nd-content-type: reference
nd-product: NAP-WAF
---

F5 WAF for NGINX can configure custom dimensions for log entries using the directive `app_protect_custom_log_attribute`.

This directive can be added to the NGINX configuration file in the `http`, `server` and `location` scopes. The custom dimensions become part of every request in the [Security logs]({{< ref "/waf/logging/security-logs.md" >}}) based on the scope used.

The `app_protect_custom_log_attribute` directive takes a key/value pair, such as `app_protect_custom_log_attribute 'customDimension' '1'`. The directive can cascade and override entries based on scope order: _location_, _server_ then _http_. 

For example, attributes at the _http_ level apply to all servers and locations unless a specific server or location overrides the same key with a different value.

When a custom dimension is assigned to a scope, it appears in the `json_log` field as a new JSON property called "customLogAttributes" at the top level. This properly appears if the `app_protect_custom_log_attribute` directive is used.

In the configuration example, the "environment" attribute appears in logs of all locations under that server block.

```json
""customLogAttributes"":[{""name"":""component"",""value"":""comp1""},{""name"":""gateway"",""value"":""gway1""}]}"
```

The following example defines the `app_protect_custom_log_attribute` directive at the server and location level, with key/value pairs as strings.

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
        app_protect_custom_log_attribute 'environment' 'env1';

        location / {

            app_protect_enable on;
            app_protect_custom_log_attribute gateway gway1;
            app_protect_custom_log_attribute component comp1;
            proxy_pass http://172.29.38.211:80$request_uri;
        }
    }
```

The key/value pairs are 'environment env1', 'gateway gway1' and 'component comp1' in the above examples:

- app_protect_custom_log_attribute environment env1;
- app_protect_custom_log_attribute gateway gway1;
- app_protect_custom_log_attribute component comp1;

The key/value pairs are parsed as follows:

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

The `app_protect_custom_log_attribute` directive has constraints you should keep in mind:

- Key and value strings are limited to 64 chars
- There are a maximum of 10 key/value pairs in each scope

An error message beginning with "_'app_protect_custom_log_attribute' directive is invalid_" will be displayed in the security log if:

1. The `app_protect_custom_log_attribute` exceeds the maximum number of 10 directives
1. The `app_protect_custom_log_attribute` exceeds the maximum name length of 64 chars
1. The `app_protect_custom_log_attribute` exceeds the maximum value of 64 chars

The log will specify the precise issue:

```text
app_protect_custom_log_attribute directive is invalid. Number of app_protect_custom_log_attribute directives exceeds maximum
```


