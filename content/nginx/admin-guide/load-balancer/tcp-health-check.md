---
description: Monitor the health of TCP servers in an upstream group by sending periodic
  health checks, including customizable active health checks in F5 NGINX Plus.
docs: DOCS-419
title: TCP Health Checks
toc: true
weight: 400
type:
- how-to
---

<span id="intro"></span>
## Introduction

NGINX and F5 NGINX Plus can continually test your TCP upstream servers, avoid the servers that have failed, and gracefully add the recovered servers into the load‑balanced group.

<span id="prereq"></span>
## Prerequisites

- You have configured an upstream group of TCP servers in the [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context, for example:

    ```nginx
    stream {
        #...
        upstream stream_backend {
            server backend1.example.com:12345;
            server backend2.example.com:12345;
            server backend3.example.com:12345;
       }
        #...
    }
    ```

- You have configured a server that passes TCP connections to the server group:

    ```nginx
    stream {
        #...
        server {
            listen     12345;
            proxy_pass stream_backend;
        }
        #...
    }
    ```

<span id="hc_passive"></span>
## Passive TCP Health Checks

If an attempt to connect to an upstream server times out or results in an error, NGINX Open Source or NGINX Plus can mark the server as unavailable and stop sending requests to it for a defined amount of time. To define the conditions under which NGINX considers an upstream server unavailable, include the following parameters to the [`server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) directive

- [`fail_timeout`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#fail_timeout) – The amount of time within which a specified number of connection attempts must fail for the server to be considered unavailable. Also, the amount of time that NGINX considers the server unavailable after marking it so.
- [`max_fails`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#max_fails) – The number of failed attempts that happen during the specified time for NGINX to consider the server unavailable.

The default values are `10` seconds and `1` attempt. So if a connection attempt times out or fails at least once in a 10‑second period, NGINX marks the server as unavailable for 10 seconds. The example shows how to set these parameters to 2 failures within 30 seconds:

```nginx
upstream stream_backend {
    server backend1.example.com:12345 weight=5;
    server backend2.example.com:12345 max_fails=2 fail_timeout=30s;
    server backend3.example.com:12346 max_conns=3;
}
```

<span id="slow_start"></span>
### Server Slow Start

A recently recovered upstream server can be easily overwhelmed by connections, which may cause the server to be marked as unavailable again. Slow start allows an upstream server to gradually recover its weight from zero to its nominal value after it has been recovered or became available. This can be done with the [`slow_start`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#slow_start) parameter of the upstream [`server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) directive:

```nginx
upstream backend {
    server backend1.example.com:12345 slow_start=30s;
    server backend2.example.com;
    server 192.0.0.1 backup;
}
```

Note that if there is only a single server in a group, the `slow_start` parameter is ignored and the server is never marked unavailable. Slow start is exclusive to NGINX Plus.

<span id="hc_active"></span>
## Active TCP Health Checks

Health checks can be configured to test a wide range of failure types. For example, NGINX Plus can continually test upstream servers for responsiveness and avoid servers that have failed.

NGINX Plus sends special health check requests to each upstream server and checks for a response that satisfies certain conditions. If a connection to the server cannot be established, the health check fails, and the server is considered unhealthy. NGINX Plus does not proxy client connections to unhealthy servers. If several health checks are configured for an upstream group, the failure of any check is enough to consider the corresponding server unhealthy.

To enable active health checks:

1. Specify a _shared memory zone_ – a special area where the NGINX Plus worker processes share state information about counters and connections. Add the [`zone`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#zone) directive to the upstream server group and specify the zone name (here, **stream_backend**) and the amount of memory (64 KB):

    ```nginx
    stream {
        #...
        upstream stream_backend {
            zone   stream_backend 64k;
            server backend1.example.com:12345;
            server backend2.example.com:12345;
            server backend3.example.com:12345;
        }
        #...
    }
    ```

2. Enable active health checks for the upstream group with the [`health_check`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) directive:

    ```nginx
    stream {
        #...
        server {
            listen        12345;
            proxy_pass    stream_backend;
            health_check;
            #...
        }
    }
    ```

3. If necessary, reduce a timeout between two consecutive health checks with the [`health_check_timeout`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_timeout) directive. This directive overrides the [`proxy_timeout`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_timeout) value for health checks, as for health checks this timeout needs to be significantly shorter:

    ```nginx
    stream {
        #...
        server {
            listen               12345;
            proxy_pass           stream_backend;
            health_check;
            health_check_timeout 5s;
        }
    }
    ```

4. By default, NGINX Plus sends health check messages to the port specified by the [`server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) directive in the [`upstream`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream) block. You can specify another port for health checks, which is particularly helpful when monitoring the health of many services on the same host. To override the port, specify the [`port`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_port) parameter of the [`health_check`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) directive:

    ```nginx
    stream {
        #...
        server {
            listen               12345;
            proxy_pass           stream_backend;
            health_check         port=12346;
            health_check_timeout 5s;
        }
    }
    ```

<span id="hc_active_finetune"></span>
### Fine-Tuning TCP Health Checks

By default, NGINX Plus tries to connect to each server in an upstream server group every `5` seconds. If the connection cannot be established, NGINX Plus considers the health check failed, marks the server as unhealthy, and stops forwarding client connections to the server.

To change the default behavior, include parameters to the [`health_check`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) directive:

- [`interval`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_interval) – How often (in seconds) NGINX Plus sends health check requests (default is `5` seconds)
- [`passes`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_passes) – Number of consecutive health checks the server must respond to to be considered healthy (default is `1`)
- [`fails`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_fails) – Number of consecutive health checks the server must fail to respond to to be considered unhealthy (default is `1`)

    ```nginx
    stream {
        #...
        server {
            listen       12345;
            proxy_pass   stream_backend;
            health_check interval=10 passes=2 fails=3;
        }
        #...
    }
    ```

  In the example, the time between TCP health checks is increased to `10` seconds, the server is considered unhealthy after `3` consecutive failed health checks, and the server needs to pass `2` consecutive checks to be considered healthy again.


<span id="hc_active_match"></span>
### The “match {}” Configuration Block

You can create your own tests to verify server responses to health checks. These tests are defined with the [`match {}`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) configuration block placed in the [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context.


1. On the [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) level, specify the [`match {}`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) block and name it, for example, `tcp_test`:

    ```nginx
    stream {
        #...
        match tcp_test {
            #...
        }
    }
    ```

    This block will contain tests described in **Step 3**.

2. Refer to the block from the [`health_check`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) directive by specifying the [`match`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_match) parameter and the name of the [`match`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) block:

    ```nginx
    stream {
        #...
        server {
            listen       12345;
            health_check match=tcp_test;
            proxy_pass   stream_backend;
        }
        #...
    }
    ```

3. Within the [`match`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) block, specify the conditions or tests under which a health check succeed. The block can accept the following parameters:

    - [`send`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match_send) – The text string or hexadecimal literals (“\x” followed by two hex digits) to send to the server
    - [`expect`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match_expect) – Literal string or regular expression that the data returned by the server needs to match

    These parameters can be used in different combinations, but no more than one `send` and one `expect` parameter can be specified at a time:

    - If no `send` or `expect` parameters are specified, the ability to connect to the server is tested.

    - If the `expect` parameter is specified, the server is expected to unconditionally send data first:

    ```nginx
    match pop3 {
        expect ~* "\+OK";
    }
    ```

    - If the `send` parameter is specified, it is expected that the connection will be successfully established and the specified string will be sent to the server:

    ```nginx
    match pop_quit {
        send QUIT;
    }
    ```

    - If both the `send` and `expect` parameters are specified, then the string from the `send` parameter must match the regular expression from the `expect` parameter:

    ```nginx
    stream {
        #...
        upstream   stream_backend {
            zone   upstream_backend 64k;
            server backend1.example.com:12345;
        }
        match http {
            send      "GET / HTTP/1.0\r\nHost: localhost\r\n\r\n";
            expect ~* "200 OK";
        }
        server {
            listen       12345;
            health_check match=http;
            proxy_pass   stream_backend;
        }
    }
    ```

    The example shows that in order for a health check to pass, the HTTP request must be sent to the server, and the expected result from the server contains `200` `OK` to indicate a successful HTTP response.
