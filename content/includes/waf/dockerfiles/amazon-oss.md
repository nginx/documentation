---
---

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM amazonlinux:2023

# Install NGINX OSS and F5 WAF for NGINX WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install wget ca-certificates shadow-utils yum-utils \
    && echo "[nginx-mainline]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=http://nginx.org/packages/mainline/amzn/2023/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo \
    && echo "module_hotfixes=true" >> /etc/yum.repos.d/nginx.repo \
    && echo "priority=9" >> /etc/yum.repos.d/nginx.repo \
    && echo "[app-protect-x-oss]" > /etc/yum.repos.d/app-protect-oss.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-oss/amzn/2023/\$basearch/" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-oss.repo \
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