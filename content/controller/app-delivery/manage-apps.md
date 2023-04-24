---
authors: []
categories:
- services
- app management
date: "2020-10-26T15:32:41-06:00"
description: Create, view, and edit Apps and Components.
docs: DOCS-478
doctypes:
- task
draft: false
journeys:
- using
personas:
- devops
roles:
- admin
tags:
- docs
title: Manage Apps & Components
toc: true
weight: 300
---

## Overview

Follow the steps in this topic to learn how to create and manage Apps and App Components.

{{< tip >}}You can also use the NGINX Controller API to create Apps and Components. See the [NGINX Controller API Reference]({{< relref "api/_index.md" >}}) for details.{{< /tip >}}
&nbsp;

## Before You Begin

You will need to select an [Environment]({{< relref "/services/manage-environments.md#create-an-environment" >}}) and [Gateway]({{< relref "/services/manage-gateways.md#create-a-gateway" >}}) -- or create new Environment and Gateway resources -- when adding a new App.

{{< note >}}If you do not have permission to create these resources and none are available to select, contact your system administrator.{{< /note >}}
&nbsp;

## Create an App

To create an App:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Services**.
1. On the **Services** menu, select **Apps**.
1. On the **Apps** menu, select **Create App**.
1. On the **Create App** page, provide the following information:
   - Name
   - Environment
   - Description (Optional)
   - Display Name (Optional)
   - Tags (Optional)
1. Select **Submit**.

## Create a Component

To create a Component:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Services**.
1. On the **Services** menu, select **Apps**.
1. On the **Apps** menu, in the **Recent Apps** section, select the name of the App that you want to add the Component to.
1. On the Overview page for your App, select **Create Component**. 
1. Then, complete each of the configuration sections as needed:

   - [General Configuration](#general-configuration)
   - [URIs](#uris)
   - [Workload Groups](#workload-groups)
   - [Ingress](#ingress)
   - [Backend](#backend)
   - [Monitoring](#monitoring)
   - [Errors and Logs](#errors-and-logs)
   - [Programmability](#programmability)
   - [Caching](#caching)
   - [Snippets](#snippets)   
   - [Rate Limiting](#rate-limiting)
   - [Authentication](#authentication)
   - [Security](#security)

1. When ready, review the API Spec and then select **Submit** to create the Component.

## Configuration Options

### General Configuration

{{< include "app-components/create-a-component-general-adc.md" >}}

### URIs

{{< include "app-components/create-a-component-uris.md" >}}

### Workload Groups

{{< include "app-components/create-a-component-workload-groups.md" >}}

### Ingress

{{< include "app-components/create-a-component-ingress-adc.md" >}}

### Backend

{{< include "app-components/create-a-component-backend-adc.md" >}}

### Monitoring

{{< include "app-components/create-a-component-monitoring.md" >}}

### Errors and Logs

{{< include "app-components/create-a-component-errors-and-logs.md" >}}

### Programmability

{{< include "app-components/create-a-component-programmability.md" >}}

### Caching

{{< note >}}
Introduced in NGINX Controller App Delivery module v3.22.
{{< /note >}}

{{< include "app-components/create-a-component-caching.md" >}}

### Snippets

{{< note >}}
Introduced in NGINX Controller App Delivery module v3.22.
{{< /note >}}

Refer to the [About Snippets]({{< relref "/app-delivery/about-snippets.md" >}}) topic to learn more about Snippets and how they impact the NGINX Controller-generated `nginx.conf` file.

{{< include "app-components/create-a-component-snippets.md" >}}

### Rate Limiting

{{< include "app-components/create-a-component-rate-limiting.md" >}}

### Authentication

{{< include "app-components/create-a-component-authentication.md" >}}

### Security

{{< include "app-components/create-a-component-security-adc.md" >}}

## Edit or Delete Apps and Components

To view, edit, and delete Apps:

1. Open the NGINX Controller user interface and log in.
1. Select the **NGINX Controller menu icon** > **Services** > **Apps**.
1. On the **Apps** menu, select **Overview**. The **Apps Overview** page is displayed and shows a list of your Apps.
1. To view the details for an App, including metrics data and components, select the App name in the list of Apps.
1. To edit the App, select **Edit Config** on the **Quick Actions** menu.
1. To delete the App, select **Delete Config** on the **Quick Action**s menu.

To edit or delete a Component:

1. Open the NGINX Controller user interface and log in.
1. Select the **NGINX Controller menu icon** > **Services** > **Apps**.
1. On the **Apps** menu, select **Overview**. The **Apps Overview** page is displayed and shows a list of your Apps.
1. Select the App that contains the Component that you want to modify. The App's **Overview** page is displayed.
1. In the details panel for your App, select **Components**.
1. On the **Components** page, select the Component that you want to modify.
1. To edit the Component, select **Edit Config** on the **Quick Actions** menu.
1. To delete the Component, select **Delete Config** on the **Quick Actions** menu.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
