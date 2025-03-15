---
description: Stream video in multiple formats, including  Real-Time Messaging Protocol
  (RTMP), HLS, and DASH, with the RTMP dynamic module, supported by NGINX, Inc.
docs: DOCS-399
title: RTMP
toc: true
weight: 100
type:
- how-to
---

<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the RTMP Media Streaming module package `nginx-plus-module-rtmp`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-rtmp
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-rtmp
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

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-rtmp
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_rtmp_module.so;
   ```

2. Perform additional configuration as required by the [module](https://github.com/arut/nginx-rtmp-module).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [NGINX RTMP Module Reference](https://github.com/arut/nginx-rtmp-module)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
