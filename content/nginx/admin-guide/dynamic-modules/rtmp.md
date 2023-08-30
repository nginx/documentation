---
description: Stream video in multiple formats, including  Real-Time Messaging Protocol
  (RTMP), HLS, and DASH, with the RTMP dynamic module, supported by NGINX, Inc.
docs: DOCS-399
doctypes:
- task
title: RTMP
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the RTMP Media Streaming module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-rtmp
   ```

   For Debian and Ubuntu:
   
   ```shell
   apt-get install nginx-plus-module-rtmp
   ```

   For SLES:
   
   ```shell
   zypper install nginx-plus-module-rtmp
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-rtmp
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_rtmp_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/arut/nginx-rtmp-module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX RTMP Module Reference](https://github.com/arut/nginx-rtmp-module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
