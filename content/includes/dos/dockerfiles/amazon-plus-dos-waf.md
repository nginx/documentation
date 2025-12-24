---
---

```dockerfile
# syntax=docker/dockerfile:1
FROM amazonlinux:2023

# Install prerequisite packages:
RUN dnf -y install ca-certificates

# Add NGINX/NAP WAF/NAP DOS repositories:
RUN curl -o /etc/yum.repos.d/plus-amazonlinux2023.repo https://cs.nginx.com/static/files/plus-amazonlinux2023.repo && \
    curl -o /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo && \
    curl -o /etc/yum.repos.d/app-protect-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo && \
    curl -o /etc/yum.repos.d/dependencies.amazonlinux2023.repo https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo

# Update the repository and install the most recent versions of the F5 WAF and F5 DoS for NGINX packages (which include NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -x \
    && dnf -y install ca-certificates shadow-utils \
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
    && dnf -y install app-protect app-protect-dos \
    && rm /etc/yum.repos.d/plus-amazonlinux2023.repo \
    && rm /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && rm -rf /var/cache/yum \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN nginx -v && admd -v
RUN echo "RELEASE:" && cat /opt/app_protect/RELEASE && echo "VERSION:" && cat /opt/app_protect/VERSION

# Copy configuration files:
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```