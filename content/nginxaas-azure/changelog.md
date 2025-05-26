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


## May 22, 2025

- {{% icon-feature %}} **NGINXaaS is now running NGINX Plus Release 33 (R33) in the Stable Upgrade Channel**

  NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) have now been automatically upgraded to  [NGINX Plus Release 33 (R33)]({{< ref "/nginx/releases.md#nginxplusrelease-33-r33" >}}). This upgrade also includes updates to the following NGINX Plus modules:
  - nginx-plus-module-njs
   For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#configuration-directives-list" >}}).

## May 20, 2025

- {{% icon-feature %}} **Azure Monitor Platform Metrics**

   NGINXaaS now publishes platform metrics directly to Azure Monitor. Compared to legacy monitoring based on custom metrics, platform metrics offers reduced latency and higher reliability. We strongly recommend migrating your alerts to use platform metrics for improved monitoring and management. For more details on enabling platform metrics, please refer to [Enable Monitoring]({{< relref "/nginxaas-azure/monitoring/enable-monitoring.md">}}).

## April 22, 2025

### What's New

- {{% icon-feature %}} **NGINX App Protect WAF is now generally available**

NGINX App Protect WAF is now generally available and is no longer a preview feature and will therefore be billed as specified in the [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/f5-networks.f5-nginx-for-azure?tab=PlansAndPrice). This feature now supports the creation and deployment of [custom security policies]({{< relref "./app-protect/configure-waf.md#custom-policies" >}}).

## April 16, 2025

- {{% icon-feature %}} **Notification on update to deployments using the Stable Upgrade Channel**

   NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) will be updated to [NGINX Plus Release 33 (R33)]({{< ref "/nginx/releases.md#nginxplusrelease-33-r33" >}}) during the week of May 05-09, 2025. This will also include updates to the following NGINX Plus modules:
  - nginx-plus-module-njs

   Please review the [NGINX Plus Release 33 (R33)]({{< ref "/nginx/releases.md#nginxplusrelease-33-r33" >}}) Release Notes carefully. If you have any concerns, it's recommended to validate your configuration against NGINX Plus R33 by setting up a test deployment using the **Preview** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}). See [these instructions]({{< ref "/nginxaas-azure/quickstart/recreate.md" >}}) on how to set up a deployment similar to your current one. For entitlement and visibility policy, check [the FAQs]({{< ref "/nginxaas-azure/faq.md" >}}) to address any additional questions you might have.

   If you have any questions or concerns, please [contact us]({{< ref "/nginxaas-azure/troubleshooting/troubleshooting.md" >}}).

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

   NGINXaaS can now be used as an external load balancer to route traffic to workloads running in your Azure Kubernetes Cluster. To learn how to set it up, see the [Quickstart Guide]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md">}}).

## January 23, 2025

- {{< icon-feature >}} **In-place SKU Migration from Standard to Standard V2**

   You can now migrate NGINXaaS for Azure from the Standard plan to the Standard V2 plan without redeploying. We recommend upgrading to the Standard V2 plan to access features like NGINX App Protect WAF and more listen ports. The Standard plan will be retired soon. For migration details, see [migrate from standard]({{< ref "/nginxaas-azure/troubleshooting/migrate-from-standard.md">}}).
