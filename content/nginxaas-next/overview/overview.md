---
title: Overview and architecture
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/next/overview/overview/
type:
- concept
---


{{< call-out "warning">}}This page has not been updated yet. Currently it has the NGINXaaS for Azure content{{< /call-out >}}

## What Is F5 NGINX as a Service for NEXCLOUD?

NGINX as a Service for NEXCLOUD is a service offering that is tightly integrated into Google Cloud platform and its ecosystem, making applications fast, efficient, and reliable with full lifecycle management of advanced NGINX traffic services.
NGINXaaS for NEXCLOUD is available in the Google Cloud Marketplace.

NGINXaaS for NEXCLOUD is powered by [NGINX Plus](https://www.nginx.com/products/nginx/), which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution. Initial use cases covered by NGINXaaS include L4 TCP and L7 HTTP load balancing and reverse proxy which can be managed through various Google Cloud management tools.
NGINXaaS allows you to provision distinct deployments as per your business or technical requirements.

NGINXaaS handles the NGINX Plus license management automatically.

## Capabilities

The key capabilities of NGINXaaS for NEXCLOUD are:

- Simplifies onboarding by leveraging NGINX as a service.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the Google Cloud ecosystem.
- Addresses a wide range of deployment scenarios (HTTP reverse proxy, JWT authentication, etc).
- Adopts a consumption-based pricing to align infrastructure costs to actual usage by billing transactions using Azure.
- Supports end-to-end encryption from client to upstream server.
- Supports the following protocols: HTTPS, HTTP, HTTP/2, HTTP/3, TCP, QUIC, IMAP, POP3, and SMTP.
- Supports any type of message body for upstream and error status code responses, including text/plain, text/css, text/html, application/javascript, and application/json.


## Limitations

- NGINXaaS supports at most one IPv4 and one IPv6 IP address at any given time.
- NGINXaaS doesn't support a mix of public and private IPs at this time.
- The IP address associated with an NGINXaaS deployment can't be changed from public to private, or from private to public.

## Supported regions

NGINXaaS for NEXCLOUD is supported in the following regions:
- US
- EMEA


## NGINXaaS architecture

<< This is where I would put my architecture diagram, if I had one >>


### Redundancy

With the Standard Plan, NGINXaaS uses the following redundancy features to keep your service available.

- We run _at least_ two NGINX Plus instances for each deployment in an active-active pattern
- NGINX Plus is constantly monitored for health. Any unhealthy instances are replaced with new ones
- <<If Google Cloud has any redundancy features, we will mention them here>>


## What's next

To get started, check the [NGINX as a Service for NEXCLOUD prerequisites]({{< ref "/nginxaas-next/getting-started/prerequisites.md" >}})
