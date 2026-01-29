---
nd-docs: DOCS-264
title: "XFF trusted headers"
weight: 2200
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

XFF trusted headers are disabled by default.

The following example uses the default configuration while enabling XFF trusted headers.

```json
{
    "policy": {
        "name": "xff_enabled",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "general": {
            "customXffHeaders": [],
            "trustXff": true
        }
    }
}
```

This alternative policy example enables XFF with custom-defined headers.

```json
{
    "policy": {
        "name": "xff_custom_headers",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "general": {
            "customXffHeaders": [
                "xff"
            ],
            "trustXff": true
        }
    }
}
```