---
description: Create and manage environments to use with your apps, gateways, and certs.
nd-docs: DOCS-372
title: Manage Environments
toc: true
weight: 100
type:
- tutorial
---

## Overview

This page contains instructions for creating and managing Environments in the F5 NGINX Controller user interface.

{{< call-out "tip" >}}
If you prefer, you can use the NGINX Controller API to create and manage Environments. See the [NGINX Controller API reference guide]({{< ref "/controller/api/_index.md" >}}) (**Services > Environments**) for details.
{{< /call-out >}}

## Objective

- Create an Environment
- View, edit, and delete environments

## About Environments

An **Environment** is a logical container used to group Applications, Gateways, and [Certificates]({{< ref "/controller/services/manage-certs.md" >}}) into a domain associated with common goals, resource needs, usage constraints, and access controls. Environments typically map closely to organizational boundaries. "Dev" and "prod" are a few common Environment examples.

A **dev** Environment is where developers can build and test an application. Its primary purpose is to allow developers to quickly develop and test new application features. Access to a dev Environment is typically restricted to those who need it--developers and testers. The resources in a dev Environment support the development and debugging of the application and, as such, may not have the same capabilities or requirements as resources in a production, or "prod", Environment.

The applications, gateways, and certificates associated with a dev Environment are specific to the development process. The applications represent the path to the development machines where the latest rev of the application is being tested; these are tied to the development CI/CD pipelines. The ingress definitions for these applications represent instantiations that allow only the developers and testers to use the application--for example, via machines only accessible via VPN access. The certificates associated with the development Environment and its apps would typically have some differentiator in `name_`, for example, a suffix of "dev" `app1.contoso.dev`. The gateways associated with the development environment include placements that correspond to instantiations on machines that are part of the dev infrastructure.

By contrast, our example **prod** Environment hosts the running application accessible to end users. The goal of the prod Environment is to allow seamless access to the applications for end users, with minimal latency and down time. The applications, gateways, and certificates that are associated with the prod Environment reflect its purpose. The applications defined as part of the prod Environment represent the path to the production machines hosting the latest rev of the application; these are tied to the production CI/CD pipelines. The ingress definitions for these applications represent instantiations that allow end users to use the application, via machines that allow public access. The certificates associated with the prod Environment and its apps would typically represent the company and the app branding, for example, `app1.contoso.com`. The gateways associated with the prod Environment include placements that correspond to instantiations on machines that are part of the production infrastructure.

## Create an Environment

To create an Environment:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Environments**.
4. On the **Environments** menu, select **Create Environment**.
5. On the **Create Environment** page, complete the fields to define your Environment.
6. Select **Submit**.

## View, Edit, and Delete Environments

To view, edit, and delete environments:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Environments**.
4. On the **Environments** menu, select **Overview**. The **Environments Overview** page is displayed and shows a list of your environments.
5. To view the details for an Environment, select the name of the Environment from the list provided. On the Environment Overview page, you can view metrics data associated with the Environment, as well as its associated Apps, Certs, and Gateways.
6. To edit the Environment, select **Edit Config** on the **Quick Actions** menu.
7. To delete the Environment, select **Delete Config** on the **Quick Actions** menu.

## What's Next

- [Give Users and Roles access to your Environment]({{< ref "/controller/platform/access-management/manage-users.md" >}})
- [Create or Upload Certificates]({{< ref "/controller/services/manage-certs.md#create-a-cert" >}})
- [Create a Gateway]({{< ref "/controller/services/manage-gateways.md#create-a-gateway" >}})
- [Create an Application]({{< ref "/controller/app-delivery/manage-apps.md#create-an-app" >}})
- [Create App Components]({{< ref "/controller/app-delivery/manage-apps.md#create-a-component" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
