---
description: This chapter describes how to configure different types of health checks
  for UDP servers in a load‑balanced upstream server group.
docs: DOCS-421
title: UDP Health Checks
toc: true
weight: 500
type:
- how-to
---

<span id="prereq"></span>
## Prerequisites

- You have configured an upstream group of servers that handles UDP network traffic (DNS, RADIUS, syslog) in the [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context, for example:

    ```nginx
    stream {
        #...
        upstream dns_upstream {
            server 192.168.136.130:53;
            server 192.168.136.131:53;
            server 192.168.136.132:53;
        }
        #...
    }
    ```

- You have configured a server that passes UDP datagrams to the upstream server group:

    ```nginx
    stream {
        #...
        server {
            listen          53 udp;
            proxy_pass      dns_upstream;
            proxy_timeout   1s;
            proxy_responses 1;
            error_log       logs/dns.log;
        }
        #...
    }
    ```

    See [TCP and UDP Load Balancing]({{< relref "../load-balancer/tcp-udp-load-balancer.md" >}}) for details.

<span id="hc_passive"></span>
## Passive UDP Health Checks

NGINX Open Source or F5 NGINX Plus can mark the server as unavailable and stop sending UDP datagrams to it for some time if the server replies with an error or times out.

The number of consecutive failed connection attempts within a certain time period is set with the [`max_fails`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#max_fails) parameter for an [`upstream server`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server) (default value is `1`).

The time period is set with the [`fail_timeout`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#fail_timeout) parameter (default value is `10` seconds). The parameter also sets the amount of time that NGINX considers the server unavailable after marking it so.

So if a connection attempt times out or fails at least once in a 10‑second period, NGINX marks the server as unavailable for 10 seconds. The example shows how to set these parameters to 2 failures within 60 seconds:

```nginx
upstream dns_upstream {
    server 192.168.136.130:53 fail_timeout=60s;
    server 192.168.136.131:53 fail_timeout=60s;
}
```

<span id="hc_active"></span>
## Active UDP Health Checks

Active Health Checks allow testing a wider range of failure types and are available only for NGINX Plus. For example, instead of waiting for an actual TCP request from a DNS client to fail before marking the DNS server as down (as in passive health checks), NGINX Plus will send special health check requests to each upstream server and check for a response that satisfies certain conditions. If a connection to the server cannot be established, the health check fails, and the server is considered unhealthy. NGINX Plus does not proxy client connections to unhealthy servers. If more than one health check is defined, the failure of any check is enough to consider the corresponding upstream server unhealthy.

To enable active health checks:

1. In the upstream group, specify a _shared memory zone_ with the [`zone`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#zone) directive – a special area where the NGINX Plus worker processes share state information about counters and connections. In the `zone` directive, specify the zone _name_ (`dns_zone` in the example) and the zone _size_ (`64k` in the example):

    ```nginx
    stream {
        #...
        upstream dns_upstream {
            zone   dns_zone 64k;
            server 192.168.136.130:53;
            server 192.168.136.131:53;
            server 192.168.136.132:53;
        }
        #...
    }
    ```

2. In the `server` block that forwards traffic to the upstream group (via [`proxy_pass`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_pass)), specify the [`udp`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_udp) parameter to the `health_check` directive:

    ```nginx
    stream {
        #...
        server {
             listen       53 udp;
             proxy_pass   dns_upstream;
             health_check udp;
        }
        #...
    }
    ```

A basic UDP health check assumes that NGINX Plus sends the “nginx health check” string to an upstream server and expects the absence of ICMP “Destination Unreachable” message in response. You can configure your own health check tests in the `match {}` block. See [The “match {}” Configuration Block](#hc_active_match) for details.

<span id="hc_active_finetune"></span>
### Fine-Tuning UDP Health Checks

You can fine‑tune the health check by specifying the following parameters to the [`health_check`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) directive:

- `interval`– How often (in seconds) NGINX Plus sends health check requests (default is `5` seconds)
- `passes`– Number of consecutive health checks the server must respond to to be considered healthy (default is `1`)
- `fails`– Number of consecutive health checks the server must fail to respond to to be considered unhealthy (default is `1`)

```nginx
server {
    listen       53 udp;
    proxy_pass   dns_upstream;
    health_check interval=20 passes=2 fails=2 udp;
}
```

In the example, the time between UDP health checks is increased to 20 seconds, the server is considered unhealthy after 2 consecutive failed health checks, and the server needs to pass 2 consecutive checks to be considered healthy again.

<span id="hc_active_match"></span>
### The “match {}” Configuration Block

You can verify server responses to health checks by configuring a number of tests. These tests are defined within the [`match {}`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) configuration block.

1. In the top‑level `stream {}` context, specify the [`match {}`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) block and set its name, for example, `udp_test`:

    ```nginx
    stream {
        #...
        match  udp_test {
            #...
        }
    }
    ```

2. Refer to the block from the `health_check` directive by including the [`match`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_match) parameter to specify the name of the `match {}` block:

    ```nginx
    stream {
        #...
        server {
            listen       53 udp;
            proxy_pass   dns_upstream;
            health_check match=udp_test udp;
        }
        #...
    }
    ```

3. In the `match {}` block, specify conditions or tests under which a health check succeeds. This is done with `send` and `expect` parameters:
    - [`send`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match_send)– The text string or hexadecimal literals (“/x” followed by two hex digits) to send to the server
    - [`expect`](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match_expect)– Literal string or regular expression that the data returned by the server needs to match

    These parameters can be used in different combinations, but no more than one `send` and one `expect` parameter can be specified at a time.

<span id="example_ntp"></span>
#### Example Test for NTP

To fine‑tune health checks for NTP, you should specify both `send` and `expect` parameters with the following text strings:

```nginx
match ntp {
    send \xe3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00;
    expect ~* \x24;
}
```

<span id="example_dns"></span>
#### Example Test for DNS

To fine‑tune health checks for DNS, you should also specify both `send` and `expect` parameters with the following text strings:

```nginx
match dns {
    send \x00\x2a\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x03\x73\x74\x6c\x04\x75\x6d\x73\x6c\x03\x65\x64\x75\x00\x00\x01\x00\x01;
    expect ~* "health.is.good";
}
```
