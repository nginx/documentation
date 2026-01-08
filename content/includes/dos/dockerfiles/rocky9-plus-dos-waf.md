---
---

```dockerfile
# syntax=docker/dockerfile:1
# For Rocky Linux 9
FROM rockylinux:9

# Install F5 DoS for NGINX:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -x \
    # Create nginx user/group first, to be consistent throughout Docker variants \
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
    && dnf -y install ca-certificates epel-release 'dnf-command(config-manager)' \
    && curl -o /etc/yum.repos.d/plus-9.repo https://cs.nginx.com/static/files/plus-9.repo \
    && curl -o /etc/yum.repos.d/app-protect-dos-9.repo https://cs.nginx.com/static/files/app-protect-dos-9.repo \
    && curl -o /etc/yum.repos.d/app-protect-9.repo https://cs.nginx.com/static/files/app-protect-9.repo \
    && curl -o /etc/yum.repos.d/dependencies.9.repo https://cs.nginx.com/static/files/dependencies.9.repo \
    && dnf config-manager --set-enabled crb \
    && dnf install -y app-protect app-protect-dos \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN nginx -v && admd -v
RUN echo "RELEASE:" && cat /opt/app_protect/RELEASE && echo "VERSION:" && cat /opt/app_protect/VERSION

COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```