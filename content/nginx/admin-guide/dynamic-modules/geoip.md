---
description: Capture information from the client IP address in variables, using the
  MaxMind GeoIP databases, with the GeoIP dynamic module supported by NGINX, Inc.
docs: DOCS-386
title: GeoIP
toc: true
weight: 100
type:
- how-to
---

{{< note >}} MaxMind GeoLite Legacy databases are currently [discontinued](https://blog.maxmind.com/2018/01/discontinuation-of-the-geolite-legacy-databases), MaxMind GeoIP2 or Geolite2 databases and F5 NGINX Plus [GeoIP2 module]({{< ref "geoip2.md" >}}) should be used instead. {{< /note >}}

## Installation

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the GeoIP module package `nginx-plus-module-geoip`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-geoip
   ```

   {{< note >}} Only 7.x version of CentOS, Oracle Linux, and RHEL is supported. {{< /note >}}


   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-geoip
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-geoip
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-geoip
   ```

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of GeoIP modules with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_geoip_module.so;
   load_module modules/ngx_stream_geoip_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the module ([HTTP](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) or [TCP/UDP](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html)).

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

- [GeoIP2 Dynamic Module Installation Instructions]({{< ref "geoip2.md" >}})

- [Restricting Access by Geographical Location]({{< ref "nginx/admin-guide/security-controls/controlling-access-by-geoip.md" >}})

- [ngx_http_geoip_module Module Reference](https://nginx.org/en/docs/http/ngx_http_geoip_module.html)

- [ngx_stream_geoip_module Module Reference](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
