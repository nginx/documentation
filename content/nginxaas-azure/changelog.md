---
title: "Changelog"
weight: 900
toc: true
docs: "DOCS-870"
url: /nginxaas/azure/changelog/

---

Learn about the latest updates, new features, and resolved bugs in F5 NGINX as a Service for Azure.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas-azure/known-issues.md" >}}) page.

To review older entries, visit the [Changelog archive]({{< ref "/nginxaas-azure/changelog-archive" >}}) section.

## April 17, 2025

### What's New

- {{% icon-feature %}} **NGINX App Protect WAF is now generally available**

NGINX App Protect WAF is now generally available and is no longer a preview feature and will therefore be billed as specified in the [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/f5-networks.f5-nginx-for-azure?tab=PlansAndPrice)

## March 31, 2025

### What's New

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

  NGINXaaS for Azure is now available in the following additional regions:

  - UK West
  - UK South

See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## March 13, 2025

- {{% icon-resolved %}} **Percentage capacity metric**

   We’re introducing the new percentage capacity metric, `nginxaas.capacity.percentage`, which provides a more accurate estimate of your deployment's load compared to the previous consumed NCUs metric. The new capacity metric expresses the capacity consumed as a percentage of the deployment's total capacity. Please modify any alerts and monitoring on deployment performance to use the new percentage capacity metric. The consumed NCUs metric is being deprecated and will be removed in the near future. Please see [Scaling guidance]({{< ref "/nginxaas-azure/quickstart/scaling.md">}}) for more details.

## March 5, 2025

- {{% icon-info %}} **Retirement of Standard Plan**

   The `Standard` plan for NGINXaaS for Azure has been retired, and you can no longer use it to create new deployments. If you have a deployment running on the `Standard` plan, consider [migrating]({{< ref "/nginxaas-azure/troubleshooting/migrate-from-standard.md">}}) it to the [`Standard V2 plan`]({{< ref "/nginxaas-azure/billing/overview.md#standard-v2-plan" >}}) to access new features such as NGINX App Protect WAF and additional listen ports. Plan migration does not incur downtime.

## February 10, 2025

- {{% icon-feature %}} **NGINXaaS Load Balancer for Kubernetes is now Generally Available**

   NGINXaaS can now be used as an external load balancer to route traffic to workloads running in your Azure Kubernetes Cluster. To learn how to set it up, see the [Quickstart Guide]({{< ref "/nginxaas-azure/quickstart/loadbalancer-kubernetes.md">}}).

## January 23, 2025

- {{< icon-feature >}} **In-place SKU Migration from Standard to Standard V2**

   You can now migrate NGINXaaS for Azure from the Standard plan to the Standard V2 plan without redeploying. We recommend upgrading to the Standard V2 plan to access features like NGINX App Protect WAF and more listen ports. The Standard plan will be retired soon. For migration details, see [migrate from standard]({{< ref "/nginxaas-azure/troubleshooting/migrate-from-standard.md">}}).
