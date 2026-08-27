---
title: "NGINX config restrictions"
description: "Reference for NGINX configuration restrictions specific to F5 Application Delivery Service for AWS deployments."
weight: 150
toc: true
f5-docs: DOCS-000
url: /application-delivery-service/aws/deploy/nginx-configuration/nginx-config-restrictions/
f5-content-type: reference
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 Application Delivery Service for AWS, NGINX configuration, listen restrictions, proxy_protocol, IPv6, UDP, QUIC, listen ports"
f5-summary: >
  This reference documents NGINX configuration restrictions that apply specifically to F5 Application Delivery Service for AWS deployments, beyond the general F5 Application Delivery Service for AWS restrictions.
  Use it to look up listener, protocol, and port limits before you upload a configuration.
f5-audience: operator
---

F5 Application Delivery Service for AWS enforces additional restrictions on NGINX configurations to support its managed network interfaces. These restrictions are validated when you upload a configuration; configurations that violate any restriction are rejected before they are applied.

## Listen address restrictions

For general listen address and port restrictions that apply to all F5 Application Delivery Service for AWS deployments, see [Listener restrictions]({{< ref "/ads/overview/nginx-configuration/configuration-rules.md#listener-restrictions" >}}).

## IPv6 requirement for UDP and QUIC

F5 Application Delivery Service for AWS requires using an IPv6 address on listener ports configured for UDP or QUIC protocols. For example, a UDP listener can be configured as `listen [::]:53 udp;`. If a port configured for UDP or QUIC does not include an IPv6 listening address, the NGINX configuration cannot be applied to an AWS deployment.

{{< call-out class="note" title="Note" >}}

Configuring the NGINX deployment to listen on IPv6 does not restrict or otherwise impact the IP address type used for incoming client traffic or upstream traffic. F5 Application Delivery Service for AWS ensures that IPv4 and IPv6 client traffic is always supported to the frontend service, and you can configure upstream traffic to use IPv4, IPv6, or both based on your application's needs.

{{< /call-out >}}

## proxy_protocol consistency

All `listen` directives for a given port (across every server block in the configuration) must have a consistent `proxy_protocol` setting. Enabling `proxy_protocol` on some listeners for a port while leaving it disabled on others is not supported.

## IPv4 and IPv6 across server blocks

All `listen` directives for the same port must use the same address family:

- **Merging within a single server block**: When a server block contains both an IPv4 listener and an IPv6 listener on the same port, F5 Application Delivery Service for AWS collapses them into a single port entry that carries both address families. That entry includes IPv6, so the NLB listener for that port is created as an IPv6 target group.
- **Cross-server-block mixing is not allowed**: If port _N_ is referenced with an IPv6 address in one server block, every other server block that references port _N_ must also use IPv6. An IPv4-only listener for the same port in a different server block is not supported.

## Unique listen port limit

A configuration can define at most 50 unique listen ports across the entire configuration. Configurations with more than 50 unique listen ports are not supported.

## What's next

[Monitor your deployment]({{< ref "/ads/aws/monitoring/enable-monitoring.md" >}})