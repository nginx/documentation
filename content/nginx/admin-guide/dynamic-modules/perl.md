---
description: Implement location and variable handlers in Perl and insert Perl calls
  into Server Side Includes (SSI), with the Perl dynamic module, supported by NGINX,
  Inc.
nd-docs: DOCS-397
title: Perl
toc: true
weight: 100
type:
- how-to
---

The Perl dynamic module allows implementing location and variable handlers in Perl and insert Perl calls into Server Side Includes (SSI).

## Installation

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2. Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

3. Install the Perl module package `nginx-plus-module-perl` from the official NGINX Plus repository.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-perl
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-perl
   ```

   For Debian/Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-perl
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-perl
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-perl
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-perl
   ```

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_perl_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://nginx.org/en/docs/http/ngx_http_perl_module.html).

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

- [NGINX Perl module reference](https://nginx.org/en/docs/http/ngx_http_perl_module.html)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
