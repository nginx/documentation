---
description: Protect against Layer 7 attacks such as SQLi, XSS, CSRF, LFI, and RFI,
  with the F5 NGINX ModSecurity WAF dynamic module, supported by NGINX.
nd-docs: DOCS-394
title: NGINX ModSecurity WAF
toc: true
weight: 100
type:
- how-to
---

{{< call-out "note" >}} The `nginx-plus-module-modsecurity` package is no longer available in the NGINX Plus repository.{{< /call-out >}}

NGINX ModSecurity WAF officially reached End-of-Sale status on April 1, 2022 ([NGINX Plus Release 29]({{< ref "/nginx/releases.md#r29" >}})), and End-of-Life status on March 31, 2024 ([NGINX Plus Release 32]({{< ref "/nginx/releases.md#r32" >}})).

For more details, [see this blog](https://www.f5.com/company/blog/nginx/f5-nginx-modsecurity-waf-transitioning-to-eol) announcement.

To remove the module, follow the [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}}) instructions.

## More Info

- [ModSecurity documentation](https://github.com/SpiderLabs/ModSecurity/wiki)

- [NGINX ModSecurity WAF technical specifications](https://docs.nginx.com/nginx-waf/technical-specs/)

- [Installing and configuring NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-installation-logging/)

- [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules/)

- [Using the OWASP CRS with the NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-owasp-crs/)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})
