---
description: Learn how to use the F5 NGINX Management Suite API Connectivity Manager
  web interface to create, update, or delete a Developer Portal.
docs: DOCS-901
title: Publish a Developer Portal
toc: true
weight: 300
type:
- how-to
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

You can use API Connectivity Manager to create and publish Developer Portals (or, "Dev Portals") to host your APIs and documentation. API Connectivity Manager Dev Portals provide a [framework for customization]({{< relref "/nms/acm/how-to/infrastructure/customize-devportal.md" >}})  that lets you match your Dev Portal to your brand's or business' requirements.

You can also modify and delete your Developer Portals using API Connectivity Manager.

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- Your [Infrastructure]({{< relref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md" >}}) has one or more Environments with a [Developer Portal]({{< relref "/nms/acm/getting-started/add-devportal" >}}) cluster.
- You have verified that you can access the Developer Portal using the configured hostname.


### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

## Create a Developer Portal

### Create the Services Workspace

1. Under **Modules**, select **API Connectivity Manager**.
1. On the sidebar, select **Services**.
1. On the **Services - Workspaces** section, select **Create Workspace**.
1. In the **Create Workspace** drawer, provide a **Name** and **Description**.
   - **Name**: (required) A name can be any combination of lowercase letters, hyphens, numbers, or underscores. Spaces and capital letters are not allowed.
   - **Description**: (optional; 150-character limit) The description should help others in your organization understand the nature or purpose of the Workspace.
1. (Optional) Select the **Contact Information** box to designate someone as the Workspace's owner. Then, provide the following information:

    - **Contact Name**
    - **Contact Email**
    - **Slack**: The contact's Slack handle

1. Select **Create** to save your changes.


## Modify Developer Portal Resources

### Edit Workspace Description and Contact Information

1. On the sidebar, select **Services**.
1. Select the ellipsis button next to your workspace on the **Actions** column.
1. Select **Edit Workspace**.
1. Update the **Description** and **Workspace Contact Information** as needed.
1. Select **Save**.

## Delete Developer Portal Resources

### Remove a Developer Portal from an API Proxy

1. On the sidebar, select **Services**.
1. Select your workspace from the list.
1. On the **API Proxies** section, select the ellipsis button next to your API Proxy in the **Actions** column.
1. Select **Edit Proxy**.
1. On the **Basic > Configuration** section, uncheck **Also publish API to developer portal**.
1. Select **Save & Publish**.

### Delete API Docs

1. On the sidebar, select **Services**.
1. Select your workspace from the list.
1. On the **API Docs** section, select the ellipsis button next to your API Doc in the **Actions** column.
1. Select **Delete API Doc**.
1. Select **Delete** to confirm the action.

### Delete Services Workspaces

{{<note>}}To delete a Workspace, you must delete all the API Proxies and API Docs belonging to a Services Workspace.{{</note>}}

1. On the sidebar, select **Services**.
1. Select the ellipsis button next to your workspace in the **Actions** column.
1. Select **Delete workspace**.
1. Select **Delete** to confirm the action.
