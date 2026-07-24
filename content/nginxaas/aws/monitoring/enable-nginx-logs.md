---
title: Enable NGINX logs
weight: 350
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/monitoring/enable-nginx-logs/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

F5 NGINXaaS for AWS supports integrating with AWS services to collect NGINX error and access logs, and F5 WAF for NGINX security logs.

## Prerequisites

- Configure IAM Role Federation (OIDC). See [our documentation on setting up IAM Role Federation]({{< ref "/nginxaas/aws/deploy/access-management.md#configure-iam-role-federation" >}}) for exact steps.
- Grant the IAM role access to read logs, for example, `logs:GetLogEvents` and `logs:FilterLogEvents`. See [AWS's documentation on controlling access to CloudWatch Logs with IAM](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/auth-and-access-control-cwl.html) for more information.

## Setting up error logs

{{< include "/nginxaas/logging-config-error-logs.md" >}}

## Setting up access logs

{{< include "/nginxaas/logging-config-access-logs.md" >}}

## Setting up F5 WAF for NGINX security logs

{{< include "/nginxaas/logging-config-security-logs.md" >}}

## Export NGINX logs to a CloudWatch log group

To enable sending logs to your desired CloudWatch log group, you must specify the log group when creating or updating a deployment. To create a deployment, see [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/" >}}) for a step-by-step guide. To update the deployment, in the NGINXaaS console,

1. On the left menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter the log group you want logs to be sent to under **CloudWatch Log Group**.
1. Select **Update**.

## View NGINX logs in Amazon CloudWatch Logs

In the [AWS Management Console](https://console.aws.amazon.com/),

1. Go to your CloudWatch log group.
2. Search for "CloudWatch Logs Insights".

Refer to the [AWS's CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) documentation to learn how you can create queries.

NGINX access and error logs sent to Amazon CloudWatch Logs will have the log stream prefix `nginx-logs` which can be used to filter NGINX logs from the rest of your log group's streams. You can also filter based on the following fields using a CloudWatch Logs Insights `filter` or `stats` query, for example,

* `filename`
* `nginxaas_organization_object_id`
* `nginxaas_deployment_location`
* `nginxaas_deployment_name`
* `nginxaas_deployment_object_id`
* `nginxaas_namespace`

For example, the following query filters for a specific deployment name and counts entries by filename:

```
fields @timestamp, @message
| filter nginxaas_deployment_name = "my-deployment"
| stats count() by filename
```

## Disable Exporting NGINX logs to a CloudWatch log group

To disable sending logs to your CloudWatch log group, update your NGINXaaS deployment to remove the reference to your log group. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Remove the log group under **CloudWatch Log Group**.
1. Select **Update**.

## Troubleshooting

If Amazon CloudWatch Logs is not showing any logs, check for **Failed Log Export to CloudWatch** events from your NGINXaaS deployment.

In the NGINXaaS console:

1. On the navigation menu, select **Events**.
1. Select **Add Filter**.
1. Select **Affected Object** and the name of your NGINXaaS deployment.

Events are deleted after 14 days.
