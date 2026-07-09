---
title: Overview and architecture
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/overview/
f5-content-type: concept
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

## What is NGINXaaS for AWS?

F5 NGINXaaS for AWS is a SaaS offering that is tightly integrated
into AWS and its ecosystem of services, making applications fast, efficient,
and reliable bringing advanced traffic services enabled with the commercial version of NGINX, without any of the operational toil.

[NGINX Plus](https://www.nginx.com/products/nginx/) powers NGINXaaS for AWS, which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution.

NGINXaaS handles the NGINX Plus license management automatically.

{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Prerequisites" titleUrl="/nginxaas/aws/deploy/prerequisites/" icon="power">}}
    Follow these steps to prepare for your NGINXaaS deployment
  {{</card>}}
  {{<card title="Create a deployment" titleUrl="/nginxaas/aws/deploy/create-deployment/deploy-console/" icon="cloud-upload">}}
    Step-by-step instructions to deploy NGINXaaS using the NGINXaaS Console
  {{</card>}}
  {{<card title="Add certificates" titleUrl="/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console/" icon="lock">}}
    Instructions to add SSL/TLS certificates to your NGINXaaS deployment using the NGINXaaS Console
  {{</card>}}
{{</card-section>}}

## Capabilities

The key capabilities of NGINXaaS for AWS are:

- Simplifies onboarding by providing a fully managed, ready-to-use NGINX service, eliminating the need for infrastructure setup, manual upgrades, or operational overhead.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the AWS ecosystem.
- Adopts a consumption-based pricing to align infrastructure costs to actual usage by billing transactions using AWS.

## NGINXaaS for AWS architecture

NGINXaaS for AWS runs in dedicated infrastructure managed by F5, with connectivity into your Amazon VPC established through [AWS PrivateLink](https://aws.amazon.com/privatelink/). Admins manage the deployment using the NGINXaaS Console, API, or Terraform. Inside your VPC, NGINXaaS reaches your application servers through an interface VPC endpoint, and integrates with Amazon CloudWatch, AWS Secrets Manager, and other AWS services using an IAM role assumed via OIDC federation. Client traffic flows in either through a managed public endpoint or through a customer-owned Network Load Balancer, depending on the [Service Frontend](#service-frontend) you choose.

- The NGINXaaS Console is used to create, update, and delete NGINX configurations, certificates and NGINXaaS deployments
- NGINXaaS automatically adapts to application traffic demands through autoscaling
- Each NGINXaaS deployment has dedicated network and compute resources. There is no possibility of noisy neighbor problems or data leakage between deployments
- NGINXaaS can route traffic to upstreams even if the upstream servers are located in different geographies. See [Known Issues]({{< ref "/nginxaas/aws/known-issues.md" >}}) for any networking restrictions.
- NGINXaaS supports request tracing. See the [Application Performance Management with NGINX Variables](https://www.f5.com/company/blog/nginx/application-tracing-nginx-plus) blog to learn more about tracing.
- Supports HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP redirects. NGINXaaS also provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules | NGINX](https://blog.nginx.org/blog/creating-nginx-rewrite-rules) for more details.

### Service Frontend

The service frontend of an NGINXaaS deployment controls how client ingress traffic reaches your deployment. There are two frontend types: managed public endpoint and private endpoint.

#### Managed Public Endpoint

A managed public endpoint frontend allows client access over the internet through a public DNS name created by NGINXaaS in its network.

**This frontend type is suitable for:**

- Serving public web applications to end users over the internet
- Proxying traffic from clients outside AWS
- Testing NGINXaaS configurations before you set up a [Private Endpoint]({{< ref "/nginxaas/aws/overview.md#private-endpoint" >}}) frontend

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

A private endpoint frontend allows client access through your network by using [AWS PrivateLink](https://aws.amazon.com/privatelink/). To set up connectivity, create either an [interface VPC endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html) for internal traffic or a [Network Load Balancer fronting that endpoint](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/target-group-register-targets.html) for external traffic. This approach brings the NGINXaaS deployment into your client network through an NGINXaaS-owned VPC endpoint service, so application clients can connect directly into your network. For step-by-step instructions, see [Set up connectivity]({{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md#set-up-connectivity-private-endpoint-only" >}}).

**This frontend type is suitable for:**

- Situations where you need greater control over traffic to the NGINXaaS deployment
- Environments where all clients exist within your AWS network
- Internal services that shouldn't be exposed to the internet

**Access control**

A VPC endpoint service allow list restricts which AWS account IDs can connect to the deployment. If you don’t specify any account IDs in the allow list, traffic from all accounts is allowed (or, if you disable [acceptance required](https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html), any principal that requests a connection is auto-accepted).

### Upstream network

NGINXaaS uses [AWS PrivateLink](https://aws.amazon.com/privatelink/) to connect securely to your applications.

To bring the deployment into your application network, you create a [VPC endpoint service](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html) backed by a Network Load Balancer that targets your upstream application servers, and share it with the NGINXaaS AWS account. NGINXaaS then connects to your applications through an interface VPC endpoint in its own VPC. By using your own Network Load Balancer and target group, you control traffic flow and can apply your preferred security controls.

To connect NGINXaaS to your upstream VPC endpoint service, you must share the service with the NGINXaaS AWS account and provide its service name when creating your deployment. For steps, see {{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md#create-a-vpc-endpoint-service" >}}.

#### Connection draining

During scaling, some connections older than 60 seconds might be reset. The service automatically handles reconnects, so you don't need to wait before reconnecting.

### NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX deployment based on its underlying compute resources. This abstraction lets you specify capacity in NCUs without considering hardware differences between regions.
You can reserve a minimum capacity for your deployment. The deployment automatically scales up or down based on traffic demand and makes sure it never drops below the reserved minimum.

### Geographical Controllers

NGINXaaS for AWS has a global presence, with management requests served by regional controllers. A geographical controller (GC) is a control plane that serves users within a defined geographic boundary while addressing data residency and localization requirements. For example, a US geographical controller serves customers in the United States. NGINXaaS currently operates in three geographies: US, EU, and Asia Pacific (APAC).

### Supported regions

{{< include "/nginxaas/aws/supported-regions.md" >}}

## Current Limitations

We are committed to enhancing NGINXaaS for AWS and welcome your feedback to help shape the future of our service. If there are features you'd like to see prioritized, we encourage you to submit a [support ticket]({{< ref "/nginxaas/aws/support.md" >}}) to share your suggestions.

Here are the current constraints you should be aware of when while using NGINXaaS for AWS:

- NGINXaaS is [supported in a limited number of regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}). We are continually working to expand support across additional regions.
- We only support authentication via AWS IAM Identity Center acting as an identity provider.
- User Role-Based Access Control (RBAC) is not yet supported, but this enhancement is on our roadmap as we improve access control for multi-user environments.

## What's next

To get started, check the [NGINXaaS for AWS prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites.md" >}})
