---
description: Configure NGINX and F5 NGINX Plus as an application gateway for uWSGI and Django
docs: DOCS-439
title: Using NGINX and NGINX Plus as an Application Gateway with uWSGI and Django
toc: true
weight: 500
type:
- how-to
---

This article explains how to use NGINX or F5 NGINX Plus as an application gateway with uWSGI and Django.

<span id="intro"></span>
## Introduction

NGINX is a high‑performance, scalable, secure, and reliable web server and a reverse proxy. NGINX uses web acceleration techniques to manage HTTP connections and traffic. Features like [load balancing]({{< relref "../load-balancer/http-load-balancer.md" >}}), [SSL termination]({{< ref "/nginx/admin-guide/security-controls/terminating-ssl-http.md" >}}), connection and request [policing]({{< ref "/nginx/admin-guide/security-controls/controlling-access-proxied-http.md" >}}), static [content offload]({{< ref "/nginx/admin-guide/web-server/serving-static-content.md" >}}), and [content caching]({{< ref "/nginx/admin-guide/content-cache/content-caching.md" >}}) help users build reliable websites.

NGINX acts as a secure application gateway, passing traffic from users to applications. In this regard, not only can NGINX proxy HTTP and HTTPS traffic to an HTTP‑enabled application container, it can also connect to most of the popular application servers and web frameworks via optimized app‑gateway interfaces implemented in modules like [FastCGI](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html), [Memcached](https://nginx.org/en/docs/http/ngx_http_memcached_module.html), [scgi](https://nginx.org/en/docs/http/ngx_http_scgi_module.html), and [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html).

Many application containers have embedded external HTTP interfaces with some routing capabilities. NGINX offers an all‑in‑one solution. It handles HTTP connection management, load balancing, content caching, and traffic security. The application backend sits behind NGINX for better scalability and performance. You can group app instances behind NGINX to ensure high availability.

<span id="about-uwsgi-django"></span>
## About uWSGI and Django

A few words about "specialized interfaces." As useful as it is, HTTP has never been designed for modern, lightweight application‑deployment scenarios. Over time, standardized interfaces have evolved for use with various application frameworks and application containers. One of these interfaces is the Web Server Gateway Interface ([WSGI](http://wsgi.readthedocs.org/en/latest/)), an interface between a web server/proxy and Python‑based applications.

One common application server is the [uWSGI application server container](https://github.com/unbit/uwsgi). It offers [uwsgi](http://uwsgi-docs.readthedocs.org/en/latest/Protocol.html) -  its own implementation of the WSGI protocol.

Other than that, the uWSGI application server supports HTTP, FastCGI, and SCGI – with the uwsgi protocol recommended as the fastest way to talk to applications.

<span id="configure"></span>
## Configure NGINX and NGINX Plus for Use with uWSGI and Django

This document provides an example of how to configure NGINX and NGINX Plus for use with a [uWSGI](http://uwsgi-docs.readthedocs.org/en/latest/) server and a Python development environment.

NGINX 0.8.40 and later (and all releases of NGINX Plus) includes native support for passing traffic from users to Python applications via the uwsgi protocol. If you downloaded [NGINX Open Source  binaries or source](https://nginx.org/en/download.html) from our official repositories, or [NGINX Plus from the customer portal](https://account.f5.com/myf5), no action is needed to enable support for the uwsgi protocol – NGINX and NGINX Plus support uswgi by default.

Configuring the uWSGI application container itself is outside the scope of this document; refer to the excellent [Quickstart for Python/WSGI applications](http://uwsgi-docs.readthedocs.org/en/latest/WSGIquickstart.html) for more information.

[Django](https://www.djangoproject.com/) is a common Python web framework. For simplicity the example uses a Django‑based setup for the Python app. The [Django documentation](https://docs.djangoproject.com/en/1.11/) provides extensive information on how to configure a Django environment.

This example is illustrative only, and one way you might invoke your uWSGI server with Django:

```shell
uwsgi \
    --chdir=/var/django/projects/myapp \
    --module=myapp.wsgi:application \
    --env DJANGO_SETTINGS_MODULE=myapp.settings \
    --master --pidfile=/usr/local/var/run/uwsgi/project-master.pid \
    --socket=127.0.0.1:29000 \
    --processes=5 \
    --uid=505 --gid=505 \
    --harakiri=20 \
    --max-requests=5000 \
    --vacuum \
    --daemonize=/usr/local/var/log/uwsgi/myapp.log
```

With these options in place, here's a sample NGINX configuration for use with a Django project:

```nginx
http {
    # ...
    upstream django {
        server 127.0.0.1:29000;
    }

    server {
        listen      80;
        server_name myapp.example.com;
        root        /var/www/myapp/html;

        location / {
            index index.html;
        }

        location /static/  {
            alias /var/django/projects/myapp/static/;
        }

        location /main {
            include     /etc/nginx/uwsgi_params;
            uwsgi_pass  django;
            uwsgi_param Host $host;
            uwsgi_param X-Real-IP $remote_addr;
            uwsgi_param X-Forwarded-For $proxy_add_x_forwarded_for;
            uwsgi_param X-Forwarded-Proto $http_x_forwarded_proto;
        }
    }
}
```

This configuration defines an upstream named `django`. The port number `29000` specified for the server in this upstream matches the port that the uWSGI server binds to, as specified by the `--socket=` argument in the sample `uwsgi` command.

Serving static content is offloaded to NGINX or NGINX Plus, which serves it directly from `/var/django/projects/myapp/static`. Application traffic to the `/main` location is proxied and bridged from HTTP to the uwsgi protocol, and then passed to the Django app that runs within the uWSGI application container.

<span id="conclusion"></span>
## Conclusion

Lightweight, heterogeneous application environments are becoming a popular way of building and deploying modern web applications. Newer, standardized application interface protocols like uwsgi and FastCGI enable faster communication between users and applications.

Using NGINX and NGINX Plus in front of an application container has become a common way to free applications from the burden of HTTP traffic management, and to protect the application from unexpected spikes of user traffic, malicious behavior, denial‑of‑service (DoS) attacks, and more. This allows developers to fully focus on the application logic, and leave the web acceleration and fundamental HTTP traffic security tasks to NGINX or NGINX Plus.

<span id="resources"></span>
## Resources

- [NGINX support](https://uwsgi-docs.readthedocs.io/en/latest/Nginx.html) in the uWSGI project documentation
- [How to use Django with uWSGI](https://docs.djangoproject.com/en/1.11/howto/deployment/wsgi/uwsgi/) in the Django project documentation
