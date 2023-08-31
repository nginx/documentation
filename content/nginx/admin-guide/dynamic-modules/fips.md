---
description: Verify compliance with [FIPS 140-2](https://csrc.nist.gov/publications/detail/fips/140/2/final)
  security requirements for cryptographic modules.
docs: DOCS-385
doctypes:
- task
title: FIPS Status Check
toc: true
weight: 100
---


For NGINX Plus, the cryptographic boundary includes all functionality that is implemented by the [`http_ssl`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html), [`http_v2`](https://nginx.org/en/docs/http/ngx_http_v2_module.html), [`stream_ssl`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html), and [`mail_ssl`](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html) modules. These modules implement SSL and TLS operations for inbound and outbound connections which use HTTP, HTTP/2, TCP, and mail protocols.


<span id="install"></span>
## Installation Instructions

1. Install the FIPS module.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-fips-check
   ```

   for Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-fips-check
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-fips-check
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-fips-check
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-fips-check
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-fips-check
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_fips_check_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/ogarrett/nginx-fips-check-module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [FIPS Compliance for NGINX Plus](https://docs.nginx.com/nginx/fips-compliance-nginx-plus/)

* [NGINX FIPS Status Check Module Reference](https://github.com/ogarrett/nginx-fips-check-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
