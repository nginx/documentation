---
title: "About subscription licenses"
date: 2024-10-10T12:52:14-07:00
toc: true
weight: 2
type: concept
product: Solutions
docs: DOCS-000
---

## Overview

We’re updating NGINX Plus to align with F5’s entitlement and visibility policy, bringing benefits like fair and compliant usage, better visibility into license management, and improved customer support.

Starting with NGINX Plus R33, all **NGINX Plus instances require a valid JSON Web Token (JWT) license**. This license is tied to your subscription (not individual instances) and is used to validate your subscription and automatically send usage reports to F5's licensing endpoint (`product.connect.nginx.com`), as required by your subscription agreement. In offline environments, usage reporting is [routed through NGINX Instance Manager]({{< relref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).

### Important changes

##### NGINX Plus won't start if:

- The JWT license is missing or invalid.
- The JWT license expired over 90 days ago.

##### NGINX Plus will **stop processing traffic** if:

- It can't submit an initial usage report to F5's licensing endpoint or NGINX Instance Manager. 

  If the first report fails, NGINX Plus immediately stops processing traffic and logs an `EMERG` message. NGINX Plus will attempt to report every minute, and traffic processing will resume once the initial report succeeds. If you need time to prepare for usage reporting, see [Postpone reporting enforcement](#postpone-reporting-enforcement).

- It hasn't submitted a usage report in the last 180 days (for subsequent reports).

  Once the first successful report is made, NGINX Plus saves a record of the transaction. If subsequent reports fail, a 180-day reporting grace period starts, beginning from the last successful report. During this period, NGINX Plus will continue to operate normally, even during reloads, restarts, or reboots. However, if reporting isn’t restored by the end of the grace period, NGINX Plus will stop processing traffic.


### What this means for you

When installing or upgrading to NGINX Plus R33 or later, take the following steps:

- **[Download and add a valid JWT license](#download-jwt)** to each NGINX Plus instance.
- **[Set up your environment](#set-up-environment)** to allow NGINX Plus to send usage reports.  

---

## Add the JWT license {#add-jwt}

Before you install or upgrade to NGINX Plus R33 or later, make sure to:

### Download the license from MyF5 {#download-jwt}
    
{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

### Copy the license to each NGINX Plus instance

{{< include "licensing-and-reporting/apply-jwt.md" >}}

#### Custom paths: {#custom-paths}

{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}

---

## Prepare your environment for reporting {#set-up-environment}

To ensure NGINX Plus R33 or later can send usage reports, follow these steps based on your environment:

### For internet-connected environments

Allow outbound HTTPS traffic on TCP port `443` to communicate with F5's licensing endpoint (`product.connect.nginx.com`). Ensure that the following IP addresses are allowed:

- `3.135.72.139`
- `3.133.232.50`
- `52.14.85.249`

### For network-restricted environments

In environments where NGINX Plus instances cannot access the internet, you'll need NGINX Instance Manager to handle usage reporting.

#### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus R33 or later to report usage data to NGINX Instance Manger:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

To send NGINX Plus usage reports to F5, follow the instructions in [Submit usage reports to F5 from NGINX Instance Manager](#submit-usage-reports-from-nim).

### Postpone reporting enforcement {#postpone-reporting-enforcement}

To give yourself more time to submit the initial usage report, you can postpone reporting by setting [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#enforce_initial_report) to `off`. This change enables a 180-day reporting grace period, during which NGINX Plus will operate normally while still attempting to report.


```nginx
# Modify this directive to start the 180-day grace period for initial reporting.
mgmt {
  enforce_initial_report off;
}
```

{{<important>}}After 180 days, if usage reporting still hasn’t been established, NGINX Plus will stop processing traffic.{{</important>}}

---

## Error log location and monitoring {#log-monitoring}

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}

---

## Understand reported usage metrics {#usage-metrics}

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

---

## Learn more about related topics

### NGINX Plus

#### NGINX Plus installation guide

For detailed instructions on installing or upgrading NGINX Plus, visit the [NGINX Plus installation guide]({{< relref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

#### `mgmt` module and directives

For full details about the `mgmt` module and its directives, visit the [Module ngx_mgmt_module reference guide](https://nginx.org/en/docs/ngx_mgmt_module.html).

### NGINX Instance Manager

The instructions below use the terms "internet-connected" and "network-restricted" to describe how NGINX Instance Manager accesses the internet.

#### License NGINX Instance Manager

- **Internet-connected**: Follow the steps in [Add license]({{< relref "nim/admin-guide/license/add-license.md" >}}).
- **Network-restricted**: Follow the steps in [Add a license in a disconnected environment]({{< relref "nim/disconnected/add-license-disconnected-deployment.md" >}}).

#### Submit usage reports to F5 from NGINX Instance Manager {#submit-usage-reports-from-nim}

- **Internet-connected**: Follow the steps in [Report usage to F5]({{< relref "nim/admin-guide/license/report-usage-connected-deployment.md" >}}).
- **Network-restricted**: Follow the steps in [Report usage to F5 in a disconnected environment]({{< relref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).

### NGINX App Protect WAF

For details on installing or upgrading NGINX App Protect WAF, visit the guide for the respective version:

- [NGINX App Protect WAF v4 installation guide]({{< ref "/nap-waf/v4/admin-guide/install.md" >}})
- [NGINX App Protect WAF v5 installation guide]({{< ref "/nap-waf/v5/admin-guide/install.md" >}})

### NGINX App Protect DoS

For detailed instructions on installing or upgrading NGINX App Protect DoS, visit the [NGINX App Protect DoS installation guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}).

## Watch instructional videos

### Submit usage reports in a connected environment
{{< youtube id="mnTJ1oYnZpk" >}}

### Submit usage reports in a disconnected environment
{{< youtube id="4wIM21bR9-g" >}}

### Install or upgrade to NGINX Plus R33
{{< youtube id="zHd7btagJRM" >}}
