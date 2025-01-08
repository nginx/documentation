---
description: null
docs: DOCS-391
doctypes:
- task
title: Lua
toc: true
weight: 100
---

Integrate Lua co-routines into the NGINX event-processing model with the community-authored Lua dynamic module.

<span id="prereq"></span>
## Prerequisites

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Prior to installing the module, verify that the [NGINX Developer Kit (NDK)]({{< relref "nginx/admin-guide/dynamic-modules/ndk.md" >}}) module is already installed.


<span id="install"></span>
## Installation

   Install the Lua module package `nginx-plus-module-lua`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

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


<span id="configure"></span>

## Configuration

After installation, enable and configure the modules in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of NDK and Lua modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_lua_module.so;
   load_module modules/ngx_stream_lua_module.so;
   ```

   {{< note >}} The `ndk_http_module.so` module must be placed first. {{< /note >}}

2. Configure additional settings as needed for the modules. For details, see the [`lua-nginx-module`](https://github.com/openresty/lua-nginx-module) and [`stream-lua-nginx-module`](https://github.com/openresty/stream-lua-nginx-module) documentation.

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [The `lua-nginx-module` Module Reference](https://github.com/openresty/lua-nginx-module)

- [The `stream-lua-nginx-module` Module Reference](https://github.com/openresty/stream-lua-nginx-module)

- [The NDK Module Reference](https://github.com/vision5/ngx_devel_kit)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
