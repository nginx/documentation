---
title: "Securing upstream traffic"
weight: 300
categories: ["tasks"]
toc: true
docs: "DOCS-1475"
url: /nginxaas/azure/quickstart/security-controls/securing-upstream-traffic/
---

Learn how to encrypt HTTP traffic between F5 NGINX as a Service for Azure (NGINXaaS) and an upstream group or a proxied server. To secure TCP traffic to upstream servers, follow the [NGINX Plus guide](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-tcp-traffic-upstream/). As with securing HTTP traffic, you will need to [add the SSL/TLS client certificate]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}}) to the NGINXaaS deployment.

### Prerequisites

- [Add a SSL/TLS Certificate]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}}) to the NGINXaaS deployment.
- Enable [njs module]({{< relref "/nginxaas-azure/quickstart/njs-support.md">}}) if configuration uses njs directives.

### Configuring NGINX

[Add the client certificate and the key]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}}) that will be used to authenticate NGINX to the NGINXaaS deployment. Make a note of the filepaths you assign to the `Certificate path` and `Key path`.

Next, change the URL to an upstream group to support SSL connections. In the NGINX configuration file, specify the “https” protocol for the proxied server or an upstream group in the `proxy_pass` directive:

```nginx
location /upstream {
    proxy_pass https://backend.example.com;
}
```

Add the client certificate and key to the NGINX config to authenticate NGINX on each upstream server with `proxy_ssl_certificate` and `proxy_ssl_certificate_key` directives using the filepaths noted above. NGINXaaS for Azure expects the directive's file arguments to match the filepaths assigned to a certificate and key that have been added to the NGINXaaS Deployment.

```nginx
location /upstream {
    proxy_pass                https://backend.example.com;
    proxy_ssl_certificate     /etc/nginx/client.pem;
    proxy_ssl_certificate_key /etc/nginx/client.key;
}
```

If you use a self-signed certificate for an upstream or your own CA, you may include this file by adding it to the [NGINX configuration]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md">}}) and including the `proxy_ssl_trusted_certificate` directive. The file must be in the PEM format. Optionally, include the [`proxy_ssl_verify`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify) and [`proxy_ssl_verify_depth`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify_depth) directives to have NGINX check the validity of the security certificates:

```nginx
location /upstream {
    # ...
    proxy_ssl_trusted_certificate /etc/nginx/trusted_ca_cert.crt;
    proxy_ssl_verify       on;
    proxy_ssl_verify_depth 2;
    # ...
}
```

If your configuration is using the [njs module]({{< relref "/nginxaas-azure/quickstart/njs-support.md">}}), you can include the `js_fetch_trusted_certificate` directive to [verify](http://nginx.org/en/docs/njs/reference.html#fetch_verify) HTTPS certificates with the [Fetch API](http://nginx.org/en/docs/njs/reference.html#ngx_fetch).

Toggle `yes` to include the CA file as proctectd file when using Azure Portal as show below:

{{< img src="nginxaas-azure/add-ca-as-protected-file.png" alt="Screenshot of the Azure portal showing the toggle for protected files" >}}

### Configuring upstreams

Each upstream server should be configured to accept HTTPS connections. For each upstream server, specify a path to the server certificate and the private key [added to the NGINXaaS Deployment]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}}) with `ssl_certificate` and `ssl_certificate_key` directives:

```nginx
server {
    listen              443 ssl;
    server_name         backend1.example.com;

    ssl_certificate     /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/certs/server.key;
    #...
    location /upstream {
        proxy_pass http://url_to_app.com;
        # ...
    }
}
```

Specify the path to a trusted client CA certificate added to the [NGINX configuration]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md">}}) with the `ssl_client_certificate` or `ssl_trusted_certificate` directives. The file should be in PEM format.

```nginx
server {
    #...
    ssl_client_certificate /etc/ssl/certs/ca.crt;
    ssl_verify_client      optional;
    #...
}
```

Complete example to secure your traffic between NGINX and upstream servers is available [here](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/#complete-example).

### Additional configuration

If your keys specified in `proxy_ssl_certificate_key` use passphrase, then include the passphrases as file to the NGINX configuration and reference the file in `proxy_ssl_password_file`. It is recomended to use a protected file as an argument for this directive.

```nginx
location /upstream {
    proxy_pass                https://backend.example.com;
    proxy_ssl_certificate     /etc/nginx/client.pem;
    proxy_ssl_certificate_key /etc/nginx/client.key;
    proxy_ssl_password_file pswd.txt;
}
```

You can also configure NGINX with a list of revoked certificates using `proxy_ssl_crl` directive. Include this file in PEM format in your NGINX configuration.

```nginx
location /upstream {
    # ...
    proxy_ssl_crl /etc/nginx/revoked.crt;
    # ...
}
```

`ssl_session_ticket_key` directive specifies a file with the secret key used to encrypt and decrypt TLS session tickets. To use these directives in your config file, include a file to your [NGINX configuration]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}}) with 80 or 48 bytes of random data generated using `openssl` command, in your config bundle. For example,

```nginx
http {
    server {
         ssl_certificate /etc/nginx/client.pem;
         ssl_certificate_key /etc/nginx/client.key;
         ssl_client_certificate /etc/nginx/ca.pem;
         ssl_session_ticket_key keys;
    }
}
```
