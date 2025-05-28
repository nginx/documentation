---
title: NGINX integration
toc: true
weight: 500
---

Unit is a potent and versatile server in its own right. However, if you're
used to NGINX's rich feature set, you can deploy it in front of Unit; one
notable use case for NGINX here is securing the Unit control socket.

## Fronting Unit with NGINX

Configure a [listener]({{< relref "/unit/configuration.md#configuration-listeners" >}}) in Unit:

```json
{
   "127.0.0.1:8080": {
      "comment_127.0.0.1:8080": "Socket address where NGINX proxies requests",
      "pass": "...",
      "comment_pass": "Unit's internal request destination",
      "forwarded": {
            "client_ip": "X-Forwarded-For",
            "comment_client_ip": "The header field set by NGINX",
            "source": [
               "127.0.0.1"
            ],
            "comment_source": "The IP address where NGINX runs"
      }
   }
}
```

Here, **forwarded** is optional; it enables identifying the
[originating IPs]({{< relref "/unit/configuration.md#configuration-listeners-xff" >}})
of requests proxied from **source**.

In NGINX configuration, create an upstream in the **http** context, adding
the listener's socket as a **server**:

```nginx
http {
    upstream unit_backend {
        server 127.0.0.1:8080; # Unit's listener socket address
    }

    server {
        location /unit/ { # Arbitrary location
            proxy_pass http://unit_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; # Unit's listener must list the same name in client_ip/header
        }
    }
}
```

A more compact alternative would be a direct **proxy_pass** in your
**location**:

```nginx
http {
    server {
        location /unit/ { # Arbitrary location
            proxy_pass http://127.0.0.1:8080; # Unit's listener socket address
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; # Unit's listener must list the same name in client_ip/header
        }
    }
}
```

The **proxy_set_header X-Forwarded-For** directives work together with the
listener's **client_ip** option.

For details, see the [NGINX documentation](https://nginx.org). Commercial
support and advanced features are [also available](https://www.nginx.com).

## Securely proxying Unit's control API {#nginx-secure-api}

By default, Unit exposes its
[control API]({{< relref "/unit/controlapi.md#configuration-mgmt" >}})
via a UNIX domain socket. These sockets aren't network accessible, so the API is
local only. To enable secure remote access, you can use NGINX as a reverse proxy.

{{< warning >}}
Avoid exposing an unprotected control socket to public networks. Use NGINX
or a different solution such as SSH for security and authentication.
{{< /warning >}}

Use this configuration template for NGINX (replace placeholders in
**ssl_certificate**, **ssl_certificate_key**,
**ssl_client_certificate**, **allow**, **auth_basic_user_file**,
and **proxy_pass** with real values):

```nginx
server {

    # Configure SSL encryption
    listen 443 ssl;

    ssl_certificate /path/to/ssl/cert.pem; # Path to your PEM file; use a real path in your configuration
    ssl_certificate_key /path/to/ssl/cert.key; # Path to your key file; use a real path in your configuration

    # SSL client certificate validation
    ssl_client_certificate /path/to/ca.pem; # Path to certification authority PEM file; use a real path in your configuration
    ssl_verify_client on;

    # Network ACLs
    allow 1.2.3.4; # Replicate and update as needed with allowed IPs and network CIDRs
    deny all;

    # HTTP Basic authentication
    auth_basic on;
    auth_basic_user_file /path/to/htpasswd; # Path to your htpasswd file

    location / {
        proxy_pass http://unix:/path/to/control.unit.sock; # Path to Unit's control socket
    }
}
```

The same approach works for an IP-based control socket:

```nginx
location / {
    proxy_pass http://127.0.0.1:8080; # Unit's control socket address
}
```
