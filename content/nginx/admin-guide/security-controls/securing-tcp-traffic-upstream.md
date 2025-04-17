---
description: Secure TCP traffic between NGINX or F5 F5 NGINX Plus and upstream servers,
  using SSL/TLS encryption.
docs: DOCS-436
title: Securing TCP Traffic to Upstream Servers
toc: true
weight: 1000
type:
- how-to
---

This article explains how to secure TCP traffic between NGINX and a TCP upstream server or an upstream group of TCP servers.

## Prerequisites

- F5 NGINX Plus [R6]({{< ref "nginx/releases.md" >}}) and later or the latest NGINX Open Source compiled with the `--with-stream` and `with-stream_ssl_module` configuration parameters
- A proxied TCP server or an [upstream group of TCP servers]({{< ref "nginx/admin-guide/load-balancer/tcp-udp-load-balancer.md" >}})
- SSL certificates and a private key

## Obtaining SSL Server Certificates

First, you will need to get server certificates and a private key and put them on the upstream server or on each server in the upstream group. A certificate can be obtained from a trusted certificate authority (CA) or generated using an SSL library such as [OpenSSL](http://www.openssl.org/).

Self-signed server certificates are used when you need to encrypt the connection between NGINX and the upstream server. However, these connections are vulnerable to a man-in-the-middle attack: an imposter can impersonate the upstream server and NGINX will not know it is talking to a fake server. If you obtain server certificates that have been signed by a trusted CA (you can create your own internal CA using OpenSSL), you can then configure NGINX to only trust certificates that have been signed by that CA. This makes it much more difficult for an attacker to impersonate an upstream server.

## Obtaining an SSL Client Certificate

NGINX can identify itself to the upstream servers by using an SSL Client Certificate. This client certificate must be signed by a trusted CA and stored on NGINX along with the corresponding private key.

You will need to configure the upstream servers to require client certificates for all incoming SSL connections and to trust the CA that issued the client certificate to NGINX. Then, when NGINX connects to the upstream, it will provide its client certificate and the upstream server will accept it.

## Configuring NGINX

In the NGINX configuration file, include the [proxy_ssl](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl) directive in the `server` block on the `stream` level:

```nginx
stream {
    server {
        ...
        proxy_pass backend;
        proxy_ssl  on;
    }
}
```

Then specify the path to the SSL client certificate required by the upstream server and the certificate’s private key:

```nginx
server {
        ...
        proxy_ssl_certificate     /etc/ssl/certs/backend.crt;
        proxy_ssl_certificate_key /etc/ssl/certs/backend.key;
}
```

Optionally, you can specify which SSL protocols and ciphers are used:

```nginx
server {
        ...
        proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_ciphers   HIGH:!aNULL:!MD5;
}
```

If you use certificates issued by a CA, also include the [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_trusted_certificate) directive to name the file containing the trusted CA certificates used to verify the upstream’s security certificates. The file must be in the PEM format. Optionally, include the [proxy_ssl_verify](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify) and [proxy_ssl_verfiy_depth](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify_depth) directives to have NGINX check the validity of the security certificates:

```nginx
server {
    ...
    proxy_ssl_trusted_certificate /etc/ssl/certs/trusted_ca_cert.crt;
    proxy_ssl_verify       on;
    proxy_ssl_verify_depth 2;
}
```

Each new SSL connection requires a full SSL handshake between the client and server, which is quite CPU-intensive. To have NGINX proxy previously negotiated connection parameters and use a so-called abbreviated handshake, include the [proxy_ssl_session_reuse](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_session_reuse) directive:

```nginx
proxy_ssl_session_reuse on;
```

## Complete Example

```nginx
stream {

    upstream backend {
        server backend1.example.com:12345;
        server backend2.example.com:12345;
        server backend3.example.com:12345;
   }

    server {
        listen     12345;
        proxy_pass backend;
        proxy_ssl  on;

        proxy_ssl_certificate         /etc/ssl/certs/backend.crt;
        proxy_ssl_certificate_key     /etc/ssl/certs/backend.key;
        proxy_ssl_protocols           TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_ciphers             HIGH:!aNULL:!MD5;
        proxy_ssl_trusted_certificate /etc/ssl/certs/trusted_ca_cert.crt;

        proxy_ssl_verify        on;
        proxy_ssl_verify_depth  2;
        proxy_ssl_session_reuse on;
    }
}
```

In this example, the [proxy_ssl](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl) directive specifies that TCP traffic forwarded by NGINX to upstream servers be secured.

When a secure TCP connection is passed from NGINX to the upstream server for the first time, the full handshake process is performed. The upstream server asks NGINX to present a security certificate specified in the [proxy_ssl_certificate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_certificate) directive. The [proxy_ssl_protocols](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_protocols) and [proxy_ssl_ciphers](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_ciphers) directives control which protocols and ciphers are used.

The next time NGINX passes a connection to the upstream, session parameters will be reused because of the [proxy_ssl_session_reuse](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_session_reuse) directive, and the secured TCP connection is established faster.

The trusted CA certificates in the file named by the [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_trusted_certificate) directive are used to verify the certificate on the upstream server. The [proxy_ssl_verify_depth](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify_depth) directive specifies that two certificates in the certificates chain are checked, and the [proxy_ssl_verify](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify) directive verifies the validity of certificates.

To learn more about NGINX Plus, please see our [commercial subscriptions](https://nginx.com/products/).
