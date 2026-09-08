---
title: Configure F5 WAF for NGINX 
description: "Configure F5 WAF for NGINX security features by editing the NGINX configuration file."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/app-protect/configure-waf/
f5-content-type: how-to
f5-product: F5 NGINXaaS
f5-keywords: "F5 WAF, app protect, security policy, NGINX configuration"
f5-summary: >
  This page explains how to configure F5 WAF for NGINX by loading the module and setting the enforcer address, then enabling a security policy.
  You need this to protect your application from web threats.
f5-audience: operator
contentVars:
  product: NGINXaaS
---

## Overview

This guide explains how to configure the F5 WAF for NGINX security features.

## Configure

To use F5 WAF for NGINX, apply the following changes to the NGINX config file.

1. Load the F5 WAF for NGINX module on the main context:

```nginx
load_module modules/ngx_http_app_protect_module.so;
```

2. Set the enforcer address:

```nginx
app_protect_enforcer_address 127.0.0.1:50000;
```

{{< call-out class="note" >}} The app_protect_enforcer_address directive is a required directive for F5 WAF for NGINX to work and must match `127.0.0.1:50000`{{< /call-out >}}


3. Enable F5 WAF for NGINX with the `app_protect_enable` directives in the appropriate scope. The `app_protect_enable` directive may be set in the `http`, `server`, and `location` contexts.

It is recommended to have a basic policy enabled in the `http` or `server` context to process malicious requests in a more complete manner.

```nginx
app_protect_enable on;
```

4. Configure the pre-defined policy to use with the `app_protect_policy_file` directive (either the `app_protect_default_policy` or `app_protect_strict_policy`).

```nginx
app_protect_policy_file app_protect_strict_policy;
```

Sample Config with F5 WAF for NGINX configured:

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
            app_protect_policy_file app_protect_strict_policy;
            proxy_pass http://127.0.0.1:80/proxy/$request_uri;
        }

        location /proxy {
            default_type text/html;
            return 200 "Hello World\n";
        }
    }
}
```
