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

 {{< note >}} The ModSecurity WAF module was deprecated since <a href="../../../releases/#r29">NGINX Plus Release 29</a>, and is no longer available since <a href="../../../releases/#r32">NGINX Plus Release 32</a> {{< /note >}}


<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the NGINX ModSecurity WAF module package `nginx-plus-module-modsecurity`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-modsecurity
   ```

   {{< note >}} ppc64le is currently not supported for Amazon Linux, CentOS, Oracle Linux, and RHEL. {{< /note >}}

   For Amazon Linux 2023:

   ```shell
   dnf install nginx-plus-module-modsecurity
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-modsecurity
   ```

   {{< note >}} aarch64 and ppc64le is currently not supported for Ubuntu.{{< /note >}}

   For SLES:

   ```shell
   zypper install nginx-plus-module-modsecurity
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-modsecurity
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_modsecurity_module.so;
   ```

2. Perform additional configuration as required by the [module](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```

4. [Configure](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-installation-logging/) the module.


<span id="info"></span>
## More Info

- [ModSecurity Documentation](https://github.com/SpiderLabs/ModSecurity/wiki)

- [NGINX ModSecurity WAF Technical Specifications](https://docs.nginx.com/nginx-waf/technical-specs/)

- [Installing and Configuring NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-installation-logging/)

- [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules/)

- [Using the OWASP CRS with the NGINX ModSecurity WAF](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-owasp-crs/)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})
