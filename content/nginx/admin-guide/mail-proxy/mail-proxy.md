---
description: Simplify your email service and improve its performance with NGINX or
  F5 NGINX Plus as a proxy for the IMAP, POP3, and SMTP protocols
nd-docs: DOCS-423
title: Configure NGINX as a Mail Proxy Server
toc: true
weight: 100
type:
- how-to
---

This article will explain how to configure F5 NGINX Plus or NGINX Open Source as a proxy for a mail server or an external mail service.

## Introduction

NGINX can proxy IMAP, POP3 and SMTP protocols to one of the upstream mail servers that host mail accounts and thus can be used as a single endpoint for email clients. This may bring in a number of benefits, such as:

- easy scaling the number of mail servers
- choosing a mail server basing on different rules, for example, choosing the nearest server basing on a client’s IP address
- distributing the load among mail servers

<span id="prerequisites"></span>
## Prerequisites

- NGINX Plus (already includes the Mail modules necessary to proxy email traffic) or NGINX Open Source compiled the Mail modules using the `--with-mail` parameter for email proxy functionality and `--with-mail_ssl_module` parameter for SSL/TLS support:

    ```shell
    ./configure --with-mail --with-mail_ssl_module --with-openssl=[DIR]/openssl-1.1.1
    ```

- IMAP, POP3 and/or SMTP mail servers or an external mail service

<span id="mail_conf"></span>
## Configuring SMTP/IMAP/POP3 Mail Proxy Servers

In the NGINX configuration file:

