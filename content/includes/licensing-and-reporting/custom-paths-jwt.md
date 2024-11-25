---
docs:
---

If you plan to use a custom path for the license file, note that **custom paths won’t work until after the R33 upgrade**. You’ll need to create a placeholder file at `/etc/nginx/license.jwt` or `/usr/local/etc/nginx/license.jwt` on FreeBSD before upgrading.

1. **Before upgrading**: Create the placeholder file by running:

   ```bash
   touch /etc/nginx/license.jwt
   ```

2. **After upgrading**: Update the [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token) directive in the NGINX configuration [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block to point to your custom path:

   ```nginx
   mgmt {
     license_token <custom_path>;
   }
   ```
