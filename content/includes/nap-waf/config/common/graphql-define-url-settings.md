---
nd-docs: "DOCS-1588"
---

The second step to configure GraphQL is to define the URL settings. Set the values for "isAllowed": **true**, "name": **/graphql** in the URLs section, which means URLs with **/graphql** name are permitted. This path will be used for all GraphQL API requests.

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