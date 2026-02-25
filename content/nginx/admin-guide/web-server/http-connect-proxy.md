---
description: HTTP traffic tunneling via the HTTP CONNECT method, enabling centralized egress control through a trusted NGINX Plus server.
nd-docs: DOCS-441
title: HTTP CONNECT forward proxy
toc: true
weight: 600
nd-content-type: how-to
nd-product: NGPLUS
---

In corporate networks, NGINX Plus R36 and later can be configured as a forward proxy server, facilitating client access to external resources. A forward proxy operates between internal clients and the global network, enabling centralized traffic control.

Unlike a reverse proxy that protects servers, upstreams, or services, forward proxy serves client requests and regulates their access to the external resources. To enable this functionality, the HTTP `CONNECT` method is used to establish a secure tunnel between the client and the proxy server (NGINX Plus). This tunnel permits the transmission of HTTPS traffic and other protocols, such as SSH or FTP, through the proxy.

## Enable HTTP CONNECT proxy

To enable the HTTP `CONNECT` forward proxy, add the [`tunnel_pass`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_pass) directive that turns on the forward proxy functionality within the `server` or `location` blocks.

The `tunnel_pass` directive can be used without any parameters. The default value is [`$host`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_host):[`$request_port`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_port) variables: all requests are automatically forwarded to external resources based on the host and the port which we are trying to access.

