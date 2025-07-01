---
description: Verify compliance with [FIPS 140-2](https://csrc.nist.gov/publications/detail/fips/140/2/final)
  security requirements for cryptographic modules.
nd-docs: DOCS-385
title: FIPS Status Check
toc: true
weight: 100
type:
- how-to
---

For F5 NGINX Plus, the cryptographic boundary includes all functionality that is implemented by the [`http_ssl`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html), [`http_v2`](https://nginx.org/en/docs/http/ngx_http_v2_module.html), [`stream_ssl`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html), and [`mail_ssl`](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html) modules. These modules implement SSL and TLS operations for inbound and outbound connections which use HTTP, HTTP/2, TCP, and mail protocols.

## Installation

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2. Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

3. Install the FIPS module package `nginx-plus-module-fips-check` from the official NGINX Plus repository.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-fips-check
   ```

   for Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-fips-check
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-fips-check
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-fips-check
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-fips-check
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-fips-check
   ```

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_fips_check_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://github.com/ogarrett/nginx-fips-check-module).

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

- [FIPS compliance for NGINX Plus]({{< ref "/nginx/fips-compliance-nginx-plus.md" >}})

- [NGINX FIPS Status Check module GitHub project](https://github.com/ogarrett/nginx-fips-check-module)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
