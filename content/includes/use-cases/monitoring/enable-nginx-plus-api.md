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
server {
    listen       9000 default_server;
    # If port 9000 is in use, you can also use 8080:
    # listen     8080 default_server;
    server_name  localhost;

    # Handle API calls under /api/ in read-write mode
    location /api/ {
        api write=on;

        # allow GET from anywhere
        allow 0.0.0.0/0;
        deny all;

        # require auth and limit write methods to your network
        limit_except GET {
            auth_basic           "NGINX Plus API";
            auth_basic_user_file /etc/nginx/conf.d/api.htpasswd;
            allow                192.0.2.0/24  # example IP range; replace with yours
            deny                 all;
        }
    }

    # Serve the dashboard page at /dashboard.html
    location = /dashboard.html {
        root /usr/share/nginx/html;
    }

    # Redirect any request to “/” to the dashboard
    location / {
        return 301 /dashboard.html;
    }
}
```

For more details, see the [NGINX Plus API module documentation](https://nginx.org/en/docs/http/ngx_http_api_module.html) and [Configuring the NGINX Plus API]({{< ref “nginx/admin-guide/monitoring/live-activity-monitoring.md#configuring-the-api” >}}).

After saving the changes, reload NGINX:

```shell
nginx -s reload
```
