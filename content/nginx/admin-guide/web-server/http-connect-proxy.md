---
description: HTTP traffic tunneling via the HTTP CONNECT method, enabling centralized egress control through a trusted NGINX Plus server.
nd-docs: DOCS-441
title: HTTP CONNECT forward proxy
toc: true
weight: 600
type:
- how-to
---

In corporate networks, NGINX Plus R36 and later can be configured as a forward proxy server, facilitating client access to external resources. A forward proxy operates between internal clients and the global network, enabling centralized traffic control.

Unlike a reverse proxy that protects servers, upstreams, or services, forward proxy serves client requests and regulates their access to the external resources. To enable this functionality, the HTTP `CONNECT` method is used to establish a secure tunnel between the client and the proxy server (NGINX Plus). This tunnel permits the transmission of HTTPS traffic and other protocols, such as SSH or FTP, through the proxy.

## Enabling HTTP CONNECT proxy

To enable the HTTP `CONNECT` forward proxy, add the [`tunnel_pass`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_pass) directive that turns on the forward proxy functionality within the `server` or `location` blocks.

The directive can be used without any parameters. The default value is [`$host`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_host):[`$request_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_port) variables: all requests are automatically forwarded to external resources based on the host and the port which we are trying to access.

The `tunnel_pass` directive is a content handling directive (similar to `proxy_pass` or `grpc_pass`), and if specified for the `server` block, will not be inherited by corresponding `location` blocks. If you have a location that implements any other NGINX Plus capabilities within the forward proxy, you will need to enable the `tunnel_pass` for this `location` as well. See [Disabling other http methods](#disable-other-http-methods).

```nginx
server {
    listen 10.10.1.11:3128;

    tunnel_pass;
}
```

In this basic configuration, the client establishes a tunnel with NGINX Plus, sends the HTTP `CONNECT` method to the specified port `3128` which is standard for forward proxying, and if successful, responds with `200 OK`. The tunnel is established and the client can perform the TLS handshake and get the response.


## Disable other HTTP methods

As soon as the `CONNECT` method is enabled, all other methods such as `GET`, `POST` are not applicable in this mode. Rejecting them ensures that only tunnel requests are allowed thus improving security.

You can create a rule with the [`if`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#if) directive to deny all HTTP methods except CONNECT, If a client uses any other method, NGINX Plus returns the `403` error code:

```nginx
server {
    listen 10.10.1.11:3128;

    # Handle other methods
    location / {
        if ($request_method != CONNECT) {
            return 403 "Forbidden: allows only CONNECT method";
        }

    # allow CONNECT requests
    tunnel_pass;
    }
}
```

Note that in the example the [`tunnel_pass`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_pass) directive is specified inside the `location` block. Since `tunnel_pass` is a content handling directive, when it is specified for the `server` block, it is not inherited by nested locations.


## Enable logging 

For testing, debugging and monitoring purposes you can configure error and access logs.

1. At the `http` level, specify the [`log_format`](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) directive, give the log a name (for example, `http_connect`), and include the metrics:

   ```nginx
   log_format http_connect  '$remote_addr [$time_local] '
                            '$request_method $host:$request_port $status '
                            '$upstream_addr $bytes_sent $upstream_connect_time '
                            '$request_time "$http_user_agent"';
   ```

   See the [NGINX variables index](https://nginx.org/en/docs/varindex.html) for the list of all supported variables.

2. Specify the [`error_log`](https://nginx.org/en/docs/ngx_core_module.html#error_log) and [`access_log`](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) directives on the same configuration level where the [`tunnel_pass`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_pass) directive is defined:

   ```nginx
   access_log logs/connect_access.log http_connect;
   error_log  logs/connect_error.log;
   ```

3. Test the configuration. This example enables logging for the location block which denies all HTTP methods except `CONNECT` and where the `tunnel_pass` directive is specified:

   ```nginx
   log_format http_connect  '$remote_addr [$time_local] '
                            '$request_method $host:$request_port $status '
                            '$upstream_addr $bytes_sent $upstream_connect_time '
                            '$request_time "$http_user_agent"';
   server {
       listen 10.10.1.11:3128;

       location / {
           if ($request_method != CONNECT) {
               return 403 "Forbidden: allows only CONNECT method";
           }

       tunnel_pass;

       access_log logs/connect_access.log http_connect;
       error_log  logs/connect_error.log;
       }
   }
   ```

   A test request can be sent with the `curl` command:

   ```shell
   curl -v -x 10.10.1.11:3128 https://example.com
   ```
   The result of the command can be seen in the log (`200 OK`):
 
   ```none
   logs > connect_access.log
     1    10.10.1.240 [01/Dec/2025:10:46:27 +0000] CONNECT example.com:443 200 127.456.789.0:443 4275 0.014 0.258 "curl/8.7.1"
   ```

## Access control

It is highly recommended to restrict access to the proxy servers. Access control can be managed in several ways:

- by ports and port ranges with the [`num_map`](https://nginx.org/en/docs/http/ngx_http_num_map_module.html) module (NGINX Plus R36)
- by IP addresses with the [`geo`](https://nginx.org/en/docs/http/ngx_http_geo_module.html) module
- by hostnames with the [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html) module

All of these access methods can be used together and combined with the the [`proxy_allow_upstream`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_allow_upstream) directive (NGINX Plus R36).

### Restricting by ports and port ranges

The [`num_map`](https://nginx.org/en/docs/http/ngx_http_num_map_module.html) module introduced in NGINX Plus R36 allows defining ports and port ranges and uses the same approach as the `map` block. For example, if the value of the [`$request_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_port) variable is `443`, the `$allowed_port` variable is assigned the value `ssl`. It also restricts the allowed port range for the upstream connections or proxy requests:

