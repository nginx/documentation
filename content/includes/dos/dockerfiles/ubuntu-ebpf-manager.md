---
---

```dockerfile
# syntax=docker/dockerfile:1
# For Ubuntu 

# Where version can be: jammy/noble
FROM ubuntu:noble

# Install F5 DoS ebpf manager for NGINX and create required nginx user
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        wget \
        gnupg2 \
        ubuntu-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
        | gpg --dearmor \
        | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/ubuntu $(lsb_release -cs) nginx-plus" \
        > /etc/apt/sources.list.d/nginx-app-protect-dos.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y app-protect-dos-ebpf-manager \
    && apt-get remove --purge --auto-remove -y \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -r -s /usr/sbin/nologin nginx

STOPSIGNAL SIGQUIT

RUN ebpf_manager_dos -v

# Idle forever
CMD ["bash", "-c", "/usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log"]
```