---
# We use sentence case and present imperative tone
title: "XFF headers and trust"
# Weights are assigned in increments of 100: determines sorting order
weight: 700
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

XFF trust is disabled by default but can be enabled.

In this example, we use the default configuration but enable the trust of XFF header.

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

In this example, we configure a policy with a custom-defined XFF header.

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