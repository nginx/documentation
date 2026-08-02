---
title: Enable NGINX logs
weight: 350
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/monitoring/enable-nginx-logs/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

F5 NGINXaaS for AWS integrates with Amazon CloudWatch Logs to collect NGINX error and access logs.

When you enable log export, NGINXaaS writes NGINX logs to a CloudWatch Logs log group (the **Log Group**) in a log stream named `logs`.

## Prerequisites

- Configure a **Role ARN** in the **Identity** section of your deployment. NGINXaaS uses this IAM role to export logs to CloudWatch. See [Identity and access management]({{< ref "/nginxaas/aws/deploy/access-management.md" >}}) for how to create the role and attach the [Policy for CloudWatch Logs]({{< ref "/nginxaas/aws/deploy/access-management.md#step-3-add-inline-policies-to-your-role" >}}).
- Grant the IAM role the permissions required to export logs:
  - `logs:CreateLogStream` and `logs:PutLogEvents` — required for NGINXaaS to write logs to the log group.
  - `logs:CreateLogGroup` — required only if you want NGINXaaS to create the log group for you. If you pre-create the log group yourself, you can omit this permission.

  See [AWS's documentation on controlling access to CloudWatch Logs with IAM](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/auth-and-access-control-cwl.html) for more information.
- To view logs in the CloudWatch console, your own AWS identity needs read access such as `logs:GetLogEvents` and `logs:FilterLogEvents`. This is separate from the deployment's IAM role.

## Setting up error logs

{{< include "/nginxaas/logging-config-error-logs.md" >}}

## Setting up access logs

{{< include "/nginxaas/logging-config-access-logs.md" >}}

## Export NGINX logs to CloudWatch

To enable exporting logs, turn on the **Export Logs to CloudWatch** toggle when creating or updating a deployment. To create a deployment, see [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/" >}}) for a step-by-step guide. To update an existing deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. In the **Identity** section, make sure the **Role ARN** field is populated with an IAM role that has the [required permissions](#prerequisites). Log export fails without it.
1. In the **Observability** section, turn on the **Export Logs to CloudWatch** toggle.
1. In the **Log Group Name** field, enter the name of the CloudWatch Logs log group you want to receive exported logs. If you leave this field at its default, NGINXaaS uses a log group named after the deployment object ID.
1. Select **Update**.

## View NGINX logs in Amazon CloudWatch Logs

In the [AWS Management Console](https://console.aws.amazon.com/),

1. Go to the **CloudWatch** console and select **Logs** > **Log Management** > **Log groups**.
1. In the **Filter log groups** field, enter the name of your log group to find it quickly.
1. Select your log group and open the `logs` log stream, or use **Logs Insights** to query across streams.

Refer to the [AWS's CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) documentation to learn how you can create queries.

Within the log group, NGINX access and error logs are written to a log stream named `logs`, which you can use to separate NGINX logs from the rest of your log group's streams. You can also filter based on the following fields using a CloudWatch Logs Insights `filter` or `stats` query, for example,

* `filename`
* `nginxaas_deployment_location`
* `nginxaas_deployment_name`
* `nginxaas_deployment_object_id`
* `nginxaas_namespace`
* `nginxaas_organization_object_id`

For example, to query for a deployment's /var/log/nginx/access.log entries:

1. In the CloudWatch console, select **Logs** > **Logs Insights**.
1. Select the log group for your deployment (default value is the deployment object ID).
1. In the query editor, enter the following query to filter for access log entries

```
fields @timestamp, @message
| filter @logStream = "logs" and attributes.filename = "/var/log/nginx/access.log"
| sort @timestamp desc
```

The same procedure can be used to query via the newer **Log Analytics** feature in the CloudWatch console. See [AWS's documentation on Log Analytics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/LogAnalytics.html) for more information.

## Disable exporting NGINX logs to CloudWatch

To stop exporting logs, update your NGINXaaS deployment to turn off the log export toggle. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. In the **Observability** section, turn off the **Export Logs to CloudWatch** toggle.
1. Select **Update**.

## Troubleshooting

If Amazon CloudWatch Logs is not showing any logs, check for **Failed Log Export to CloudWatch** events from your NGINXaaS deployment.

In the NGINXaaS console:

1. On the navigation menu, select **Events**.
1. Select **Add Filter**.
1. Select **Affected Object** and the name of your NGINXaaS deployment.

Events are deleted after 14 days.

## What's next

- [Enable monitoring]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
- [Metrics catalog]({{< ref "/nginxaas/aws/monitoring/metrics-catalog.md" >}})
- [Identity and access management]({{< ref "/nginxaas/aws/deploy/access-management.md" >}})
