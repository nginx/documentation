---
title: Glossary
description: "Definitions for terms and acronyms used throughout F5 Application Delivery Service documentation."
weight: 9000
toc: false
f5-product: F5 Application Delivery Service
f5-content-type: reference
f5-docs: DOCS-000
f5-keywords: "F5 ADS, glossary, terminology, F5 ADS Console, geographical controller, geography, NGINX Capacity Unit, NCU, F5 ADS deployment, F5 ADS organization, service frontend, managed public endpoint, private endpoint, upstream network, network attachment, VPC endpoint, VPC peering, NGINX configuration"
f5-summary: >
  This glossary defines terms and acronyms used across F5 Application Delivery Service documentation.
  Use it to look up concepts such as the F5 ADS Console, geographical controllers, service frontends,
  upstream networks, NGINX Capacity Units, and the cloud-specific networking resources F5 ADS deployments rely on.
  Terms apply to all supported cloud providers unless an entry notes otherwise.
f5-audience: any
---

Definitions for terms and acronyms used across F5 Application Delivery Service documentation.

{{< table >}}

| Term | Description |
|------|-------------|
| F5 ADS Console | The web interface for managing F5 ADS organizations, NGINX configurations, SSL/TLS certificates, and deployments. Log in at [console.nginxaas.net](https://console.nginxaas.net/), then select the geography you want to work in. |
| F5 ADS deployment | An instance of the highly available NGINX Plus managed service. You can create a deployment in any supported cloud provider where your organization holds an active F5 ADS marketplace subscription. |
| F5 ADS organization | The account that hosts your F5 ADS configurations and deployments. You can link an organization to a marketplace subscription for each cloud provider you deploy into. You can also add unlimited users to collaborate on your F5 ADS resources. |
| F5 ADS user | An individual with access to all resources in an F5 ADS organization. F5 ADS authenticates users through Microsoft social login, Google social login, or email and password. You can add an individual to multiple organizations, and they can switch between them. |
| Geographical controller (GC) | A control plane that serves users within a defined geographic boundary. It addresses data residency and localization requirements. For example, a US geographical controller serves customers in the United States. |
| Geography | A group of cloud provider regions served by a single geographical controller: US, EU, APAC, or CA. You select a geography when you log in to the F5 ADS Console. For the regions in each geography, see the supported regions documentation for your cloud provider. |
| Managed public endpoint | A service frontend type that makes a deployment available over the public internet. See **Service frontend**. |
| Network attachment | A Google Cloud resource that connects your F5 ADS for Google Cloud deployment to upstream applications in your VPC network. See the [Google Cloud network attachments documentation](https://cloud.google.com/vpc/docs/about-network-attachments). |
| NGINX Capacity Unit (NCU) | A unit that quantifies deployment capacity based on underlying compute resources. You can specify capacity in NCUs without accounting for hardware differences between regions. You can reserve a minimum capacity, and the deployment scales with traffic demand without dropping below it.<br>For details, see the docs for each cloud provider:<br>- [AWS]({{< ref "/f5ads/aws/overview.md#nginx-capacity-unit-ncu" >}})<br>- [Google Cloud]({{< ref "/f5ads/google/overview.md#nginx-capacity-unit-ncu" >}}) |
| NGINX configuration | The configuration file that controls how a deployment handles traffic. F5 ADS uses standard NGINX configuration syntax, the same syntax you'd use for NGINX running outside F5 ADS. See the [NGINX configuration reference documentation](https://nginx.org/en/docs/). |
| Private endpoint | A service frontend type that accepts client connections from trusted private networks. See **Service frontend**. |
| Service frontend | The way clients reach an F5 ADS deployment. Each deployment uses one of two types: **Managed public endpoint**, reachable over the public internet, or **Private endpoint**, reachable only from trusted private networks.<br>For details, see the docs for each cloud provider:<br>- [AWS]({{< ref "/f5ads/aws/overview.md#service-frontend" >}})<br>- [Google Cloud]({{< ref "/f5ads/google/overview.md#service-frontend" >}}) |
| Upstream network | The network that hosts the applications and workloads F5 ADS proxies traffic to. You typically define these backend services, or origin servers, in an NGINX `upstream` block.<br>For instructions on connecting a deployment to an upstream network, see the docs for each cloud provider:<br>- [AWS]({{< ref "/f5ads/aws/overview.md#upstream-network" >}})<br>- [Google Cloud]({{< ref "/f5ads/google/overview.md#upstream-network" >}}) |
| VPC endpoint | An AWS resource that establishes a PrivateLink connection from your AWS VPC to an F5 ADS deployment. Create one when the service frontend is **Private endpoint**, targeting the VPC endpoint service for that deployment. For details, see the [AWS PrivateLink documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html). |
| VPC peering | A way to connect an F5 ADS deployment to an upstream network privately, so traffic to your backend services avoids the public internet. |

{{< /table >}}
