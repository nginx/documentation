---
title: "Billing overview"
weight: 100
categories: ["concepts"]
toc: true
docs: "DOCS-885"
url: /nginxaas/azure/billing/overview/
---

## Pricing plans

F5 NGINX as a Service for Azure (NGINXaaS) provides two pricing plans.

### Standard V2 plan

The Standard V2 plan is designed for production workloads offering a [99.95% uptime SLA](https://www.f5.com/pdf/customer-support/eusa-sla.pdf), high availability through active-active deployments, redundancy, autoscaling, lossless rolling upgrades, and more. Choosing the Standard V2 plan will result in billing based on metered consumption of NGINX Capacity Units (NCU).

When using the Standard V2 plan, NGINXaaS is a consumption-based service, metered hourly, and billed monthly in NGINX Capacity Units (NCUs).

The SKU for the Standard V2 pricing plan is `standardv2_Monthly`.

The Standard V2 plan allows for configuration of NGINX App Protect WAF and a higher number of listen ports.


### Basic plan

The Basic plan is ideal for those who are just starting out, as it's intended for early-stage trials, development work, and testing. Please note that it doesn't provide service level agreement (SLA) guarantees, and it lacks both redundancy options and the capability to scale resources as needed.

When using the Basic plan, each NGINXaaS deployment is billed at the rate specified on the [Azure Marketplace Offer](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/f5-networks.f5-nginx-for-azure?tab=Overview).

The SKU for the Basic pricing plan is `basic_Monthly`.

{{< note >}}The costs for your plan will appear on the Azure Portal Cost Analysis page and the Azure Consumption APIs. There may be a 24h delay before usage is visible.{{< /note >}}


## NGINX Capacity Unit (NCU)

{{< include "/nginxaas-azure/ncu-description.md" >}}

Each NCU provisioned (not consumed) is billed at the rate specified on the [Azure Marketplace Offer](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/f5-networks.f5-nginx-for-azure?tab=Overview). The minimum usage interval is 1 hour, and the maximum provisioned NCU size is billed for that hour.

*Billing Example 1*: "I provisioned a 20 NCU NGINXaaS deployment in East US 2 at 9:04AM and then deleted it at 10:45AM."

* The hourly rate in East US 2 is `$0.03/NCU/hour`.
* 9:00 hour: `20 NCU·hour`
* 10:00 hour: `20 NCU·hour`
* Total NCU·hours: `40 NCU·hour`
* Total: `40 NCU·hour * $0.03/NCU/hour = $1.20`.

*Billing Example 2*: "I provisioned a 40 NCU NGINXaaS deployment in West Europe at 9:34AM. At 10:04AM I resized it to 20 NCUs. I then deleted it at 11:45AM."

* The hourly rate in West Europe is `$0.05/NCU/hour`.
* 9:00 hour: `40 NCU·hour`
* 10:00 hour: `40 NCU·hour`
* 11:00 hour: `20 NCU·hour`
* Total NCU·hours: `100 NCU·hour`
* Total:  `100 NCU·hours * 0.05$/NCU/hour = $5.00`.

{{< note >}}Further guidance:
* For how many NCUs should you provision and how to scale to match workload, see the [Scaling Guidance]({{< relref "/nginxaas-azure/quickstart/scaling.md" >}})
* To learn more about metrics related to NCUs, see the [NGINXaaS Statistics namespace]({{< relref "/nginxaas-azure/monitoring/metrics-catalog.md#nginxaas-statistics" >}})
{{< /note >}}


## Bandwidth

The standard Azure [networking](https://azure.microsoft.com/en-us/pricing/details/virtual-network/) and [bandwidth](https://azure.microsoft.com/en-us/pricing/details/bandwidth/) charges apply to NGINX deployments.

{{< note >}}The management traffic for NGINX instances is billed as a `Virtual Network Peering - Intra-Region Egress` charge. This charge includes the data for shipping metrics and logs. The cost for shipping metrics data is approximately $0.03/month. If you enable NGINX logging the cost increases by roughly $0.005 per GB of logs NGINX generates. To estimate this, multiply the number of requests by the average log line size of the access_log format you have configured.
{{< /note >}}
