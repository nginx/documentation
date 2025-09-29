---
title: Configure App Protect WAF
weight: 300
toc: true
url: /nginxaas/azure/app-protect/configure-waf/
type:
- how-to
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

{{< call-out "note" >}} The app_protect_enforcer_address directive is a required directive for Nginx App Protect to work and must match 127.0.0.1:50000{{< /call-out >}}


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

{{< table >}}
  | Policy                      | Enforcement Mode             | Path                                         |
  |---------------------------- | ---------------------------- | -------------------------------------------- |
  | Default                     | Strict                       | /etc/app_protect/conf/NginxDefaultPolicy.json |
  | Default                     | Transparent                  | /etc/app_protect/conf/NginxDefaultPolicy_transparent.json |
  | Strict                      | Strict                       | /etc/app_protect/conf/NginxStrictPolicy.json |
  | Strict                      | Transparent                  | /etc/app_protect/conf/NginxStrictPolicy_transparent.json |
{{< /table >}}

To view the contents of the available security policies, navigate to the azure portal and select the **Security Policies** tab in the App Protect section.

## Custom policies

NGINXaas for Azure also supports custom security policies. You can create and modify custom security policies to deploy to NGINX App Protect Instances using the API or Azure Portal.

### Manage custom policies

To create a custom security policy in the Azure Portal:

1. Select your deployment
2. Select **NGINX app protect WAF** from the menu on the left
3. Select **Custom Policies**
4. Select **Add Custom Security Policy** to open the policy editor

In the policy editor:

- Enter the policy **Name**, **File path**, your policy content, and then select **Save**.

    - The **File path** must start with the prefix "/etc/app_protect/conf/".
    - The **File path** extension must be ".json".

After your policy has been saved, you can then reference it in your NGINX configuration. For more information on policy configuration and syntax, refer to the NGINX App Protect [configuration guide](https://docs.nginx.com/nginx-app-protect-waf/v5/configuration-guide/configuration/).

{{< call-out "note" >}}The **name** field within the security policy must be unique among the policies referenced in your NGINX configuration.{{< /call-out >}}

{{< call-out "warning" >}}Referencing both custom and precompiled policies in your NGINX configuration is not supported at this time. 
As a workaround, make a copy of the default policy you want to use, then add it as a custom policy with a different name.
{{< /call-out >}}

The **Custom Policies** tab shows the status of your custom policies (Compilation and Application Status). Custom policies are automatically compiled when created or modified. Policies that are applied to the NGINX configuration cannot be deleted until they are first removed from the configuration. 

It is highly recommended to use logging to monitor the performance of NGINX App Protect WAF and to help diagnose problems. See [Enable App Protect WAF Logs]({{< ref "/nginxaas-azure/app-protect/enable-logging.md" >}}) for directions to configure security and operational logs.

## What's next

[Enable App Protect WAF Logs]({{< ref "/nginxaas-azure/app-protect/enable-logging.md" >}})