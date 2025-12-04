---
---

```dockerfile
# Where version can be: bullseye/bookworm
FROM debian:bullseye

# Install prerequisite packages:
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg > /dev/null

# Add NGINX Plus, NGINX App Protect and F5 DoS for NGINX repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect-dos.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent versions of the F5 WAF and F5 DoS for NGINX packages (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nginx-app-protect.list /etc/apt/sources.list.d/nginx-app-protect-dos.list && \
    rm -rf /etc/apt/apt.conf.d/90nginx /var/lib/apt/lists/*

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN nginx -v && admd -v
RUN cat /opt/app_protect/VERSION /opt/app_protect/RELEASE

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```