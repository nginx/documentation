---
# We use sentence case and present imperative tone
title: "Data guard"
# Weights are assigned in increments of 100: determines sorting order
weight: 800
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes the data guard feature of F5 WAF for NGINX.

Data guard is a security feature that can be used to prevent the leakage of sensitive information from an application. 

Examples include credit card numbers (CCN), Social Security numbers (SSN) or custom-defined patterns. 

Sensitive data is either blocked or masked based on configuration.

The following example enables _blocking mode_:

```json
{
    "policy": {
        "name": "dataguard_blocking",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": true,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": []
        }
    }
}
```

{{< call-out "note" >}}

In _blocking mode_, data masking has no effect.

{{< /call-out >}}

This next example enables _alarm mode_, which allows you to use data masking.

Data masking allows a page to load while masking all sensitive data.

```json
{
    "policy": {
        "name": "nginx_default_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": false
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": true,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": []
        }
    }
}
```

This final example shows partial masking using a custom pattern.

Custom patterns are defined in _customPatternsList_, with the numbers of unmasked leading and trailing characters defined by _firstCustomCharactersToExpose_ and _lastCustomCharactersToExpose_, respectively.

```json
{
    "policy": {
        "name": "custom_pattern_mask_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": false
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": false,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": [],
            "customPatterns": true,
            "firstCustomCharactersToExpose": 2,
            "lastCustomCharactersToExpose": 4,
            "customPatternsList": [
               "....-....-....-....",
               "siteTk_[0-9]+"
            ]
        }
    }
}
```