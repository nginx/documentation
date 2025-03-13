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

<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the njs module package `nginx-plus-module-njs`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-njs
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-njs
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-njs
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-njs
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-njs
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-njs
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of njs modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_js_module.so;
   load_module modules/ngx_stream_js_module.so;
   ```

2. Perform additional configuration as required by the [module](https://www.nginx.com/blog/introduction-nginscript/).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [njs Scripting Language Reference and Examples](https://nginx.org/en/docs/njs/)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
