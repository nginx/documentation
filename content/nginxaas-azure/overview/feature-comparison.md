---
title: Feature comparison
weight: 300
description: Compare NGINXaaS for Azure with other NGINX offerings.
toc: false
nd-docs: DOCS-1473
url: /nginxaas/azure/overview/feature-comparison/
type:
- concept
---

{{<bootstrap-table "table table-striped table-bordered">}}

|**Load Balancer**<br>&nbsp;&nbsp;       |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**F5 NGINXaaS<br>for Azure**     |
|----------------------------------------|---------------------|---------------------|--------------------------|
|&nbsp;&nbsp;[HTTP](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) and [TCP/UDP](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/) support    |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[Layer 7 request routing](https://www.nginx.org/en/docs/http/ngx_http_core_module.html#location)     |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[Session persistence](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#enabling-session-persistence)         |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[Active health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/)        |                     |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[DNS service-discovery integration](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#service)   |             |{{<check>}}          |{{<check>}}               |
|**Content Cache**                       |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;[Static and dynamic content caching](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/)|{{<check>}}    |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[Cache-purging API](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/#purging-content-from-the-cache)           |                     |{{<check>}}          |                          |
|&nbsp;&nbsp;MQTT protocol support for IOT devices          |                     |{{<check>}}          |{{<check>}}             |
|**Web Server and Reverse Proxy**        |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;Origin server for static content    |{{<check>}}  |{{<check>}}          |{{<check>}}                          |
|&nbsp;&nbsp;Reverse proxy: [HTTP](https://nginx.org/en/docs/http/ngx_http_proxy_module.html), [FastCGl](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html),<br>&nbsp;&nbsp;[memcached](https://nginx.org/en/docs/http/ngx_http_memcached_module.html), [SCGI](https://nginx.org/en/docs/http/ngx_http_scgi_module.html), [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) |{{<check>}} | {{<check>}} |{{<check>}}   |
|&nbsp;&nbsp;[HTTP/2 gateway](https://www.nginx.org/en/docs/http/ngx_http_v2_module.html)             |{{<check>}}           |{{<check>}}         |{{<check>}}               |
|&nbsp;&nbsp;[gRPC proxy](https://nginx.org/en/docs/http/ngx_http_grpc_module.html)                  |{{<check>}}           |{{<check>}}         |{{<check>}}               |
|&nbsp;&nbsp;[HTTP/2 server push](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push)        |{{<check>}}           |{{<check>}}         |{{<check>}}               |
|&nbsp;&nbsp;[HTTP/3 over QUIC](https://nginx.org/en/docs/http/ngx_http_v3_module.html)            |{{<check>}}           |{{<check>}}         |{{<check>}}               |
|**Security Controls**                   |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;[HTTP basic authentication](https://www.nginx.org/en/docs/http/ngx_http_auth_basic_module.html)   |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[HTTP authentication subrequests](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html) |{{<check>}}      |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[IP address-based access control lists](https://nginx.org/en/docs/http/ngx_http_access_module.html) |{{<check>}}|{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[Rate limiting](https://blog.nginx.org/blog/rate-limiting-nginx)               |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;Dual-stack RSA/ECC SSL/TLS offload |{{<check>}}   |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;TLS 1.3 support             |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[JWT authentication](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)          |                     |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;OpenID Connect single sign-on<br>&nbsp;&nbsp;(SSO) |  |{{<check>}}      |{{<check>}}               |
|&nbsp;&nbsp;Internal redirect |             |{{<check>}}          |                          |
|&nbsp;&nbsp;NGINX as a SAML Service Provider |             |{{<check>}}          |{{<check>}}                  |
|&nbsp;&nbsp;[NGINX App Protect WAF](https://www.f5.com/products/nginx/nginx-app-protect) (additional cost) |             |{{<check>}}          |{{<check>}}          |
|&nbsp;&nbsp;[F5 DoS for NGINX](https://www.f5.com/products/nginx/nginx-app-protect) (additional cost) |             |{{<check>}}          |                          |
|**Monitoring**                          |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;Export to [external monitoring tools](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/)  |{{<check>}} |{{<check>}}          |Export metrics to<br>Azure Monitor |
|&nbsp;&nbsp;Built-in dashboard          |                     |{{<check>}}          |[Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)<br> and [Azure Portal](https://azure.microsoft.com/en-us/get-started/azure-portal)       |
|&nbsp;&nbsp;[Extended status with 100+<br>&nbsp;&nbsp;additional metrics](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/) | |{{<check>}} |{{<check>}}            |
|&nbsp;&nbsp;Native Open Telemetry Tracing |             |{{<check>}}          |                          |
|**High Availability (HA)**              |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;[Active-active](https://docs.nginx.com/nginx/admin-guide/high-availability/)               |                     |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[Active-passive](https://docs.nginx.com/nginx/admin-guide/high-availability/)              |                     |{{<check>}}          | Not Applicable           |
|&nbsp;&nbsp;[Configuration synchronization<br>&nbsp;&nbsp;across cluster](https://docs.nginx.com/nginx/admin-guide/high-availability/configuration-sharing/) | |{{<check>}} |{{<check>}}            |
|&nbsp;&nbsp;[State sharing](https://docs.nginx.com/nginx/admin-guide/high-availability/zone_sync/): sticky-learn session<br>&nbsp;&nbsp;persistence, rate limiting, key-value<br>&nbsp;&nbsp;stores |          |{{<check>}}          |{{<check>}}         |
|**Programmability**                     |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;[NGINX JavaScript module](https://www.f5.com/company/blog/nginx/harnessing-power-convenience-of-javascript-for-each-request-with-nginx-javascript-module)     |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;[NGINX Plus API for dynamic<br>&nbsp;&nbsp;reconfiguration](https://docs.nginx.com/nginx/admin-guide/load-balancer/dynamic-configuration-api/) | |{{<check>}} |                         |
|&nbsp;&nbsp;[Key-value store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html)             |                     |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;Dynamic reconfiguration without<br>&nbsp;&nbsp;process reloads | |{{<check>}} |                    |
|**Streaming Media**                     |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;Live streaming: RTMP, HLS, DASH |{{<check>}}      |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;VOD: Flash (FLV), MP4       |{{<check>}}          |{{<check>}}          |{{<check>}}               |
|&nbsp;&nbsp;Adaptive bitrate VOD: [HLS](https://nginx.org/en/docs/http/ngx_http_hls_module.html), [HDS](https://nginx.org/en/docs/http/ngx_http_f4f_module.html)   |                 |{{<check>}}          |                          |
|&nbsp;&nbsp;[MP4 bandwidth controls](https://nginx.org/en/docs/http/ngx_http_mp4_module.html)      |                     |{{<check>}}          |                          |
|**Third-party ecosystem**               |**NGINX Open<br>Source** |**NGINX Plus<br>&nbsp;** |**NGINXaaS<br>for Azure**     |
|&nbsp;&nbsp;[Ingress controller](https://www.f5.com/products/nginx/nginx-ingress-controller)          |{{<check>}}          |{{<check>}}          |                          |
|&nbsp;&nbsp;OpenShift Router            |{{<check>}}          |{{<check>}}          |                          |
|&nbsp;&nbsp;[Dynamic modules repository](https://www.f5.com/go/product/nginx-modules)  |                     |{{<check>}}          |[Image-Filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html)<br />[njs](https://nginx.org/en/docs/njs/)<br />[OpenTelemetry](https://nginx.org/en/docs/ngx_otel_module.html)<br />[XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html)       |
|&nbsp;&nbsp;Deployable as a service     |                     |                     |Microsoft Azure           |
|&nbsp;&nbsp;[Commercial support](https://my.f5.com/manage/s/article/K000140156/)          |                     |{{<check>}}          |{{<check>}}               |
{{</bootstrap-table>}}
