---
nd-docs: "DOCS-1596"
---

F5 WAF for NGINX comes with pre-defined signatures and signature sets. Also, the user can create their own user-defined signatures (as we have seen above) as well as user-defined signature sets. User-defined Signature sets are suitable for organizing the sheer number of pre-defined and user-defined signatures into logical sets for better use in the policy. For pre-defined signatures, there are two ways of managing signature sets: manual addition of signatures using the signature unique IDs, or filtering signatures based on specific criteria, like request/response, risk level, accuracy level, attack type, systems, etc. For the user-defined signatures, signature IDs are automatically generated, and they cannot be used in manual addition of signatures. Therefore, only one way is possible: filtering based on tag, request/response, risk level, accuracy level, attack type, systems, etc.

The following example shows the creation of a new signature set based on filtering all signatures that have accuracy equals to "low":

```json
{
    "name": "filtered_signature_sets",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "signature-sets": [
        {
            "name": "my-low-accuracy-signatures",
            "block": true,
            "alarm": true,
            "signatureSet": {
                "type": "filter-based",
                "filter": {
                    "attackType": {
                        "name": "Other Application Attacks"
                    },
                    "signatureType": "request",
                    "riskFilter": "eq",
                    "riskValue": "high",
                    "accuracyFilter": "le",
                    "accuracyValue": "high"
                }
            }
        }
    ]
}
```

Note that the filter can have one of the following values:

- `eq` - Include values equal to.
- `le` - Include values less than or equal.
- `ge` - Include values greater than or equal.
- `all` - Do not filter, use all items. Note that `all` is the default value so if the user does not specify a filter, it will be considered as `all`. Also, if the user specifies the `all` filter, there is no need to specify the corresponding value element.

Therefore, the above example can be interpreted as: include all the signatures with risk equal to "high" and all signatures with accuracy equal to or less than medium. The result should include all low and medium accuracy signatures that have a high risk value.

In the following example, we demonstrate how to add signatures manually to a signature set by specifying the signature ID of each of the signatures:

```json
{
    "name": "manual_signature_sets",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "signature-sets": [
        {
            "name": "my-cherry-picked-signatures",
            "block": true,
            "alarm": true,
            "signatureSet": {
                "type": "manual",
                "signatures": [
                    {
                        "signatureId": 200003360
                    },
                    {
                        "signatureId": 200001234
                    }
                ]
            }
        }
    ]
}
```

It is worthy to note that if a newly added signature set name matches an existing signature set name, it will not overwrite the existing set. Instead, a new set will be created with "\_2" appended to the signature set name. For example, if we create a signature set with the name "My_custom_signatures" with 3 signatures, then add a new signature to the set and reload the `nginx` process, a new signature set will be created with the name "My_custom_signatures_2" containing the new list of 4 signatures. The older list "My_custom_signatures" with 3 signatures will remain intact.