---
nd-docs: DOCS-243
title: "HTTP compliance"
weight: 1300
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

This topic describes the HTTP compliance feature for F5 WAF for NGINX.

It validates a HTTP request and also prevents the use of the HTTP protocol as an entry point to an application.

In the following example, the HTTP compliance violation is enabled with the blocking enforcement mode.

It also configures all sub-violations in their relevant sections, which you can add or remove to create your desired configurations.

When you do not customize a sub-violation, it retains its default settings.

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_HTTP_PROTOCOL",
                    "alarm": true,
                    "block": true
                }
            ],
            "http-protocols": [
                {
                    "description": "Header name with no header value",
                    "enabled": true
                },
                {
                    "description": "Chunked request with Content-Length header",
                    "enabled": true
                },
                {
                    "description": "Check maximum number of parameters",
                    "enabled": true,
                    "maxParams": 5
                },
                {
                    "description": "Check maximum number of headers",
                    "enabled": true,
                    "maxHeaders": 20
                },
                {
                    "description": "Body in GET or HEAD requests",
                    "enabled": true
                },
                {
                    "description": "Bad multipart/form-data request parsing",
                    "enabled": true
                },
                {
                    "description": "Bad multipart parameters parsing",
                    "enabled": true
                },
                {
                    "description": "Unescaped space in URL",
                    "enabled": true
                }
            ]
        }
    }
}
```