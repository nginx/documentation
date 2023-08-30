---
description: Capture information from the client IP address in variables, using the
  [MaxMind GeoIP2](https://www.maxmind.com/en/geoip2-databases) databases, with the
  GeoIP2 dynamic module supported by NGINX, Inc.
docs: DOCS-387
doctypes:
- task
title: GeoIP2
toc: true
weight: 100
---


<span id="info"></span>
## Module Info

[MaxMind GeoIP2](https://www.maxmind.com/en/geoip2-databases) databases provide contextual data for a comprehensive profile of IP addresses, including geolocation data (region, state, city, postal code) and extra data (ISP, domain, connection type). Basing on these data, NGINX Plus will be able to perform different user differentiation strategies, for example, provide different type of content depending on a country.


<span id="install"></span>
## Installation Instructions

1. Install the GeoIP2 module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   yum install nginx-plus-module-geoip2
   ```
   Note: the GeoIP2 module cannot be installed on ppc64le version of CentOS, Oracle Linux, and RHEL.

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-geoip2
   ```
   For Alpine:

   ```shell
   apk add nginx-plus-module-geoip2
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-geoip2
   ```

2. Put both of the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directives in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_geoip2_module.so;
   load_module modules/ngx_stream_geoip2_module.so;

   http {
       # ...
   }
   ```

3. Perform additional configuration as required by the [module](https://github.com/leev/ngx_http_geoip2_module#user-content-download-maxmind-geolite2-database-optional).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [Restricting Access by Geographical Location]({{< relref "../security-controls/controlling-access-by-geoip.md" >}})

* [MaxMind GeoIP2 Databases](https://www.maxmind.com/en/geoip2-databases)

* [MaxMind Geolite2 Free Downloadable Databases](https://dev.maxmind.com/geoip/geoip2/geolite2/)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
