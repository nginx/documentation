---
docs: "DOCS-1510"
---

Choose the appropriate `Dockerfile` example based on your Operating System (OS).

{{<tabs name="nap5_nginx_plus_dockerfiles">}}
{{%tab name="Alpine Linux"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.16/3.17
ARG OS_VER="3.17"

# Base image
FROM alpine:${OS_VER}

# Install NGINX Plus and NGINX App Protect WAF v5 module
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

{{%/tab%}}
{{%tab name="Amazon Linux 2"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM amazonlinux:2

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    amazon-linux-extras enable epel \
    && yum clean metadata \
    && yum -y install wget ca-certificates epel-release shadow-utils \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/7/\$basearch/" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
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

{{%/tab%}}
{{%tab name="CentOS"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM centos:7

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install wget ca-certificates epel-release \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/7/\$basearch/" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-7-x-plus.repo \
    && yum -y install app-protect-module-plus \
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

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install wget ca-certificates yum-utils \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/\$basearch/" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-8-x-plus.repo \
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

{{%/tab%}}
{{%tab name="Debian"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_CODENAME's are: bullseye/bookworm
ARG OS_CODENAME=bookworm

# Base image
FROM debian:${OS_CODENAME}

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg2 \
    && wget https://cs.nginx.com/static/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && printf "deb https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb https://pkgs.nginx.com/app-protect-x-plus/debian `lsb_release -cs` nginx-plus\n" | \
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

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
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
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-${UBI_VERSION}-x-plus.repo \
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

{{%/tab%}}
{{%tab name="Ubuntu"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_CODENAME's are: focal/jammy
ARG OS_CODENAME=jammy

# Base image
FROM ubuntu:${OS_CODENAME}

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg2 \
    && wget https://cs.nginx.com/static/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
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

{{%/tab%}}
{{</tabs>}}
