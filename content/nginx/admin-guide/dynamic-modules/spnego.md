---
description: This module adds [SPNEGO](https://tools.ietf.org/html/rfc4178) support
  to NGINX Plus. Currently, only Kerberos authentication via GSSAPI is supported.
docs: DOCS-401
doctypes:
- task
title: SPNEGO
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the SPNEGO Auth module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-auth-spnego
   ```

   For Debian and Ubuntu::

   ```shell
   apt-get install nginx-plus-module-auth-spnego
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-auth-spnego
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-auth-spnego
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-auth-spnego
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/spnego-http-auth-nginx-module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/stnoonan/spnego-http-auth-nginx-module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX Module for HTTP SPNEGO Auth Reference](https://github.com/stnoonan/spnego-http-auth-nginx-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})

