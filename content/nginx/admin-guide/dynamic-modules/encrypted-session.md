---
description: This dynamic module provides encryption and decryption support for NGINX
  variables based on AES-256 with MAC. It is usually used with the [Set-Misc](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/set-misc/)
  dynamic module and the NGINX [`rewrite`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html)
  module.
docs: DOCS-384
doctypes:
- task
title: Encrypted-Session
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the Encrypted-Session module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-encrypted-session
   ```

   for Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-encrypted-session
   ```
   
   For Debian and Ubuntu:
   
   ```shell
   apt-get install nginx-plus-module-encrypted-session
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-encrypted-session
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-encrypted-session
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-encrypted-session
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ndk_http_module.so;
   load_module modules/ngx_http_encrypted_session_module.so;
   ```
   
   {{< note >}} The directives must be in this order. {{< /note >}}

3. Perform additional configuration as required by the [module](https://github.com/openresty/encrypted-session-nginx-module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX encrypted-session-nginx-module Module Reference](https://github.com/openresty/encrypted-session-nginx-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
