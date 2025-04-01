---
description: Learn how to view, add, mute, and delete Alerts.
docs: DOCS-521
title: Manage Alerts
toc: true
weight: 200
type:
- concept
---

## Overview

[Alerts]({{< ref "/controller/analytics/alerts/about-alerts.md" >}}) are notifications about the F5 NGINX Controller system and your applications' performance.

[Alert rules]({{< ref "/controller/analytics/alerts/about-alerts.md#alert-rules" >}}) let you specify what you want to be alerted about. This includes which metrics you want to monitor; the trigger conditions and threshold to meet; the instance(s) to monitor; and the email address(es) to use for notifications.

## Add an Alert Rule

To add an alert rule:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Alerts > Alert Rules**.
1. Select **Create Alert Rule**.
1. Define your alert rule by providing the following information:

   - Name
   - (Optional) Display Name
   - Metric
   - Condition, Threshold, and Time Period
   - Filter
   - (Optional) Breakout
   - Email Notification Address(es):

     - Select the desired address(es) from the list provided, or
     - Select **Manage Email Addresses** to add a new address, then take the steps below:

       1. Select **Add Email Address**.
       1. Provide the desired email address.
       1. Select the submit (plus sign) icon.
       1. Select **Done** to close the Manage Email Addresses panel.

       {{<note>}}You will need to verify the email address before it can begin receiving alerts.{{</note>}}

1. (Optional) Select **Mute Alert Rule** if you want to create the alert rule but not receive any associated notifications.
1. Select **Create**.

## View Alerts

To view all **alerts** that are triggered by alert rules:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Alerts > Alerts**.

All alert rules and triggered alerts are displayed on this page. You can use the search bar to filter the alerts that are displayed.

## Edit an Alert Rule

To edit an alert:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Alerts > Alert Rules**.
1. Select the alert rule that you want to edit.
1. Select the edit (pencil) icon for the alert rule.
1. Make the desired changes to the alert rule, then select **Save**.

{{< important >}}
When you edit an alert rule, any ongoing alerts which previously met that rule will expire immediately.

If the threshold is still exceeded in the new alert rule configuration, new alerts will be triggered.
{{< /important >}}

## Mute or Unmute an Alert Rule

If you want to stop receiving notifications for an alert rule without deleting it, you can mute it. Likewise, you can unmute alert rules for which you want to resume receiving notifications.

To mute or unmute an alert:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Alerts > Alert Rules**.
1. Select the alert rule that you want to mute or unmute.
1. Select the mute (volume) icon to mute or unmute the alert rule.

## Delete an Alert Rule

To delete an alert rule:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Alerts > Alert Rules**.
1. Select the alert rule that you want to delete.
1. Select the delete (trash can) icon to delete the alert rule.
1. Select **Delete** in the pop-up box to confirm that you want to proceed.

## What's Next

- Learn more [About Alerts]({{< ref "/controller/analytics/alerts/about-alerts.md" >}})
- Learn more about [Metrics and Metadata]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- Learn more about [Traffic Metrics]({{< ref "/controller/analytics/metrics/overview-traffic-metrics.md" >}})
- [Manage Registered Emails]({{< ref "/controller/analytics/alerts/manage-registered-emails.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
