---
description: Learn how to support various deployment patterns for Developer Portal.
docs: DOCS-955
title: Deployment Patterns for Developer Portal
toc: true
weight: 200
---

{{< shortversions "1.2.0" "latest" "acmvers" >}}

## Overview

The Developer Portal application is a combination of a portal application (Developer Portal UI) and a backend API service (Developer Portal API service) to support the application.

The following deployment patterns are supported:

- Developer Portal UI and API service deployed on a single host (default).
- Load-balanced backend API using multiple IP addresses. Developer Portal UI and API service deployed on different hosts.
- Load-balanced backend API using a single hostname. Developer Portal UI and API service deployed on different hosts using a single hostname and frontend by a load balancer.

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with a [Developer Portal]({{< relref "/nms/acm/getting-started/add-devportal" >}}) cluster.
- You have verified that you can access the Developer Portal using the configured hostname.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

---

## Single Host Installation

With the localhost installation, which is the default setup, both the backend and UI Developer Portal binaries are installed on the same machine. The backend API service is on the localhost, port 8080, by default.

<div align="center">
{{< img src="acm/deployment-patterns/LocalInstall.png" alt="local install" width="400" >}}
</div>

---

## Multi-Host Installation for High Availability

The Developer Portal backend API service can be scaled for high availability by installing the backend binaries on multiple hosts. The Developer Portal front-end load balances the requests between multiple backend services using an IP address or an internal DNS name.

<div align="center">
{{< img src="acm/deployment-patterns/MultipleIP.png" alt="multiple IPs" width="400" >}}
</div>

### Configure Developer Portal Backend

When creating a Developer Portal in an environment, you can set multiple `serviceTargets` to match any of the deployment patterns above.

1. In the API Connectivity Manager user interface, go select **Workspaces > Environments > \<your environment\>**, where "your environment" is the Environment that contains the Developer Portal.
1. Select **Edit Advanced Config** from the **Actions** menu for the desired Developer Portal.
1. On the **Backend** tab, select the default backend service, then select **Edit Backend** from the **Actions** menu.
1. Add/Update desired service target.
