---
description: Load balance HTTP traffic across web or application server groups, with
  several algorithms and advanced features like slow-start and session persistence.
nd-docs: DOCS-418
title: HTTP Load Balancing
toc: true
weight: 100
type:
- how-to
---

<span id="overview"></span>
## Overview

Load balancing across multiple application instances is a commonly used technique for optimizing resource utilization, maximizing throughput, reducing latency, and ensuring fault‑tolerant configurations.

Watch the [F5 NGINX Plus for Load Balancing and Scaling](https://www.nginx.com/resources/webinars/nginx-plus-for-load-balancing-30-min/) webinar, for a deep dive on techniques to build large‑scale, highly available web services.

NGINX and NGINX Plus can be used in different deployment scenarios as a [very efficient HTTP load balancer](https://www.nginx.com/blog/nginx-load-balance-deployment-models/).


<span id="proxy_pass"></span>
## Proxy HTTP Traffic to a Group of Servers

Use NGINX Plus or NGINX Open Source to load balance across a group of servers. First, define the group of servers with the [`upstream`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) directive. Place the directive in the [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context.

Servers in the group are configured using the [`server`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) directive (not to be confused with the `server` block that defines a virtual server running on NGINX). For example, the following configuration defines a group named **backend** and consists of three server configurations. This may resolve to more than three actual servers:

```nginx
http {
    upstream backend {
        server backend1.example.com weight=5;
        server backend2.example.com;
        server 192.0.0.1 backup;
    }
}
```

To pass requests to a server group, the name of the group is specified in the [`proxy_pass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive. If using an alternate protocol such as fastcgi, use that protocol's pass directive instead. The list of alternate pass directives is: [`fastcgi_pass`](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass), [`memcached_pass`](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_pass), [`scgi_pass`](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass), [`uwsgi_pass`](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass).

In the next example, a virtual server running on NGINX passes all requests to the **backend** upstream group defined in the previous example:

```nginx
server {
    location / {
        proxy_pass http://backend;
    }
}
```

The following example combines the two snippets above and shows how to proxy HTTP requests to the **backend** server group. The group consists of three servers, two of them running instances of the same application while the third is a backup server.

```nginx
http {
    upstream backend {
        server backend1.example.com;
        server backend2.example.com;
        server 192.0.0.1 backup;
    }

    server {
        location / {
            proxy_pass http://backend;
        }
    }
}
```


<span id="method"></span>
## Choosing a Load Balancing Method

NGINX Open Source supports four load balancing methods: Round Robin, Least Connections, IP Hash, and Generic Hash.
NGINX Plus supports six load balancing methods: the four above, Least Time, and Random.

> **Note:** When configuring any method other than Round Robin, put the corresponding directive ([`hash`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash), [`ip_hash`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash), [`least_conn`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn), [`least_time`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_time), or [`random`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#random)) above the list of `server` directives in the [`upstream {}`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) block.

1. Round Robin – Requests are distributed evenly across the servers, with [server weights](#weights) taken into consideration. This method is used by default; there is no directive for enabling it.

    ```nginx
    upstream backend {
       # no load balancing method is specified for Round Robin
       server backend1.example.com;
       server backend2.example.com;
    }
    ```

2. [Least Connections](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn) – A request is sent to the server with the least number of active connections. This method also takes  [server weights](#weights) into consideration.

    ```nginx
    upstream backend {
        least_conn;
        server backend1.example.com;
        server backend2.example.com;
    }
    ```

3. [IP Hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash) – The server to which a request is sent is determined from the client IP address. In this case, either the first three octets of the IPv4 address or the whole IPv6 address is used to calculate the hash value. The method guarantees that requests from the same address get to the same server unless it is not available.

    ```nginx
    upstream backend {
        ip_hash;
        server backend1.example.com;
        server backend2.example.com;
    }
    ```

    If one of the servers needs to be temporarily removed from the load‑balancing rotation, it can be marked with the [down](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#down) parameter. This preserves the current hashing of client IP addresses. Requests that were to be processed by this server are automatically sent to the next server in the group.

    ```nginx
    upstream backend {
        server backend1.example.com;
        server backend2.example.com;
        server backend3.example.com down;
    }
    ```

4. Generic [Hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash) – The server to which a request is sent is determined from a user‑defined key. This key can be a text string, a variable, or a combination. For example, the key may be a paired source IP address and port. This example uses a URI:

    ```nginx
    upstream backend {
        hash $request_uri consistent;
        server backend1.example.com;
        server backend2.example.com;
    }
    ```

    The optional [consistent](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash) parameter to the `hash` directive enables [ketama](http://www.last.fm/user/RJ/journal/2007/04/10/rz_libketama_-_a_consistent_hashing_algo_for_memcache_clients) consistent‑hash load balancing. Requests are evenly distributed across all upstream servers based on the user‑defined hashed key value. If an upstream server is added to or removed from an upstream group, only a few keys are remapped, which minimizes cache misses. This is useful for load balancing cache servers or other applications that accumulate state.

5. [Least Time](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_time) (NGINX Plus only) – For each request, NGINX Plus selects the server with the lowest average latency and the lowest number of active connections. The lowest average latency is calculated based the [parameter](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_time) included with the `least_time` directive. This parameter can be one of the following:

    - `header` – Time to receive the first byte from the server
    - `last_byte` – Time to receive the full response from the server
    - `last_byte inflight` – Time to receive the full response from the server, taking into account incomplete requests

    ```nginx
    upstream backend {
        least_time header;
        server backend1.example.com;
        server backend2.example.com;
    }
    ```

6. [Random](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#random) (NGINX Plus only) – Each request will be passed to a randomly selected server. This method takes into account server weights.
If the `two` parameter is specified, NGINX first randomly selects two servers, then chooses between these servers using one of the following specified methods:

    - `least_conn` – The least number of active connections
    - `least_time=header` (NGINX Plus) – The least average time to receive the response header from the server ([`$upstream_header_time`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_header_time))
    - `least_time=last_byte` (NGINX Plus) – The least average time to receive the full response from the server ([`$upstream_response_time`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_response_time))

    ```nginx
    upstream backend {
        random two least_time=last_byte;
        server backend1.example.com;
        server backend2.example.com;
        server backend3.example.com;
        server backend4.example.com;
    }
    ```

    The **Random** load balancing method should be used for distributed environments where multiple load balancers are passing requests to the same set of backends. For environments where the load balancer has a full view of all requests, use other load balancing methods.



<span id="weights"></span>
## Server Weights

Some load balancing methods, including Round Robin, Least Connections, and Random, distribute requests according to their server weights. The [`weight`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#weight) parameter to the [`server`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) directive sets the weight of a server. If no weight is set, it defaults to `1`:

```nginx
upstream backend {
    server backend1.example.com weight=5;
    server backend2.example.com;
    server 192.0.0.1 backup;
}
```

In the example above, **backend1.example.com** has weight `5`, while the other two servers have the default weight (`1`). However, the one with IP address `192.0.0.1` is marked as a `backup` server and does not receive requests unless both of the other servers are unavailable. With this configuration of weights, out of every `6` requests, `5` are sent to **backend1.example.com** and `1` to **backend2.example.com**.


<span id="slow_start"></span>
## Server Slow-Start

The server slow‑start feature prevents a recently recovered server from being overwhelmed by connections, which may time out and cause the server to be marked as failed again. This feature is only available in NGINX Plus.

Slow‑start allows an upstream server to gradually recover its weight from `0` to its nominal value after it has recovered or become available. This can be done with the [`slow_start`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#slow_start) parameter to the `server` directive:

```nginx
upstream backend {
    server backend1.example.com slow_start=30s;
    server backend2.example.com;
    server 192.0.0.1 backup;
}
```

The time value (here, `30` seconds) sets the time during which NGINX Plus ramps up the number of connections to the server to the full value. If no value is specified, it defaults to `0`, which disables slow-start.

> **Note:** If there is only a single server in a group, the [`max_fails`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#max_fails), [`fail_timeout`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#fail_timeout), and [`slow_start`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#slow_start) parameters to the `server` directive are ignored, and the server is never considered unavailable.


<span id="sticky"></span>
## Session Persistence

Session persistence means that NGINX Plus identifies user sessions and routes all requests in a given session to the same upstream server.

NGINX Plus supports three session persistence methods. The methods are set with the [`sticky`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) directive. (For session persistence with NGINX Open Source, use the `hash` or `ip_hash` directive as described [above](#method).)

- [Sticky cookie](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_cookie) – NGINX Plus adds a session cookie to the first response from the upstream group and identifies the server that sent the response. The client's next request contains the cookie value, and NGINX Plus routes the request to the upstream server that responded to the first request. This is the simplest session persistence method.

    ```nginx
    upstream backend {
        server backend1.example.com;
        server backend2.example.com;
        sticky cookie srv_id expires=1h domain=.example.com path=/;
    }
    ```

    In the example above, the `srv_id` parameter sets the name of the cookie. The optional `expires` parameter sets the time for the browser to keep the cookie (here, `1` hour). The optional `domain` parameter defines the domain for which the cookie is set, and the optional `path` parameter defines the path for which the cookie is set.

- [Sticky route](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_route) – Use the [`route`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#route) parameter to the `server` directive to assign a route identifier to each server. NGINX Plus assigns one of the route identifiers to the client when it receives the client's first request. Subsequent requests then compare these route identifiers, which are either stored in a cookie or passed in the request URI.

    ```nginx
    upstream backend {
        server backend1.example.com route=a;
        server backend2.example.com route=b;
        sticky route $route_cookie $route_uri;
    }
    ```
    In the example above, the session cookie is checked first for the route identifier. If there is none, then the URI is checked second.

- [Sticky learn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn) – NGINX Plus first finds session identifiers by inspecting requests and responses. Then NGINX Plus “learns” which upstream server corresponds to which session identifier. Generally, these identifiers are passed in a HTTP cookie. If a request contains a session identifier already “learned”, NGINX Plus forwards the request to the corresponding server:

    ```nginx
    upstream backend {
       server backend1.example.com;
       server backend2.example.com;
       sticky learn
           create=$upstream_cookie_examplecookie
           lookup=$cookie_examplecookie
           zone=client_sessions:1m
           timeout=1h;
    }
    ```

    In the example, one of the upstream servers creates a session by setting the cookie `EXAMPLECOOKIE` in the response.

    The mandatory `create` parameter specifies a variable that indicates how a new session is created. In the example, new sessions are created from the cookie `EXAMPLECOOKIE` sent by the upstream server.

    The mandatory `lookup` parameter specifies how to search for existing sessions. In our example, existing sessions are searched in the cookie `EXAMPLECOOKIE` sent by the client.

    The mandatory `zone` parameter specifies a shared memory zone where all information about sticky sessions is kept. In our example, the zone is named **client_sessions** and is `1` megabyte in size.

    This is a more sophisticated session persistence method than the previous two as it does not require keeping any cookies on the client side: all info is kept server‑side in the shared memory zone.

    If there are several NGINX instances in a cluster that use the "sticky learn" method, it is possible to sync the contents of their shared memory zones on conditions that:
  - the zones have the same name
  - the [`zone_sync`](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync) functionality is configured on each instance
  - the `sync` parameter is specified

    ```nginx
       sticky learn
           create=$upstream_cookie_examplecookie
           lookup=$cookie_examplecookie
           zone=client_sessions:1m
           timeout=1h
           sync;
    }
    ```

    See [Runtime State Sharing in a Cluster]({{< ref "nginx/admin-guide/high-availability/zone_sync.md" >}}) for details.


<span id="maxconns"></span>
## Limit the Number of Connections

With NGINX Plus, it is possible to limit the number of active connections to an upstream server.

The [`max_conns`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#max_conns) parameter sets the maximum number of connections to the upstream server.

The [`queue`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#queue) directive allows excess connections to be held in a queue. It requires a maxmum number for the queue and a timeout.

If the `max_conns` limit has been reached, the request is placed in a queue for further processing. If the queue limit has been reached, if no queue directive is specified, or if a client reaches the `timeout` time in queue, the client will receive an error.

```nginx
upstream backend {
    server backend1.example.com max_conns=3;
    server backend2.example.com;
    queue 100 timeout=70;
}
```

> **Note:** The `max_conns` limit is ignored if there are idle [`keepalive`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) connections opened in other [`worker processes`](https://nginx.org/en/docs/ngx_core_module.html#worker_processes). As a result, the total number of connections to the server might exceed the `max_conns` value in a configuration where the memory is [shared with multiple worker processes](#zone).


<span id="health"></span>
## Configure Health Checks

NGINX can continually test your HTTP upstream servers, avoid the servers that have failed, and gracefully add the recovered servers into the load‑balanced group.

See [HTTP Health Checks]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}) for instructions how to configure health checks for HTTP.


<span id="zone"></span>
## Share Data with Multiple Worker Processes

If an [`upstream`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) block does not include the [`zone`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) directive, each worker process keeps its own copy of the server group configuration and maintains its own set of related counters. The counters include the current number of connections to each server in the group and the number of failed attempts to pass a request to a server. As a result, the server group configuration cannot be modified dynamically.

When the `zone` directive is included in an `upstream` block, the configuration of the upstream group is kept in a memory area shared among all worker processes. This scenario is dynamically configurable, because the worker processes access the same copy of the group configuration and utilize the same related counters.

The `zone` directive is mandatory for [active health checks](#health_active) and [dynamic reconfiguration]({{< ref "dynamic-configuration-api.md" >}}) of the upstream group. However, other features of upstream groups can benefit from the use of this directive as well.

For example, if the configuration of a group is not shared, each worker process maintains its own counter for failed attempts to pass a request to a server (set by the [max_fails](#health_passive) parameter). In this case, each request gets to only one worker process. When the worker process that is selected to process a request fails to transmit the request to a server, other worker processes don’t know anything about it. While some worker process can consider a server unavailable, others might still send requests to this server. For a server to be definitively considered unavailable, the number of failed attempts during the timeframe set by the `fail_timeout` parameter must equal `max_fails` multiplied by the number of worker processes. On the other hand, the `zone` directive guarantees the expected behavior.

Similarly, the [Least Connections](#method) load‑balancing method might not work as expected without the `zone` directive, at least under low load. This method passes a request to the server with the smallest number of active connections. If the configuration of the group is not shared, each worker process uses its own counter for the number of connections and might send a request to the same server that another worker process just sent a request to.  However, you can increase the number of requests to reduce this effect. Under high load requests are distributed among worker processes evenly, and the `Least Connections` method works as expected.


<span id="zone-size"></span>
### Set the Zone Size

It is not possible to recommend an ideal memory‑zone size, because usage patterns vary widely. The required amount of memory is determined by which features (such as [session persistence](#sticky), [health checks](#health_active), or [DNS re‑resolving](#resolve)) are enabled and how the upstream servers are identified.

As an example, with the `sticky_route` session persistence method and a single health check enabled, a 256‑KB zone can accommodate information about the indicated number of upstream servers:

- 128 servers (each defined as an IP‑address:port pair)
- 88 servers (each defined as hostname:port pair where the hostname resolves to a single IP address)
- 12 servers (each defined as hostname:port pair where the hostname resolves to multiple IP addresses)


<span id="resolve"></span>
## Configure HTTP Load Balancing Using DNS

The configuration of a server group can be modified at runtime using DNS.

For servers in an upstream group that are identified with a domain name in the [`server`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) directive, NGINX Plus can monitor changes to the list of IP addresses in the corresponding DNS record, and automatically apply the changes to load balancing for the upstream group, without requiring a restart. This can be done by including the [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive in the [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) block along with the [`resolve`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolve) parameter to the `server` directive:

```nginx
http {
    resolver 10.0.0.1 valid=300s ipv6=off;
    resolver_timeout 10s;
    server {
        location / {
            proxy_pass http://backend;
        }
    }
    upstream backend {
        zone backend 32k;
        least_conn;
        # ...
        server backend1.example.com resolve;
        server backend2.example.com resolve;
    }
}
```

In the example, the `resolve` parameter to the `server` directive tells NGINX Plus to periodically re‑resolve the **backend1.example.com** and **backend2.example.com** domain names into IP addresses.

The [`resolver`](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive defines the IP address of the DNS server to which NGINX Plus sends requests (here, `10.0.0.1`). By default, NGINX Plus re‑resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the `valid` parameter; in the example it is `300` seconds, or `5` minutes.

The optional `ipv6=off` parameter means only IPv4 addresses are used for load balancing, though resolving of both IPv4 and IPv6 addresses is supported by default.

If a domain name resolves to several IP addresses, the addresses are saved to the upstream configuration and load balanced. In our example, the servers are load balanced according to the [Least Connections](#method) load‑balancing method. If the list of IP addresses for a server has changed, NGINX Plus immediately starts load balancing across the new set of addresses.


<span id="ntlm"></span>
## Load Balancing of Microsoft Exchange Servers

In [NGINX Plus Release 7](https://docs.nginx.com/nginx/releases/#nginxplus-release7-r7) and later, NGINX Plus can proxy Microsoft Exchange traffic to a server or a group of servers and load balance it.

To set up load balancing of Microsoft Exchange servers:

1. In a `location` block, configure proxying to the upstream group of Microsoft Exchange servers with the [`proxy_pass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive:

   ```nginx
   location / {
       proxy_pass https://exchange;
       # ...
   }
   ```

2. In order for Microsoft Exchange connections to pass to the upstream servers, in the `location` block set the [`proxy_http_version`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version) directive value to `1.1`, and the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive to `Connection ""`, just like for a keepalive connection:

   ```nginx
   location / {
       # ...
       proxy_http_version 1.1;
       proxy_set_header   Connection "";
       # ...
   }
   ```

3. In the `http` block, configure a upstream group of Microsoft Exchange servers with an [`upstream`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) block named the same as the upstream group specified with the [`proxy_pass`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive in Step 1. Then specify the [`ntlm`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ntlm) directive to allow the servers in the group to accept requests with NTLM authentication:

   ```nginx
   http {
       # ...
       upstream exchange {
           zone exchange 64k;
           ntlm;
           # ...
       }
   }
   ```

4. Add Microsoft Exchange servers to the upstream group and optionally specify a [load‑balancing method](#method):

   ```nginx
   http {
       # ...
       upstream exchange {
           zone exchange 64k;
           ntlm;
           server exchange1.example.com;
           server exchange2.example.com;
           # ...
       }
   }
   ```


<span id="ntlm_example"></span>
### Complete NTLM Example

```nginx
http {
    # ...
    upstream exchange {
        zone exchange 64k;
        ntlm;
        server exchange1.example.com;
        server exchange2.example.com;
    }

    server {
        listen              443 ssl;
        ssl_certificate     /etc/nginx/ssl/company.com.crt;
        ssl_certificate_key /etc/nginx/ssl/company.com.key;
        ssl_protocols       TLSv1.2 TLSv1.3;

        location / {
            proxy_pass         https://exchange;
            proxy_http_version 1.1;
            proxy_set_header   Connection "";
        }
    }
}
```

For more information about configuring Microsoft Exchange and NGINX Plus, see the [Load Balancing Microsoft Exchange Servers with NGINX Plus]({{< ref "/nginx/deployment-guides/load-balance-third-party/microsoft-exchange.md" >}}) deployment guide.


<span id="dynamic"></span>
## Dynamic Configuration Using the NGINX Plus API

With NGINX Plus, the configuration of an upstream server group can be modified dynamically using the NGINX Plus API. A configuration command can be used to view all servers or a particular server in a group, modify parameter for a particular server, and add or remove servers. For more information and instructions, see [Configuring Dynamic Load Balancing with the NGINX Plus API]({{< ref "dynamic-configuration-api.md" >}}).
