---
docs: DOCS-1269
doctypes:
- task
tags:
- docs
title: Configure Telemetry and Web Analytics
toc: true
weight: 260
---

## Overview

The F5 NGINX Management Suite platform lets you share telemetry and web analytics data with F5 NGINX. This data provides valuable insights into software usage and adoption, which F5 NGINX uses to improve product development and support customers worldwide. This document provides an overview of the transmitted data, instructions for enabling or disabling the features, and instructions for configuring firewalls.

## Telemetry

NGINX Management Suite sends a limited set of telemetry data to F5 NGINX for analysis. This data is associated only with the subscription ID from the applied license and does not include any personally identifiable information or specific details about the management plane, data plane, or other details.

The purpose of collecting this telemetry data is to:

- Drive and validate product development decisions to ensure optimal outcomes for users.
- Assist the Customer Success and Support teams in helping users achieve their goals.
- Fulfill Flexible Consumption Program reporting requirements by automatically reporting product usage to F5 NGINX, saving users time.

By sharing this telemetry data, we can improve NGINX Management Suite and provide better support to users.

### Captured Telemetry Data Points

The table below shows the captured telemetry data points, the trigger conditions, and their respective purposes. Additional data points may be added in the future.

{{<bootstrap-table "table table-striped table-bordered">}}

| <div style="width:250px">Data Point</div>            | Triggering Event                            | Purpose |
|--------------------------|------------------------------------|-------|
| Installation | The first time NGINX Management Suite processes are started. | To measure the time it takes to install and start using NGINX Management Suite. |
| Login | When a user logs in to NGINX Management Suite. No data about the user is sent, only the fact that a user successfully authenticated and the timestamp of the login event. | To understand how often users or systems access NGINX Management Suite. |
| Start/Stop processes | When any NGINX Management Suite processes are started or stopped. | To gauge how often users upgrade NGINX Management Suite or troubleshoot issues. This information helps F5 Support diagnose issues. |
| Adding Data Plane(s)      | When NGINX Agent registers with NGINX Management Suite for the first time. No data about the data plane is sent, just that an NGINX Agent registered with the platform. | To understand the frequency and quantity of data planes being added to NGINX Management Suite. This information helps inform our scale and performance targets and helps F5 Support diagnose issues. |
| Product Usage | Data is sent daily or when Send Usage is selected from the Licenses page in the web interface or initiated using the API. (Requires a [JWT license]({{< relref "/nms/installation/add-license.md#jwt-license" >}}).) | To track and report commercial usage in accordance with entitlement and Flexible Consumption Program (FCP) requirements. |

{{</bootstrap-table>}}

### Enabling and Disabling Telemetry

Once you [apply a valid license to NGINX Management Suite]({{< relref "/nms/installation/add-license.md" >}}), the platform will automatically try to send the specified telemetry data points to F5 NGINX. It may also include data points captured shortly before the license was applied. For example, if you install NGINX Management Suite and immediately apply the license, the *Installation* data point will be sent.

#### Disable Telemetry

You can disable telemetry sharing at any time by going to the NGINX Management Suite web interface and selecting **Settings > License**. You can also disable the feature using the `/license` API endpoint. You can re-enable telemetry from the same locations if you change your mind.

### Firewall Settings for Telemetry

NGINX Management Suite must establish outbound connections to the IP address range 159.60.126.0/25 on port 443 to successfully transmit telemetry data to NGINX F5. The Product Usage data point requires both inbound and outbound connections on port 443.

If you are using a JWT license, make sure to allow inbound and outbound access on port 443 to the following URLs:

- [https://product.apis.f5.com](https://product.apis.f5.com)
- [https://product-s.apis.f5.com/ee](https://product-s.apis.f5.com/ee)

---

## Web Analytics

Web analytics are collected when users interact with the platform through their web browsers. This data is sent directly from the users' browsers to F5 NGINX and is used to understand user interaction patterns and improve the user experience.

### Enabling and Disabling Web Analytics

#### Opt Out of Web Analytics During Provisioning

During provisioning or upgrade, administrators will see a notice about web analytics collection with an option to opt out. This notice includes a link to F5’s official [Privacy Notice](https://www.f5.com/company/policies/privacy-notice). Administrators can opt out by clicking the provided link or later by accessing the user menu in the top-right corner of the screen and selecting the option to disable data collection.

#### Disable Web Analytics

If administrators miss the initial opt-out message or want to change their decision later, they can follow these steps to disable web analytics:

1. Click on the **User** icon in the top-right corner of the screen.
2. Select **"Collect interaction data (all users)"** to turn the setting off.

{{<note>}}The admin user’s decision to opt in or out of web analytics affects all users on the platform.{{</note>}}