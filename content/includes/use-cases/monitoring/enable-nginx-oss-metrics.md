---
nd-product: MISCEL
nd-files:
- content/nginx-one-console/getting-started.md
- content/nginx-one-console/nginx-configs/metrics/enable-metrics.md
- content/nim/monitoring/overview-metrics.md
- content/nim/nginx-instances/add-instance.md
---

To collect basic metrics about server activity for NGINX Open Source:

1. **Enable the stub status API**

Add the following to your NGINX configuration file:

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

{{<call-out type="important" title="Important">}}
Make sure that the `server` and  `location` blocks are in the same configuration file, and not split across multiple files using `include` directives.
{{</call-out>}}

This configuration:

- Enables the stub status API endpoint.
- Allows requests only from `127.0.0.1` (localhost).
- Blocks all other requests for security.

For more details, see the [NGINX Stub Status module documentation](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html).

2. **Configure access logging** 

Enable access logging in your NGINX configuration to collect detailed traffic metrics. Ensure that the following log format is used:

```nginx
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
'$status $body_bytes_sent "$http_referer" '
'"$http_user_agent" "$http_x_forwarded_for" '
'"$bytes_sent" "$request_length" "$request_time" '
'"$gzip_ratio" $server_protocol ';

access_log  /var/log/nginx/access.log  main;
```

This log format captures key metrics including request timing, response sizes, and client information.
