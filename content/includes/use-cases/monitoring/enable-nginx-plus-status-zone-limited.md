---
files:
  - content/nginx-one/nginx-configs/metrics/enable-metrics.md 
---

To make NGINX Plus metrics available on the NGINX One Console, you must enable shared memory zones for the virtual servers being monitored. Shared memory zones store configuration and runtime state information shared across NGINX worker processes.

To display [HTTP]({{< ref "nginx/admin-guide/load-balancer/http-load-balancer.md" >}}) and [TCP]({{< ref "nginx/admin-guide/load-balancer/tcp-udp-load-balancer.md" >}}) servers in NGINX Console, one or more status_zone directives must be defined. The same zone name can be reused across multiple server blocks.

Since [R19]({{< ref "nginx/releases.md#r19" >}}), you can apply the status_zone directive to location blocks, allowing statistics to be aggregated separately for servers and locations.

```nginx
server {
    # ...
    status_zone status_page;
    location / {
        proxy_pass http://backend;
        status_zone location_zone;
    }
}
```