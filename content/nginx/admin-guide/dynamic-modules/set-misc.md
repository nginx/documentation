---
title: Set-Misc
description: Implement numerous additional `set_*` directives to extend the NGINX core [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module, with the Set-Misc dynamic module supported by NGINX, Inc.
weight: 100
doctypes: ["task"]
toc: true
docs: "DOCS-400"
---


<span id="install"></span>
## Installation Instructions

1. Prior to installing the Set-Misc module, verify that the [NDK]({{< relref "ndk.md" >}}) module is already installed.

2. Install the Set-Misc module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
      
   ```shell
   $ yum install nginx-plus-module-set-misc
   ```

   For Debian and Ubuntu:
   
   ```shell
   $ apt-get install nginx-plus-module-set-misc
   ```

   For SLES:
   
   ```shell
   $ zypper install nginx-plus-module-set-misc
   ```

   For Alpine:

   ```shell
   $ apk add nginx-plus-module-set-misc
   ```

3. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives  for NDK and Set-Misc modules in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_set_misc_module.so;
   ```
   
   > **Note:** The directives must be in this order.

4. Perform additional configuration as required by the [module](https://github.com/openresty/set-misc-nginx-module).

5. Reload NGINX Plus to enable the module:

   ```shell
   $ nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX `ngx_set_misc` Module Reference](https://github.com/openresty/set-misc-nginx-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
