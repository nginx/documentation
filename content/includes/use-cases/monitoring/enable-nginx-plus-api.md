---
docs:
files:
  - content/nim/monitoring/overview-metrics.md
  - content/nginx-one/getting-started.md
---
<!-- include in content/nginx-one/getting-started.md disabled, hopefully temporarily -->
To collect comprehensive metrics for NGINX Plus--including bytes streamed, information about upstream systems and caches, and counts of all HTTP status codes--add the following to your NGINX Plus configuration file (for example, `/etc/nginx/nginx.conf` or an included file):

```nginx
# Enable the /api/ location with appropriate access control
# to use the NGINX Plus API.
#
location /api/ {
    api write=on;
    allow 127.0.0.1;
    deny all;
}
```

This configuration:

- Enables the NGINX Plus API.
- Allows requests only from `127.0.0.1` (localhost).
- Blocks all other requests for security.

For more details, see the [NGINX Plus API module documentation](https://nginx.org/en/docs/http/ngx_http_api_module.html).

After saving the changes, reload NGINX to apply the new configuration:

```shell
nginx -s reload
```
