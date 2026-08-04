---
title: Glossary
weight: 900
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/glossary/
f5-content-type: reference
f5-product: F5 NGINXaaS
contentVars:
  product: NGINXaaS
---

This document provides definitions for terms and acronyms commonly used in F5 ${product} documentation.

{{<table>}}

| Term                        | Description                                                                          |
| ------------------------    | -------------------------------------------------------------------------------------|
| Geographical Controller (GC)| Geographical Controller (GC) is a control plane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. |
| NGINX Configuration         | NGINXaaS deployments are configured with standard NGINX configuration file syntax - the same syntax you'd use for NGINX running outside NGINXaaS. See the [NGINX configuration reference documentation](https://nginx.org/en/docs/).
| NGINXaaS Deployment         | An instance of the highly available NGINX Plus managed service. A deployment can be created in any supported cloud provider where your organization holds an active NGINXaaS marketplace subscription.
| NGINXaaS Organization       | The account that hosts your NGINXaaS configurations and deployments. An Organization can be linked to marketplace subscriptions for each cloud provider you want to deploy into, and can have unlimited users added for collaboration on your NGINXaaS resources. |
| NGINXaaS User | NGINXaaS Users are granted access to all resources in the NGINXaaS Organization. User authentication is performed securely via Google Cloud, requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Organizations, and can switch between them. |
| Network attachment          | A Google Cloud resource that connects your NGINXaaS for Google Cloud deployment to upstream applications in your VPC network. [More information](https://cloud.google.com/vpc/docs/about-network-attachments).   |
| Service Frontend            | Each NGINXaaS deployment uses one of two service frontend types: **Managed public endpoint**, which makes the deployment available for client access over the public internet, or **Private endpoint**, which enables client access from trusted private network connections. <br>For details, see the docs for each cloud provider:<br>- [AWS]({{< ref "/nginxaas/aws/overview.md#service-frontend" >}})<br>- [Google Cloud]({{< ref "/nginxaas/google/overview.md#service-frontend" >}}) |
| Upstream Network            | The network that hosts your applications and workloads NGINXaaS proxies traffic to. These backend services or origin servers, are typically defined in an NGINX `upstream` block. For instructions on connecting your NGINXaaS deployment to an upstream network, see the docs for each supported cloud provider. |
| VPC Endpoint                | An AWS resource that establishes a PrivateLink connection from your AWS VPC to the NGINXaaS deployment. When you configure an NGINXaaS for AWS deployment's service frontend as **Private endpoint**, you can create an interface VPC endpoint that target's the deployment's VPC endpoint service. For details, see the [AWS PrivateLink documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html). |
| VPC Peering                 | A method for connecting an NGINXaaS deployment's network to an upstream network so traffic to your backend services routes directly over a private network. |
{{</table>}}
