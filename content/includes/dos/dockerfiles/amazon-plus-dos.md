---
nd-product: F5DOSN
---

```dockerfile

# For AmazonLinux 2023:
FROM amazonlinux:2023

# Install F5 DoS for NGINX
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    dnf -y install ca-certificates \
    && curl -o /etc/yum.repos.d/plus-amazonlinux2023.repo https://cs.nginx.com/static/files/plus-amazonlinux2023.repo \
    && curl -o  /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo \
    && dnf install -y app-protect-dos \
    && cat license.jwt > /etc/nginx/license.jwt \
    && dnf clean all \
    && rm -rf /var/cache/dnf \ 
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log 

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]

```