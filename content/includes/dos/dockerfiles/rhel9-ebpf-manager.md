---
---

```dockerfile
# For UBI 9
FROM registry.access.redhat.com/ubi9

ARG RHEL_ORG
ARG RHEL_ACTIVATION_KEY

# Install F5 DoS ebpf manager for NGINX and create required nginx user
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -x \
    # Create nginx user/group first, to be consistent throughout Docker variants \
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
    && dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    && dnf -y install ca-certificates \
    && curl -o /etc/yum.repos.d/app-protect-dos-9.repo https://cs.nginx.com/static/files/app-protect-dos-9.repo \
    && dnf -y install app-protect-dos-ebpf-manager \
    && rm /etc/yum.repos.d/app-protect-dos-9.repo \
    && dnf clean all \
    && rm -rf /var/cache/yum

STOPSIGNAL SIGQUIT

CMD ["bash", "-c", "/usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log"]
```