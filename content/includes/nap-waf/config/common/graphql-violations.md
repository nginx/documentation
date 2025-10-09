---
nd-docs: "DOCS-1578"
---

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