---
nd-product: NONECO
nd-files:
- content/includes/use-cases/monitoring/enable-nginx-plus-api-with-config-sync-group.md
- content/nginx-one-console/getting-started.md
- content/nginx-one-console/nginx-configs/metrics/enable-metrics.md
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

{{<call-out type="important" title="Important">}}
Make sure that the `server` and  `location` blocks are in the same configuration file, and not split across multiple files using `include` directives.
{{</call-out>}}

{{<call-out type="note" title="Configure NGINX Agent">}}
To enable NGINX Agent to call the NGINX Plus API, follow the steps below:
- Add the following configuration to `/etc/nginx-agent/nginx-agent.conf`:
```
data_plane_config:
  nginx:
    api_tls:
      ca: "/etc/nginx/certs/nginx-selfsigned.crt"
```
- Restart NGINX Agent for the configuration changes to take affect
```
sudo systemctl restart nginx-agent
```

- Run the following command 
```
sudo journalctl -u nginx-agent | grep "NGINX Plus API"
``` 
- Ensure that the following log message is seen 
```
NGINX Plus API found, NGINX Plus receiver enabled to scrape metrics
```
{{</call-out>}}

{{<call-out type="note" title="Note">}}
Here is an example of how to generate self-signed certificates
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx-selfsigned.key -out /etc/nginx/certs/nginx-selfsigned.crt -subj "/CN=localhost" -addext "subjectAltName=IP:127.0.0.1"
```
{{</call-out>}}