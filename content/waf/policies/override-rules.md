---
title: Override rules
weight: 1800
toc: true
nd-content-type: reference
nd-product: NAP-WAF
nd-docs: DOCS-000
---

This topic describes override rules feature of F5 WAF for NGINX.

Override rules allow you to replace **default policy** settings. These override rules can be included as part of a declarative policy so that all incoming requests are verified against those rules.

Each override rule consists of a condition followed by changes to the original policy which will apply to requests that meet the condition. 

You can apply this feature to apply unique policy settings to incoming requests with one or more rules based on multiple parameters:

- Method
- Source IP address
- Header values
- URI values

To ensure efficient compilation time and optimal resource allocation for policies, policies have a maximum limit of 10 rules and a maximum of 5 clauses in a condition. A compilation error will not occur if a policy file contains more than 5 clauses or 10 overrides.

The replacement policy should not include any override rules. Override rules should be used to extend or switch to a different policy, rather than being part of the replacement policy itself.

Each override rule is compiled as a separate policy, whether extending the main policy or switching to a new one. The enforcer will switch to the policy that corresponds to the matched rule, but the main policy name will be reported along with the override rule property.

The URI, host, and user-agent strings in the request are treated as plain ASCII characters and won't undergo language decoding. If any of these strings contain non-ASCII characters, they may be misinterpreted and may not comply with rules that expect specific values in the conditions.

The structure of these override rules adheres to the JSON schema defined by the declarative policy.

An example could look like the following:

```shell
{
  "policy": {
    "name": "override_rules_example",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "override-rules": [
      {
        "name": "localhost-log-only",
        "condition": "host.contains('localhost') and clientIp == '127.0.0.1' and userAgent.lower().startsWith('curl')",
        "override": {
          "policy": {
            "enforcementMode": "transparent"
          }
        }
      },
      {
        "name": "login_page",
        "condition": "method == 'POST' and not parameters['ref'].lower().matches('example') and uri.contains('/login/')",
        "actionType": "replace-policy",
        "override": {
          "policy": {
            "name": "login_page_block_redirect",
            "template": {
              "name": "POLICY_TEMPLATE_NGINX_BASE"
            },
            "signature-sets": [
              {
                "name": "All Signatures",
                "block": true,
                "alarm": true
              }
            ],
            "response-pages": [
              {
                "responseRedirectUrl": "https://example.com/rejected?id=<%TS.request.ID()%>",
                "responseActionType": "redirect",
                "responsePageType": "default"
              }
            ]
          }
        }
      },
      {
        "name": "api-strict",
        "condition": "uri.contains('api4') and not (clientIp.matches('fd00:1::/48') or userAgent.lower().startsWith('Mozilla'))",
        "actionType": "replace-policy",
        "override": {
          "$ref": "file:///NginxStrictPolicy.json"
        }
      },
      {
        "name": "strict-post",
        "condition": "method.matches('POST') and (cookies['sessionToken'] != 'c2Vzc2lvblRva2Vu' or headers['Content-Encoding'] == 'gzip')",
        "actionType": "replace-policy",
        "override": {
          "$ref": "file:///NginxStrictPolicy.json"
        }
      },
        "name": "usa-only",
        "condition": "geolocation != 'US'",
                "actionType": "violation",
                "violation": {
                    "block": true,
                    "alarm": true,
                    "attackType": {
                           "name": "Forceful Browsing"
                       },
                    "description": "Attempt to access from outside the USA",
                    "rating": 4
                }
        }
    ]
  }
}
```

The _override_rules_example_ example policy contains five override rules:

1. The **"localhost-log-only"** rule applies to the requests with a user agent header starting with "curl", a host header containing "localhost", and a client IP address set to 127.0.0.1. It switches the enforcement mode to "transparent" without blocking the request. The remaining policy settings remain unchanged. This type of override rule is an example of an **Inline Policy Reference**.
1. The **"login_page"** rule is triggered by POST requests to URIs containing "/login/". Since the "actionType" field is set to "replace-policy", it overrides the policy with a new one named "login_page_block_redirect". This new policy is independent of the "override_rules_example" policy. It enables all signature sets and redirects the user to a rejection page. This is another example of an **Inline Policy Reference** with a different condition.
1. The **"api-strict"** rule is applied for requests with "api4" in the URI, except for client IP addresses matching the "fd00:1::/48" range and user agents starting with "Mozilla". It references an external policy file named "NginxStrictPolicy.json" located at "/etc/app_protect/conf/" to override the current policy. The "actionType" field is set to "replace-policy" and the external policy can be specified using a reference to its file using **$ref**. The file is the JSON policy source of that policy. This type of policy switching is known as **External Policy Reference**.
1. The **"strict-post"** rule is triggered when POST requests include a session token in the cookies that is not equal to "c2Vzc2lvblRva2Vu" or when the "gzip" value is found in the content-encoding headers. This rule follows a similar approach to referencing an external policy file, just like the **api-strict** rule mentioned above.
1. The **"usa-only"** rule is triggered when a request coming from a country other than the USA. The actionType is set to "violation", meaning that `VIOL_RULE` violation is triggered for such a request. This violation will block and mark the request as illegal with regard to the "block" and "alarm" attributes. There is no change in policy for this rule. 

These five rules demonstrate how the override rules feature allows for customization and the ability to modify specific aspects of the original policy based on predefined conditions.

For more details about the **Geolocation** feature, view the [Geolocation]({{< ref "/waf/policies/geolocation.md" >}}) topic.

{{< call-out "note" >}} 

By default, the actionType field is configured to "extend-policy". 

External references are supported for any policy reference.

{{< /call-out >}}

### First match principle

Policy enforcement operates on the **first match** principle. This principle is applied when multiple conditions match or are similar, indicating that any incoming requests that match the first condition will be processed. 

In the following example, the _override_rules_example2_ policy uses two override rules: `this_rule_will_match` and `non_matching_rule`. 

Since both conditions match, the first match principle will be applied, and requests with "_api_" in the URI will be processed. 

It will reference the external policy file named _NginxStrictPolicy.json_ to override the current policy.

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

### Logging & reporting override rules

If a request matches an override rule, the `json_log` field will include a new block named 'overrideRule'. However, if no rules match the request, the log will not contain any related information. 

When the 'actionType' flag is set to _replace-policy_, the _originalPolicyName_ field in the log will reflect the name of the original policy name (Which contains override rules), and the `policy_name` field will reflect the policy that was enforced.

For example, if the matching override rule is called "login_page":

```shell
policy_name="login_page_block_redirect"
```

_json_log_ will have:

```JSON
{
    ...
    "overrideRule": {
        "name": "login_page",
        "originalPolicyName": "override_rule_example"
}
    ...

```

If the matching override rule is called _usa-only_:

```shell
{
...
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
...
```

### Errors and warnings

#### Missing policy name

Every policy must have a name if the actionType is `extend-policy` or `replace-policy`. 

If the policy `name` is not provided in the override section, an error message will be displayed indicating the missing policy 'name' within that specific override rule. 

For instance, in the override rule below, the policy name is not specified.


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
```shell
"error_message": "Failed to import Policy 'policy1' from '/etc/app_protect/conf/test.json': Missing policy 'name' in the override rule 'example-rule'."
```

#### Cyclic override rule error

If an inline or externally referenced policy contains an override rule, a cyclic override rule error will be issued.
 
```shell
"error_message": "Failed to import an override policy: Cyclic override-rules detected."
```