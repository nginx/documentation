---
---

```dockerfile

# syntax=docker/dockerfile:1
# For Ubuntu 

# Where version can be: jammy/noble
FROM ubuntu:noble

# Setup repository keys
RUN apt-get update && \

# Install F5 DoS for NGINX
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/ubuntu $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-app-protect-dos.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-dos \
    && cat license.jwt > /etc/nginx/license.jwt \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```