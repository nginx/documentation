---
description: ''
nd-docs: DOCS-384
title: Encrypted-Session
toc: true
weight: 100
type:
- how-to
---

The Encrypted Session dynamic module provides encryption and decryption support for NGINX variables based on AES-256 with MAC. It is usually used with the [Set-Misc]({{< ref "/nginx/admin-guide/dynamic-modules/set-misc.md" >}}) dynamic module and the NGINX [`rewrite`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module.

## Prerequisites

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2.  Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

3. Prior to installing the module, verify that the [NDK]({{< ref "ndk.md" >}}) module is already installed.

## Installation

1. Install the Encrypted Session module package `nginx-plus-module-encrypted-session` from the official NGINX Plus repository.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-encrypted-session
   ```

   for Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-encrypted-session
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-encrypted-session
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-encrypted-session
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-encrypted-session
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-encrypted-session
   ```

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_encrypted_session_module.so;

   http {
       # ...
   }
   ```

   {{< call-out "note" >}} The directives must be in this order. {{< /call-out >}}

2. Perform additional configuration as required by the [module](https://github.com/openresty/encrypted-session-nginx-module).

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

- [The `encrypted-session-nginx-module` module GitHub project](https://github.com/openresty/encrypted-session-nginx-module)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
