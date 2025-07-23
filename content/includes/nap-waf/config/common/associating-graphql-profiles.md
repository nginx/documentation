---
nd-docs: "DOCS-1607"
---

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