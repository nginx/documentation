---
nd-docs: "DOCS-1608"
---

F5 WAF for NGINX generates its own cookies and adds them on top of the application cookies.

These are called Enforcer Cookies.

You can control the attributes within these cookies:

* `httpOnlyAttribute`: Whether or not to add HttpOnly attribute, value is either `true` or `false`, default is **true**.
* `secureAttribute`: Whether or not to add Secure attribute, value is either `always` or `never`, default is **always**.
* `sameSiteAttribute`: In which mode to add SameSite attribute, value is one of: `none-value`, `lax`, `strict` or `none`, default is **strict**. Use `none` in order to not add this attribute to the cookie at all.

In this example, we configure HttpOnly to be `true`, Secure to be `never`, and SameSite to be `strict`.

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

* `httpOnlyAttribute`: Default value was `true` for all policies.
* `secureAttribute`: Default value was `never` in the default policy, and `always` in the strict and API policies.
* `sameSiteAttribute`: Default value was `lax` in the default and API policies, and `strict` in the strict policy.