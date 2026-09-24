---
f5-product: F5 DOS for NGINX
f5-files:
- content/nap-dos/deployment-guide/kubernetes-with-L4-accelerated-mitigation.md
---

```dockerfile
# For UBI 10
FROM registry.access.redhat.com/ubi10

ARG RHEL_ORG
ARG RHEL_ACTIVATION_KEY

# Set this to the same version you built the F5 DoS for NGINX image with, for example:
#   --build-arg DOS_VERSION="-37+4.9.6"
# Left empty, the most recent version is installed, which may not match that image.
ARG DOS_VERSION=""

# Install F5 DoS ebpf manager for NGINX and create required nginx user
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -x \
    # Create nginx user/group first, to be consistent throughout Docker variants \
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
    && dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm \
    && dnf -y install ca-certificates \
    && curl -o /etc/yum.repos.d/app-protect-dos-10.repo https://cs.nginx.com/static/files/app-protect-dos-10.repo \
    && dnf -y install "app-protect-dos-ebpf-manager${DOS_VERSION}" \
    && rm /etc/yum.repos.d/app-protect-dos-10.repo \
    && dnf clean all \
    && rm -rf /var/cache/yum

STOPSIGNAL SIGQUIT

CMD ["bash", "-c", "/usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log"]
```

