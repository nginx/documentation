---
nd-docs: DOCS-000
---

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