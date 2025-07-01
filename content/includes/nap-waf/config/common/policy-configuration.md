---
nd-docs: "DOCS-1548"
---

The NGINX App Protect WAF ships with two reference policies, both with a default enforcement mode set to Blocking:
- The **default** policy which is identical to the base template and provides OWASP Top 10 and Bot security protection out of the box.
- The **strict** policy contains more restrictive criteria for blocking traffic than the default policy. It is meant to be used for protecting sensitive applications that require more security but with higher risk of false positives.
You can use those policies as is, but usually you will use them as starting points and further customize them to the needs of the applications they protect.