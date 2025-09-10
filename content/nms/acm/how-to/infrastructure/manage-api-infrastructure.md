---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  manage your API infrastructure.
nd-docs: DOCS-924
title: Manage API Infrastructure
toc: true
weight: 100
type:
- how-to
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

API Connectivity Manager lets you manage your API infrastructure by using a set of hierarchical resources. The top-level resource, called a **Workspace**, provides a logical grouping for resources called **Environments**. Environments contain **Clusters** that allocate NGINX instances for use as API Gateways and Developer Portals.

You can use Workspaces to create isolated work areas for business units or teams. You can use Environments to allocate infrastructure resources for use within a team's Workspace.

This guide provides instructions for using  API Connectivity Manager Workspaces and Environments to manage your API infrastructure.

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, running, and licensed.
- You have SSH access to the host where API Connectivity Manager is running and can use the `sudo` command.
- You have installed a [supported version]({{< ref "/nim/fundamentals/tech-specs.md" >}}) of F5 NGINX Plus on each host that you want to add to a Cluster.
- You know the IP address or FQDN for each host that you want to add to a cluster.
- You have SSH access to each of the hosts that you want to allocate to a cluster and can use the `sudo` command.
- You have installed the [`njs`](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) module on each host that you want to add to the cluster.

## How to Access the User Interface

{{< include "acm/how-to/access-acm-ui.md" >}}

## Create a Workspace {#create-workspace}

{{<tabs name="Add a Services Workspace">}}

{{%tab name="UI"%}}

Take the steps below to create a new Workspace.

1. From the API Connectivity Manager **Infrastructure** landing page, select **Create Workspace**.
1. In the **Create Workspace** drawer, provide a **Name** and **Description**.

   - **Name**: (required) A name can be any combination of lowercase letters, hyphens, numbers, or underscores. Spaces and capital letters are not allowed.
   - **Description**: (optional; 150-character limit) The description should help others in your organization understand the nature or purpose of the Workspace.

1. (Optional) Select the **Contact Information** box to designate someone as the Workspace's owner. Then, provide the following information:

    - **Contact Name**
    - **Contact Email**
    - **Slack**: The contact's Slack handle

1. Select **Create** to save your changes.

The **Create Workspace** drawer will display a confirmation when the Workspace has been created. From there, you can go on to [Add an Environment](#Add-an-environment) or go back to the Workspaces landing page.

{{%/tab%}}
{{%tab name="API"%}}



{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces`|

{{</bootstrap-table>}}


```json
{
    "name":  "{{infraWorkspaceName}}",
    "metadata": {
        "description": "Petstore Team Workspace"
    },
    "contactDetails": {
        "adminEmail": "admin@example.com",
        "adminName": "I.M. Admin",
        "adminPhone": "555 123 1234"
    }
}
```

{{%/tab%}}
{{</tabs>}}
## Add an Environment {#add-environment}
{{<tabs name="Add an Environment">}}

{{%tab name="UI"%}}

After creating a Workspace, you must create at least one Environment. When creating an Environment, you will also create the Clusters where your API Gateway(s) and/or Developer Portal(s) will reside.

{{< call-out "caution"  >}}

- Do not add the same host to both an API Gateway cluster and a Developer Portal cluster.
- The Developer Portal cluster requires at least one dedicated host.
{{< /call-out >}}

Take the steps below to add an Environment.

1. On the **Workspaces** landing page, select the ellipsis (`...`) icon for your desired Workspace.
1. Select **Add Environment**.
1. In the **Add Environment** drawer, provide the requested information:
    - **Name** (required)
    - **Description** (optional)
    - **Type**: **Production** (**prod**) or **Non-Production** (**non-prod**)
1. In the **API Gateways** section, provide the **Name** and **Hostname** of at least one instance that you want to add to the cluster.

   This instance, or instance group, will host the API Gateway.
1. (Optional) In the **Developer Portals** section, provide the **Name** and **Hostname** of at least one instance that you want to add to the cluster.

   This instance, or instance group, will host the Developer Portal.

   {{< call-out "note" >}}The Dev Portal requires a separate, dedicated host. Do not install the Dev Portal on a host that is already running the management or data planes.{{< /call-out >}}
1. Select the **Create** button to create the Environment. The **Add Environment** drawer will display a confirmation when the Environment has been created.
1. Copy the `cURL` or `wget` command shown in the confirmation drawer and save it -- you will need to use this information to [add your NGINX instances to the cluster](#register-nginx-instance).

{{%/tab%}}
{{%tab name="API"%}}
{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

| Parameter | Description |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `proxies.proxyClusterName`                     | The group of NGINX instances where configuration will be written     |
| `proxies.hostnames`                     | An IP Address or fully qualified domain name (FQDN) used to identify the API-Gateway environment|

{{</bootstrap-table>}}



{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces/{{infraWorkspaceName}}/environments`|

{{</bootstrap-table>}}


```json
{
    "name": "{{environmentname}}",
    "proxies": [
        {
            "proxyClusterName": "{{proxyClusterName}}",
            "hostnames": [
                "{{environmentHostname}}"
            ]
        }
    ]
}
```

{{%/tab%}}
{{</tabs>}}
## Onboard an NGINX Instance {#register-nginx-instance}

[Install the NGINX Agent]({{< ref "/nms/nginx-agent/install-nginx-agent" >}}) on each host to register the instance with API Connectivity Manager as part of the cluster.

Take the steps below to add an NGINX instance to an API Gateway.

1. Use SSH to log in to the host machine.
1. Run the `cURL` or `wget` install command that was displayed in the **Environment Created** confirmation drawer.
1. When the installation is complete, the instance will appear in the **Instances** list for the cluster in the API Connectivity Manager user interface.
1. After running the `cURL` command you can check the environment job status on the environments page
{{<img src="/acm/acm-onboarding-success.png" alt="Environment Onboarding Status." >}}


## Environment Statuses
{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}


| Status | Description |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Configuring`                     | ACM have received the changes and will attempt to deploy to the instance group |
| `Pending`                     | Check that instance group contains instances, see Instance Groups Overview page |
| `Fail`                     | Deploying configurations have failed, review the Events page for more details |
| `Success`                     | Changes have been successfully deployed to the instance group  |

{{</bootstrap-table>}}

> {{< icon "fa-solid fa-circle-question" >}} **Lost your install command?**
>
> Don't worry! You can take the steps below to recover it:
>
> 1. In the API Connectivity Manager user interface, go to **Infrastructure > Environments > \<your environment\>**.
> 1. Click anywhere in the row of the Cluster that you want to add an instance to.
> 1. The **Onboarding Commands** will be shown in the cluster details drawer.
