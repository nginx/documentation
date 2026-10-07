---
title: Billing overview
description: "How F5 Application Delivery Service for AWS is priced and billed through AWS Marketplace."
weight: 100
toc: true
f5-docs: DOCS-000
f5-content-type: concept
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, billing, pricing, NCU, AWS Marketplace"
f5-summary: >
  F5 Application Delivery Service for AWS bills hourly through your AWS subscription.
  This page covers pricing tiers, NGINX Capacity Units, and billing examples.
f5-audience: any
---

F5 Application Delivery Service for AWS is available through the AWS Marketplace. You subscribe to the service through your AWS account, and your subscription is visible in the AWS Marketplace. F5 hosts all deployments and underlying resources in an F5-managed infrastructure, you manage and monitor your deployments through the F5 ADS Console. F5 fully manages the underlying infrastructure, software maintenance, availability, and scaling. Billing runs hourly, and you can track it in the AWS Cost Management Console.

## Pricing plans

F5 ADS for AWS is available on an Enterprise plan, backed by a 99.95% uptime service-level agreement (SLA). Pricing is based on three billing meters: Fixed, NCU and Data transferred each priced according to the regional tier of your deployment.

### Pricing by regional tier

{{< table >}}

| Tier   | Fixed price/hour | NCU price/hour | Data transfer/DTU | AWS regions                                                         |
|--------|------------------|----------------|-------------------|---------------------------------------------------------------------|
| Tier 1 | $0.020           | $0.010         | $0.00001          | us-east-1, us-east-2, us-west-2, ap-south-1, ap-south-2            |
| Tier 2 | $0.023           | $0.012         | $0.00001          | us-west-1, eu-central-1, eu-north-1, eu-west-1, eu-west-2, eu-west-3, ca-central-1, ca-west-1 |
| Tier 3 | $0.026           | $0.013         | $0.00001          | ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-4     |

{{< /table >}}

## NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity for a deployment. F5 ADS meters resources hourly based on the capacity you use, so you can scale up or down dynamically. A single NCU consists of:

   - Bandwidth: 2.2 Mbps
   - Connections: 3,000

## Data Transfer Unit (DTU)

A Data Transfer Unit (DTU) is the unit used to measure data transfer for billing purposes.

## Billing examples

**Example 1: Steady deployment**

A deployment in a Tier 1 region uses 20 NCUs and processes 100,000 DTUs of data for 1 hour:

- Fixed price: $0.020/hour
- NCU usage: 20 NCUs * $0.010/hour = $0.200/hour
- Data transfer: 100,000 DTUs * $0.00001/DTU = $1.00

Total cost for 1 hour: $0.020 + $0.200 + $1.00 = **$1.22**

**Example 2: Scaling deployment**

A deployment in a Tier 1 region uses 30 NCUs for 2 hours, then scales to 50 NCUs for 1 more hour, processing 200,000 DTUs of data:

- Fixed price: $0.020/hour * 3 hours = $0.060
- NCU usage: (30 NCUs * $0.010/hour * 2 hours) + (50 NCUs * $0.010/hour * 1 hour) = $1.10
- Data transfer: 200,000 DTUs * $0.00001/DTU = $2.00

Total cost for 3 hours: $0.060 + $1.10 + $2.00 = **$3.16**

## Review billing data

F5 ADS for AWS reports billing data per deployment. You can access it through the AWS Cost Management Console. Usage metrics and costs update hourly, so you can monitor and optimize resource allocation.

## Cancel your subscription

{{< call-out class="warning" title="Potential for data loss" >}}
Canceling your subscription immediately suspends your deployments. If you re-subscribe later, you need to recreate every deployment from scratch.
{{< /call-out >}}

To cancel your subscription, go to the [AWS Marketplace Subscriptions](https://console.aws.amazon.com/marketplace/subscriptions) page. When you cancel:

- All active deployments immediately move to a suspended state. Suspended deployments stop processing traffic.
- You can still view and delete deployments in the F5 ADS Console, but you can't update existing ones or create new ones.
- You can still view, edit, create, and delete configurations and SSL certificates in the console.

