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

## NGINXaaS for Google Cloud architecture

{{< img src="nginxaas-google/nginxaas-google-cloud-architecture.png" alt="Architecture diagram of NGINXaaS for Google Cloud showing user traffic through load balancers to applications, with control plane management via the NGINXaaS Console, GCP Marketplace, and Identity Provider, plus logging, monitoring, and secret management." >}}

At the top, administrators connect to the NGINXaaS Console, which connects to the GCP Marketplace and an SSO Identity Provider. The GCP Marketplace manages accounts and entitlements, and the Identity Provider integrates with the NGINXaaS Console.

The NGINXaaS Console (part of the NGINX One platform) sits in an NGINXaaS Geographic Area Controller (for example, US, CA, EU) and handles control plane/management functions. It communicates with GCP Provisioning APIs and pushes configuration updates to the NGINX Data Plane VPC.

Inside the NGINX Data Plane VPC, a GCP Load Balancer (L4 Passthrough LB) connects to the NGINX instance, which is integrated with an NGINX Agent and optional NAP (App Protect) Enforcer. Application users connect through Public or Private Endpoints via a Proxy Load Balancer and Network Endpoint Group to upstream applications.

Logs and metrics flow to GCP Cloud Logging and Cloud Monitoring, while secrets and certificates are managed by GCP Secret Manager.

### Geographical Controllers

NGINXaaS for Google has a global presence with management requests being served from various geographical controllers. A Geographical Controller (GC) is a controlplane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. We currently have presence in two Geographies: **US** and **EU**.

### Networking

We use Google [Private Service Connect]((https://cloud.google.com/vpc/docs/private-service-connect)) (PSC) to securely connect NGINXaaS to your applications and enable client access to your deployments. A [PSC backend](https://cloud.google.com/vpc/docs/private-service-connect#backends) brings the NGINXaaS deployment into your client network, allowing your application clients to connect seamlessly. A [PSC Interface](https://cloud.google.com/vpc/docs/private-service-connect#interfaces) brings the deployment into your application network, enabling secure connectivity to your applications. This approach gives you full control over traffic flow by leveraging your own networking resources, so you can apply your preferred security controls and ensure a secure deployment environment.

### Redundancy

With the Standard Plan, NGINXaaS uses the following redundancy features to keep your service available.

- We run _at least_ two NGINX Plus instances for each deployment in an active-active pattern
- NGINX Plus is constantly monitored for health. Any unhealthy instances are replaced with new ones
- <<If Google Cloud has any redundancy features, we will mention them here>> TBD

## Supported regions

NGINXaaS for Google Cloud is supported in the following regions per geography:

   {{< table "table" >}}
   |NGINXaaS Geography | Google Cloud Regions |
   |-----------|---------|
   | US  | us-west1, us-east1, us-central1 |
   | EU    | europe-west2, europe-west1 |
   {{< /table >}}

## Limitations

- We currently support two geographies with limited regions only.
- We only support authentication via Google acting as an identity provider.
- User Role Based Access Control (RBAC) is not supported.
- NGINX Configuration needs a specific snippet for an NGINXaaS deployment to work.

## What's next

To get started, check the [NGINXaaS for Google Cloud prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}})
