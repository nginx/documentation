---
title: Custom dimensions for log entries
toc: false
weight: 200
nd-content-type: reference
nd-product: NAP-WAF
---

Custom dimensions log entries feature refers to the new configuration in F5 WAF for NGINX, where the new directive called `app_protect_custom_log_attribute` is assigned to a particular location or server or http level in the `nginx.conf` file. The need is to be able to add custom identifiers to the respective location and/or server and identify requests in the Security Log by those identifiers.

The `app_protect_custom_log_attribute` directive will be used to track the assigned location/server/http dimension of each request by adding the `app_protect_custom_log_attribute` to the **Security Logs** a.k.a **Request Logs**. Since it is a custom attribute a customer can set, that custom attribute will appear for every request log entry that was handled by that location/server.

### Configuration

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

### Things to Remember While Configuring the Custom Dimensions Log Entries

The `app_protect_custom_log_attribute` directive has a few limitations which should be kept in mind while configuring this directive:

- Key and value strings are limited to 64 chars
- Maximum possible directive numbers are limited to 10 (in total) in each context i.e. Limit of 10 keys and values

### Errors and Warnings

An error message "`app_protect_custom_log_attribute` directive is invalid" will be displayed in the Security Log if the below conditions are met:

1. If the `app_protect_custom_log_attribute` exceeds the maximum number of 10 directives
2. If the `app_protect_custom_log_attribute` exceeds the maximum name length of 64 chars
3. If the `app_protect_custom_log_attribute` exceeds the maximum value of 64 chars

Error message example:

```shell
app_protect_custom_log_attribute directive is invalid. Number of app_protect_custom_log_attribute directives exceeds maximum
```

### Logging and Reporting

When `app_protect_custom_log_attribute` is assigned to a particular location/server/http context, it will appear in the `json_log` field as a new JSON property called "customLogAttributes" at the top level. The property will not appear if no `app_protect_custom_log_attribute` directive was assigned.

Attributes at the http level applies to all servers and locations unless a specific server or location overrides the same key with a different value. Same goes for the server level and all locations under it. In the below example, the "environment" attribute will appear in logs of all locations under that server.

Security logging example in json_log:

```json
""customLogAttribute"":[{""name"":""component"",""value"":""comp1""},{""name"":""gateway"",""value"":""gway1""}]}"
```