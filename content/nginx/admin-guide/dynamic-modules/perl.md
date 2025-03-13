---
description: Implement location and variable handlers in Perl and insert Perl calls
  into Server Side Includes (SSI), with the Perl dynamic module, supported by NGINX,
  Inc.
docs: DOCS-397
title: Perl
toc: true
weight: 100
type:
- how-to
---

<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the Perl module package `nginx-plus-module-perl`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-perl
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-perl
   ```

   For Debian/Ubuntu:

   ```shell
   apt-get install nginx-plus-module-perl
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-perl
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-perl
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-perl
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_perl_module.so;
   ```

2. Perform additional configuration as required by the [module](https://nginx.org/en/docs/http/ngx_http_perl_module.html).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [NGINX Perl Module Reference](https://nginx.org/en/docs/http/ngx_http_perl_module.html)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
