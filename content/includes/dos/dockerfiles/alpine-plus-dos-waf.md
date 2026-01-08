---
---

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.21/3.22
ARG OS_VER="3.22"

# Base image
FROM alpine:${OS_VER}

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub && \
    wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub

# Add NGINX Plus repository:
RUN printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Add F5 WAF for NGINX & Dos repositories:
RUN printf "https://pkgs.nginx.com/app-protect-dos/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories && \
    printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories && \
    printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Update the repository and install the most recent versions of the F5 WAF and F5 DoS for NGINX packages (which include NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    set -x \
    # Create nginx user/group first, to be consistent throughout Docker variants \
    && addgroup -S -g 101 nginx \
    && adduser -S -u 101 -G nginx -h /nonexistent -s /sbin/nologin nginx \
    && apk update && apk add app-protect app-protect-dos \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && rm -rf /var/cache/apk/*

RUN nginx -v && admd -v
RUN echo "RELEASE:" && cat /opt/app_protect/RELEASE && echo "VERSION:" && cat /opt/app_protect/VERSION

# Copy configuration files:
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80


STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```
