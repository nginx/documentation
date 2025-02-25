---
title: "Configure App Protect WAF"
weight: 300
categories: ["tasks"]
toc: true
url: /nginxaas/azure/app-protect/configure-waf/
---

## Overview

This guide explains how to configure the F5 NGINX App Protect WAF security features.

## Configure

To use NGINX App Protect apply the following changes to the NGINX config file.

1. Load the NGINX App Protect WAF module on the main context:

```nginx
load_module modules/ngx_http_app_protect_module.so;
```

2. Set the enforcer address:

```nginx
app_protect_enforcer_address 127.0.0.1:50000;
```

{{<note>}} The app_protect_enforcer_address directive is a required directive for Nginx App Protect to work and must match 127.0.0.1:50000{{</note>}}


3. Enable NGINX App Protect WAF with the `app_protect_enable` directives in the appropriate scope. The `app_protect_enable` directive may be set in the `http`, `server`, and `location` contexts.

It is recommended to have a basic policy enabled in the `http` or `server` context to process malicious requests in a more complete manner.

```nginx
app_protect_enable on;
```

4. Configure the path of the pre-compiled policy file to the `app_protect_policy_file` directive. You can find the list of supported policies and their paths under the [Precompiled Policies](#precompiled-policies) section.

```nginx
app_protect_policy_file /etc/app_protect/conf/NginxDefaultPolicy.json;
```

Sample Config with App Protect configured:

```nginx
user nginx;
worker_processes auto;
worker_rlimit_nofile 8192;
pid /run/nginx/nginx.pid;

load_module modules/ngx_http_app_protect_module.so;

events {
    worker_connections 4000;
}

error_log /var/log/nginx/error.log debug;

http {
    access_log off;
    server_tokens "";

    app_protect_enforcer_address 127.0.0.1:50000;

    server {
        listen 80 default_server;

        location / {
            app_protect_enable on;
            app_protect_policy_file /etc/app_protect/conf/NginxDefaultPolicy.json;
            proxy_pass http://127.0.0.1:80/proxy/$request_uri;
        }

        location /proxy {
            default_type text/html;
            return 200 "Hello World\n";
        }
    }
}
```

## Precompiled Policies

NGINXaaS for Azure ships with the two reference policies (Default and Strict) supported in NGINX App Protect. These policies are supported in both the blocking and transparent enforcement modes.
For more information on these policies refer the NGINX App Protect [configuration guide](https://docs.nginx.com/nginx-app-protect-waf/v5/configuration-guide/configuration/).

The following table shows the path to the precompiled policy file that needs to be used with the `app_protect_policy_file` directive:

{{<bootstrap-table "table table-striped table-bordered">}}
  | Policy                      | Enforcement Mode             | Path                                         |
  |---------------------------- | ---------------------------- | -------------------------------------------- |
  | Default                     | Strict                       | /etc/app_protect/conf/NginxDefaultPolicy.json |
  | Default                     | Transparent                  | /etc/app_protect/conf/NginxDefaultPolicy_transparent.json |
  | Strict                      | Strict                       | /etc/app_protect/conf/NginxStrictPolicy.json |
  | Strict                      | Transparent                  | /etc/app_protect/conf/NginxStrictPolicy_transparent.json |
{{</bootstrap-table>}}

To view the contents of the available security policies, navigate to the azure portal and select the **Security Policies** tab in the App Protect section.

{{<note>}}Custom policies are not supported at this time.{{</note>}}

## What's next

[Enable App Protect WAF Logs]({{< relref "/nginxaas-azure/app-protect/enable-logging.md" >}})
