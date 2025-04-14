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

> **Note**: The module was deprecated in [Release 23]({{< ref "nginx/releases.md#r23" >}}) and removed in [Release 26]({{< ref "nginx/releases.md#r26" >}}). The [`proxy_cookie_flags`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive implements native support for setting cookie flags and replaces the module. See [Native Method for Setting Cookie Flags](https://www.nginx.com/blog/nginx-plus-r23-released#cookie-flags) for details.

## Installation

1. Install the Cookie-Flag module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-cookie-flag
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-cookie-flag
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-cookie-flag
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-cookie-flag
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of F5 NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_cookie_flag_filter_module.so;

   http {
       # ...
   }
   ```

3. Perform additional configuration as required by the [module](https://github.com/AirisX/nginx_cookie_flag_module).

4. Test the NGINX Plus configuration. In a terminal, type-in the command:

    ```shell
    nginx -t
    ```

    Expected output of the command:

    ```shell
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf is successful
    ```

5. Reload the NGINX Plus configuration to enable the module:

    ```shell
    nginx -s reload
    ```

## More Info

- [NGINX Module Reference for Adding Cookie Flag](https://github.com/AirisX/nginx_cookie_flag_module)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
