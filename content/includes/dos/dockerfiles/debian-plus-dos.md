---
---

```dockerfile
# Where can be bullseye/bookworm
FROM debian:bullseye

# Install F5 DoS for NGINX
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        wget \
        gnupg2 \
        debian-archive-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
        | gpg --dearmor \
        | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list \
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/debian $(lsb_release -cs) nginx-plus" \
        > /etc/apt/sources.list.d/nginx-app-protect-dos.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-dos \
    && cat license.jwt > /etc/nginx/license.jwt \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN --mount=type=secret,id=nginx_license_secret \
    sh -c 'cat /run/secrets/nginx_license_secret | base64 -d > /etc/nginx/license.jwt' && \
    chmod 600 /etc/nginx/license.jwt

RUN nginx -v && admd -v

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```