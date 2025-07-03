---
description: ''
nd-docs: DOCS-391
title: Lua
toc: true
weight: 100
type:
- how-to
---

Integrate Lua co-routines into the NGINX event-processing model with the community-authored Lua dynamic module.

## Prerequisites

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2. Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

3. Prior to installing the module, verify that the [NGINX Developer Kit (NDK)]({{< ref "/nginx/admin-guide/dynamic-modules/ndk.md" >}}) module is already installed.

## Installation

   Install the Lua module package `nginx-plus-module-lua` from the official NGINX Plus repository.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-lua
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-lua
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-lua
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-lua
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-lua
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-lua
   ```

## Configuration

After installation, enable and configure the modules in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of NDK and Lua modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_lua_module.so;
   load_module modules/ngx_stream_lua_module.so;

   http {
       # ...
   }

   stream {
       # ...
   }
   ```

   {{< note >}} The `ndk_http_module.so` module must be placed first. {{< /note >}}

2. Configure additional settings as needed for the modules. For details, see the [`lua-nginx-module`](https://github.com/openresty/lua-nginx-module) and [`stream-lua-nginx-module`](https://github.com/openresty/stream-lua-nginx-module) documentation.

3. Test the NGINX Plus configuration. In a terminal, type-in the command:

    ```shell
    nginx -t
    ```

    Expected output of the command:

    ```shell
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf is successful
    ```

4. Reload the NGINX Plus configuration to enable the module:

    ```shell
    nginx -s reload
    ```

## More info

- [The `lua-nginx-module` GitHub Project](https://github.com/openresty/lua-nginx-module)

- [The `stream-lua-nginx-module` Module Reference](https://github.com/openresty/stream-lua-nginx-module)

- [The NDK Module GitHub project](https://github.com/vision5/ngx_devel_kit)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
