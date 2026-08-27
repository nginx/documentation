---
title: Glossary
weight: 900
toc: true
f5-docs: DOCS-000
url: /application-delivery-service/overview/glossary/
f5-content-type: reference
f5-product: F5 Application Delivery Service
contentVars:
  product: F5 Application Delivery Service
---

This document provides definitions for terms and acronyms commonly used in F5 ${product} documentation.

{{<table>}}

| Term                        | Description                                                                          |
| ------------------------    | -------------------------------------------------------------------------------------|
| Geographical Controller (GC)| Geographical Controller (GC) is a control plane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. |
| Network attachment          | A Google Cloud resource that connects your F5 Application Delivery Service for Google Cloud deployment to upstream applications in your VPC network. [More information](https://cloud.google.com/vpc/docs/about-network-attachments).   |
| NGINX Configuration         | F5 Application Delivery Service deployments are configured with standard NGINX configuration file syntax - the same syntax you'd use for NGINX running outside F5 Application Delivery Service. See the [NGINX configuration reference documentation](https://nginx.org/en/docs/).
| F5 Application Delivery Service Deployment         | An instance of the highly available NGINX Plus managed service. A deployment can be created in any supported cloud provider where your organization holds an active F5 Application Delivery Service marketplace subscription.
| F5 Application Delivery Service Organization       | The account that hosts your F5 Application Delivery Service configurations and deployments. An Organization can be linked to marketplace subscriptions for each cloud provider you want to deploy into, and can have unlimited users added for collaboration on your F5 Application Delivery Service resources. |
| F5 Application Delivery Service User | F5 Application Delivery Service Users are granted access to all resources in the F5 Application Delivery Service Organization. User authentication is performed securely via Google Cloud, requiring a matching identity. Individuals can be added as users to multiple F5 Application Delivery Service Organizations, and can switch between them. |
| Service Frontend            | Each F5 Application Delivery Service deployment uses one of two service frontend types: **Managed public endpoint**, which makes the deployment available for client access over the public internet, or **Private endpoint**, which enables client access from trusted private network connections. <br>For details, see the docs for each cloud provider:<br>- [AWS]({{< ref "/ads/aws/overview.md#service-frontend" >}})<br>- [Google Cloud]({{< ref "/ads/google/overview.md#service-frontend" >}}) |
| Upstream Network            | The network that hosts your applications and workloads F5 Application Delivery Service proxies traffic to. These backend services or origin servers, are typically defined in an NGINX `upstream` block. For instructions on connecting your F5 Application Delivery Service deployment to an upstream network, see the docs for each supported cloud provider. |
| VPC Endpoint                | An AWS resource that establishes a PrivateLink connection from your AWS VPC to the F5 Application Delivery Service deployment. When you configure an F5 Application Delivery Service for AWS deployment's service frontend as **Private endpoint**, you can create an interface VPC endpoint that target's the deployment's VPC endpoint service. For details, see the [AWS PrivateLink documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html). |
| VPC Peering                 | A method for connecting an F5 Application Delivery Service deployment's network to an upstream network so traffic to your backend services routes directly over a private network. |
{{</table>}}
