---
docs: "DOCS-1536"
---

This section describes how to configure GraphQL with minimal configuration. Refer to the following sections for GraphQL elements definitions and details about advanced configuration options.

{{< note >}} GraphQL is supported on NGINX App Protect WAF version starting 4.2. Make sure you're running NGINX App Protect WAF version 4.2 or later to get GraphQL to work properly.{{< /note >}}

GraphQL policy consists of three basic elements: GraphQL Profile, GraphQL Violations and GraphQL URL.

You can enable GraphQL on App Protect by following these steps:

1. Create a GraphQL policy that includes the policy name. Note that GraphQL profile and GraphQL violation will be enabled by default in the default policy.
You can enable GraphQL on App Protect with minimum effort by using the following GraphQL policy example.
2. Add the GraphQL URL to the policy and associate the GraphQL default profile with it.
3. Optionally, if the app that uses this policy serves only GraphQL traffic, then delete the wildcard URL "*" from the policy so that requests to any URL other than **/graphql** will trigger a violation. In the example below we assume this is the case.
4. Update the `nginx.conf` file. To enforce GraphQL settings, update the `app_protect_policy_file` field with the GraphQL policy name in `nginx.conf` file. Perform nginx reload once `nginx.conf` file is updated to enforce the GraphQL settings.

In the following policy example, the GraphQL "policy name" i.e. "graphql_policy", and graphql "urls" settings are defined.

```shell
{
    "name": "graphql_policy",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "urls": [
        {
            "$action": "delete",
            "method": "*",
            "name": "*",
            "type": "wildcard"
        },
        {
            "name": "/graphql",
            "type": "explicit",
            "urlContentProfiles": [
                {
                    "contentProfile": {
                        "name": "Default"
                    },
                    "headerValue": "*",
                    "headerName": "*",
                    "headerOrder": "default",
                    "type": "graphql"
                }
            ]
        }
    ]
}
```

As described in point 4 above, here is an example `nginx.conf` file:

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

    app_protect_enable on;  # This is how you enable NGINX App Protect WAF in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json"; # This is a reference to the policy file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:515; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port


    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://172.29.38.211:80$request_uri;
        }

        location /graphql {
            client_max_body_size 0;
            default_type text/html;
            app_protect_policy_file "/etc/app_protect/conf/graphQL_policy.json"; # This location will invoke the custom GraphQL policy 
            proxy_pass http://172.29.38.211:80$request_uri;
        }
    }
}
```