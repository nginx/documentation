---
# We use sentence case and present imperative tone
title: "GraphQL protection"
# Weights are assigned in increments of 100: determines sorting order
weight: 1190
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This topic describes the GraphQL protection feature for F5 WAF for NGINX.

{{< call-out "note" >}}
GraphQL is supported by F5 WAF for NGINX version 4.2 on.
{{< /call-out >}}

GraphQL is designed for APIs to use in the development of client applications that access large data sets with intricate relations among themselves. It

It also allows the client to specify exactly what data it needs, reducing the amount of data transferred over the network and improving the overall performance of the application.

Securing GraphQL APIs with F5 WAF for NGINX involves using WAF to monitor and protect against security threats and attacks. 

GraphQL, like REST, is usually [served over HTTP](http://graphql.org/learn/serving-over-http/), using GET and POST requests and a proprietary [query language](https://graphql.org/learn/schema/#the-query-and-mutation-types). It is vulnerable to common web API security vulnerabilities, such as injection attacks, Denial of Service (DoS) attacks and abuse of flawed authorization.

Unlike REST, where web resources are identified by multiple URLs, GraphQL servers operates on a single URL/endpoint, usually **/graphql**.

## Basic configuration

GraphQL policies consists of three basic elements: a GraphQL profile, GraphQL violations and a GraphQL URL.

You can enable GraphQL protection by following these steps:

1. Create a GraphQL policy that includes the policy name. Note that GraphQL profile and GraphQL violation will be enabled by default in the default policy.
1. Add the GraphQL URL to the policy and associate the GraphQL default profile with it.
1. If the app that uses this policy serves only GraphQL traffic, then delete the wildcard URL "*" from the policy so that requests to any URL other than **/graphql** will trigger a violation.
1. Update the `nginx.conf` file. To enforce GraphQL settings, update the `app_protect_policy_file` field with the GraphQL policy name in `nginx.conf` file. Perform nginx reload once `nginx.conf` file is updated to enforce the GraphQL settings.

In the following policy example, the GraphQL "_policy name_" _graphql_policy_ and GraphQL "_urls_" settings are defined:

```json
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

This is an example of a customized `nginx.conf` file:

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

    app_protect_enable on;  # This is how you enable F5 WAF for NGINX in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json"; # This is a reference to the policy file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:514; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port


    server {
        listen       80;
        server_name  localhost;

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

## Advanced configuration

F5 WAF for NGINX has four violations specific to GraphQL: `VIOL_GRAPHQL_FORMAT`, `VIOL_GRAPHQL_MALFORMED`, `VIOL_GRAPHQL_INTROSPECTION_QUERY` and `VIOL_GRAPHQL_ERROR_RESPONSE`.

Under the "_blocking-settings_", you can selectively enable or disable these violations, which are enabled by default.

Any changes to these violation settings will override the default settings, and the violation details will be recorded in the security log.

Since the GraphQL violations are enabled by default, you can change the GraphQL violations settings i.e. alarm: `true` and block: `false` under the "blocking settings". 

With this configuration the GraphQL profile detects violations but does not block the request. They may still contribute to the Violation Rating, which, if raised above 3, will automatically block the request.

To block violating requests, set the alarm and block to `true`.

```json
{
    "name": "graphql_policy",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "blocking-settings": {
        "violations": [
            {
                "name": "VIOL_GRAPHQL_FORMAT",
                "alarm": true,
                "block": false
            },
            {
                "name": "VIOL_GRAPHQL_MALFORMED",
                "alarm": true,
                "block": false
            },
            {
                "name": "VIOL_GRAPHQL_INTROSPECTION_QUERY",
                "alarm": true,
                "block": false
            },
            {
                "name": "VIOL_GRAPHQL_ERROR_RESPONSE",
                "alarm": true,
                "block": false
            }
        ]
    }
}
```

### GraphQL profile

The GraphQL profile defines the GraphQL properties that are enforced by the security policy.

The profile can be added by the security engineers to make sure that GraphQL applications are bound to the same security settings defined in the profile. 

Different GraphQL applications can have different profiles based on their security needs.

GraphQL profiles include:

- **Security enforcement**: Whether to detect signatures and/or metacharacters and an optional override list of signatures that need to be disabled in the context of this profile.
- **Defense attributes**: Special restrictions applied to the GraphQL traffic.
- **responseEnforcement**: Whether to block Disallowed patterns and the list of patterns for the `disallowedPatterns` property.

In the following GraphQL profile example, the "_defenseAttributes_" have been given custom values. 

You can also add a list of disallowed patterns to the "_disallowedPatterns_" field, also visible in the example:

```json
"graphql-profiles" : [
         {
            "attackSignaturesCheck" : true,
            "defenseAttributes" : {
            "allowIntrospectionQueries" : false,
               "maximumBatchedQueries" : 10,
               "maximumQueryCost" : "any",
               "maximumStructureDepth" : 10,
               "maximumTotalLength" : 100000,
               "maximumValueLength" : 100000,
               "tolerateParsingWarnings" : false
            },
            "description" : "",
            "metacharElementCheck" : false,
            "name" : "response_block",
            "responseEnforcement" : {
               "blockDisallowedPatterns" : true,
               "disallowedPatterns":["pattern1","pattern2"]
            }
         }
     ]
```

### URL settings

The second part of configuring GraphQL protection is to define the URL settings. 

Set the values for "isAllowed": **true**, "name": **/graphql** in the URLs section. 

This means URLs with **/graphql** name are permitted, and will be used for all GraphQL API requests.

Under the "urlContentProfiles" settings define the GraphQL profile name, headerValue: `*` (wildcard), headerName: `*` (wildcard), headerOrder: `default`.

These options allow any GraphQL URL request with any headerValue, headerName and type should be `graphql`.

There are no restrictions on the number of GraphQL profiles that can be added by the user.

```json
  "urls": [
        {
            "$action": "delete",
            "method": "*",
            "name": "*",
            "protocol": "http",
            "type": "wildcard"
        },
        {
            "isAllowed": true,
            "name": "/graphql",
            "protocol": "http",
            "type": "explicit",
            "performStaging": false,
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
```

### Associate GraphQL profiles with URLs

In order for a GraphQL profile to become effective, it has to be associated with a URL that represents the service. 

Add the GraphQL profile name which you defined previously under the GraphQL profiles in the name field. 

This example has two GraphQL profiles with the "name": "Default" and "My Custom Profile" under the urlContentProfiles.

```json
{
    "name": "graphql_policy",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",

    "graphql-profiles": [
        {
            "attackSignaturesCheck": true,
            "defenseAttributes": {
                "allowIntrospectionQueries": true,
                "maximumBatchedQueries": "any",
                "maximumQueryCost": "any",
                "maximumStructureDepth": "any",
                "maximumTotalLength": "any",
                "maximumValueLength": "any",
                "tolerateParsingWarnings": true
            },
            "description": "Default GraphQL Profile",
            "metacharElementCheck": true,
            "name": "Default",
            "responseEnforcement": {
                "blockDisallowedPatterns": false
            }
        },
        {
            "attackSignaturesCheck": true,
            "defenseAttributes": {
                "allowIntrospectionQueries": true,
                "maximumBatchedQueries": "any",
                "maximumQueryCost": "any",
                "maximumStructureDepth": "any",
                "maximumTotalLength": "400",
                "maximumValueLength": "any",
                "tolerateParsingWarnings": false
            },
            "description": "my custom Profile",
            "metacharElementCheck": true,
            "name": "My Custom Profile",
            "responseEnforcement": {
                "blockDisallowedPatterns": true,
                "disallowedPatterns": ["pattern1", "pattern2"]
            }
        }
    ],
    "urls": [
        {
            "$action": "delete",
            "method": "*",
            "name": "*",
            "protocol": "http",
            "type": "wildcard"
        },
        {
            "isAllowed": true,
            "name": "/graphql",
            "protocol": "http",
            "type": "explicit",
            "performStaging": false,
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
        },
        {
            "isAllowed": true,
            "name": "/mygraphql",
            "protocol": "http",
            "type": "explicit",
            "performStaging": false,
            "urlContentProfiles": [
                {
                    "contentProfile": {
                        "name": "My Custom Profile"
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

### Response pages

A GraphQL error response page is returned when a request is blocked. 

This GraphQL response page can be customized, but the GraphQL JSON syntax must be preserved for them to be displayed correctly. 

The default page returns the GraphQL status code Blocking Response Page (BRP) and a short JSON error message which includes the support ID.

```shell
"response-pages": [
        {
            "responsePageType": "graphql",
            "responseActionType": "default",
            "responseContent": "{\"errors\": [{\"message\": \"This is a custom GraphQL blocking response page. Code: BRP. Your support ID is: <%TS.request.ID()%>\"}]}"
        }
    ]
```