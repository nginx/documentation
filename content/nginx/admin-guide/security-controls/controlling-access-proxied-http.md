---
description: Protect your upstream web and application servers by limiting connections,
  rate of requests, or bandwidth, based on client IP address or other variables.
nd-docs: DOCS-432
title: Limiting Access to Proxied HTTP Resources
toc: true
weight: 600
type:
- how-to
---

This article explains how to set the maximum number of requests for a connection, or the maximum rate of downloading content from the server.

<span id="intro"></span>
## Introduction

Using NGINX and F5 NGINX Plus, it is possible to limit:

- The number of connections per key value (for example, per IP address)
- The request rate per key value (the number of requests that are allowed to be processed during a second or minute)
- The download speed for a connection

Note that IP addresses can be shared behind NAT devices, so limiting by IP address should be used judiciously.


<span id="limit_conn"></span>
## Limiting the Number of Connections

To limit the number of connections:

1. Use the [limit_conn_zone](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone) directive to define the key and set the parameters of the shared memory zone (the worker processes will use this zone to share counters for key values). As the first parameter, specify the expression evaluated as a key. In the second parameter `zone`, specify the name of the zone and its size:

   ```nginx
   limit_conn_zone $binary_remote_addr zone=addr:10m;
   ```

2. Use the [limit_conn](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn) directive to apply the limit within the `location {}`, `server {}`, or `http {}` context. Specify the name of the shared memory zone as the first parameter, and the number of allowed connection per key as the second parameter:

   ```nginx
   location /download/ {
        limit_conn addr 1;
   }
   ```

   The number of connections is limited on an IP address basis because the [`$binary_remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_binary_remote_addr) variable is used as a key.

   Another way to limit the number of connections for a given server is by using the [`$server_name`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_server_name) variable:

   ```nginx
   http {
       limit_conn_zone $server_name zone=servers:10m;

       server {
           limit_conn servers 1000;
       }
   }
   ```


<span id="limit_req"></span>
## Limiting the Request Rate

Rate limiting can be used to prevent DDoS attacks, or prevent upstream servers from being overwhelmed by too many requests at the same time. The method is based on the [`leaky bucket`](https://en.wikipedia.org/wiki/Leaky_bucket) algorithm: requests arrive at the bucket at various rates and leave the bucket at fixed rate.

Before using rate limiting, you will need to configure global parameters of the "leaky bucket":

- key - a parameter used to differentiate one client from another, generally a variable
- shared memory zone - the name and size of the zone that keeps states of these keys (the "leaky bucket")
- rate - the request rate limit specified in requests per second (`r/s`) or requests per minute (`r/m`) ("leaky bucket draining"). Requests per minute are used to specify a rate less than one request per second.

These parameters are set with the [limit_req_zone](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) directive. The directive is defined on the `http {}` level - such approach allows applying different zones and request overflow parameters to different contexts:

```nginx
http {
    #...
    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
}
```

With this configuration, the shared memory zone `one` with the size of 10 megabytes is created.
The zone keeps states of client IP addresses set with the [`$binary_remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_binary_remote_addr) variable. Note that in comparison to [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr) which also holds a client’s IP address, [`$binary_remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_binary_remote_addr) holds the binary representation of IP address which is shorter.

The optimal size of the shared memory zone can be counted using the following data:
the size of [`$binary_remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_binary_remote_addr) value is 4 bytes for IPv4 addresses,
stored state occupies 128 bytes on 64-bit platforms. Thus, state information for about 16,000 IP addresses occupies 1 megabyte of the zone.

If storage is exhausted when NGINX needs to add a new entry, it removes the oldest entry. If the space freed is still not enough to accommodate the new record, NGINX returns status code `503 Service Unavailable`. The status code can be redefined with the [limit_req_status](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status) directive.

Once the zone is set, you can use requests limiting anywhere in the NGINX configuration with the [limit_req](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) specified for a `server {}`, `location {}`, or `http {}` context:

```nginx
http {
    #...

    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

    server {
        #...

        location /search/ {
            limit_req zone=one;
        }
    }
}
```

With this configuration, NGINX will process no more than `1` request per second within the `/search/` location. Processing of these requests is delayed in such a way that the overall rate is not greater than specified. If the number of requests exceeds the specified rate, NGINX will delay processing of such requests until the "bucket" (shared memory zone `one`) is full. For requests that arrive at the full bucket, NGINX will respond with the `503 Service Unavailable` error (if not redefined with [limit_req_status](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status)).


<span id="limit_req_dry_run"></span>
### Testing the Request Rate Limit

Before configuring real-life rate limiting, you can try the “dry run” mode that does not limit the requests processing rate. However, such excessive requests are still accounted in the shared memory zone and logged. The “dry run” mode can be enabled with the [limit_req_dry_run](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_dry_run) directive:

```nginx
http {
    #...

    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

    server {
        #...

        location /search/ {
            limit_req zone=one;
            limit_req_dry_run on;
        }
    }
}
```

Every request that would exceed the defined rate limit will be logged with the “dry run” mark:

```none
2019/09/03 10:28:45 [error] 142#142: *13246 limiting requests, dry run, excess: 1.000 by zone "one", client: 172.19.0.1, server: www.example.com, request: "GET / HTTP/1.0", host: "www.example.com:80"
```


