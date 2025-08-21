```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM centos:7

# Install NGINX Plus and F5 WAF for NGINX v5 module
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