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

This article explains how to secure TCP traffic between NGINX and an upstream TCP server or group of upstream TCP servers.

## Prerequisites

- F5 NGINX Plus [R6]({{< ref "nginx/releases.md" >}}) or later, or the latest NGINX Open Source compiled with the `--with-stream` and `with-stream_ssl_module` configuration parameters
- A proxied TCP server or an [upstream group of TCP servers]({{< ref "nginx/admin-guide/load-balancer/tcp-udp-load-balancer.md" >}})
- SSL certificates and a private key

## Obtaining SSL Server Certificates

First, obtain SSL server certificates and a private key. Obtain an SSL server certificate from a trusted certificate authority (CA). Alternatively, generate one using an SSL library such as [OpenSSL](http://www.openssl.org/). Place the server certificates and private key on each of the upstream servers. 

Self-signed server certificates encrypt the connection between NGINX and the upstream server. However, these connections are vulnerable to a man-in-the-middle attack. (If an imposter impersonates the upstream server, NGINX will not know it is talking to a fake server.) To lessen the risk, obtain server certificates signed by a trusted CA. (You can create your own internal CA using OpenSSL.) Afterward, configure NGINX to only trust certificates signed by that CA. This makes it much more difficult for an attacker to impersonate an upstream server.

## Obtaining an SSL Client Certificate

NGINX can identify itself to the upstream servers using an SSL client certificate. A trusted CA must sign this client certificate. It must be stored on NGINX along with the corresponding private key.

Configure the upstream servers to require client certificates for all incoming SSL connections and trust the CA that issued the client certificate to NGINX. By doing so, NGINX provides its client certificate when it connects to an upstream server, and the server will accept the certificate.

## Configuring NGINX

Open the NGINX configuration file. Then, include the [proxy_ssl](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl) directive in the `server` block on the `stream` level:

```nginx
stream {
    server {
        ...
        proxy_pass backend;
        proxy_ssl  on;
    }
}
```

Specify the path to the SSL client certificate required by the upstream server. Also, specify the certificate’s private key:

```nginx
server {
        ...
        proxy_ssl_certificate     /etc/ssl/certs/backend.crt;
        proxy_ssl_certificate_key /etc/ssl/certs/backend.key;
}
```

Optionally, specify which SSL protocols and ciphers to use:

```nginx
server {
        ...
        proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_ciphers   HIGH:!aNULL:!MD5;
}
```

The [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_trusted_certificate) directive specifies the file containing the trusted CA certificates. These trusted certificates are used to validate the upstream server’s security certificates. The file must be in PEM format. Optionally, include the [proxy_ssl_verify](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify) and [proxy_ssl_verfiy_depth](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify_depth) directives so NGINX vaidates the security certificates:

```nginx
server {
    ...
    proxy_ssl_trusted_certificate /etc/ssl/certs/trusted_ca_cert.crt;
    proxy_ssl_verify       on;
    proxy_ssl_verify_depth 2;
}
```

New SSL connections require a full SSL handshake between the client and server. This is quite CPU-intensive. NGINX can proxy previously negotiated connection parameters and use a so-called abbreviated handshake. This lessens the CPU load for new SSL connections. To enable this, include the [proxy_ssl_session_reuse](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_session_reuse) directive:

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

In this example, the [proxy_ssl](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl) directive specifies to secure the TCP traffic NGINX forwards to upstream servers.

A full handshake occurs when NGINX first secures a TCP connection to an upstream server. The upstream server asks NGINX to present a security certificate specified in the [proxy_ssl_certificate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_certificate) directive. The [proxy_ssl_protocols](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_protocols) and [proxy_ssl_ciphers](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_ciphers) directives specify the respective protocols and ciphers.

The [proxy_ssl_session_reuse](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_session_reuse) directive causes subsequent upstream connections to reuse the session parameters. This makes establishing a secured TCP connection faster.

The [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_trusted_certificate) directive names a file containing trusted CA certificates. Use these certificates to verify the certificate on the upstream server. The [proxy_ssl_verify_depth](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify_depth) directive specifies to check two certificates in the certificates chain. The [proxy_ssl_verify](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify) directive verifies the validity of certificates.

To learn more about NGINX Plus, please see our [commercial subscriptions](https://nginx.com/products/).