The `tunnel_pass` directive is a content handling directive (similar to `proxy_pass`), and if specified for the `server` block, will not be inherited by corresponding `location` blocks. If you have a location that implements any other NGINX Plus capabilities within the forward proxy, you will need to enable the `tunnel_pass` for this `location` as well. See [Disable other HTTP methods](#disable-other-http-methods).

```nginx
server {
    listen 10.10.1.11:3128;

    tunnel_pass;
}
```

In this basic configuration, the client establishes a tunnel with NGINX Plus, sends the HTTP `CONNECT` method to the specified port `3128` which is standard for forward proxying, and if successful, responds with `200 OK`. The tunnel is established and the client can perform the TLS handshake and get the response.


## Disable other HTTP methods

As soon as the `CONNECT` method is enabled, all other methods such as `GET`, `POST` are not applicable in this mode. Rejecting them ensures that only tunnel requests are allowed thus improving security.

You can create a rule with the [`if`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#if) directive to deny all HTTP methods except `CONNECT`, If a client uses any other method, NGINX Plus returns the `403` error code:

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

1. On the `http` level, specify the [`log_format`](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) directive, give the log a name (for example, `http_connect`), and include the metrics:

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

## Test the configuration

 This example sums up the steps above: it enables logging for the `location` block which denies all HTTP methods except `CONNECT` and where the `tunnel_pass` directive is specified:

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

1. Test nginx configuration for syntax validity and apply the configuration:

   ```nginx
   nginx -t && nginx -s reload
   ```

2. Send a test request with the `curl` command:

   ```shell
   curl -v -x 10.10.1.11:3128 https://example.com
   ```

3. Check the access log to see the result of the command: 

   ```shell
   tail -n 100 /logs/connect_access.log
   ```

   The result of the command:

   ```none
   logs > connect_access.log
     1    10.10.1.240 [01/Dec/2025:10:46:27 +0000] CONNECT example.com:443 200 127.456.789.0:443 4275 0.014 0.258 "curl/8.7.1"
   ```
   The result shows that the client (`10.10.1.240`) successfully established a connection (`200`) to the destination server (`example.com:443` resolved to `127.456.789.0:443`).


## Access control

It is highly recommended to restrict access to the proxy servers. Access control can be managed in several ways:

- by ports and port ranges with the [`num_map`](https://nginx.org/en/docs/http/ngx_http_num_map_module.html) module (NGINX Plus R36)
- by IP addresses with the [`geo`](https://nginx.org/en/docs/http/ngx_http_geo_module.html) module
- by hostnames with the [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html) module

All of these access methods can be used together and combined with the the [`proxy_allow_upstream`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_allow_upstream) directive (NGINX Plus R36).

### Restrict by ports and port ranges

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

### Restrict by IP addresses

Access by IP addresses can be restricted with the [`geo`](https://nginx.org/en/docs/http/ngx_http_geo_module.html) module:

```nginx
geo $allowed_networks {
        10.10.1.0/24  allow;
        10.20.11.0/24 allow;
        default       deny;
}
```

### Restrict by hostnames

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

### Combine access control methods

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
    default       0;
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
        root  html;
        allow all;
    }

    access_log logs/connect_access.log connect_debug;
    error_log  logs/connect_debug.log debug;
}
```

Access can also be limited using other modules, for example with the [`satisfy`](https://nginx.org/en/docs/http/ngx_http_core_module.html#satisfy) directive, or the [`allow`/`deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow) directives.


## mTLS authentication

Mutual TLS (mTLS) ensures that both the client and server authenticate each other by exchanging and validating trusted certificates. Once the authentication succeeds, a secure, encrypted connection is established.

For an HTTP CONNECT proxy, mutual TLS (mTLS) is currently the only supported authentication method. Other methods, such as [basic authentication](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html) are currently not supported because NGINX Plus processes only the `Authorization` header, not the `Proxy-Authorization` header.

To enable mTLS, you need:

- a server certificate and private key, used by NGINX Plus to authenticate itself to clients
- a client Certificate Authority (CA) certificate, used by NGINX Plus to verify client certificates
- one or more client certificates, signed by the trusted client CA, used by clients to authenticate to the proxy
- NGINX Plus configuration that enables TLS and enforces client certificates verification

Certificates can be created using tools such as OpenSSL or obtained from certificate providers such as Let's Encrypt.

### Configure mTLS

In your NGINX Plus configuration file:

1. Enable the TLS layer on proxy listener by adding the `ssl` parameter to the `listen` directive, port `3128` is a commonly used port for forward proxies:

   ```nginx
   listen 10.10.1.11:3128 ssl;
   #...
   ```

2. Specify the proxy server SSL certificate and private key (the certificate that NGINX Plus presents to clients):

   ```nginx
   #...
   ssl_certificate     /etc/ssl/certs/forward_proxy_server.crt;
   ssl_certificate_key /etc/ssl/certs/forward_proxy_server.key;
   #...
   ```

3. Configure client certificate verification. Specify the trusted Client CA certificate used to validate client certificates with the [`ssl_client_certificate`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_client_certificate) directive. With [`ssl_verify_client`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_verify_client) set to on, every client is required to present a valid certificate during the TLS handshake, otherwise the connection will be rejected:

   ```nginx
   #...
   ssl_client_certificate /etc/ssl/certs/forward_proxy_client_ca.crt;

   ssl_verify_client      on;
   ssl_verify_depth       1;

   ssl_protocols             TLSv1.2 TLSv1.3;
   ssl_prefer_server_ciphers on;
   #...
   ```

### Conditional forward proxy access based on mTLS

Based on the result of client certificate verification, you can implement different access policies.

This scenario enables conditional access: if a client provides a valid certificate, access is granted to all resources through the proxy. If not, access is limited to particular resources or blocked.

1. Set the [`ssl_verify_client`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_verify_client) directive value to `optional` to allow clients to connect with or without a client certificate, making conditional access possible:

   ```nginx
   #...
   ssl_client_certificate /etc/ssl/certs/forward_proxy_client_ca.crt;
   ssl_verify_client      optional;
   #...
   ```

2. Verify the status of the client certificate using the [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) block and the [`$ssl_client_verify`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#var_ssl_client_verify) variable. The result will be saved to the `$ssl_ok` variable:

   ```nginx
   map $ssl_client_verify $ssl_ok {
       default 0;
       SUCCESS 1;
   }
   ```

   In the `map` block, the value of the `$ssl_ok` variable depends on the status of [`$ssl_client_verify`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#var_ssl_client_verify) variable. If the result of client certificate verification is “SUCCESS”, the `$ssl_ok` variable gets the value `1`:

3. Check the hostname the client is going to access based on the `Host` header of the request (the [$host](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_host) variable). Access will be allowed only for `example.com` and its subdomains. The `hostnames` parameter of the [`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) directive is required to recognize hostnames and wildcards in the hostnames: 

   ```nginx
   map $host  $allowed_host {
       hostnames;
       default       0;
       example.com   1;
       *.example.com 1;
   }
   ```

4. Define access rules by combining the results of client certificate verification (`$ssl_ok`) and hostname validation (`$allowed_host`). To allow access to all websites, the client must present a valid client certificate. If no client certificate is provided, access is restricted to `example.com` and its subdomains. The result is stored in the `$connect_ok` variable:

   ```nginx
   map "$ssl_ok:$allowed_host" $connect_ok {
       default 0;
       "1:0"   1;
       "1:1"   1;
       "0:1"   1;
   }
   ```

5. Restrict upstream connections to valid `CONNECT` requests using the [`tunnel_allow_upstream`](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html#tunnel_allow_upstream) directive based on the result in the `$connect_ok` variable:

    ```nginx
      tunnel_allow_upstream $connect_ok;
      tunnel_pass;
    ```

### Complete example

This configuration sums up the steps and enables authorization based on client certificate verification result. Clients with valid client certificates are granted full access through the proxy. Clients without a certificate are restricted to `example.com` and its subdomains, all other `CONNECT` requests are denied.

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
    listen 10.10.1.11:3128 ssl;

    ssl_certificate     /etc/ssl/certs/forward_proxy_server.crt;
    ssl_certificate_key /etc/ssl/certs/forward_proxy_server.key;

    ssl_client_certificate /etc/ssl/certs/forward_proxy_client_ca.crt;
    ssl_verify_client      optional;
    ssl_verify_depth       1;

    ssl_protocols             TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    tunnel_allow_upstream $connect_ok;
    tunnel_pass;

    access_log logs/connect_access.log http_connect;
    error_log  logs/connect_error.log;
}
```

The first `map` block checks if the client passed the mTLS verification. It sets the `$ssl_ok` variable to `1` if NGINX Plus successfully verified the client certificate during the TLS handshake, and to `0` otherwise.

The second `map` block checks if the requested host is allowlisted: if the `CONNECT` target hostname is `example.com` or any of its subdomains, the `$allowed_host` variable is set to `1` and to `0` otherwise.

The third `map` block builds the final decision variable, `$connect_ok`. Its result will be evaluated by the `tunnel_allow_upstream` directive: if it has a non-empty value, access will be granted, with restrictions above implemented. If the client cert is valid (`$ssl_ok`=`1`), access is allowed regardless of host. If the client cert is not valid (`$ssl_ok`=`0`), access is allowed only if the host is allowlisted. Otherwise access is denied (default is `0`).

The [`ssl_verify_client`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_verify_client) directive is set to `optional` which allows clients to connect with or without client certificate, making conditional access possible.

#### Testing

1. Test the nginx configuration for syntax validity and apply the configuration:

   ```nginx
   nginx -t && \
   nginx -s reload
   ```

2. Test the proxy authentication layer for requests to verify that the proxy is protected as expected under different scenarios.

   - Client certificate is not provided:

     ```shell
     curl -v -x https://myproxy:3128    \
                https://www.example.com \
                --proxy-cacert ./conf/tls/ca.crt
     ```
     where:

     - `myproxy:3128` is the proxy address and port
     - `https://www.example.com` is the destination URL requested through the proxy
     -  `--proxy-cacert ./conf/tls/ca.crt` - the CA used to verify the proxy’s server certificate.

     Expected result: requests to `example.com` and its subdomains succeed (for example, `301 Moved Permanently`), requests to other domains are denied (for example, `502 Bad Gateway`).


   - Correct client certificate is provided (the `--proxy-cert` and `--proxy-key` parameters):

     ```shell
     curl -v -x https://myproxy:3128    \
                https://www.example.com \
                --proxy-cert ./conf/tls/client.crt \
                --proxy-key ./conf/tls/client.key  \
                --proxy-cacert ./conf/tls/ca.crt
     ```
     For requests to all resources, the request should succeed (for example, `301 Moved Permanently`).

## See also

- [Secure and harden forward proxies in NGINX Plus](https://community.f5.com/kb/technicalarticles/secure-and-harden-forward-proxies-in-nginx-plus/344989)

- [F5 NGINX Plus R36 release blogpost](https://community.f5.com/kb/technicalarticles/f5-nginx-plus-r36-release-now-available/344514)

- [`ngx_http_tunnel_module` module reference](https://nginx.org/en/docs/http/ngx_http_tunnel_module.html)
