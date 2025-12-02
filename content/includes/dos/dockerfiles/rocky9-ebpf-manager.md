---
---

```dockerfile

# syntax=docker/dockerfile:1
# For Rocky Linux 9
FROM rockylinux:9

# Install F5 DoS for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install ca-certificates epel-release 'dnf-command(config-manager)' \
    && curl -o /etc/yum.repos.d/app-protect-dos-9.repo https://cs.nginx.com/static/files/app-protect-dos-9.repo \
    && dnf config-manager --set-enabled crb \
    && dnf install -y app-protect-dos-ebpf-manager \
    && dnf clean all \
    && rm -rf /var/cache/dnf 

# Copy configuration files:
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]

```