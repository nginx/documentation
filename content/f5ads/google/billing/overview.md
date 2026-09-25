---
title: Billing overview
description: "How F5 Application Delivery Service for Google Cloud is priced and billed through Google Cloud Marketplace."
weight: 100
toc: true
f5-docs: DOCS-000
f5-content-type: concept
f5-product: F5 Application Delivery Service for Google Cloud
f5-keywords: "F5 ADS for Google Cloud, billing, pricing, NCU, Google Cloud Marketplace, free trial"
f5-summary: >
  F5 Application Delivery Service for Google Cloud bills hourly through your Google Cloud subscription.
  This page covers pricing tiers, NGINX Capacity Units, billing examples, cancellation, and the free trial.
f5-audience: any
---

F5 Application Delivery Service for Google Cloud (F5 ADS for Google Cloud) deploys into your Google Cloud subscription. Your deployment resource is visible there and integrates with the Google Cloud ecosystem. F5 fully manages the underlying infrastructure, software maintenance, availability, and scaling. Billing runs hourly, and you can track it in the Google Cloud Cost Management Dashboard.

## Pricing plans

F5 ADS for Google Cloud is available on an Enterprise plan, backed by a 99.95% uptime service-level agreement (SLA). Pricing has three components, based on resource usage.

### Pricing components

{{< table >}}

| Tier   | Fixed price/hour | NCU price/hour | Data processing/GB | Google Cloud regions                                                                                                            |
|--------|------------------|----------------|--------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Tier 1 | $0.10            | $0.008         | $0.0096            | us-east1, us-east4, us-west1, us-west2, us-west3, us-west4, us-central1, europe-west1, europe-west4, europe-north1, asia-south2 |
| Tier 2 | $0.133           | $0.0106        | $0.0127            | europe-west2, europe-west3, asia-southeast1, asia-south1                                                                        |
| Tier 3 | $0.166           | $0.0132        | $0.0159            | europe-central2                                                                                                                 |

{{< /table >}}

## NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity for a deployment. F5 ADS meters resources hourly based on the capacity you use, so you can scale up or down dynamically. The minimum billing interval is 5 minutes. A single NCU consists of:

   - Bandwidth: 2.2 Mbps
   - Connections: 3,000

## Billing examples

**Example 1: Steady deployment**

A deployment uses 20 NCUs and processes 100 GB of data for 1 hour:

- Fixed price: $0.10/hour
- NCU usage: 20 NCUs * $0.008/hour = $0.16/hour
- Data processing: 100 GB * $0.0096/GB = $0.96

Total cost for 1 hour: $0.10 + $0.16 + $0.96 = **$1.22**

**Example 2: Scaling deployment**

A deployment uses 30 NCUs for 2 hours, then scales to 50 NCUs for 1 more hour, processing 200 GB of data:

- Fixed price: $0.10/hour * 3 hours = $0.30
- NCU usage: (30 NCUs * $0.008/hour * 2 hours) + (50 NCUs * $0.008/hour * 1 hour) = $0.88
- Data processing: 200 GB * $0.0096/GB = $1.92

Total cost for 3 hours: $0.30 + $0.88 + $1.92 = **$3.10**

## Review billing data

F5 ADS for Google Cloud reports billing data per deployment. You can access it through the Google Cloud Cost Management Dashboard. Usage metrics and costs update hourly, so you can monitor and optimize resource allocation.

## Cancel your subscription

{{< call-out class="warning" title="Potential for data loss" >}}
Canceling your subscription immediately suspends your deployments. If you re-subscribe later, you need to recreate every deployment from scratch.
{{< /call-out >}}

To cancel your subscription, go to the [Google Cloud Marketplace Orders](https://console.cloud.google.com/marketplace/orders) page. When you cancel:

- All active deployments immediately move to a suspended state. Suspended deployments stop processing traffic.
- You can still view and delete deployments in the F5 ADS Console, but you can't update existing ones or create new ones.
- You can still view, edit, create, and delete configurations and SSL certificates in the console.

## Free trial

You can sign up for a free trial of F5 ADS for Google Cloud through the [Google Cloud Marketplace](https://console.cloud.google.com/marketplace/product/f5-7626-networks-public/nginxaas-google-cloud). The trial gives you up to $100 in credits or 30 days, whichever comes first.

During the trial, F5 bills you for solution provider fees and credits you the same amount, up to $100. You still pay any applicable infrastructure usage charges.

When the trial ends, F5 charges you under the Enterprise plan unless you cancel first. You can cancel at any time before the trial ends.
