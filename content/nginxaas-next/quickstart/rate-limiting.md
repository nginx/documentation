---
title: Enable rate limiting
weight: 300
toc: true
nd-docs: DOCS-000
url: /nginxaas/next/quickstart/rate-limiting/
type:
- how-to
---


{{< call-out "warning">}}This page has not been updated yet. Currently it has the NGINXaaS for Azure content{{< /call-out >}}

F5 NGINX as a Service for NEXCLOUD (NGINXaaS) supports rate limiting using the [ngx_http_limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) module to limit the processing rate of requests. For more information on rate limiting with NGINX, see [NGINX Limiting Access to Proxied HTTP Resources](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-proxied-http/) and [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/).

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

{{< call-out "note" >}}As a prerequisite to using the `sync` parameter with `limit_req_zone` directive for rate limiting, enable [Runtime State Sharing with NGINXaaS for NEXCLOUD]({{< ref "/nginxaas-next/quickstart/runtime-state-sharing.md" >}}).{{< /call-out >}}
