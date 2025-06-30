---
nd-docs: "DOCS-1591"
---

What we have been seeing so far has been related to making changes by actually overriding specific configuration values. What would happen in the case we wanted to remove a specific configuration entity from the policy. For example, let's say we have added file types "aaa", "bbb", and "ccc", and now we wish to remove "bbb" from the list of disallowed file types. Deleting this entity from the declarative configuration file will simply mean that this entity will be left intact when the policy is rebuilt, meaning that the entity is still in the disallowed file types list. To resolve such situations, we have a `modifications` section where we can force modification where otherwise it is not possible using direct declarative configuration.

There is a specific section named `modifications` where we can configure items to be removed/deleted or forcefully modified in the policy.

In this example, we specify that we wish to remove the file type **log** from the disallowed file types list.

```json
{
    "policy": {
        "name": "modifying_disallowed_file_types",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking"
    },
    "modifications": [
        {
            "entityChanges": {
                "type": "explicit"
            },
            "entity": {
                "name": "log"
            },
            "action": "delete",
            "entityType": "filetype"
        }
    ]
}
```

#### entityType List

The below list provides information about the `entityType` which can be used in the `modifications` section of the App Protect policy:

- blocking-settings/evasion
- blocking-settings-general
- blocking-settings/http-protocol
- blocking-settings/violation
- bot-defense/mitigations/anomaly
- bot-defense/mitigations/browser
- bot-defense/mitigations/class
- bot-defense/mitigations/signature
- bot-defense/settings
- browser-definition
- character-set
- cookie
- cookie-settings
- csrf-protection
- csrf-url
- data-guard
- enforcer-settings
- filetype
- general
- graphql-profile
- grpc-profile
- header
- header-settings
- host-name
- json-profile
- method
- parameter
- response-page
- signature
- sensitive-parameter
- signature-setting
- url
- whitelist-ip
- xml-profile