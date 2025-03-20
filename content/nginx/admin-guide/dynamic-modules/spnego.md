---
description: This module adds [SPNEGO](https://tools.ietf.org/html/rfc4178) support
  to F5 NGINX Plus. Currently, only Kerberos authentication via GSSAPI is supported.
docs: DOCS-401
title: SPNEGO
toc: true
weight: 100
type:
- how-to
---

<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the SPNEGO Auth module package `nginx-plus-module-auth-spnego`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-auth-spnego
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-auth-spnego
   ```

   For Debian and Ubuntu::

   ```shell
   apt-get install nginx-plus-module-auth-spnego
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-auth-spnego
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-auth-spnego
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-auth-spnego
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/spnego-http-auth-nginx-module.so;
   ```

2. Perform additional configuration as required by the [module](https://github.com/stnoonan/spnego-http-auth-nginx-module).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [NGINX Module for HTTP SPNEGO Auth Reference](https://github.com/stnoonan/spnego-http-auth-nginx-module)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})

