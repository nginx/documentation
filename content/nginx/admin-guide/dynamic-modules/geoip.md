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

{{< note >}} MaxMind GeoLite Legacy databases are currently [discontinued](https://blog.maxmind.com/2018/01/discontinuation-of-the-geolite-legacy-databases), MaxMind GeoIP2 or Geolite2 databases and F5 NGINX Plus [GeoIP2 module]({{< relref "geoip2.md" >}}) should be used instead. {{< /note >}}


<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the GeoIP module package `nginx-plus-module-geoip`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-geoip
   ```

   {{< note >}} Only 7.x version of CentOS, Oracle Linux, and RHEL is supported. {{< /note >}}


   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-geoip
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-geoip
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-geoip
   ```

<span id="configure"></span>

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

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```

<span id="info"></span>
## More Info

- [GeoIP2 Dynamic Module Installation Instructions]({{< relref "geoip2.md" >}})

- [Restricting Access by Geographical Location]({{< relref "../security-controls/controlling-access-by-geoip.md" >}})

- [ngx_http_geoip_module Module Reference](https://nginx.org/en/docs/http/ngx_http_geoip_module.html)

- [ngx_stream_geoip_module Module Reference](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
