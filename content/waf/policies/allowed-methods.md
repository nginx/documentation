---
title: "Allowed methods"
weight: 400
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

This topic describes the allowed HTTP methods for F5 WAF for NGINX.

You can use policies to specify what methods are allowed or disallowed.

## Allowed by default

To disable a method allowed by default, you can use `"$action": "delete"`.

The following example changes the default allowed method _PUT_ by removing it from the default enforcement.

The example includes the other methods that are allowed by default for reference, and do not need to be explicitly enabled:

```json
{
    "policy": {
        "name": "blocking_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_METHOD",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "methods": [
            {
                "name": "GET"
            },
            {
                "name": "POST"
            },
            {
                "name": "HEAD"
            },
            {
                "name": "PUT",
                "$action": "delete"
            },
            {
                "name": "PATCH"
            },
            {
                "name": "DELETE"
            },
            {
                "name": "OPTIONS"
            }
        ]
    }
}
```

## Custom method enforcement

To enable any custom method other than the above mentioned HTTP standard methods, the user must configure the specific modules that allow those methods.

NGINX will reject any custom method other than the standard allowed HTTP methods GET, POST, PUT, DELETE, HEAD, and OPTIONS.

For examples, view the [ngx_http_dav_module](https://nginx.org/en/docs/http/ngx_http_dav_module.html) topic.