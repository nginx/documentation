---
description: An NGINX Instance Manager quick start document.
docs: DOCS-628
doctypes:
- tutorial
tags:
- docs
title: Quick Start
toc: true
weight: 100
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document helps you get NGINX Instance Manager up and running for a demo or insecure environment.

{{<warning>}}This setup will get you started quickly and leverages an NGINX proxy to handle incoming traffic. If you don't use the proxy and open all ports without controls, anyone can use the API and modify your NGINX Instances. There is also no encryption unless you add it, so data will be unencrypted using this guide. This is usually ok for demos but not for production use. If this is not understood, please use the full installation guide instead.{{</warning>}}

## Prerequisites {#prerequisites}

1. Get the installation packages or binaries.
2. Get license files.
   1. Download NGINX Instance Manager Server license file (for production use)
   2. Download repository certificate and key (for repo access)
3. Create a Linux instance for hosting the NGINX Instance Manager Server.
   1. Ensure the firewall is open for gRPC port and API/GUI port.
   2. Suggested sizing is 2GB Memory, 1 vCPU, and 20GB disk space.
   3. Use CENTOS7 or CENTOS8 for this example (substitute commands for your distribution if you want something else)
4. Generate a certificate for use with HTTPS that includes:
   1. private key
   2. CA chain
   3. server crt

{{%heading "quickstart"%}}

## Install Server {#install-server}

You can choose one of the following two options:

- Use the public NGINX repositories with a certificate and key or internal package management system (like Red Hat Satellite)
- Use the packages directly by downloading them from the myF5 portal or from  NGINX/F5 sales team.

We will go with option 1 because it has fewer steps, and this is a quick start guide.

