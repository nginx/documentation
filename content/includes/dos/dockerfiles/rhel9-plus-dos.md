---
nd-docs: DOCS-143
nd-product: F5DOSN
---

```dockerfile
# For UBI 9
FROM registry.access.redhat.com/ubi9

ARG RHEL_ORG
ARG RHEL_ACTIVATION_KEY

# Install F5 DoS for NGINX
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    subscription-manager register --org=${RHEL_ORG} --activationkey=${RHEL_ACTIVATION_KEY} \
    && subscription-manager refresh \
    && subscription-manager attach --auto || true \
    && subscription-manager repos --enable=rhel-9-for-x86_64-baseos-rpms \
    && subscription-manager repos --enable=rhel-9-for-x86_64-appstream-rpms \
    && dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    && dnf -y install ca-certificates \
    && curl -o /etc/yum.repos.d/plus-9.repo https://cs.nginx.com/static/files/plus-9.repo \
    && curl -o /etc/yum.repos.d/app-protect-dos-9.repo https://cs.nginx.com/static/files/app-protect-dos-9.repo \
    && dnf -y install app-protect-dos \
    && cat license.jwt > /etc/nginx/license.jwt \
    && rm /etc/yum.repos.d/plus-9.repo \
    && rm /etc/yum.repos.d/app-protect-dos-9.repo \
    && dnf clean all \
    && rm -rf /var/cache/yum \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]

```