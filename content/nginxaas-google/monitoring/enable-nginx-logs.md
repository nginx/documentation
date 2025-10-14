---
title: Enable NGINX logs
weight: 350
toc: true
draft: false
nd-docs: DOCS-000
url: /nginxaas/google/monitoring/enable-nginx-logs/
type:
- how-to
---

F5 NGINXaaS for Google (NGINXaaS) supports integrating with Google Cloud services to collect NGINX error and access logs.

## Prerequisites

- Configure Workload Identity Federation (WIF). See [our documentation on setting up WIF]({{< ref "/nginxaas-google/monitoring/access-management.md#configure-wif" >}}) for exact steps.
- Grant a project-level role or grant your principal access to the `roles/logging.viewer` role. See [Google's documentation on controlling access to Cloud Logging with IAM](https://cloud.google.com/logging/docs/access-control).

## Setting up error logs

{{< include "/nginxaas-google/logging-config-error-logs.md" >}}

## Setting up access logs

{{< include "/nginxaas-google/logging-config-access-logs.md" >}}


## Export NGINX logs to a Google Cloud Project

To enable sending logs to your desired Google Cloud project, you must specify the project ID when creating or updating a deployment. To create a deployment, see [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/" >}}) for a step-by-step guide. To update the deployment, in the NGINXaaS console,

1. On the left menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter the project you want metrics to be send to under **Log Project ID**.
1. Select **Update**.

## View NGINX logs in Google Cloud Logging

In the [Google Cloud Console](https://console.cloud.google.com/),

1. Go to your log project.
2. Search for "Logs Explorer".

Refer to the [Google's Logs Explorer](https://cloud.google.com/logging/docs/view/logs-explorer-interface) documentation to learn how you can create queries.


NGINX access and error logs sent to Cloud Logging will have the log name `nginx-logs` which can be used to filter NGINX logs from the rest of your project logs. You can also filter based on log labels, for example,

* `filename`
* `nginxaas_account_id`
* `nginxaas_deployment_location`
* `nginxaas_deployment_name`
* `nginxaas_deployment_object_id`
* `nginxaas_namespace`

## Disable Exporting NGINX logs to a Google Cloud Project

To disable sending logs to your Google Cloud project, update your NGINXaaS deployment to remove the reference to your project ID. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Remove the project ID under **Log Project ID**.
1. Select **Update**.

