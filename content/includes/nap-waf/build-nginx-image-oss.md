---
docs: "DOCS-1513"
---

Choose the appropriate `Dockerfile` example based on your Operating System (OS).

{{<tabs name="nap5_nginx_OSS_dockerfiles">}}
{{%tab name="Alpine Linux"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.16/3.17
ARG OS_VER="3.17"

# Base image
FROM alpine:${OS_VER}

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    apk add openssl curl ca-certificates \
    && printf "%s%s%s%s\n" \
        "http://nginx.org/packages/mainline/alpine/v" \
        `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
        "/main" \
        | tee -a /etc/apk/repositories \
    && wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
    && printf "https://pkgs.nginx.com/app-protect-x-oss/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | \
        tee -a /etc/apk/repositories \
    && apk update \
    && apk add app-protect-module-oss \
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

{{%/tab%}}
{{%tab name="Amazon Linux 2"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM amazonlinux:2

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    amazon-linux-extras enable epel \
    && yum clean metadata \
    && yum -y install wget ca-certificates epel-release shadow-utils yum-utils \
    && echo "[nginx-mainline]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=http://nginx.org/packages/mainline/amzn2/\$releasever/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo \
    && echo "module_hotfixes=true" >> /etc/yum.repos.d/nginx.repo \
    && echo "priority=9" >> /etc/yum.repos.d/nginx.repo \
    && echo "[app-protect-x-oss]" > /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/\$basearch/" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && yum -y install app-protect-module-oss \
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

{{%/tab%}}
{{%tab name="CentOS"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM centos:7

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install wget ca-certificates epel-release yum-utils \
    && echo "[nginx-mainline]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo \
    && echo "module_hotfixes=true" >> /etc/yum.repos.d/nginx.repo \
    && echo "[app-protect-x-oss]" > /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/\$basearch/" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-7-x-oss.repo \
    && yum -y install app-protect-module-oss \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && yum clean all \
    && rm -rf /var/cache/yum

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM oraclelinux:8

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install wget ca-certificates yum-utils \
    && echo "[nginx-mainline]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo \
    && echo "module_hotfixes=true" >> /etc/yum.repos.d/nginx.repo \
    && echo "[app-protect-x-oss]" > /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/8/\$basearch/" >> /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-8-x-oss.repo \
    && dnf clean all \
    && dnf -y install app-protect-module-oss \
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

{{%/tab%}}
{{%tab name="Debian"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_CODENAME's are: bullseye/bookworm
ARG OS_CODENAME=bookworm

# Base image
FROM debian:${OS_CODENAME}

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y curl \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg2 \
       debian-archive-keyring \
    && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list \
    && wget https://cs.nginx.com/static/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && printf "deb https://pkgs.nginx.com/app-protect-x-oss/debian `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx=1.25.4-1~`lsb_release -cs` app-protect-module-oss \
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

{{%/tab%}}
{{%tab name="RHEL"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported UBI_VERSION's are 7/8/9
ARG UBI_VERSION=9

# Base Image
FROM registry.access.redhat.com/ubi${UBI_VERSION}/ubi

# Define the ARG again after FROM to use it in this stage
ARG UBI_VERSION

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    PKG_MANAGER=dnf; \
    if [ "${UBI_VERSION}" = "7" ]; then \
        PKG_MANAGER=yum; \
    fi \
    && $PKG_MANAGER -y install wget ca-certificates yum-utils \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && echo "[nginx-mainline]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo \
    && echo "module_hotfixes=true" >> /etc/yum.repos.d/nginx.repo \
    && echo "[app-protect-x-oss]" > /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/${UBI_VERSION}/\$basearch/" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-oss.repo \
    && $PKG_MANAGER clean all \
    && $PKG_MANAGER install -y app-protect-module-oss \
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

{{%/tab%}}
{{%tab name="Ubuntu"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_CODENAME's are: focal/jammy
ARG OS_CODENAME=jammy

# Base image
FROM ubuntu:${OS_CODENAME}

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y curl \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg2 \
       ubuntu-keyring \
    && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list \
    && wget https://cs.nginx.com/static/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && printf "deb https://pkgs.nginx.com/app-protect-x-oss/ubuntu `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx=1.25.4-1~`lsb_release -cs` app-protect-module-oss \
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

{{%/tab%}}
{{</tabs>}}
