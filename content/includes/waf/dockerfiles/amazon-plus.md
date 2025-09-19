---
---

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