---
# We use sentence case and present imperative tone
title: "Filetypes"
# Weights are assigned in increments of 100: determines sorting order
weight: 1125
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
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