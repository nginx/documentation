---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  publish APIs to your API Gateway.
docs: DOCS-927
title: Publish an HTTP API
toc: true
weight: 100
type:
- how-to
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

API Connectivity Manager lets you manage your API infrastructure by using a set of hierarchical resources. The top-level resource, called a **Workspace**, provides a logical grouping for resources called **Environments**. Environments contain **Clusters** that assign NGINX instances for use as API Gateways and Developer Portals.

This topic describes how to publish an API config to a cluster.

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with [API Gateway]({{<relref "/nms/acm/getting-started/add-api-gateway" >}}) or [Dev Portal]({{< relref "/nms/acm/getting-started/add-devportal" >}}) clusters.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

## Create a Service Workspace

{{<note>}}
The API Connectivity Manager admin must verify that the user (API Onwer) has CRUD [RBAC](https://en.wikipedia.org/wiki/Role-based_access_control) permissions for the services feature.
{{</note>}}

Service Workspaces let you group API configurations. Publishing an API requires at least one Service Workspace.

To create a Service Workspace you need to do the following:

1. On the sidebar, select **Services**. If this is your first time on the page, you'll see a prompt for creating a new workspace. If not, select the **+Add** button in the top-right corner.
2. Enter a name, description, and any other information you want to provide.
3. Select **Create**.

## Next Steps

After creating a Service Workspace, two options are displayed:

**Publish API Proxy** and **Publish API Doc**

## Publish an API Proxy {#publish-api-proxy}

1. Enter the required information in the fields provided.
2. **Service Target Hostname** should point to the backend service you want this API to resolve to.
3. If you choose not to use an OpenAPI spec then you need to add some extra information.
4. For **Gateway Proxy Hostname**, select the hostname of the environment you want to associate with the API.
5. **Base Path** and **Version** build up the URI, for example **/api/v1/**.
6. Select **Publish** to save and publish your API Proxy.

{{<note>}}
If you choose to use an OpenAPI spec, it will get processed into a config and published.
{{</note>}}

## Advanced Configurations {#advanced-configurations}

After publishing the API Proxy, a link to **Edit Advanced Configurations** is displayed.
If you want to create more advanced routing configurations, select this option.
You can upload an OpenAPI spec here too, which has all the necessary API and routing information.

{{< include "acm/openapi-support" >}}

To add an Advanced Routing configuration, select the **Ingress** menu item in the advanced section of the menu.

1. Select **Add Route** in the **Advanced Routes** section.
2. Fill out the required information in the form presented to you.
3. **Match URI** is the value you want to match on for queries.
4. Choose the required **HTTP Method** you want to use for this route match.
5. Change the **Target Backend Service Label** if required to target a specific backend based on the label value.
6. Select **Add Parameter** to add a parameter to the Path, Query, or Header that's used to match on the route.
   {{<note>}}If you choose a path parameter then you must have a placeholder for that parameter in **Match URI**.{{</note>}}
7. Select **Add** to finish adding the route.
8. Select **Next** to move to the **Backend** configuration page.

### Backends

Backends tell your API where to resolve the queries to, for example your backend server.

You can add, edit, or delete Backends.

You can also set [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) resolvers and [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) on the backend.

### Policies

This section ensures you can set policies at the individual API level.

Check the [Manage Policies]({{< relref "/nms/acm/how-to/policies/manage-policies.md" >}}) documentation for more information.

## Publish an API Proxy using an OpenAPI Spec

In the [**Publish an API Proxy**](#publish-api-proxy) form, select the option to use an OpenAPI spec and choose one from the list of existing specs.

You may also upload a new OpenAPI spec in this form by selecting **+Add API Spec** and uploading the new spec in the file input.

{{< include "acm/openapi-support" >}}

## Update a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the workspace containing the API proxy you want to edit.
2. Select **Edit Proxy** from the **Actions** menu of the Proxy you want to delete.
3. Edit as needed.
4. Select **Save and Publish**.

{{<note>}}
Certain sections can't be modified for API Proxies created with OpenAPI Specs, for example, **Advanced Routing** in the **Ingress** step.
{{</note>}}

## Delete a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the name of the workspace containing the API proxy you want to delete.
2. Select **Delete Proxy** from the **Actions** menu of the Proxy you want to delete.

## What's Next

- [Manage Policies]({{< relref "/nms/acm/how-to/policies/manage-policies.md" >}})
- [Publish a Developer Portal]({{< relref "/nms/acm/getting-started/add-devportal.md" >}})