<span id="limit_req_burst"></span>
### Handling Excessive Requests

Requests are limited to fit the rate defined in the [limit_req_zone](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) directive. If the number of requests exceeds the specified rate and the shared memory zone becomes full, NGINX will respond with an error. As traffic tends to be bursty, returning the error in response to a client request during traffic bursts is not the best case.

Such excessive requests in NGINX can be buffered and processed. The `burst` parameter of the [limit_req](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) directive sets the maximum number of excessive requests that await to be processed at the specified rate:

```nginx
http {
    #...

    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

    server {
        #...

        location /search/ {
            limit_req zone=one burst=5;
        }
    }
}
```

With this configuration, if request rate exceeds `1` request per second, requests beyond the rate will be put into the zone `one`. When the zone is full, excessive requests will be queued (`burst`), the size of this queue is `5` requests. Request processing in the queue is delayed in such a way that the overall rate is not greater than specified. Requests above the burst limit will be rejected with the `503` error.

If delaying of request is not desired during traffic burst, add the `nodelay` parameter:

```nginx
http {
    #...

    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

    server {
        #...

        location /search/ {
            limit_req zone=one burst=5 nodelay;
        }
    }
}
```

With this configuration, excessive requests within the `burst` limit will be served immediately regardless of the specified `rate`, requests above the burst limit will be rejected with the `503` error.


<span id="limit_req_delay"></span>
### Delaying Excessive Requests

Another way to handle excessive requests is to serve some number of these requests without delay, then apply rate limiting up to the point when excessive requests will be rejected.

This can be achieved with the `delay` and `burst` parameters. The `delay` parameter defines the point at which excessive requests are delayed to comply with the defined rate limit:

```nginx
http {
    #...

    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

    server {
        #...

        location /search/ {
            limit_req zone=one burst=5 delay=3;
        }
    }
}
```

With this configuration, first 3 requests (`delay`) are passed without delay, next 2 requests (`burst` - `delay`) are delayed in such a way that the overall rate is not greater than specified, further excessive requests will be rejected because the total burst size has been exceeded, subsequent requests will be delayed.


<span id="limit_req_zone_sync"></span>
### Synchronizing Contents of Many Shared Memory Zones

If you have a computer cluster with several NGINX instances and these instances use the `limit_req` method, it is possible to sync the contents of their shared memory zones on conditions that:

- the [zone_sync](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync) functionality is configured for each instance
- shared memory zones set in the [limit_req_zone](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) directive for each instance have the same name
- the [sync](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone_sync) parameter of the [limit_req_zone](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) directive is specified for each instance:

```nginx
http {
    #...
    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s sync;
}
```

See [Runtime State Sharing in a Cluster]({{< ref "nginx/admin-guide/high-availability/zone_sync.md" >}}) for details.


<span id="limit_rate"></span>
## Limiting the Bandwidth

To limit the bandwidth per connection, use the [limit_rate](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate) directive:

```nginx
location /download/ {
    limit_rate 50k;
}
```

With this setting a client will be able to download content through a single connection at a maximum speed of `50` kilobytes per second. However, the client can open several connections. So if the goal is to prevent a speed of downloading greater than the specified value, the number of connections should also be limited. For example, one connection per IP address (if the shared memory zone specified above is used):

```nginx
location /download/ {
    limit_conn addr 1;
    limit_rate 50k;
}
```

To impose the limit only after the client downloads a certain amount of data, use the [limit_rate_after](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate_after) directive. It may be reasonable to allow a client to quickly download a certain amount of data (for example, a file header — film index) and limit the rate for downloading the rest of the data (to make users watch a film, not download).

```nginx
limit_rate_after 500k;
limit_rate       20k;
```

The following example shows the combined configuration for limiting the number of connections and the bandwidth. The maximum allowed number of connections is set to `5` connections per client address, which fits most common cases since modern browsers typically open up to 3 connections at a time. Meanwhile the location that serves downloads allows only one connection:

```nginx
http {
    limit_conn_zone $binary_remote_address zone=addr:10m;

    server {
        root /www/data;
        limit_conn addr 5;

        location / {
        }

        location /download/ {
            limit_conn       addr 1;
            limit_rate_after 1m;
            limit_rate       50k;
        }
    }
}
```


<span id="limit_rate_var"></span>
### Dynamic Bandwidth Control

The [limit_rate](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate) value can also be specified as a variable - this enables dynamic bandwidth use cases, for example, allow a higher bandwidth limit to modern browsers:

```nginx
map $ssl_protocol $response_rate {
    "TLSv1.1" 10k;
    "TLSv1.2" 100k;
    "TLSv1.3" 1000k;
}

server {
    listen 443 ssl;
    ssl_protocols       TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_certificate     www.example.com.crt;
    ssl_certificate_key www.example.com.key;

    location / {
        limit_rate       $response_rate; # Limit bandwidth based on TLS version
        limit_rate_after 512;      # Apply limit after headers have been sent
        proxy_pass       http://my_backend;
    }
}
```

<span id="see_also"></span>
## See Also

- [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/)
