---
title: Phusion Passenger Open Source
description: Deploy and administer applications written in Node.js, Python, and Ruby with the Passenger Open Source dynamic module from Phusion, supported by NGINX, Inc.
weight: 100
doctypes: ["task"]
toc: true
docs: "DOCS-396"
---


<span id="install"></span>
## Installation Instructions

1. Install the Phusion Passenger Open Source module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
  
   ```shell
   $ yum install nginx-plus-module-passenger
   ```

   For Debian and Ubuntu:
  
   ```shell
   $ apt-get install nginx-plus-module-passenger
   ```

   For SLES:
 
   ```shell
   $ zypper install nginx-plus-module-passenger
   ```

   For Alpine:

   ```shell
   $ apk add nginx-plus-module-passenger
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_passenger_module.so;
   ```

3. Perform additional configuration as required by the [module](https://www.phusionpassenger.com/library/install/nginx/).

4. Reload NGINX Plus to enable the module:

   ```shell
   $ nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [Passenger Documentation](https://www.phusionpassenger.com/library/install/nginx/)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
