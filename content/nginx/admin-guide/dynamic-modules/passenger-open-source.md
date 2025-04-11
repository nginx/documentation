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

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the Phusion Passenger Open Source module package `nginx-plus-module-passenger`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-passenger
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-passenger
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-passenger
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-passenger
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-passenger
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-passenger
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_passenger_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://www.phusionpassenger.com/library/install/nginx/).

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


<span id="info"></span>
## More Info

- [Passenger Documentation](https://www.phusionpassenger.com/library/install/nginx/)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
