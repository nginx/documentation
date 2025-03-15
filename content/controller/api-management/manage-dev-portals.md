---
description: Learn how to create and manage Developer Portals for your API documentation.
docs: DOCS-570
title: Manage Developer Portals
toc: true
weight: 120
type:
- tutorial
---

## Overview

You can use F5 NGINX Controller Developer Portals (also called 'Dev Portals') to create and manage beautiful, easy-to-use API reference documentation to support your [Published APIs]({{< relref "/controller/api-management/manage-apis.md#publish-an-api" >}}).

## About Developer Portals

In NGINX Controller, each Dev Portal sits within an Environment. An Environment can contain multiple Dev Portals. You can use the same Dev Portal names across different Environments, which means you can create "test", "dev", and "production" versions of your Dev Portal across the corresponding Environments.

Each Dev Portal is associated with a Gateway, which defines the URI at which users can access the Dev Portal -- for example, `developer.acme.com`. A Gateway for a Developer Portal can be placed on a dedicated Instance, or share an Instance with other Gateway resources.

## Before You Begin

You must complete the steps below before you can create a Developer Portal.

1. [Create an Environment]({{< relref "/controller/services/manage-environments.md" >}}).
1. [Create a Gateway]({{< relref "/controller/services/manage-gateways.md" >}}) for the Dev Portal.

    {{< tip >}}
You can create multiple Dev Portal Gateways on the same Instance. If you do so, be sure to use a unique hostname and port for each. For example:

- Gateway 1's ingress URI is `https://dev-developer.acme.com`.
- Gateway 2's ingress URI is `https://test-developer.acme.com`. These resources might both have IP addresses and ports that are accessible only from within your private network.
- Gateway 3's ingress URI is `https://developer.acme.com`. This resource would have a public IP address and be accessible via the internet.

If you create multiple Dev Portal Gateways on the same Instance using the same hostname and port, the Dev Portal configuration will fail.
    {{< /tip >}}

1. [Create an API Definition]({{< relref "/controller/api-management/manage-apis.md#create-an-api-definition" >}}).

    {{< tip >}}
If you choose to [define your API manually]({{< relref "/controller/api-management/manage-apis.md#define-resources-manually" >}}), be sure to [document your API]({{< relref "/controller/api-management/manage-apis.md#document-your-api" >}}).
    {{< /tip >}}

1. [Create a Published API]({{< relref "/controller/api-management/manage-apis.md#publish-an-api" >}}).

    {{< important >}}
You must create an App Component when creating a Published API. You'll [assign routes]({{< relref "/controller/api-management/manage-apis.md#define-the-routing-rules" >}}) from the API Definition to this Component.

Both the Published API and the associated App Component must be successfully created before you can create a Dev Portal.

See [Manage Your APIs]({{< relref "/controller/api-management/manage-apis.md" >}}) and the [troubleshooting](#troubleshoot-dev-portal-publication) section below for more information.

You also have the option to associate Dev Portal(s) in the *Deployment* page when you [Add a Published API]({{< relref "/controller/api-management/manage-apis.md#add-a-published-api" >}}). If you already have a Published API and you want to create a new Dev Portal to host it, complete the tasks described in this guide.

    {{< /important >}}

## Create a Developer Portal

To create a Dev Portal, take the steps below:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select Services.
3. On the **Services** menu, select APIs.
4. On the APIs page, select **Create Dev Portal** from the Quick Actions menu.

    {{< tip >}}
If you want to connect one or more Dev Portals to an existing Published API, you should select the **Edit Published API** option. The API Documentation will be published to the selected Dev Portal(s). Refer to the [Define the Published API Deployment]({{< relref "/controller/api-management/manage-apis.md#define-the-published-api-deployment" >}}) section for more information and instructions.
    {{< /tip >}}

### Configure the Developer Portal

On the **Create Dev Portal** *Configuration* page:

1. Provide a resource name for the Dev Portal.
2. (Optional) Provide a display name, description, and tags.
3. Select the desired Environment, or select Create to create a new resource.
4. Select a Gateway, or select Create to create a new resource.
5. Select the Published API(s) that you want to host in the Dev Portal.
6. Select **Next** to move to the **Themes** page.

### Define the Dev Portal Theme

On the **Create Dev Portal** *Themes* page:

1. Select **Brand** to define the following elements:

    - **Brand Name**,
    - **Logo**, and
    - **Favicon**

2. Select **Next**.
3. Set the **Colors** for theme elements. Then, select **Next**.
4. Set the **Fonts** for the theme. Then, select **Next**.
5. Review the **API Spec**, then select **Submit**.

> You should now be able to access the Dev Portal via the hostname and port that you assigned to the Dev Portal Gateway.

## View, Edit, or Delete a Developer Portal

To view, edit, or delete a Dev Portal, take the steps below:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select Services.
3. On the **Services** menu, select APIs.
4. On the APIs menu, select **Dev Portals**.

To **edit** a Dev Portal:

1. Select the **Edit** icon for the Dev Portal.
2. Edit the Dev Portal as desired.

   - Select **Configure** to update the Dev Portal configurations, including the Environment, Gateway, and Published API.
   - Select **Brand** to customize the **Brand Name** and to upload a **Logo** and **Favicon**.
   - Select **Color** to customize the Dev Portal theme colors.
   - Select **Fonts** to customize the Dev Portal theme fonts.

3. Select **Submit** to save your changes.

To **delete** a Dev Portal, select the **Delete** icon. Then, select **Delete** in the confirmation prompt window.

## Troubleshoot Dev Portal Publication

If the Gateway that the Dev Portal is associated with is in an error state, publishing your Dev Portal will fail. You won't necessarily see an error in the Dev Portals section of the user interface when this happens, but configuration errors in these resources will impact Dev Portal functionality.

- App Component configuration errors are displayed only in the App Component section of the user interface.
- Published API configuration errors are displayed in the Published APIs section of the user interface, as well as in the Dev Portal.
- Dev Portal configuration errors are not displayed in the NGINX Controller user interface.

If your Dev Portal failed to publish, check the status of the Gateway first; resolve any issues with the Gateway, then try publishing the Dev Portal again.
If the issue persists, check the other resources for configuration errors.

## What's Next

- [Learn about Policies]({{< relref "available-policies.md" >}})
- [Manage Your APIs]({{< relref "manage-apis.md" >}})

{{< versions "3.7" "3.18" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
