---
description: Learn how F5 NGINX Controller handles caching configurations and what
  NGINX cache directives are supported.
nd-docs: DOCS-339
title: About Caching
toc: true
weight: 200
type:
- concept
---

## Overview

The F5 NGINX Controller Application Delivery (AD) module lets you configure content caching by using either the user interface (UI) or the [Components REST API](https://docs.nginx.com/nginx-controller/api/ctlr-adc-api/#tag/Components).

## Basic Caching

NGINX Controller Caching supports [basic caching](https://www.nginx.com/blog/nginx-caching-guide/#How-to-Set-Up-and-Configure-Basic-Caching) via the *disk store* resource.

When you add a disk store to a component, you define the location of the cache on the hard disk. The path you specify for the disk store is the base path under which you want to store the cache files for the component.

{{< call-out "important" >}}
The directory that you want to use as the cache must already exist and the NGINX process must have read and write permissions to it. Otherwise, NGINX Controller can't create the cached folders and files.

If NGINX Controller can't create the desired cache directory and/or write files to it, the user interface will display an error for the component.
{{< /call-out >}}

When you use the UI or the REST API to create a single disk store, NGINX Controller adds the following directives to the auto-generated `nginx.conf` file:

- [`proxy_cache_path`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path), in the top-level `http` context;
- [`proxy_cache`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache), added to the component's `location` block.

You can include NGINX Controller Caching data when creating [custom dashboards]({{< ref "/controller/analytics/dashboards/custom-dashboards" >}}) and [alerts]({{< ref "/controller/analytics/alerts/manage-alerts" >}}) for your applications.

## Cache Splitting

NGINX Controller Caching also supports splitting the cache across multiple directories, which can reside on different hard drives. To split the cache, you need to create a disk store for each desired cache location. The Caching *split config* settings let you determine how NGINX Controller should split the data between the disk stores -- either by percentage or by pattern matching.

The percentage option lets you set the percentage of the cache to store in each location. Pattern matching lets you define where to store cache contents -- like certain file types -- and which cache location should send a response based on the request.

{{< call-out "note" >}}
Read the [NGINX Caching Guide](https://www.nginx.com/blog/nginx-caching-guide/#Splitting-the-Cache-Across-Multiple-Hard-Drives) to learn more about splitting the cache across multiple hard drives.
{{< /call-out>}}

When you define a split cache, NGINX Controller adds a `split_clients` configuration block with percentage split or a `map` configuration block with string split to the `http` context of the generated `nginx.conf` file.

## Advanced Caching

As noted earlier in this topic, you can use Caching to manage basic caching use cases.
To add any of the [`ngx_http_proxy_module`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) cache directives listed below, use NGINX Controller **Snippets**.

- [`proxy_cache_background_update`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_background_update)
- [`proxy_cache_bypass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_bypass)
- [`proxy_cache_convert_head`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_convert_head)
- [`proxy_cache_key`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_key)
- [`proxy_cache_lock`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock)
- [`proxy_cache_lock_age`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock_age)
- [`proxy_cache_lock_timeout`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock_timeout)
- [`proxy_cache_max_range_offset`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_max_range_offset)
- [`proxy_cache_methods`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_methods)
- [`proxy_cache_min_uses`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_min_uses)
- [`proxy_cache_purge`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_purge)
- [`proxy_cache_revalidate`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_revalidate)
- [`proxy_cache_use_stale`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_use_stale)
- [`proxy_cache_valid`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_valid)
- [`proxy_no_cache`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_no_cache)
- [`proxy_temp_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_temp_path)

In order to enable the collection of app centric caching metrics, NGINX Controller has added a minimal set of APIs to enable and control caching. For more advanced caching features, you can make use of `configSnippets` to configure the directives above.

{{< call-out "note" >}}
When you enable the temporary path for disk store with `tempPath:ENABLED`, you need to set the temporary path `proxy_temp_path` using the snippets API.
{{< /call-out >}}


{{< call-out "note" >}}
NGINX Controller does not collect or report metrics for directives configured using Snippets.
{{< /call-out >}}

## Usage Examples

Each of the examples provided here shows a sample API request and the resulting NGINX config file. These examples are for learning purposes only and are not intended for use in production settings.

### Basic Caching {#basic-caching-example}

The example below shows an excerpt of a REST API request that sets up basic caching. This example defines one server as the cache location.

```json
"desiredState": {
    "caching": {
        "diskStores": [
        {
            "path": "/tmp/cache-1",
            "maxSize": "5G",
            "minFree": "10k",
            "inMemoryStoreSize": "500M",
            "inactiveTime": "2s"
        }
        ]
    }
}
```

The above request modifies the NGINX Controller-generated `nginx.conf` file as follows:

- Adds a `proxy_cache_path` directive for the disk store to the `http` context;
- Adds a new `proxy_cache` directive to the `location` block for the component.

```Nginx configuration file {hl_lines=[1,14]}
proxy_cache_path /tmp/cache-1/app_centric_example-env|example-app-1|example-app-component| max_size=5G min_free=10k keys_zone=app_centric_example-env|example-app-1|example-app-component|/tmp/cache-1:500M purger=off;

server {
    server_name test.example.com;
    listen 80;
    status_zone server_5ae404e8-005d-38e8-b355-6d54cb219730;
    set $f5_gateway example-gw;
    f5_metrics_marker gateway $f5_gateway;
    set $f5_environment example-env;
    f5_metrics_marker environment $f5_environment;
    location / {
        error_log /dev/null;
        access_log off;
        proxy_cache app_centric_example-env|example-app-1|example-app-component|/tmp/cache-1;
        set $f5_app example-app-1;
        f5_metrics_marker app $f5_app;
        set $f5_component example-app-component;
        f5_metrics_marker component $f5_component;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header Connection '';
        proxy_http_version 1.1;
        proxy_pass http://wg-example_http_b4859463-b3bd-4ccb-8442-e21253a50da7;
    }
}
```

### Cache Splitting using Percentage and Snippets {#split-percentage-example}

You can set up cache splitting using the Percentage criteria to define the percent of the cache to store in each location.

The example request excerpt below does the following:

- splits the cache across three different storage paths;
- sets one of the stores -- `/tmp/default` -- as the default;
- uses the Component `configSnippets.uriSnippets` API to configure the [`add_header`](https://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header) directive, to include `Cache` header with  "HIT/MISS/EXPIRED/BYPASS" in the response;
- uses the Component `configSnippets.uriSnippets` API to set a cache duration time of 1m for all requests using [`proxy_cache_valid`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_valid).

```json
{
    "desiredState": {
        "configSnippets": {
            "uriSnippets": [
                {
                    "directives": [
                        {
                            "directive": "proxy_cache_valid",
                            "args": [
                                "any",
                                "1m"
                            ]
                        }
                    ]
                }
            ]
        },
         "programmability": {
            "responseHeaderModifications": [
                {
                    "action": "ADD",
                    "headerName": "X-Cache-Status",
                    "headerValue": "$upstream_cache_status"
                }
            ]
        },
        "caching": {
            "splitConfig": {
                "criteriaType": "PERCENTAGE",
                "key": "$request_uri"
            },
            "diskStores": [
                {
                    "inMemoryStoreSize": "100m",
                    "inactiveTime": "1m",
                    "isDefault": false,
                    "maxSize": "5G",
                    "minFree": "10k",
                    "path": "/tmp/hdd1",
                    "percentCriteria": "20%"
                },
                {
                    "inMemoryStoreSize": "100m",
                    "inactiveTime": "10s",
                    "isDefault": false,
                    "maxSize": "5g",
                    "minFree": "10k",
                    "path": "/tmp/hdd2",
                    "percentCriteria": "50%"
                },
                {
                    "inMemoryStoreSize": "100m",
                    "inactiveTime": "15s",
                    "isDefault": true,
                    "maxSize": "2g",
                    "minFree": "10k",
                    "path": "/tmp/default"
                }
            ]
        }
    }
}
```

The above request modifies the `nginx.conf` file as follows:

- Adds the `split_clients` directive to the `http` context, reflecting the criteria defined for `diskStores`;
- Adds a `proxy_cache_path` directive for each disk store to the `http` context;
- Adds a new `proxy_cache` variable -- `$cache_<unique-hash>` -- to the `location` block for the component;
- Adds the `proxy_cache_valid` and `add_header` directives to the `location` block for the component.

```Nginx configuration file {hl_lines=["1-8",27,36,37]}
split_clients $request_uri $cache_bdfa5d91f97d37dbb97a42dde6a5f4ff {
    20% app_centric_env|app|split_cache_percentage|/tmp/hdd1;
    50% app_centric_env|app|split_cache_percentage|/tmp/hdd2;
    * app_centric_env|app|split_cache_percentage|/tmp/default;
}
proxy_cache_path /tmp/hdd1/app_centric_env|app|split_cache_percentage| max_size=5G min_free=10k keys_zone=app_centric_env|app|split_cache_percentage|/tmp/hdd1: 100m purger=off inactive=1m;
proxy_cache_path /tmp/hdd2/app_centric_env|app|split_cache_percentage| max_size=5g min_free=10k keys_zone=app_centric_env|app|split_cache_percentage|/tmp/hdd2: 100m purger=off inactive=10s;
proxy_cache_path /tmp/default/app_centric_env|app|split_cache_percentage| max_size=2g min_free=10k keys_zone=app_centric_env|app|split_cache_percentage|/tmp/default: 100m purger=off inactive=15s;
upstream split_p_http_7ec84d9e-373e-4d90-bcaa-0e33dcc4b906 {
    zone split_p_http_7ec84d9e-373e-4d90-bcaa-0e33dcc4b906 160k;
    server 10.146.187.154: 80;
    keepalive 64;
    keepalive_requests 100;
    keepalive_timeout 60s;
}
server {
    server_name test.example.com;
    listen 80 reuseport;
    status_zone server_4d1ee345-cf08-354e-93dc-1c3a844a04e3;
    set $f5_gateway gw;
    f5_metrics_marker gateway $f5_gateway;
    set $f5_environment env;
    f5_metrics_marker environment $f5_environment;
    location /aaa {
        error_log /dev/null;
        access_log off;
        proxy_cache $cache_bdfa5d91f97d37dbb97a42dde6a5f4ff;
        set $f5_app app;
        f5_metrics_marker app $f5_app;
        set $f5_component split_cache_percentage;
        f5_metrics_marker component $f5_component;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header Connection '';
        proxy_http_version 1.1;
        add_header Cache $upstream_cache_status;
        proxy_cache_valid any 1m;
        proxy_pass http: //split_p_http_7ec84d9e-373e-4d90-bcaa-0e33dcc4b906;
}
```

### Cache Splitting using Pattern Matching and Snippets {#split-string-example}

You can also use pattern matching to cache based on a certain string (`stringCriteria`) for each store. For example, you can define the string criteria as a list of file formats, as shown in the request excerpt below. As in the [percentage example](#split-percentage-example), we're also using the Components `configSnippets` API here to set the `add_header` and `proxy_cache_valid` directives.

The request below splits the cache into three different stores.

- One store is the default location and has no string criteria defined.
- One store is the location for all `.html`files.
- Ones store is the location for all `.mp4` files.

```json
"desiredState": {
    "configSnippets": {
        "uriSnippets": [
        {
            "directives": [
            {
                "directive": "proxy_cache_valid",
                "args": [
                "any",
                "1m"
                ]
            }
            ]
        }
        ]
    },
    "programmability": {
        "responseHeaderModifications": [
            {
                "action": "ADD",
                "headerName": "X-Cache-Status",
                "headerValue": "$upstream_cache_status"
            }
        ]
    },
    "caching": {
        "splitConfig": {
        "criteriaType": "STRING",
        "key": "$request_uri"
        },
        "diskStores": [
        {
            "inMemoryStoreSize": "10m",
            "inactiveTime": "1m",
            "isDefault": false,
            "maxSize": "2G",
            "minFree": "1m",
            "path": "/tmp/hdd1",
            "stringCriteria": ["~.html$"]
        },
        {
            "inMemoryStoreSize": "50m",
            "inactiveTime": "1m",
            "isDefault": false,
            "maxSize": "1g",
            "minFree": "10k",
            "path": "/tmp/hdd2",
            "stringCriteria": ["~.mp4$"]
        },
        {
            "inMemoryStoreSize": "30m",
            "inactiveTime": "1m",
            "isDefault": true,
            "maxSize": "2g",
            "minFree": "10k",
            "path": "/tmp/default"
        }
        ]
    }
}
```

The above request modifies the `nginx.conf` file as follows:

- Adds a `map` directive to the `http` context, reflecting the string criteria defined for the disk stores.
- Adds a `proxy_cache_path` directive to the `http` context for each disk store.
- Adds a new variable `$cache_<unique-hash>` to the `location` block for the component.

```Nginx configuration file {hl_lines=["1-8",30,39,40]}
map $request_uri $cache_8de5273e13f731e283acbc999760c3e3 {
    ~.html$ app_centric_env|app|split_string|/tmp/hdd1;
    ~.mp4$ app_centric_env|app|split_string|/tmp/hdd2;
    default app_centric_env|app|split_string|/tmp/default;
}
proxy_cache_path /tmp/hdd1/app_centric_env|app|split_string| max_size=2G min_free=1m keys_zone=app_centric_env|app|split_string|/tmp/hdd1:10m purger=off inactive=1m;
proxy_cache_path /tmp/hdd2/app_centric_env|app|split_string| max_size=1g min_free=10k keys_zone=app_centric_env|app|split_string|/tmp/hdd2:50m purger=off inactive=1m;
proxy_cache_path /tmp/default/app_centric_env|app|split_string| max_size=2g min_free=10k keys_zone=app_centric_env|app|split_string|/tmp/default:30m purger=off inactive=1m;
upstream wg_http_0ace772a-0c68-4d01-a443-6e377d4f6133 {
    zone wg_http_0ace772a-0c68-4d01-a443-6e377d4f6133 160k;
    server 10.146.187.154:80;
    keepalive 64;
    keepalive_requests 100;
    keepalive_timeout 60s;
}
map $host $f5_published_api {
    default -;
}
server {
    server_name test.example.com;
    listen 80 reuseport;
    status_zone server_4d1ee345-cf08-354e-93dc-1c3a844a04e3;
    set $f5_gateway gw;
    f5_metrics_marker gateway $f5_gateway;
    set $f5_environment env;
    f5_metrics_marker environment $f5_environment;
    location / {
        error_log /dev/null;
        access_log off;
        proxy_cache $cache_8de5273e13f731e283acbc999760c3e3;
        set $f5_app app;
        f5_metrics_marker app $f5_app;
        set $f5_component split_string;
        f5_metrics_marker component $f5_component;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header Connection '';
        proxy_http_version 1.1;
        add_header Cache $upstream_cache_status;
        proxy_cache_valid any 1m;
        proxy_pass <http://wg_http_0ace772a-0c68-4d01-a443-6e377d4f6133;>
    }
}
```

{{< versions "3.22" "latest" "adcvers" >}}
