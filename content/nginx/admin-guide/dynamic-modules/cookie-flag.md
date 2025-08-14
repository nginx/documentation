---
description: Set `HttpOnly`, `SameSite`, and `secure` flags on cookies in `Set-Cookie`
  upstream response headers with the **Cookie-Flag** dynamic module, community-authored
  and supported by NGINX, Inc.
nd-docs: DOCS-382
title: Cookie-Flag
toc: true
weight: 100
type:
- how-to
---

{{< call-out "note" >}} The `nginx-plus-module-cookie-flag` package is no longer available in the NGINX Plus repository.{{< /call-out >}}

The module was deprecated in [NGINX Plus Release 23]({{< ref "/nginx/releases.md#r23" >}}) and removed in [NGINX Plus Release 26]({{< ref "/nginx/releases.md#r26" >}}). Its functionality has been replaced with natively supported [`proxy_cookie_flags`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive.

To remove the module, follow the [Uninstalling a dynamic module]({{< ref "uninstall.md" >}}) instructions.

To learn how to replace the module with the native solution, see [Native Method for Setting Cookie Flags](https://www.nginx.com/blog/nginx-plus-r23-released#cookie-flags) and the [`proxy_cookie_flags`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive.


## More info

- [NGINX module reference for adding Cookie flag](https://github.com/AirisX/nginx_cookie_flag_module)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
