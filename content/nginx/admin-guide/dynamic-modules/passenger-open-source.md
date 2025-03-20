---
description: Deploy and administer applications written in Node.js, Python, and Ruby
  with the Passenger Open Source dynamic module from Phusion, supported by NGINX,
  Inc.
docs: DOCS-396
title: Phusion Passenger Open Source
toc: true
weight: 100
type:
- how-to
---

<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the Phusion Passenger Open Source module package `nginx-plus-module-passenger`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-passenger
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-passenger
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-passenger
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-passenger
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-passenger
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-passenger
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_passenger_module.so;
   ```

2. Perform additional configuration as required by the [module](https://www.phusionpassenger.com/library/install/nginx/).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [Passenger Documentation](https://www.phusionpassenger.com/library/install/nginx/)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
