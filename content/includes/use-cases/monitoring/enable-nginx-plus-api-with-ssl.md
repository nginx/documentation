---
nd-product: MSC
nd-files:
- content/nginx-one-console/getting-started.md
---

If SSL is enabled on the NGINX Plus API with self-signed certificates like this example:

```nginx
# This block enables the NGINX Plus API and dashboard with SSL
# For configuration and security recommendations, see:
# https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api
server {
    # Change the listen port if 9000 conflicts
    # (8080 is the conventional API port)
    listen 9000 ssl;
    ssl_certificate /etc/nginx/certs/nginx-selfsigned.crt; 
    ssl_certificate_key /etc/nginx/certs/nginx-selfsigned.key;

    location /api/ {
        # To restrict write methods (POST, PATCH, DELETE), uncomment:
        # limit_except GET {
        #     auth_basic "NGINX Plus API";
        #     auth_basic_user_file /path/to/passwd/file;
        # }

        # Enable API in write mode
        api write=on;

        # To restrict access by network, uncomment the following lines and set your network:
        # allow 192.0.2.0/24;   # replace with your network
        # allow 127.0.0.1/32;   # allow local NGINX Agent to call the NGINX Plus API to retrieve metrics
        # deny  all;
    }

    # Serve the built-in dashboard at /dashboard.html
    location = /dashboard.html {
        root /usr/share/nginx/html;
    }
}
```

NGINX Agent configuration needs to be update with the following to enable the NGINX Agent to be able to call the NGINX Plus API.
```
data_plane_config:
  nginx:
    api_tls:
      ca: "/etc/nginx/certs/nginx-selfsigned.crt"
```

Here is an example of how to generate self-signed certificates 
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx-selfsigned.key -out /etc/nginx/certs/nginx-selfsigned.crt -subj "/CN=localhost" -addext "subjectAltName=IP:127.0.0.1"
```