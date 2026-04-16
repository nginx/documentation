---
title: Advanced features with NGINX Plus
weight: 300
nd-content-type: reference
nd-product: FABRIC
nd-docs: DOCS-1837
---

NGINX Gateway Fabric can use NGINX Open Source or NGINX Plus as its data plane. [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the closed source, commercial version of NGINX. Using NGINX Plus as the data plane offers additional benefits compared to the open source version.

## Benefits of NGINX Plus

- **Robust metrics**: A plethora of [additional Prometheus metrics]({{< ref "/ngf/monitoring/prometheus.md" >}}) are available.
- **Live activity monitoring**: The [NGINX Plus dashboard]({{< ref "/ngf/monitoring/dashboard.md" >}}) shows real-time metrics and information about your server infrastructure.
- **Dynamic upstream configuration**: NGINX Plus can dynamically reconfigure upstream servers when applications in Kubernetes scale up and down, preventing the need for an NGINX reload.
- **Session persistence**: NGINX Plus provides support for cookie-based session persistence, allowing client requests to be consistently routed to the same upstream pod.
- **Load balancing methods**: NGINX Plus provides advanced, latency-aware load balancing methods (such as `least_time` and `least_time last_byte inflight`) that route traffic based on time to first byte or full response, optionally factoring in in-flight requests for smarter upstream selection.
- **JWT and OIDC Authentication**: [JSON Web Token (JWT)]({{< ref "/ngf/traffic-security/jwt-authentication.md" >}}) and [OpenID Connect (OIDC)]({{< ref "/ngf/traffic-security/oidc-authentication.md" >}}) authentication support for access control and auth delegation.
- **Support**: With an NGINX Plus license, you can take advantage of full [support](https://my.f5.com/manage/s/article/K000140156/) from NGINX, Inc.
