---
title: Overview and architecture
description: "Overview of F5 Application Delivery Service for AWS architecture, capabilities, and how it integrates with your AWS environment."
weight: 100
toc: true
f5-docs: DOCS-000
url: /f5ads/aws/overview/
f5-content-type: concept
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, architecture, service frontend, private endpoint, managed public endpoint, upstream network, NGINX Capacity Unit, NCU, geographical controller"
f5-summary: >
  NGINX Plus powers F5 Application Delivery Service for AWS, a fully managed, AWS-native SaaS load balancer and application delivery service.
  This overview covers its architecture, service frontend types, upstream connectivity, and capacity model, so you understand how it fits into your AWS environment before you deploy.
f5-audience: any
---

## What is F5 Application Delivery Service for AWS?

F5 Application Delivery Service for AWS (F5 ADS for AWS) is a SaaS offering tightly integrated with AWS and its ecosystem of services. It helps make your applications fast, efficient, and reliable, using advanced traffic management from [NGINX Plus](https://www.nginx.com/products/nginx/) without the operational overhead.

NGINX Plus extends NGINX Open Source with advanced functionality, giving you a complete application delivery solution. F5 ADS handles NGINX Plus license management automatically.

{{<card-section showAsCards="true" isFeaturedSection="false">}}
  {{<card title="Prerequisites" titleUrl="/f5ads/aws/deploy/prerequisites/" icon="power">}}
    Follow these steps to prepare for your F5 ADS deployment
  {{</card>}}
  {{<card title="Create a deployment" titleUrl="/f5ads/aws/deploy/create-deployment/deploy-console/" icon="cloud-upload">}}
    Step-by-step instructions to deploy F5 ADS using the F5 ADS Console
  {{</card>}}
  {{<card title="Add certificates" titleUrl="/f5ads/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console/" icon="lock">}}
    Instructions to add SSL/TLS certificates to your F5 ADS deployment using the F5 ADS Console
  {{</card>}}
  {{<card title="Get help" titleUrl="/f5ads/support/" icon="message-circle-question-mark">}}
    Contact F5 support for assistance with F5 ADS for AWS
  {{</card>}}
{{</card-section>}}

## Capabilities

The key capabilities of F5 ADS for AWS are:

- Simplifies onboarding and use of NGINX by providing a fully managed, ready-to-use service, eliminating the need for infrastructure setup or manual upgrades.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the AWS ecosystem.
- Uses consumption-based pricing, so your infrastructure costs align with actual usage through AWS transaction billing.

## F5 ADS for AWS architecture

{{< img src="f5ads/aws/nginxaas-aws-cloud-architecture.svg" alt="Architecture diagram showing how F5 ADS integrates with AWS. At the top, inside the AWS IaaS layer, NGINX Plus is managed using UI, API, and Terraform, alongside F5 ADS. Admins connect to this layer. Below, in the Customer VPC, end users connect through Edge Routing to multiple App Servers (labeled App Server 1). NGINX Plus directs traffic to these app servers. The Customer VPC also connects with AWS services such as AWS Secrets Manager, Amazon CloudWatch, and other AWS services. Green arrows show traffic flow from end users through edge routing and NGINX Plus to app servers, while blue arrows show admin access." >}}

- Use the F5 ADS Console to create, update, and delete NGINX configurations, certificates, and F5 ADS deployments.
- F5 ADS automatically adapts to application traffic demands through autoscaling.
- Each F5 ADS deployment has dedicated network and compute resources, so there's no risk of noisy neighbor problems or data leakage between deployments.
- F5 ADS acts as a load balancer, API gateway, and reverse proxy. It keeps your application workloads secure within your AWS account and serves traffic reliably and efficiently.
- F5 ADS for AWS supports the following capabilities:
    - HTTP, HTTP/2, HTTP/3, and gRPC traffic
    - Layer 4 and Layer 7 load balancing with [configurable balancing methods](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/#method)
    - IPv4 and IPv6 traffic
    - UDP, TCP, and QUIC protocols
    - Private or public internet client ingress
    - [Request tracing](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus)
    - HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects
- You can also create custom rules for redirecting traffic. See [How to Create NGINX Rewrite Rules | NGINX](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details.

### Service frontend

The service frontend of an F5 ADS deployment controls how client ingress traffic reaches your deployment. There are two frontend types: managed public endpoint and private endpoint.

#### Managed public endpoint

A managed public endpoint frontend gives clients access over the internet through a public DNS name that F5 ADS creates in its network.

**This frontend type is suitable for:**

- Serving public web applications to end users over the internet
- Proxying traffic from clients outside AWS
- Testing F5 ADS configurations before you set up a [private endpoint](#private-endpoint) frontend

Access control for this frontend type uses ACL rules to control traffic to the deployment. If you don't provide ACL rules, F5 ADS blocks all traffic. Each ACL rule includes the following settings:

- **Source prefixes**: A list of CIDR blocks to allow traffic from
    - Use `0.0.0.0/0`, `::0/0` to allow traffic from all source IP addresses
- **Protocol**: The network protocol to allow
    - Valid values are **TCP** and **UDP**
    - Required when you specify a port or port range
- **Port range**: A single port or port range to allow traffic from
    - If you don't specify a port range, F5 ADS accepts traffic on any port
    - Required when you specify a protocol

#### Private endpoint

A private endpoint frontend gives clients access through your network using [AWS PrivateLink](https://aws.amazon.com/privatelink/). With this approach, any application or client in your VPC can connect directly to your F5 ADS deployment through private networking.

To set up connectivity:

1. Create an [interface VPC endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html) in your own VPC.
2. Connect the interface VPC endpoint to the VPC endpoint service provisioned for your F5 ADS deployment.

For step-by-step instructions, see [Set up connectivity]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-console.md#set-up-connectivity" >}}).

**This frontend type is suitable for:**

- Situations where you need greater control over traffic to the F5 ADS deployment
- Environments where all clients exist within your AWS network
- Internal services that shouldn't be exposed to the internet

Access control for this frontend type uses a PrivateLink connection allow list, which restricts which AWS account IDs or VPC endpoint IDs can connect to the deployment:

- **Allow list entries**: AWS account IDs or VPC endpoint IDs that can connect to the deployment
- **No entries**: F5 ADS doesn't accept any PrivateLink connections
- **Modifying the list**: You can add or remove entries at any time

### Upstream network

F5 ADS uses [AWS VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) to connect privately to your upstream applications.

A VPC peering connection brings the deployment into your application network and supports secure, private connectivity to your upstream services. By managing your own VPC routing and security group rules, you control traffic flow and can apply your preferred security controls.

To connect F5 ADS to your upstream VPC, [create a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html) from your AWS account targeting the F5 ADS deployment's AWS Account ID and VPC ID. Then add the peering connection ID to your deployment.

{{< call-out class="caution" title="CIDR overlap" >}}
Upstream VPC CIDRs must not overlap with the F5 ADS deployment VPC CIDRs, or the CIDRs of other peered upstream VPCs. If CIDRs overlap, VPC peering fails.
{{< /call-out >}}

### NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX deployment based on its underlying compute resources. With this abstraction, you can specify capacity in NCUs without considering hardware differences between regions.
You can reserve a minimum capacity for your deployment. The deployment automatically scales up or down based on traffic demand and makes sure it never drops below the reserved minimum.

### Geographical controllers

F5 ADS for AWS operates globally, and regional controllers handle management requests. A geographical controller (GC) is a control plane that serves users within a defined geographic boundary. It addresses data residency and localization requirements. For example, a US geographical controller serves customers in the United States. F5 ADS currently operates in three geographies: US, EU, and Asia Pacific (APAC).

### Supported regions

{{< include "/f5ads/aws/supported-regions.md" >}}

## Current limitations

F5 is committed to enhancing F5 ADS for AWS and welcomes your feedback to help shape its future. If there are features you'd like to see prioritized, submit a [support ticket]({{< ref "/f5ads/aws/support.md" >}}) to share your suggestions.

Be aware of the following constraints when using F5 ADS for AWS:

- User Role-Based Access Control (RBAC) isn't supported yet. F5 plans to add this in a future release to improve access control for multi-user environments.
- PrivateLink and upstream VPC peering connections must remain within the same AWS region as your deployment. Cross-region connections aren't supported yet.
- F5 ADS deployments support up to 50 unique listen ports.
- F5 ADS deployments can support UDP and QUIC traffic, but the deployment must listen for that traffic on IPv6. This doesn't require your incoming client or upstream traffic to be IPv6.

## What's next

To get started, check the [F5 ADS for AWS prerequisites]({{< ref "/f5ads/aws/deploy/prerequisites.md" >}}).