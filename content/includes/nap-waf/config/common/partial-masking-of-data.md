---
nd-docs: "DOCS-1559"
---

Here is an example showing partial masking on custom patterns. Custom patterns are specified in `customPatternsList`, number of unmasked leading and trailing characters are defined in `firstCustomCharactersToExpose` and `lastCustomCharactersToExpose` parameters.

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