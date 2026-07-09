---
title: "Changelog"
weight: 1000
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/changelog/
f5-content-type: reference
f5-product: NGINXaaS for AWS
nollms: true
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

Learn about the latest updates, new features, and resolved bugs in F5 NGINXaaS for AWS.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas/aws/known-issues.md" >}}) page.

## June 1, 2026

- {{% icon-feature %}} **NGINXaaS for AWS now supports free trials**

You can now sign up for a free trial of NGINXaaS for AWS through the [AWS Marketplace](https://aws.amazon.com/marketplace/). The free trial provides up to USD 100 in credits for a maximum of 30 days, whichever comes first, to help you explore NGINXaaS for AWS and its features.

See the [Free trial]({{< ref "/nginxaas/aws/billing/overview.md#free-trial" >}}) documentation for more information.

## May 15, 2026

- {{% icon-feature %}} **NGINXaaS for AWS now supports F5 WAF for NGINX (Preview)**

You can now deploy NGINXaaS with [F5 WAF for NGINX]({{< ref "/waf" >}}); an advanced high-performance web application firewall (WAF) to provide protection from OWASP Top 10 web application security risks.

**Note:** This feature is currently in Preview and free to use during the preview period. Custom security policies and custom logging profiles are not yet supported.

## April 16, 2026

- {{% icon-feature %}} **NGINXaaS for AWS now supports Managed Public Endpoint deployments (Preview)**

You can now deploy NGINXaaS with an internet-facing managed public endpoint. Unlike private endpoint deployments, which require AWS PrivateLink in your AWS account, managed public endpoints provide a publicly resolvable, unique DNS name you can use to route traffic directly to your deployment over the internet.

**Note:** This feature is currently in preview; pricing may change.

See the [Service Frontend]({{< ref "/nginxaas/aws/overview.md#service-frontend" >}}) documentation for more information about managed public endpoint.

## February 11, 2026

- {{% icon-feature %}} **NGINXaaS for AWS is now generally available in more regions**

  NGINXaaS for AWS is now available in the following additional regions per geography:

   {{< table "table" >}}
   |NGINXaaS Geography | AWS Regions |
   |-----------|---------|
   | APAC  | ap-south-1, ap-southeast-2 |
   {{< /table >}}

See the [Supported Regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for AWS is available.

## February 10, 2026

- {{% icon-feature %}} **NGINXaaS for AWS supports fetching SSL/TLS certificates from Secrets Manager**

Customers can now reference SSL/TLS certificates and keys from [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html). NGINXaaS will securely fetch them for use in deployments, ensuring your secrets remain within AWS.

For instructions on getting started, see our documentation to [add certificates from Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}}).

## February 4, 2026

- {{% icon-feature %}} **NGINXaaS for AWS is now generally available in Asia Pacific (APAC)**

  NGINXaaS for AWS is now available in the following regions in APAC:

   {{< table "table" >}}

   | NGINXaaS Geography | AWS Regions |
   |-----------|---------|
   | APAC  | ap-southeast-1 |

   {{< /table >}}

See the [Supported Regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for AWS is available.

## January 15, 2026

- {{% icon-feature %}} **Required configuration no longer needed for deployments**

The previously required configuration is no longer necessary for your deployments.

## December 29, 2025

- {{% icon-feature %}} **NGINXaaS for AWS is now generally available in more regions**

  NGINXaaS for AWS is now available in the following additional regions per geography:

   {{< table "table" >}}

   | NGINXaaS Geography | AWS Regions |
   |-----------|---------|

   | EU  | eu-west-3, eu-central-1 |

   {{< /table >}}

See the [Supported Regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for AWS is available.

## December 15, 2025

- {{% icon-feature %}} **NGINXaaS for AWS is now generally available in more regions**

  NGINXaaS for AWS is now available in the following additional regions per geography:

   {{< table "table" >}}

   | NGINXaaS Geography | AWS Regions |
   |-----------|---------|
   | EU  | eu-west-2, eu-north-1 |

   {{< /table >}}

See the [Supported Regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for AWS is available.

## December 10, 2025

- {{% icon-feature %}} **NGINXaaS for AWS is now generally available in more regions**

  NGINXaaS for AWS is now available in the following additional regions per geography:

   {{< table "table" >}}

   | NGINXaaS Geography | AWS Regions |
   |-----------|---------|
   | US  | us-east-2, us-west-1, us-west-2 |

   {{< /table >}}

See the [Supported Regions]({{< ref "/nginxaas/aws/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for AWS is available.

## October 13, 2025

- {{% icon-feature %}} **NGINXaaS for AWS is generally available**

We are pleased to announce the general availability of F5 NGINXaaS for AWS.

F5 NGINXaaS for AWS is a fully managed load balancer and application delivery service that streamlines cloud-native application delivery without the operational complexity of managing infrastructure. This service simplifies the deployment of APIs, microservices, and web applications while enhancing performance, visibility, security, and scalability in AWS.

Key features include adaptive load balancing, advanced connectivity patterns for deployment strategies like blue-green and canary, detailed visibility with over 200 real-time metrics, and strong security controls such as role-based access control and end-to-end encryption. The service also consolidates technology with unified L4/L7 load balancing combined with advanced security and programmability into a single platform for enhanced operational efficiency.

This announcement marks a significant step in application delivery modernization, empowering organizations to improve user experiences and achieve seamless integration with Amazon CloudWatch.

To learn more, refer to the following resources:

- **Product Information:**

    - [F5 NGINXaaS for AWS](https://www.f5.com/products/nginx/f5-nginxaas-for-aws)
    - [Overview and architecture]({{< ref "/nginxaas/aws/overview.md" >}})
    - [Getting Started]({{< ref "/nginxaas/aws/deploy/prerequisites/" >}})

- **Blogs:** [F5 NGINXaaS for AWS: Delivering resilient, scalable applications](https://f5.com/company/blog/delivering-resilient-scalable-applications.html)
- **Webinars:** [Why F5 NGINXaaS for AWS is a game changer](https://events.actualtechmedia.com/on-demand/1603/why-f5-nginxaas-for-aws-is-a-game-changer/)

[Visit the AWS Marketplace](https://aws.amazon.com/marketplace/) and start leveraging NGINXaaS for AWS today!

## September 18, 2025

- {{% icon-feature %}} **NGINXaaS for AWS Early Access**

   NGINXaaS for AWS is now available in Early Access. This offering provides a fully managed, scalable, and secure solution for deploying and managing NGINX instances on AWS.

   - To learn more about NGINXaaS for AWS, see the [Overview and architecture]({{< ref "/nginxaas/aws/overview.md" >}}) topic.
   - To deploy NGINXaaS, see the [Getting Started]({{< ref "/nginxaas/aws/deploy/prerequisites/" >}}) guide.
