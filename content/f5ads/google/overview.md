---
title: Overview and architecture
description: "Overview of F5 Application Delivery Service for Google Cloud architecture, capabilities, and how it integrates with your Google Cloud environment."
weight: 100
toc: true
f5-docs: DOCS-000
f5-content-type: concept
f5-product: F5 Application Delivery Service for Google Cloud
f5-keywords: "F5 ADS for Google Cloud, architecture, service frontend, private endpoint, managed public endpoint, upstream network, NGINX Capacity Unit, NCU, geographical controller"
f5-summary: >
  NGINX Plus powers F5 Application Delivery Service for Google Cloud, a fully managed, Google Cloud-native SaaS load balancer and application delivery service.
  This overview covers its architecture, service frontend types, upstream connectivity, and capacity model, so you understand how it fits into your Google Cloud environment before you deploy.
f5-audience: any
---

## What is F5 Application Delivery Service for Google Cloud?

F5 Application Delivery Service for Google Cloud (F5 ADS for Google Cloud) is a SaaS offering tightly integrated with Google Cloud and its ecosystem of services. It helps make your applications fast, efficient, and reliable, using advanced traffic management from [NGINX Plus](https://www.nginx.com/products/nginx/) without the operational overhead.

NGINX Plus extends NGINX Open Source with advanced functionality, giving you a complete application delivery solution. F5 ADS handles NGINX Plus license management automatically.

{{<card-section showAsCards="true" isFeaturedSection="false">}}
  {{<card title="Prerequisites" titleUrl="/app-delivery/google/deploy/prerequisites/" icon="power">}}
    Follow these steps to prepare for your F5 ADS deployment
  {{</card>}}
  {{<card title="Create a deployment" titleUrl="/app-delivery/google/deploy/create-deployment/deploy-console/" icon="cloud-upload">}}
    Step-by-step instructions to deploy F5 ADS using the F5 ADS Console
  {{</card>}}
  {{<card title="Add certificates" titleUrl="/app-delivery/google/deploy/ssl-tls-certificates/ssl-tls-certificates-console/" icon="lock">}}
    Instructions to add SSL/TLS certificates to your F5 ADS deployment using the F5 ADS Console
  {{</card>}}
  {{<card title="Get help" titleUrl="/app-delivery/google/support/" icon="message-circle-question-mark">}}
    Contact F5 support for assistance with F5 ADS for Google Cloud
  {{</card>}}
{{</card-section>}}

## Capabilities

The key capabilities of F5 ADS for Google Cloud are:

- Simplifies onboarding and use of NGINX by providing a fully managed, ready-to-use service, eliminating the need for infrastructure setup or manual upgrades.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the Google Cloud ecosystem.
- Uses consumption-based pricing, so your infrastructure costs align with actual usage through Google Cloud transaction billing.

## F5 ADS for Google Cloud architecture

{{< img src="f5ads/google/nginxaas-google-cloud-architecture.svg" alt="Architecture diagram showing how F5 ADS integrates with Google Cloud. At the top, inside the Google Cloud IaaS layer, NGINX Plus is managed using UI, API, and Terraform, alongside F5 ADS. Admins connect to this layer. Below, in the Customer VPC, end users connect through Edge Routing to multiple App Servers (labeled App Server 1). NGINX Plus directs traffic to these app servers. The Customer VPC also connects with Google Cloud services such as Secret Manager, Monitoring, and other services. Green arrows show traffic flow from end users through edge routing and NGINX Plus to app servers, while blue arrows show admin access." >}}

- Use the F5 ADS Console to create, update, and delete NGINX configurations, certificates, and F5 ADS deployments.
- F5 ADS automatically adapts to application traffic demands through autoscaling.
- Each F5 ADS deployment has dedicated network and compute resources, so there's no risk of noisy neighbor problems or data leakage between deployments.
- F5 ADS can route traffic to upstream servers in different geographies. See [Known issues]({{< ref "/f5ads/google/known-issues.md" >}}) for networking restrictions.
- F5 ADS supports [request tracing](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus).
- F5 ADS supports HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects. You can also create custom rules for redirecting traffic. See [How to Create NGINX Rewrite Rules | NGINX](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details.

### Service frontend

The service frontend of an F5 ADS deployment controls how client ingress traffic reaches your deployment. There are two frontend types: managed public endpoint and private endpoint.

#### Managed public endpoint

A managed public endpoint frontend gives clients access over the internet through a public DNS name that F5 ADS creates in its network.

**This frontend type is suitable for:**

- Serving public web applications to end users over the internet
- Proxying traffic from clients outside Google Cloud
- Testing F5 ADS configurations before you set up a [private endpoint](#private-endpoint) frontend

Access control for this frontend type uses ACL rules to control traffic to the deployment. If you don't provide ACL rules, F5 ADS blocks all traffic. Each ACL rule includes the following settings:

- **Source prefixes**: A list of CIDR blocks to allow traffic from
    - Use `0.0.0.0/0` to allow traffic from all source IP addresses
- **Protocol**: The network protocol to allow
    - Valid values are **TCP** and **UDP**
    - Required when you specify a port range
- **Port range**: A single port or port range to allow traffic from
    - If you don't specify a port range, F5 ADS accepts traffic on any port
    - Required when you specify a protocol

#### Private endpoint

A private endpoint frontend gives clients access through your network using Google [Private Service Connect (PSC)](https://cloud.google.com/vpc/docs/private-service-connect). This approach brings the deployment into your client network through an F5 ADS-created service attachment, so application clients can connect directly into your network.

To set up connectivity, create one of the following:

- A [PSC endpoint](https://docs.cloud.google.com/vpc/docs/private-service-connect#endpoints) for internal traffic
- A [PSC backend](https://cloud.google.com/vpc/docs/private-service-connect#backends) for external traffic

For step-by-step instructions, see [Set up connectivity]({{< ref "/f5ads/google/deploy/create-deployment/deploy-console.md#set-up-connectivity-private-endpoint-only" >}}).

**This frontend type is suitable for:**

- Situations where you need greater control over traffic to the F5 ADS deployment
- Environments where all clients exist within your Google Cloud network
- Internal services that shouldn't be exposed to the internet

Access control for this frontend type uses a service attachment accept list, which restricts which Google project IDs can connect to the deployment. If you don't specify any project IDs, F5 ADS accepts traffic from all projects.

### Upstream network

F5 ADS uses Google [Private Service Connect](https://cloud.google.com/vpc/docs/private-service-connect) (PSC) to connect securely to your applications.

A [PSC interface](https://cloud.google.com/vpc/docs/private-service-connect#interfaces) brings the deployment into your application network and supports secure connectivity to your applications. By using your own networking resources, you control traffic flow and can apply your preferred security controls.

To connect the F5 ADS PSC interface to your network, create a [network attachment](https://cloud.google.com/vpc/docs/about-network-attachments). For steps, see [Create a network attachment]({{< ref "/f5ads/google/deploy/create-deployment/deploy-console.md#create-a-network-attachment" >}}).

### NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX deployment based on its underlying compute resources. With this abstraction, you can specify capacity in NCUs without considering hardware differences between regions.
You can reserve a minimum capacity for your deployment. The deployment automatically scales up or down based on traffic demand and makes sure it never drops below the reserved minimum.

### Geographical controllers

F5 ADS for Google Cloud operates globally, and regional controllers handle management requests. A geographical controller (GC) is a control plane that serves users within a defined geographic boundary. It addresses data residency and localization requirements. For example, a US geographical controller serves customers in the United States. F5 ADS currently operates in three geographies: US, EU, and Asia Pacific (APAC).

### Supported regions

{{< include "/f5ads/google/supported-regions.md" >}}

## Current limitations

F5 is committed to enhancing F5 ADS for Google Cloud and welcomes your feedback to help shape its future. If there are features you'd like to see prioritized, submit a [support ticket]({{< ref "/f5ads/google/support.md" >}}) to share your suggestions.

Be aware of the following constraints when using F5 ADS for Google Cloud:

- F5 ADS is supported in a limited number of regions. F5 is continually working to expand support across additional regions. See [Supported regions](#supported-regions).
- User Role-Based Access Control (RBAC) isn't supported yet. F5 plans to add this in a future release to improve access control for multi-user environments.
- F5 ADS deployments on Google Cloud don't support IPv6 traffic.
- F5 ADS deployments on Google Cloud support UDP traffic only when using the **Managed Public Endpoint** frontend service.

## What's next

To get started, check the [F5 ADS for Google Cloud prerequisites]({{< ref "/f5ads/google/deploy/prerequisites.md" >}}).
