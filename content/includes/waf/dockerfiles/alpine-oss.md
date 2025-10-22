---
---

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.16/3.17/3.19
ARG OS_VER="3.19"

# Base image
FROM alpine:${OS_VER}

# Install NGINX OSS and F5 WAF for NGINX v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    apk add openssl curl ca-certificates \
    && printf "%s%s%s%s\n" \
        "http://nginx.org/packages/mainline/alpine/v" \
        `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
        "/main" \
        | tee -a /etc/apk/repositories \
    && wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
    && printf "https://pkgs.nginx.com/app-protect-x-oss/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | \
        tee -a /etc/apk/repositories \
    && apk update \
    && apk add app-protect-module-oss \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && rm -rf /var/cache/apk/*

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```