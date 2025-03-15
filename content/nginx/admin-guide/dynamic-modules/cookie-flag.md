---
description: Set `HttpOnly`, `SameSite`, and `secure` flags on cookies in `Set-Cookie`
  upstream response headers with the **Cookie-Flag** dynamic module, community-authored
  and supported by NGINX, Inc.
docs: DOCS-382
title: Cookie-Flag
toc: true
weight: 100
type:
- how-to
---

> **Note**: The module was deprecated in <a href="../../../releases/#r23">Release 23</a> and removed in <a href="../../../releases/#r26">Release 26</a>. The [`proxy_cookie_flags`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive implements native support for setting cookie flags and replaces the module. See [Native Method for Setting Cookie Flags](https://www.nginx.com/blog/nginx-plus-r23-released#cookie-flags) for details.


<span id="install"></span>
## Installation Instructions

1. Install the Cookie-Flag module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-cookie-flag
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-cookie-flag
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-cookie-flag
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-cookie-flag
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of F5 NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_cookie_flag_filter_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/AirisX/nginx_cookie_flag_module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [NGINX Module Reference for Adding Cookie Flag](https://github.com/AirisX/nginx_cookie_flag_module)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
