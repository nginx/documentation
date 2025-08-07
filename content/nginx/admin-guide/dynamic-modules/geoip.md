---
description: Capture information from the client IP address in variables, using the
  MaxMind GeoIP databases, with the GeoIP dynamic module supported by NGINX, Inc.
nd-docs: DOCS-386
title: GeoIP
toc: true
weight: 100
type:
- how-to
---

The GeoIP dynamic module captures information from the client IP address in variables using the MaxMind GeoLite databases.

{{< call-out "note" >}} MaxMind GeoLite Legacy databases are currently [discontinued](https://blog.maxmind.com/2018/01/discontinuation-of-the-geolite-legacy-databases), MaxMind GeoIP2 or Geolite2 databases and F5 NGINX Plus [GeoIP2 module]({{< ref "geoip2.md" >}}) should be used instead. {{< /call-out >}}

## Installation

1. Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) page to verify that the module is supported by your operating system.

2. Make sure that your operating system is configured to retrieve binary packages from the official NGINX Plus repository. See installation instructions for your operating system on the [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) page.

3. Install the GeoIP module package `nginx-plus-module-geoip` from the official NGINX Plus repository.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-geoip
   ```

   {{< call-out "note" >}} Only 7.x version of CentOS, Oracle Linux, and RHEL is supported. {{< /call-out >}}


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

   stream {
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

## More info

- [GeoIP2 dynamic module]({{< ref "geoip2.md" >}})

- [Restricting access by geographical location]({{< ref "/nginx/admin-guide/security-controls/controlling-access-by-geoip.md" >}})

- [NGINX `ngx_http_geoip_module` module reference](https://nginx.org/en/docs/http/ngx_http_geoip_module.html)

- [NGINX `ngx_stream_geoip_module` module reference](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
