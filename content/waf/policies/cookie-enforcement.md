---
# We use sentence case and present imperative tone
title: "Cookie enforcement"
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

This topic describes the cookie enforcement feature for F5 WAF for NGINX.

F5 WAF for NGINX generates its own cookies and adds them on top of the application cookies, referred to as enforcer cookies.

You can control the attributes within these cookies.

| Attribute name      | Default value | Alternate values | Policy defaults |
| ------------------- | ------------- | ---------------- | --------------- |
| `httpOnlyAttribute` | _true_        | _false_          | _true_ in all policies |
| `secureAttribute`   | _never_       | _always_          | _always_ in the strict and API policies |
| `sameSiteAttribute` | _lax_      | _none-value_, _strict_,  _none_ | _strict_ in the strict policy, _none_ removes the attribute entirely  |

In this example, HttpOnly is configured as `true`, Secure as `never`, and SameSite as `strict`.

```json
{
    "policy": {
        "name": "cookie_attrs_configured",
        "template": { "name":"POLICY_TEMPLATE_NGINX_BASE" },
        "enforcer-settings": {
            "enforcerStateCookies": {
                "httpOnlyAttribute": true,
                "secureAttribute": "never",
                "sameSiteAttribute": "strict"
            }
        }
    }
}
```