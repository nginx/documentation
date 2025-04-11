---
description: Integrate [JavaScript-like](https://nginx.org/en/docs/njs/) code into
  the NGINX event-processing model for HTTP or TDP/UDP, with the NGINX njs module,
  supported by NGINX, Inc.
docs: DOCS-393
title: njs Scripting Language
toc: true
weight: 100
type:
- how-to
---

## Installation

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the njs module package `nginx-plus-module-njs`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-njs
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-njs
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-njs
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-njs
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-njs
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-njs
   ```

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of njs modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_js_module.so;
   load_module modules/ngx_stream_js_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://www.nginx.com/blog/introduction-nginscript/).

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

- [njs Scripting Language Reference and Examples](https://nginx.org/en/docs/njs/)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
