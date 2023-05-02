---
title: "Publish a gRPC API"
date: 2022-11-27T14:01:32+01:00
draft: false
description: "Learn how to use NGINX Management Suite API Connectivity Manager to publish gRPC APIs to your gRPC API Gateway."
weight: 200
toc: true
tags: ["docs"]
docs: "DOCS-1079"
categories: ["API Connectivity Manager", "api management"]
doctypes: ["task"]
---

{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Overview

NGINX Management Suite API Connectivity Manager (ACM) lets you manage your API infrastructure by using a set of hierarchical resources. The top-level resource, called a **Workspace**, provides a logical grouping for resources called **Environments**. Environments contain **Clusters** that assign NGINX instances for use as API Gateways and Developer Portals.

This topic describes how to publish an API config to a cluster.

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with [API Gateway]({{<relref "/acm/getting-started/publish-grpc-proxy" >}}) or [Dev Portal]({{< relref "/acm/getting-started/add-devportal" >}}) clusters.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

## Create a Service Workspace

{{<note>}}
The ACM admin must to verify that the user (API Owner) has [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) [RBAC](https://en.wikipedia.org/wiki/Role-based_access_control) permissions for the services feature.
{{</note>}}

Service Workspaces let you group API configurations. Publishing an API requires at least one Service Workspace.

To create a Service Workspace you need to do the following:

1. On the sidebar, select **Services**. If this is your first time on the page, you'll see a prompt for creating a new workspace. If not, select the **+Add** button in the top-right corner.
2. Enter a name, description, and any other information you want to provide.
3. Select **Create**.

## Next Steps

After creating a Service Workspace, two options are displayed:

**Publish an API Proxy** and **Publish API Doc**

## Publish an API Proxy {#publish-api-proxy}

1. Enter the required information in the fields provided.
2. **Service Target Hostname** should point to the backend service you want this API to resolve to.
3. Select **Service Target Transport Protocol** as gRPC and enter the desired **Service Target Port**.
3. For **Gateway Proxy Hostname**, select the hostname of the environment you want to associate with the API.
4. Specify **GRPC Package Name** or **Service Name**. For example: routeguide, routeguide. or routeguide.RouteGuide 
5. Provide a **Version**.
5. Select **Publish** to save and publish your API Proxy.

## Advanced Configurations {#advanced-configurations}

After publishing the API Proxy, a link to **Edit Advanced Configurations** is displayed.
If you want to create more advanced routing configurations like a route to individual gRPC methods, select this option.

To add an Advanced Routing configuration, select the **Ingress** menu item in the advanced section of the menu.

1. Select **Add Route** in the **Advanced Routes** section.
2. Fill out the required information in the form presented to you.
{{<note>}} Route by method is allowed if the **Service Name** field is set properly. For example: routeguide.RouteGuide {{</note>}}
3. Change the **Target Backend Service Label** if required to target a specific backend based on the label value.
7. Select **Add** to finish adding the route.
8. Select **Next** to move to the **Backend** configuration page.

### Backends

Backends tell your API where to resolve the queries to, for example your backend server.

You can add, edit, or delete Backends.

You can also set [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) resolvers and [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) on the backend.

### Policies

This section ensures you can set policies at the individual API level.

Check the [Manage Policies]({{< relref "/acm/how-to/policies/manage-policies.md" >}}) documentation for more information.

## Update a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the workspace containing the API proxy you want to edit.
2. Select **Edit Proxy** from the **Actions** menu of the Proxy you want to delete.
3. Edit as needed.
4. Select **Save and Publish**.

## Delete a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the name of the workspace containing the API proxy you want to delete.
2. Select **Delete Proxy** from the **Actions** menu of the Proxy you want to delete.

## What's Next

- [Manage Policies]({{< relref "/acm/how-to/policies/manage-policies.md" >}})
