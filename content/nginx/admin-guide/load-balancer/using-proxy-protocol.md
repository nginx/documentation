---
description: null
docs: DOCS-422
title: Accepting the PROXY Protocol
toc: true
weight: 800
type:
- how-to
---

This article explains how to configure NGINX and F5 NGINX Plus to accept the PROXY protocol, rewrite the IP address of a load balancer or proxy to the one received in the PROXY protocol header, configure simple logging of a client’s IP address, and enable the PROXY protocol between NGINX and a TCP upstream server.

<span id="intro"></span>
## Introduction

The [PROXY protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt) enables NGINX and NGINX Plus to receive client connection information passed through proxy servers and load balancers such as HAproxy and Amazon Elastic Load Balancer (ELB).

With the PROXY protocol, NGINX can learn the originating IP address from HTTP, SSL, HTTP/2, SPDY, WebSocket, and TCP. Knowing the originating IP address of a client may be useful for setting a particular language for a website, keeping a denylist of IP addresses, or simply for logging and statistics purposes.

The information passed via the PROXY protocol is the client IP address, the proxy server IP address, and both port numbers.

Using this data, NGINX can get the originating IP address of the client in several ways:

- With the [`$proxy_protocol_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_addr) and [`$proxy_protocol_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_port) variables which capture the original client IP address and port. The [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr) and [`$remote_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_port) variables capture the IP address and port of the load balancer.

- With the [RealIP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) module which rewrites the values in the [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr) and [`$remote_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_port) variables, replacing the IP address and port of the load balancer with the original client IP address and port. The [`$realip_remote_addr`](https://nginx.org/en/docs/http/ngx_http_realip_module.html#var_realip_remote_addr) and [`$realip_remote_port`](https://nginx.org/en/docs/http/ngx_http_realip_module.html#var_realip_remote_port) variables retain the address and port of the load balancer, and the [`$proxy_protocol_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_addr) and [`$proxy_protocol_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_port) variables retain the original client IP address and port anyway.

<span id="prereq"></span>
## Prerequisites

- To accept the PROXY protocol v2, NGINX Plus <a href="../../../releases/#r16">R16</a> and later or NGINX Open Source [1.13.11](https://nginx.org/en/CHANGES) and later

- To accept the PROXY protocol for HTTP, NGINX Plus <a href="../../../releases/#r3">R3</a> and later or NGINX Open Source [1.5.12](https://nginx.org/en/CHANGES) and later

- For TCP client‑side PROXY protocol support, NGINX Plus <a href="../../../releases/#r7">R7</a> and later or NGINX Open Source [1.9.3](https://nginx.org/en/CHANGES) and later

- To accept the PROXY protocol for TCP, NGINX Plus <a href="../../../releases/#r11">R11</a> and later or NGINX Open Source [1.11.4](https://nginx.org/en/CHANGES) and later

- The Real‑IP modules for [HTTP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) and [Stream TCP](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) are not included in NGINX Open Source by default; see [Installing NGINX Open Source]({{< relref "../installing-nginx/installing-nginx-open-source.md" >}}) for details. No extra steps are required for NGINX Plus.


<span id="listen"></span>
## Configuring NGINX to Accept the PROXY Protocol

To configure NGINX to accept PROXY protocol headers, add the `proxy_protocol` parameter to the `listen` directive in a `server` block in the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) or [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) block.

```nginx
http {
    #...
    server {
        listen 80   proxy_protocol;
        listen 443  ssl proxy_protocol;
        #...
    }
}

stream {
    #...
    server {
        listen 12345 proxy_protocol;
        #...
    }
}
```

Now you can use the [`$proxy_protocol_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_addr) and [`$proxy_protocol_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_port) variables for the client IP address and port and additionally configure the [HTTP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) and [`stream`](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) RealIP modules to replace the IP address of the load balancer in the [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr) and [`$remote_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_port) variables with the IP address and port of the client.

<span id="realip"></span>
## Changing the Load Balancer's IP Address To the Client IP Address

You can replace the address of the load balancer or TCP proxy with the client IP address received from the PROXY protocol. This can be done with the [HTTP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) and [`stream`](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) RealIP modules. With these modules, the [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr) and [`$remote_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_port) variables retain the real IP address and port of the client, while the [`$realip_remote_addr`](https://nginx.org/en/docs/http/ngx_http_realip_module.html#var_realip_remote_addr) and [`$realip_remote_port`](https://nginx.org/en/docs/http/ngx_http_realip_module.html#var_realip_remote_port) variables retain the IP address and port of the load balancer.

To change the IP address from the load balancer's IP address to the client's IP address:

1. Make sure you've configured NGINX to accept the PROXY protocol headers. See [Configuring NGINX to Accept the PROXY Protocol](#listen).

2. Make sure that your NGINX installation includes the [HTTP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) and [Stream](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) Real‑IP modules:

   ```shell
   nginx -V 2>&1 | grep -- 'http_realip_module'
   nginx -V 2>&1 | grep -- 'stream_realip_module'
   ```

   If not, recompile NGINX with these modules. See [Installing NGINX Open Source]({{< relref "../installing-nginx/installing-nginx-open-source.md" >}}) for details. No extra steps are required for NGINX Plus.

3. In the `set_real_ip_from` directive for [HTTP](https://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from), [Stream](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html#set_real_ip_from), or both, specify the IP address or the CIDR range of addresses of the TCP proxy or load balancer:

   ```nginx
   server {
       #...
       set_real_ip_from 192.168.1.0/24;
      #...
   }
   ```

4. In the `http {}` context, change the IP address of the load balancer to the IP address of the client received from the PROXY protocol header, by specifying the `proxy_protocol` parameter to the [`real_ip_header`](https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header) directive:

   ```nginx
   http {
       server {
           #...
           real_ip_header proxy_protocol;
         }
   }
   ```

<span id="log"></span>
## Logging the Original IP Address

When you know the original IP address of the client, you can configure the correct logging:

1. For HTTP, configure NGINX to pass the client IP address to upstream servers using the [`$proxy_protocol_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_addr) variable with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive:

   ```nginx
   http {
       proxy_set_header X-Real-IP       $proxy_protocol_addr;
       proxy_set_header X-Forwarded-For $proxy_protocol_addr;
   }
   ```

2. Add the [`$proxy_protocol_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_addr) variable to the `log_format` directive ([HTTP](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) or [Stream](https://nginx.org/en/docs/stream/ngx_stream_log_module.html#log_format)):

   - In the `http` block:

     ```nginx
     http {
         #...
         log_format combined '$proxy_protocol_addr - $remote_user [$time_local] '
                             '"$request" $status $body_bytes_sent '
                             '"$http_referer" "$http_user_agent"';
     }
     ```

   - In the `stream` block:

     ```nginx
     stream {
         #...
         log_format basic '$proxy_protocol_addr - $remote_user [$time_local] '
                           '$protocol $status $bytes_sent $bytes_received '
                           '$session_time';
     }
     ```

<span id="proxy_protocol"></span>
## PROXY Protocol for a TCP Connection to an Upstream

For a TCP stream, the PROXY protocol can be enabled for connections between NGINX and an upstream server. To enable the PROXY protocol, include the [`proxy_protocol`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_protocol) directive in a `server` block at the `stream {}` level:

```nginx
stream {
    server {
        listen 12345;
        proxy_pass example.com:12345;
        proxy_protocol on;
    }
}
```

<span id="example"></span>
## Example

```nginx
http {
    log_format combined '$proxy_protocol_addr - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent '
                        '"$http_referer" "$http_user_agent"';
    #...

    server {
        server_name localhost;

        listen 80   proxy_protocol;
        listen 443  ssl proxy_protocol;

        ssl_certificate      /etc/nginx/ssl/public.example.com.pem;
        ssl_certificate_key  /etc/nginx/ssl/public.example.com.key;

        location /app/ {
            proxy_pass       http://backend1;
            proxy_set_header Host            $host;
            proxy_set_header X-Real-IP       $proxy_protocol_addr;
            proxy_set_header X-Forwarded-For $proxy_protocol_addr;
        }
    }
}

stream {
    log_format basic '$proxy_protocol_addr - $remote_user [$time_local] '
                     '$protocol $status $bytes_sent $bytes_received '
                     '$session_time';
    #...
    server {
        listen              12345 ssl proxy_protocol;

        ssl_certificate     /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/cert.key;

        proxy_pass          backend.example.com:12345;
        proxy_protocol      on;
    }
}
```

The example assumes that there is a load balancer in front of NGINX to handle all incoming HTTPS traffic, for example Amazon ELB. NGINX accepts HTTPS traffic on port 443 (`listen 443 ssl;`), TCP traffic on port 12345, and accepts the client’s IP address passed from the load balancer via the PROXY protocol as well (the `proxy_protocol` parameter to the `listen` directive in both the `http {}` and `stream {}` blocks.

NGINX terminates HTTPS traffic (the [`ssl_certificate`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) and [`ssl_certificate_key`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key) directives) and proxies the decrypted data to a backend server:

- For HTTP: `proxy_pass http://backend1;`
- For TCP:  `proxy_pass backend.example.com:12345`

It includes the client IP address and port with the [`proxy_set_header`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directives.

The [`$proxy_protocol_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_addr) variable specified in the [`log_format`](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) directive also passes the client’s IP address to the log for both HTTP and TCP.

Additionally, a TCP server (the `stream {}` block) sends its own PROXY protocol data to its backend servers (the `proxy_protocol on` directive).
