---
nd-docs: "DOCS-1509"
---

{{< call-out "note" >}}
 While this example utilizes the official NGINX Open Source image as a base, the crucial requirement is that NGINX must be installed as a package from the official NGINX repository, rather than being compiled from source.
{{< /call-out >}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM nginx:1.25.5-bookworm

# Install NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       wget \
       gnupg \
    && wget https://cs.nginx.com/static/keys/nginx_signing.key \
    && gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/nginx.gpg \
       --import nginx_signing.key \
    && chmod 644 /etc/apt/trusted.gpg.d/nginx.gpg \
    && printf "deb https://pkgs.nginx.com/app-protect-x-oss/debian `lsb_release -cs` nginx-plus\n" | \
       tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y nginx=1.25.5-1~bookworm app-protect-module-oss  \
    && apt-get remove --purge --auto-remove -y apt-transport-https lsb-release gnupg wget \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-app-protect.list
```
