---
description: Deploy and administer applications written in Node.js, Python, and Ruby
  with the Passenger Open Source dynamic module from Phusion, supported by NGINX,
  Inc.
nd-docs: DOCS-396
title: Phusion Passenger Open Source
toc: true
weight: 100
type:
- how-to
---

The Passenger Open Source dynamic module from Phusion enables deployment and administration of applications written in Node.js, Python, and Ruby.

## Installation

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2. Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

3. Install the Phusion Passenger Open Source module package `nginx-plus-module-passenger` from the official NGINX Plus repository.

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

## More Info

- [Passenger documentation](https://www.phusionpassenger.com/library/install/nginx/)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
