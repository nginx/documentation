---
f5-product: F5 WAF for NGINX
f5-files:
- content/waf/install/docker.md
---

```dockerfile
# syntax=docker/dockerfile:1

# Base Image
FROM almalinux:10

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install wget ca-certificates yum-utils \
    && dnf config-manager --set-enabled crb \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-10.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/10/\$basearch/" >> /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-10-x-plus.repo \
    && dnf clean all \
    && dnf install -y app-protect-module-plus \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Securely copy the JWT license:
RUN --mount=type=secret,id=license-jwt,dst=license.jwt \
    cp license.jwt /etc/nginx/license.jwt

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```
