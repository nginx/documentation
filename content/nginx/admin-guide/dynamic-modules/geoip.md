---
description: Capture information from the client IP address in variables, using the
  MaxMind GeoIP databases, with the GeoIP dynamic module supported by NGINX, Inc.
docs: DOCS-386
doctypes:
- task
title: GeoIP
toc: true
weight: 100
---

{{< note >}} MaxMind GeoLite Legacy databases are currently [discontinued](https://blog.maxmind.com/2018/01/discontinuation-of-the-geolite-legacy-databases), MaxMind GeoIP2 or Geolite2 databases and NGINX Plus [GeoIP2 module]({{< relref "geoip2.md" >}}) should be used instead. {{< /note >}}


<span id="install"></span>
## Installation Instructions

1. Install the GeoIP module.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-geoip
   ```
   Note: Only 7.x version of CentOS, Oracle Linux, and RHEL is supported.


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

2. Put both of the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_geoip_module.so;
   load_module modules/ngx_stream_geoip_module.so;

   http {
       # ...
   }
   ```

3. Perform additional configuration as required by the module ([HTTP](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) or [TCP/UDP](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html)).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```

<span id="info"></span>
## More Info

* [GeoIP2 Dynamic Module Installation Instructions]({{< relref "geoip2.md" >}})

* [Restricting Access by Geographical Location]({{< relref "../security-controls/controlling-access-by-geoip.md" >}})

* [ngx_http_geoip_module Module Reference](https://nginx.org/en/docs/http/ngx_http_geoip_module.html)

* [ngx_stream_geoip_module Module Reference](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