You will need the packages for NGINX Instance Manager. We will get the repo crt and key to use from [MyF5 Customer Portal](https://account.f5.com/myf5) or use the one provided by your NGINX Sales Team. You may substitute the repo with just installing the rpm or deb package on your own, but you won't have automatic updates using that method.

1. Place the licenses in the correct (expected) file path.

```bash
# nginx-manager server license
sudo mkdir -p /etc/nginx-manager/

# NGINX Plus licenses so we can run NGINX Plus as a proxy for nginx-manager
sudo mkdir -p /etc/ssl/nginx/
```

2. Copy the license files to the host server.

```bash
ls

nginx-instance-manager.lic
nginx-repo.crt
nginx-repo.key
```

3. Copy the repo files to the `/etc/ssl/nginx/` directory.

```bash
sudo mv nginx-*.crt /etc/ssl/nginx/nginx-repo.crt
sudo mv nginx-*.key /etc/ssl/nginx/nginx-repo.key
```

4. Copy the Instance Manager license file to the `/etc/nginx-manager/` directory.

```bash
sudo mv nginx-instance-manager.lic /etc/nginx-manager/nginx-manager.lic
```

5. Install Prerequisites and Install Instance Manager.

```bash
# Install the required certificate authority dependencies
sudo yum install ca-certificates

# Optional install VIM and SELinux tools (RHEL8 won't have policycoreutils-python)
sudo yum install vim wget policycoreutils-python setroubleshoot-server setools mcstrans

# Install the repository file
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/instance-manager.repo

# Install the Instance Manager server
sudo yum install -y nginx-manager
```

**Troubleshooting Note**: If you have a signing key error, run the following

```bash
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
sudo rpmkeys --import /tmp/nginx_signing.key
```

**SELINUX Note**: If you didn't have SELinux installed, you need to reboot to have it take effect. Change to permissive mode and reboot (it may take a while to relabel contexts, so grab a beverage and sit back.)

```bash
# change to permissive so we don't block anything yet (but we do log)
sudo sed -i.bak 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config && cat /etc/selinux/config
# this next command reboots the system
sudo systemctl reboot
```

## Configure NGINX Instance Manager Server {#configure-server}

1. Add the license file to the `/etc/nginx-manager` directory. Ensure the name matches what is in the `nginx-manager.conf` file. The above example uses `nginx-manager.lic`. This should already be done, but if not, run the following:

```bash
sudo mv nginx-instance-manager.lic /etc/nginx-manager
```

2. Edit the `/etc/nginx-manager/nginx-manager.conf` file and change the bind_address and ports to reflect your choices.
   For example, since we will use NGINX Plus reverse proxy on the same host machine, the following file will listen on `127.0.0.1` localhost IP and use the default ports of `11000` for the user interface and API and `10000` for gRPC.

```bash
# vim or use your own editor here.
sudo vim /etc/nginx-manager/nginx-manager.conf
```

<details>
    <summary>/etc/nginx-manager/nginx-manager.conf</summary>

{{<fa "download">}} {{<link "getting-started/quickstart/nginx-manager.conf" "nginx-manager.conf">}}

```yaml {hl_lines=["5-7"]}
#
# /etc/nginx-manager/nginx-manager.conf
#

bind_address: 127.0.0.1
grpc_port: 10000
gateway_port: 11000

# We will use a NGINX Plus reverse proxy, so leave this commented out
# server_name: nginx-manager.example.com)
# cert: /etc/ssl/nginx-manager/server.crt
# key: /etc/ssl/nginx-manager/server.key

log:
    level: info
    path: /var/log/nginx-manager/
metrics:
    storage_path: /var/nginx-manager/
license: /etc/nginx-manager/nginx-manager.lic
```

</details>

## Install NGINX as a proxy server for Instance Manager {#install-proxy}

NGINX Instance Manager is designed as a web application with an API. NGINX Plus is our recommended solution for web applications requiring advanced authentication, proxy, and load balancing. A copy of NGINX Plus is included with the NGINX Instance Manager distribution as a frontend for NGINX Instance Manager. This is the only permitted use of the included NGINX Plus instance. For external uses and other systems, contact your sales team to purchase additional subscriptions.

For additional installation options for using NGINX Plus or NGINX as a front-end for NGINX Instance Manager, refer to the [encryption]({{<relref "encrypt.md">}}) and [authentication]({{<relref "auth.md">}}) documents.

The repository certificate and key (`nginx-repo.crt` and `nginx-repo.key`) can be used to pull an nginx-plus package that is used to proxy connections to `nginx-manager`. To setup NGINX Plus, use the included certificate and key (it may be easier to copy them into `/etc/ssl/nginx/nginx-repo.crt` and `/etc/ssl/nginx/nginx-repo.key`) and follow the [NGINX Plus Installation Steps](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/#install_rhel_centos).

1. Verify that you `nginx-repo.crt` and `nginx-repo.key` files are in the `/etc/ssl/nginx/` directory.

2. Install NGINX Plus.

```bash
# If you installed nginx-manager from the package and not the repo and have a different machine or plus subscription, download the following repo
# sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
sudo yum install -y nginx-plus
```

**Troubleshooting Note**: If you can't access or download nginx-plus you can either use nginx OSS for now or download a trial of nginx-plus and use that rpm. If you're simply testing Instance Manager, the OSS nginx install will be sufficient and can be installed with:

```bash
sudo yum install -y nginx
```

3. Enable the nginx service to start on boot. We will start the service at a later step.

```bash
sudo systemctl enable nginx

# Check the nginx binary version to ensure you have NGINX installed correctly:
nginx -v
```

## Generate Certificates (Optional) {#generate-certs}

Use the following as an example and modify it according to your needs. There are many ways to generate certificates that exist; the examples below are suggestions only.

1. Install OpenSSL if you haven't already. This guide assumes you know how to do that.

2. Use something similar to the below script to set up the certificates you need. Save this script as `make_certs.sh`.

<details>
    <summary>make_certs.sh</summary>

{{<fa "download">}} {{<link "getting-started/quickstart/make_certs.sh" "make_certs.sh">}}

```bash
#!/bin/bash

# Prefix for agent certificates and keys
nginx=agent

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
        -CA ca_int.crt \
        -CAkey ca_int.key \
        -CAcreateserial \
        -in agent.csr \
        -out agent.crt \
        -extfile agent.cnf \
        -extensions v3_req
    openssl verify -CAfile ca.pem agent.crt
    for os in {1..10}
    do
      openssl req \
        -new \
        -newkey rsa:2048 \
        -nodes \
        -keyout $nginx-"$os".key \
        -out $nginx-"$os".csr \
        -config agent.cnf \
        -extensions v3_req
      openssl req -in $nginx-"$os".csr -noout -verify
      openssl x509 \
        -req \
        -days 365 \
        -sha256 \
        -CA ca_int.crt \
        -CAkey ca_int.key \
        -CAcreateserial \
        -in $nginx-"$os".csr \
        -out $nginx-"$os".crt \
        -extfile agent.cnf \
        -extensions v3_req
      openssl verify -CAfile ca.pem $nginx-"$os".crt
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

{{<fa "download">}} {{<link "getting-started/quickstart/ca.cnf" "ca.cnf">}}

```none
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

{{<fa "download">}} {{<link "getting-started/quickstart/ca-intermediate.cnf" "ca-intermediate.cnf">}}

```none
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

{{<fa "download">}} {{<link "getting-started/quickstart/server.cnf" "server.cnf">}}

```none
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

{{<fa "download">}} {{<link "getting-started/quickstart/agent.cnf" "agent.cnf">}}

```none
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

## Configure NGINX Plus as a Reverse Proxy {#configure-proxy}

1. Place or verify certificates are in the correct directories.

```bash
ls -lh /etc/ssl/nginx-manager
#
# -rw-r--r--. 1 centos centos 1.8K Mar 18 18:56 agent.crt
# -rw-r-----. 1 centos centos 1.7K Mar 18 18:56 agent.key
# -rw-r--r--. 1 centos centos 2.1K Mar 18 18:56 ca.pem
# -rw-r--r--. 1 centos centos 2.1K Mar  3 13:10 nginx-manager.crt
# -rw-r-----. 1 centos centos 3.2K Mar  3 13:10 nginx-manager.key

```

2. Add the following config files to nginx include directory `/etc/nginx/conf.d/` as follows (replace the cert paths if necessary to match your setup).

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-https.conf</summary>

{{<fa "download">}} {{<link "getting-started/quickstart/nginx-manager-https.conf" "nginx-manager-https.conf">}}

```nginx
# nginx-manager-https.conf
# Proxy UI/API with no auth to 127.0.0.1 on nginx-manager
# Include the nginx-manager-upstreams.conf for the proxy_pass to work

server {
    #listen 80;
    listen 443 ssl;
    http2 on;
    server_name nginx-manager.example.com;
    status_zone nginx-manager_noauth_https;

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
        health_check uri=/swagger-ui/;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        client_max_body_size 0;
    }
}

# vim: syntax=nginx
```

</details>

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-upstreams.conf</summary>

{{<fa "download">}} {{<link "/examples/nginx-manager/nginx-manager-upstreams.conf" "nginx-manager-upstreams.conf">}}

```nginx
# nginx-manager-upstreams.conf
# Upstreams for NGINX nginx-manager API/UI

upstream nginx-manager_servers {
        zone nginx-manager_servers 64k;
        server 127.0.0.1:11000;
}

# vim: syntax=nginx
```

</details>

<details>
    <summary>/etc/nginx/conf.d/nginx-manager-grpc.conf</summary>

{{<fa "download">}} {{<link "/examples/nginx-manager/nginx-manager-grpc.conf" "nginx-manager-grpc.conf">}}

```nginx
# nginx-manager-grpc.conf
# * Proxy grpc through tcp 10443 to 127.0.0.1 on nginx-manager

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
    status_zone nginx-manager_grpc_clientssl;

    access_log /var/log/nginx/grpc-access.log grpc_json; # Alternate log location and format

    ssl_certificate         /etc/ssl/nginx-manager/nginx-manager.crt;
    ssl_certificate_key     /etc/ssl/nginx-manager/nginx-manager.key;
    # ssl_client_certificate  /etc/ssl/nginx-manager/ca.pem;

    ssl_verify_client       optional;
    # ssl_verify_depth      2;
    ssl_client_certificate  /etc/ssl/nginx-manager/ca.pem;

    ssl_session_timeout     24h;
    ssl_session_cache       shared:GRPC:10m;
    ssl_session_tickets     off;

    ssl_protocols   TLSv1.2 TLSv1.3;
    ssl_ciphers     ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    #ssl_prefer_server_ciphers   off;

    # add_header Strict-Transport-Security "max-age=63072000" always;

    location / {
        grpc_pass grpc://nginx-manager_grpc_servers;
        # grpc_bind $remote_addr    transparent;
        health_check type=grpc grpc_status=12; # 12=unimplemented
    }

    # Error responses
    include conf.d/errors.grpc_conf; # gRPC-compliant error responses
    default_type application/grpc;   # Ensure gRPC for all error responses
}

