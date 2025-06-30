---
description: Expose Prometheus metrics endpoint directly from F5 NGINX Plus.
nd-docs: DOCS-398
title: Prometheus-njs
toc: true
weight: 100
type:
- how-to
---

<span id="info"></span>
## Module Info

The `nginx-plus-module-prometheus` module is an [njs](https://nginx.org/en/docs/njs/) module that converts miscellaneous F5 NGINX Plus status metrics exposed by the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html) module to a Prometheus compliant format. The module uses subrequests to the `/api` endpoint to access the metrics.
In case you have configured [dynamic upstream routing](#prom_keyval) with generic names for upstream groups, the module can understand replacements for these names and display the correct statistics.


<span id="data"></span>
## Exported Metrics

The following NGINX Plus status metrics are exported to Prometheus:

- [nginx](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_object): `/nginx`
- [Processes](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_processes): `/processes`
- [Resolvers](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_resolver_zone): `/resolvers/`
- [Connections](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_connections): `/connections`
- [SSL](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_ssl_object): `/ssl`
- [Slabs](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_slab_zone): `/slabs/`
- [Workers](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_worker): `/workers/`
- [HTTP](https://nginx.org/en/docs/http/ngx_http_api_module.html#http_): `/http/`
- [HTTP Requests](http://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_requests): `/http/requests`
- [HTTP Caches](http://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_cache): `/http/caches/`
- [HTTP Server Zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_server_zone): `/http/server_zones/`
- [HTTP Location Zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_location_zone): `/http/location_zones/`
- [HTTP Upstreams](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream): `/http/upstreams/`
- [HTTP Limit Conn](http://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_limit_conn_zone): `/http/limit_conns/`
- [HTTP Limit Req](http://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_limit_req_zone): `/http/limit_reqs/`
- [Stream Server Zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_server_zone): `/stream/server_zones/`
- [Stream Zone Sync](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_server_zone): `/stream/zone_sync/`
- [Stream Upstreams](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_upstream): `/stream/upstreams/`
- [Stream Limit Conn](http://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_limit_conn_zone): `/stream/limit_conns/`

{{< note >}} The `state` metric values in [`/http/upstreams/`](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream) and [`/stream/upstreams/`](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_upstream) are converted using the following rule:


{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|NGINX | Prometheus |
| ---| --- |
|"up" | `1` |
|"draining" | `2` |
|"down" | `3` |
|"unavail" | `4` |
|"checking" | `5` |
|"unhealthy" | `6` |

{{</bootstrap-table>}}
{{< /note >}}

<span id="install"></span>
## Installation

Install the `nginx-plus-module-prometheus` module.

- For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

  ```shell
  sudo yum install nginx-plus-module-prometheus
  ```

- For Amazon Linux 2023, AlmaLinux, Rocky Linux:

  ```shell
  sudo dnf install nginx-plus-module-prometheus
  ```

- For Debian and Ubuntu:

  ```shell
  sudo apt install nginx-plus-module-prometheus
  ```

- For SLES:

  ```shell
  sudo zypper install nginx-plus-module-prometheus
  ```

- For Alpine:

  ```shell
  apk add nginx-plus-module-prometheus
  ```

  For FreeBSD:

  ```shell
  sudo pkg install nginx-plus-module-prometheus
  ```

{{< note >}} The [`nginx-plus-module-njs`]({{< ref "nginscript.md" >}}) module will also be installed together with the module. {{< /note >}}


<span id="conf"></span>
## Configuration

After module installation, perform the following steps in NGINX Plus configuration file (**nginx.conf**):

1. Enable the [`nginx-plus-module-njs`]({{< ref "nginscript.md" >}}) module in the top‑level context:

   ```nginx
   load_module modules/ngx_http_js_module.so;

   http {
       # ...
   }
   ```

2. [Include](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_import) the `prometheus.js` file:

   ```nginx
   http {
       # ...
       js_import /usr/share/nginx-plus-module-prometheus/prometheus.js;
   }
   ```

3. [Create](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) a location for Prometheus metrics, for example, `/metrics`:

   ```nginx
   location = /metrics {
       js_content prometheus.metrics;
   }
   ```

4. [Enable](https://nginx.org/en/docs/http/ngx_http_api_module.html#api) the API to be able to expose the `/metrics` endpoint from Prometheus:

   ```nginx
   location /api {
       api;
       #...
   }
   ```

5. (optional, in case of "`too big subrequest response`" error in error log) Since the module uses subrequests for API calls, you may need to [increase](https://nginx.org/en/docs/http/ngx_http_core_module.html#subrequest_output_buffer_size) the size of the buffer that stores the response body of a subrequest:

   ```nginx
   http {
       # ...
       subrequest_output_buffer_size 32k;
   }
   ```

6. Configure Prometheus to obtain metrics from NGINX Plus by specifying the network address of the NGINX Plus instance in a [scrape_config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) section of the Prometheus configuration file.


<span id="upgrade"></span>
## Upgrade Instructions

When upgrading Prometheus-njs version to version 1.3.1 and later, it is important to update NGINX Plus configuration file with the changes introduced in NGINX Plus [R22](https://www.nginx.com/blog/nginx-plus-r22-released/) and [njs 0.4.0](https://www.nginx.com/blog/nginx-plus-r22-released#njs):

- the [`js_include`](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_include) directive is deprecated
- the [`js_import`](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_import) directive is used instead of [js_include](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_include)
- the [`js_content`](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_content) and [`js_set`](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_set) directives can reference a module function

See [Configuration](#conf) for the example of Prometheus-njs configuration in NGINX Plus configuration file.


<span id="vars"></span>
## Module Variables

The module supports several embedded variables:

- [`$prom_keyval`](#prom_keyval)
- [`$prom_keyval_stream`](#prom_keyval_stream)
- [`$prom_metrics_disabled`](#prom_metrics_disabled)

The variables can be set in NGINX Plus configuration file with the [`set`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set) directive.


<span id="prom_keyval"></span>
### Using the $prom_keyval Variable

The `$prom_keyval` variable has been created to correctly show statistics for dynamic configuration of upstream routing: when names of upstreams are generic and these names are dynamically replaced by real names from the [key-value](https://nginx.org/en/docs/http/ngx_http_keyval_module.html) storage.

To add the `$prom_keyval` variable, add the [`set`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set) directive to the location that exposes metrics to Prometheus (for example, `= /metrics`), in the following format:

```nginx
set $prom_keyval "upstream_keyval";
```

where `$prom_keyval` will hold all values from `upstream_keyval` key-value storage specified in the [`keyval_zone`](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive:

```nginx
http {

    #...

    keyval_zone zone=upstream_keyval:64k;
    keyval      $domain $upstream zone=http_upstream_keyval;

    upstream 0 {
        zone   http_backend 64k;
        server backend1.example.com;
        server backend2.example.com;
    }

    server {
        #...

        location / {
            proxy_pass http://$upstream;
            #...
        }

        location /api {
            api;
            #...
        }

        location = /metrics {
            set        $prom_keyval "http_upstream_keyval";
            js_content prometheus.metrics;
        }
    }
}
```


<span id="prom_keyval_stream"></span>
### Using the $prom_keyval_stream Variable

In order to perform dynamic replacements in the [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context, you will need to specify a new key-value storage in the stream block and set the name of the key-value storage in the `$prom_keyval_stream` variable:

```nginx

http {

    # the contents of the 'http' block is the same as for the $prom_keyval example
    # except the 'location /metrics' block:
    # ...

        location = /metrics {
            set $prom_keyval        "http_upstream_keyval";
            set $prom_keyval_stream "stream_upstream_keyval";
            js_content              prometheus.metrics;
        }
    }
}

stream {

    keyval_zone zone=stream_keyval:32k;

    upstream stream_backend {
        zone   stream_backend 64k;
        server backend1.example.com:12345;
        server backend2.example.com:12345;
    }

    server {
        listen 12345;

        proxy_pass  stream_backend;
        status_zone backend_stream_zone;
    }
}
```


<span id="prom_metrics_disabled"></span>
### Using the $prom_metrics_disabled Variable

The `$prom_metrics_disabled` variable disables exporting particular NGINX Plus status metrics to Prometheus. If you are concerned about the amount of storage NGINX Plus metrics are taking in Prometheus, you can disable particular endpoints via this variable. The variable value must be a comma separated list of NGINX Plus endpoints:

```nginx
#...
location /metrics {
    set $prom_keyval           "http_upstream_keyval";
    set $prom_keyval_stream    "stream_upstream_keyval";
    set $prom_metrics_disabled "stream/upstreams, resolvers";
    js_content                 prometheus.metrics;
}
#...
```

You can disable exporting the following NGINX Plus status metrics to Prometheus:

- `nginx`
- `processes`
- `resolvers`
- `connections`
- `ssl`
- `slabs`
- `workers`
- `http/requests`
- `http/caches`
- `http/upstreams`
- `http/server_zones`
- `http/location_zones`
- `http/limit_conns`
- `http/limit_reqs`
- `stream/upstreams`
- `stream/server_zones`
- `stream/zone_sync`
- `stream/limit_conns`


<span id="example"></span>
## Example

```nginx
load_module modules/ngx_http_js_module.so;

#...

http {

    js_import /usr/share/nginx-plus-module-prometheus/prometheus.js;

    subrequest_output_buffer_size 32k;

    upstream backend {
        zone   backend 64k;
        server backend1.example.com;
        server backend2.example.com;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
        }

        location /api {
            api;
        }

        location = /metrics {
            set $prom_keyval           "http_upstream_keyval";
            set $prom_keyval_stream    "stream_upstream_keyval";
            set $prom_metrics_disabled "stream/upstreams, resolvers";
            js_content                 prometheus.metrics;
        }

        status_zone backend_zone;
    }
}

stream {

    keyval_zone zone=stream_keyval:32k;

    upstream stream_backend {
        zone   stream_backend 64k;
        server backend1.example.com:12345;
        server backend2.example.com:12345;
    }

    server {
        listen 12345;

        proxy_pass  stream_backend;
        status_zone backend_stream_zone;
}
```


<span id="info"></span>
## More Info

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
