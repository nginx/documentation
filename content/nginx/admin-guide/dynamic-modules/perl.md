---
description: Implement location and variable handlers in Perl and insert Perl calls
  into Server Side Includes (SSI), with the Perl dynamic module, supported by NGINX,
  Inc.
docs: DOCS-397
doctypes:
- task
title: Perl
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the Perl module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
  
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

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_perl_module.so;
   ```

3. Perform additional configuration as required by the [module](https://nginx.org/en/docs/http/ngx_http_perl_module.html).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX Perl Module Reference](https://nginx.org/en/docs/http/ngx_http_perl_module.html)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
