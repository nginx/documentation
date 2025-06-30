---
nd-docs: "DOCS-1593"
---

The Detect Base64 feature allows NGINX App Protect WAF to detect whether values in headers, cookies, and parameters are Base64 encoded. When an entity is detected as Base64 encoded NGINX App Protect WAF will enforce the configured signatures on the decoded value, instead of on the original value.

This feature is disabled by default or by setting the `decodeValueAsBase64` to `disabled`.

There is a small risk that the system will wrongly detect a field value as Base64 decodable, when it's actually not. In that case signatures will not be detected properly. To mitigate this, set `decodeValueAsBase64` to `disabled` on known non Base64 entities.

```json
{
    "policy": {
        "name": "detect_base64",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "cookies": [
            {
                "name": "username",
                "type": "explicit",
                "decodeValueAsBase64": "disabled"
            }
        ],
        "parameters": [
            {
                "name": "catchPhrase",
                "type": "explicit",
                "decodeValueAsBase64": "disabled"
            }
        ],
        "headers": [
            {
                "name": "Catch-Phrase",
                "type": "explicit",
                "decodeValueAsBase64": "disabled"
            }
        ]
    }
}
```

If `decodeValueAsBase64` is set to `required`, then a violation is raised if the value is not Base64 decodable.

In this example we already know which specific entity values are Base64 decodable, so we set the value of `decodeValueAsBase64` to `required` to raise a violation if the value is not Base64 decodable:
```json
{
    "policy": {
        "name": "detect_base64",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_VALUE_BASE64",
                    "alarm": true,
                    "block": true
                }
            ]
        },

        "cookies": [
            {
                "name": "mySession",
                "type": "explicit",
                "decodeValueAsBase64": "required"
            }
        ],
        "parameters": [
            {
                "name": "myId",
                "type": "explicit",
                "decodeValueAsBase64": "required"
            }
        ],
        "headers": [
            {
                "name": "My-Header",
                "type": "explicit",
                "decodeValueAsBase64": "required"
            }
        ]
    }
}
```