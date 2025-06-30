---
description: Terminate HTTPS traffic from clients, relieving your upstream web and
  application servers of the computational load of SSL/TLS encryption.
nd-docs: DOCS-437
title: NGINX SSL Termination
toc: true
weight: 100
type:
- how-to
---

This section describes how to configure an HTTPS server on NGINX and F5 NGINX Plus.

## Setting up an HTTPS Server {#setup}

To set up an HTTPS server, in your **nginx.conf** file include the `ssl` parameter to the [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive in the [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block, then specify the locations of the server certificate and private key files:

```nginx
server {
    listen              443 ssl;
    server_name         www.example.com;
    ssl_certificate     www.example.com.crt;
    ssl_certificate_key www.example.com.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    #...
}
```

The server certificate is a public entity. It is sent to every client that connects to the NGINX or NGINX Plus server. The private key is a secure entity and should be stored in a file with restricted access. However, the NGINX master process must be able to read this file. Alternatively, the private key can be stored in the same file as the certificate:

```nginx
ssl_certificate     www.example.com.cert;
ssl_certificate_key www.example.com.cert;
```

In this case it is important to restrict access to the file. Note that although the certificate and the key are stored in one file in this case, only the certificate is sent to clients.

The [`ssl_protocols`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) and [`ssl_ciphers`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers ) directives can be used to require that clients use only the strong versions and ciphers of SSL/TLS when establishing connections.

Since version 1.23.4, NGINX uses these defaults:

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers   HIGH:!aNULL:!MD5;
```

Vulnerabilities are sometimes found in the design of older ciphers, and we recommend disabling them in a modern NGINX configuration (unfortunately, the default configuration cannot easily be changed because of backward compatibility for existing NGINX deployments). Please note that CBC-mode ciphers might be vulnerable to a number of attacks (the BEAST attack in particular as described in  [CVE-2011-3389](https://nvd.nist.gov/vuln/detail/CVE-2011-3389)), and we recommend not using SSLv3 due to the [POODLE](https://nvd.nist.gov/vuln/detail/CVE-2014-3566) attack, unless you need to support legacy clients.


### OCSP Validation of Client Certificates {#setup_ocsp}

NGINX can be configured to use Online Certificate Status Protocol (OCSP) to check the validity of X.509 client certificates as they are presented. An OCSP request for the client certificate status is sent to an OCSP responder which checks the certificate validity and returns the response with the certificate status:

- `Good` - the certificate is not revoked
- `Revoked` - the certificate is revoked
- `Unknown` - no information is available about the client certificate

To enable OCSP validation of SSL client certificates, specify the [`ssl_ocsp`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ocsp) directive along with the [`ssl_verify_client`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_verify_client) directive, which enables certificate verification:

```nginx
server {
    listen 443 ssl;

    ssl_certificate     /etc/ssl/foo.example.com.crt;
    ssl_certificate_key /etc/ssl/foo.example.com.key;

    ssl_verify_client       on;
    ssl_trusted_certificate /etc/ssl/cachain.pem;
    ssl_ocsp                on; # Enable OCSP validation

    #...
}
```

NGINX sends the OCSP request to the OCSP URI embedded in the client certificate unless a different URI is defined with the [`ssl_ocsp_responder`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ocsp_responder) directive. Only `http://` OCSP responders are supported:

```nginx
#...
ssl_ocsp_responder http://ocsp.example.com/;
#...
```

To cache OCSP responses in a single memory zone shared by all worker processes, specify the [`ssl_ocsp_cache`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ocsp_cache) directive to define the name and size of the zone. Responses are cached for `1` hour unless the `nextUpdate`value in the OCSP response specifies a different value:

```nginx
#...
ssl_ocsp_cache shared:one:10m;
#...
```

The result of the client certificate validation is available in the [`$ssl_client_verify`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#var_ssl_client_verify) variable, including the reason for OCSP failure.


## HTTPS Server Optimization {#optimize}

SSL operations consume extra CPU resources. The most CPU-intensive operation is the SSL handshake. There are two ways to minimize the number of these operations per client:

- Enabling keepalive connections to send several requests via one connection
- Reusing SSL session parameters to avoid SSL handshakes for parallel and subsequent connections

Sessions are stored in the SSL session cache shared between worker processes and configured by the [`ssl_session_cache`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache) directive. One megabyte of cache contains about 4000 sessions. The default cache timeout is `5` minutes. This timeout can be increased using the [`ssl_session_timeout`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_timeout) directive. Below is a sample configuration optimized for a multi-core system with 10 megabyte shared session cache:

```nginx
worker_processes auto;

http {
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    server {
        listen              443 ssl;
        server_name         www.example.com;
        keepalive_timeout   70;

        ssl_certificate     www.example.com.crt;
        ssl_certificate_key www.example.com.key;
        ssl_protocols       TLSv1.2 TLSv1.3;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        #...
    }
}
```

## SSL Certificate Chains {#cert_chains}

Some browsers may complain about a certificate signed by a well-known certificate authority, while other browsers may accept the certificate without issues. This occurs because the issuing authority has signed the server certificate using an intermediate certificate that is not present in the base of well-known trusted certificate authorities which is distributed in a particular browser. In this case the authority provides a bundle of chained certificates that should be concatenated to the signed server certificate. The server certificate must appear before the chained certificates in the combined file:

```shell
cat www.example.com.crt bundle.crt > www.example.com.chained.crt
```

The resulting file should be used in the [`ssl_certificate`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) directive:

```nginx
server {
    listen              443 ssl;
    server_name         www.example.com;
    ssl_certificate     www.example.com.chained.crt;
    ssl_certificate_key www.example.com.key;
    #...
}
```

If the server certificate and the bundle have been concatenated in the wrong order, NGINX fails to start and displays the following error message:

```none
SSL_CTX_use_PrivateKey_file(" ... /www.example.com.key") failed
   (SSL: error:0B080074:x509 certificate routines:
    X509_check_private_key:key values mismatch)
```

The error happens because NGINX has tried to use the private key with the bundle’s first certificate instead of the server certificate.

Browsers usually store intermediate certificates which they receive and are signed by trusted authorities. So actively used browsers may already have the required intermediate certificates and may not complain about a certificate sent without a chained bundle. To ensure the server sends the complete certificate chain the openssl command-line utility may be used:

```shell
openssl s_client -connect www.godaddy.com:443
...
Certificate chain
 0 s:/C=US/ST=Arizona/L=Scottsdale/1.3.6.1.4.1.311.60.2.1.3=US
     /1.3.6.1.4.1.311.60.2.1.2=AZ/O=GoDaddy.com, Inc
     /OU=MIS Department/CN=www.GoDaddy.com
     /serialNumber=0796928-7/2.5.4.15=V1.0, Clause 5.(b)
   i:/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com, Inc.
     /OU=http://certificates.godaddy.com/repository
     /CN=Go Daddy Secure Certification Authority
     /serialNumber=07969287
 1 s:/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com, Inc.
     /OU=http://certificates.godaddy.com/repository
     /CN=Go Daddy Secure Certification Authority
     /serialNumber=07969287
   i:/C=US/O=The Go Daddy Group, Inc.
     /OU=Go Daddy Class 2 Certification Authority
 2 s:/C=US/O=The Go Daddy Group, Inc.
     /OU=Go Daddy Class 2 Certification Authority
   i:/L=ValiCert Validation Network/O=ValiCert, Inc.
     /OU=ValiCert Class 2 Policy Validation Authority
     /CN=http://www.valicert.com//emailAddress=info@valicert.com
...
```

In this example the subject (“`s`”) of the `www.GoDaddy.com` server certificate `#0` is signed by an issuer (`“i”`) which itself is the subject of certificate #1. Certificate #1 is signed by an issuer which itself is the subject of certificate #2. This certificate, however, is signed by the well‑known issuer `ValiCert, Inc.` whose certificate is stored in the browsers themselves.

If a certificate bundle has not been added, only the server certificate (#0) is shown.

## A Single HTTP/HTTPS Server {#single}

It is possible to configure a single server that handles both HTTP and HTTPS requests by placing one `listen` directive with the `ssl` parameter and one without in the same virtual server:

```nginx
server {
    listen              80;
    listen              443 ssl;
    server_name         www.example.com;
    ssl_certificate     www.example.com.crt;
    ssl_certificate_key www.example.com.key;
    #...
}
```

In NGINX version 0.7.13 and earlier, SSL cannot be enabled selectively for individual listening sockets, as shown above. SSL can only be enabled for the entire server using the [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive, making it impossible to set up a single HTTP/HTTPS server. The `ssl` parameter to the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive was added to solve this issue. The [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive therefore is deprecated in version 0.7.14 and later.


## Name-Based HTTPS Servers {#name}

A common issue arises when two or more HTTPS servers are configured to listen on a single IP address:

```nginx
server {
    listen          443 ssl;
    server_name     www.example.com;
    ssl_certificate www.example.com.crt;
    #...
}

server {
    listen          443 ssl;
    server_name     www.example.org;
    ssl_certificate www.example.org.crt;
    #...
}
```

With this configuration, a browser receives the default server’s certificate. In this case, it is `www.example.com` regardless of the requested server name. This is caused by the behavior of the SSL protocol itself. The SSL connection is established before the browser sends an HTTP request and NGINX does not know the name of the requested server. Therefore, it may only offer the default server’s certificate.

The best way to solve this issue is to assign a separate IP address to every HTTPS server:

```nginx
server {
    listen          192.168.1.1:443 ssl;
    server_name     www.example.com;
    ssl_certificate www.example.com.crt;
    #...
}

server {
    listen          192.168.1.2:443 ssl;
    server_name     www.example.org;
    ssl_certificate www.example.org.crt;
    #...
}
```

Note that there are also some specific proxy settings for HTTPS upstreams ([`proxy_ssl_ciphers`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_ciphers), [`proxy_ssl_protocols`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_protocols), and [`proxy_ssl_session_reuse`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_session_reuse)) which can be used for fine‑tuning SSL between NGINX and upstream servers. You can read more about these in the [HTTP proxy module documentation](https://nginx.org/en/docs/http/ngx_http_proxy_module.html).

### An SSL Certificate With Several Names

There are other ways to share a single IP address among several HTTPS servers. However, all of them have drawbacks. One way is to use a certificate with several names in the `SubjectAltName` certificate field, for example, `www.example.com` and `www.example.org`. However, the length of the `SubjectAltName` field is limited.

Another way is to use a certificate with a wildcard name, for example, `*.example.org`. A wildcard certificate secures all subdomains of the specified domain, but only on one level. This certificate matches `www.example.org`, but does not match `example.org` or `www.sub.example.org`. These two methods can also be combined. A certificate may contain exact and wildcard names in the `SubjectAltName` field. For example, `example.org` and `*.example.org`.

It is better to place a certificate file with several names and its private key file at the http level of your configuration so that they inherit the single memory copy across all servers:

```nginx
ssl_certificate     common.crt;
ssl_certificate_key common.key;

server {
    listen          443 ssl;
    server_name     www.example.com;
    #...
}

server {
    listen          443 ssl;
    server_name     www.example.org;
    #...
}
```

### Server Name Indication

A more generic solution for running several HTTPS servers on a single IP address is the [TLS Server Name Indication](https://en.wikipedia.org/wiki/Server_Name_Indication) (SNI) extension ([RFC 6066](https://tools.ietf.org/html/rfc6066)), which allows a browser to pass a requested server name during the SSL handshake. With this solution, the server will know which certificate it should use for the connection. Although SNI is widely supported by modern browsers, some old browsers may still not include support for it. Major browsers support SNI starting with the following versions:

- Chrome 105 (Windows version supports SNI on Vista or higher, too)
- Firefox 2.0 and other browsers using Mozilla Platform rv:1.8.1
- Microsoft Internet Explorer 7.0 (but only on Windows Vista or higher)
- Opera 8.0
- Safari 3.2.1 (Windows version supports SNI on Vista or higher)

Only domain names can be passed in SNI. However, some browsers will pass the IP address of the server as its name if a request includes a literal IP address. It is best not to rely on this.

In order to use SNI in NGINX, it must be supported in both the OpenSSL library with which the NGINX binary has been built, as well as the library with which it is being dynamically linked at runtime. OpenSSL supports SNI since the version 0.9.8f if it was built with configuration `option --enable-tlsext`. Since OpenSSL version 0.9.8j, this option is enabled by default. If NGINX was built with SNI support, NGINX shows the following when run with the `-V` switch:

```shell
nginx -V
...
TLS SNI support enabled
...
```

However, if the SNI-enabled NGINX is linked dynamically to an OpenSSL library without SNI support, NGINX displays the warning:

```none
NGINX was built with SNI support, however, now it is linked
dynamically to an OpenSSL library which has no tlsext support,
therefore SNI is not available
```

## Compatibility Notes

- The SNI support status has been shown by the `-V` switch since versions 0.8.21 and 0.7.62.

- The `ssl` parameter of the [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive has been supported since version 0.7.14. Prior to version 0.8.21 it could only be specified along with the `default` parameter.

- SNI has been supported since version 0.5.23.

- The shared SSL session cache has been supported since version 0.5.6.

### SSL protocols

 - Version 1.27.3 and later: the default SSL protocols are `TLSv1.2` and `TLSv1.3` (if supported by the OpenSSL library). Otherwise, when OpenSSL 1.0.0 or older is used, the default SSL protocols are `TLSv1` and `TLSv1.1`.

- Version 1.23.4 and later: the default SSL protocols are `TLSv1`, `TLSv1.1`, `TLSv1.2`, and `TLSv1.3` (if supported by the OpenSSL library).

- Version 1.9.1 and later: the default SSL protocols are `TLSv1`, `TLSv1.1`, and `TLSv1.2` (if supported by the OpenSSL library).

- From versions 0.7.65 and 0.8.19 and later, the default SSL protocols are `SSLv3`, `TLSv1`, `TLSv1.1`, and `TLSv1.2` (if supported by the OpenSSL library).

- In versions 0.7.64 and 0.8.18 and earlier, the default SSL protocols are `SSLv2`, `SSLv3`, and `TLSv1`.

### SSL ciphers

- In version 1.0.5 and later, the default SSL ciphers are `HIGH:!aNULL:!MD5`.

- In versions 0.7.65 and 0.8.20 and later, the default SSL ciphers are `HIGH:!ADH:!MD5`.

- From version 0.8.19 the default SSL ciphers are `ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM`.

- From version 0.7.64, 0.8.18 and earlier the default SSL ciphers are `ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP`.
