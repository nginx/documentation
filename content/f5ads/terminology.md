---
title: Glossary
description: "Definitions for terms and acronyms used throughout F5 Application Delivery Service documentation."
weight: 9000
toc: false
f5-product: F5 Application Delivery Service
f5-content-type: reference
f5-docs: DOCS-000
f5-keywords: "F5 ADS, glossary, terminology, geographical controller, F5 ADS deployment, F5 ADS organization, service frontend, upstream network, network attachment, VPC endpoint, VPC peering, NGINX configuration"
f5-summary: >
  This glossary defines terms and acronyms used across F5 Application Delivery Service documentation.
  Use it to look up concepts such as geographical controllers, service frontends, upstream networks,
  and the cloud-specific networking resources F5 ADS deployments rely on.
  Terms apply to all supported cloud providers unless an entry notes otherwise.
f5-audience: any
---

Definitions for terms and acronyms used across F5 Application Delivery Service documentation.

{{< table >}}

| Term | Description |
|------|-------------|
| Geographical controller (GC) | A control plane that serves users within a defined geographic boundary. It addresses data residency and localization requirements. For example, a US geographical controller serves customers in the United States. |
| Network attachment | A Google Cloud resource that connects your F5 ADS for Google Cloud deployment to upstream applications in your VPC network. See the [Google Cloud network attachments documentation](https://cloud.google.com/vpc/docs/about-network-attachments). |
| NGINX configuration | F5 ADS deployments use standard NGINX configuration file syntax, the same syntax you'd use for NGINX running outside F5 ADS. See the [NGINX configuration reference documentation](https://nginx.org/en/docs/). |
| F5 ADS deployment | An instance of the highly available NGINX Plus managed service. You can create a deployment in any supported cloud provider where your organization holds an active F5 ADS marketplace subscription. |
| F5 ADS organization | The account that hosts your F5 ADS configurations and deployments. You can link an organization to marketplace subscriptions for each cloud provider you want to deploy into, and add unlimited users to collaborate on your F5 ADS resources. |
| F5 ADS user | F5 ADS users have access to all resources in the F5 ADS organization. F5 ADS authenticates users through Microsoft social login, Google social login, or email and password. You can add an individual as a user to multiple F5 ADS organizations, and they can switch between them. |
| Service frontend | Each F5 ADS deployment uses one of two service frontend types: **Managed public endpoint**, which makes the deployment available for client access over the public internet, or **Private endpoint**, which accepts client connections from trusted private networks.<br>For details, see the docs for each cloud provider:<br>- [AWS]({{< ref "/f5ads/aws/overview.md#service-frontend" >}})<br>- [Google Cloud]({{< ref "/f5ads/google/overview.md#service-frontend" >}}) |
| Upstream network | The network that hosts the applications and workloads F5 ADS proxies traffic to. You typically define these backend services, or origin servers, in an NGINX `upstream` block. For instructions on connecting your deployment to an upstream network, see the docs for each supported cloud provider. |
| VPC endpoint | An AWS resource that establishes a PrivateLink connection from your AWS VPC to the F5 ADS deployment. When you configure the service frontend as **Private endpoint**, you can create an interface VPC endpoint that targets the VPC endpoint service for that deployment. For details, see the [AWS PrivateLink documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html). |
| VPC peering | A method for connecting the network for an F5 ADS deployment to an upstream network, so traffic to your backend services routes directly over a private network. |

{{< /table >}}
