---
---

```dockerfile
# For UBI 8
FROM registry.access.redhat.com/ubi8

ARG RHEL_ORG
ARG RHEL_ACTIVATION_KEY

# Install F5 DoS for NGINX
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    subscription-manager register --org=${RHEL_ORG} --activationkey=${RHEL_ACTIVATION_KEY} \
    && subscription-manager refresh \
    && subscription-manager attach --auto || true \
    && subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms \
    && subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms \
    && dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf -y install ca-certificates \
    && curl -o /etc/yum.repos.d/app-protect-dos-8.repo https://cs.nginx.com/static/files/app-protect-dos-8.repo \
    && dnf -y install app-protect-dos-ebpf-manager \
    && rm /etc/yum.repos.d/app-protect-dos-8.repo \
    && dnf clean all \
    && rm -rf /var/cache/yum

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["bash", "-c", "/usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log"]

```