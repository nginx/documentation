---
description: Implement numerous additional `set_*` directives to extend the NGINX
  core [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module,
  with the Set-Misc dynamic module supported by NGINX, Inc.
docs: DOCS-400
title: Set-Misc
toc: true
weight: 100
type:
- how-to
---


## Prerequisites

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Prior to installing the module, verify that the [NDK]({{< ref "ndk.md" >}}) module is already installed.



## Installation

Install the Set-Misc module package `nginx-plus-module-set-misc`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-set-misc
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-set-misc
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-set-misc
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-set-misc
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-set-misc
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-set-misc
   ```




## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of NDK and Set-Misc modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_set_misc_module.so;

   http {
       # ...
   }
   ```

   {{< note >}} The directives must be in this order. {{< /note >}}

2. Perform additional configuration as required by the [module](https://github.com/openresty/set-misc-nginx-module).

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



## More Info

- [NGINX `ngx_set_misc` Module Reference](https://github.com/openresty/set-misc-nginx-module)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
