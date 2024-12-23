---
docs:
---

1. Copy the license file to `/etc/nginx/license.jwt` on Linux or `/usr/local/etc/nginx/license.jwt` on FreeBSD for each NGINX Plus instance.

1. **SELinux**: If you're running a Linux distribution with SELinux enabled, set the file security context type with the following command:

   ```bash
   chcon -t httpd_config_t /etc/nginx/license.jwt
   ```
