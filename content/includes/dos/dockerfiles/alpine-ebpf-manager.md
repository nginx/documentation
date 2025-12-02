---
---

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.21/3.22
ARG OS_VER="3.22"

# Base image
FROM alpine:${OS_VER}

# Install F5 DoS ebpf manager for NGINX and create required nginx user
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
    && printf "https://pkgs.nginx.com/app-protect-dos/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories \
    && apk update \
    && apk add app-protect-dos-ebpf-manager \
    && rm -rf /var/cache/apk/* \
    && useradd -r -s /usr/sbin/nologin nginx || true


STOPSIGNAL SIGQUIT

CMD ["bash", "-c", "/usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log"]

```