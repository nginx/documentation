---
---

```dockerfile

# For AmazonLinux 2023:
FROM amazonlinux:2023

# Install F5 DoS ebpf manager for NGINX and create required nginx user
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install ca-certificates \
    && curl -o  /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo \
    && dnf install -y app-protect-dos-ebpf-manager \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && useradd -r -s /usr/sbin/nologin nginx || true

STOPSIGNAL SIGQUIT

CMD ["bash", "-c", "/usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log"]

```