---
title: "Do-nothing"
weight: 1050
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

This topic describes the do-nothing policy feature of F5 WAF for NGINX.

Within _urlContentProfiles_, adding the _do-nothing_ type allows the user to avoid inspecting or parsing the content in a policy, and instead handle the request's header according to the specifications outlined in the security policy.

The following example configures do-nothing for a specific user-defined URL:

```json
{
    "policy" : {
        "name": "ignore_body",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "urls": [
            {
                "method": "*",
                "name": "*",
                "type": "wildcard",
                "urlContentProfiles": [
                    {
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "do-nothing"
                    }
                ]
            }
        ]
    }
}
```