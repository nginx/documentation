---
title: Migrate from Custom metrics to Platform metrics
weight: 1000
toc: true
url: /nginxaas/azure/monitoring/migrate-to-platform-metrics/
type:
- how-to
---

## Overview

F5 NGINXaaS for Azure previously supported monitoring through [Custom Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-custom-overview), which is a preview feature in Azure. Support for Custom Metrics will be removed in the future. We've added support for Platform Metrics, which is the recommended way to monitor resources in Azure. We strongly recommend switching your deployment's monitoring to Platform Metrics to take advantage of lower latency and better reliability.

## Migration steps

Follow the steps in this section to migrate your deployment monitoring from Custom metrics to Platform metrics.

1. Verify that your NGINXaaS deployment meets the [pre-requisites]({{< ref "/nginxaas-azure/monitoring/enable-metrics.md#prerequisites">}}) for Platform metrics to work.
2. If the pre-requisites are met, Platform metrics are enabled by default on all NGINXaaS deployment. Verify that you are able to see the new metrics in Azure Monitor under the `Standard Metrics` namespace.
3. **Migrate existing alert rules** to use Platform metrics instead of Custom metrics:

   If you have existing alert rules configured for Custom metrics, you need to update them to use the equivalent Platform metrics signals.

   1. In the [Azure portal](https://portal.azure.com), go to **Monitor** > **Alerts**.
   2. Select **Alert rules**.
   3. Select the alert rule you want to migrate, then select **Edit**.
   4. In the **Conditions** tab, select the current **Signal name** to modify it.
   5. Replace the Custom metrics signal with the corresponding Platform metrics signal:
      - Platform metrics signals use the `NGINXaaS Standard Metrics` namespace
   6. The metric name remains the same between Custom and Platform metrics (for example, `nginx.http.request.count`). No update to the signal name is needed.
   7. Review and adjust the alert logic, thresholds, and conditions as needed.
   8. Select **Review + create**, then **Create** to save the updated alert rule.

   {{< call-out "note" >}}For a complete list of available Platform metrics, see the [metrics catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}). To learn more about editing alert rules, refer to the [Edit an existing alert rule](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-metric-alert-rule#edit-an-existing-alert-rule) section in the Azure documentation.{{< /call-out >}}
