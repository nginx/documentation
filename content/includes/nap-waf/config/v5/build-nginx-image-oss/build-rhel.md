```dockerfile
# syntax=docker/dockerfile:1

# Supported UBI_VERSION's are 7/8/9
ARG UBI_VERSION=9

# Base Image
FROM registry.access.redhat.com/ubi${UBI_VERSION}/ubi

# Define the ARG again after FROM to use it in this stage
ARG UBI_VERSION

# Install NGINX OSS and F5 WAF for NGINX v5 module
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