upstream nginx-manager_grpc_servers {
        zone nginx-manager_grpc 64k;
        server 127.0.0.1:10000;
}

# vim: syntax=nginx
```

</details>

<details>
    <summary>/etc/nginx/conf.d/errors.grpc_conf</summary>

{{<fa "download">}} {{<link "/examples/nginx-manager/errors.grpc_conf" "errors.grpc_conf">}}

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

<details>
    <summary>/etc/nginx/conf.d/status-api.conf</summary>

{{<fa "download">}} {{<link "/examples/nginx-manager/status-api.conf" "status-api.conf">}}

```nginx
# status-api.conf
# This sample NGINX Plus configuration enables the NGINX Plus API, for live
# activity monitoring and the built-in dashboard, dynamic configuration of
# upstream groups, and key-value stores. Keep in mind that any features
# added to the API in future NGINX Plus releases will be enabled
# automatically by this file.
# Created in May 2018 by NGINX, Inc. for NGINX Plus R14 and later.

# Documentation:
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/
# https://www.nginx.com/blog/live-activity-monitoring-nginx-plus-3-simple-steps

# To conform with the conventional configuration scheme, place this file in
# the /etc/nginx/conf.d directory and add an 'include' directive that
# references it in the main configuration file, /etc/nginx/nginx.conf,
# either by name or with a wildcard expression. Then validate and reload
# the configuration, for example, with this command:
#
#     nginx -t && nginx -s reload

