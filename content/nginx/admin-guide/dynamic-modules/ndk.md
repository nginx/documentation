---
description: The NDK module makes it easier for module developers to develop NGINX
  modules.
docs: DOCS-392
doctypes:
- task
title: NGINX Developer Kit
toc: true
weight: 100
---


The NDK module is also a prerequisite for [Lua]({{< relref "lua.md" >}}) and [Set-Misc]({{< relref "set-misc.md" >}}) modules.

<span id="install"></span>
## Installation Instructions

1. Install the NDK module.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-ndk
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-ndk
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-ndk
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-ndk
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-ndk
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-ndk
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ndk_http_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/vision5/ngx_devel_kit).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NDK Module Reference](https://github.com/vision5/ngx_devel_kit)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
