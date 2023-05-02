---
title: "Encryption"
date: 2020-12-27T20:56:49-07:00
draft: false
description: "An NGINX Instance Manager encryption document."
# Assign weights in increments of 100
weight: 500
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "security"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
docs: "DOCS-625"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

<style>table, th, td {  border: 1px solid #CCC;  border-collapse: collapse;}th, td {  padding: 6px;}th {  text-align: center;}</style>

{{%heading "overview"%}}

This document helps you secure NGINX Instance Manager by utilizing certificates.

{{<warning>}}A management server should NEVER be exposed to the public internet. You can mitigate exposure with settings here, but they are not a substitute for preventing unneeded exposure.{{</warning>}}

{{<note>}}
NGINX Plus is provided to be used with NGINX Instance Manager only as a frontend.
Using NGINX Plus for other web applications or instances is not permitted.
{{</note>}}

## Prerequisites {#prerequisites}

1. Install NGINX Instance Manager Server.
2. Install NGINX or NGINX Plus.
3. Start and Enable Instance Manager and NGINX Plus (or NGINX).

## Encryption Methods {#methods}

Use the [native SSL encryption methods](#native) for NGINX Instance Manager or the recommended approach of using [NGINX as an SSL termination reverse proxy](#proxy).

The following table summarizes the key differences between NGINX Open Source and NGINX Plus (for authentication options with NGINX Instance Manager).

| Method | no proxy | nginx-oss |nginx-plus|
|--|--|--|--|
| [SSL Termination](#ssl-termination) | [Included](#native-ssl-termination) | [Included](#nginx-ssl-termination-oss) | [Included](#nginx-ssl-termination-plus) |
| [Client mTLS](#mtls) | [Included](#native-mtls) | [Included](#nginx-mtls) | [Included](#nginx-plus-mtls)|
| [GRPC Health Checks](#grpc)| N/A| N/A| Included|

## How it works {#how-it-works}

Instance Manager listens on two ports. The gRPC communication listens only on `127.0.0.1` and is on `10000` by default. The browser interface and API listen on `127.0.0.1` and are on `11000` by default. By using NGINX, we follow our own guidance for any web application. Use NGINX Open Source ("NGINX OSS") or NGINX Plus for the forward proxy. An instance of NGINX Plus is provided with NGINX Instance Manager. Use it to proxy and secure NGINX Instance Manager.

{{<tip>}}To improve security, replace `127.0.0.1` with a filename and path for a socket listener.{{</tip>}}

## Common NGINX Snippets {#common}

### Security Options {#security}

These options help prevent and mitigate common attacks that can compromise any web based server. They should be included on all configurations for security reasons. Adjust and use the ones that fit your needs. They are the [HSTS settings](https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/) that should be used with any SSL setup and NGINX. Change the max-age once you've verified these settings work for you.

Create a common conf for headers:

<details>
    <summary>/etc/nginx/http_headers.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/http_headers.conf" "http_headers.conf">}}
```nginx
# /etc/nginx/http_headers.conf
add_header X-Frame-Options SAMEORIGIN;

# vim: syntax=nginx
```
</details>

<details>
    <summary>/etc/nginx/https_headers.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/https_headers.conf" "https_headers.conf">}}
```nginx
# /etc/nginx/https_headers.conf
include http_headers.conf;
# add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";
# enable the longer max-age above after you test your configuration
add_header Strict-Transport-Security "max-age=86400; includeSubdomains";

# Enable Content Security Policy 
add_header Content-Security-Policy "default-src 'self'; font-src *;img-src * data:; script-src *; style-src *";

# Enable X-XSS protection
add_header X-XSS-Protection "1; mode=block";

# Referrer-Policy
add_header Referrer-Policy "strict-origin";

# vim: syntax=nginx
```
</details><br/>

And use this in the confs for the NGINX proxy:

<details>
    <summary>/etc/nginx/conf.d/default.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/default.conf" "default.conf">}}
```nginx
http {
    include http_headers.conf;

    # Serve HTTP content using the http_headers conf
    server {
        listen 80
    }

    server {
        listen 443 ssl;

        include https_headers.conf;

        # This 'location' block inherits the STS header
        location / {
            root /usr/share/nginx/html;
        }

        # Because this 'location' block contains another 'add_header' directive,
        # we must redeclare the STS header
        location /servlet {
            add_header X-Served-By "My Unnecessary Header Example";
            include https_headers.conf;
            proxy_pass https://nginx-manager.example.com;
        }
    }
}

# vim: syntax=nginx
```
</details><br/>

### Upstreams {#common-upstreams}

The examples below make reference to an upstream group nginx-manager_servers. You can create the same with a conf file similar to the one below.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-upstreams.conf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-upstreams.conf" "nginx-manager-upstreams.conf">}}
```nginx
# nginx-manager-upstreams.conf
# Upstreams for NGINX Instance Manager Server API/UI

upstream nginx-manager_servers {
        zone nginx-manager_servers 64k;
        server 127.0.0.1:11000;
        keepalive 64;
}

# vim: syntax=nginx
```
</details><br/>

### Status Page {#common-status}

NGINX Plus uses a status page. The following example shows a default configuration on port `8080`. Adjust the port to your desired one and add SSL if wanted (or other restrictions like rate limiting).

<details>
  <summary>/etc/nginx/conf.d/status-api.conf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/status-api.conf" "status-api.conf">}}
```nginx
# This sample NGINX Plus configuration enables the NGINX Plus API, for live 
# activity monitoring and the built-in dashboard, dynamic configuration of 
# upstream groups, and key-value stores. Keep in mind that any features 
# added to the API in future NGINX Plus releases are enabled 
# automatically by this file.
# Created in May 2018 by NGINX, Inc. for NGINX Plus R14 and later.

# Documentation: 
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/
# https://www.nginx.com/blog/live-activity-monitoring-nginx-plus-3-simple-steps

# To conform with the conventional configuration scheme, place this file in 
# the /etc/nginx/conf.d directory and add an 'include' directive that 
# references it in the main configuration file, /etc/nginx/nginx.conf, 
# either by name or with a wildcard expression. Then confirm and reload
# the configuration, for example with this command:
#
#     nginx -t && nginx -s reload

# Additional directives are required in other parts of the 
# configuration:
#
# To collect metrics for an HTTP or TCP/UDP virtual server, you must 
# include the 'status_zone' directive in its 'server' block. See: 
# http://nginx.org/r/status_zone
#
# Similarly, to collect metrics for an upstream server group, you 
# must include the 'zone' directive in the 'upstream' block. See:
# http://nginx.org/r/zone
#
# For more information and instructions, see:
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring#status_data

# It is recommended to restrict access to the NGINX Plus API so 
# that only authorized users can view metrics and configuration, change 
# configuration, or both. Here are a few options:
#
# (1) Configure your firewall to limit access to port 8080.
#
# (2) Use SSL/TLS client certificates. See:
#    https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/
#
# (3) Enable HTTP Basic authentication (RFC 7617) by uncommenting the 
#    'auth_basic*' directives in the 'server' block below. You can add users 
#    with an htpasswd generator, which is readily available, or reuse an 
#    existing htpasswd file (from an Apache HTTP Server, for example). See: 
#    http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html
#
# (4) Enable access from a defined network and disable it from all others, 
#    by uncommenting the 'allow' and 'deny' directives in the 'server' block
#    below and specifying the appropriate network ranges. See: 
#    http://nginx.org/en/docs/http/ngx_http_access_module.html
#
# You can create further restrictions on write operations, to distinguish
# between users with read permission and those who can change configuration.
# Uncomment the sample 'limit_except' directive in the 'location api' 
# block below. In addition to the HTTP Basic authentication shown, other 
# authentication schemes are supported. See: 
# http://nginx.org/r/limit_except

server {
    # Conventional port for the NGINX Plus API is 8080
    listen 8080;

    access_log off; # Don't log access here (test env)
    
    # Uncomment to use HTTP Basic authentication; see (3) above
    #auth_basic "NGINX Plus API";
    #auth_basic_user_file /etc/nginx/users;

    # Uncomment to use permissions based on IP address; see (4) above
    #allow 10.0.0.0/8;
    #deny all;

    # Conventional location for accessing the NGINX Plus API 
    location /api/ {
        # Enable in read-write mode
        api write=on;

        # Uncomment to further restrict write permissions; see note above
        #limit_except GET {
            #auth_basic "NGINX Plus API";
            #auth_basic_user_file /etc/nginx/admins;
        #}
    }

    location /nginx_status {
        stub_status;
    }
    
    # Conventional location of the NGINX Plus dashboard
    location = /dashboard.html {
        root /usr/share/nginx/html;
    }

    # Redirect requests for "/" to "/dashboard.html"
    location / {
        root /usr/share/nginx/html;
        index dashboard.html;
    }

    # Swagger-UI exposure
    location /swagger-ui {
        root /usr/share/nginx/html;
    }

    # Redirect requests for pre-R14 dashboard
    location /status.html {
        return 301 /dashboard.html;
    }
}

# vim: syntax=nginx
```
</details><br/>

### Stub Page {#common-stub}

NGINX Open Source uses a stub status page. The following example shows a default configuration on port `8080`. Adjust the port to your desired one and add SSL if wanted (or other restrictions like rate limiting).

Please Note: You need to compile NGINX Open Source with the --with-http_stub_status_module parameter

<details>
    <summary>/etc/nginx/conf.d/stub-status.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/stub-status.conf" "stub-status.conf">}}

```nginx
# ngx_http_stub_status_module (Available in NGINX F/OSS)
# provides Basic Status information http://nginx.org/en/docs/http/ngx_http_stub_status_module.html

server {
    listen 127.0.0.1:80;
    server_name 127.0.0.1;
    access_log off; # Don't log access here (test env)
    location /nginx_status {
        stub_status on;
        allow 127.0.0.1;
        deny all;
    }
}

# vim: syntax=nginx
```
</details>

{{%heading "ssl"%}}

## SSL Termination {#ssl-termination}

Configure either NGINX Open Source or NGINX Plus for SSL Termination. You can use either of the two methods:
- native SSL in the Instance Manager config files or
- use a proxy in the front end to provide SSL Termination

### Native SSL Termination {#native-ssl-termination}

Modify the /etc/nginx-manager/nginx-manager.conf file to include SSL certificates. You will need to verify these certificates are valid and also adjust agent settings to use https.

<details>
    <summary>/etc/nginx-manager/nginx-manager.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/noauth/nginx-manager.conf" "nginx-manager.conf">}}
```yaml {hl_lines=[15,17]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "127.0.0.1")
bind_address: 0.0.0.0
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# path to x.509 certificate file (optional)
cert: /etc/ssl/nginx-manager/nginx-manager.crt
# path to x.509 certificate key file (optional)
key: /etc/ssl/nginx-manager/nginx-manager.key
```
</details><br/>

### NGINX Proxy SSL Termination {#nginx-ssl-termination}

Configure the SSL certificate and key inside the NGINX configuration as you normally would. Refer to the guide [NGINX SSL Termination](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/).

{{<tabs name="ssl-termination">}}
{{%tab name="NGINX Plus"%}}

### SSL Termination for NGINX Plus {#nginx-ssl-termination-plus}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-noauth.conf</summary>

{{<fa "download">}} [nginx-manager-noauth.conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-noauth.conf)
```nginx {hl_lines=[7,9,"17-18","21-23","25-27","33-34"]}
# nginx-manager-noauth.conf
# Proxy UI/API with no auth to 127.0.0.1 on nginx-manager
# Include the nginx-manager-upstreams.conf for the proxy_pass to work

server {
    listen          88;
    listen          443 http2 ssl;
    
    server_name     nginx-manager.example.com;
    status_zone     nginx-manager_noauth_https;

    # Optional log locations
    # access_log /var/log/nginx/nginx-manager-noauth-access.log info;
    # error_log /var/log/nginx/nginx-manager-noauth-error.log;

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;

    location / {
        proxy_pass http://nginx-manager_servers;
        # proxy_pass https://nginx-manager_servers;
        health_check uri=/swagger-ui/;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;
    }
}

# vim: syntax=nginx
```
</details>

{{%/tab%}}
{{%tab name="NGINX Open Source"%}}

### SSL Termination for NGINX OSS {#nginx-ssl-termination-oss}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-noauth.conf</summary>

{{<fa "download">}} [nginx-manager-noauth.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-manager-noauth.conf)
```nginx {hl_lines=[7,9,"16-17","20-22","24-26","31-32"]}
# nginx-manager-noauth.conf
# Proxy UI/API with no auth to 127.0.0.1 on nginx-manager
# Include the nginx-manager-upstreams.conf for the proxy_pass to work

server {
    listen          88;
    listen          443 http2 ssl;
    
    server_name     nginx-manager.example.com;

    # Optional log locations
    # access_log /var/log/nginx/nginx-manager-noauth-access.log info;
    # error_log /var/log/nginx/nginx-manager-noauth-error.log;

    # SSL certificates must be valid for the FQDN and placed in the correct directories
    ssl_certificate             /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key         /etc/ssl/nginx-manager/nginx-manager.key;
    # ssl_client_certificate    /etc/ssl/nginx-manager/ca.pem;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;

    location / {
        proxy_pass http://nginx-manager_servers;
        # proxy_pass https://nginx-manager_servers;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;
    }
}

# vim: syntax=nginx
```
</details>

{{%/tab%}}
{{</tabs>}}

{{%heading "mtls"%}}

## Mutual Client Certificate Auth Setup (mtls) {#mtls}

Using client certificates unique to each endpoint allows you to secure and authorize individual nginx instances with the nginx-manager. You can utilize basic client auth with nginx-manager directly or leverage nginx as a proxy to offload client cert handling or re-encrypt traffic back to the nginx-manager. For enterprises, the recommended method is to leverage the included NGINX Plus proxy and configure the options below in the [NGINX Plus Section](#nginx-plus-mtls).

Use PKI methods to secure your enterprise. Refer to the following instructions for guidance.

Generate a Certificate Authority (CA) for all the methods described below. This can be on the Instance Manager server for testing. For production, follow your organization's standards (typically an offline machine without network connections).

The root CA provides a certificate for an intermediate CA which should be secured. The root CA (or intermediate CA) issues client and server certificates. The CA (either root or intermediate) will sign certificate signing requests (CSRs) and issue certificates. The following examples assume you have the following components setup:

1. CA server (nginx-manager-ca.example.com) with ca.pem bundle
2. Instance Manager server (nginx-manager.example.com) with key and crt
3. nginx-agent instances (nginx-1.example.com) with key and crt

### Generate Certificates {#generate-certs}

Use the following as an example and modify according to your needs. There are many ways to generate certificates that exist, the examples below are suggestive only.

1. Install OpenSSL if you haven't already. This guide assumes you know how to do that.

2. Use something similar to the below script to setup the certificates you need. Save this script as `make_certs.sh`.

<details>
    <summary>make_certs.sh</summary>

{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/getting-started/quickstart/make_certs.sh" "make_certs.sh">}}
```bash
#!/bin/bash

make_ca() {
    echo "Creating CA certificate and key"
    openssl req \
      -new \
      -newkey rsa:4096 \
      -days 365 \
      -sha256 \
      -nodes \
      -x509 \
      -keyout ca.key \
      -out ca.crt \
      -config ca.cnf \
      -extensions v3_req
    #openssl x509 -in ca.crt -noout -text
}

make_int() {
    echo "Creating Intermediate CA certificate and key"
    openssl req \
      -new \
      -newkey rsa:4096 \
      -nodes \
      -keyout ca_int.key \
      -out ca_int.csr \
      -config ca-intermediate.cnf \
      -extensions v3_req
    openssl req -in ca_int.csr -noout -verify
    openssl x509 \
      -req \
      -sha256 \
      -days 365 \
      -CA ca.crt \
      -CAkey ca.key \
      -CAcreateserial \
      -in ca_int.csr \
      -out ca_int.crt \
      -extfile ca-intermediate.cnf \
      -extensions v3_req
    openssl verify -CAfile ca.crt ca_int.crt
    echo "Creating CA chain"
    cat ca_int.crt ca.crt > ca.pem
}

make_server() {
    echo "Creating nginx-manger certificate and key"
    openssl req \
      -new \
      -nodes \
      -keyout server.key \
      -out server.csr \
      -config server.cnf \
      -extensions v3_req
    openssl req -in server.csr -noout -verify
    openssl x509 \
      -req \
      -days 365 \
      -sha256 \
      -CA ca_int.crt \
      -CAkey ca_int.key \
      -CAcreateserial \
      -in server.csr \
      -out server.crt \
      -extfile server.cnf \
      -extensions v3_req
    openssl verify -CAfile ca.pem server.crt
}

make_agent() {
    echo "Creating Agent certificate and key"
    openssl req \
        -new \
        -newkey rsa:2048 \
        -nodes \
        -keyout agent.key \
        -out agent.csr \
        -config agent.cnf \
        -extensions v3_req
    openssl req -in agent.csr -noout -verify
    openssl x509 \
        -req \
        -days 365 \
        -CA ca.crt \
        -CAkey ca.key \
        -CAcreateserial \
        -in agent.csr \
        -out agent.crt \
        -extfile agent.cnf \
        -extensions v3_req
    openssl verify -CAfile ca.pem agent.crt
    for os in {1..10}
    do
        for nginx in agent
        do
            openssl req \
              -new \
              -newkey rsa:2048 \
              -nodes \
              -keyout $nginx-$os.key \
              -out $nginx-$os.csr \
              -config agent.cnf \
              -extensions v3_req
            openssl req -in $nginx-$os.csr -noout -verify
            openssl x509 \
              -req \
              -days 365 \
              -sha256 \
              -CA ca.crt \
              -CAkey ca.key \
              -CAcreateserial \
              -in $nginx-$os.csr \
              -out $nginx-$os.crt \
              -extfile agent.cnf \
              -extensions v3_req
            openssl verify -CAfile ca.pem $nginx-$os.crt
        done
    done
}

# MAIN
make_ca
make_int
make_server
make_agent

```
</details><br/>

3. Put the following OpenSSL cnf files in the same directory.

<details>
    <summary>ca.cnf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/getting-started/quickstart/ca.cnf" "ca.cnf">}}
```
[req]
default_bits        = 4096
distinguished_name  = req_distinguished_name
prompt              = no
default_md          = sha256
req_extensions      = v3_req

[req_distinguished_name]
countryName                 = US
stateOrProvinceName         = California
localityName                = San Francisco
organizationName            = NGINX, Inc.
commonName                  = nginx-manager_ca

[v3_req]
basicConstraints = critical, CA:true
keyUsage = critical, keyCertSign, cRLSign
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = nginx-manager_ca.example.com
DNS.2 = localhost
IP.1 = 127.0.0.1
```
</details>

<details>
    <summary>ca-intermediate.cnf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/getting-started/quickstart/ca-intermediate.cnf" "ca-intermediate.cnf">}}
```
[req]
default_bits        = 4096
distinguished_name  = req_distinguished_name
prompt              = no
default_md          = sha256
req_extensions      = v3_req

[req_distinguished_name]
countryName                 = US
stateOrProvinceName         = California
localityName                = San Francisco
organizationName            = NGINX, Inc.
commonName                  = nginx-manager_ca_int

[v3_req]
basicConstraints = critical, CA:true
keyUsage = critical, keyCertSign, cRLSign
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = nginx-manager_ca_int.example.com
DNS.2 = localhost
IP.1 = 127.0.0.1
```
</details>

<details>
    <summary>server.cnf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/getting-started/quickstart/server.cnf" "server.cnf">}}
```
[req]
prompt             = no
default_bits       = 4096
x509_extensions    = v3_req
req_extensions     = v3_req
default_md         = sha256
distinguished_name = req_distinguished_name

[req_distinguished_name]
countryName                 = US
stateOrProvinceName         = California
localityName                = San Francisco
organizationName            = NGINX, Inc.
commonName                  = nginx-manager.example.com

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = nginx-manager.example.com
DNS.2 = server
DNS.3 = nginx-manager
DNS.4 = localhost
IP.1 = 127.0.0.1
```
</details>

<details>
    <summary>agent.cnf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/getting-started/quickstart/agent.cnf" "agent.cnf">}}
```
[req]
prompt             = no
default_bits       = 2048
x509_extensions    = v3_req
req_extensions     = v3_req
default_md         = sha256
distinguished_name = req_distinguished_name

[req_distinguished_name]
countryName                 = US
stateOrProvinceName         = California
localityName                = San Francisco
organizationName            = NGINX, Inc.
commonName                  = agent.example.com

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = agent.example.com
DNS.2 = *.example.com

```
</details><br/>

4. Make the script executable and run the script to generate the certificates.

```bash
sudo chmod +x ./make_certs.sh
sudo ./make_certs.sh
```

5. Set Permissions on the certificates and keys

```bash
sudo chmod 664 *.crt
sudo chmod 640 *.key
```

6. Rename and move the certificates into a directory.

```bash
sudo mkdir -p /etc/ssl/nginx-manager
sudo cp ca.pem /etc/ssl/nginx-manager/ca.pem
sudo cp server.crt /etc/ssl/nginx-manager/nginx-manager.crt
sudo cp server.key /etc/ssl/nginx-manager/nginx-manager.key
sudo cp agent.crt /etc/ssl/nginx-manager/
sudo cp agent.key /etc/ssl/nginx-manager/
```

7. Add the ca.pem to the trusted store

```bash
sudo cp /etc/ssl/nginx-manager/ca.pem /etc/pki/ca-trust/source/anchors/nim-ca.crt
sudo update-ca-trust
```

### Using Instance Manager for mTLS {#native-mtls}

Instance Manager provides a way to load certificates for client certificates and mTLS natively. This method is easy to get started with. However, it may be harder to integrate with existing solutions or the provided advanced security options (such as certificate revocation and rotation).

Setup the nginx-manager to utilize the server.crt,key and ca from above. Edit the nginx-manager.conf similar to the below example. The server_name field is needed to match the SAN name we used in the server.crt generation.

<details>
    <summary>/etc/nginx-agent/nginx-manager.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/noauth/nginx-manager.conf" "nginx-manager.conf">}}
```yaml {hl_lines=[15,17,19]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "localhost")
bind_address: 0.0.0.0
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL server name for use with cert and key below (optional)
server_name: nginx-manager.example.com
# path to x.509 certificate file (optional)
cert: /etc/ssl/nginx-manager/server.crt
# path to x.509 certificate key file (optional)
key: /etc/ssl/nginx-manager/server.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/
```
</details>

Restarting the nginx-manager will pickup the encryption options but you also need to update all the nginx-agent endpoints to utilize certificates.

In our nginx1 example instance, modify the nginx-agent.conf file to resemble the example below. Note the tls options we configure. The enable:true indicates we want grpc to be secured. In addition, when we specify the cert and key, we tell the nginx-agent to use client cert authentication with the nginx-manager. Finally, we also add the ca.pem since we generated the certificates off this ca (which must be the same for both the client and server). If the CA was publicly trusted, we could omit the ca option.

<details>
    <summary>/etc/nginx-agent/nginx-agent.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/noauth/nginx-agent.conf" "nginx-agent.conf">}}
```yaml {hl_lines=[8,13,15,17,19]}
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent

# specify the server grpc port to connect to
server: nginx-manager.example.com:10000

# tls options
tls:
  # disable tls for testing
  enable: true
  # path to certificate
  cert: /etc/ssl/nginx-manager/agent.crt
  # path to certificate key
  key: /etc/ssl/nginx-manager/agent.key
  # path to CA cert
  ca: /etc/ssl/nginx-manager/ca.pem
log:
  # set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
  level: info
  # set log path. if empty, don't log to file.
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
# tags:
# - web
# - staging
# - etc
# list of allowed config directories (comma-separated)
# config_dirs: /etc/nginx,/usr/local/etc/nginx
# nginx configuration options
nginx:
  # path of nginx to manage
  bin_path: /usr/sbin/nginx
  # specify stub status URL (see: nginx.org/r/stub_status)
  stub_status: "http://localhost:8080/nginx_status"
  # specify plus status api url (see nginx.org/r/api)
  plus_api: "http://localhost:8080/api"
```
</details>

Restart the agent and you should have gRPC utilizing client authentication. This setup also forces you to use SSL for the UI/API (server-side SSL only).

### Leverage NGINX for offloading mTLS {#nginx-mtls}

Having NGINX proxy the client certs allows you to offload the encryption tasks which can help with performance and scaling. In this method we can utilize NGINX Plus or NGINX Open Source and will have nginx-manager listen on 127.0.0.1 without encryption, allowing NGINX to listen on the public IP and verify client certificates. You can also combine the method above with this method to secure communications end-to-end.

Configure the nginx-manager to only listen on 127.0.0.1 and use unencrypted communication. This is the default from a fresh installation. Leave the cert and key options commented out. To verify configure the nginx-manager.conf to resemble the following example.

<details>
    <summary>/etc/nginx-agent/nginx-manager.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/offload/nginx-manager.conf" "nginx-manager.conf">}}
```yaml {hl_lines=[8]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "127.0.0.1")
bind_address: 127.0.0.1
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# path to x.509 certificate file (optional)
# cert: /etc/ssl/nginx-manager/nginx-manager.crt
# path to x.509 certificate key file (optional)
# key: /etc/ssl/nginx-manager/nginx-manager.key
# path to x.509 certificate key file (optional)
# key: /etc/ssl/nginx-manager/server.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/
```
</details>

Configure the NGINX Plus instance running on the nginx-manager with a grpc conf similar to the following example. Reload nginx (systemctl reload nginx) and now nginx should be listening on 10443 for grpc(s) communication. Note the options to verify client and for the depth in the example below.

{{<warning>}}If the NGINX Controller Agent has issues starting, try using the stream method explained below to avoid them.{{</warning>}}
</br>

{{<tabs name="grpc-proxying">}}
{{%tab name="grpc http context"%}}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-grpc.conf</summary>

{{<fa "download">}} [nginx-manager-grpc.conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-grpc.conf)
```nginx {hl_lines=["29-31"]}
# nginx-manager-grpc.conf
# nginx-manager-grpc.conf
# Proxy grpc through tcp 10002 to 127.0.0.1 on nginx-manager
# Can have SSL added
# Replace 10002 with the port you want to use externally

log_format grpc_json escape=json '{"timestamp":"$time_iso8601","client":"$remote_addr",'
                                  '"uri":"$uri","http-status":$status,'
                                  '"grpc-status":$grpc_status,"upstream":"$upstream_addr"'
                                  '"rx-bytes":$request_length,"tx-bytes":$bytes_sent}';

map $upstream_trailer_grpc_status $grpc_status {
    default $upstream_trailer_grpc_status; # We normally expect to receive 
                                           # grpc-status as a trailer
    ''      $sent_http_grpc_status;        # Else use the header, regardless of 
                                           # who generated it
}

map $status $loggable {
    ~^[23]  0;
    default 1;
}

map $http_upgrade $connection_upgrade {
        default upgrade;
        ''        close;
}

# gRPC Client requirements set
client_max_body_size 0;
client_body_timeout 7d;

server {
    status_zone nginx-manager_grpc;
    listen 10443 http2 ssl;
    server_name nginx-manager.example.com;

    access_log /var/log/nginx/grpc-access.log grpc_json; # Alternate log location and format

    ssl_certificate         /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key     /etc/ssl/nginx-manager/nginx-manager.key;

    ssl_verify_client       on;
    # ssl_verify_depth        2;
    ssl_client_certificate  /etc/ssl/nginx-manager/ca.pem;

    ssl_session_timeout     24h;
    ssl_session_cache       shared:GRPC:10m;
    ssl_session_tickets     off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers     ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    #ssl_prefer_server_ciphers   off;

    # add_header Strict-Transport-Security "max-age=63072000" always;

    location / {
        grpc_pass grpc://nginx-manager_grpc_servers; # grpcs for secure and grpc for insecure
        # grpc_bind $remote_addr transparent;
        health_check type=grpc grpc_status=12; # 12=unimplemented
    }

    include conf.d/errors.grpc_conf; # gRPC-compliant error responses
    default_type application/grpc;   # Ensure gRPC for all error responses

    upstream nginx-manager_grpc_servers {
        zone nginx-manager_grpc 64k;
        server 127.0.0.1:10000;
        keepalive 20;
}

# vim: syntax=nginx
```
</details>

<details>
    <summary>/etc/nginx/conf.d/errors.grpc_conf</summary>

{{<fa "download">}} [errors.grpc_conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/errors.grpc_conf)
```nginx
# Standard HTTP-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/http-grpc-status-mapping.md
#
error_page 400 = @grpc_internal;
error_page 401 = @grpc_unauthenticated;
error_page 403 = @grpc_permission_denied;
error_page 404 = @grpc_unimplemented;
error_page 429 = @grpc_unavailable;
error_page 502 = @grpc_unavailable;
error_page 503 = @grpc_unavailable;
error_page 504 = @grpc_unavailable;

# NGINX-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/statuscodes.md
#
error_page 405 = @grpc_internal; # Method not allowed
error_page 408 = @grpc_deadline_exceeded; # Request timeout
error_page 413 = @grpc_resource_exhausted; # Payload too large
error_page 414 = @grpc_resource_exhausted; # Request URI too large
error_page 415 = @grpc_internal; # Unsupported media type;
error_page 426 = @grpc_internal; # HTTP request was sent to HTTPS port
error_page 495 = @grpc_unauthenticated; # Client certificate authentication error
error_page 496 = @grpc_unauthenticated; # Client certificate not presented
error_page 497 = @grpc_internal; # HTTP request was sent to mutual TLS port
error_page 500 = @grpc_internal; # Server error
error_page 501 = @grpc_internal; # Not implemented

# gRPC error responses
# Ref: https://github.com/grpc/grpc-go/blob/master/codes/codes.go
#
location @grpc_deadline_exceeded {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' *';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 4;
    add_header          'grpc-message' 'deadline exceeded';
    return 204;
}

location @grpc_permission_denied {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 7;
    add_header          'grpc-message' 'permission denied';
    return              204;
}

location @grpc_resource_exhausted {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 8;
    add_header          'grpc-message' 'resource exhausted';
    return              204;
}

location @grpc_unimplemented {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 12;
    add_header          'grpc-message' unimplemented;
    return              204;
}

location @grpc_internal {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 13;
    add_header          'grpc-message' 'internal error';
    return              204;
}

location @grpc_unavailable {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 14;
    add_header          'grpc-message' 'unavailable';
    return              204;
}

location @grpc_unauthenticated {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 16;
    add_header          'grpc-message' '401. Unauthorized.';
    return              200;
}

# vim: syntax=nginx
```
</details><br/>

{{%/tab%}}
{{%tab name="stream context"%}}

Enable the stream module if it's not already enabled in the `nginx.conf` configuration. Use a file similar to the following example for configuring a stream context for gRPC proxying. Add the proper include line.

<details>
    <summary>/etc/nginx/nginx.conf</summary>

{{<fa "download">}} [nginx.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx.conf)
```nginx {hl_lines=["33-35"]}
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log notice;
pid /var/run/nginx.pid;

load_module modules/ngx_http_js_module.so;
load_module modules/ngx_stream_js_module.so;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referrer" ' '"$http_user_agent" "$http_x_forwarded_for"';
    # NGINX Plus Additional NGINX Metrics
    log_format main_ext '$remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referrer" "$http2" ' '"$http_user_agent" "$http_x_forwarded_for" ' '"$host" sn="$server_name" ' 'rt=$request_time ' 'ua="$upstream_addr" us="$upstream_status" ' 'ut="$upstream_response_time" ul="$upstream_response_length" ' 'cs=$upstream_cache_status $request_id';

    # access_log  /var/log/nginx/access.log  main; # Default
    access_log /var/log/nginx/access.log main_ext; # NGINX Plus Additional NGINX Metrics

    sendfile on;
    #tcp_nopush     on;
    keepalive_timeout 65;
    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}

stream {
    include /etc/nginx/stream.conf.d/*.conf;
}
```
</details>

Create a `stream.conf.d` directory and add the following file to the directory.

<details>
    <summary>/etc/nginx/stream.conf.d/nginx-grpc-stream.conf</summary>

{{<fa "download">}} [nginx-grpc-stream.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-grpc-stream.conf)
```nginx
# nginx-grpc-stream.conf

upstream nginx-manager_stream_grpc_servers {
    zone nginx-manager_stream_grpc 64k;
    server 127.0.0.1:10000;
}

server {
    listen 10443;
    status_zone nginx-manager.example.com_grpc;

    # error_log /var/log/nginx/stream-error.log debug;
    proxy_pass nginx-manager_stream_grpc_servers;
}

# vim: syntax=nginx
```
</details><br/>

{{%/tab%}}
{{</tabs>}}

On our example nginx-1.example.com instance, edit the nginx-agent.conf to resemble the following example.

<details>
    <summary>/etc/nginx-agent/nginx-agent.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-agent.conf" "nginx-agent.conf">}}
```yaml {hl_lines=[8,13,15,17,19]}
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent

# specify the server grpc port to connect to
server: nginx-manager.example.com:10443

# tls options
tls:
  # disable tls for testing
  enable: true
  # path to certificate
  cert: /etc/ssl/nginx-manager/agent.crt
  # path to certificate key
  key: /etc/ssl/nginx-manager/agent.key
  # path to CA cert
  ca: /etc/ssl/nginx-manager/ca.pem
log:
  # set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
  level: info
  # set log path. if empty, don't log to file.
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
# tags:
# - web
# - staging
# - etc
# list of allowed config directories (comma-separated)
# config_dirs: /etc/nginx,/usr/local/etc/nginx
# nginx configuration options
nginx:
  # path of nginx to manage
  bin_path: /usr/sbin/nginx
  # specify stub status URL (see: nginx.org/r/stub_status)
  stub_status: "http://localhost:8080/nginx_status"
  # specify plus status api url (see nginx.org/r/api)
  plus_api: "http://localhost:8080/api"
```
</details>

Restart the agent and verify through the logs, or by using the browser interface or API,  that we can receive metrics and configuration data. Client cert authentication is now taking place through the NGINX proxy.

### Leverage NGINX Plus for advanced mTLS {#nginx-plus-mtls}

Using NGINX Plus allows all the features of mTLS but adds the ability to work with other providers, rotate certificates and leverage key-value stores and technologies that can improve performance and security. In this method, NGINX Plus will handle the grpc communications and pass the traffic back internally to nginx-manager. You can pass the traffic back unencrypted also combining the method above.

This is very similar to the method [above](#nginx-mtls) but we will enable nginx-manager to run securely and modify the nginx proxy to use grpcs instead of grpc.

Edit the nginx-manager.conf to resemble the following example to secure traffic. Note we use 127.0.0.1 instead of 0.0.0.0. This means we only listen on 127.0.0.1 but we use the secure communications path. We leverage the server_name option to match the SAN we used. We could use a separate crt and key also which differs from the proxy crt/key but for now we use the same.

<details>
    <summary>/etc/nginx-agent/nginx-manager.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-manager.conf" "nginx-manager.conf">}}
```yaml {hl_lines=[8,15,17,19]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "localhost")
bind_address: 127.0.0.1
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL server name for use with cert and key below (optional)
server_name: nginx-manager.example.com
# path to x.509 certificate file (optional)
cert: /etc/ssl/nginx-manager/server.crt
# path to x.509 certificate key file (optional)
key: /etc/ssl/nginx-manager/server.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/
```
</details>

Restarting the nginx-manager now enables secure communication but only internally. Configure the nginx plus instance with a conf file similar to the example below to listen on 10443 for grpcs traffic. Note the proxy option to use grpcs instead of grpc here. You don't need the grpc crt, key, and ca options here but they're listed and commented in case you want to leverage multiple certificates that differ on the internal leg.

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-grpc.conf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/nginx-manager-grpc.conf" "nginx-manager-grpc.conf">}}
```nginx {hl_lines=[37,"39-41","43-45","47-49","51-53"]}
# nginx-manager-grpc.conf
# Proxy grpc through tcp 10002 to 127.0.0.1 on nginx-manager
# Can have SSL added
# Replace 10002 with the port you want to use externally

log_format grpc_json escape=json '{"timestamp":"$time_iso8601","client":"$remote_addr",'
                                  '"uri":"$uri","http-status":$status,'
                                  '"grpc-status":$grpc_status,"upstream":"$upstream_addr"'
                                  '"rx-bytes":$request_length,"tx-bytes":$bytes_sent}';

map $upstream_trailer_grpc_status $grpc_status {
    default $upstream_trailer_grpc_status; # We normally expect to receive 
                                           # grpc-status as a trailer
    ''      $sent_http_grpc_status;        # Else use the header, regardless of 
                                           # who generated it
}

map $status $loggable {
    ~^[23]  0;
    default 1;
}

map $http_upgrade $connection_upgrade {
        default upgrade;
        ''        close;
}

# gRPC Client requirements set
client_max_body_size 0;
client_body_timeout 7d;

server {
    listen 10443 http2 ssl;
    server_name nginx-manager.example.com;
    status_zone  nginx-manager_grpc_clientssl;

    access_log /var/log/nginx/grpc-access.log grpc_json; # Alternate log location and format

    ssl_certificate         /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key     /etc/ssl/nginx-manager/nginx-manager.key;
    ssl_client_certificate  /etc/ssl/nginx-manager/ca.pem;

    ssl_verify_client       on;
    ssl_verify_depth      2;
    ssl_client_certificate  /etc/ssl/nginx-manager/ca.pem;

    ssl_session_timeout     24h;
    ssl_session_cache       shared:GRPC:10m;
    ssl_session_tickets     off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers     ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers   off;

    # add_header Strict-Transport-Security "max-age=63072000" always;

    location / {
        grpc_pass grpc://nginx-manager_grpc_servers; # Adjust to grpcs for SSL
        # grpc_bind $remote_addr transparent;
        health_check type=grpc grpc_status=12; # 12=unimplemented
    }

    # Error responses
    include conf.d/errors.grpc_conf; # gRPC-compliant error responses
    default_type application/grpc;   # Ensure gRPC for all error responses    
}

upstream nginx-manager_grpc_servers {
        zone nginx-manager_grpc 64k;
        server 127.0.0.1:10000;
        keepalive 20;
}

# vim: syntax=nginx
```
</details>

<details>
    <summary>/etc/nginx/conf.d/errors.grpc_conf</summary>

{{<fa "download">}} {{< link "nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/errors.grpc_conf" "errors.grpc_conf">}}
```nginx
# Standard HTTP-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/http-grpc-status-mapping.md
#
error_page 400 = @grpc_internal;
error_page 401 = @grpc_unauthenticated;
error_page 403 = @grpc_permission_denied;
error_page 404 = @grpc_unimplemented;
error_page 429 = @grpc_unavailable;
error_page 502 = @grpc_unavailable;
error_page 503 = @grpc_unavailable;
error_page 504 = @grpc_unavailable;

# NGINX-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/statuscodes.md
#
error_page 405 = @grpc_internal; # Method not allowed
error_page 408 = @grpc_deadline_exceeded; # Request timeout
error_page 413 = @grpc_resource_exhausted; # Payload too large
error_page 414 = @grpc_resource_exhausted; # Request URI too large
error_page 415 = @grpc_internal; # Unsupported media type;
error_page 426 = @grpc_internal; # HTTP request was sent to HTTPS port
error_page 495 = @grpc_unauthenticated; # Client certificate authentication error
error_page 496 = @grpc_unauthenticated; # Client certificate not presented
error_page 497 = @grpc_internal; # HTTP request was sent to mutual TLS port
error_page 500 = @grpc_internal; # Server error
error_page 501 = @grpc_internal; # Not implemented

# gRPC error responses
# Ref: https://github.com/grpc/grpc-go/blob/master/codes/codes.go
#
location @grpc_deadline_exceeded {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' *';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 4;
    add_header          'grpc-message' 'deadline exceeded';
    return 204;
}

location @grpc_permission_denied {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 7;
    add_header          'grpc-message' 'permission denied';
    return              204;
}

location @grpc_resource_exhausted {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 8;
    add_header          'grpc-message' 'resource exhausted';
    return              204;
}

location @grpc_unimplemented {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 12;
    add_header          'grpc-message' unimplemented;
    return              204;
}

location @grpc_internal {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 13;
    add_header          'grpc-message' 'internal error';
    return              204;
}

location @grpc_unavailable {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 14;
    add_header          'grpc-message' 'unavailable';
    return              204;
}

location @grpc_unauthenticated {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 16;
    add_header          'grpc-message' '401. Unauthorized.';
    return              200;
}

# vim: syntax=nginx
```
</details><br/>

Reload the NGINX server (`systemctl reload nginx`) and the new configuration should take effect. Finally, go to your NGINX instance and edit the `nginx-agent.conf` file to resemble the following example (`nginx-1.example.com` in our example).

<details>
    <summary>/etc/nginx-agent/nginx-agent.conf</summary>

{{<fa "download">}} {{< link "/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-agent.conf" "nginx-agent.conf">}}
```yaml {hl_lines=[8,13,15,17,19]}
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent

# specify the server grpc port to connect to
server: nginx-manager.example.com:10443

# tls options
tls:
  # disable tls for testing
  enable: true
  # path to certificate
  cert: /etc/ssl/nginx-manager/agent.crt
  # path to certificate key
  key: /etc/ssl/nginx-manager/agent.key
  # path to CA cert
  ca: /etc/ssl/nginx-manager/ca.pem
log:
  # set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
  level: info
  # set log path. if empty, don't log to file.
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
# tags:
# - web
# - staging
# - etc
# list of allowed config directories (comma-separated)
config_dirs: /etc/nginx,/usr/local/etc/nginx
# nginx configuration options
nginx:
  # path of nginx to manage
  bin_path: /usr/sbin/nginx
  # specify stub status URL (see: nginx.org/r/stub_status)
  stub_status: "http://localhost:8080/nginx_status"
  # specify plus status api url (see nginx.org/r/api)
  plus_api: "http://localhost:8080/api"
```
</details><br/>

{{%heading "grpc"%}}

## grpc Forwarding {#grpc}

NGINX Plus can provide gRPC health checks and forwarding by using a file similar to the one below in the `http conf` directory (usually `conf.d`).

{{<tabs name="grpc-conf">}}
{{%tab name="Publish without Encryption"%}}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-grpc-open.conf</summary>

{{<fa "download">}} [nginx-manager-grpc-open.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-manager-grpc-open.conf)

```nginx {hl_lines=["6-9","11-16","18-21","23-25",32,"35-36","39-41"]}
# nginx-manager-grpc.conf
# Proxy grpc through tcp 10002 to 127.0.0.1 on nginx-manager
# Can have SSL added (internal name must be on certificate used)
# Replace 10002 with the port you want to use externally

log_format grpc_json escape=json '{"timestamp":"$time_iso8601","client":"$remote_addr",'
                                  '"uri":"$uri","http-status":$status,'
                                  '"grpc-status":$grpc_status,"upstream":"$upstream_addr"'
                                  '"rx-bytes":$request_length,"tx-bytes":$bytes_sent}';

map $upstream_trailer_grpc_status $grpc_status {
    default $upstream_trailer_grpc_status; # We normally expect to receive 
                                           # grpc-status as a trailer
    ''      $sent_http_grpc_status;        # Else use the header, regardless of 
                                           # who generated it
}

map $status $loggable {
    ~^[23]  0;
    default 1;
}

# gRPC Client requirements set
client_max_body_size 0;
client_body_timeout 7d;

server {
    status_zone nginx-manager_grpc_grpc;
    listen 10443 http2;
    server_name nginx-manager.example.com;

    access_log /var/log/nginx/nginx-manager-grpc-access.log grpc_json; # Alternate log location and format

    location / {
        grpc_pass grpc://nginx-manager_grpc_servers; # Adjust to grpcs for SSL
        health_check type=grpc grpc_status=12; # 12=unimplemented
    }

    # Error responses
    include conf.d/errors.grpc_conf; # gRPC-compliant error responses
    default_type application/grpc;   # Ensure gRPC for all error responses  
}

upstream nginx-manager_grpc_servers {
        zone nginx-manager_grpc 64k;
        server 127.0.0.1:10000;
        keepalive 20;
        # you must use a server name that matches the certificate for SSL Use
}

# vim: syntax=nginx
```
</details>

<details>
    <summary>/etc/nginx/conf.d/errors.grpc_conf</summary>

{{<fa "download">}} [errors.grpc_conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/errors.grpc_conf)

```nginx
# Standard HTTP-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/http-grpc-status-mapping.md
#
error_page 400 = @grpc_internal;
error_page 401 = @grpc_unauthenticated;
error_page 403 = @grpc_permission_denied;
error_page 404 = @grpc_unimplemented;
error_page 429 = @grpc_unavailable;
error_page 502 = @grpc_unavailable;
error_page 503 = @grpc_unavailable;
error_page 504 = @grpc_unavailable;

# NGINX-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/statuscodes.md
#
error_page 405 = @grpc_internal; # Method not allowed
error_page 408 = @grpc_deadline_exceeded; # Request timeout
error_page 413 = @grpc_resource_exhausted; # Payload too large
error_page 414 = @grpc_resource_exhausted; # Request URI too large
error_page 415 = @grpc_internal; # Unsupported media type;
error_page 426 = @grpc_internal; # HTTP request was sent to HTTPS port
error_page 495 = @grpc_unauthenticated; # Client certificate authentication error
error_page 496 = @grpc_unauthenticated; # Client certificate not presented
error_page 497 = @grpc_internal; # HTTP request was sent to mutual TLS port
error_page 500 = @grpc_internal; # Server error
error_page 501 = @grpc_internal; # Not implemented

# gRPC error responses
# Ref: https://github.com/grpc/grpc-go/blob/master/codes/codes.go
#
location @grpc_deadline_exceeded {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' *';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 4;
    add_header          'grpc-message' 'deadline exceeded';
    return 204;
}

location @grpc_permission_denied {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 7;
    add_header          'grpc-message' 'permission denied';
    return              204;
}

location @grpc_resource_exhausted {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 8;
    add_header          'grpc-message' 'resource exhausted';
    return              204;
}

location @grpc_unimplemented {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 12;
    add_header          'grpc-message' unimplemented;
    return              204;
}

location @grpc_internal {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 13;
    add_header          'grpc-message' 'internal error';
    return              204;
}

location @grpc_unavailable {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 14;
    add_header          'grpc-message' 'unavailable';
    return              204;
}

location @grpc_unauthenticated {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 16;
    add_header          'grpc-message' '401. Unauthorized.';
    return              200;
}

# vim: syntax=nginx
```
</details>

{{%/tab%}}
{{%tab name="Publish with TLS Encryption"%}}

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-grpc-ssl.conf</summary>

{{<fa "download">}} [nginx-manager-grpc-ssl.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-manager-grpc-ssl.conf)
```nginx {hl_lines=["6-9","11-16","18-21","23-26","28-30",37,"39-40","42-44","46-48","51-52","55-57"]}
# nginx-manager-grpc-ssl.conf
# Proxy grpc through tcp 10443 with TLS encryption to local server name on nginx-manager
# nginx-agent will use the cert that Plus presents here in the nginx-agent.conf
# Replace 10443 with the port you want to use externally

log_format grpc_json escape=json '{"timestamp":"$time_iso8601","client":"$remote_addr",'
                                  '"uri":"$uri","http-status":$status,'
                                  '"grpc-status":$grpc_status,"upstream":"$upstream_addr"'
                                  '"rx-bytes":$request_length,"tx-bytes":$bytes_sent}';

map $upstream_trailer_grpc_status $grpc_status {
    default $upstream_trailer_grpc_status; # We normally expect to receive 
                                           # grpc-status as a trailer
    ''      $sent_http_grpc_status;        # Else use the header, regardless of 
                                           # who generated it
}

map $status $loggable {
    ~^[23]  0;
    default 1;
}

map $http_upgrade $connection_upgrade {
        default upgrade;
        ''        close;
}

# gRPC Client requirements set
client_max_body_size 0;
client_body_timeout 7d;

server {
    status_zone         nginx-manager_grpc_grpcs;
    listen              10443 ssl http2;
    server_name         nginx-manager.example.com;

    access_log          /var/log/nginx/nginx-manager-grpc-access.log grpc_json; # Alternate log location and format

    ssl_certificate     /etc/ssl/nginx-manager/public.grpc.crt;   # This cert matches the one in nginx-agent.conf
    ssl_certificate_key /etc/ssl/nginx-manager/public.grpc.key;   

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;

    location / {
        grpc_pass grpc://nginx-manager_grpc_servers; # Adjust to grpcs for SSL
        health_check type=grpc grpc_status=12; # 12=unimplemented
    }

    # Error responses
    include conf.d/errors.grpc_conf; # gRPC-compliant error responses
    default_type application/grpc;   # Ensure gRPC for all error responses   

}

upstream nginx-manager_grpc_servers {
        zone nginx-manager_grpc 64k;
        server 127.0.0.1:10000;
        keepalive 20;
}

# vim: syntax=nginx
```
</details>

<details>
    <summary>/etc/nginx/conf.d/errors.grpc_conf</summary>

{{<fa "download">}} [errors.grpc_conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/errors.grpc_conf)

```nginx
# Standard HTTP-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/http-grpc-status-mapping.md
#
error_page 400 = @grpc_internal;
error_page 401 = @grpc_unauthenticated;
error_page 403 = @grpc_permission_denied;
error_page 404 = @grpc_unimplemented;
error_page 429 = @grpc_unavailable;
error_page 502 = @grpc_unavailable;
error_page 503 = @grpc_unavailable;
error_page 504 = @grpc_unavailable;

# NGINX-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/statuscodes.md
#
error_page 405 = @grpc_internal; # Method not allowed
error_page 408 = @grpc_deadline_exceeded; # Request timeout
error_page 413 = @grpc_resource_exhausted; # Payload too large
error_page 414 = @grpc_resource_exhausted; # Request URI too large
error_page 415 = @grpc_internal; # Unsupported media type;
error_page 426 = @grpc_internal; # HTTP request was sent to HTTPS port
error_page 495 = @grpc_unauthenticated; # Client certificate authentication error
error_page 496 = @grpc_unauthenticated; # Client certificate not presented
error_page 497 = @grpc_internal; # HTTP request was sent to mutual TLS port
error_page 500 = @grpc_internal; # Server error
error_page 501 = @grpc_internal; # Not implemented

# gRPC error responses
# Ref: https://github.com/grpc/grpc-go/blob/master/codes/codes.go
#
location @grpc_deadline_exceeded {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' *';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 4;
    add_header          'grpc-message' 'deadline exceeded';
    return 204;
}

location @grpc_permission_denied {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 7;
    add_header          'grpc-message' 'permission denied';
    return              204;
}

location @grpc_resource_exhausted {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 8;
    add_header          'grpc-message' 'resource exhausted';
    return              204;
}

location @grpc_unimplemented {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 12;
    add_header          'grpc-message' unimplemented;
    return              204;
}

location @grpc_internal {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 13;
    add_header          'grpc-message' 'internal error';
    return              204;
}

location @grpc_unavailable {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 14;
    add_header          'grpc-message' 'unavailable';
    return              204;
}

location @grpc_unauthenticated {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 16;
    add_header          'grpc-message' '401. Unauthorized.';
    return              200;
}

# vim: syntax=nginx
```
</details>

{{%/tab%}}
{{%tab name="Publish with TLS Encryption and grpcs"%}}

To encrypt the internal traffic on the server (only needed if you plan to expose externally or proxy from another instance or require this), you need to add the certificates to the nginx-manager configuration file. Add the certificates and restart the service to enable grpc encryption locally.

<details>
    <summary>/etc/nginx-manager/nginx-manager.conf</summary>

{{<fa "download">}} [nginx-manager.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-manager.conf)
```yaml {hl_lines=[8,15,17,19]}
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "localhost")
bind_address: 127.0.0.1
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL server name for use with cert and key below (optional)
server_name: nginx-manager.example.com
# path to x.509 certificate file (optional)
cert: /etc/ssl/nginx-manager/server.crt
# path to x.509 certificate key file (optional)
key: /etc/ssl/nginx-manager/server.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/
```
</details>

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-grpc-mtls.conf</summary>

{{<fa "download">}} [nginx-manager-grpc-mtls.conf](/nim/previous-versions/static/previous-versions/v1/getting-started/encrypt/nginx-manager-grpc-mtls.conf)
```nginx {hl_lines=["6-9","11-16","18-21","23-26","28-30","37-39","41-43",45,"47-48","51-54","57-59"]}
# nginx-manager-grpcs-mtls.conf
# Proxy grpc through tcp 10443 with TLS encryption to local server name on nginx-manager
# nginx-agent will use the cert that Plus presents here in the nginx-agent.conf
# Replace 10443 with the port you want to use externally

log_format grpc_json escape=json '{"timestamp":"$time_iso8601","client":"$remote_addr",'
                                  '"uri":"$uri","http-status":$status,'
                                  '"grpc-status":$grpc_status,"upstream":"$upstream_addr"'
                                  '"rx-bytes":$request_length,"tx-bytes":$bytes_sent}';

map $upstream_trailer_grpc_status $grpc_status {
    default $upstream_trailer_grpc_status; # We normally expect to receive 
                                           # grpc-status as a trailer
    ''      $sent_http_grpc_status;        # Else use the header, regardless of 
                                           # who generated it
}

map $status $loggable {
    ~^[23]  0;
    default 1;
}

map $http_upgrade $connection_upgrade {
        default upgrade;
        ''        close;
}

# gRPC Client requirements set
client_max_body_size 0;
client_body_timeout 7d;

server {
    status_zone         nginx-manager_grpcs_grpcs;
    listen              10443 ssl http2;
    server_name         nginx-manager.example.com;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers   off;

    access_log          /var/log/nginx/nginx-manager-grpc-access.log grpc_json;   # Alternate log location and format

    ssl_certificate     /etc/ssl/nginx-manager/public.grpc.crt;   # This cert matches the one in nginx-agent.conf
    ssl_certificate_key /etc/ssl/nginx-manager/public.grpc.key;   

    location / {
        grpc_pass                       grpcs://nginx-manager_grpc_servers;   # Adjust to grpcs for SSL
        grpc_ssl_certificate            /etc/ssl/nginx-manager/nginx-manager.crt;   # This cert matches the one in nginx-manager.conf
        grpc_ssl_certificate_key        /etc/ssl/nginx-manager/nginx-manager.key;
        health_check        type=grpc   grpc_status=12;                 # 12=unimplemented
    }

    # Error responses
    include conf.d/errors.grpc_conf; # gRPC-compliant error responses
    default_type application/grpc;   # Ensure gRPC for all error responses  

}

upstream nginx-manager_grpc_servers {
        zone nginx-manager_grpc 64k;
        server nginx-manager:10000; # note the server name above must be on the
        keepalive 20;
}

# vim: syntax=nginx
```
</details>

<details>
    <summary>/etc/nginx/conf.d/errors.grpc_conf</summary>

{{<fa "download">}} [errors.grpc_conf](/nim/previous-versions/static/previous-versions/v1/examples/nginx-manager/errors.grpc_conf)
```nginx
# Standard HTTP-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/http-grpc-status-mapping.md
#
error_page 400 = @grpc_internal;
error_page 401 = @grpc_unauthenticated;
error_page 403 = @grpc_permission_denied;
error_page 404 = @grpc_unimplemented;
error_page 429 = @grpc_unavailable;
error_page 502 = @grpc_unavailable;
error_page 503 = @grpc_unavailable;
error_page 504 = @grpc_unavailable;

# NGINX-to-gRPC status code mappings
# Ref: https://github.com/grpc/grpc/blob/master/doc/statuscodes.md
#
error_page 405 = @grpc_internal; # Method not allowed
error_page 408 = @grpc_deadline_exceeded; # Request timeout
error_page 413 = @grpc_resource_exhausted; # Payload too large
error_page 414 = @grpc_resource_exhausted; # Request URI too large
error_page 415 = @grpc_internal; # Unsupported media type;
error_page 426 = @grpc_internal; # HTTP request was sent to HTTPS port
error_page 495 = @grpc_unauthenticated; # Client certificate authentication error
error_page 496 = @grpc_unauthenticated; # Client certificate not presented
error_page 497 = @grpc_internal; # HTTP request was sent to mutual TLS port
error_page 500 = @grpc_internal; # Server error
error_page 501 = @grpc_internal; # Not implemented

# gRPC error responses
# Ref: https://github.com/grpc/grpc-go/blob/master/codes/codes.go
#
location @grpc_deadline_exceeded {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' *';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 4;
    add_header          'grpc-message' 'deadline exceeded';
    return 204;
}

location @grpc_permission_denied {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 7;
    add_header          'grpc-message' 'permission denied';
    return              204;
}

location @grpc_resource_exhausted {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 8;
    add_header          'grpc-message' 'resource exhausted';
    return              204;
}

location @grpc_unimplemented {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 12;
    add_header          'grpc-message' unimplemented;
    return              204;
}

location @grpc_internal {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 13;
    add_header          'grpc-message' 'internal error';
    return              204;
}

location @grpc_unavailable {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 14;
    add_header          'grpc-message' 'unavailable';
    return              204;
}

location @grpc_unauthenticated {
    add_header          'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Transfer-Encoding,Custom-Header-1,X-Accept-Content-Transfer-Encoding,X-Accept-Response-Streaming,X-User-Agent,X-Grpc-Web,Access-Control-Allow-Credentials';
    add_header          'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    # add_header          'Set-Cookie' $auth_cookie;
    add_header          'Access-Control-Expose-Headers' 'Content-Transfer-Encoding,Grpc-Message,Grpc-Status';
    add_header          'Access-Control-Allow-Origin' '*';
    add_header          'Access-Control-Allow-Credentials' 'true';
    add_header          'grpc-status' 16;
    add_header          'grpc-message' '401. Unauthorized.';
    return              200;
}

# vim: syntax=nginx
```
</details>

{{%/tab%}}
{{</tabs>}}