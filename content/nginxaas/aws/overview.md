---
title: Overview and architecture
description: "Overview of F5 Application Delivery Service for AWS architecture, capabilities, and how it integrates with your AWS environment."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/overview/
f5-content-type: concept
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 Application Delivery Service for AWS, architecture, service frontend, private endpoint, managed public endpoint, upstream network, NGINX Capacity Unit, NCU, geographical controller"
f5-summary: >
  F5 Application Delivery Service for AWS is a fully managed, AWS-native SaaS load balancer and application delivery service powered by commercial NGINX Plus.
  This overview covers its architecture, service frontend types, upstream connectivity, and capacity model, so you understand how it fits into your AWS environment before you deploy.
f5-audience: any
---

## What is F5 Application Delivery Service for AWS?

F5 Application Delivery Service for AWS (ADS) is a SaaS offering that is tightly integrated
into AWS and its ecosystem of services, making applications fast, efficient,
and reliable. It brings advanced traffic management capabilities from the commercial version of NGINX, without any of the operational toil.

[NGINX Plus](https://www.nginx.com/products/nginx/) powers F5 ADS, which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution.

F5 ADS handles the NGINX Plus license management automatically.

{{<card-section showAsCards="true" isFeaturedSection="false">}}
  {{<card title="Prerequisites" titleUrl="/nginxaas/aws/deploy/prerequisites/" icon="power">}}
    Follow these steps to prepare for your F5 ADS deployment
  {{</card>}}
  {{<card title="Create a deployment" titleUrl="/nginxaas/aws/deploy/create-deployment/deploy-console/" icon="cloud-upload">}}
    Step-by-step instructions to deploy F5 ADS using the F5 ADS Console
  {{</card>}}
  {{<card title="Add certificates" titleUrl="/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console/" icon="lock">}}
    Instructions to add SSL/TLS certificates to your F5 ADS deployment using the F5 ADS Console
  {{</card>}}
  {{<card title="Get help" titleUrl="/nginxaas/support/" icon="message-circle-question-mark">}}
    Contact F5 support for assistance with F5 ADS
  {{</card>}}
{{</card-section>}}

## Capabilities

The key capabilities of F5 Application Delivery Service for AWS are:

- Simplifies onboarding and use of NGINX by providing a fully managed, ready-to-use service, eliminating the need for infrastructure setup or manual upgrades.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the AWS ecosystem.
- Adopts a consumption-based pricing to align infrastructure costs to actual usage by billing transactions using AWS.

## F5 Application Delivery Service for AWS architecture

{{< img src="nginxaas/aws/nginxaas-aws-cloud-architecture.png" alt="Architecture diagram showing how F5 ADS integrates with AWS. At the top, inside the AWS IaaS layer, NGINX Plus is managed using UI, API, and Terraform, alongside F5 ADS. Admins connect to this layer. Below, in the Customer VPC, end users connect through Edge Routing to multiple App Servers (labeled App Server 1). NGINX Plus directs traffic to these app servers. The Customer VPC also connects with AWS services such as AWS Secrets Manager, Amazon CloudWatch, and other AWS services. Green arrows show traffic flow from end users through edge routing and NGINX Plus to app servers, while blue arrows show admin access." >}}

- The F5 ADS Console is used to create, update, and delete NGINX configurations, certificates and F5 ADS deployments
- F5 ADS automatically adapts to application traffic demands through autoscaling
- Each F5 ADS deployment has dedicated network and compute resources. There is no possibility of noisy neighbor problems or data leakage between deployments
- F5 ADS acts as a load balancer, API gateway, and reverse proxy, enabling you to keep your application workloads secure within your AWS account while serving traffic reliably and efficiently
- F5 ADS supports the following capabilities:
    - HTTP, HTTP/2, HTTP/3, and gRPC traffic
    - Layer 4 and Layer 7 load balancing with [configurable balancing methods](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#method)
    - IPv4 and IPv6 traffic
    - UDP, TCP, and QUIC protocols
    - Private or public internet client ingress
    - [Request tracing](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus)
    - HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects
- F5 ADS also provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules | NGINX](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details

### Service frontend

The service frontend of an F5 ADS deployment controls how client ingress traffic reaches your deployment. There are two frontend types: managed public endpoint and private endpoint.

#### Managed public endpoint

A managed public endpoint frontend allows client access over the internet through a public DNS name created by F5 ADS in its network.

**This frontend type is suitable for:**

- Serving public web applications to end users over the internet
- Proxying traffic from clients outside AWS
- Testing F5 ADS configurations before you set up a [Private endpoint]({{< ref "/nginxaas/aws/overview.md#private-endpoint" >}}) frontend

##### Access control

Access control list (ACL) rules control traffic to a managed public endpoint deployment. If you don’t provide ACL rules, no traffic is allowed. An ACL rule includes the following settings:

- **Source prefixes**: A list of CIDR blocks to allow traffic from
    - Use `0.0.0.0/0`, `::0/0` to allow traffic from all source IP addresses
- **Protocol**: The network protocol to allow
    - Valid values are **TCP** and **UDP**
    - Required when you specify a port or port range
- **Port range**: A single port or port range to allow traffic from
    - If you don’t specify a port range, traffic is allowed from any port
    - Required when you specify a protocol

#### Private endpoint

A private endpoint frontend allows client access through your network by using [AWS PrivateLink](https://aws.amazon.com/privatelink/). To set up connectivity, create an [interface VPC endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html) in your own VPC that connects to the VPC endpoint service provisioned for your F5 ADS deployment. This approach enables any applications or clients in your VPC to connect directly to the F5 ADS deployment via private networking. For step-by-step instructions, see [Set up connectivity]({{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md#set-up-connectivity-private-endpoint-only" >}}).

**This frontend type is suitable for:**

- Situations where you need greater control over traffic to the F5 ADS deployment
- Environments where all clients exist within your AWS network
- Internal services that shouldn't be exposed to the internet

##### Access control

A PrivateLink connection allow list restricts which AWS account IDs or VPC endpoint IDs can connect to the deployment. If you don't specify any entries in the allow list, no PrivateLink connections will be accepted. The allow list can be modified at any time to add or remove access permission for any AWS accounts or VPC endpoints.

### Upstream network

F5 ADS uses [AWS VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) to connect privately to your upstream applications.

A VPC peering connection brings the deployment into your application network and supports secure, private connectivity to your upstream services. By managing your own VPC routing and security group rules, you control traffic flow and can apply your preferred security controls.

To connect F5 ADS to your upstream VPC, you must [create a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html) from your AWS account targeting the F5 ADS deployment's AWS Account ID and VPC ID, then add the peering connection ID to your deployment.

{{< call-out class="caution" title="CIDR overlap" >}}
Upstream VPC CIDRs must not overlap with the F5 ADS deployment
VPC CIDRs, or the CIDRs of other peered upstream VPCs. If CIDRs overlap, VPC peering will fail.
{{< /call-out >}}

### NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX deployment based on its underlying compute resources. This abstraction lets you specify capacity in NCUs without considering hardware differences between regions.
You can reserve a minimum capacity for your deployment. The deployment automatically scales up or down based on traffic demand and makes sure it never drops below the reserved minimum.

### Geographical controllers

F5 ADS has a global presence, with management requests served by regional controllers. A geographical controller (GC) is a control plane that serves users within a defined geographic boundary while addressing data residency and localization requirements. For example, a US geographical controller serves customers in the United States. F5 ADS currently operates in three geographies: US, EU, and Asia Pacific (APAC).

### Supported regions

{{< include "/nginxaas/aws/supported-regions.md" >}}

## Current limitations

We are committed to enhancing F5 ADS and welcome your feedback to help shape the future of our service. If there are features you'd like to see prioritized, we encourage you to submit a [support ticket]({{< ref "/nginxaas/aws/support.md" >}}) to share your suggestions.

Here are the current constraints you should be aware of while using F5 Application Delivery Service for AWS:

- F5 WAF is currently not supported for F5 ADS, but this feature is expected to be available soon - stay tuned.
- User Role-Based Access Control (RBAC) is not yet supported, but this enhancement is on our roadmap as we improve access control for multi-user environments.
- PrivateLink and upstream VPC peering connections must remain within the same AWS region as your deployment. Cross-region connections are not currently supported.
- F5 ADS deployments on AWS can only support up to 50 unique listen ports.
- While F5 ADS deployments on AWS can be configured for UDP and QUIC traffic, it requires that the deployment is listening for that traffic on IPv6. Note: this does not require the incoming client traffic, or upstream traffic to be IPv6.

## What's next

To get started, check the [F5 Application Delivery Service for AWS prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites.md" >}})
