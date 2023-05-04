---
date: 2022-07-13T13:11:00-06:00
description: 'Learn how to use NGINX Management Suite API Connectivity Manager to create workspaces and environments for your API infrastructure.'
doctypes:
- task
tags:
- docs
title: Create Workspaces and Envrionments
toc: true
categories: ["api management"]
versions: []
weight: 100
docs: "DOCS-924"
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

NGINX Management Suite API Connectivity Manager (ACM) lets you manage your API infrastructure by using a set of hierarchical resources. The top-level resource, called a **Workspace**, provides a logical grouping for resources called **Environments**. Environments contain **Clusters** that allocate NGINX instances for use as API Gateways and Developer Portals.

You can use Workspaces to create isolated work areas for business units or teams. You can use Environments to allocate infrastructure resources for use within a team's Workspace.   
This guide provides instructions for using  API Connectivity Manager Workspaces and Environments to manage your API infrastructure.

### Before You Begin

Complete the following prerequisites before proceeding with this guide: 

- ACM is installed, running, and licensed.
- You have SSH access to the host where ACM is running and can use the `sudo` command.
- You have installed a [supported version]({{< ref "tech-specs" >}}) of NGINX Plus on each host that you want to add to a Cluster.
- You know the IP address or FQDN for each host that you want to add to a cluster.
- You have SSH access to each of the hosts that you want to allocate to a cluster and can use the `sudo` command.
- You have installed the [`njs`](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) module on each host that you want to add to the cluster.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui.md" >}}

## Create a Workspace {#create-workspace}

Take the steps below to create a new Workspace.

1. From the ACM **Infrastructure** landing page, select **Create Workspace**. 
1. In the **Create Workspace** drawer, provide a **Name** and **Description**.
   
   - **Name**: (required) A name can be any combination of lowercase letters, hyphens, numbers, or underscores. Spaces and capital letters are not allowed.
   - **Description**: (optional; 150-character limit) The description should help others in your organization understand the nature or purpose of the Workspace.

1. (Optional) Select the **Contact Information** box to designate someone as the Workspace's owner. Then, provide the following information:
    
    - **Contact Name**
    - **Contact Email** 
    - **Slack**: The contact's Slack handle

1. Select **Create** to save your changes. 

The **Create Workspace** drawer will display a confirmation when the Workspace has been created. From there, you can go on to [Add an Environment](#Add-an-environment) or go back to the Workspaces landing page.

## Add an Environment {#add-environment}

After creating a Workspace, you must create at least one Environment. When creating an Environment, you will also create the Clusters where your API Gateway(s) and/or Developer Portal(s) will reside. 

{{<caution>}}

- Do not add the same host to both an API Gateway cluster and a Developer Portal cluster.
- The Developer Portal cluster requires at least one dedicated host.
{{</caution>}}

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
   {{<note>}}The Dev Portal requires a separate, dedicated host. Do not install the Dev Portal on a host that is already running the management or data planes.{{</note>}}   
1. Select the **Create** button to create the Environment. The **Add Environment** drawer will display a confirmation when the Environment has been created. 
1. Copy the `cURL` or `wget` command shown in the confirmation drawer and save it -- you will need to use this information to [add your NGINX instances to the cluster](#register-nginx-instance).

## Onboard an NGINX Instance {#register-nginx-instance}

[Install the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent" >}}) on each host to register the instance with ACM as part of the cluster.

Take the steps below to add an NGINX instance to an API Gateway.

1. Use SSH to log in to the host machine.
1. Run the `cURL` or `wget` install command that was displayed in the **Environment Created** confirmation drawer. 
1. When the installation is complete, the instance will appear in the **Instances** list for the cluster in the ACM user interface. 

> {{< fa "fa-solid fa-circle-question" >}} **Lost your install command?**
> 
> Don't worry! You can take the steps below to recover it:
>
> 1. In the ACM user interface, go to **Infrastructure > Environments > \<your environment\>**.
> 1. Click anywhere in the row of the Cluster that you want to add an instance to.
> 1. The **Onboarding Commands** will be shown in the cluster details drawer. 

