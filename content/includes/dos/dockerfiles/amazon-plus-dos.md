---
---

```dockerfile
# For AmazonLinux 2023:
FROM amazonlinux:2023

# Install F5 DoS for NGINX
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -x \
    && dnf -y install ca-certificates shadow-utils \
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
    && curl -o /etc/yum.repos.d/plus-amazonlinux2023.repo https://cs.nginx.com/static/files/plus-amazonlinux2023.repo \
    && curl -o  /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo \
    && dnf install -y app-protect-dos \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log 

COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```