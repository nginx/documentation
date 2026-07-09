---
title: Glossary
weight: 900
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/glossary/
f5-content-type: reference
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

This document provides definitions for terms and acronyms commonly used in F5 NGINXaaS for AWS documentation.

{{<table>}}

| Term                        | Description                                                                          |
| ------------------------    | -------------------------------------------------------------------------------------|
| Authorized Domains          |  The list of email domains allowed to authenticate into the NGINXaaS Account using AWS IAM Identity Center. <br>- This can be used to restrict access to identities within your AWS Organization, or other known, trusted directories. For example, your AWS Organization may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Account to only allow `example.com`, users attempting to log in with the same email associated with an `alternative.net` directory would not be authenticated. |
| Geographical Controller (GC)| Geographical Controller (GC) is a control plane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. See the [Supported Regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}) documentation for the full list of geographies where NGINXaaS for AWS is available. |
| NGINXaas Account            | Represents an AWS procurement with an active Marketplace NGINXaaS subscription, linked to a billing account. To create an account, see the signup documentation in [prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites.md" >}}). |
| NGINXaaS User | NGINXaaS Users are granted access to all resources in the NGINXaaS Account. User authentication is performed securely via AWS IAM Identity Center, requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Accounts, and can switch between them using the steps documented below. |
| VPC                         | A Virtual Private Cloud (VPC) is a virtual version of a physical network, implemented within AWS. It provides networking functionality for your AWS resources. [More information](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html). |
| VPC endpoint service        | An AWS resource, backed by a Network Load Balancer, that connects your NGINXaaS deployment to upstream applications in your VPC over AWS PrivateLink. [More information](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html).   |

{{</table>}}
