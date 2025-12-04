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
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    dnf -y install app-protect app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    rm /etc/yum.repos.d/plus-amazonlinux2023.repo && \
    rm /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN nginx -v && admd -v
RUN cat /opt/app_protect/VERSION /opt/app_protect/RELEASE

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```