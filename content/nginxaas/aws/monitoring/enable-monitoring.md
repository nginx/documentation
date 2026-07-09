---
title: Enable monitoring
weight: 200
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/monitoring/enable-monitoring/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

Monitoring your application's performance is crucial for maintaining its reliability and efficiency. F5 NGINXaaS for AWS seamlessly integrates with AWS services, allowing you to collect, correlate, and analyze metrics for a thorough understanding of your application's health and behavior.

## Prerequisites

- Configure IAM Role Federation (OIDC). See [our documentation on setting up IAM Role Federation]({{< ref "/nginxaas/aws/deploy/access-management.md#configure-iam-role-federation" >}}) for exact steps.
- Grant the IAM role access to the following permissions depending on your needs:
  - `cloudwatch:GetMetricData` and `cloudwatch:ListDashboards` — view metrics and dashboards in Amazon CloudWatch (read-only access)
  - `cloudwatch:PutMetricData` — required for NGINXaaS for AWS to publish metrics to your CloudWatch namespace

  See [AWS's documentation on identity and access management for Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/auth-and-access-control-cw.html) for more information.
- Configure the [`status_zone`](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone) directive in your `server` blocks and the [`zone`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) directive in your `upstream` blocks to collect HTTP request and response statistics, stream connection metrics, upstream statistics, and memory statistics. See the [Metrics Catalog]({{< ref "/nginxaas/aws/monitoring/metrics-catalog.md" >}}) for configuration requirements.

## Export NGINXaaS metrics to a CloudWatch namespace

To enable sending metrics to your desired CloudWatch namespace, you must specify the namespace when creating or updating a deployment. To create a deployment, see [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/" >}}) for a step-by-step guide. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter the namespace you want metrics to be sent to under **CloudWatch Namespace**, for example, `NGINXaaS`.
1. Select **Update**.

## View NGINXaaS metrics in Amazon CloudWatch

See the [Metrics Catalog]({{< ref "/nginxaas/aws/monitoring/metrics-catalog.md" >}}) for a full list of metrics NGINXaaS for AWS provides.

### CloudWatch Metrics Explorer

Log in to the [AWS Management Console](https://console.aws.amazon.com/),

1. Go to the **CloudWatch** console.
2. Search for "Metrics Explorer".

Refer to the [AWS's CloudWatch Metrics Explorer](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metrics-Explorer.html) documentation to learn how you can create charts and queries.

### Import a pre-built dashboard

To help you quickly visualize important metrics and logs from your NGINXaaS deployments, you can import a pre-configured dashboard into Amazon CloudWatch. The dashboard displays key metrics such as request and connection rates, response status codes, upstream health, and access and error logs.

To import the dashboard:

1. Copy the dashboard JSON configuration {{< details summary="Show dashboard JSON" >}}

```json
{
  "variables": [
    {
      "type": "property",
      "property": "DeploymentName",
      "inputType": "select",
      "id": "DeploymentName",
      "label": "NGINXaaS Deployment",
      "visible": true
    }
  ],
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 14,
      "height": 8,
      "properties": {
        "title": "Request + Connection rates",
        "view": "timeSeries",
        "region": "us-east-1",
        "period": 60,
        "metrics": [
          [ "NGINXaaS", "nginx.http.connections", "DeploymentName", "${DeploymentName}", "ConnectionOutcome", "ACCEPTED", { "id": "m1", "visible": false, "stat": "Sum" } ],
          [ { "expression": "RATE(m1)", "label": "Connections/second", "id": "e1", "yAxis": "right" } ],
          [ "NGINXaaS", "nginx.http.requests", "DeploymentName", "${DeploymentName}", { "id": "m2", "visible": false, "stat": "Sum" } ],
          [ { "expression": "RATE(m2)", "label": "Requests/second", "id": "e2", "yAxis": "left" } ]
        ],
        "yAxis": {
          "left": { "label": "Req/s" },
          "right": { "label": "Conn/s" }
        }
      }
    },
    {
      "type": "metric",
      "x": 14,
      "y": 0,
      "width": 10,
      "height": 8,
      "properties": {
        "title": "Current Connections",
        "view": "singleValue",
        "sparkline": true,
        "region": "us-east-1",
        "period": 60,
        "stat": "Average",
        "metrics": [
          [ "NGINXaaS", "nginx.http.connection.count", "DeploymentName", "${DeploymentName}" ]
        ]
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 8,
      "width": 14,
      "height": 7,
      "properties": {
        "title": "Response rate by Zone + Status",
        "view": "timeSeries",
        "region": "us-east-1",
        "metrics": [
          [ { "expression": "SELECT RATE(SUM(nginx_http_response_status)) FROM SCHEMA(\"NGINXaaS\", DeploymentName,ZoneName,StatusRange) WHERE DeploymentName = '${DeploymentName}' GROUP BY ZoneName, StatusRange", "id": "q1", "period": 60 } ]
        ]
      }
    },
    {
      "type": "metric",
      "x": 14,
      "y": 8,
      "width": 5,
      "height": 4,
      "properties": {
        "title": "Current Requests",
        "view": "singleValue",
        "sparkline": true,
        "region": "us-east-1",
        "period": 60,
        "stat": "Sum",
        "metrics": [
          [ "NGINXaaS", "nginx.http.request.processing.count", "DeploymentName", "${DeploymentName}", { "stat": "Sum" } ]
        ]
      }
    },
    {
      "type": "metric",
      "x": 19,
      "y": 8,
      "width": 5,
      "height": 4,
      "properties": {
        "title": "Config updates",
        "view": "singleValue",
        "sparkline": true,
        "region": "us-east-1",
        "period": 60,
        "stat": "Sum",
        "metrics": [
          [ "NGINXaaS", "nginx.config.reloads", "DeploymentName", "${DeploymentName}", { "stat": "Sum" } ]
        ]
      }
    },
    {
      "type": "metric",
      "x": 14,
      "y": 12,
      "width": 10,
      "height": 7,
      "properties": {
        "title": "Upstream Status",
        "view": "timeSeries",
        "stacked": true,
        "region": "us-east-1",
        "metrics": [
          [ { "expression": "SELECT AVG(nginx_http_upstream_peer_count) FROM SCHEMA(\"NGINXaaS\", DeploymentName,PeerState) WHERE DeploymentName = '${DeploymentName}' GROUP BY PeerState", "id": "q2", "period": 60 } ]
        ]
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 15,
      "width": 14,
      "height": 7,
      "properties": {
        "title": "Upstream Response rate by Zone + Status",
        "view": "timeSeries",
        "region": "us-east-1",
        "metrics": [
          [ { "expression": "SELECT RATE(SUM(nginx_http_upstream_peer_responses)) FROM SCHEMA(\"NGINXaaS\", DeploymentName,ZoneName,StatusRange) WHERE DeploymentName = '${DeploymentName}' GROUP BY ZoneName, StatusRange", "id": "q3", "period": 60 } ]
        ]
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 22,
      "width": 24,
      "height": 8,
      "properties": {
        "title": "Error Logs",
        "region": "us-east-1",
        "view": "table",
        "logGroupNames": [ "/nginxaas/aws/${DeploymentName}/error" ],
        "query": "fields @timestamp, @message | filter filename = \"error.log\" | sort @timestamp desc | limit 100"
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 30,
      "width": 24,
      "height": 8,
      "properties": {
        "title": "Access Logs",
        "region": "us-east-1",
        "view": "table",
        "logGroupNames": [ "/nginxaas/aws/${DeploymentName}/access" ],
        "query": "fields @timestamp, @message | filter filename = \"access.log\" | sort @timestamp desc | limit 100"
      }
    }
  ]
}
```

{{< /details >}}

2. Go to the [AWS Management Console](https://console.aws.amazon.com/).
3. Go to the **CloudWatch** console.
4. Select **Dashboards** and select **Create dashboard**.
5. Enter a name for the dashboard and select **Create dashboard**. When prompted to add a widget, select **Cancel** to start with an empty dashboard.
6. Select **Actions**, and select **View/edit source** to switch to the JSON source editor.
7. Replace the default JSON with the dashboard configuration you copied and select **Update**.
8. Select **Save dashboard**.

{{< call-out class="note" >}}The dashboard includes a **DeploymentName** variable. Use this variable to view metrics for a specific NGINXaaS deployment or select multiple deployments to compare their performance.{{< /call-out >}}

## Disable exporting NGINXaaS metrics to a CloudWatch namespace

To disable sending metrics to your CloudWatch namespace, update your NGINXaaS deployment to remove the reference to your namespace. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Remove the namespace under **CloudWatch Namespace**.
1. Select **Update**.

## Troubleshooting

If Amazon CloudWatch is not showing any metrics, check for **Failed Metric Export to CloudWatch** events from your NGINXaaS deployment.

In the NGINXaaS console:

1. On the navigation menu, select **Events**.
1. Select **Add Filter**.
1. Select **Affected Object** and the name of your NGINXaaS deployment.

Events are deleted after 14 days.
