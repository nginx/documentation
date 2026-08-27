---
title: About
weight: 100
toc: true
f5-docs: DOCS-000
url: /application-delivery-service/overview/about/
f5-content-type: concept
f5-product: F5 Application Delivery Service
---

## What is F5 ${product}?

${product} is a service offering that is tightly integrated into your cloud platform and its ecosystem, making applications fast, efficient, and reliable with full lifecycle management of advanced NGINX traffic services.

${product} is powered by [NGINX Plus](https://www.nginx.com/products/nginx/), which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution. ${product} handles the NGINX Plus license management automatically.

## Capabilities

The key capabilities of ${product} are:

- Simplifies onboarding by providing a fully managed, ready-to-use NGINX service, eliminating the need for infrastructure setup, manual upgrades, or operational overhead.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with your cloud provider's ecosystem.
- ${product} keeps your SSL private keys and other secrets secure and easy to manage.
- Adopts a consumption-based pricing model to align infrastructure costs to actual usage.
- ${product} is used to create, update, and delete NGINX configurations, certificates, and deployments.
- ${product} automatically adapts to application traffic demands through autoscaling.
- Each ${product} deployment has dedicated network and compute resources. There is no possibility of noisy neighbor problems or data leakage between deployments.
- Makes collecting and reviewing access logs and NGINX metrics painless and accessible.
- ${product} supports request tracing. See the [Application Performance Management with NGINX Variables](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus) blog to learn more about tracing.
- Supports HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects. ${product} also provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details.

## Availability

${product} is available for use with multiple public cloud providers. See specific documentation for more details:

- [F5 Application Delivery Service for AWS]({{< ref "/ads/aws/overview.md" >}})
- [F5 Application Delivery Service for Google Cloud]({{< ref "/ads/google/overview.md" >}})
