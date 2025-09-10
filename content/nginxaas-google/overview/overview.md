---
title: Overview and architecture
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/overview/overview/
type:
- concept
---

## What Is F5 NGINXaaS for Google Cloud?

NGINXaaS for Google Cloud is a service offering that is tightly integrated into Google Cloud platform and its ecosystem, making applications fast, efficient, and reliable with full lifecycle management of advanced NGINX traffic services.
NGINXaaS for Google Cloud is available in the Google Cloud Marketplace.

NGINXaaS for Google Cloud is powered by [NGINX Plus](https://www.nginx.com/products/nginx/), which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution. Initial use cases covered by NGINXaaS include L4 TCP and L7 HTTP load balancing and reverse proxy which can be managed through various Google Cloud management tools.
NGINXaaS allows you to provision distinct deployments as per your business or technical requirements.

NGINXaaS handles the NGINX Plus license management automatically.

## Capabilities

The key capabilities of NGINXaaS for Google Cloud are:

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

- TBD

## Supported regions

NGINXaaS for Google Cloud is supported in the following regions:

- TBD


## NGINXaaS architecture

TBD << This is where I would put my architecture diagram, if I had one >>


### Redundancy

With the Standard Plan, NGINXaaS uses the following redundancy features to keep your service available.

- We run _at least_ two NGINX Plus instances for each deployment in an active-active pattern
- NGINX Plus is constantly monitored for health. Any unhealthy instances are replaced with new ones
- <<If Google Cloud has any redundancy features, we will mention them here>> TBD


## What's next

To get started, check the [NGINXaaS for Google Cloud prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}})
