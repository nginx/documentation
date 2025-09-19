---
---

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
