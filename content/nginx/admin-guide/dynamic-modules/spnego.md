---
description: This module adds [SPNEGO](https://tools.ietf.org/html/rfc4178) support
  to F5 NGINX Plus. Currently, only Kerberos authentication via GSSAPI is supported.
docs: DOCS-401
title: SPNEGO
toc: true
weight: 100
type:
- how-to
---

## Installation

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the SPNEGO Auth module package `nginx-plus-module-auth-spnego`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-auth-spnego
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-auth-spnego
   ```

   For Debian and Ubuntu::

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-auth-spnego
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-auth-spnego
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-auth-spnego
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-auth-spnego
   ```

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/spnego-http-auth-nginx-module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://github.com/stnoonan/spnego-http-auth-nginx-module).

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

- [NGINX Module for HTTP SPNEGO Auth Reference](https://github.com/stnoonan/spnego-http-auth-nginx-module)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
