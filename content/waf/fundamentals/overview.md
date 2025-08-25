---
# We use sentence case and present imperative tone
title: "Overview"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is to describing what NGINX App Protect is, expanding on the detail from the [landing page]({{< ref "/waf/" >}}).

It is also an opportunity to explain the difference between NGINX App Protect versions, and how integrates with other products in the NGINX ecosystem.

The text here will likely be synthesized from the Overview descriptions at the top of the [Administration Guides]({{< ref "/nap-waf/v4/admin-guide/install.md#overview" >}}), but there's also detail from [F5.com](https://www.f5.com/products/nginx/nginx-app-protect) that can be added.

{{< /call-out >}}

[F5 WAF for NGINX](https://www.f5.com/products/nginx/nginx-app-protect) is an advanced, lightweight and high-performance web application firewall (WAF) for applications and APIs. 

It provides protection for the OWASP Top 10, with additional functionality:

- HTTP response inspection and protocol compliance
- Data schema validation (JSON & XML)
- Meta character checking
- Disallowing file types

For more details, see the [Supported security policy features]({{< ref "/waf/fundamentals/technical-specifications.md#supported-security-policy-features">}}).

F5 WAF for NGINX is part of the [NGINX One](https://www.f5.com/products/nginx/one) premium packages and runs natively on [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) and [NGINX Ingress Controller](https://www.f5.com/products/nginx/nginx-ingress-controller). 

It is platform-agnostic and supports deployment options ranging from edge load balancers to individual pods in Kubernetes clusters.
