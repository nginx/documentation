---
title: Identity and access management
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/access-management/
type:
- how-to
---



F5 NGINXaaS for Google Cloud (NGINXaaS) leverages Workload Identity Federation (WIF) to integrate with Google Cloud services. For example, when WIF is configured, NGINXaaS can export logs and metrics from your deployment to Cloud Monitoring in your chosen Google project. To learn more about WIF on Google Cloud, see [Google's Workload Identity Federation documentation](https://cloud.google.com/iam/docs/workload-identity-federation). 

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
    - Add the following **attribute condition**: `assertion.sub=='$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID'` where `$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID` is your NGINXaaS deployment's service account's unique ID.

### Grant access to the WIF principal with your desired roles

In the [Google Cloud Console](https://console.cloud.google.com/),
1. Select your google project you want to grant access on. For example, to grant access to export logs to a Google project, `$LOG_PROJECT_ID`, or to export metrics to a Google project, `$METRIC_PROJECT_ID`, go to that project.
1. Go to the **IAM** page.
1. Select **Grant Access**.
1. Enter your principal, for example, `principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID`.
1. Assign roles. For example, 
    - To grant access to export logs, add the **Logs Writer** role.
    - To grant access to export metrics, add the **Monitoring Metric Writer** role.

Alternatively, to use the Google Cloud CLI, you can run the following `gcloud` commands.
- To grant access to export logs to a Google project, `$LOG_PROJECT_ID`,
    ```bash
    gcloud projects add-iam-policy-binding "$LOG_PROJECT_ID" \
        --member="principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID" \
        --role='roles/logging.logWriter'
    ```
- To grant access to export metrics to a Google project, `$METRIC_PROJECT_ID`,
    ```bash
    gcloud projects add-iam-policy-binding "$METRIC_PROJECT_ID" \
        --member="principal://iam.googleapis.com/projects/$WIF_PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_ID/subject/$NGINXAAS_SERVICE_ACCOUNT_UNIQUE_ID" \
        --role='roles/monitoring.metricWriter'
    ```

See [Google's documentation on granting access](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-providers#access) for more information.

### Update your NGINXaaS deployment with the name of your workload identity pool provider

In the NGINXaaS Console,
1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter your provider name, for example, `projects/<project-number>/locations/<location>/workloadIdentityPools/<pool-id>/providers/<provider-id>`, under **Workload Identity Pool Provider Name**.
1. Select **Update**.

## What's next

[Add SSL/TLS Certificates]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})
