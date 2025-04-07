---
title: Enable content caching
weight: 200
toc: true
docs: DOCS-897
url: /nginxaas/azure/quickstart/basic-caching/
type:
- how-to
---

F5 NGINX as a Service for Azure (NGINXaaS) supports caching using the [ngx_http_proxy_module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) module, improving performance by allowing content to be served from cache without having to contact upstream servers. For more information on caching with NGINX, see [NGINX Content Caching](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/).

## Configuring caching
```nginx
http {
    # ...
    proxy_cache_path /var/cache/nginx keys_zone=mycache:10m;
}
```

NGINXaaS for Azure only supports caching to `/var/cache/nginx`. This is because data at `/var/cache/nginx` will be stored in a separate [Temporary Disk](https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview#temporary-disk). The size of the temporary disk is 4GB.

## Limitations

Currently, `proxy_cache_purge` might not work as expected because NGINXaaS [deploys multiple instances of NGINX Plus]({{< ref "/nginxaas-azure/overview/overview.md#architecture" >}}) for high availability. The `PURGE` request will be routed to a single instance, and only the matched values on that instance will be purged.
