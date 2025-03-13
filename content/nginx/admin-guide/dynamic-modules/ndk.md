---
description: null
docs: DOCS-392
title: NGINX Developer Kit
toc: true
weight: 100
type:
- how-to
---

The NGINX Developer Kit (NDK) module makes it easier for module developers to develop NGINX modules.

The NDK module is also a prerequisite for [Encrypted Session]({{< relref "encrypted-session.md" >}}), [Lua]({{< relref "lua.md" >}}), and [Set-Misc]({{< relref "set-misc.md" >}}) modules.


<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the NDK module package `nginx-plus-module-ndk`.

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


<span id="configure"></span>
## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ndk_http_module.so;
   ```

2. Perform additional configuration as required by the [module](https://github.com/vision5/ngx_devel_kit).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [NDK Module Reference](https://github.com/vision5/ngx_devel_kit)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
