---
# We use sentence case and present imperative tone
title: "XFF trusted headers"
# Weights are assigned in increments of 100: determines sorting order
weight: 2200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
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