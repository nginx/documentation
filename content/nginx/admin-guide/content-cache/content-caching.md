---
description: Cache both static and dynamic content from your proxied web and application
  servers, to speed delivery to clients and reduce the load on the servers.
nd-docs: DOCS-380
title: NGINX Content Caching
toc: true
weight: 100
type:
- how-to
---

<span id="intro"></span>
## Overview

When caching is enabled, F5 NGINX Plus saves responses in a disk cache and uses them to respond to clients without having to proxy requests for the same content every time.

To learn more about NGINX Plus’s caching capabilities, watch the [Content Caching with NGINX](https://nginx.com/resources/webinars/content-caching-nginx-plus/) webinar on demand and get an in‑depth review of features such as dynamic [content caching](https://nginx.com/products/nginx/caching/), cache purging, and delayed caching.

<span id="enable"></span>
## Enable the Caching of Responses

To enable caching, include the [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive in the top‑level `http {}` context. The mandatory first parameter is the local filesystem path for cached content, and the mandatory `keys_zone` parameter defines the name and size of the shared memory zone that is used to store metadata about cached items:

```nginx
http {
    # ...
    proxy_cache_path /data/nginx/cache keys_zone=mycache:10m;
}
```

Then include the [`proxy_cache`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache) directive in the context (protocol type, virtual server, or location) for which you want to cache server responses, specifying the zone name defined by the `keys_zone` parameter to the `proxy_cache_path` directive (in this case, `mycache`):

```nginx
http {
    # ...
    proxy_cache_path /data/nginx/cache keys_zone=mycache:10m;
    server {
        proxy_cache mycache;
        location / {
            proxy_pass http://localhost:8000;
        }
    }
}
```

Note that the size defined by the `keys_zone` parameter does not limit the total amount of cached response data. Cached responses themselves are stored with a copy of the metadata in specific files on the filesystem. To limit the amount of cached response data, include the `max_size` parameter to the [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive. (But note that the amount of cached data can temporarily exceed this limit, as described in the following section.)

<span id="processes"></span>
## NGINX Processes Involved in Caching

There are two additional NGINX processes involved in caching:

- The **cache manager** is activated periodically to check the state of the cache. If the cache size exceeds the limit set by the `max_size` parameter to the [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive, the cache manager removes the data that was accessed least recently. As previously mentioned, the amount of cached data can temporarily exceed the limit during the time between cache manager activations.

- The **cache loader** runs only once, right after NGINX starts. It loads metadata about previously cached data into the shared memory zone. Loading the whole cache at once could consume sufficient resources to slow NGINX performance during the first few minutes after startup. To avoid this, configure iterative loading of the cache by including the following parameters to the [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive:

  - `loader_threshold` – Duration of an iteration, in milliseconds (by default, `200`)
  - `loader_files` – Maximum number of items loaded during one iteration (by default, `100`)
  - `loader_sleeps` – Delay between iterations, in milliseconds (by default, `50`)

In the following example, iterations last `300` milliseconds or until `200` items have been loaded:

```nginx
proxy_cache_path /data/nginx/cache keys_zone=mycache:10m loader_threshold=300 loader_files=200;
```

<span id="select"></span>
## Specify Which Requests to Cache

By default, NGINX Plus caches all responses to requests made with the HTTP `GET` and `HEAD` methods the first time such responses are received from a proxied server. As the key (identifier) for a request, NGINX Plus uses the request string. If a request has the same key as a cached response, NGINX Plus sends the cached response to the client. You can include various directives in the `http {}`, `server {}`, or `location {}` context to control which responses are cached.

To change the request characteristics used in calculating the key, include the [`proxy_cache_key`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_key) directive:

```nginx
proxy_cache_key "$host$request_uri$cookie_user";
```

To define the minimum number of times that a request with the same key must be made before the response is cached, include the [`proxy_cache_min_uses`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_min_uses) directive:

```nginx
proxy_cache_min_uses 5;
```

To cache responses to requests with methods other than `GET` and `HEAD`, list them along with `GET` and `HEAD` as parameters to the [`proxy_cache_methods`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_methods) directive:

```nginx
proxy_cache_methods GET HEAD POST;
```

<span id="bypass"></span>
## Limit or Disable Caching

By default, responses remain in the cache indefinitely. They are removed only when the cache exceeds the maximum configured size, and then in order by length of time since they were last requested. You can set how long cached responses are considered valid, or even whether they are used at all, by including directives in the `http {}`, `server {}`, or `location {}` context:

To limit how long cached responses with specific status codes are considered valid, include the [`proxy_cache_valid`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_valid) directive:

```nginx
proxy_cache_valid 200 302 10m;
proxy_cache_valid 404      1m;
```

In this example, responses with the code `200` or `302` are considered valid for 10 minutes, and responses with code `404` are valid for 1 minute. To define the validity time for responses with all status codes, specify `any` as the first parameter:

```nginx
proxy_cache_valid any 5m;
```

To define conditions under which NGINX Plus does not send cached responses to clients, include the [`proxy_cache_bypass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_bypass) directive. Each parameter defines a condition and consists of a number of variables. If at least one parameter is not empty and does not equal “`0`” (zero), NGINX Plus does not look up the response in the cache, but instead forwards the request to the backend server immediately.

```nginx
proxy_cache_bypass $cookie_nocache $arg_nocache$arg_comment;
```

To define conditions under which NGINX Plus does not cache a response at all, include the [`proxy_no_cache`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_no_cache) directive, defining parameters in the same way as for the `proxy_cache_bypass` directive.

```nginx
proxy_no_cache $http_pragma $http_authorization;
```

<span id="purge"></span>
## Purge Content From The Cache

NGINX makes it possible to remove outdated cached files from the cache. This is necessary for removing outdated cached content to prevent serving old and new versions of web pages at the same time. The cache is purged upon receiving a special “purge” request that contains either a custom HTTP header, or the HTTP `PURGE` method.

<span id="purge_configure"></span>
### Configure Cache Purge

Let’s set up a configuration that identifies requests that use the HTTP `PURGE` method and deletes matching URLs.

1. In the `http {}` context, create a new variable, for example, `$purge_method`, that depends on the `$request_method` variable:

    ```nginx
    http {
        # ...
        map $request_method $purge_method {
            PURGE 1;
            default 0;
        }
    }
    ```

2. In the `location {}` block where caching is configured, include the [`proxy_cache_purge`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_purge) directive to specify a condition for cache‑purge requests. In our example, it is the `$purge_method` configured in the previous step:

    ```nginx
    server {
        listen      80;
        server_name www.example.com;

        location / {
            proxy_pass  https://localhost:8002;
            proxy_cache mycache;

            proxy_cache_purge $purge_method;
        }
    }
    ```

<span id="purge_request"></span>
### Send the Purge Command

When the `proxy_cache_purge` directive is configured, you need to send a special cache‑purge request to purge the cache. You can issue purge requests using a range of tools, including the `curl` command as in this example:

```none
$ curl -X PURGE -D – "https://www.example.com/*"
HTTP/1.1 204 No Content
Server: nginx/1.15.0
Date: Sat, 19 May 2018 16:33:04 GMT
Connection: keep-alive
```

In the example, the resources that have a common URL part (specified by the asterisk wildcard) are purged. However, such cache entries are not removed completely from the cache: they remain on disk until they are deleted for either inactivity (as determined by the `inactive` parameter to the [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive) or by the cache purger (enabled with the [`purger`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#purger) parameter to `proxy_cache_path`), or a client attempts to access them.

<span id="purge_secure"></span>
### Restrict Access to the Purge Command

We recommend that you limit the number of IP addresses that are allowed to send a cache‑purge request:

```nginx
geo $purge_allowed {
   default         0;  # deny from other
   10.0.0.1        1;  # allow from 10.0.0.1 address
   192.168.0.0/24  1;  # allow from 192.168.0.0/24
}

map $request_method $purge_method {
   PURGE   $purge_allowed;
   default 0;
}
```

In this example, NGINX checks if the `PURGE` method is used in a request, and, if so, analyzes the client IP address. If the IP address is whitelisted, then the `$purge_method` is set to `$purge_allowed`: `1` permits purging, and `0` denies it.

<span id="purge_remove"></span>
### Completely Remove Files from the Cache

To completely remove cache files that match an asterisk, activate a special `cache purger` process that permanently iterates through all cache entries and deletes the entries that match the wildcard key. Include the [`purger`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#purger) parameter to the [`proxy_cache_path`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive in the `http {}` context:

```nginx
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=mycache:10m purger=on;
```

<span id="purge_example"></span>
### Cache Purge Configuration Example

```nginx
http {
    # ...
    proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=mycache:10m purger=on;

    map $request_method $purge_method {
        PURGE 1;
        default 0;
    }

    server {
        listen      80;
        server_name www.example.com;

        location / {
            proxy_pass        https://localhost:8002;
            proxy_cache       mycache;
            proxy_cache_purge $purge_method;
        }
    }

    geo $purge_allowed {
       default         0;
       10.0.0.1        1;
       192.168.0.0/24  1;
    }

    map $request_method $purge_method {
       PURGE   $purge_allowed;
       default 0;
    }
}
```

<span id="slice"></span>
## Byte-Range Caching

The initial cache fill operation sometimes takes quite a long time, especially for large files. For example, when a video file starts downloading to fulfill the initial request for a part of the file, subsequent requests have to wait for the entire file to be downloaded and put into the cache.

NGINX makes it possible to cache such range requests and gradually fill the cache with the [Cache Slice](https://nginx.org/en/docs/http/ngx_http_slice_module.html) module, which divides files into smaller “slices”. Each range request chooses particular slices that cover the requested range and, if this range is still not cached, put it into the cache. All other requests for these slices take the data from the cache.

{{< call-out "note" >}}
Currently, slicing does not work with [background cache update](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_background_update) as in this case a request will be constructed without byte-range support.
{{< /call-out >}}

To enable byte‑range caching:

1. Make sure NGINX is compiled with the [Cache Slice](https://nginx.org/en/docs/http/ngx_http_slice_module.html) module.
2. Specify the size of the slice with the [slice](https://nginx.org/en/docs/http/ngx_http_slice_module.html#slice) directive:

    ```nginx
    location / {
        slice  1m;
    }
    ```

   Choose a slice size that makes slice downloading fast. If the size is too small, memory usage might be excessive and a large number of file descriptors opened while processing the request, while an excessively large size might cause latency.

3. Include the [`$slice_range`](https://nginx.org/en/docs/http/ngx_http_slice_module.html#var_slice_range) variable to the cache key:

    ```nginx
    proxy_cache_key $uri$is_args$args$slice_range;
    ```

4. Enable caching of responses with the `206` status code:

    ```nginx
    proxy_cache_valid 200 206 1h;
    ```

5. Enable passing of range requests to the proxied server by setting the [`$slice_range`](https://nginx.org/en/docs/http/ngx_http_slice_module.html#var_slice_range) variable in the `Range` header field:

    ```nginx
    proxy_set_header  Range $slice_range;
    ```

Here's the full configuration:

```nginx
location / {
    slice             1m;
    proxy_cache       cache;
    proxy_cache_key   $uri$is_args$args$slice_range;
    proxy_set_header  Range $slice_range;
    proxy_cache_valid 200 206 1h;
    proxy_pass        http://localhost:8000;
}
```

Note that if slice caching is turned on, the initial file must not be changed.

<span id="example"></span>
## Combined Configuration Example

The following sample configuration combines some of the caching options described above.

```nginx
http {
    # ...
    proxy_cache_path /data/nginx/cache keys_zone=mycache:10m loader_threshold=300
                     loader_files=200 max_size=200m;

    server {
        listen 8080;
        proxy_cache mycache;

        location / {
            proxy_pass http://backend1;
        }

        location /some/path {
            proxy_pass http://backend2;
            proxy_cache_valid any 1m;
            proxy_cache_min_uses 3;
            proxy_cache_bypass $cookie_nocache $arg_nocache$arg_comment;
        }
    }
}
```

In this example, two locations use the same cache but in different ways.

Because responses from `backend1` rarely change, no cache‑control directives are included. Responses are cached the first time a request is made, and remain valid indefinitely.

In contrast, responses to requests served by `backend2` change frequently, so they are considered valid for only 1 minute and aren’t cached until the same request is made 3 times. Moreover, if a request matches the conditions defined by the `proxy_cache_bypass` directive, NGINX Plus immediately passes the request to `backend2` without looking for the corresponding response in the cache.
