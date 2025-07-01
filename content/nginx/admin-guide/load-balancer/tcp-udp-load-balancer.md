---
description: This chapter describes how to use F5 NGINX Plus and NGINX Open Source
  to proxy and load balance TCP and UDP traffic.
nd-docs: DOCS-420
title: TCP and UDP Load Balancing
toc: true
weight: 200
type:
- how-to
---

## Introduction {#intro}

[Load balancing](https://www.f5.com/glossary/load-balancer) refers to efficiently distributing network traffic across multiple backend servers.

In F5 NGINX Plus [R5]({{< ref "nginx/releases.md#r5" >}}) and later, NGINX Plus can proxy and load balance Transmission Control Protocol) (TCP) traffic. TCP is the protocol for many popular applications and services, such as LDAP, MySQL, and RTMP.

In NGINX Plus [R9]({{< ref "nginx/releases.md#r9" >}}) and later, NGINX Plus can proxy and load balance UDP traffic. UDP (User Datagram Protocol) is the protocol for many popular non-transactional applications, such as DNS, syslog, and RADIUS.

To load balance HTTP traffic, refer to the [HTTP Load Balancing]({{< ref "http-load-balancer.md" >}}) article.

## Prerequisites

- Latest NGINX Plus (no extra build steps required) or latest [NGINX Open Source](https://nginx.org/en/download.html) built with the `--with-stream` configuration flag
- An application, database, or service that communicates over TCP or UDP
- Upstream servers, each running the same instance of the application, database, or service

## Configuring reverse proxy {#proxy_pass}

First, you will need to configure _reverse proxy_ so that NGINX Plus or NGINX Open Source can forward TCP connections or UDP datagrams from clients to an upstream group or a proxied server.

Open the NGINX configuration file and perform the following steps:

1. Create a top‑level [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block:

   ```nginx
   stream {
       # ...
   }
   ```

2. Define one or more [`server {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server) configuration blocks for each virtual server in the top‑level `stream {}` context.

3. Within the `server {}` configuration block for each server, include the [`listen`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive to define the _IP address_ and/or _port_ on which the server listens.

   For UDP traffic, also include the [`udp`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#udp) parameter. As TCP is the default protocol for the `stream` context, there is no `tcp` parameter to the `listen` directive:

   ```nginx
   stream {

       server {
           listen 12345;
           # ...
       }

       server {
           listen 53 udp;
           # ...
       }
       # ...
   }
   ```

4. Include the [`proxy_pass`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_pass) directive to define the proxied server or an upstream group to which the server forwards traffic:

   ```nginx
   stream {

       server {
           listen     12345;
           #TCP traffic will be forwarded to the "stream_backend" upstream group
           proxy_pass stream_backend;
       }

       server {
           listen     12346;
           #TCP traffic will be forwarded to the specified server
           proxy_pass backend.example.com:12346;
       }

       server {
           listen     53 udp;
           #UDP traffic will be forwarded to the "dns_servers" upstream group
           proxy_pass dns_servers;
       }
       # ...
   }
   ```

5. If the proxy server has several network interfaces, you can optionally configure NGINX to use a particular source IP address when connecting to an upstream server. This may be useful if a proxied server behind NGINX is configured to accept connections from particular IP networks or IP address ranges.

   Include the [`proxy_bind`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_bind) directive and the IP address of the appropriate network interface:

   ```nginx
   stream {
       # ...
       server {
           listen     127.0.0.1:12345;
           proxy_pass backend.example.com:12345;
           proxy_bind 127.0.0.1:12345;
       }
   }
   ```

6. Optionally, you can tune the size of two in‑memory buffers where NGINX can put data from both the client and upstream connections. If there is a small volume of data, the buffers can be reduced which may save memory resources. If there is a large volume of data, the buffer size can be increased to reduce the number of socket read/write operations. As soon as data is received on one connection, NGINX reads it and forwards it over the other connection. The buffers are controlled with the [`proxy_buffer_size`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_buffer_size) directive:

   ```nginx
   stream {
       # ...
       server {
           listen            127.0.0.1:12345;
           proxy_pass        backend.example.com:12345;
           proxy_buffer_size 16k;
       }
   }
   ```

## Configuring TCP or UDP load balancing {#upstream}

To configure load balancing:

1. Create a group of servers, or an _upstream group_ whose traffic will be load balanced. Define one or more [`upstream {}`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream) configuration blocks in the top‑level [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context and set the name for the upstream group, for example, `stream_backend` for TCP servers and `dns_servers` for UDP servers:

   ```nginx
   stream {

       upstream stream_backend {
           # ...
       }

       upstream dns_servers {
           # ...
       }

       # ...
   }
   ```

   Make sure that the name of the upstream group is referenced by a [`proxy_pass`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_pass) directive, like those configured [above](#proxy_pass) for reverse proxy.

2. Populate the upstream group with _upstream servers_. Within the [`upstream {}`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream) block, add a [`server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) directive for each upstream server, specifying its IP address or hostname (which can resolve to multiple IP addresses) and an _obligatory_ port number. Note that you do not define the protocol for each server, because that is defined for the entire upstream group by the parameter you include on the `listen` directive in the `server` block, which you have created [earlier](#proxy_pass).

   ```nginx
   stream {

       upstream stream_backend {
           server backend1.example.com:12345;
           server backend2.example.com:12345;
           server backend3.example.com:12346;
           # ...
       }

       upstream dns_servers {
           server 192.168.136.130:53;
           server 192.168.136.131:53;
           # ...
       }

       # ...
   }
   ```

3. Configure the load‑balancing method used by the upstream group. You can specify one of the following methods:

   - Round Robin – By default, NGINX uses the Round Robin algorithm to load balance traffic, directing it sequentially to the servers in the configured upstream group. Because it is the default method, there is no `round‑robin` directive; simply create an `upstream {}` configuration block in the top‑level `stream {}` context and add `server` directives as described in the previous step.

   - [Least Connections](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#least_conn) – NGINX selects the server with the smaller number of current active connections.

   - [Least Time](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#least_time) (NGINX Plus only) – NGINX Plus selects the server with the lowest average latency and the least number of active connections. The method used to calculate lowest average latency depends on which of the following parameters is included on the `least_time` directive:

     - `connect`    – Time to connect to the upstream server
     - `first_byte` – Time to receive the first byte of data
     - `last_byte`  – Time to receive the full response from the server

      ```nginx
      upstream stream_backend {
          least_time first_byte;
          server backend1.example.com:12345;
          server backend2.example.com:12345;
          server backend3.example.com:12346;
      }
      ```

   - [Hash](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#hash) – NGINX selects the server based on a user‑defined key, for example, the source IP address ([`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr)):

     ```nginx
     upstream stream_backend {
         hash $remote_addr;
         server backend1.example.com:12345;
         server backend2.example.com:12345;
         server backend3.example.com:12346;
     }
     ```

     The `Hash` load‑balancing method is also used to configure _session persistence_. As the hash function is based on client IP address, connections from a given client are always passed to the same server unless the server is down or otherwise unavailable. Specify an optional `consistent` parameter to apply the [ketama](http://www.last.fm/user/RJ/journal/2007/04/10/rz_libketama_-_a_consistent_hashing_algo_for_memcache_clients) consistent hashing method:

     ```nginx
     hash $remote_addr consistent;
     ```

   - [Random](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#random) – Each connection will be passed to a randomly selected server. If the `two` parameter is specified, first, NGINX randomly selects two servers taking into account server weights, and then chooses one of these servers using the specified method:

     - `least_conn` – The least number of active connections
     - `least_time=connect` (NGINX Plus) – The time to connect to the upstream server ([`$upstream_connect_time`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#var_upstream_connect_time))
     - `least_time=first_byte` (NGINX Plus) – The least average time to receive the first byte of data from the server ([`$upstream_first_byte_time`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#var_upstream_first_byte_time))
     - `least_time=last_byte` (NGINX Plus) – The least average time to receive the last byte of data from the server ([`$upstream_session_time`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#var_upstream_session_time))

      ```nginx
      upstream stream_backend {
          random two least_time=last_byte;
          server backend1.example.com:12345;
          server backend2.example.com:12345;
          server backend3.example.com:12346;
          server backend4.example.com:12346;
      }
      ```

    The **Random** load balancing method should be used for distributed environments where multiple load balancers are passing requests to the same set of backends. For environments where the load balancer has a full view of all requests, use other load balancing methods, such as round robin, least connections and least time.

5. Optionally, for each upstream server specify server‑specific parameters including [maximum number of connections](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#max_conns), [server weight](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#weight), and so on:

   ```nginx
   upstream stream_backend {
       hash   $remote_addr consistent;
       server backend1.example.com:12345 weight=5;
       server backend2.example.com:12345;
       server backend3.example.com:12346 max_conns=3;
   }
   upstream dns_servers {
       least_conn;
       server 192.168.136.130:53;
       server 192.168.136.131:53;
       # ...
   }
   ```

An alternative approach is to proxy traffic to a single server instead of an upstream group. If you identify the server by hostname, and configure the hostname to resolve to multiple IP addresses, then NGINX load balances traffic across the IP addresses using the `Round Robin` algorithm. In this case, you _must_ specify the server’s port number in the `proxy_pass` directive and _must not_ specify the protocol before IP address or hostname:

```nginx
stream {
    # ...
    server {
        listen     12345;
        proxy_pass backend.example.com:12345;
    }
}
```

## Configuring health checks {#health}

NGINX can continually test your TCP or UDP upstream servers, avoid the servers that have failed, and gracefully add the recovered servers into the load‑balanced group.

See [TCP Health Checks]({{< ref "nginx/admin-guide/load-balancer/tcp-health-check.md" >}}) for instructions how to configure health checks for TCP.

See [UDP Health Checks]({{< ref "nginx/admin-guide/load-balancer/udp-health-check.md" >}}) for instructions how to configure health checks for UDP.

## On-the-fly configuration

Upstream server groups can be easily reconfigured on-the-fly using NGINX Plus REST API. Using this interface, you can view all servers in an upstream group or a particular server, modify server parameters, and add or remove upstream servers.

To enable on-the-fly configuration:

1. Create the top-level `http {}` block or make sure it is present in your configuration:

   ```nginx
   http {
       # ...
   }
   ```

2. Create a location for configuration requests, for example, _api_:

   ```nginx
   http {
       server {
           location /api {
               # ...
           }
       }
   }
   ```

3. In this location specify the [`api`](https://nginx.org/en/docs/http/ngx_http_api_module.html#api) directive:

   ```nginx
   http {
       server {
           location /api {
               api;
               # ...
           }
       }
   }
   ```

4. By default, the NGINX Plus API provides read-only access to data. The `write=on` parameter enables read/write access so that changes can be made to upstreams:

   ```nginx
   http {
       server {
           location /api {
               api  write=on;
               # ...
           }
       }
   }
   ```

5. Limit access to this location with [`allow`](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow) and [`deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny) directives:

   ```nginx
   http {
       server {
           location /api {
               api   write=on;
               allow 127.0.0.1; # permit access from localhost
               deny  all;       # deny access from everywhere else
           }
       }
   }
   ```

6. When the API is enabled in the write mode, it is recommended restricting access to `PATCH`, `POST`, and `DELETE` methods to particular users. This can be done by implementing [HTTP basic authentication](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html):

   ```nginx
   http {
       server {
           location /api {
               limit_except GET {
                   auth_basic "NGINX Plus API";
                   auth_basic_user_file /path/to/passwd/file;
               }
               api   write=on;
               allow 127.0.0.1;
               deny  all;
           }
       }
   }
   ```

7. Create a _shared memory zone_ for the group of upstream servers so that all worker processes can use the same configuration. To do this, in the top-level [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block, find the target upsteam group, add the [`zone`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#zone) directive to the upstream server group and specify the zone name (here, **stream_backend**) and the amount of memory (64 KB):

   ```nginx
   stream {
       upstream stream_backend {
           zone backend 64k;
           # ...
       }
   }
   ```

### On-the-fly configuration example

```nginx
stream {
    # ...
    # Configuration of an upstream server group
    upstream appservers {
        zone appservers 64k;
        server appserv1.example.com:12345 weight=5;
        server appserv2.example.com:12345 fail_timeout=5s;
        server backup1.example.com:12345 backup;
        server backup2.example.com:12345 backup;
    }

    server {
        # Server that proxies connections to the upstream group
        proxy_pass appservers;
        health_check;
    }
}
http {
    # ...
    server {
        # Location for API requests
        location /api {
            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
            api write=on;
            allow 127.0.0.1;
            deny  all;
        }
    }
}
```

Here, access to the location is allowed only from the localhost address (`127.0.0.1`). Access from all other IP addresses is denied.

To pass a configuration command to NGINX, send an API command by any method, for example, with curl.

For example, to add a new server to the server group, send a `POST` request:

```shell
curl -X POST -d '{ \
   "server": "appserv3.example.com:12345", \
   "weight": 4 \
 }' -s 'http://127.0.0.1/api/9/stream/upstreams/appservers/servers'
```

To remove a server from the server group, send a `DELETE` request:

```shell
curl -X DELETE -s 'http://127.0.0.1/api/9/stream/upstreams/appservers/servers/0'
```

To modify a parameter for a specific server, send a  `PATCH` request:

```shell
curl -X PATCH -d '{ "down": true }' -s 'http://127.0.0.1/api/9/http/upstreams/appservers/servers/0'
```

## Example of TCP and UDP load-balancing configuration {#example}

This is a configuration example of TCP and UDP load balancing with NGINX:

```nginx
stream {
    upstream stream_backend {
        least_conn;
        server backend1.example.com:12345 weight=5;
        server backend2.example.com:12345 max_fails=2 fail_timeout=30s;
        server backend3.example.com:12345 max_conns=3;
    }

    upstream dns_servers {
        least_conn;
        server 192.168.136.130:53;
        server 192.168.136.131:53;
        server 192.168.136.132:53;
    }

    server {
        listen        12345;
        proxy_pass    stream_backend;
        proxy_timeout 3s;
        proxy_connect_timeout 1s;
    }

    server {
        listen     53 udp;
        proxy_pass dns_servers;
    }

    server {
        listen     12346;
        proxy_pass backend4.example.com:12346;
    }
}
```

In this example, all TCP and UDP proxy‑related functionality is configured inside the [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block, just as settings for HTTP requests are configured in the [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) block.

There are two named [`upstream`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream) blocks, each containing three servers that host the same content as one another. In the [`server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) for each server, the server name is followed by the obligatory port number. Connections are distributed among the servers according to the [Least Connections](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#least_conn) load‑balancing method: a connection goes to the server with the fewest number of active connections.

The three [`server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) blocks define three virtual servers:

- The first server listens on port 12345 and proxies all TCP connections to the **stream_backend** group of upstream servers. Note that the [`proxy_pass`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_pass) directive defined in the context of the `stream` module must not contain a protocol.

  Two optional timeout parameters are specified: the [`proxy_connect_timeout`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_connect_timeout) directive sets the timeout required for establishing a connection with a server in the **stream_backend** group. The [`proxy_timeout`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_timeout) directive sets a timeout used after proxying to one of the servers in the **stream_backend** group has started.

- The second server listens on port 53 and proxies all UDP datagrams (the `udp` parameter to the `listen` directive) to an upstream group called **dns_servers**. If the `udp` parameter is not specified, the socket listens for TCP connections.

- The third virtual server listens on port 12346 and proxies TCP connections to **backend4.example.com**, which can resolve to several IP addresses that are load balanced with the Round Robin method.

## See also

- [TCP Health Checks]({{< relref "tcp-health-check.md" >}})

- [UDP Health Checks]({{< relref "udp-health-check.md" >}})

- [Load Balancing DNS Traffic with NGINX and NGINX Plus](https://www.f5.com/company/blog/nginx/load-balancing-dns-traffic-nginx-plus)

- [TCP/UDP Load Balancing with NGINX: Overview, Tips, and Tricks](https://blog.nginx.org/blog/tcp-load-balancing-udp-load-balancing-nginx-tips-tricks)
