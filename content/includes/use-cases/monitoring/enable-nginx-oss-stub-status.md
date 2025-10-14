---
docs:
files:
  - content/nim/monitoring/overview-metrics.md
  - content/nginx-one/getting-started.md  
---

To collect basic metrics about server activity for NGINX Open Source, add the following to your NGINX configuration file:

```nginx
server {
    listen 127.0.0.1:8080;
    location /api {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
```

This configuration:

- Enables the stub status API.
- Allows requests only from `127.0.0.1` (localhost).
- Blocks all other requests for security.

For more details, see the [NGINX Stub Status module documentation](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html).