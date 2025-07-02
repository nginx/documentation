---
description: Protect your upstream TCP application servers by limiting connections
  or bandwidth, based on client IP address or other variables.
nd-docs: DOCS-433
title: Restricting Access to Proxied TCP Resources
toc: true
weight: 700
type:
- how-to
---

This chapter provides scenarios for restricting access to a database or media server that communicates over TCP. Access can be limited by IP address, the number of simultaneous connections, or bandwidth.

<span id="restrict"></span>
## Restricting Access by IP Address

NGINX can allow or deny access based on a particular IP address or the range of IP addresses of client computers. To allow or deny access, use the [allow](https://nginx.org/en/docs/stream/ngx_stream_access_module.html#allow) and [deny](https://nginx.org/en/docs/stream/ngx_stream_access_module.html#deny) directives inside the [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context or a [server](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server) block:

```nginx
stream {
    #...
    server {
        listen 12345;
        deny   192.168.1.2;
        allow  192.168.1.1/24;
        allow  2001:0db8::/32;
        deny   all;
    }
}
```

The rules are processed in sequence, from top to bottom: if the first directive in the sequence is `deny all`, then all further `allow` directives have no effect. In this example, the subnet `192.168.1.1/24` is allowed access, with the exception of `192.168.1.2`. The `2001:0db8::/32` range of IPv6 addresses is also allowed, and access to any other IP addresses is denied.

<span id="limit_conn"></span>
## Limiting the Number of TCP Connections

You can limit the number of simultaneous TCP connections from one IP address. This can be useful in preventing denial-of-service (DoS) attacks.

First, let’s define the _zone_ that will store the maximum number of TCP connections to one server, and a key to identify the connection. This can be done with the [limit_conn_zone](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone) directive in the [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context:

```nginx
stream {
    #...
    limit_conn_zone $binary_remote_addr zone=ip_addr:10m;
    #...
}
```

The key that identifies the connection is defined as `$binary_remote_addr`, which represents the IP address of the client in binary format. The name of the shared memory zone is `ip_addr` and the zone size is 10 megabytes.

After the zone is defined, limit connections with the [limit_conn](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html#limit_conn) directive. Its first parameter specifies the name of the shared memory zone previously defined by [limit_conn_zone](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone). As the second parameter, specify the maximum number of allowed connections for each IP address, in either the [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context or a [server](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server) block (as in this example, which also shows the prerequisite `limit_conn_zone` directive):

```nginx
stream {
    #...
    limit_conn_zone $binary_remote_addr zone=ip_addr:10m;

    server {
        #...
        limit_conn ip_addr 1;
    }
}
```

When limiting the number of connections per IP address, be aware that multiple hosts behind a Network Address Translation (NAT) device share the same IP address.

<span id="limit_bandwidth"></span>
## Limiting the Bandwidth

You can configure the maximum download or upload speed for TCP connections. Include the [proxy_download_rate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_download_rate) or [proxy_upload_rate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_upload_rate) directive, respectively:

```nginx
server {
    #...
    proxy_download_rate 100k;
    proxy_upload_rate   50k;
}
```

With these settings a client can download data through a single connection at a maximum speed of 100 kilobytes per second, and upload data through a single connection at a maximum speed of 50 kilobytes per second. However, the client can open several connections. So if the goal is to limit overall speed of loading for each client, the number of connections must also be limited to `1` as described in the previous section.

```nginx
stream {
    #...
    limit_conn_zone $binary_remote_addr zone=ip_addr:10m;

    server {
        #...
        limit_conn ip_addr  1;
        proxy_download_rate 100k;
        proxy_upload_rate   50k;
    }
}
```
