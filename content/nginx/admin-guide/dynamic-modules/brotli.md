---
description: Learn how to use the Brotli module with F5 NGINX Plus
nd-docs: DOCS-381
title: Brotli
toc: true
weight: 100
type:
- how-to
---

## Overview

Brotli is a general‑purpose, lossless data compression algorithm that uses a variant of the LZ77 algorithm, Huffman coding, and second‑order context modeling. Its compression ratio is comparable to the best currently available general‑purpose compression methods. Its speed is similar to [DEFLATE](https://www.ietf.org/rfc/rfc1951.txt) but with denser compression.

The [ngx_brotli](https://github.com/google/ngx_brotli) module enables Brotli compression in F5 NGINX Plus and consists of two modules:

- `ngx_brotli filter module` – for compressing responses on-the-fly
- `ngx_brotli static module` - for serving pre-compressed files

## Prerequisites

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2. If required, install the **epel-release** dependency

   - for Amazon Linux 2 LTS:

   ```shell
   sudo amazon-linux-extras install epel -y
   ```

   - for CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install epel-release -y
   ```
3. Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

## Installation

Install the Brotli module package `nginx-plus-module-brotli` from the official NGINX Plus repository.

- for Amazon Linux 2 LTS, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-brotli
   ```

- for Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-brotli
   ```

- for Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-brotli
   ```

- for SLES 15:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-brotli
   ```

- for FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-brotli
   ```

## Configuration

After installation you will need to enable and configure Brotli modules in NGINX Plus configuration file **nginx.conf**.

1. Enable dynamic loading of Brotli modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_brotli_filter_module.so; # for compressing responses on-the-fly
   load_module modules/ngx_http_brotli_static_module.so; # for serving pre-compressed files

   http {
       #...
   }
   ```

2. Enable Brotli compression and perform additional configuration as required by the [ngx_brotli](https://github.com/google/ngx_brotli/#configuration-directives) module. Brotli compression can be configured on the [`http`](http://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`server`](http://nginx.org/en/docs/http/ngx_http_core_module.html#server) or [`location`](http://nginx.org/en/docs/http/ngx_http_core_module.html#location) levels:

   ```nginx
   http {

       server {
           brotli on;
           #...
       }
   }
   ```

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

- [The `ngx_brotli` module GitHub project](https://github.com/google/ngx_brotli)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
