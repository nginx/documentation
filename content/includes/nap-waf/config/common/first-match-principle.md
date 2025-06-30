---
nd-docs: "DOCS-1572"
---

The policy enforcement operates on the **first match** principle. This principle is applied when multiple conditions match or are similar, indicating that any incoming requests that match the first condition will be processed. In the following example, the "override_rules_example2" policy uses two override rules: "this_rule_will_match" and "non_matching_rule". Since both conditions match, the first match principle will be applied, and requests with "api" in the URI will be processed. It will reference an external policy file named "NginxStrictPolicy.json" to override the current policy. .

For example:

```shell
{
  "policy": {
    "name": "override_rules_example2",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "override-rules": [
      {
        "name": "this_rule_will_match",
        "condition": "uri.contains('api')",
        "actionType": "replace-policy",
        "override": {
          "$ref": "file:///NginxStrictPolicy.json"
        }
      },
      {
        "name": "non_matching_rule",
        "condition": "uri.contains('api') and not clientIp == '192.168.0.10'",
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