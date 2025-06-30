---
nd-docs: "DOCS-1553"
---

The **Override Rules** feature allows overriding of the **default policy** settings. Each override rule consists of a condition followed by changes to the original policy applied to requests that meet the respective condition. This feature provides the ability to include the override rules within a declarative policy such that all incoming requests are verified against those rules.

With this enhancement, users now have more control over how a unique policy setting is applied to incoming requests with a specific method, source IP address, header or URI value through one or multiple unique override rules. Each override rule possesses a unique name and specific conditions that are matched against incoming traffic from a specific client side. The structure of these override rules adheres to the JSON schema defined by the declarative policy.

Here is an example of a declarative policy using an override rules entity:

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

The above "override_rules_example" policy contains five override rules:

1. The **"localhost-log-only"** rule applies to the requests with a user agent header starting with "curl", a host header containing "localhost", and a client IP address set to 127.0.0.1. It switches the enforcement mode to "transparent" without blocking the request. The remaining policy settings remain unchanged. This type of override rule is an example of an **Inline Policy Reference**.
2. The **"login_page"** rule is triggered by POST requests to URIs containing "/login/". Since the "actionType" field is set to "replace-policy", it overrides the policy with a new one named "login_page_block_redirect". This new policy is independent of the "override_rules_example" policy. It enables all signature sets and redirects the user to a rejection page. This is another example of an **Inline Policy Reference** with a different condition.
3. The **"api-strict"** rule is applied for requests with "api4" in the URI, except for client IP addresses matching the "fd00:1::/48" range and user agents starting with "Mozilla". It references an external policy file named "NginxStrictPolicy.json" located at "/etc/app_protect/conf/" to override the current policy. The "actionType" field is set to "replace-policy" and the external policy can be specified using a reference to its file using **$ref**. The file is the JSON policy source of that policy. This type of policy switching is known as **External Policy Reference**.
4. The **"strict-post"** rule is triggered when POST requests include a session token in the cookies that is not equal to "c2Vzc2lvblRva2Vu" or when the "gzip" value is found in the content-encoding headers. This rule follows a similar approach to referencing an external policy file, just like the **api-strict** rule mentioned above.
5. The **"usa-only"** rule is triggered when a request coming from a country other than the USA. The actionType is set to "violation", meaning that `VIOL_RULE` violation is triggered for such a request. This violation will block and mark the request as illegal with regard to the "block" and "alarm" attributes. There is no change in policy for this rule. For more details about **Geolocation** feature, see [Geolocation in Policy Override Rules Conditions](#geolocation-in-policy-override-rules-conditions).

These five rules demonstrate how the override rules feature allows for customization and the ability to modify specific aspects of the original policy based on predefined conditions.


{{< note >}}
- By default, the actionType field is configured to "extend-policy".
- External references are supported for any policy reference.
{{< /note >}}