---
description: This document provides instructions on how to publish API documentation
  and API proxies to a Developer Portal in order to make them available at a designated
  hostname.
docs: DOCS-1082
title: Publish Docs to a Developer Portal
toc: true
weight: 200
type:
- how-to
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

---

## Overview

This document will guide you through the process of publishing API documentation and API proxies to a Developer Portal. You will find instructions on how to add an API spec file, publish API documentation and the associated API proxy, or publish API documentation only. After completing these steps, you should be able to access your API and documentation at the designated hostname.

---

## Before You Begin

To complete the steps in this guide, you need the following:

- [API Connectivity Manager is installed]({{< ref "/nim/deploy/_index.md" >}}) and running
- One or more environments with a [configured Developer Portal]({{< ref "/nms/acm/getting-started/add-devportal.md" >}})
- (Optional) [Customize the Developer Portal]({{< ref "/nms/acm/how-to/infrastructure/customize-devportal.md" >}})

---

## How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

---

## Add an API Doc

1. On the sidebar, select **Services**.
1. Select your workspace.
1. Select **API Docs > Add API Doc**.
1. Browse your local filesystem and select the API Spec in YAML or JSON format that you'd like to upload.
1. Select **Save**.

## Publish the API Documentation and API Proxy

1. Select **Services** on the sidebar.
1. Select your workspace from the **Workspaces** list.
1. On the **API Proxies** section, select **Publish to Proxy**.
1. On the **Name** box, type the name for the backend service. `-svc` will be added to the name automatically.
1. On the **Service Target Hostname**, type the hostname for the Service Target.
1. On the **API Proxy** section, the **Name** box is automatically filled.
1. On the **API Spec** section, select your spec using the list.
1. Select your **Gateway Proxy Hostname** using the list.
1. Confirm the **Base Path** and **Version** on the **Ingress** section. Update the default values if needed.
1. Check the **Also publish API to developer portal** box on the **Developer Portal** section.
1. Select the **Portal Proxy Hostname** using the list.
1. Select **Publish**

The API and documentation should now be available at the hostname provided for the Developer Portal proxy.

## Publish the API Documentation Only

Take the steps below to publish just the API documentation.

1. Select **Services** on the sidebar.
1. Select **Publish API Doc** from the **Actions** menu.
1. In the **Name** box, type the name for your API Doc.
1. On the **API Spec** section, select your spec using the list.
1. Select the **Portal Proxy Hostname** using the list.
1. Confirm the **Base Path** and **Version** on the **Ingress** section. Update the default values if needed.
1. Select the **Enter an external Hostname** option.
1. On the **External Hostname** section, provide the hostname for your external Target Proxy.
1. Select **Save**.
