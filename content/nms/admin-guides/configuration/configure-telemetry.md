---
description: The NGINX Management Suite platform has the option to share telemetry
  data with F5 NGINX. This data provides valuable insights into software usage and
  adoption, which F5 NGINX uses to inform product development and support our customers
  worldwide in maximizing their success with the platform.  In this document, you
  will find an overview of the transmitted data, instructions for enabling or disabling
  the feature, and instructions for configuring firewalls.
docs: DOCS-1269
doctypes:
- task
tags:
- docs
title: Configure Telemetry
toc: true
weight: 260
---

## Telemetry Data and Purpose

NGINX Management Suite sends a limited set of telemetry data to F5 NGINX for analysis. This data is associated only with the subscription ID from the applied license and does not include any personally identifiable information or specific details about the management plane, data plane, or other details.

The purpose of collecting this telemetry data is as follows:

- Driving and validating product development decisions to ensure optimal outcomes for users.
- Assisting the Customer Success and Support teams in helping users achieve their goals successfully.
- Fulfilling Flexible Consumption Program reporting requirements by automatically reporting product usage to F5 NGINX, saving time for users.

By sharing this telemetry data, we can improve NGINX Management Suite and provide better support to our users.

The table below shows the captured data points, the trigger conditions, and their respective purposes. We may add additional data points in the future.

{{<bootstrap-table "table table-striped table-bordered">}}

| <div style="width:250px">Data Point</div>            | Triggering Event                            | Purpose |
|--------------------------|------------------------------------|-------|
| Installation | The first time NGINX Management Suite processes are started. | To measure the time it takes to install and start using NGINX Management Suite. |
| Login | When a user logs in to NGINX Management Suite. No data about the user is sent, only the fact that a user successfully authenticated and the timestamp of the login event. | To understand how often users or systems access NGINX Management Suite. |
| Start/Stop processes | When any NGINX Management Suite processes are started or stopped. | To gauge how often users upgrade NGINX Management Suite or troubleshoot issues. This information helps F5 Support diagnose issues. |
| Adding Data Plane(s)      | When NGINX Agent registers with NGINX Management Suite for the first time. No data about the data plane is sent, just that an NGINX Agent registered with the platform. | To understand the frequency and quantity of data planes being added to NGINX Management Suite. This information helps inform our scale and performance targets and helps F5 Support diagnose issues. |
| Product Usage | Data is sent daily or when Send Usage is selected from the Licenses page in the web interface or initiated using the API. (Requires a [JWT license]({{< relref "/nms/installation/add-license.md#jwt-license" >}}).) | To track and report commercial usage in accordance with entitlement and Flexible Consumption Program (FCP) requirements. |

{{</bootstrap-table>}}

---

## Enabling and Disabling Telemetry

Once you [apply a valid license to NGINX Management Suite]({{< relref "/nms/installation/add-license.md" >}}), the platform will automatically try to send the specified data points to F5 NGINX. It may also include data points captured shortly before the license was applied. For example, if you install NGINX Management Suite and immediately apply the license, the *Installation* data point will be sent.

You can disable telemetry sharing at any time by going to the NGINX Management Suite web interface and selecting **Settings > License**. Additionally, you can disable the feature using the `/license` API endpoint. You can re-enable telemetry from the same locations if you change your mind.

---

## Firewall Settings

NGINX Management Suite must be able to establish outbound connections to the IP address range 159.60.126.0/25 on port 443 in order to successfully transmit telemetry data to NGINX F5. The Product Usage data point requires both inbound and outbound connections on port 443.

If you are using a JWT license, make sure to allow inbound and outbound access on port 443 to the following URLs:

- https://product.apis.f5.com
- https://product-s.apis.f5.com/ee
