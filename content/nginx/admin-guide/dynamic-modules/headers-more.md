---
description: Set and clear input and output headers to extend the NGINX core [Headers](https://nginx.org/en/docs/http/ngx_http_headers_module.html)
  module, with the Headers-More dynamic module supported by NGINX, Inc.
docs: DOCS-388
doctypes:
- task
title: Headers-More
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the Headers-More module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-headers-more
   ```
   
   For Debian and Ubuntu:
   
   ```shell
   apt-get install nginx-plus-module-headers-more
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-headers-more
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-headers-more
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-headers-more
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_headers_more_filter_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/openresty/headers-more-nginx-module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX ngx_headers_more Module Reference](https://github.com/openresty/headers-more-nginx-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
