---
nd-product: SOLUTI
nd-files:
- content/solutions/about-subscription-licenses/getting-started.md
---

1. Copy the license file to:

   - `/etc/nginx/license.jwt` on Linux
   - `/usr/local/etc/nginx/license.jwt` on FreeBSD

1. Reload NGINX:

   ```shell
   systemctl reload nginx
   ```

1. If SELinux is enabled, set the correct file context so NGINX can read the license:

   ```shell
   chcon -t httpd_config_t /etc/nginx/license.jwt
   ```
