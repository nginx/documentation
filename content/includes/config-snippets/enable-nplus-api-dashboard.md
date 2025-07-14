---
docs:
files:
- content/nginx-one/workshops/lab5/upgrade-nginx-plus-to-latest-version.md
- content/includes/use-cases/monitoring/enable-nginx-plus-api.md
---

```nginx
# This block enables the NGINX Plus API and dashboard
# For configuration and security recommendations, see:
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api
server {
    # Change the listen port if 9000 conflicts
    # (8080 is the conventional API port)
    listen 9000;

    location /api/ {
        # To restrict write methods (POST, PATCH, DELETE), uncomment:
        # limit_except GET {
        #     auth_basic "NGINX Plus API";
        #     auth_basic_user_file /path/to/passwd/file;
        # }

        # Enable API in write mode
        api write=on;

        # To restrict access by network, uncomment and set your network:
        # allow 192.0.2.0/24   # replace with your network
        # deny  all;
    }

    # Serve the built-in dashboard at /dashboard.html
    location = /dashboard.html {
        root /usr/share/nginx/html;
    }
}
```
