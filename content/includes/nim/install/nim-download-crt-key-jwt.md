---
nd-files:
  - content/nim/install/vm-bare-metal/install-with-bash-script-offline.md
  - content/nim/install/vm-bare-metal/install-with-bash-script-online.md
---

To install and license NGINX Instance Manager, you need to download your SSL certificate, private key, and JSON web token (JWT) from MyF5.

{{< include "/licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

The downloaded files may have names like `nginx-one-<subscription-id>.crt`, depending on your product and subscription. **Rename and move** the files to the following default locations:

- `/etc/ssl/nginx/nginx-repo.crt`
- `/etc/ssl/nginx/nginx-repo.key`
- `/etc/nginx/license.jwt`

For example:

```shell
sudo mv nginx-one-<subscription-id>.crt /etc/ssl/nginx/nginx-repo.crt
sudo mv nginx-one-<subscription-id>.key /etc/ssl/nginx/nginx-repo.key
sudo mv nginx-one-<subscription-id>.jwt /etc/nginx/license.jwt
```