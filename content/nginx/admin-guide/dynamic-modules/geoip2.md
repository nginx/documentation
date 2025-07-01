---
description: Capture information from the client IP address in variables, using the
  [MaxMind GeoIP2](https://www.maxmind.com/en/geoip2-databases) databases, with the
  GeoIP2 dynamic module supported by NGINX, Inc.
nd-docs: DOCS-387
title: GeoIP2
toc: true
weight: 100
type:
- how-to
---


## Module Info

[MaxMind GeoIP2](https://www.maxmind.com/en/geoip2-databases) databases provide contextual data for a comprehensive profile of IP addresses, including geolocation data (region, state, city, postal code) and extra data (ISP, domain, connection type). Basing on these data, F5 NGINX Plus will be able to perform different user differentiation strategies, for example, provide different type of content depending on a country.



## Installation

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the GeoIP2 module package `nginx-plus-module-geoip2`.

   For CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-geoip2
   ```

   {{< note >}} the GeoIP2 module cannot be installed on ppc64le version of CentOS, Oracle Linux, and RHEL. {{< /note >}}

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-geoip2
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-geoip2
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-geoip2
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-geoip2
   ```

<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of GeoIP2 modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_geoip2_module.so;
   load_module modules/ngx_stream_geoip2_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://github.com/leev/ngx_http_geoip2_module#user-content-download-maxmind-geolite2-database-optional).

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

- [Restricting Access by Geographical Location]({{< ref "nginx/admin-guide/security-controls/controlling-access-by-geoip.md" >}})

- [MaxMind GeoIP2 Databases](https://www.maxmind.com/en/geoip2-databases)

- [MaxMind Geolite2 Free Downloadable Databases](https://dev.maxmind.com/geoip/geoip2/geolite2/)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