# Note that additional directives are required in other parts of the
# configuration:
#
# For metrics to be gathered for an HTTP or TCP/UDP virtual server, you must
# include the 'status_zone' directive in its 'server' block. See:
# http://nginx.org/r/status_zone
#
# Similarly, for metrics to be gathered for an upstream server group, you
# must include the 'zone' directive in the 'upstream' block. See:
# http://nginx.org/r/zone
#
# For more information and instructions, see:
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring#status_data

# We strongly recommend that you restrict access to the NGINX Plus API so
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
# (4) Enable access from a defined network and disable it from all others
#    by uncommenting the 'allow' and 'deny' directives in the 'server' block
#    below and specifying the appropriate network ranges. See:
#    http://nginx.org/en/docs/http/ngx_http_access_module.html
#
# You can create further restrictions on write operations to distinguish
# between users with read permission and those who can change the configuration.
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
    allow 127.0.0.1;
    deny all;

    location /nginx_status {
        stub_status;
    }

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

3. Replace the `default.conf` hello world page with a blank file

```bash
sudo cp /dev/null default.conf
```

4. Verify all nginx files are present in `/etc/nginx/conf.d` directory

```bash
ls -lh /etc/nginx/conf.d

total 10K
-rw-r--r--. 1 root root    0 Jul  1 12:37 default.conf
-rw-r--r--. 1 root root 2.2K Jul  1 12:37 errors.grpc_conf
-rw-r--r--. 1 root root 2.5K Jul  1 12:37 nginx-manager-grpc.conf
-rw-r--r--. 1 root root 1.3K Jul  1 12:37 nginx-manager-https.conf
-rw-r--r--. 1 root root 224B Jul  1 12:37 nginx-manager-upstreams.conf
-rw-r--r--. 1 root root 4.2K Jul  1 12:37 status-api.conf
```

## Enable SELinux (Optional) {#selinux}

NGINX Instance Manager also has an SELinux policy module that can be installed on SELinux-enabled systems. It is provided as an RPM and can be pulled from the same repository as the server packages. You can do this manually as well and place ports in the httpd context.

Since we are using NGINX Plus as a reverse proxy, we can add the external ports exposed by NGINX Plus. We will leverage information in the blog [Using NGINX with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).

You should also add them to other firewall exceptions if needed (See next section)

1. Install SELinux Policy Module

```bash
# Install SELinux Policy Module
sudo yum install -y nginx-manager-selinux

# Check SELinux status
sestatus

# SELinux status:                 enabled
# SELinuxfs mount:                /sys/fs/selinux
# SELinux root directory:         /etc/selinux
# Loaded policy name:             targeted
# Current mode:                   enforcing
# Mode from config file:          enforcing
# Policy MLS status:              enabled
# Policy deny_unknown status:     allowed
# Max kernel policy version:      31

# Check NGINX module is loaded
sudo semodule -l | grep nginx

# nginx_manager   1.0.0

```

2. Install dependencies for SELinux -- this shouldn't be needed, but if you skipped the part earlier about it, you can do this.

```bash
# Check which libraries are required for semanage
sudo yum provides /usr/sbin/semanage

# Install with yum
sudo yum install policycoreutils-python setroubleshoot-server setools mcstrans
```

**Troubleshooting Note**: You may need to log out and log in after this, so the next command will work depending on what was installed.

3. Add ports for Instance Manager SELinux context. In this example, we will expose `10000` and `11000` for nginx-manager to listen on `127.0.0.1`

```bash
sudo semanage port -a -t nginx_manager_port_t -p tcp 10000
sudo semanage port -a -t nginx_manager_port_t -p tcp 11000
```

