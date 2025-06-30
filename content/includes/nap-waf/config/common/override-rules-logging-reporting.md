---
nd-docs: "DOCS-1583"
---

If a request matches an override rule, the `json_log` field will include a new block named 'overrideRule'. However, if no rules match the request, the log will not contain any related information. When the 'actionType' flag is set to "replace-policy", the 'originalPolicyName' field in the log will reflect the name of the original policy name (the one that contains override rules), and the `policy_name` field will reflect the policy that was enforced.

For example, if the matching override rule is called "login_page":

```shell

...
policy_name="login_page_block_redirect"
...

json_log will have:

{
    ...
    "overrideRule": {
        "name": "login_page",
        "originalPolicyName": "override_rule_example"
}
    ...

```

If the matching override rule is called "usa-only":

```shell
{
    "enforcementState": {
        "isBlocked": true,
        "isAlarmed": true,
        "rating": 4,
        "attackType": [
            {
                "name": "ATTACK_TYPE_FORCEFUL_BROWSING"
            }
        ]
    },
    "violation": {
        "name": "VIOL_RULE"
    },
    "policyEntity": {
        "override-rule": {
            "name": "usa-only"
        }
    },
    "description": "Trying to access special"
},

```