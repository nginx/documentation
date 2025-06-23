---
docs:
files:
  - content/nim/monitoring/overview-metrics.md
  - content/nginx-one/getting-started.md
---
<!-- include in content/nginx-one/getting-started.md disabled, hopefully temporarily -->
To collect comprehensive metrics for NGINX Plus -- including bytes streamed, information about upstream systems and caches, and counts of all HTTP status codes -- add the following to your NGINX Plus configuration file (for example, `/etc/nginx/nginx.conf` or an included file):

```nginx
# Server block for enabling the NGINX Plus API and dashboard
#
# This block requires NGINX Plus. It turns on the API in write mode
# and serves the built-in dashboard for monitoring.
# Change the listen port if 9000 conflicts; 8080 is the conventional API port.
# For production, secure the API with TLS and limit access by IP or auth.
server {
    # Listen for API and dashboard traffic
    listen 9000 default_server;
    server_name localhost;

    # Handle API calls under /api/ in read-write mode
    location /api/ {
        api write=on;
    }

    # Serve the dashboard page at /dashboard.html
    location = /dashboard.html {
        root /usr/share/nginx/html;
    }

    # Redirect any request to the root path “/” to the dashboard
    location / {
        return 301 /dashboard.html;
    }
}
```

For more details, see the [NGINX Plus API module documentation](https://nginx.org/en/docs/http/ngx_http_api_module.html).

After saving the changes, reload NGINX to apply the new configuration:

```shell
nginx -s reload
```
