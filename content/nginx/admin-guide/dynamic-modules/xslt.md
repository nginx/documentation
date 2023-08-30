---
description: Modify XML code in response bodies using one or more XSLT stylesheets,
  with the XSLT dynamic module, supported by NGINX, Inc.
docs: DOCS-403
doctypes:
- task
title: XSLT
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the XSLT module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-xslt
   ```

   For Amazon Linux 2023:

   ```shell
   dnf install nginx-plus-module-xslt
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-xslt
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-xslt
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-xslt
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-xslt
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_xslt_module.so;
   ```

3. Perform additional configuration as required by the [module](https://nginx.org/en/docs/http/ngx_http_xslt_module.html).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX ngx_http_xslt_module Reference](https://nginx.org/en/docs/http/ngx_http_xslt_module.html)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