```nginx
num_map $request_port $allowed_port {
    default    0;

    443        ssl;
    <=1023     less-eq;
    8080-8090  range;
    >8092      more;
}
```

### Restricting by IP addresses

Access by IP addresses can be restricted with the [`geo`](https://nginx.org/en/docs/http/ngx_http_geo_module.html) module:

```nginx
geo $allowed_networks {
        10.10.1.0/24  allow;
        10.20.11.0/24 allow;
        default       deny;
}
```

### Restricting by hostnames

Restriction by hostnames can be configured with the [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html) module, which works mainly with strings and regular expressions. Although it is possible to match port numbers using `map`, it is recommended to use the [`num_map`](https://nginx.org/en/docs/http/ngx_http_num_map_module.html) module for more port-based restrictions, as it provides additional functionality such as defining ranges. 

In this example, access is allowed to `example.com` and its subdomains only:

```nginx
map $host  $allowed_host {
    hostnames;
    default       0;
    example.com   1;
    *.example.com 1;
}
```

### Combining access control methods

These access methods can be combined in the [`tunnel_allow_upstream`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_allow_upstream) directive, which performs access checks when the upstream server to which the request will be sent is selected. If any variable passed to [`tunnel_allow_upstream`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_allow_upstream) evaluates to non-zero or non-empty value, it will be calculated as `1` and access is granted. If all variables evaluate to `0` or an empty value, access is denied.

### Access control example

```nginx
log_format connect_debug '$remote_addr [$time_local] '
                         '$request_method $host:$request_port $status '
                         '$upstream_addr $bytes_sent $upstream_connect_time '
                         '$request_time "$http_user_agent"';

num_map $request_port $allowed_port {
    default    0;

    443        ssl;
    <=1023     less-eq;
    8080-8090  range;
    >8092      more;
}

geo $allowed_networks {
        10.10.1.0/24  allow;
        10.20.11.0/24 allow;
        default       deny;
}

map $host  $allowed_host {
    hostnames;
    default     0;
    example.com   1;
    *.example.com 1;
}

server {
    listen 10.10.1.11:3128;

    #Allow CONNECT only to certain ports/nets/hosts
    tunnel_allow_upstream $allowed_networks $allowed_port $allowed_host;

    error_page 403;

    satisfy all;

    allow 10.10.0.0/16;
    allow 127.0.0.1;
    deny  all;

    tunnel_pass;

    location ^~ /errors/ {
        internal;
        root html;
        allow all;
    }

    access_log logs/connect_access.log connect_debug;
    error_log  logs/connect_debug.log debug;
}
```

Access can also be limited using other modules, for example with the [`satisfy`](https://nginx.org/en/docs/http/ngx_http_core_module.html#satisfy) directive, or the [`allow`/`deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow) directives.


## mTLS authenticaton

For proxy functionality, mutual mTLS authentication is supported:

```nginx
log_format http_connect  '$remote_addr [$time_local] '
                         '$request_method $host:$request_port $status '
                         '$upstream_addr $bytes_sent $upstream_connect_time '
                         '$request_time "$http_user_agent"';


map $ssl_client_verify $ssl_ok {
    default 0;
    SUCCESS 1;
}

map $host  $allowed_host {
    hostnames;
    default       0;
    example.com   1;
    *.example.com 1;
}

map "$ssl_ok:$allowed_host" $connect_ok {
    default 0;
    "1:0"   1;
    "1:1"   1;
    "0:1"   1;
}

server {
    listen 10.10.1.11:3128; ssl;

    ssl_certificate     tls/proxy.cert;
    ssl_certificate_key tls/proxy.key;

    ssl_client_certificate tls/ca.cert;
    ssl_verify_client      on;
    ssl_verify_depth       1;

    ssl_protocols             TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    tunnel_allow_upstream $connect_ok;

    tunnel_pass;

    access_log logs/connect_access.log http_connect;
    error_log  logs/connect_error.log;
}
```

