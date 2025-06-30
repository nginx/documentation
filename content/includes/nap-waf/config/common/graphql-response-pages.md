---
nd-docs: "DOCS-1557"
---

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