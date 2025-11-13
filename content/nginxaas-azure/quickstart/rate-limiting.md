---
title: Enable rate limiting
weight: 300
toc: true
nd-docs: DOCS-899
url: /nginxaas/azure/quickstart/rate-limiting/
type:
- how-to
---

F5 NGINXaaS for Azure (NGINXaaS) supports rate limiting using the [ngx_http_limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) module to limit the processing rate of requests. For more information on rate limiting with NGINX, see [NGINX Limiting Access to Proxied HTTP Resources](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-proxied-http/) and [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/).

## Configuring basic rate limiting

```nginx
http {
    #...

    limit_req_zone $binary_remote_addr zone=mylimit:10m rate=1r/s;

    server {
        #...

        location /login/ {
            limit_req zone=mylimit;

        }
}
```

{{< call-out "note" >}}As a prerequisite to using the `sync` parameter with `limit_req_zone` directive for rate limiting, enable [Runtime State Sharing with NGINXaaS for Azure]({{< ref "/nginxaas-azure/quickstart/runtime-state-sharing.md" >}}).{{< /call-out >}}
