---
docs:
files:
  - content/nim/monitoring/overview-metrics.md
  - content/nginx-one/getting-started.md
---
<!-- include in content/nginx-one/getting-started.md disabled, hopefully temporarily -->
To collect comprehensive metrics for NGINX Plus -- including bytes streamed, information about upstream systems and caches, and counts of all HTTP status codes -- add the following to your NGINX Plus configuration file (for example, `/etc/nginx/nginx.conf` or an included file):

```nginx
# This block:
# - Enables the read-write NGINX Plus API under /api/
# - Serves the built-in dashboard at /dashboard.html
# - Restricts write methods (POST, PATCH, DELETE) to authenticated users
#   and a specified IP range
# Change the listen port if 9000 conflicts; 8080 is the conventional API port.
server {
    # Listen on port 9000 for API and dashboard traffic
    listen 9000 default_server;

    # Handle API calls under /api/
    location /api/ {
        # Enable write operations (POST, PATCH, DELETE)
        api write=on;

        # Allow GET requests from any IP
        allow 0.0.0.0/0;
        # Deny all other requests by default
        deny all;

        # For methods other than GET, require auth and restrict to a network
        limit_except GET {
            # Prompt for credentials with this realm
            auth_basic "NGINX Plus API";
            # Path to the file with usernames and passwords
            auth_basic_user_file /path/to/passwd/file;

            # Allow only this IP range (replace with your own)
            allow 192.0.2.0/24;
            # Deny all other IPs
            deny all;
        }
    }

    # Serve the dashboard page at /dashboard.html
    location = /dashboard.html {
        # Files are located under this directory
        root /usr/share/nginx/html;
    }

    # Redirect any request for / to the dashboard
    location / {
        return 301 /dashboard.html;
    }
}
```

For more details, see the [NGINX Plus API module documentation](https://nginx.org/en/docs/http/ngx_http_api_module.html) and [Configuring the NGINX Plus API]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md#configuring-the-api" >}}).

After saving the changes, reload NGINX:

```shell
nginx -s reload
```
