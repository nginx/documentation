---
# We use sentence case and present imperative tone
title: "Secure traffic using mTLS"
# Weights are assigned in increments of 100: determines sorting order
weight: 600
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document describes how to secure traffic between NGINX and the F5 WAF enforcer using mTLS.

It explains how to generate the necessary certificates, then update configuration files to use them.

A mutual TLS (mTLS) connection creates authentication between both NGINX (client) and F5 WAF Enforcer (server). 

This adds an extra layer of security, ensuring that both parties are who they claim to be.

## Generate certificates and keys

To enable mTLS, you must first create certificates.

{{< call-out "note" >}}

The following commands will generate self-signed certificates in _/etc/ssl/certs/_ valid for the default period of 30 days. You can adjust the command to fit your needs. 

For instance, to specify a different validity period, add the _-days_ option followed by the number of days you want the certificate to be valid (Such as _-days 90_).

{{< /call-out >}}

First, create the certificate authority files:

```shell
mkdir -p /etc/ssl/certs
openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_server_ca.key
openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_client_ca.key
openssl req -x509 -new -key /etc/ssl/certs/app_protect_server_ca.key -out /etc/ssl/certs/app_protect_server_ca.crt -subj "/O=F5/OU=app-protect/CN=mTLS Server Root CA"
openssl req -x509 -new -key /etc/ssl/certs/app_protect_client_ca.key -out /etc/ssl/certs/app_protect_client_ca.crt -subj "/O=F5/OU=app-protect/CN=mTLS Client Root CA"
```

Then, create the server (F5 WAF enforcer) files:

```shell
openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_server.key
openssl req -new -key /etc/ssl/certs/app_protect_server.key -out /etc/ssl/certs/app_protect_server_csr.crt -subj "/O=F5/OU=app-protect/CN=mTLS"
openssl x509 -req -in /etc/ssl/certs/app_protect_server_csr.crt -CA /etc/ssl/certs/app_protect_server_ca.crt -CAkey /etc/ssl/certs/app_protect_server_ca.key -out /etc/ssl/certs/app_protect_server.crt -CAcreateserial
```

Finally, create the client (NGINX) files:

```shell
openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_client.key
openssl req -new -key /etc/ssl/certs/app_protect_client.key -out /etc/ssl/certs/app_protect_client_csr.crt -subj "/O=F5/OU=app-protect/CN=mTLS"
openssl x509 -req -in /etc/ssl/certs/app_protect_client_csr.crt -CA /etc/ssl/certs/app_protect_client_ca.crt -CAkey /etc/ssl/certs/app_protect_client_ca.key -out /etc/ssl/certs/app_protect_client.crt -CAcreateserial
```

## Update configuration files

To enable mTLS, you must add F5 WAF enforcer to a [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) context.

Modify an existing block or create one with the following information:

```nginx {hl_lines=[3, 8, 12, 13, 14]}
stream {
    upstream enforcer {
        server 127.0.0.1:4431;
    }

    server {
        listen 5000;
        proxy_pass enforcer;
        proxy_ssl_server_name on;
        proxy_timeout 60m;
        proxy_ssl on;
        proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
        proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
        proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
    }
```

- _upstream enforcer_ specifies the server, which listens on port 4431 by default
- _proxy_pass_ indicates that requests should be routed through the enforcer upstream
- _proxy_ssl_certificate_ and _proxy_ssl_certificate_key_ are for the client (NGINX) credentials
- _proxy_ssl_trusted_certificate_ enables the server (enforcer) verification

This stream server should then be used as the _app_protect_enforcer_address_ value:

```shell
app_protect_enforcer_address 127.0.0.1:5000;
```

A fully configured file might look similar to the following example:

```nginx {hl_lines=[12,13,14, 18, 22, 23, 24, 33]}
user nginx;
worker_processes auto;
worker_shutdown_timeout 10s; # NGINX gives worker processes 10 seconds to gracefully terminate before it will actively close connections
load_module modules/ngx_http_app_protect_module.so;
error_log /var/log/nginx/error.log notice;

events {
        worker_connections 65536;
    }

stream {
upstream enforcer {
    server 127.0.0.1:4431;
}

server {
    listen 5000;
    proxy_pass enforcer;
    proxy_ssl_server_name on;
    proxy_timeout 60m;
    proxy_ssl on;
    proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
    proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
    proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    app_protect_enforcer_address 127.0.0.1:5000;

    server {
        listen 80;
        server_name localhost;

        app_protect_enable on;
        app_protect_policy_file app_protect_default_policy;
        app_protect_security_log_enable on;
        app_protect_security_log log_all syslog:server=127.0.0.1:514;

        location / {
            client_max_body_size 0;
            default_type text/html;
            # Pass traffic to backend
            proxy_pass http://127.0.0.1:8080/;
        }
    }
}
```

{{< call-out "note" >}}

With a [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md" >}}) installation, you have finished all necessary steps.

{{< /call-out >}}

## Modify Docker compose file

{{< call-out "warning" >}}

This section **only** applies to installations using Docker.

{{< /call-out >}}

To use mTLS with Docker, you must modify your compose files.

The certificates folder _/etc/ssl/certs/_ must be added to the _volumes:_ sections of the NGINX and WAF enforcer services.

And the individual certificate and key files must be added to the _environment:_ section of the WAF enforcer service, using the correct names.

This example highlights the required fields:

```yaml {hl_lines=[11, 22, 23, 24, 27]}
services:
	  nginx:
	    container_name: nginx
	    image: nginx-app-protect-5
	    volumes:
	      - app_protect_bd_config:/opt/app_protect/bd_config
	      - app_protect_config:/opt/app_protect/config
	      - app_protect_etc_config:/etc/app_protect/conf
	      - /conf/nginx.conf:/etc/nginx/nginx.conf
	      - /conf/default.conf:/etc/nginx/conf.d/default.conf 
	      - /path/to/your/certs:/etc/ssl/certs
	    networks:
	      - waf_network
	    ports:
	      - "80:80"

	  waf-enforcer:
	    container_name: waf-enforcer
	    image: "private-registry.nginx.com/nap/waf-enforcer:<version-tag>"
	    environment:
	      - ENFORCER_PORT=4431
	      - ENFORCER_SERVER_CERT=/etc/ssl/certs/app_protect_server.crt
	      - ENFORCER_SERVER_KEY=/etc/ssl/certs/app_protect_server.key
	      - ENFORCER_CA_FILE=/etc/ssl/certs/app_protect_client_ca.crt
	    volumes:
	      - app_protect_bd_config:/opt/app_protect/bd_config
	      - /path/to/your/certs:/etc/ssl/certs
	    networks:
	      - waf_network
	    restart: always

	  waf-config-mgr:
	    container_name: waf-config-mgr
	    image: "private-registry.nginx.com/nap/waf-config-mgr:<version-tag>"
	    volumes:
	      - app_protect_bd_config:/opt/app_protect/bd_config
	      - app_protect_config:/opt/app_protect/config
	      - app_protect_etc_config:/etc/app_protect/conf
	    restart: always
	    network_mode: none
	    depends_on:
	      waf-enforcer:
	        condition: service_started

	networks:
	  waf_network:
	    driver: bridge

	volumes:
	  app_protect_bd_config:
	  app_protect_config:
	  app_protect_etc_config:
```

