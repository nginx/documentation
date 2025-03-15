---
description: Configure NGINX as a reverse proxy for HTTP and other protocols, with
  support for modifying request headers and fine-tuned buffering of responses.
docs: DOCS-441
title: NGINX Reverse Proxy
toc: true
weight: 300
type:
- how-to
---

This article describes the basic configuration of a proxy server. You will learn how to pass a request from NGINX to proxied servers over different protocols, modify client request headers that are sent to the proxied server, and configure buffering of responses coming from the proxied servers.

## Introduction

Proxying is typically used to distribute the load among several servers, seamlessly show content from different websites, or pass requests for processing to application servers over protocols other than HTTP.

## Passing a Request to a Proxied Server

When NGINX proxies a request, it sends the request to a specified proxied server, fetches the response, and sends it back to the client. It is possible to proxy requests to an HTTP server (another NGINX server or any other server) or a non-HTTP server (which can run an application developed with a specific framework, such as PHP or Python) using a specified protocol. Supported protocols include [FastCGI](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html), [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html), [SCGI](https://nginx.org/en/docs/http/ngx_http_scgi_module.html), and [memcached](https://nginx.org/en/docs/http/ngx_http_memcached_module.html).

To pass a request to an HTTP proxied server, the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive is specified inside a [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location). For example:

```nginx
location /some/path/ {
    proxy_pass http://www.example.com/link/;
}
```

This example configuration results in passing all requests processed in this location to the proxied server at the specified address. This address can be specified as a domain name or an IP address. The address may also include a port:

```nginx
location ~ \.php {
    proxy_pass http://127.0.0.1:8000;
}
```

Note that in the first example above, the address of the proxied server is followed by a URI, `/link/`. If the URI is specified along with the address, it replaces the part of the request URI that matches the location parameter. For example, here the request with the `/some/path/page.html` URI will be proxied to `http://www.example.com/link/page.html`. If the address is specified without a URI, or it is not possible to determine the part of URI to be replaced, the full request URI is passed (possibly, modified).

To pass a request to a non-HTTP proxied server, the appropriate `**_pass` directive should be used:

- [fastcgi_pass](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass) passes a request to a FastCGI server
- [uwsgi_pass](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass) passes a request to a uwsgi server
- [scgi_pass](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass) passes a request to an SCGI server
- [memcached_pass](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_pass) passes a request to a memcached server

Note that in these cases, the rules for specifying addresses may be different. You may also need to pass additional parameters to the server (see the [reference documentation](https://nginx.org/en/docs/) for more detail).

The [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive can also point to a [named group](https://nginx.org/en/docs/http/load_balancing.html#algorithms) of servers. In this case, requests are distributed among the servers in the group according to the [specified method](https://www.nginx.com/resources/admin-guide/load-balancer/).

<span id="headers"></span>
## Passing Request Headers

By default, NGINX redefines two header fields in proxied requests, “Host” and “Connection”, and eliminates the header fields whose values are empty strings. “Host” is set to the `$proxy_host` variable, and “Connection” is set to `close`.

To change these setting, as well as modify other header fields, use the [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive. This directive can be specified in a [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) or higher. It can also be specified in a particular [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) context or in the [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) block. For example:

```nginx
location /some/path/ {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://localhost:8000;
}
```

In this configuration the “Host” field is set to the [$host](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) variable.

To prevent a header field from being passed to the proxied server, set it to an empty string as follows:

```nginx
location /some/path/ {
    proxy_set_header Accept-Encoding "";
    proxy_pass http://localhost:8000;
}
```

<span id="buffers"></span>
## Configuring Buffers

By default NGINX buffers responses from proxied servers. A response is stored in the internal buffers and is not sent to the client until the whole response is received. Buffering helps to optimize performance with slow clients, which can waste proxied server time if the response is passed from NGINX to the client synchronously. However, when buffering is enabled NGINX allows the proxied server to process responses quickly, while NGINX stores the responses for as much time as the clients need to download them.

The directive that is responsible for enabling and disabling buffering is [proxy_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering). By default it is set to `on` and buffering is enabled.

The [proxy_buffers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers) directive controls the size and the number of buffers allocated for a request. The first part of the response from a proxied server is stored in a separate buffer, the size of which is set with the [proxy_buffer_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size) directive. This part usually contains a comparatively small response header and can be made smaller than the buffers for the rest of the response.

In the following example, the default number of buffers is increased and the size of the buffer for the first portion of the response is made smaller than the default.

```nginx
location /some/path/ {
    proxy_buffers 16 4k;
    proxy_buffer_size 2k;
    proxy_pass http://localhost:8000;
}
```

If buffering is disabled, the response is sent to the client synchronously while it is receiving it from the proxied server. This behavior may be desirable for fast interactive clients that need to start receiving the response as soon as possible.

To disable buffering in a specific location, place the [proxy_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering) directive in the [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) with the `off` parameter, as follows:

```nginx
location /some/path/ {
    proxy_buffering off;
    proxy_pass http://localhost:8000;
}
```

In this case NGINX uses only the buffer configured by [proxy_buffer_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size) to store the current part of a response.

A common use of a reverse proxy is to provide load balancing. Learn how to improve power, performance, and focus on your apps with rapid deployment in the free [Five Reasons to Choose a Software Load Balancer](https://www.nginx.com/resources/library/five-reasons-choose-software-load-balancer/) ebook.

<span id="proxy_bind"></span>
## Choosing an Outgoing IP Address

If your proxy server has several network interfaces, sometimes you might need to choose a particular source IP address for connecting to a proxied server or an upstream. This may be useful if a proxied server behind NGINX is configured to accept connections from particular IP networks or IP address ranges.

Specify the [proxy_bind](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_bind) directive and the IP address of the necessary network interface:

```nginx
location /app1/ {
    proxy_bind 127.0.0.1;
    proxy_pass http://example.com/app1/;
}

location /app2/ {
    proxy_bind 127.0.0.2;
    proxy_pass http://example.com/app2/;
}
```

The IP address can be also specified with a variable. For example, the [`$server_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_server_addr) variable passes the IP address of the network interface that accepted the request:

```nginx
location /app3/ {
    proxy_bind $server_addr;
    proxy_pass http://example.com/app3/;
}
```
