---
title: Overview and architecture
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/google/overview/
f5-content-type: concept
f5-product: NGOOGL
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
- NGINXaaS automatically adapts to application traffic demands through autoscaling
- Each NGINXaaS deployment has dedicated network and compute resources. There is no possibility of noisy neighbor problems or data leakage between deployments
- NGINXaaS can route traffic to upstreams even if the upstream servers are located in different geographies. See [Known Issues]({{< ref "/nginxaas-google/known-issues.md" >}}) for any networking restrictions.
- NGINXaaS supports request tracing. See the [Application Performance Management with NGINX Variables](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus) blog to learn more about tracing.
- Supports HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects. NGINXaaS also provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules | NGINX](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details.

### Service Frontend

The service frontend of an NGINXaaS deployment controls how client ingress traffic reaches your deployment. There are two frontend types: **Managed Public Endpoint** and **Private Endpoint**.

#### Managed Public Endpoint

A managed public endpoint frontend allows client access over the internet through a public DNS name created by NGINXaaS in its network.

**This frontend type is suitable for:**

- Serving public web applications to end users over the internet
- Proxying traffic from clients outside Google Cloud
- Testing NGINXaaS configurations before you set up a [Private Endpoint]({{< ref "/nginxaas-google/overview.md#private-endpoint" >}}) frontend

**Access control**

Access control list (ACL) rules control traffic to a managed public endpoint deployment. If you don’t provide ACL rules, no traffic is allowed. An ACL rule includes the following settings:

- **Source prefixes**: A list of CIDR blocks to allow traffic from
    - Use `0.0.0.0/0` to allow traffic from all source IP addresses
- **Protocol**: The network protocol to allow
    - Valid values are **TCP** and **UDP**
    - Required when you specify a port range
- **Port range**: A single port or port range to allow traffic from
    - If you don’t specify a port range, traffic is allowed from any port
    - Required when you specify a protocol

#### Private Endpoint

A private endpoint frontend allows client access through your network by using Google’s [Private Service Connect (PSC)](https://cloud.google.com/vpc/docs/private-service-connect). To set up connectivity, create either a [PSC endpoint](https://docs.cloud.google.com/vpc/docs/private-service-connect#endpoints) for internal traffic or a [PSC backend](https://cloud.google.com/vpc/docs/private-service-connect#backends) for external traffic. This approach brings the NGINXaaS deployment into your client network through an NGINXaaS-created service attachment, so application clients can connect directly into your network. For step-by-step instructions, see [Set up connectivity]({{< ref "/nginxaas-google/getting-started/create-deployment/deploy-console.md#set-up-connectivity-private-endpoint-only" >}}).

**This frontend type is suitable for:**

- Situations where you need greater control over traffic to the NGINXaaS deployment
- Environments where all clients exist within your Google Cloud network
- Internal services that shouldn't be exposed to the internet

**Access control**

A service attachment accept list restricts which Google project IDs can connect to the deployment. If you don’t specify any project IDs in the accept list, traffic from all projects is allowed.

### Upstream network

NGINXaaS uses Google [Private Service Connect](https://cloud.google.com/vpc/docs/private-service-connect) (PSC) to connect securely to your applications.

A [PSC interface](https://cloud.google.com/vpc/docs/private-service-connect#interfaces) brings the deployment into your application network and supports secure connectivity to your applications. By using your own networking resources, you control traffic flow and can apply your preferred security controls.

To connect the NGINXaaS PSC interface to your network, you must create a [network attachment](https://cloud.google.com/vpc/docs/about-network-attachments). For steps, see {{< ref "/nginxaas-google/getting-started/create-deployment/deploy-console.md#create-a-network-attachment" >}}.

#### Connection draining

During scaling, some connections older than 60 seconds might be reset. The service automatically handles reconnects, so you don't need to wait before reconnecting.

### NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX deployment based on its underlying compute resources. This abstraction lets you specify capacity in NCUs without considering hardware differences between regions.
You can reserve a minimum capacity for your deployment. The deployment automatically scales up or down based on traffic demand and makes sure it never drops below the reserved minimum.

### Geographical Controllers

NGINXaaS for Google has a global presence, with management requests served by regional controllers. A geographical controller (GC) is a control plane that serves users within a defined geographic boundary while addressing data residency and localization requirements. For example, a US geographical controller serves customers in the United States. NGINXaaS currently operates in three geographies: US, EU, and Asia Pacific (APAC).

### Supported regions

{{< include "/nginxaas-google/supported-regions.md" >}}

## Current Limitations

We are committed to enhancing NGINXaaS for Google Cloud and welcome your feedback to help shape the future of our service. If there are features you'd like to see prioritized, we encourage you to submit a [support ticket]({{< ref "/nginxaas-google/get-help/support.md" >}}) to share your suggestions.

Here are the current constraints you should be aware of when while using NGINXaaS for Google Cloud:

- NGINXaaS is [supported in a limited number of regions]({{< ref "/nginxaas-google/overview.md#supported-regions" >}}). We are continually working to expand support across additional regions.
- We only support authentication via Google acting as an identity provider.
- User Role-Based Access Control (RBAC) is not yet supported, but this enhancement is on our roadmap as we improve access control for multi-user environments.

## What's next

To get started, check the [NGINXaaS for Google Cloud prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}})
