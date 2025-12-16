---
title: Billing overview
weight: 100
toc: true
nd-docs: DOCS-885
url: /nginxaas/azure/billing/overview/
nd-content-type: concept
nd-product: NAZURE
---

NGINXaaS for Azure is deployed into your Azure subscription. Your NGINXaaS deployment resource is visible within your subscription, while the underlying infrastructure is managed by F5 and is abstracted away from you.

## Pricing plans

NGINXaaS for Azure is billed monthly based on hourly consumption.

F5 NGINXaaS for Azure (NGINXaaS) provides two pricing plans.

### Standard V3 plan

The Standard V3 plan is an upgraded, purpose-built solution for modern enterprises looking to simplify application traffic management and scale workloads effortlessly. This improved plan offers a [99.95% uptime SLA](https://www.f5.com/pdf/customer-support/eusa-sla.pdf), high availability through active-active deployments, redundancy, lossless rolling upgrades, and dynamic autoscaling capabilities to optimize both performance and cost.

The Standard V3 plan introduces dynamic autoscaling that ensures consumption pricing - customers pay only for what they use. Each NGINX Capacity Unit (NCU) delivers 2.2 Mbps bandwidth and 3,000 connections, providing unmatched flexibility and scalability to suit diverse workloads.

The Standard V3 pricing model is designed to optimize efficiency and transparency: customers benefit from an affordable fixed price per deployment ($0.25/hour) that covers baseline overhead, while NCU usage ($0.008/hour/unit) and data processing ($0.005/GB) allow costs to scale precisely with demand. NGINXaaS is a consumption-based service, metered hourly, and billed monthly in NGINX Capacity Units (NCUs).

The Standard V3 plan allows for optional Web Application Firewall (WAF) configuration and a higher number of listen ports, offering enhanced security and connectivity options for enterprise applications.

The SKU for the Standard V3 pricing plan is `standardv3_Monthly`.

### Standard V2 plan

The Standard V2 plan is designed for production workloads offering a [99.95% uptime SLA](https://www.f5.com/pdf/customer-support/eusa-sla.pdf), high availability through active-active deployments, redundancy, autoscaling, lossless rolling upgrades, and more. Choosing the Standard V2 plan will result in billing based on metered consumption of NGINX Capacity Units (NCU).

When using the Standard V2 plan, NGINXaaS is a consumption-based service, metered hourly, and billed monthly in NGINX Capacity Units (NCUs).

The SKU for the Standard V2 pricing plan is `standardv2_Monthly`.

The Standard V2 plan allows for configuration of F5 WAF for NGINX and a higher number of listen ports.


### Developer plan

The Developer plan is ideal for those who are just starting out, as it's intended for early-stage trials, development work, and testing. Please note that it doesn't provide service level agreement (SLA) guarantees, and it lacks both redundancy options and the capability to scale resources as needed.

When using the Developer plan, each NGINXaaS deployment is billed at the rate specified on the [Azure Marketplace Offer](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/f5-networks.f5-nginx-for-azure?tab=Overview).

The SKU for the Developer pricing plan is `developer_Monthly`.

{{< call-out "note" >}}The costs for your plan will appear on the Azure Portal Cost Analysis page and the Azure Consumption APIs. There may be a 24h delay before usage is visible.{{< /call-out >}}


## NGINX Capacity Unit (NCU)

{{< include "/nginxaas-azure/ncu-description.md" >}}

Each NCU provisioned (not consumed) is billed at the rate specified on the [Azure Marketplace Offer](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/f5-networks.f5-nginx-for-azure?tab=Overview). The minimum usage interval is 1 hour, and the maximum provisioned NCU size is billed for that hour.

*Billing Example 1*: "I provisioned a 20 NCU NGINXaaS deployment in East US 2 at 9:04AM and then deleted it at 10:45AM. Assuming 1GB data processed"

* The hourly fixed price per deployment is `$0.25/hour`
* The hourly NCU rate in East US 2 is `$0.008/NCU/hour`
* The data processing price is `$0.005/GB`
* 9:00 hour: `20 NCU·hour`
* 10:00 hour: `20 NCU·hour`
* Total NCU·hours: `40 NCU·hour`
* Fixed deployment cost: `2 hours * $0.25/hour = $0.50`
* NCU usage cost: `40 NCU·hour * $0.008/NCU/hour = $0.32`
* Data processing cost: `1 GB * $0.005/GB = $0.005`
* Total: `$0.50 + $0.32 + $0.005 = $0.87`

*Billing Example 2*: "I provisioned a 40 NCU NGINXaaS deployment in West Europe at 9:34AM. At 10:04AM I resized it to 20 NCUs. I then deleted it at 11:45AM. Assuming 2.5GB data processed"

* The hourly fixed price per deployment is `$0.25/hour`
* The hourly NCU rate in West Europe is `$0.008/NCU/hour`
* The data processing price is `$0.005/GB`
* 9:00 hour: `40 NCU·hour`
* 10:00 hour: `40 NCU·hour`
* 11:00 hour: `20 NCU·hour`
* Total NCU·hours: `100 NCU·hour`
* Fixed deployment cost: `3 hours * $0.25/hour = $0.75`
* NCU usage cost: `100 NCU·hour * $0.008/NCU/hour = $0.80`
* Data processing cost: `2.5 GB * $0.005/GB = $0.125`
* Total: `$0.75 + $0.80 + $0.125 = $1.675`

{{< call-out "note" >}}Further guidance:
* For how many NCUs should you provision and how to scale to match workload, see the [Scaling Guidance]({{< ref "/nginxaas-azure/quickstart/scaling.md" >}})
* To learn more about metrics related to NCUs, see the [NGINXaaS Statistics namespace]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md#nginxaas-statistics" >}})
{{< /call-out >}}


## Bandwidth

The standard Azure [networking](https://azure.microsoft.com/en-us/pricing/details/virtual-network/) and [bandwidth](https://azure.microsoft.com/en-us/pricing/details/bandwidth/) charges apply to NGINX deployments.

{{< call-out "note" >}}The management traffic for NGINX instances is billed as a `Virtual Network Peering - Intra-Region Egress` charge. This charge includes the data for shipping metrics and logs. The cost for shipping metrics data is approximately $0.03/month. If you enable NGINX logging the cost increases by roughly $0.005 per GB of logs NGINX generates. To estimate this, multiply the number of requests by the average log line size of the access_log format you have configured.
{{< /call-out >}}

## Review billing data

NGINXaaS billing data is reported per deployment and can be viewed in the Azure Portal under "Cost Management + Billing".​