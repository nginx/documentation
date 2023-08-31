---
description: Integrate Lua co-routines into the NGINX event-processing model, with
  the Lua dynamic module, community-authored and supported by NGINX, Inc.
docs: DOCS-391
doctypes:
- task
title: Lua
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Prior to installing the Lua module, verify that the [NDK]({{< relref "ndk.md" >}}) module is already installed.

2. Install the Lua module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-lua
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-lua
   ```

   For Debian and Ubuntu:
   
   ```shell
   apt-get install nginx-plus-module-lua
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-lua
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-lua
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-lua
   ```

3. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives for NDK and Lua modules in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_lua_module.so;
   ```
   
   {{< note >}} The directives must be in this order. {{< /note >}}

4. Perform additional configuration as required by the [module](https://github.com/openresty/lua-nginx-module).

5. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX Lua Module Reference](https://github.com/openresty/lua-nginx-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
