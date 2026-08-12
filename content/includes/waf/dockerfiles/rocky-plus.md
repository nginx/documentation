---
f5-product: F5 WAF for NGINX
f5-files:
- content/waf/install/docker.md
- content/waf/install/kubernetes.md
---

```dockerfile
# syntax=docker/dockerfile:1

# Supported ROCKY_VERSION's are 8/9/10
ARG ROCKY_VERSION=9

# Base Image
FROM rockylinux/rockylinux:${ROCKY_VERSION}

# Define the ARG again after FROM to use it in this stage
ARG ROCKY_VERSION

# Install NGINX Plus and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    if [ "${ROCKY_VERSION}" = "8" ]; then \
        NGINX_PLUS_REPO="nginx-plus-${ROCKY_VERSION}.repo"; \
    else \
        NGINX_PLUS_REPO="plus-${ROCKY_VERSION}.repo"; \
    fi \
    && dnf -y install wget ca-certificates \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/${NGINX_PLUS_REPO} \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/${ROCKY_VERSION}/\$basearch/" >> /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-${ROCKY_VERSION}-x-plus.repo \
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
