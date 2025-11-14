---
---

If you’re upgrading from NGINX Plus R32 or earlier to R33 or later and plan to use a custom path for the license file, note that the custom path isn’t recognized until after the upgrade. You must first create a placeholder file at `/etc/nginx/license.jwt` (or `/usr/local/etc/nginx/license.jwt` on FreeBSD).  

1. **Before upgrading**: Create the placeholder file:

   ```bash
   touch /etc/nginx/license.jwt
   ```

1. **After upgrading**: Update the [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the configuration to point to your custom path:

   ```nginx
   mgmt {
     license_token <custom_path>;
   }
   ```
