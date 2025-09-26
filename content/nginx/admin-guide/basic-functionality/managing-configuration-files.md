---
description: Understand the basic elements in an NGINX or F5 NGINX Plus configuration
  file, including directives and contexts.
nd-docs: DOCS-378
title: Create NGINX Plus and NGINX Configuration Files
toc: true
weight: 200
type:
- how-to
---

NGINX and NGINX Plus use a text‑based configuration file, by default named **nginx.conf**.

NGINX Plus: default location is `/etc/nginx` for Linux or `/usr/local/etc/nginx` for FreeBSD.

NGINX Open Source: location depends on the package system used to install NGINX and the operating system. It is typically one of `/usr/local/nginx/conf`, `/etc/nginx`, or `/usr/local/etc/nginx`.

You can verify the exact configuration file path with the `--conf-path=` parameter in the output of the `nginx -V` command:

```shell
 nginx -V 2>&1 | awk -F: '/configure arguments/ {print $2}' | xargs -n1
```

Sample output:

```none
--prefix=/etc/nginx
--sbin-path=/usr/sbin/nginx
--modules-path=/usr/lib64/nginx/modules
--conf-path=/etc/nginx/nginx.conf          # The path to your config file
--error-log-path=/var/log/nginx/error.log
--http-log-path=/var/log/nginx/access.log
--pid-path=/var/run/nginx.pid
--...<more parameters>
```

## Directives

The configuration file consists of _directives_ and their parameters. Simple (single‑line) directives end with a semicolon ( `;` ). Other directives act as “containers” which group together related directives. Containers are enclosed in curly braces ( `{}` ) and are often referred to as _blocks_. Here are some examples of simple directives.

```nginx
user             nobody;
error_log        logs/error.log notice;
worker_processes 1;
```

## Feature-specific configuration files

To make the configuration easier to maintain, it is possible to split it into a set of feature‑specific files stored in the `/etc/nginx/conf.d` directory and use the [include](https://nginx.org/en/docs/ngx_core_module.html#include) directive in the main **nginx.conf** file to reference the contents of the feature‑specific files.

```nginx
include conf.d/http;
include conf.d/stream;
include conf.d/exchange-enhanced;
```

## Contexts

A few top‑level directives, referred to as _contexts_, group together the directives that apply to different traffic types:

- [events](https://nginx.org/en/docs/ngx_core_module.html#events) – General connection processing
- [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) – HTTP traffic
- [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail) – Mail traffic
- [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) – TCP and UDP traffic

Directives placed outside of these contexts are said to be in the _main_ context.

### Virtual servers

In each of the traffic‑handling contexts, you include one or more `server` blocks to define _virtual servers_ that control the processing of requests. The directives you can include within a `server` context vary depending on the traffic type.

For HTTP traffic (the `http` context), each [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) directive controls the processing of requests for resources at particular domains or IP addresses. One or more [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) contexts within a `server` context define how to process specific sets of URIs.

For mail and TCP/UDP traffic (the [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html) and [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) contexts) the `server` directives each control the processing of traffic arriving at a particular TCP port or UNIX socket.

### Sample configuration file with multiple contexts

The following configuration illustrates the use of contexts.

```nginx
user nobody; # a directive in the 'main' context

events {
    # configuration of connection processing
}

http {
    # Configuration specific to HTTP and affecting all virtual servers

    server {
        # configuration of HTTP virtual server 1
        location /one {
            # configuration for processing URIs starting with '/one'
        }
        location /two {
            # configuration for processing URIs starting with '/two'
        }
    }

    server {
        # configuration of HTTP virtual server 2
    }
}

stream {
    # Configuration specific to TCP/UDP and affecting all virtual servers
    server {
        # configuration of TCP virtual server 1
    }
}
```

### Inheritance

In general, a _child_ context – a context contained within another context (its _parent_) – inherits the settings of directives included at the parent level. Some directives can appear in multiple contexts, in which case you can override the setting inherited from the parent by including the directive in the child context. For an example, see the [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive.

## Reload configuration file

For changes to the configuration file to take effect, it must be reloaded. You can either restart the `nginx` process or send the `reload` signal to upgrade the configuration without interrupting the processing of current requests. For details, see [Control NGINX Processes at Runtime]({{< ref "/nginx/admin-guide/basic-functionality/runtime-control.md" >}}).

With NGINX Plus, you can dynamically reconfigure [load balancing]({{< ref "/nginx/admin-guide/load-balancer/dynamic-configuration-api.md" >}}) across the servers in an upstream group without reloading the configuration. You can also use the NGINX Plus API and key‑value store to dynamically control access, for example [based on client IP address]({{< ref "/nginx/admin-guide/security-controls/denylisting-ip-addresses.md" >}}).
