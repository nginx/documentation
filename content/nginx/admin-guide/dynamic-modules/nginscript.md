---
title: njs Scripting Language
description: Integrate [JavaScript-like](https://nginx.org/en/docs/njs/) code into the NGINX event-processing model for HTTP or TDP/UDP, with the NGINX njs module, supported by NGINX, Inc.
weight: 100
doctypes: ["task"]
toc: true
docs: "DOCS-393"
---


<span id="install"></span>
## Installation Instructions

1. Install the njs module.
 
   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   $ yum install nginx-plus-module-njs
   ```
   
   For Debian and Ubuntu:
   
   ```shell
   $ apt-get install nginx-plus-module-njs
   ```

   For SLES:
   
   ```shell
   $ zypper install nginx-plus-module-njs
   ```

   For Alpine:

   ```shell
   $ apk add nginx-plus-module-njs
   ```

2. Put both of the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_js_module.so;
   load_module modules/ngx_stream_js_module.so;
   ```

3. Perform additional configuration as required by the [module](https://www.nginx.com/blog/introduction-nginscript/).

4. Reload NGINX Plus to enable the module:

   ```shell
   $ nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [njs Scripting Language Reference and Examples](https://nginx.org/en/docs/njs/)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
