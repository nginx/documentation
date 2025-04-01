---
docs: DOCS-1269
title: Configure telemetry and web analytics
toc: true
weight: 260
type:
- how-to
---

## Overview

F5 NGINX Instance Manager lets you share telemetry and web analytics data with F5. This data provides insights into software usage, helping improve product development and customer support. This document explains the data that’s sent, how to enable or disable telemetry, and how to configure firewall settings.

## Telemetry

NGINX Instance Manager sends limited telemetry data linked to the subscription ID in your license. The data doesn’t include personal details or specifics about the management or data planes.

### Why telemetry is collected

Telemetry helps:

- Guide product development to improve user outcomes.
- Support Customer Success and Support teams in resolving issues.
- Automatically report usage for Flexible Consumption Program requirements, saving you time.

By sharing telemetry, you help improve NGINX Instance Manager and its support.

### Telemetry data points

The table below shows the captured telemetry data points, the trigger conditions, and their respective purposes. Additional data points may be added in the future.

{{<bootstrap-table "table table-striped table-bordered">}}

| <div style="width:250px">Data Point</div>            | Triggering Event                            | Purpose |
|--------------------------|------------------------------------|-------|
| Installation | The first time NGINX Instance Manager processes are started. | To measure the time it takes to install and start using NGINX Instance Manager. |
| Login | When a user logs in to NGINX Instance Manager. No data about the user is sent, only the fact that a user successfully authenticated and the timestamp of the login event. | To understand how often users or systems access NGINX Instance Manager. |
| Start/Stop processes | When any NGINX Instance Manager processes are started or stopped. | To gauge how often users upgrade NGINX Instance Manager or troubleshoot issues. This information helps F5 Support diagnose issues. |
| Adding Data Plane(s)      | When NGINX Agent registers with NGINX Instance Manager for the first time. No data about the data plane is sent, just that an NGINX Agent registered with the platform. | To understand the frequency and quantity of data planes being added to NGINX Instance Manager. This information helps inform our scale and performance targets and helps F5 Support diagnose issues. |
| Product Usage | Data is sent daily or when Send Usage is selected from the Licenses page in the web interface or initiated using the API. (Requires a [JWT license]({{< ref "/nim/admin-guide/license/add-license.md#jwt-license" >}}).) | To track and report commercial usage in accordance with entitlement and Flexible Consumption Program (FCP) requirements. |

{{</bootstrap-table>}}

### Enable or disable telemetry

Once you [apply a valid license]({{< ref "/nim/admin-guide/license/add-license.md" >}}), telemetry data starts transmitting. If the license is applied immediately after installation, the *Installation* data point is also sent.

#### Disable telemetry

You can disable telemetry anytime by:

- Going to **Settings > License** in the web interface.
- Using the [`/license` API endpoint]({{< ref "/nim/fundamentals/api-overview.md" >}}).

Re-enable telemetry in the same way.

### Firewall settings for telemetry

To enable telemetry, configure your firewall to allow:

- Outbound TCP connections to `159.60.126.0/25` on port `443`.
- For JWT licenses, inbound and outbound access to:
  - `https://product.apis.f5.com`
  - `https://product-s.apis.f5.com/ee`

## Web analytics

Web analytics track interactions with NGINX Instance Manager through users’ web browsers. The data is sent directly to NGINX and helps improve user experience.

### Opt out of web analytics during provisioning

During provisioning or upgrades, administrators see a notice about web analytics collection with an option to opt out. The notice includes a link to the [Privacy Notice](https://www.f5.com/company/policies/privacy-notice).

### Disable web analytics

If administrators miss the initial opt-out:

1. Select the **User** icon in the top-right corner.
2. Select **"Collect interaction data (all users)"** to clear the setting.

{{<note>}}The admin's decision to enable or disable web analytics applies to all users.{{</note>}}
