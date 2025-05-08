---
docs:
file:
  - content/solutions/about-subscription-licenses.md
  - content/nap-waf/v5/admin-guide/install.md
---

1. Copy the license file to `/etc/nginx/license.jwt` on Linux or `/usr/local/etc/nginx/license.jwt` on FreeBSD for each NGINX Plus instance.
2. Reload NGINX:

   ```shell
   systemctl reload nginx
   ```

**If SELinux is enabled**: 

Set the correct file context so NGINX can read the license:

```shell
chcon -t httpd_config_t /etc/nginx/license.jwt
```
