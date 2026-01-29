---
nd-docs: DOCS-253
title: "Evasion techniques"
weight: 1100
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

This topic describes the evasion techniques feature for F5 WAF for NGINX.

Evasion techniques are used by hackers to attempt to access resources or evade what would otherwise be identified as an attack.

Like HTTP compliance, evasion techniques have a list of sub-violations that can be configured for additional granularity and to reduce false positives.

In the following example, the evasion technique violation is enabled with the blocking enforcement mode.

It also configures all sub-violations in their relevant sections, which you can add or remove to create your desired configurations.

When you do not customize a sub-violation, it retains its default settings.

```json
{
    "policy": {
        "name": "evasions_enabled",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_EVASION",
                    "alarm": true,
                    "block": true
                }
            ],
            "evasions": [
                {
                    "description": "Bad unescape",
                    "enabled": true
                },
                {
                    "description": "Directory traversals",
                    "enabled": true
                },
                {
                    "description": "Bare byte decoding",
                    "enabled": true
                },
                {
                    "description": "Apache whitespace",
                    "enabled": true
                },
                {
                    "description": "Multiple decoding",
                    "enabled": true,
                    "maxDecodingPasses": 2
                },
                {
                    "description": "IIS Unicode codepoints",
                    "enabled": true
                },
                {
                    "description": "IIS backslashes",
                    "enabled": true
                },
                {
                    "description": "%u decoding",
                    "enabled": true
                }
            ]
        }
    }
}
```