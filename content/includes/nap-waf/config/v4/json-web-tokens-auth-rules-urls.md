---
docs: DOCS-1496
---

A new entity named as `authorizationRules` is introduced under the URL. This entity encompasses an authorization condition essential for "Claims" validation, enabling access to a specific URL based on claims of a JWT.
The `authorizationRules` entity consists of the following two mandatory fields:

- `name`: a unique descriptive name for the condition predicate
- `condition`: a boolean expression that defines the conditions for granting access to the URL

Here is an example of declarative policy using an `authorizationRules` entity under the access profile:
```json
{
    "urls": [
        {
            "name": "/api/v3/shops/items/*",
            "accessProfile": {
                "name": "my_jwt"
            },
            "authorizationRules": [
                {
                    "condition": "claims['scope'].contains('pet:read') and claims['scope'].contains('pet:write')",
                    "name": "auth_scope"
                },
                {
                    "condition": "claims['roles'].contains('admin') or claims['roles'].contains('inventory-manager')",
                    "name": "auth_roles"
                },
                {
                    "condition": "claims['email'].endsWith('petshop.com')",
                    "name": "auth_email"
                }
            ]
        }
    ]
}
``` 
#### AuthorizationRules Condition Syntax Usage
The `authorizationRules` use a Boolean expression to articulate the conditions for granting access to the URL. The conditions use the same syntax as in [Policy Override Rules](#override-rules) with one additional attribute **"claims"**.
#### Claims Attribute
The newly introduced attribute "claims" is a mapping of JSON paths for claims from the JWT to their respective values. Only structure nesting is supported using the "." notation. 
A few points to remember regarding JWT claims:
- Please note that at the moment, accessing individual cells within JSON arrays isn't possible. Instead, the entire array gets serialized as a string, and its elements can be evaluated using string operators like "contains".
- While it's technically feasible to consolidate all conditions into one with "and" between them, it's not recommended. Dividing them into multiple conditions enhances the readability and clarity of the policy, particularly when explaining the reasons for authorization failure.
For the full reference of authorizationRules condition syntax and usage see the NGINX App Protect WAF [Declarative Policy guide]({{< relref "nap-waf/v4/declarative-policy/policy.md" >}}/#policy/override-rules).
See below example for JWT claims:
 
```json
{
    "scope": "top-level:read",
    "roles": [
        "inventory-manager",
        "price-editor"
    ],
    "sub": "joe@doe.com"
    "address": {
        "country": "US",
        "state": "NY",
        "city": "New York",
        "street": "888 38th W"
    }      
}
```
then the claims can be:
```
claims['scope'] = "top-level:read" 
claims['roles'] = "["inventory-manager", "price-editor]" # the whole array is presented as a string
claims['address.country'] = "US" 
claims['company'] = null # does not exist 
claims['address'] = "{ \"address\": { .... } }" # JSON structs can be accessed using the dot "." notation
```