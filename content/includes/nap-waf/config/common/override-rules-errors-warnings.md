---
nd-docs: "DOCS-1600"
---

#### Missing Policy Name

Every policy must have a name if actionType is either "extend-policy" or "replace-policy". If the policy 'name' is not provided in the override section, an error message will be displayed indicating the missing policy 'name' within that specific override rule. For instance, in the override rule below, the policy name is not specified.


Example of Missing policy 'name':

```shell
"override-rules": [
    {
        "name": "example-rule",
        "condition": "uri.contains('127')",
        "actionType": "replace-policy",
        "override": {
            "policy": {
                "name": "policy_name",  <--- the missing part
                "enforcementMode": "transparent"
            }
        }
    }
]
```

Example of Missing policy 'name' error:

```shell
"error_message": "Failed to import Policy 'policy1' from '/etc/app_protect/conf/test.json': Missing policy 'name' in the override rule 'example-rule'."
```

#### Cyclic Override Rule Error

If an inline or externally referenced policy contains an override rule, a Cyclic Override Rule error will be issued.

Example of Cyclic Override Rule error:

```shell
"error_message": "Failed to import an override policy: Cyclic override-rules detected."
```