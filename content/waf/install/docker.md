---
# We use sentence case and present imperative tone
title: "Docker"
# Weights are assigned in increments of 100: determines sorting order
weight: 400
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes how to install F5 WAF for NGINX using Docker. 

## Before you begin

To complete this guide, you will need the following prerequisites:

- An active F5 WAF for NGINX subscription (Purchased or trial)
- [Docker](https://docs.docker.com/get-started/get-docker/)

You should read the [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) and [Secure traffic using mTLS]({{< ref "/waf/configure/secure-mtls.md" >}}) topics for additional set-up configuration if you want to use them immediately.

To review supported operating systems, read the [Technical specifications]({{< ref "/waf/fundamentals/technical-specifications.md" >}}) topic.

{{< include "waf/install-selinux-warning.md" >}}

## Docker deployment options

There are three kinds of Docker deployments available:

- Multi-container configuration
- Hybrid configuration
- Single container configuration

The multi-container configuration is recommended if you are building a new system, and deploys the F5 for WAF module and its components in separate images, allowing for nuanced version management.

The hybrid configuration is suitable if you want to add F5 WAF for NGINX to an existing virtual environment and wish to use Docker for the F5 WAF components instead of installing and configuring WAF packages as explained in the [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md" >}}) instructions.

The single container configuration only supports NGINX Plus and requires a building a Docker image that encapsulates all parts of the system. This image will need to be rebuilt with each release.

The steps you should follow on this page are dependent on your configuration type: after the shared steps, links will guide you to the next appropriate section.

## Download your subscription credentials 

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

## Configure Docker for the F5 Container Registry

{{< include "waf/install-services-registry.md" >}}

You should now move to the section based on your configuration type:

- [Multi-container configuration](#multi-container-configuration)
- [Hybrid configuration](#hybrid-configuration)
- [Single container configuration](#single-container-configuration)

## Multi-container configuration

### Create configuration files

{{< include "waf/install-create-configuration.md" >}}

{{< tabs name="configuration-files-multi" >}}

{{% tab name="nginx.conf" %}}

```nginx {hl_lines=[4, 26, 27, 28]}
user nginx;

worker_processes auto;
load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections 10240;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    upstream app_backend_com {
        server 192.168.0.1:8000;
        server 192.168.0.1:8001;
    }
    server {
        listen 80;
        server_name app.example.com;

        app_protect_enable on;
        app_protect_security_log_enable on;
        app_protect_security_log "/etc/nginx/custom_log_format.json" syslog:server=127.0.0.1:514;

        location / {
            client_max_body_size 0;
            default_type text/html;
            # set your backend here
            proxy_pass http://app_backend_com;
            proxy_set_header Host $host;
        }
    }
}
```

{{% /tab %}}

{{% tab name="entrypoint.sh" %}}

```shell
#!/bin/sh

/bin/su -s /bin/sh -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 >> /var/log/app_protect/bd-socket-plugin.log &" nginx
/usr/sbin/nginx -g 'daemon off;'

# Optional line for the IP intelligence feature
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```

{{% /tab %}}

{{% tab name="custom_log_format.json" %}}

```json
{
    "filter": {
        "request_type": "all"
    },
    "content": {
        "format": "splunk",
        "max_request_size": "any",
        "max_message_size": "10k"
    }
}
```

{{% /tab %}}

{{< /tabs >}}

### Create a Dockerfile

In the same folder as your credential and configuration files, create a _Dockerfile_ based on your desired operating system image using an example from the following sections.

Alternatively, you may want make your own image based on a Dockerfile using the official NGINX image:

{{< details summary="Dockerfile based on official image" >}}

This example uses NGINX Open Source as a base: it requires NGINX to be installed as a package from the official repository, instead of being compiled from source.

{{< include "/waf/dockerfiles/official-oss.md" >}}

{{< /details >}}

{{< call-out "note" >}}

If you are not using using `custom_log_format.json` or the IP intelligence feature,  you should remove any references to them from your Dockerfile.

{{< /call-out >}}

#### Alpine Linux

{{< tabs name="alpine-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/alpine-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/alpine-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/amazon-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/amazon-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/debian-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/debian-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### Oracle Linux

{{< tabs name="oracle-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/oracle-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/oracle-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/ubuntu-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/ubuntu-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### RHEL 8

{{< tabs name="rhel8-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rhel8-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rhel8-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### RHEL 9

{{< tabs name="rhel9-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rhel9-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rhel9-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

#### Rocky Linux 9

{{< tabs name="rocky-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rocky9-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rocky9-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Build the Docker image

{{< include "waf/install-build-image.md" >}}

### Update configuration files

Once you have installed F5 WAF for NGINX, you must load it as a module in the main context of your NGINX configuration.

```nginx
load_module modules/ngx_http_app_protect_module.so;
```

The Enforcer address must be added at the _http_ context:

```nginx
app_protect_enforcer_address 127.0.0.1:50000;
```

And finally, F5 WAF for NGINX can enabled on a _http_, _server_ or _location_ context:

```nginx
app_protect_enable on;
```

{{< call-out "warning" >}}

You should only enable F5 WAF for NGINX on _proxy_pass_ and _grpc_pass_ locations.

{{< /call-out >}}

Here are two examples of how these additions could look in configuration: some of them may already exist from when you created the files.

{{< tabs name="example-configuration-files-multi" >}}

{{% tab name="nginx.conf" %}}

The default path for this file is `/etc/nginx/nginx.conf`.

```nginx {hl_lines=[5, 33]}
user  nginx;
worker_processes  auto;

# F5 WAF for NGINX
load_module modules/ngx_http_app_protect_module.so;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # F5 WAF for NGINX
    app_protect_enforcer_address 127.0.0.1:50000;

    include /etc/nginx/conf.d/*.conf;
}
```

{{% /tab %}}

{{% tab name="default.conf" %}}

The default path for this file is `/etc/nginx/conf.d/default.conf`.

```nginx {hl_lines=[10]}
server {
    listen 80;
    server_name domain.com;


    location / {

        # F5 WAF for NGINX
        app_protect_enable on;

        client_max_body_size 0;
        default_type text/html;
        proxy_pass http://127.0.0.1:8080/;
    }
}

server {
    listen 8080;
    server_name localhost;


    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

{{% /tab %}}

{{< /tabs >}}

Once you have updated your configuration files, you can reload NGINX to apply the changes. You have two options depending on your environment:

- `nginx -s reload`
- `sudo systemctl reload nginx`

### Configure Docker

{{< include "waf/install-services-docker.md" >}}

#### Download Docker images

{{< include "waf/install-services-images.md" >}}

#### Create and run a Docker Compose file

Create a _docker-compose.yml_ file with the following contents in your host environment, replacing image tags as appropriate:

```yaml
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
    - ./license.jwt:/etc/nginx/license.jwt # Only necessary when using NGINX Plus
    networks:
    - waf_network
    ports:
    - "80:80"

  waf-enforcer:
    container_name: waf-enforcer
    image: waf-enforcer:5.2.0
    environment:
      - ENFORCER_PORT=50000
    ports:
      - "50000:50000"
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always

  waf-config-mgr:
    container_name: waf-config-mgr
    image: waf-config-mgr:5.2.0
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /opt/app_protect/config:/opt/app_protect/config
      - /etc/app_protect/conf:/etc/app_protect/conf
    restart: always
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

networks:
  waf_network:
    driver: bridge
```

To start the F5 WAF for NGINX services, use `docker compose up` in the same folder as the _docker-compose.yml_ file:

```shell
sudo docker compose up -d
```

You can now review the operational status of F5 WAF for NGINX using the [Post-installation checks]({{< ref "/waf/install/docker.md#post-installation-checks" >}}).

## Hybrid configuration

### Additional requirements

Besides the prerequisites outlined in the [Before you begin](#before-you-begin) section, you will require:

- A working [NGINX Open Source]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}}) or [NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) instance.

### Install F5 WAF for NGINX packages

Navigate to your chosen operating system, which are alphabetically ordered.

#### Alpine Linux

{{< tabs name="alpine-hybrid-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "https://pkgs.nginx.com/app-protect-x-oss/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apk update
sudo apk add app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "https://pkgs.nginx.com/app-protect-x-plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apk update
sudo apk add openssl ca-certificates app-protect-module-plus
```

{{% /tab %}}

{{< /tabs >}}

#### Amazon Linux

{{< tabs name="amazon-hybrid-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Create a file for the F5 WAF for NGINX repository:

`/etc/yum.repos.d/app-protect-x-oss.repo`

```shell
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/amzn/2023/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Create a file for the F5 WAF for NGINX repository:

`/etc/yum.repos.d/app-protect-x-plus.repo`

```shell
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/amzn/2023/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-plus
```

{{% /tab %}}

{{< /tabs >}}

#### Debian

{{< tabs name="debian-hybrid-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-oss/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Add the F5 WAF for NGINX repository:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-plus/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-plus
```

{{% /tab %}}

{{< /tabs >}}

#### Oracle Linux / RHEL / Rocky Linux 8

{{< call-out "important" >}}

The steps are identical for these platforms due to their similar architecture.

{{< /call-out >}}

{{< tabs name="oracle-hybrid-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Create a file for the F5 WAF for NGINX repository:

`/etc/yum.repos.d/app-protect-x-oss.repo`

```shell
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo yum install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Create a file for the F5 WAF for NGINX repository:

`/etc/yum.repos.d/app-protect-x-plus.repo`

```shell
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-plus
```

{{% /tab %}}

{{< /tabs >}}

#### Ubuntu

{{< tabs name="ubuntu-hybrid-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-oss/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
```

Update the repository, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect-module-plus
```

{{% /tab %}}

{{< /tabs >}}

#### RHEL / Rocky Linux 9

{{< tabs name="rhel-hybrid-instructions" >}}

{{% tab name="NGINX Open Source" %}}

Create a file for the F5 WAF for NGINX repository:

`/etc/yum.repos.d/app-protect-x-oss.repo`

```shell
[app-protect-x-oss]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo yum install app-protect-module-oss
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

Create a file for the F5 WAF for NGINX repository:

`/etc/yum.repos.d/app-protect-x-plus.repo`

```shell
[app-protect-x-plus]
name=nginx-app-protect repo
baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/$basearch/
sslclientcert=/etc/ssl/nginx/nginx-repo.crt
sslclientkey=/etc/ssl/nginx/nginx-repo.key
gpgcheck=0
enabled=1
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect-module-plus
```

{{% /tab %}}

{{< /tabs >}}

### Configure Docker

{{< include "waf/install-services-docker.md" >}}

#### Download Docker images

{{< include "waf/install-services-images.md" >}}

#### Create and run a Docker Compose file

{{< include "waf/install-services-compose.md" >}}

F5 WAF for NGINX should now be operational, and you can move onto [Post-installation checks](#post-installation-checks).

## Single container configuration

### Create configuration files

{{< include "waf/install-create-configuration.md" >}}

{{< tabs name="configuration-files-single" >}}

{{% tab name="nginx.conf" %}}

```nginx {hl_lines=[4, 26, 27, 28]}
user nginx;

worker_processes auto;
load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections 10240;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    upstream app_backend_com {
        server 192.168.0.1:8000;
        server 192.168.0.1:8001;
    }
    server {
        listen 80;
        server_name app.example.com;

        app_protect_enable on;
        app_protect_security_log_enable on;
        app_protect_security_log "/etc/nginx/custom_log_format.json" syslog:server=127.0.0.1:514;

        location / {
            client_max_body_size 0;
            default_type text/html;
            # set your backend here
            proxy_pass http://app_backend_com;
            proxy_set_header Host $host;
        }
    }
}
```

{{% /tab %}}

{{% tab name="entrypoint.sh" %}}

```shell
#!/bin/sh

/bin/su -s /bin/sh -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 >> /var/log/app_protect/bd-socket-plugin.log &" nginx
/usr/sbin/nginx -g 'daemon off;'

# Optional line for the IP intelligence feature
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```

{{% /tab %}}

{{% tab name="custom_log_format.json" %}}

```json
{
    "filter": {
        "request_type": "all"
    },
    "content": {
        "format": "splunk",
        "max_request_size": "any",
        "max_message_size": "10k"
    }
}
```

{{% /tab %}}

{{< /tabs >}}

### Create a Dockerfile

Copy or move your subscription files into a new folder.

In the same folder as the subscription files, create a _Dockerfile_ based on your desired operating system image using an example from the following sections.

{{< call-out "note" >}}

If you are not using using `custom_log_format.json` or the IP intelligence feature,  you should remove any references to them from your Dockerfile.

{{< /call-out >}}

#### Alpine Linux

```dockerfile
# syntax=docker/dockerfile:1
# For Alpine 3.19:
FROM alpine:3.19

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
 && wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub

# Add NGINX Plus repository:
RUN printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Add F5 WAF for NGINX repository:
RUN printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories \
 && printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Update the repository and install the most recent version of the F5 WAF for NGINX package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    apk update && apk add app-protect

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    apk update && apk add app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### Amazon Linux

```dockerfile
# syntax=docker/dockerfile:1
# For Amazon Linux 2023:
FROM amazonlinux:2023

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX Plus repo:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo

# Add NAP dependencies repo:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo

# Add NGINX App-protect repo:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo

# Install F5 WAF for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install app-protect \
    && dnf clean all \
    && rm -rf /var/cache/yum

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### Debian

```dockerfile
ARG OS_CODENAME
# Where OS_CODENAME can be: buster/bullseye/bookworm
# syntax=docker/dockerfile:1
# For Debian 11 / 12:
FROM debian:${OS_CODENAME}

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add NGINX Plus repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-plus.list

# Add F5 WAF for NGINX repositories:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the F5 WAF for NGINX package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && apt-get install -y app-protect

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get install -y app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### Oracle Linux

```dockerfile
# syntax=docker/dockerfile:1
# For Oracle Linux 8:
FROM oraclelinux:8

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates yum-utils

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo

# Enable Yum repositories to pull App Protect dependencies:
RUN dnf config-manager --set-enabled ol8_codeready_builder \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all

# Install F5 WAF for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### RHEL 8

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi8:
FROM registry.access.redhat.com/ubi8/ubi

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all

# Install F5 WAF for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install --enablerepo=codeready-builder-for-rhel-8-x86_64-rpms -y app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### RHEL 9

```dockerfile
# syntax=docker/dockerfile:1
# For Rocky Linux 9:
FROM rockylinux:9

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates 'dnf-command(config-manager)'

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
RUN dnf config-manager --set-enabled crb \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && dnf clean all

# Install F5 WAF for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### Rocky Linux 9

```dockerfile
# syntax=docker/dockerfile:1
# For Rocky Linux 9:
FROM rockylinux:9

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates 'dnf-command(config-manager)'

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
RUN dnf config-manager --set-enabled crb \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && dnf clean all

# Install F5 WAF for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

#### Ubuntu

```dockerfile
ARG OS_CODENAME
# Where OS_CODENAME can be: focal/jammy/noble
# syntax=docker/dockerfile:1
# For Ubuntu 20.04 / 22.04 / 24.04:
FROM ubuntu:${OS_CODENAME}

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add NGINX Plus repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-plus.list

# Add F5 WAF for NGINX repositories:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the F5 WAF for NGINX package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect

# Only use if you want to install and use the IP intelligence feature:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get install -y app-protect-ip-intelligence

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### Build the Docker image

{{< include "waf/install-build-image.md" >}}

### Update configuration files

{{< include "waf/install-update-configuration.md" >}}

F5 WAF for NGINX should now be operational, and you can move onto [Post-installation checks](#post-installation-checks).

## Post-installation checks

{{< include "waf/install-post-checks.md" >}}

## Next steps

{{< include "waf/install-next-steps.md" >}}
