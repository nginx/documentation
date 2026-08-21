---
title: Enable monitoring
description: "Learn how to enable, view, and disable Amazon CloudWatch metric export for F5 Application Delivery Service for AWS deployments."
weight: 200
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/monitoring/enable-monitoring/
f5-content-type: how-to
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 Application Delivery Service for AWS, CloudWatch, metrics, monitoring, Embedded Metric Format, EMF, CloudWatch Logs, status_zone"
f5-summary: >
  Learn how to export performance metrics from F5 Application Delivery Service for AWS deployments to Amazon CloudWatch.
  This guide covers configuring IAM role permissions, enabling metric export in the F5 Application Delivery Service console, and viewing metrics in CloudWatch Metrics Explorer.
f5-audience: operator
---

## Overview

Monitoring your application's performance is crucial for maintaining its reliability and efficiency. F5 Application Delivery Service for AWS (ADS) integrates with Amazon CloudWatch so you can collect, correlate, and analyze metrics for a thorough understanding of your application's health and behavior.

F5 ADS exports metrics using the [Amazon CloudWatch Embedded Metric Format (EMF)](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format.html). When you enable metric export, F5 ADS writes EMF records to a CloudWatch Logs log group (the **Metric Group**) in a log stream named `metrics`. CloudWatch automatically extracts these records into metrics under the `F5 Application Delivery Service` namespace, where you can chart and query them like any other CloudWatch metric.

## Before you begin

- Configure a **Role ARN** in the **Identity** section of your deployment. F5 ADS uses this IAM role to export metrics to CloudWatch. See [Identity and access management]({{< ref "/nginxaas/aws/deploy/access-management.md" >}}) for how to create the role and attach the [Policy for CloudWatch Logs]({{< ref "/nginxaas/aws/deploy/access-management.md#step-3-add-inline-policies-to-your-role" >}}).
- Grant the IAM role the permissions required to export metrics:
  - `logs:CreateLogStream` and `logs:PutLogEvents`: required for F5 ADS to write EMF records to the metric log group.
  - `logs:CreateLogGroup`: required only if you want F5 ADS to create the log group for you. If you pre-create the log group yourself, you can omit this permission.

  See [AWS's documentation on controlling access to CloudWatch Logs with IAM](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/auth-and-access-control-cwl.html) for more information.
- To view metrics in the CloudWatch console, your own AWS identity needs read access such as `cloudwatch:GetMetricData` and `cloudwatch:ListMetrics`. This is separate from the deployment's IAM role. See [AWS's documentation on identity and access management for Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/auth-and-access-control-cw.html) for more information.
- Configure the [`status_zone`](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone) directive in your `server` blocks and the [`zone`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) directive in your `upstream` blocks to collect HTTP request and response statistics, stream connection metrics, upstream statistics, and memory statistics. See the [Metrics Catalog]({{< ref "/nginxaas/aws/monitoring/metrics-catalog.md" >}}) for configuration requirements.

## Export F5 Application Delivery Service metrics to CloudWatch

To enable exporting metrics, turn on the **Export Metrics to CloudWatch** toggle when creating or updating a deployment. To create a deployment, see [our documentation on creating an F5 ADS deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/" >}}) for a step-by-step guide. To update an existing deployment, in the F5 ADS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. In the **Identity** section, make sure the **Role ARN** field is populated with an IAM role that has the [required permissions](#before-you-begin). Metric export fails without it.
1. In the **Observability** section, turn on the **Export Metrics to CloudWatch** toggle.
1. In the **Metric Group Name** field, enter the name of the CloudWatch Logs log group you want to receive exported metrics. If you leave this field at its default, F5 ADS uses a log group named after the deployment object ID.
1. Select **Update**.

Within the metric log group, F5 ADS writes EMF records to a log stream named `metrics`. CloudWatch extracts these records into metrics under the `F5 Application Delivery Service` namespace.

## View F5 Application Delivery Service metrics in Amazon CloudWatch

See the [Metrics Catalog]({{< ref "/nginxaas/aws/monitoring/metrics-catalog.md" >}}) for a full list of metrics F5 ADS provides.

### CloudWatch Metrics Explorer

Log in to the [AWS Management Console](https://console.aws.amazon.com/),

1. Go to the **CloudWatch** console.
1. Select **Classic Metrics** and then select the **F5 Application Delivery Service** tile in the **Custom Namespaces** section.

Refer to the [AWS's CloudWatch Metrics Explorer](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metrics-Explorer.html) documentation to learn how you can create charts and queries.

{{< call-out class="note" >}}Metrics can take a few minutes to appear after you enable export, because CloudWatch must first ingest the EMF records and extract them into the `F5 Application Delivery Service` namespace. To inspect the raw EMF records, open the `metrics` log stream in your metric log group with [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html).{{< /call-out >}}

## Disable F5 Application Delivery Service metric export to CloudWatch

To stop exporting metrics, update your F5 ADS deployment to turn off the metric export toggle. To update the deployment, in the F5 ADS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. In the **Observability** section, turn off the **Export Metrics to CloudWatch** toggle.
1. Select **Update**.

## Troubleshooting

If Amazon CloudWatch is not showing any metrics, check for **Failed Metric Export to CloudWatch** events from your F5 ADS deployment.

In the F5 ADS console:

1. On the navigation menu, select **Events**.
1. Select **Add Filter**.
1. Select **Affected Object** and the name of your F5 ADS deployment.

Events are deleted after 14 days.

## What's next

- [Enable NGINX logs]({{< ref "/nginxaas/aws/monitoring/enable-nginx-logs.md" >}})
- [Metrics catalog]({{< ref "/nginxaas/aws/monitoring/metrics-catalog.md" >}})
- [Identity and access management]({{< ref "/nginxaas/aws/deploy/access-management.md" >}})
