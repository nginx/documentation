---
title: About subscription licenses
toc: true
weight: 2
type:
- reference
product: Solutions
nd-docs: DOCS-1780
---

## Overview

We’re updating NGINX Plus to align with F5’s entitlement and visibility policy, bringing benefits like fair and compliant usage, better visibility into license management, and improved customer support.

Starting with NGINX Plus R33, all **NGINX Plus instances require a valid JSON Web Token (JWT) license**. This license is tied to your subscription (not individual instances) and is used to validate your subscription and automatically send usage reports to F5's licensing endpoint (`product.connect.nginx.com`), as required by your subscription agreement. In offline environments, usage reporting is [routed through NGINX Instance Manager]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).

## Important changes

If you have multiple subscriptions, you’ll also have multiple JWT licenses. You can assign each NGINX Plus instance to the license you prefer. NGINX combines usage reporting across all licensed instances.

This feature is available in NGINX Instance Manager 2.20 and later.

### NGINX Plus won't start if:

- The JWT license is missing or invalid.
- The JWT license expired over 90 days ago.

### NGINX Plus will **stop processing traffic** if:

- It can't submit an initial usage report to F5's licensing endpoint or NGINX Instance Manager.

  If the first report fails, NGINX Plus immediately stops processing traffic and logs an `EMERG` message. NGINX Plus will attempt to report every minute, and traffic processing will resume once the initial report succeeds. If you need time to prepare for usage reporting, see [Postpone reporting enforcement](#postpone-reporting-enforcement).

- It hasn't submitted a usage report in the last 180 days (for subsequent reports).

  Once the first successful report is made, NGINX Plus saves a record of the transaction. If subsequent reports fail, a 180-day reporting grace period starts, beginning from the last successful report. During this period, NGINX Plus will continue to operate normally, even during reloads, restarts, or reboots. However, if reporting isn’t restored by the end of the grace period, NGINX Plus will stop processing traffic.


### What this means for you

When installing or upgrading to NGINX Plus R33 or later, take the following steps:

- **[Download and add a valid JWT license](#download-jwt)** to each NGINX Plus instance.
- **[Set up your environment](#set-up-environment)** to allow NGINX Plus to send usage reports.

---

## Download the license from MyF5 {#download-jwt}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

---

## Deploy the JWT license

After you download the JWT license, you can deploy it to your NGINX Plus instances using either of the following methods:

- Use a **Config Sync Group** if you're managing instances with the NGINX One Console (recommended)
- Copy the license manually to each instance

Each method ensures your NGINX Plus instances have access to the required license file.

### Deploy with a Config Sync Group (Recommended)

If you're using the [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}}), the easiest way to manage your JWT license is with a [Config Sync Group]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}). This method lets you:

- Avoid manual file copying
- Keep your fleet consistent
- Automatically apply updates to new NGINX Plus instances

To deploy the JWT license with a Config Sync Group:

{{< include "/licensing-and-reporting/deploy-jwt-with-csgs.md" >}}

Your JWT license now syncs to all NGINX Plus instances in the group.

When your subscription renews and a new JWT license is issued, update the file in the Config Sync Group to apply the change across your fleet.  

New instances added to the group automatically inherit the license.

{{< call-out "note" "If you’re using NGINX Instance Manager" "" >}}
If you're using NGINX Instance Manager instead of the NGINX One Console, the equivalent feature is called an *instance group*. You can manage your JWT license in the same way by adding or updating the file in the instance group. For details, see [Manage instance groups]({{< ref "/nim/nginx-instances/manage-instance-groups.md" >}}).
{{< /call-out >}}

### Copy the license manually

If you're not using NGINX One, copy the JWT license file to each NGINX Plus instance manually.

{{< include "/licensing-and-reporting/apply-jwt.md" >}}

### Custom paths {#custom-paths}

{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}

---

## Prepare your environment for reporting {#set-up-environment}

To ensure NGINX Plus R33 or later can send usage reports, follow these steps based on your environment:

### For internet-connected environments

1. Allow outbound HTTPS traffic on TCP port `443` to communicate with F5's licensing endpoint (`product.connect.nginx.com`). Ensure that the following IP addresses are allowed:

   - `3.135.72.139`
   - `3.133.232.50`
   - `52.14.85.249`

2.  (Optional, R34 and later) If your company enforces a strict outbound traffic policy, you can use an outbound proxy for establishing an end-to-end tunnel to the F5 licensing endpoint. On each NGINX Plus instance, update the [`proxy`](https://nginx.org/en/docs/ngx_mgmt_module.html#proxy) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX configuration (`/etc/nginx/nginx.conf`) to point to the company's outbound proxy server:


    ```nginx
    mgmt {
        proxy          PROXY_ADDR:PORT; #can be http or https
        proxy_username USER;            #optional
        proxy_password PASS;            #optional
    }
    ```

### For network-restricted environments

In environments where NGINX Plus instances cannot access the internet, you'll need NGINX Instance Manager to handle usage reporting.

#### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus R33 or later to report usage data to NGINX Instance Manager:

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

For detailed instructions on installing or upgrading NGINX Plus, visit the [NGINX Plus installation guide]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

#### `mgmt` module and directives

For full details about the `mgmt` module and its directives, visit the [Module ngx_mgmt_module reference guide](https://nginx.org/en/docs/ngx_mgmt_module.html).

### NGINX Instance Manager

The instructions below use the terms "internet-connected" and "network-restricted" to describe how NGINX Instance Manager accesses the internet.

#### License NGINX Instance Manager

- **Internet-connected**: Follow the steps in [Add license]({{< ref "nim/admin-guide/add-license.md" >}}).
- **Network-restricted**: Follow the steps in [Add a license in a disconnected environment]({{< ref "nim/disconnected/add-license-disconnected-deployment.md" >}}).

#### Submit usage reports to F5 from NGINX Instance Manager {#submit-usage-reports-from-nim}

- **Internet-connected**: Follow the steps in [Report usage to F5]({{< ref "nim/admin-guide/report-usage-connected-deployment.md" >}}).
- **Network-restricted**: Follow the steps in [Report usage to F5 in a disconnected environment]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).

### NGINX App Protect WAF

For details on installing or upgrading NGINX App Protect WAF, visit the guide for the respective version:

- [NGINX App Protect WAF v4 installation guide]({{< ref "/nap-waf/v4/admin-guide/install.md" >}})
- [NGINX App Protect WAF v5 installation guide]({{< ref "/nap-waf/v5/admin-guide/install.md" >}})

### NGINX App Protect DoS

For detailed instructions on installing or upgrading NGINX App Protect DoS, visit the [NGINX App Protect DoS installation guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}).

## Watch instructional videos

### Submit usage reports in a connected environment
{{< youtube id="PDnacyh2RUw" >}}

### Submit usage reports in a disconnected environment
{{< youtube id="4wIM21bR9-g" >}}

### Install or upgrade to NGINX Plus R33
{{< youtube id="zHd7btagJRM" >}}
