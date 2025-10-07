---
nd-docs: "DOCS-1594"
---

F5 WAF for NGINX introduces three new violations specific to JWT: `VIOL_ACCESS_INVALID`, `VIOL_ACCESS_MISSING` and `VIOL_ACCESS_MALFORMED`.

Under the "blocking-settings," user can either enable or disable these violations. Note that these violations will be enabled by default. The details regarding logs will be recorded in the security log.

See the below example for these violations.

```shell
{
    "policy": {
        "name": "jwt_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "blocking-settings": {
           "violations": [
            {
               "alarm": true,
               "block": false,
               "name": "VIOL_ACCESS_INVALID"
            },
            {
               "alarm": true,
               "block": false,
               "name": "VIOL_ACCESS_MISSING"
            },
            {
               "alarm": true,
               "block": false,
               "name": "VIOL_ACCESS_MALFORMED"
            }
            ]
        }
    }
}
```