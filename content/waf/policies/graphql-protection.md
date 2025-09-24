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

GraphQL is an API technology that has grown rapidly in recent years and is continuing to gain traction. GraphQL is a query language designed for APIs to use in the development of client applications that access large data sets with intricate relations among themselves. It provides an intuitive application and flexible syntax for describing data requirements.

GraphQL provides a more efficient, powerful and flexible alternative to REST APIs. This makes it easier to retrieve the data you require in a single request and helps in overcoming challenges which include under-fetching and over-fetching of data. GraphQL also enables faster front-end development without the need for new API endpoints (GraphQL works on a single endpoint), great backend analytics using GraphQL queries and a structured schema and type system.

GraphQL also allows the client to specify exactly what data it needs, reducing the amount of data transferred over the network and improving the overall performance of the application.

In the following sections, you will learn more about enabling GraphQL configuration (using basic and advanced configuration) plus GraphQL security, GraphQL profile and URL settings.

### GraphQL Security

Securing GraphQL APIs with F5 WAF for NGINX involves using WAF to monitor and protect against security threats and attacks. GraphQL, like REST, is usually [served over HTTP](http://graphql.org/learn/serving-over-http/), using GET and POST requests and a proprietary [query language](https://graphql.org/learn/schema/#the-query-and-mutation-types). It is prone to the typical Web APIs security vulnerabilities, such as injection attacks, Denial of Service (DoS) attacks and abuse of flawed authorization.

Unlike REST, where Web resources are identified by multiple URLs, GraphQL server operates on a single URL/endpoint, usually **/graphql**. All GraphQL requests for a given service should be directed to this endpoint.

## Enabling GraphQL with Basic Configuration

This section describes how to configure GraphQL with minimal configuration. Refer to the following sections for GraphQL elements definitions and details about advanced configuration options.

{{< call-out "note" >}} GraphQL is supported on F5 WAF for NGINX version starting 4.2. Make sure you're running F5 WAF for NGINX version 4.2 or later to get GraphQL to work properly.{{< /call-out >}}

GraphQL policy consists of three basic elements: GraphQL Profile, GraphQL Violations and GraphQL URL.

You can enable GraphQL on App Protect by following these steps:

1. Create a GraphQL policy that includes the policy name. Note that GraphQL profile and GraphQL violation will be enabled by default in the default policy.
You can enable GraphQL on App Protect with minimum effort by using the following GraphQL policy example.
1. Add the GraphQL URL to the policy and associate the GraphQL default profile with it.
1. Optionally, if the app that uses this policy serves only GraphQL traffic, then delete the wildcard URL "*" from the policy so that requests to any URL other than **/graphql** will trigger a violation. In the example below we assume this is the case.
1. Update the `nginx.conf` file. To enforce GraphQL settings, update the `app_protect_policy_file` field with the GraphQL policy name in `nginx.conf` file. Perform nginx reload once `nginx.conf` file is updated to enforce the GraphQL settings.

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

    app_protect_enable on;  # This is how you enable F5 WAF for NGINX in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json"; # This is a reference to the policy file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:514; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port


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

## GraphQL Advanced Configuration

The below sections provides details about enabling GraphQL with advanced configuration.

In advanced configuration, GraphQL policy consists of GraphQL Violations, GraphQL Profile and the URL section.

### GraphQL Violations

F5 WAF for NGINX introduces four new violations specific to GraphQL: `VIOL_GRAPHQL_FORMAT`, `VIOL_GRAPHQL_MALFORMED`, `VIOL_GRAPHQL_INTROSPECTION_QUERY` and `VIOL_GRAPHQL_ERROR_RESPONSE`. <br>

Under the "blocking-settings," user can either enable or disable these violations. Note that these violations will be enabled by default. Any changes to these violation settings here will override the default settings. The details regarding logs will be recorded in the security log. <br>

See also the [Violations](#violations) section for more details.

While configuring GraphQL, since the GraphQL violations are enabled by default, you can change the GraphQL violations settings i.e. alarm: `true` and block: `false` under the "blocking settings". In this manner, the GraphQL profile detects violations but does not block the request. They may contribute to the Violation Rating, which, if raised above 3, will automatically block the request.

However, setting the alarm and block to `true` will enforce block settings and App Protect will block any violating requests.

See below example for more details:

```shell
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

### GraphQL Profile

{{< call-out "note" >}} For GraphQL profile default values and GraphQL violations reference, see NGINX App Protect WAF [Declarative Policy guide.]({{< ref "/nap-waf/v5/declarative-policy/policy.md" >}}) {{< /call-out >}}

The GraphQL Profile defines the GraphQL properties that are enforced by the security policy.

The profile can be added by the security engineers to make sure that GraphQL apps are bound to the same security settings defined in the profile. Different GraphQL apps can have different profiles based on the security needs.

The GraphQL Profile includes:

- **Security enforcement**: whether to detect signatures and/or metacharacters and optionally an exception (a.k.a override) list of signatures that need to be disabled in the context of this profile.
- **Defense attributes**: special restrictions applied to the GraphQL traffic. The below example shows the customized GraphQL properties.
- **responseEnforcement**: whether to block Disallowed patterns and provide the list of patterns against the `disallowedPatterns` property.

GraphQL profile example:

In the GraphQL profile example below, we changed the "defenseAttributes" to custom values. You can customize these values under the "defenseAttributes" property. Add a list of disallowed patterns to the "disallowedPatterns" field (for example, here we've added pattern1 and pattern2).

```shell
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

### Define URL settings

he second step to configure GraphQL is to define the URL settings. Set the values for "isAllowed": **true**, "name": **/graphql** in the URLs section, which means URLs with **/graphql** name are permitted. This path will be used for all GraphQL API requests.

Under the "urlContentProfiles" settings define the GraphQL profile name, headerValue: `*` (wildcard), headerName: `*` (wildcard), headerOrder: `default` (allowing any GraphQL URL request with any headerValue, headerName and type should be `graphql`.

There are no restrictions on the number of GraphQL profiles that can be added by the user.

GraphQL URL example:

```shell
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

### Associating GraphQL Profiles with URL

The last step is to associate the GraphQL profiles with the URLs. As with JSON and XML profiles, in order for a GraphQL Profile to become effective, it has to be associated with a URL that represents the service. Add the GraphQL profile name which you defined previously under the GraphQL profiles in the name field. For example, here we have defined two GraphQL profiles with the "name": "Default" and "My Custom Profile" under the urlContentProfiles. Later we also associated these profiles in "graphql-profiles".

GraphQL configuration example:

In this example we define a custom GraphQL profile and use it on one URL, while assigning the default profile to another one.

```shell
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

### GraphQL Response Pages

A GraphQL error response page is returned when a request is blocked. This GraphQL response page, like other blocking response pages, can be customized, but the GraphQL JSON syntax must be preserved for them to be displayed correctly. The default page returns the GraphQL status code Blocking Response Page (BRP) and a short JSON error message which includes the support ID.

For example:

```shell
"response-pages": [
        {
            "responsePageType": "graphql",
            "responseActionType": "default",
            "responseContent": "{\"errors\": [{\"message\": \"This is a custom GraphQL blocking response page. Code: BRP. Your support ID is: <%TS.request.ID()%>\"}]}"
        }
    ]
```