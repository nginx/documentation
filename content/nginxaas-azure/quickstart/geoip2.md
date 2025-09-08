---
title: GeoIP2
weight: 700
toc: true
url: /nginxaas/azure/quickstart/geoip2/
type:
- how-to
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) supports GeoIP2 using the [`ngx_http_geoip2_module` or `ngx_stream_geoip2_module`](https://github.com/leev/ngx_http_geoip2_module) dynamic modules, enabling NGINXaaS to implement various user differentiation strategies. For more information on GeoIP2 with NGINX, see [NGINX GeoIP2](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/geoip2/).

NGINXaaS uses your MaxMind license to download GeoIP2 databases, puts them in the right place before NGINX starts, and updates the databases daily to reduce your operational overhead. All GeoIP2 data is deleted once you stop using GeoIP2 or delete your deployment. MaxMind provides a variety of [databases](https://www.maxmind.com/en/geoip-databases), including a lower accuracy [free option](https://www.maxmind.com/en/geolite2/signup). NGINXaaS uses a modified form of [MaxMind's `geoipupdate`](https://github.com/maxmind/geoipupdate).

## Configure

To enable GeoIP2 you [update your NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview.md">}}) to include your MaxMind license and the relevant NGINX directives.

1. Log into MaxMind and [generate a `GeoIP.conf`](https://dev.maxmind.com/geoip/updating-databases/#2-obtain-geoipconf-with-account-information) file.
2. Add the `GeoIP.conf` file to your NGINX configuration, using the exact path `/etc/nginx/GeoIP.conf`. The `GeoIP.conf` will be validated, and must include `AccountID`, `LicenseKey`, and `EditionIDs`. Other configuration options in `GeoIP.conf` are ignored.  We recommend you enable the **Protected** {{<icon "solid fa-toggle-on">}} toggle button to mark `GeoIP.conf` as a protected file, which will prevent the contents from being read via any Azure client tools.
3. Add the `load_module` directive - the modules are available at `modules/ngx_http_geoip2_module.so` or `modules/ngx_stream_geoip2_module.so`.
4. Add `geoip2` directives to your NGINX configuration as desired. The `EditionIDs` from your `GeoIP.conf` are available at `/usr/local/share/GeoIP`

{{< call-out "note" >}}NGINXaaS for Azure currently only supports the database directory at the path `/usr/local/share/GeoIP`.{{< /call-out >}}

There are many different ways to use the `geoip2` directives; For example:

```nginx
load_module modules/ngx_http_geoip2_module.so;

http {
    # "GeoLite2-City" is one of the EditionIDs in /etc/nginx/GeoIP.conf
    geoip2 /usr/local/share/GeoIP/GeoLite2-City.mmdb {
        $geoip2_city_name   city names en;
    }

    server {
        listen 80;
        server_name localhost;
        location / {
            return 200 "Hello $geoip2_city_name";
        }
    }
}
```

## Monitoring

All licenses are [validated with MaxMind](https://dev.maxmind.com/license-key-validation-api/) when initially added to your deployment, but MaxMind licenses can expire or be manually revoked.

To view the status of your MaxMind license, [enable monitoring]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}) for your NGINXaaS deployment and navigate to the Metrics tab. View the `nginxaas.maxmind` metric under the `nginxaas statistics` metric namespace. The `nginxaas.maxmind` metric reports the health of your license through the `status` dimension:

   {{<bootstrap-table "table table-striped table-bordered">}}

   | Status         | Description                                                                                |
   | -------------- | ------------------------------------------------------------------------------------------ |
   | `active`       | The license is valid and in use to update GeoIP2 databases.                                |
   | `unauthorized` | MaxMind returned an license error, which usually indicates an issue with the `GeoIP.conf`. |

   {{</bootstrap-table>}}