1. Create a top-level [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail) context (is defined at the same level as the [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context):

    ```nginx
    mail {
        #...
    }
    ```

2. Specify the name for your mail server with the [server_name](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#server_name) directive:

    ```nginx
    mail {
       server_name mail.example.com;
        #...
    }
    ```

3. Specify the HTTP authentication server with the [auth_http](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#auth_http) directive. The authentication server will authenticate email clients, choose an upstream server for email processing, and report errors. See [Setting up Authentication for a Mail Proxy](#mail_auth).

    ```nginx
    mail {
        server_name mail.example.com;
        auth_http   localhost:9000/cgi-bin/nginxauth.cgi;
        #...
    }
    ```

4. Alternatively, specify whether to inform a user about errors from the authentication server by specifying the [proxy_pass_error_message](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_pass_error_message) directive. This may be handy when a mailbox runs out of memory:

    ```nginx
    mail {
        server_name mail.example.com;
        auth_http   localhost:9000/cgi-bin/nginxauth.cgi;

        proxy_pass_error_message on;
        #...
    }
    ```

5. Configure each SMTP, IMAP, or POP3 server with the [server](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#server) blocks. For each server, specify:
    - the _port number_ that correspond to the specified protocol with the [listen](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#listen) directive
    - the _protocol_ with the [protocol](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#protocol) directive (if not specified, will be automatically detected from the port specified in the [listen](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#listen) directive)
    - permitted _authentication methods_ with [imap_auth](https://nginx.org/en/docs/mail/ngx_mail_imap_module.html#imap_auth), [pop3_auth](https://nginx.org/en/docs/mail/ngx_mail_pop3_module.html#pop3_auth), and [smtp_auth](https://nginx.org/en/docs/mail/ngx_mail_smtp_module.html#smtp_auth) directives:

    ```nginx
    server {
        listen    25;
        protocol  smtp;
        smtp_auth login plain cram-md5;
    }

    server {
        listen    110;
        protocol  pop3;
        pop3_auth plain apop cram-md5;
    }

    server {
        listen   143;
        protocol imap;
    }
    ```

<span id="mail_auth"></span>
## Setting up Authentication for a Mail Proxy

Each POP3/IMAP/SMTP request from the client will be first authenticated on an external HTTP authentication server or by an authentication script. Having an authentication server is obligatory for NGINX mail server proxy. The server can be created by yourself in accordance with the [NGINX authentication protocol](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#protocol) which is based on the HTTP protocol.

If authentication is successful, the authentication server will choose an upstream server and redirect the request. In this case, the response from the server will contain the following lines:

```shell
HTTP/1.0 200 OK
Auth-Status: OK
Auth-Server: <host> # the server name or IP address of the upstream server that will used for mail processing
Auth-Port: <port> # the port of the upstream server
```

If authentication fails, the authentication server will return an error message. In this case, the response from the server will contain the following lines:

```shell
HTTP/1.0 200 OK
Auth-Status: <message> # an error message to be returned to the client, for example “Invalid login or password”
Auth-Wait: <number> # the number of remaining authentication attempts until the connection is closed
```

Note that in both cases the response will contain _HTTP/1.0 200 OK_ which might be confusing.

For more examples of requests to and responses from the authentication server, see the [ngx_mail_auth_http_module](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#protocol) in [NGINX Reference documentation](https://nginx.org/en/docs/).

<span id="mail_ssl"></span>
## Setting up SSL/TLS for a Mail Proxy

Using POP3/SMTP/IMAP over SSL/TLS you make sure that data passed between a client and a mail server are secured.

To enable SSL/TLS for the mail proxy:

1. Make sure your NGINX is configured with SSL/TLS support by typing-in the `nginx -V` command in the command line and then looking for the `with --mail_ssl_module` line in the output:

    ```shell
    $ nginx -V
    configure arguments: ... with--mail_ssl_module
    ```

2. Make sure you have obtained server certificates and a private key and put them on the server. A certificate can be obtained from a trusted certificate authority (CA) or generated using an SSL library such as OpenSSL.
3. Enable SSL/TLS for mail proxy with the [ssl](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl) directive. If the directive is specified in the [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail) context, SSL/TLS will be enabled for all mail proxy servers. You can also enable STLS and STARTTLS with the [starttls](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#starttls) directive:

    ```nginx
    ssl on;
    ```

    or

    ```nginx
    starttls on;
    ```

4. Add SSL certificates: specify the path to the certificates (which must be in the PEM format) with the [ssl_certificate](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_certificate) directive, and specify the path to the private key in the [ssl_certificate_key](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_certificate_key) directive:

    ```nginx
    mail {
        #...
        ssl_certificate     /etc/ssl/certs/server.crt;
        ssl_certificate_key /etc/ssl/certs/server.key;
    }
    ```

5. You can use only strong versions and ciphers of SSL/TLS with the [ssl_protocols](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_protocols) and [ssl_ciphers](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_ciphers) directives, or you can set your own preferable protocols and ciphers:

    ```nginx
    mail {
        #...
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers   HIGH:!aNULL:!MD5;
    }
    ```

### Optimizing SSL/TLS for Mail Proxy

These hints will help you make your NGINX mail proxy faster and more secure:

1. Set the number of worker processes equal to the number of processors with the [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) directive set on the same level as the [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail) context:

    ```nginx
    worker_processes auto;
    mail {
        #...
    }
    ```

2. Enable the shared session cache and disable the built-in session cache with the [ssl_session_cache](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_session_cache) directive:

    ```nginx
    worker_processes auto;

    mail {
        #...
        ssl_session_cache shared:SSL:10m;
        #...
    }
    ```

3. Optionally, you may increase the session lifetime which is `5` minutes by default with the [ssl_session_timeout](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_session_timeout) directive:

    ```nginx
    worker_processes auto;

    mail {
        #...
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;
        #...
    }
    ```

## Complete Example

```nginx
worker_processes auto;

mail {
    server_name mail.example.com;
    auth_http   localhost:9000/cgi-bin/nginxauth.cgi;

    proxy_pass_error_message on;

    ssl                 on;
    ssl_certificate     /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/certs/server.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    server {
        listen     25;
        protocol   smtp;
        smtp_auth  login plain cram-md5;
    }

    server {
        listen    110;
        protocol  pop3;
        pop3_auth plain apop cram-md5;
}

     server {
        listen   143;
        protocol imap;
    }
}
```

In this example, there are three email proxy servers: SMTP, POP3 and IMAP. Each of the servers is configured with SSL and STARTTLS support. SSL session parameters will be cached.

The proxy server uses the HTTP authentication server – its configuration is beyond the scope of this article. All error messages from the server will be returned to clients.
