---
description: Learn about NGINX Controller Alerts and Notifications.
nd-docs: DOCS-520
title: About Alerts
toc: true
weight: 100
type:
- concept
---

## Overview

The F5 NGINX Controller Analytics module lets you configure alerts and notifications, so you can stay informed about your system and app performance. In this topic, you'll learn about [alerts](#alerts), [alert rules](#alert-rules), and [alert notifications](#alert-notifications).

{{< see-also >}}
Refer to [Manage Alerts]({{< ref "/controller/analytics/alerts/manage-alerts.md" >}}) to learn how to set up alerts.
{{< /see-also >}}

## Alerts

An *alert* is generated when the criteria for an alert rule are met.
All alerts contain the following information:

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Name | Description |
|---|---|
| `started_timestamp` | The time at which the alert was triggered.|
| `last_checked_timestamp` | The time at which the last alert check occurred.|
| `started_value` | The value of the alert metric at the time the alert was triggered.|
| `last_checked_value` | The value of the alert metric when it was last checked.|
| `dimensions` | The list of dimension values for which the alert was triggered.|

## Alert Rules

An *Alert Rule* defines the conditions that will trigger an alert. NGINX Controller generates names for alert rules automatically. An alert rule consists of the following information:

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Name | Description |
|---|---|
| `name` | A unique identifier for the alert rule.|
| `display name` | A human-friendly name that helps you identify what the alert rule does. |
| `metric` | The [metric]({{< ref "/controller/analytics/catalogs/metrics.md" >}}) that you want to monitor. <br/>{{< note >}}An alert rule can monitor one metric.{{< /note >}}|
| `operator` | The operator that will be applied to the value of the metric to check if an alert should be triggered. There are two available operators: `le` - less or equal and `ge` - greater or equal.|
| `threshold` | Defines the value that, when exceeded, will trigger an alert. <br/>{{< tip >}}You can find the allowed threshold value(s) for each metric in the **unit** field of the metric's entry in the [Metrics Catalogs Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}}). Select the "Index" button to access the list of all available metrics and jump directly to that item in the catalog.{{< /tip >}} |
| `period` | Defines the time window in which you want to calculate the aggregated metric value.<br />- The maximum possible time window is `24h`.<br/>- The minimum possible time window is `2m`.|
| `filter` | Lets you refine the alert rule for a more specific set of metric values, based on dimensions.<br/>If no filter is provided, all collected data will be used when calculating the alert rule status.|
| `group by` | Groups results according to the specified dimension(s). A separate alert will be triggered for each result group. You can provide multiple dimension names as a comma-separated list. <br/>{{<note>}}Using a dimension with a high cardinality of values might result in a high volume of alerts.{{</note>}}|
| `notification type` | Defines how you want to receive alert notifications. |
| `email addresses` | A comma-separated list of email addresses that should receive alert notifications.|
| `mute` | Boolean; turns alert notifications on and off. Set to 'on' to mute notifications. |

If you leave any rule parameter blank, NGINX Controller will take all relevant data for the parameter into account in the alert rule calculation.

Each Alert Rule has a status that describes the current state of the alert rule. It contains the following information:

<a id="alert-rule-status"></a>

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Name | Description |
|---|---|
| `alerts count` | The total number of triggered alerts for the Alert Rule since its creation.|
| `status: ok` | The rule has not triggered any alerts, or that all triggered alerts have expired.|
| `status: ongoing` | At least one alert for the alert rule is currently ongoing.|
| `lastCheckedTimestamp` | The time when the alert rule was last checked successfully.|
| `lastStartedTimestamp` | The time when alert rule status has changed from 'ok' to 'ongoing'.|
| `lastExpiredTimestamp` | The time when alert rule status has changed from 'ongoing' to 'ok'.|

<br/>

Alert rules work in the following manner:

1. Incoming metric updates are continuously monitored against the set of alert rules.
2. The most recent metric value is checked against the threshold defined in the alert rule.
3. If the threshold is met, an alert notification is generated and the rule will continue to be monitored. In the [Alerts Status]({{< ref "/controller/analytics/alerts/manage-alerts.md#view-alert-rule-status" >}}) pane, the alert instance's status will be displayed as "ongoing".
4. If subsequent metric updates show that the metric no longer violates the threshold for the configured period, the alert expires.

## Alert Notifications

An *Alert notification* is a message either displayed in the NGINX Controller user interface or sent via email. Alert notifications are sent when an alert is triggered or expired, depending on the alert rule criteria.

- The **Notifications** feed contains information about all changes in the system, including alert changes. To access the Notifications feed, select the bell icon next to the **Account Settings** menu.
- A notification appears in the Notifications feed immediately when an alert is triggered or expires.
- Alert instance emails notify you when a single alert instance starts or expires.

If you want to stop receiving notifications for an alert rule, but you don't want to delete it, you can [mute the alert rule]({{< ref "/controller/analytics/alerts/manage-alerts.md#mute-or-unmute-an-alert-rule" >}}).
Likewise, if you want to stop receiving emails for an alert rule, but you do want to continue receiving the user interface notifications, [edit the alert rule]({{< ref "/controller/analytics/alerts/manage-alerts.md#edit-an-alert-rule" >}}) and remove your email address.

