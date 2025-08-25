---
# We use sentence case and present imperative tone
title: "Docker"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

There's some content around mTLS that should be spun into its own page:

- [Docker Compose File with mTLS]({{< ref "/nap-waf/v5/admin-guide/deploy-on-docker.md#docker-compose-file-with-mtls" >}})
- [Secure Traffic Between NGINX and App Protect Enforcer using mTLS]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls" >}})

I haven't found reference to it in v5 content, but I don't see why it couldn't/wouldn't apply to v4 too?

{{</ call-out >}}

This page describes how to install F5 WAF for NGINX with NGINX Plus using Docker.

## Before you begin

To complete this guide, you will need the following prerequisites:

- An active F5 WAF for NGINX subscription (Purchased or trial)
- A working [NGINX Plus installation]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}})
- [Docker](https://docs.docker.com/get-started/get-docker/)

You should read the [IP intelligence topic]({{< ref "/waf/policies/ip-intelligence.md" >}}) for additional set-up configuration if you want to use the feature immediately.

To review supported operating systems, please read the [Technical specifications]({{< ref "/waf/fundamentals/technical-specifications.md" >}}) guide.

## Download your subscription credentials 

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

## Create configuration files

Once you have downloaded your subscription files, place them in a folder.

In the same folder, you can then create three files:

- _nginx.conf_ - An NGINX configuration file with F5 WAF for NGINX enabled
- _entrypoint.sh_ - A Docker startup script which spins up all F5 WA for NGINX processes, requiring executable permissions
- _custom_log_format.json_ - An optional user-defined security log format file

{{< call-out "note" >}}

If you are not using using `custom_log_format.json`, you should remove any references to it from your nginx.conf and entrypoint.sh files.

{{< /call-out >}}

Here are examples of the file contents: 

{{< tabs name="configuration-files" >}}

{{% tab name="nginx.conf" %}}

```nginx
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
        proxy_http_version 1.1;

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

## Create a Dockerfile

In the same folder as your credential and configuration files, create a _Dockerfile_ based on your desired operating system image using an example below:

{{< call-out "note" >}}

If you are not using using `custom_log_format.json` or the IP intelligence feature,  you should remove any references to them from your Dockerfile.

{{< /call-out >}}

### Alpine Linux

{{< tabs name="alpine-instructions" >}}

{{% tab name="V4" %}}

```dockerfile
# syntax=docker/dockerfile:1
# For Alpine 3.19:
FROM alpine:3.19

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
 && wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub

# Add NGINX Plus repository:
RUN printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Add NGINX App Protect repository:
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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.16/3.17/3.19
ARG OS_VER="3.19"

# Base image
FROM alpine:${OS_VER}

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
    && printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | \
       tee -a /etc/apk/repositories \
    && printf "https://pkgs.nginx.com/app-protect-x-plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | \
       tee -a /etc/apk/repositories \
    && apk update \
    && apk add app-protect-module-plus \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && rm -rf /var/cache/apk/*

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM amazonlinux:2023

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install wget ca-certificates shadow-utils \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/amzn/2023/\$basearch/" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.cert" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-plus.repo \
    && yum -y install app-protect-module-plus \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_CODENAME's are: bullseye/bookworm
ARG OS_CODENAME=bookworm

# Base image
FROM debian:${OS_CODENAME}

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg2 \
       debian-archive-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
       gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
       https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
       https://pkgs.nginx.com/app-protect-x-plus/debian `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-module-plus \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### Oracle Linux

{{< tabs name="oracle-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM oraclelinux:8

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install wget ca-certificates yum-utils \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/\$basearch/" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.cert" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && dnf clean all \
    && dnf -y install app-protect-module-plus \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_CODENAME's are: focal/jammy
ARG OS_CODENAME=jammy

# Base image
FROM ubuntu:${OS_CODENAME}

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg2 \
       ubuntu-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
       gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
       https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
       https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-module-plus \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### RHEL8

{{< tabs name="rhel8-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported UBI_VERSION's are 7/8/9
ARG UBI_VERSION=8

# Base Image
FROM registry.access.redhat.com/ubi${UBI_VERSION}/ubi

# Define the ARG again after FROM to use it in this stage
ARG UBI_VERSION

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    PKG_MANAGER=dnf; \
    if [ "${UBI_VERSION}" = "7" ]; then \
        PKG_MANAGER=yum; \
        NGINX_PLUS_REPO="nginx-plus-7.4.repo"; \
    elif [ "${UBI_VERSION}" = "9" ]; then \
        NGINX_PLUS_REPO="plus-${UBI_VERSION}.repo"; \
    else \
        NGINX_PLUS_REPO="nginx-plus-${UBI_VERSION}.repo"; \
    fi \
    && $PKG_MANAGER -y install wget ca-certificates \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/${NGINX_PLUS_REPO} \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/${UBI_VERSION}/\$basearch/" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.cert" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && $PKG_MANAGER clean all \
    && $PKG_MANAGER install -y app-protect-module-plus \
    && $PKG_MANAGER clean all \
    && rm -rf /var/cache/$PKG_MANAGER \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### RHEL 9

{{< tabs name="rhel9-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Base Image
FROM rockylinux:9

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install wget ca-certificates \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/${NGINX_PLUS_REPO} \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/${UBI_VERSION}/\$basearch/" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.cert" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && dnf clean all \
    && dnf install -y app-protect-module-plus \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

### Rocky Linux 9

{{< tabs name="rocky-instructions" >}}

{{% tab name="V4" %}}

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

{{% /tab %}}

{{% tab name="V5" %}}

```dockerfile
# syntax=docker/dockerfile:1

# Base Image
FROM rockylinux:9

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.cert,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install wget ca-certificates \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/${NGINX_PLUS_REPO} \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/${UBI_VERSION}/\$basearch/" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.cert" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
    && dnf clean all \
    && dnf install -y app-protect-module-plus \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{% /tab %}}

{{< /tabs >}}

## Build the Docker image

Your folder should contain the following files:

- _nginx-repo.cert_
- _nginx-repo.key_
- _nginx.conf_
- _entrypoint.sh_
- _Dockerfile_
- _custom_log_format.json_ (Optional)

To build an image, use the following command, replacing `<your-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.cert --secret id=nginx-key,src=nginx-repo.key -t <your-image-name> .
```

A RHEL-based system would use the following command instead:

```shell
podman build --no-cache --secret id=nginx-crt,src=nginx-repo.cert --secret id=nginx-key,src=nginx-repo.key -t <your-image-name> .
```

{{< call-out "note" >}}

The `--no-cache` option is used to ensure the image is built from scratch, installing the latest versions of NGINX Plus and F5 WAF for NGINX.

{{< /call-out >}}

Verify that your image has been created using the `docker images` command:

```shell
docker images <your-image-name>
```

Create a container based on this image, replacing <your-container-name> as appropriate:

```shell
docker run --name <your-container-name> -p 80:80 -d <your-image-name>
```

Verify the new container is running using the `docker ps` command:

```shell
docker ps
```

## Update configuration files

{{< include "waf/install-update-configuration.md" >}}

## Configure Docker services

{{< include "waf/install-services-docker.md" >}}

### Configure Docker for the F5 Container Registry

{{< include "waf/install-services-registry.md" >}}

### Download Docker images

{{< include "waf/install-services-images.md" >}}

### Create and run a Docker Compose file

{{< include "waf/install-services-compose.md" >}}

## Post-installation checks

{{< include "waf/install-post-checks.md" >}}

## Next steps

{{< include "waf/install-next-steps.md" >}}