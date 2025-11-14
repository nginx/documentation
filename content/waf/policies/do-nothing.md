---
# We use sentence case and present imperative tone
title: "Do-nothing"
# Weights are assigned in increments of 100: determines sorting order
weight: 1050
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
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