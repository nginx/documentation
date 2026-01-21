---
title: Identity and access management
weight: 600
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/access-management/
nd-content-type: how-to
nd-product: NGOOGL
---



F5 NGINXaaS for Google Cloud (NGINXaaS) uses Workload Identity Federation (WIF) to integrate with Google Cloud services. For example, with WIF configured, your NGINXaaS deployment can perform the following integrations:

 - export logs to Cloud Logging
 - export metrics to Cloud Monitoring
 - fetch secrets from Secret Manager

To learn more, see [Google's Workload Identity Federation documentation](https://cloud.google.com/iam/docs/workload-identity-federation).

## Prerequisites

- In the project you're configuring WIF in, you need the following roles to create a workload identity pool, provider, and policy bindings:
    - [iam.workloadIdentityPoolAdmin](https://cloud.google.com/iam/docs/roles-permissions/iam#iam.workloadIdentityPoolAdmin)
    - [resourcemanager.projectIamAdmin](https://cloud.google.com/iam/docs/roles-permissions/resourcemanager#resourcemanager.projectIamAdmin)
- An NGINXaaS deployment. See [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/" >}}) for a step-by-step guide.

## Configure WIF

### Create a Workload Identity Pool and Provider

1. Create a workload identity pool. See [Google's documentation on configuring Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-providers#create-pool-provider) for a step-by-step guide.
1. Create an OIDC workload identity pool provider. See [Google's documentation on creating a workload identity pool provider](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-providers#create-pool-provider) for a step-by-step guide. Set up the provider settings as follows:
    - `Issuer URL` must be `https://accounts.google.com`.
    - `Allowed audiences` must contain the full canonical resource name of the workload identity pool provider, for example, `https://iam.googleapis.com/projects/<project-number>/locations/<location>/workloadIdentityPools/<pool-id>/providers/<provider-id>`. If `Allowed audiences` is empty, the full canonical resource name of the workload identity pool provider will be included by default.
    - Add the following **attribute mapping**: `google.subject=assertion.sub`.
    - Add the following **attribute condition**: `assertion.sub=='$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID'`, where `$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID` is the unique ID of your NGINXaaS deployment's service account. This ID can be found in the `F5 NGINXaaS Service Account Unique ID` field under the **Cloud Info** section in the **Details** tab of your deployment.

### Grant access to the WIF principal with your desired roles

Depending on your use case, you will need to grant certain roles on specific resources. See [Google's documentation on granting access](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-providers#access) for more information.

{{< details summary="Grant access to export logs to a Google project">}}

To grant access to export logs to a Google project, `$LOG_PROJECT_ID`, in the [Google Cloud Console](https://console.cloud.google.com/),

1. Go to the `$LOG_PROJECT_ID` project.
1. Go to the **IAM** page.
1. Select **Grant Access**.
1. Enter your principal, for example, `principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID`.
1. Assign the **Logs Writer** role.

Alternatively, to use the Google Cloud CLI, you can run the following `gcloud` command:

```bash
gcloud projects add-iam-policy-binding "$LOG_PROJECT_ID" \
    --member="principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID" \
    --role='roles/logging.logWriter'
```

{{< /details >}}

{{< details summary="Grant access to export metrics to a Google project">}}

To grant access to export metrics to a Google project, `$METRIC_PROJECT_ID` in the [Google Cloud Console](https://console.cloud.google.com/), perform the following steps.

1. Go to the `$METRIC_PROJECT_ID` project.
1. Go to the **IAM** page.
1. Select **Grant Access**.
1. Enter your principal, for example, `principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID`.
1. Assign the **Monitoring Metric Writer** role.

Alternatively, to use the Google Cloud CLI, you can run the following `gcloud` command:

```bash
gcloud projects add-iam-policy-binding "$METRIC_PROJECT_ID" \
    --member="principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID" \
    --role='roles/monitoring.metricWriter'
```

{{< /details >}}

{{< details summary="Grant access to fetch a secret from Secret Manager">}}

To grant access to fetch a secret, `$SECRET_ID`, in the [Google Cloud Console](https://console.cloud.google.com/),

1. Go to the secret, `$SECRET_ID`, in Secret Manager.
1. Select the **Permissions** tab.
1. Select **Grant Access**.
1. Enter your principal, for example, `principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID`.
1. Assign the **Secret Manager Secret Accessor** role.

Alternatively, to use the Google Cloud CLI, you can run the following `gcloud` command:

```bash
gcloud secrets add-iam-policy-binding "$SECRET_ID" \
    --member="principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID" \
    --role='roles/secretmanager.secretAccessor'
```

If you would like to fetch more than one secret, you will need to grant access on each secret or grant access on the project your secrets are in.

{{< /details >}}

### Update your NGINXaaS deployment with the name of your workload identity pool provider

In the NGINXaaS Console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter your provider name, for example, `projects/<project-number>/locations/<location>/workloadIdentityPools/<pool-id>/providers/<provider-id>`, under **Workload Identity Pool Provider Name**.
1. Select **Update**.

## What's next

- [Monitor your deployment]({{< ref "/nginxaas-google/monitoring/enable-monitoring.md" >}})
- [Enable NGINX Logs]({{< ref "/nginxaas-google/monitoring/enable-nginx-logs.md" >}})
