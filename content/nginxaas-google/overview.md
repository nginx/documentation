---
title: Overview and architecture
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/overview/
type:
- concept
---

## What Is F5 NGINXaaS for Google Cloud?

NGINXaaS for Google Cloud is a service offering that is tightly integrated into Google Cloud platform and its ecosystem, making applications fast, efficient, and reliable with full lifecycle management of advanced NGINX traffic services.

[NGINX Plus](https://www.nginx.com/products/nginx/) powers NGINXaaS for Google Cloud, which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution.

NGINXaaS handles the NGINX Plus license management automatically.

## Capabilities

The key capabilities of NGINXaaS for Google Cloud are:

- Simplifies onboarding by providing a fully managed, ready-to-use NGINX service, eliminating the need for infrastructure setup, manual upgrades, or operational overhead.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the Google Cloud ecosystem.
- Adopts a consumption-based pricing to align infrastructure costs to actual usage by billing transactions using Google.

## NGINXaaS for Google Cloud architecture

{{< img src="nginxaas-google/nginxaas-google-cloud-architecture.svg" alt="Architecture diagram showing how NGINXaaS integrates with Google Cloud. At the top, inside the Google Cloud IaaS layer, NGINX Plus is managed using UI, API, and Terraform, alongside NGINXaaS. Admins connect to this layer. Below, in the Customer VPC, end users connect through Edge Routing to multiple App Servers (labeled App Server 1). NGINX Plus directs traffic to these app servers. The Customer VPC also connects with Google Cloud services such as Secret Manager, Monitoring, and other services. Green arrows show traffic flow from end users through edge routing and NGINX Plus to app servers, while blue arrows show admin access." >}}

- The NGINXaaS Console is used to create, update, and delete NGINX configurations, certificates and NGINXaaS deployments
- Each NGINXaaS deployment has dedicated network and compute resources. There is no possibility of noisy neighbor problems or data leakage between deployments
- NGINXaaS can route traffic to upstreams even if the upstream servers are located in different geographies. See [Known Issues]({{< ref "/nginxaas-google/known-issues.md" >}}) for any networking restrictions.
- NGINXaaS supports request tracing. See the [Application Performance Management with NGINX Variables](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus) blog to learn more about tracing.
- Supports HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects. NGINXaaS also provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules | NGINX](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details.
- Google Cloud's Private Service Connect (PSC) enables clients within your Virtual Private Cloud (VPC) to access your NGINXaaS deployments. PSC also provides NGINXaaS a secure and private way to connect to your upstream applications. Known networking limitations can be found in the [Known Issues]({{< ref "/nginxaas-google/known-issues.md" >}}).

### Geographical Controllers

NGINXaaS for Google has a global presence with management requests being served from various geographical controllers. A Geographical Controller (GC) is a control plane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. We currently have presence in two Geographies: **US** and **EU**.

### Networking

We use Google [Private Service Connect]((https://cloud.google.com/vpc/docs/private-service-connect)) (PSC) to securely connect NGINXaaS to your applications and enable client access to your deployments. A [PSC backend](https://cloud.google.com/vpc/docs/private-service-connect#backends) brings the NGINXaaS deployment into your client network, allowing your application clients to connect seamlessly. A [PSC Interface](https://cloud.google.com/vpc/docs/private-service-connect#interfaces) brings the deployment into your application network, enabling secure connectivity to your applications. This approach gives you full control over traffic flow by leveraging your own networking resources, so you can apply your preferred security controls and ensure a secure deployment environment.


## Supported regions

NGINXaaS for Google Cloud is supported in the following regions per geography:

   {{< table "table" >}}
   |NGINXaaS Geography | Google Cloud Regions |
   |-----------|---------|
   | US  | us-west1, us-east1, us-central1 |
   | EU    | europe-west2, europe-west1 |
   {{< /table >}}

## Limitations

- As mentioned above, we currently support two geographies with limited regions only.
- We only support authentication via Google acting as an identity provider.
- User Role Based Access Control (RBAC) is not yet supported.
- NGINX Configurations require a specific snippet for an NGINXaaS deployment to work.
   - For specifics see [NGINX configuration required content]({{< ref "nginxaas-google/getting-started/nginx-configuration/overview.md#nginx-configuration-required-content" >}}).

## What's next

To get started, check the [NGINXaaS for Google Cloud prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}})
