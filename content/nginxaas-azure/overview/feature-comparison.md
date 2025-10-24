---
title: Feature overview
weight: 300
description: Compare NGINXaaS for Azure with other NGINX offerings.
toc: false
nd-docs: DOCS-1473
url: /nginxaas/azure/overview/feature-comparison/
type:
- concept
---

NGINXaaS for Azure delivers the core capabilities of NGINX as a managed service, integrated with Microsoft Azure. It provides most of the features of NGINX Open Source and many from NGINX Plus, but some capabilities are not included.

Below is a feature breakdown with notes on support and limitations.


## Load balancing

- [HTTP and TCP/UDP load balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)
- [Layer 7 request routing](https://www.nginx.org/en/docs/http/ngx_http_core_module.html#location)
- [Session persistence](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#enabling-session-persistence)
- [Active health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/)
- [DNS-based service discovery](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#service)

---

## Content caching

- [Static and dynamic content caching](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/)
- MQTT protocol support for IoT devices

**Limitation:**

- [Cache purging API](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/#purging-content-from-the-cache) is not available

---

## Web server and reverse proxy

- Origin server for static content  
- Reverse proxy for [HTTP](https://nginx.org/en/docs/http/ngx_http_proxy_module.html), [FastCGI](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html), [memcached](https://nginx.org/en/docs/http/ngx_http_memcached_module.html), [SCGI](https://nginx.org/en/docs/http/ngx_http_scgi_module.html), and [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html)
- [HTTP/2 gateway](https://www.nginx.org/en/docs/http/ngx_http_v2_module.html)
- [gRPC proxy](https://nginx.org/en/docs/http/ngx_http_grpc_module.html)
- [HTTP/2 server push](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push)
- [HTTP/3 over QUIC](https://nginx.org/en/docs/http/ngx_http_v3_module.html)

---

## Security

- [HTTP basic authentication](https://www.nginx.org/en/docs/http/ngx_http_auth_basic_module.html)
- [Authentication subrequests](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html) (For external authentication systems)
- [IP-based access controls](https://nginx.org/en/docs/http/ngx_http_access_module.html)
- [Rate limiting](https://blog.nginx.org/blog/rate-limiting-nginx)
- Dual-stack RSA/ECC SSL/TLS offload
- TLS 1.3 support
- [JWT authentication](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- OpenID Connect SSO
- NGINX as a SAML Service Provider  
- [F5 WAF for NGINX](https://www.f5.com/products/nginx/nginx-app-protect) (Available at an extra cost)  

**Limitations:** 

- Internal redirect and F5 WAF for NGINX DoS are not available

---

## Monitoring

- Export metrics directly into [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)
- Dashboards in [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview) and [Azure Portal](https://azure.microsoft.com/en-us/get-started/azure-portal)
- [Extended status with 100+ metrics](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/)

**Limitations:**  

- No built-in live dashboard like NGINX Plus; visibility is provided through Azure Monitor instead
- Native OpenTelemetry tracing is not available

---

## High availability (HA)

- [Active-active HA](https://docs.nginx.com/nginx/admin-guide/high-availability/)
- [Configuration synchronization across the cluster](https://docs.nginx.com/nginx/admin-guide/high-availability/configuration-sharing/)
- [State sharing](https://docs.nginx.com/nginx/admin-guide/high-availability/zone_sync/) for session persistence, rate limiting, and key-value store

**Limitation:**

- [Active-passive HA](https://docs.nginx.com/nginx/admin-guide/high-availability/) is not applicable in the managed service model

---

## Programmability

- [NGINX JavaScript (njs) module](https://www.f5.com/company/blog/nginx/harnessing-power-convenience-of-javascript-for-each-request-with-nginx-javascript-module)
- [Key-value store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html)

**Limitations:**  

- [NGINX Plus API for dynamic reconfiguration](https://docs.nginx.com/nginx/admin-guide/load-balancer/dynamic-configuration-api/) is not available

---

## Streaming media

- Live streaming: RTMP, HLS, DASH
- VOD: Flash (FLV), MP4

**Limitations:** 

- Adaptive bitrate streaming (HLS/HDS) and [MP4 bandwidth controls](https://nginx.org/en/docs/http/ngx_http_mp4_module.html) are not available

---

## Ecosystem and extensibility

- Dynamic module support for:  
  - [Image-Filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html)
  - [njs](https://nginx.org/en/docs/njs/)
  - [OpenTelemetry](https://nginx.org/en/docs/ngx_otel_module.html)
  - [XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html)
- Delivered as a managed service in Microsoft Azure
- [Commercial support](https://my.f5.com/manage/s/article/K000140156/) from F5

**Limitations:**  

- [Ingress Controller](https://www.f5.com/products/nginx/nginx-ingress-controller) and OpenShift Router are not included
- Dynamic module repository is limited compared to NGINX Plus

---

{{< include "/nginx-plus/oss-plus-comparison.md" >}}
