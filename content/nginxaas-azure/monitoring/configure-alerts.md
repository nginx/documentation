---
title: Configure alerts
weight: 300
toc: true
draft: false
docs: DOCS-985
url: /nginxaas/azure/monitoring/configure-alerts/
type:
- how-to
---

## Overview

{{<note>}}F5 NGINX as a Service for Azure (NGINXaaS) publishes platform metrics to Azure Monitor. To learn more about how to create and manage metrics-based alert rules, refer to the [Alerts section in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-new-alert-rule?tabs=metric) documentation from Microsoft. {{</note>}}

This guide explains how to create and configure metrics-based alerts for your NGINXaaS for Azure deployment using Azure Monitor.


## Prerequisites

- Setup is complete for [NGINXaaS for Azure deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment/" >}}).

- To complete this setup, you must be an owner or user access administrator for the NGINX deployment resource.

- To enable metrics, see [Enable Monitoring]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}).

{{<note>}} See [Azure monitor overview](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) documentation to familiarize with Azure Monitor. {{</note>}}

## Create metrics-based alerts for proactive monitoring.

1. Go to your NGINXaaS for Azure deployment.

2. Select **Alerts** in the left menu.

3. In the **Create** menu, select **Alert rule**.

4. Select the **Scope** tab, and choose NGINX deployment as the scope of the alert.

{{<note>}} The scope is auto-selected as NGINX deployment. {{</note>}}

5. In the **Conditions** tab, select a **Signal name**, for example, "nginx.http.request.count".

   {{< img src="nginxaas-azure/alert-select-signal.png" alt="Screenshot of the Conditions tab showing how to select a Signal name from the list" >}}

6. Define the **alert logic** such as:

   - Set the threshold and average as per your requirements.
   - Set the frequency to evaluate alerts as per your requirements.

   {{< img src="nginxaas-azure/alert-logic.png" alt="Screenshot of the alert logic page showing how to set the threshold and frequency" >}}

7. Define the **actions**:

    - Create an **action group** for future reference. See the [Configure basic action group settings](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) section.
    - Define the **notification settings**: whom to notify when the alert is triggered. See the [Configure notifications](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) section.
    - (Optional) Define an action to be performed when the alert is triggered, such as a runbook or azure function.

8. Fill out the details of the alert:

    - Specify the **severity** of the alert, and the name of the rule.
    - In the **advanced options** tab, you can turn on "Enable alert upon creation" and "Automatically resolve alerts".

{{<note>}} [Standard Azure alert charges will apply](https://azure.microsoft.com/en-us/pricing/details/monitor/).{{</note>}}