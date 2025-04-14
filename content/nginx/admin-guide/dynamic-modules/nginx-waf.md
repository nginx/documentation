---
description: Protect against Layer 7 attacks such as SQLi, XSS, CSRF, LFI, and RFI,
  with the F5 NGINX ModSecurity WAF dynamic module, supported by NGINX.
docs: DOCS-394
title: NGINX ModSecurity WAF
toc: true
weight: 100
type:
- how-to
---

The F5 NGINX ModSecurity web application firewall (WAF) is built on ModSecurity 3.0.

 {{< note >}} The ModSecurity WAF module was deprecated since NGINX Plus [Release 29]({{< ref "nginx/releases.md#r29" >}}), and is no longer available since NGINX Plus [Release 32]({{< ref "nginx/releases.md#r32" >}}) {{< /note >}}

## Installation

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the NGINX ModSecurity WAF module package `nginx-plus-module-modsecurity`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-modsecurity
   ```

   {{< note >}} ppc64le is currently not supported for Amazon Linux, CentOS, Oracle Linux, and RHEL. {{< /note >}}

   For Amazon Linux 2023:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-modsecurity
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-modsecurity
   ```

   {{< note >}} aarch64 and ppc64le is currently not supported for Ubuntu.{{< /note >}}

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-modsecurity
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-modsecurity
   ```

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_modsecurity_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual).

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

5. [Configure](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-installation-logging/) the module.

## More Info

- [ModSecurity Documentation](https://github.com/SpiderLabs/ModSecurity/wiki)

- [NGINX ModSecurity WAF Technical Specifications](https://docs.nginx.com/nginx-waf/technical-specs/)

- [Installing and Configuring NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-installation-logging/)

- [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules/)

- [Using the OWASP CRS with the NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-owasp-crs/)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})