{{< note >}}If you mute an alert rule while the alert rule status is "ongoing", you will not receive any further alert notifications, including when the alert rule status changes.{{< /note >}}

### Email notifications

{{< important >}}
You must [verify your email address]({{< ref "/controller/analytics/alerts/manage-registered-emails.md" >}}) in order to receive alert notification emails.
{{< /important >}}

When an alert rule's conditions are met, NGINX Controller sends an alert email with the subject "[controller-alert] Alert started: <alert_rule_name>" to all of the email addresses that are specified in the alert rule.

If multiple alerts are triggered in a single calculation period, NGINX Controller sends a summary email message that contains all of the alerts for the time period.

When an alert instance expires, NGINX Controller sends a message with subject "[controller-alert] Alert expired: <alert_rule_name>" to all of the email addresses that are specified in the alert rule.

The notification uses the automatically-generated name that was assigned by the system when the rule was created.

NGINX Controller sends summary emails once every hour. These emails contain alerts that have been triggered or expired since the last summary email was sent. If no alerts started or expired in that timeframe, then the summary will not be sent.

### How Many Notifications to Expect

As an example, let's say that you have three instances configured in the NGINX Controller. You want to monitor all three instances based on the `http.request.count` metric.

Assuming that traffic is constantly flowing through all three instances, and the threshold is exceeded for all three, the system will return three alerts (one per instance). In this case, you would receive one email, containing three alert notices, and three user interface notifications.

If the threshold is exceeded for one instance, then you will receive one alert email and one notification in the user interface.

## How Alerts Work

NGINX Controller checks the list of configured alert rules every 30 seconds. Then, it queries the [Metrics API]({{< ref "/controller/analytics/metrics/metrics-api.md" >}}) for the data defined in each alert rule.

The API query uses the following template:

`?names=<agg-function>(<metric-name>)&startTime=now-<period>&endTime=now<&additional-alert-rule-parameters>"`

where

- `<agg-function>` is the appropriate [aggregation function]({{< ref "/controller/analytics/metrics/metrics-api.md#aggregations" >}}) for the metric. You can find this information in the [Metrics Catalog Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}}).
  - `AVG` applies to `gauge` metrics. Gauges are averaged over the time period configured in the alert rule.
  - `MAX` applies to `counter` metrics.
  - `SUM` applies to `incremental` metrics.

- The `<metric-name>` and `<period>` parameters are read from the alert rule configuration.
- `<&additional-alert-rule-parameters>` e.g. `filter` or `groupBy` parameters read from the alert rule configuration.

NGINX Controller checks the value returned by the Metrics API against the configured threshold, then takes the appropriate action:

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Conditions | Action |
|---|---|
| - threshold is exceeded<br>- "ongoing" alert does not exist | Triggers new alert. |
| - threshold is exceeded<br>- "ongoing" alert exists | Updates existing alert's `last_checked_timestamp` and `last_checked_value`. |
| - threshold *is not* exceeded<br>- "ongoing" alert exists | Expires alert.|
| - threshold *is not* exceeded<br>- "ongoing" does not exist | No action.|

Next, the alert rule status is updated. Each alert rule will be updated with a new `last_checked_timestamp` and new `status`, if applicable.

Finally, the alert notifications for newly-created or expired alerts will be sent for any rules that are not muted.

{{< important >}}
If the [Metrics API]({{< ref "/controller/analytics/metrics/metrics-api.md" >}}) query does not return any data  -- for example, if there was no traffic through the instance and therefore no metric value -- NGINX Controller assumes a value of `0`. In such cases, the threshold will be compared to `0`.
{{< /important >}}

## Alert special cases

### Alerts for the controller.agent.status metric

The `controller.agent.status` is a special metric representing the heartbeat of the NGINX Agent running on the instance.
The metric is reported every 1 minute by the NGINX Agent to the NGINX Controller and may only have a value of 1 if the NGINX Agent is healthy.
If the NGINX Agent is unhealthy it is not reporting the heartbeat and effectively no values for the `controller.agent.status` are stored by the NGINX Controller.
Based on this metric it is possible to create an alert rule and receive notifications whenever the total number of heartbeats reported by a certain NGINX Agent in a recent period is below or equal (or above or equal) certain threshold.

For example, you would like to receive notifications whenever the NGINX Agent availability at any instance is less or equal 70%.
To achieve that:

1. Create an alert rule for the `controller.agent.status` metric.
2. Set the period to at least 10 minutes (recommended, to avoid flapping conditions). Heartbeats arrive every minute while the alert status is evaluated every 30 seconds.
3. Set the threshold to 7 of the NGINX Agent availability (7 heartbeats received in the last 10 min).
4. Set the operator to below or equal.
5. Break out by the instance dimension to get notified about the NGINX Agent availability per instance.

## What's Next

- [Create and Manage Alert Rules]({{< ref "/controller/analytics/alerts/manage-alerts.md" >}})
- [Manage Registered Emails]({{< ref "/controller/analytics/alerts/manage-registered-emails.md" >}})
- [NGINX Controller REST API Reference]({{< ref "/controller/api/_index.md" >}})

{{< versions "3.13" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
