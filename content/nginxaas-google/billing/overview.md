---
title: Billing overview
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/billing/overview/
type:
- concept
---

F5 NGINXaaS for Google Cloud is deployed into your Google Cloud subscription, where your deployment resource is visible and integrated with Google Cloud’s ecosystem. The underlying infrastructure, software maintenance, availability, and scaling are fully managed by F5, abstracting operational complexities. Billing occurs hourly and is tracked in the Google Cloud Cost Management Dashboard.

## Pricing plans

F5 NGINXaaS for Google Cloud is offered on an Enterprise plan, delivering enterprise-grade performance, scalability, and security backed by a 99.95% uptime SLA. The pricing model consists of three billing components, ensuring transparent and predictable costs based on resource usage.

### Pricing components
{{< table >}}

| Component                   | Cost                          |
|---------------------------- | ----------------------------- |
| Fixed price                 | $0.10 per hour                |
| NGINX Capacity Units (NCU)  | $0.008 per NCU per hour       |
| Data processing             | $0.0096 per GB processed      |

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