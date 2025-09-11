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

[F5 WAF for NGINX](https://www.f5.com/products/nginx/nginx-app-protect) is an advanced, lightweight and high-performance web application firewall (WAF) for applications and APIs. 

It provides protection for the OWASP Top 10, with additional functionality:

- HTTP response inspection and protocol compliance
- Data schema validation (JSON & XML)
- Meta character checking
- Disallowing file types

For more details, see the [Supported security policy features]({{< ref "/waf/fundamentals/technical-specifications.md#supported-security-policy-features">}}).

It is platform-agnostic and supports a range of deployment options for operational needs:

1. [Virtual environment (Bare metal)]({{< ref "/waf/install/virtual-environment.md" >}})
    - NGINX operates on the host system
    - WAF components are deployed in containers
    - Ideal for existing NGINX virtual environments
1. [Docker]({{< ref "/waf/install/docker.md" >}})
    - NGINX and WAF components are deployed as containers
    - Suitable for environments with multiple deployment stages
1. [Kubernetes]({{< ref "/waf/install/kubernetes.md" >}})
    - Integrates NGINX and WAF components in a single pod
    - Ideal for scalable, cloud-native environments

F5 WAF for NGINX is part of the [NGINX One](https://www.f5.com/products/nginx/one) premium packages and runs natively on [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) and [NGINX Ingress Controller](https://www.f5.com/products/nginx/nginx-ingress-controller). 
