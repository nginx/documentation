---
title: Enable NGINX logs
weight: 350
toc: true
f5-docs: DOCS-000
url: /nginxaas/google/monitoring/enable-nginx-logs/
f5-content-type: how-to
f5-product: F5 Application Delivery Service for Google Cloud
---

F5 Application Delivery Service for Google Cloud (ADS) supports integrating with Google Cloud services to collect NGINX error and access logs, and F5 WAF for NGINX security logs.

## Prerequisites

- Enable the [Cloud Logging API](https://docs.cloud.google.com/logging/docs/api/enable-api).
- Configure Workload Identity Federation (WIF). See [our documentation on setting up WIF]({{< ref "/nginxaas/google/deploy/access-management.md#configure-wif" >}}) for exact steps.
- Grant a project-level role or grant your principal access to the `roles/logging.viewer` role. See [Google's documentation on controlling access to Cloud Logging with IAM](https://cloud.google.com/logging/docs/access-control).

## Setting up error logs

{{< include "/nginxaas/logging-config-error-logs.md" >}}

## Setting up access logs

{{< include "/nginxaas/logging-config-access-logs.md" >}}

## Setting up F5 WAF for NGINX security logs

{{< include "/nginxaas/logging-config-security-logs.md" >}}

## Export NGINX logs to a Google Cloud Project

To enable sending logs to your desired Google Cloud project, you must specify the project ID when creating or updating a deployment. To create a deployment, see [our documentation on creating an F5 ADS deployment]({{< ref "/nginxaas/google/deploy/create-deployment/" >}}) for a step-by-step guide. To update the deployment, in the F5 ADS console,

1. On the left menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter the project you want metrics to be sent to under **Log Project ID**.
1. Select **Update**.

## View NGINX logs in Google Cloud Logging

In the [Google Cloud Console](https://console.cloud.google.com/),

1. Go to your log project.
2. Search for "Logs Explorer".

Refer to the [Google's Logs Explorer](https://cloud.google.com/logging/docs/view/logs-explorer-interface) documentation to learn how you can create queries.

NGINX access and error logs sent to Cloud Logging will have the log name `nginx-logs` which can be used to filter NGINX logs from the rest of your project logs. You can also filter based on log labels, for example,

* `filename`
* `organization_object_id`
* `deployment_location`
* `deployment_name`
* `deployment_object_id`
* `namespace`

## Disable Exporting NGINX logs to a Google Cloud Project

To disable sending logs to your Google Cloud project, update your F5 ADS deployment to remove the reference to your project ID. To update the deployment, in the F5 ADS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Remove the project ID under **Log Project ID**.
1. Select **Update**.

## Troubleshooting

If Google Cloud Logging is not showing any logs, check for **Failed Log Export to Google** events from your F5 ADS deployment.

In the F5 ADS console:

1. On the navigation menu, select **Events**.
1. Select **Add Filter**.
1. Select **Affected Object** and the name of your F5 ADS deployment.

Events are deleted after 14 days.
