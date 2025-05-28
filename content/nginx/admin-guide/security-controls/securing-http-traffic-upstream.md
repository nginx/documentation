---
description: Secure HTTP traffic between NGINX or F5 NGINX Plus and upstream servers,
  using SSL/TLS encryption.
docs: DOCS-435
title: Securing HTTP Traffic to Upstream Servers
toc: true
weight: 900
type:
- how-to
---

This article explains how to encrypt HTTP traffic between NGINX and an upstream group or a proxied server.


## Prerequisites

- [NGINX Open Source](https://nginx.org/en/download.html) or [F5 NGINX Plus](https://nginx.com/products/)
- A [proxied server]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}}) or an [upstream group of servers]({{< ref "nginx/admin-guide/load-balancer/http-load-balancer.md" >}})
- SSL certificates and a private key

## Obtaining SSL Server Certificates

You can purchase a server certificate from a trusted certificate authority (CA). You can create own internal CA with an [OpenSSL](https://www.openssl.org/) library and generate your own certificate instead. The server certificate, along with a private key, should be placed on each upstream server.

<span id="client_certs"></span>
## Obtaining an SSL Client Certificate

NGINX will identify itself to the upstream servers with an SSL client certificate. A trusted CA must sign the client certificate, which is configured on NGINX together with the corresponding private key.

You will also need to configure the upstream servers to require client certificates for all incoming SSL connections, and to trust the CA that issued NGINX client certificate. Then, when NGINX connects to the upstream, it will provide its client certificate and the upstream server will accept it.

<span id="config"></span>
## Configuring NGINX

First, change the URL to an upstream group to support SSL connections. In the NGINX configuration file, specify the `https` protocol in the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive:

```nginx
location /upstream {
    proxy_pass https://backend.example.com;
}
```

Add the client certificate and the key that will be used to authenticate NGINX on each upstream server with [proxy_ssl_certificate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate) and [proxy_ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate_key) directives:

```nginx
location /upstream {
    proxy_pass                https://backend.example.com;
    proxy_ssl_certificate     /etc/nginx/client.pem;
    proxy_ssl_certificate_key /etc/nginx/client.key;
}
```

If you use a self-signed certificate for an upstream or your own CA, also include the [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_trusted_certificate). The file must be in the PEM format. Optionally, include the [proxy_ssl_verify](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify) and [proxy_ssl_verfiy_depth](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify_depth) directives to have NGINX check the validity of the security certificates:

```nginx
location /upstream {
    #...
    proxy_ssl_trusted_certificate /etc/nginx/trusted_ca_cert.crt;
    proxy_ssl_verify       on;
    proxy_ssl_verify_depth 2;
    #...
}
```

Each new SSL connection requires a full SSL handshake between the client and server, which is quite CPU-intensive. To have NGINX proxy previously negotiated connection parameters and use a so-called abbreviated handshake, include the [proxy_ssl_session_reuse](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_session_reuse) directive:

```nginx
location /upstream {
    #...
    proxy_ssl_session_reuse on;
    #...
}
```

Optionally, you can specify which SSL protocols and ciphers are used:

```nginx
location /upstream {
        #...
        proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_ciphers   HIGH:!aNULL:!MD5;
}
```

<span id="config_upstream"></span>
## Configuring Upstream Servers

Each upstream server should be configured to accept HTTPS connections. For each upstream server, specify a path to the server certificate and the private key with [ssl_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) and [ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key) directives:

```nginx
server {
    listen              443 ssl;
    server_name         backend1.example.com;

    ssl_certificate     /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/certs/server.key;
    #...
    location /yourapp {
        proxy_pass https://url_to_app.com;
        #...
    }
}
```

Specify the path to a client certificate with the [ssl_client_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_client_certificate) directive:

```nginx
server {
    #...
    ssl_client_certificate /etc/ssl/certs/ca.crt;
    ssl_verify_client      optional;
    #...
}
```

<span id="example"></span>
## Complete Example

```nginx
http {
    #...
    upstream backend.example.com {
        server backend1.example.com:443;
        server backend2.example.com:443;
   }

    server {
        listen      80;
        server_name www.example.com;
        #...

        location /upstream {
            proxy_pass                    https://backend.example.com;
            proxy_ssl_certificate         /etc/nginx/client.pem;
            proxy_ssl_certificate_key     /etc/nginx/client.key;
            proxy_ssl_protocols           TLSv1 TLSv1.1 TLSv1.2;
            proxy_ssl_ciphers             HIGH:!aNULL:!MD5;
            proxy_ssl_trusted_certificate /etc/nginx/trusted_ca_cert.crt;

            proxy_ssl_verify        on;
            proxy_ssl_verify_depth  2;
            proxy_ssl_session_reuse on;
        }
    }

    server {
        listen      443 ssl;
        server_name backend1.example.com;

        ssl_certificate        /etc/ssl/certs/server.crt;
        ssl_certificate_key    /etc/ssl/certs/server.key;
        ssl_client_certificate /etc/ssl/certs/ca.crt;
        ssl_verify_client      optional;

        location /yourapp {
            proxy_pass https://url_to_app.com;
        #...
        }

    server {
        listen      443 ssl;
        server_name backend2.example.com;

        ssl_certificate        /etc/ssl/certs/server.crt;
        ssl_certificate_key    /etc/ssl/certs/server.key;
        ssl_client_certificate /etc/ssl/certs/ca.crt;
        ssl_verify_client      optional;

        location /yourapp {
            proxy_pass https://url_to_app.com;
        #...
        }
    }
}
```

In this example, the “`https`” protocol in the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive specifies that the traffic forwarded by NGINX to upstream servers be secured.

When a secure connection is passed from NGINX to the upstream server for the first time, the full handshake process is performed:

- The [proxy_ssl_certificate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate) directive defines the location of the PEM-format certificate required by the upstream server.
- The [proxy_ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate_key) directive defines the location of the certificate’s private key.
- The [proxy_ssl_protocols](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_protocols and [proxy_ssl_ciphers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_ciphers) directives control which protocols and ciphers are used.

The next time NGINX passes a connection to the upstream server, session parameters will be reused because of the [proxy_ssl_session_reuse](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_session_reuse) directive, and the secured connection is established faster.

The trusted CA certificates in the file named by the [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_trusted_certificate) directive are used to verify the certificate on the upstream.
The [proxy_ssl_verify_depth](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify_depth) directive specifies that two certificates in the certificates chain are checked. 
The [proxy_ssl_verify](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify) directive verifies the validity of certificates.
