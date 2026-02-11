---
nd-product: MISCEL
nd-files:
- content/nginx-one-console/getting-started.md
- content/nginx-one-console/nginx-configs/metrics/enable-metrics.md
- content/nim/monitoring/overview-metrics.md
- content/nim/nginx-instances/add-instance.md
---

To collect comprehensive metrics for NGINX Plus, including bytes streamed, information about upstream systems and caches, and counts of all HTTP status codes, add the following to your NGINX Plus configuration file, for example `/etc/nginx/nginx.conf` or an included file:

{{< include "nginx-one-console/config-snippets/enable-nplus-api-dashboard.md" >}}

{{< call-out "note" "Security tip" >}}
- By default, all clients can call the API.  
- To limit who can access the API, uncomment the `allow` and `deny` lines under `api write=on` and replace the example CIDR with your trusted network.  
- To restrict write methods (`POST`, `PATCH`, `DELETE`), uncomment and configure the `limit_except GET` block and set up [HTTP basic authentication](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html).  
{{</ call-out >}}

{{<call-out type="note" title="Configure NGINX Agent">}}
If there are issues with NGINX Agent discovering the NGINX Plus API, NGINX Agent can be manually configured with the address of the NGINX Plus API. 

- Add the following configuration to `/etc/nginx-agent/nginx-agent.conf`:
```
data_plane_config:
  nginx:
    api:
      url: "http://127.0.0.1:9000/api"
```
- Restart NGINX Agent for the configuration changes to take affect
```
sudo systemctl restart nginx-agent
```

- Run the following command 
```
sudo journalctl -u nginx-agent | grep "Found NGINX Plus API"
``` 
- Ensure that the following log message is seen 
```
Found NGINX Plus API
```
{{</call-out>}}

For more details, see the [NGINX Plus API module](https://nginx.org/en/docs/http/ngx_http_api_module.html) documentation and [Configuring the NGINX Plus API]({{< ref "/nginx/admin-guide/monitoring/live-activity-monitoring.md#configuring-the-api" >}}).
