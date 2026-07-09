---
title: Billing overview
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/billing/overview/
f5-content-type: concept
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

F5 NGINXaaS for AWS is deployed into your AWS account, where your deployment resource is visible and integrated with AWS's ecosystem. The underlying infrastructure, software maintenance, availability, and scaling are fully managed by F5, abstracting operational complexities. Billing occurs hourly and is tracked in AWS Cost Explorer.

## Pricing plans

F5 NGINXaaS for AWS is offered on an Enterprise plan, delivering enterprise-grade performance, scalability, and security backed by a 99.95% uptime SLA. The pricing model consists of three billing components, ensuring transparent and predictable costs based on resource usage.

### Pricing components
{{< table >}}
| Tier   | Fixed price per hour | NCU price per hour         | Data processing per GB | AWS Regions                                                                                                   |
|--------|---------------------|----------------------------|-----------------------|-----------------------------------------------------------------------------------------------------------------------|
| Tier 1 | $0.10               | $0.008                     | $0.0096               | us-east-1, us-east-2, us-west-1, us-west-2, eu-west-1, eu-north-1, ap-south-1, ap-southeast-1    |
| Tier 2 | $0.133              | $0.0106                    | $0.0127               | eu-west-2, eu-west-3, ap-southeast-2                                                                           |
| Tier 3 | $0.166              | $0.0132                    | $0.0159               | eu-central-1                                                                                                       |
{{< /table >}}

## NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity for a deployment. Resources are metered hourly based on the capacity utilized, enabling customers to scale up or down dynamically. The minimum billing interval is 5 min, ensuring accurate alignment of cost and usage. A single NCU consists of:

   - Bandwidth – 2.2 Mbps
   - Connections – 3000

## Billing examples

### Deployment with 20 NCUs processing 100 GB of data for 1 hour

- Fixed price: $0.10/hour
- NCU usage: 20 NCUs * $0.008/hour = $0.16/hour
- Data processing: 100 GB * $0.0096/GB = $0.96

**Total cost for 1 hour: $0.10 + $0.16 + $0.96 = $1.22**

### Deployment using 30 NCUs for 2 hours and scaled to 50 NCUs for another hour, processing 200 GB of data

- Fixed price: $0.10/hour * 3 hours = $0.30
- NCU usage: (30 NCUs * $0.008/hour * 2 hours) + (50 NCUs * $0.008/hour * 1 hour) = $0.88
- Data processing: 200 GB * $0.0096/GB = $1.92

**Total cost for 3 hours: $0.30 + $0.88 + $1.92 = $3.10**

## Review billing data

Billing data for F5 NGINXaaS for AWS is reported per deployment and can be accessed through AWS Cost Explorer. Usage metrics and costs are updated hourly, allowing customers to monitor and optimize resource allocation effectively.

## Cancelling your NGINXaaS for AWS subscription

You can unsubscribe from NGINXaaS for AWS by visiting the AWS Marketplace [Manage subscriptions](https://aws.amazon.com/marketplace/management/subscriptions) page. Please note the following behavior when you cancel your subscription:

- Upon cancelation, all active deployments will immediately transition to a suspended state. In the suspended state, deployments will no longer be operational and cannot process traffic.
- While in this state, you will still have access to your deployments via the NGINXaaS Console, allowing you to view or delete them. However, it will no longer be possible to update existing deployments or create new ones.
- Despite the suspension of deployments, you will retain the ability to view, edit, create, and delete configurations and SSL certificates through the console.

If you decide to re-subscribe to NGINXaaS for AWS after canceling your subscription, all previously suspended deployments will remain deactivated. You will need to recreate your deployments from scratch.

We recommend carefully reviewing your deployments and configurations before initiating the cancelation process to avoid any unintended data loss.

## Free trial

You can sign up for a free trial of NGINXaaS for AWS through the [AWS Marketplace](https://aws.amazon.com/marketplace/).
The free trial provides up to USD 100 in credits for a maximum of 30 days, whichever comes first, to help you explore NGINXaaS for AWS and its features.

During the trial, you will be billed for solution provider fees and credited for those same fees at the same time, up to USD 100. Additionally, you will still be billed for any applicable infrastructure usage charges during the trial period.

At the end of the trial period, you will be charged under the Enterprise plan unless you stop or end the subscription. You may cancel the trial at any time by canceling your plan before the trial ends.
