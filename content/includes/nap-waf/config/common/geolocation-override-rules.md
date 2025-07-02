---
nd-docs: "DOCS-1567"
---

The below example represents a security policy for a web application. The policy named as "override_rule_example" is based on a template called "POLICY_TEMPLATE_NGINX_BASE." The policy is set to operate in "blocking" mode, which means it will prevent certain activities.

There's a specific configuration under "general" that deals with custom headers for cross-origin requests, specifically the "xff" header. The policy is configured to trust this header.

In the "override-rules" section there is one override rule named "myFirstRule." This rule is set up to trigger when the geolocation of a request is identified as 'IL' (Israel). When this condition is met, the action taken is to extend the policy, but with a change in enforcement mode to "transparent."

In simpler terms, when someone tries to access the web application from Israel ('IL'), the security policy will be adjusted to allow the access but in a more transparent manner, meaning it won't block the access but may monitor it differently.

```json
{
    "policy": {
        "name": "override_rule_example",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "enforcementMode": "blocking",
        "general": {
             "customXffHeaders": ["xff"],
             "trustXff": true
         },
         "override-rules": [
            {
                "name": "myFirstRule",
                "condition": "geolocation == 'IL'",
                "actionType": "extend-policy",
                "override": {
                    "policy": {
                        "enforcementMode": "transparent"
                    }
                }
            }
        ]
    }
}
```