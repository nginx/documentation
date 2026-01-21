---
title: Billing overview
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/billing/overview/
nd-content-type: concept
nd-product: NGOOGL
---

F5 NGINXaaS for Google Cloud is deployed into your Google Cloud subscription, where your deployment resource is visible and integrated with Google Cloud’s ecosystem. The underlying infrastructure, software maintenance, availability, and scaling are fully managed by F5, abstracting operational complexities. Billing occurs hourly and is tracked in the Google Cloud Cost Management Dashboard.

## Pricing plans

F5 NGINXaaS for Google Cloud is offered on an Enterprise plan, delivering enterprise-grade performance, scalability, and security backed by a 99.95% uptime SLA. The pricing model consists of three billing components, ensuring transparent and predictable costs based on resource usage.

### Pricing components
{{< table >}}
| Tier   | Fixed price per hour | NCU price per hour         | Data processing per GB | Google Cloud Regions                                                                                                   |
|--------|---------------------|----------------------------|-----------------------|-----------------------------------------------------------------------------------------------------------------------|
| Tier 1 | $0.10               | $0.008                     | $0.0096               | us-east1, us-east4, us-west1, us-west2, us-west3, us-west4, us-central1, europe-west1, europe-west4, europe-north1    |
| Tier 2 | $0.133              | $0.0106                    | $0.0127               | europe-west2, europe-west3                                                                                            |
| Tier 3 | $0.166              | $0.0132                    | $0.0159               | europe-central2                                                                                                       |
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

Billing data for F5 NGINXaaS for Google Cloud is reported per deployment and can be accessed through the Google Cloud Cost Management Dashboard. Usage metrics and costs are updated hourly, allowing customers to monitor and optimize resource allocation effectively.

## Canceling Subscription

You could unsubscribe from **NGINXaaS for Google Cloud** on the [Marketplace Orders Page](https://console.cloud.google.com/marketplace/orders). When you cancel subscription, any running deployments will immediately enter a **suspended state** and will be scheduled for deletion. In this state, deployments are no longer operational and cannot pass traffic. However, you will still be able to access your deployments in the console to view or delete them, although you will no longer be able to update existing deployments or create new ones while unsubscribed. Even though your deployments are suspended, you will still be able to view, edit, create, and delete configurations and certificates in the console. If you decide to re-subscribe after canceling, please note that you will need to re-create all your deployments from scratch, as any suspended deployments cannot be restored once the cancellation process has started.
