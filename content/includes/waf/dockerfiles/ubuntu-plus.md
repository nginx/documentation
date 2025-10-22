---
---

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