**Troubleshooting Note**: If you already defined the ports, you must modify them with the command below (change `-a` to `-m`).

```bash
sudo semanage port -m -t nginx_manager_port_t -p tcp 10000
sudo semanage port -m -t nginx_manager_port_t -p tcp 11000
```

4. Confirm the SELinux policy is applied for the ports for `nginx_manager_port_t`.

```bash
sudo semanage port -l | grep nginx_manager_port_t
# nginx_manager_port_t           tcp      11000, 10000
```

5. Add ports for NGINX proxy to listen on ports. This example will expose `10443` and `443` for the nginx proxy to listen externally.

```bash
# port 443 is already part of the httpd context by default, we only need to add non-standard ports
sudo semanage port -a -t http_port_t -p tcp 10443
sudo semanage port -a -t http_port_t -p tcp 8080
```

6. Confirm the SELinux policy is applied for the ports for `nginx`.

```bash
sudo semanage port -l | grep http_port_t
# http_port_t                    tcp      10443, 8080, 80, 443
```

7. Open firewall ports if using a firewall. For the default Centos7 install, there is no firewall running by default.

### SELinux is too hard {#selinux-hard}

If you're still feeling the urge to just disable SELinux, please don't. SELinux will limit the damage done to privilege escalations and attacks significantly. It mitigates many 0-day attacks. If enforcing doesn't work, you can allow just the nginx-manager to work (and nginx) to be permissive and keep enforcing on. Finally, you can make everything permissive, which doesn't protect you but lets you log privilege attempts.

1. Temporarily disabling SELinux for NGINX and nginx-manager

```bash
sudo semanage permissive -a httpd_t
sudo semanage permissive -a nginx-manager
```

## Start services {#service-start}

1. Start and enable NGINX

```bash
sudo systemctl enable nginx --now
```

2. Start and enable nginx-manager

```bash
sudo systemctl enable nginx-manager --now
```

## Install an agent {#agent-install}

You can use this procedure on an endpoint, but since we are running nginx on the nginx-manager, we can install the agent there and manage the proxy through nginx-manager.

1. Install the repository file.

```bash
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-agent.repo
```

2. Install the nginx-agent package

```bash
sudo yum install -y nginx-agent
```

If you have a signing key error, run the following:

```bash
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
sudo rpmkeys --import /tmp/nginx_signing.key
```

3. Configure the `nginx-agent` configuration file

<details>
    <summary>/etc/nginx-agent/nginx-agent.conf</summary>

{{<fa "download">}} {{<link "getting-started/quickstart/nginx-agent.conf" "nginx-agent.conf">}}

```yaml
#
# /etc/nginx-agent/nginx-agent.conf
#

server: nginx-manager.example.com:10443
tls:
  enable: true
  cert: /etc/ssl/nginx-manager/agent.crt
  key: /etc/ssl/nginx-manager/agent.key
  ca: /etc/ssl/nginx-manager/ca.pem
log:
  level: info
  path: /var/log/nginx-agent/
# * add directories we can write files to below
config_dirs: /etc/nginx,/etc/ssl/nginx-manager
nginx:
  bin_path: /usr/sbin/nginx
  stub_status: "http://127.0.0.1:8080/nginx_status"
  plus_api: "http://127.0.0.1:8080/api"
metrics_poll_interval: 1000ms
# * specify access logs to exclude from metrics (comma separated)
# exclude_logs: /var/log/nginx/skipthese*,/var/log/nginx/special-access.log

```

</details><br/>

4. Install Selinux Module (Optional) {#agent-selinux}

```bash
sudo yum install -y nginx-agent-selinux
```

5. Start and enable the nginx-agent service

```bash
sudo systemctl enable nginx-agent --now
```

## Access the GUI {#access-server-gui}

Point your browser to the FQDN and port you configured Instance Manager on. If your server name is `nim.example.com` and the port is `443`, then your browser can access the web interface at `https://nim.example.com`.

## Access the Swagger-UI API {#access-server-api}

To access the swagger-ui page, simply append '/swagger-ui' to the end of the URL. For example, the server above would be `https://nim.example.com/swagger-ui`.

## Access the metrics endpoint {#access-server-metrics}

To access metrics through Grafana or Prometheus, configure the data source as a Prometheus endpoint and add '/metrics' to the end of the URL. For example, the server above would be https://nim.example.com/metrics.

## What's Next

- Configure Authentication on the Server
- Configure nginx-agent on nginx instances
- Use Grafana to display metrics
- Scan a network range for new instances
