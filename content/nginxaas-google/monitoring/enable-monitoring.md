---
title: Enable monitoring
weight: 200
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/monitoring/enable-monitoring/
type:
- how-to
---

Monitoring your application's performance is crucial for maintaining its reliability and efficiency. F5 NGINXaaS for Google Cloud (NGINXaaS) seamlessly integrates with Google Cloud services, allowing you to collect, correlate, and analyze metrics for a thorough understanding of your application's health and behavior.


## Prerequisites

- Enable the [Cloud Monitoring API](https://cloud.google.com/monitoring/api/enable-api).
- Configure Workload Identity Federation (WIF). See [our documentation on setting up WIF]({{< ref "/nginxaas-google/monitoring/access-management.md#configure-wif" >}}) for exact steps.
- Grant a project-level role or grant your principal access to the `roles/monitoring.viewer` role. See [Google's documentation on controlling access to Cloud Monitoring with IAM](https://cloud.google.com/monitoring/access-control).

## Export NGINXaaS metrics to a Google Cloud Project

To enable sending metrics to your desired Google Cloud project, you must specify the project ID when creating or updating a deployment. To create a deployment, see [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/" >}}) for a step-by-step guide. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter the project you want metrics to be send to under **Metric Project ID**.
1. Select **Update**.

## View NGINXaaS metrics in Google Cloud Monitoring

See the [Metrics Catalog]({{< ref "/nginxaas-google/monitoring/metrics-catalog.md" >}}) for a full list of metrics NGINXaaS provides.

### Google Cloud Console's Metrics Explorer

Log in to your [Google Cloud Console](https://console.cloud.google.com/),

1. Go to your metric project.
2. Search for "Metrics Explorer".

Refer to the [Google's Metrics Explorer](https://cloud.google.com/monitoring/charts/metrics-explorer) documentation to learn how you can create charts and queries.

### Google Cloud Monitoring API

You can retrieve raw time series metrics from the [Cloud Monitoring API](https://cloud.google.com/monitoring/api/v3).

For example, you can use [`projects.timeSeries.list`](https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list) to list metrics matching filters from a specified time interval. The following `curl` command lists `nginx.http.requests` metrics from the time interval `start_time` to `end_time` in the given `project_id`.

```bash
curl \
  "https://monitoring.googleapis.com/v3/projects/{project_id}/timeSeries?filter=metric.type%3D%22workload.googleapis.com%2Fnginx.http.requests%22&interval.endTime={end_time}&interval.startTime={start_time}" \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --header "Accept: application/json" \
  --compressed
```

See [Google's documentation to authenticate for using REST](https://cloud.google.com/docs/authentication/rest) for more information.

The following JSON shows an example response body:

```json
{
  "timeSeries": [
    {
      "metric": {
        "labels": {
          "nginxaas_deployment_location": "us-east1",
          "nginxaas_deployment_object_id": "depl_AZjtL2OUdCeh-DROeCLp1w",
          "nginxaas_account_id": "account-id",
          "service_name": "unknown_service:naasagent",
          "instrumentation_source": "naasagent",
          "nginxaas_deployment_name": "test-deployment",
          "nginxaas_namespace": "default"
        },
        "type": "workload.googleapis.com/nginx.http.requests"
      },
      "resource": {
        "type": "generic_node",
        "labels": {
          "node_id": "",
          "location": "global",
          "namespace": "",
          "project_id": "{project_id}"
        }
      },
      "metricKind": "CUMULATIVE",
      "valueType": "INT64",
      "points": [
        {
          "interval": {
            "startTime": "{start_time}",
            "endTime": "{end_time}"
          },
          "value": {
            "int64Value": "1405"
          }
        }
      ]
    }
  ],
}
```

{{< call-out "note" >}}Many of NGINX Plus's advanced statistics need to be enabled in the "nginx.conf" file before they will appear in the Metrics Explorer, for example "plus.http.request.bytes_*". Refer to [Gathering Data to Appear in Statistics]({{< ref "/nginx/admin-guide/monitoring/live-activity-monitoring.md#gathering-data-to-appear-in-statistics" >}}) to learn more.{{< /call-out >}}

## Disable exporting NGINXaaS metrics to a Google Cloud project

To disable sending metrics to your Google Cloud project, update your NGINXaaS deployment to remove the reference to your project ID. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Remove the project ID under **Metric Project ID**.
1. Select **Update**.

