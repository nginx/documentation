---
title: "Filetypes"
weight: 1125
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

This page describes the filetype feature of F5 WAF for NGINX.

Using this feature, you can enable or disable specific file types with your policies.

The following example enables the violation in blocking mode.

It allows the wildcard entity by default (All filetypes), then selectively blocks the `.bat` filetype .

```json
{
    "policy": {
        "name": "policy1",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_FILETYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "filetypes": [
            {
                "name": "*",
                "type": "wildcard",
                "allowed": true,
                "checkPostDataLength": false,
                "postDataLength": 4096,
                "checkRequestLength": false,
                "requestLength": 8192,
                "checkUrlLength": true,
                "urlLength": 2048,
                "checkQueryStringLength": true,
                "queryStringLength": 2048,
                "responseCheck": false
            },
            {
                "name": "bat",
                "allowed": false
            }
        ]
    }
}
```

You can declare any additional file types in their own section (Denoted with curly brackets), disabling them with the `"allowed": false` directive.