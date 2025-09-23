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

Starting with NGINX Plus R33, **NGINX Plus instances require a valid JSON Web Token (JWT) license**.  

The JWT license:

- Is tied to your subscription (not to individual instances).  
- Validates your subscription and sends usage reports to F5’s licensing endpoint (`product.connect.nginx.com`) in connected environments, or through [NGINX Instance Manager]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}}) in disconnected environments.  

If you have multiple subscriptions, you’ll also have multiple JWT licenses. You can assign each NGINX Plus instance to any license. NGINX combines usage reporting across all licensed instances.  

{{< call-out "Note" "Note" >}}Combining licenses with NGINX Instance Manager requires version **2.20 or later**.{{</ call-out >}}  

---

## Important changes

NGINX Plus requires a valid license and regular usage reporting to run normally.

The conditions below, and the workflow diagram that follows, explain what happens if those requirements aren’t met.  

### Starting NGINX Plus requires:

- A valid JWT license. If the license is missing or invalid, NGINX Plus won’t start.  
- A license that is less than 90 days past expiration. If it’s expired longer, NGINX Plus won’t start.  

### Continuing to process traffic requires:

- A successful initial usage report. If the first report fails, NGINX Plus stops processing traffic until the report succeeds. See [Postpone reporting enforcement](#postpone-reporting-enforcement) for how to add a grace period.  
- At least one usage report every 180 days. If the grace period ends without a report, NGINX Plus stops processing traffic until reporting is restored.  

### Licensing and reporting workflow

The following workflow shows what happens when a JWT license is missing, expired, or when usage reporting fails:

{{< figure
    src="/nginx/images/nginx-plus-licensing-workflows.png"
    link="/nginx/images/nginx-plus-licensing-workflows.png"
    alt="Flowchart showing NGINX Plus license and reporting checks, with outcomes for missing, expired, or invalid licenses."
    caption="Figure: Licensing and reporting workflow for NGINX Plus. Outcomes include warnings in the error log, grace periods for reporting, and in some cases traffic stopping until the issue is resolved."
>}}

### What this means for you

To keep NGINX Plus running after you install or upgrade to R33 or later, you need to:

- **[Add a valid JWT license](#download-jwt)** to each NGINX Plus instance.  
- **[Set up reporting](#set-up-environment)** so each instance can send usage data.

---

## Download the license from MyF5 {#download-jwt}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

---

## Deploy the JWT license

After you download the JWT license, you need to deploy it to your NGINX Plus instances. You can do this in one of two ways:

- **Use a Config Sync Group (recommended):** If you manage instances with the [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}}), this method keeps instances consistent, avoids manual copying, and applies license updates automatically.  
- **Copy the license manually:** Place the license file on each instance yourself.  

Both methods ensure your NGINX Plus instances have access to the required license file.  

Choose the option that fits your environment:

<details>
<summary>Deploy with Config Sync Group (NGINX One Console)</summary>

### Deploy with a Config Sync Group

If you use the [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}}), the easiest way to deploy your JWT license is with a [Config Sync Group]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}). A Config Sync Group lets you:

- Avoid manual file copying  
- Keep all instances consistent  
- Automatically apply the license to new instances  

To deploy the JWT license with a Config Sync Group:

{{< include "/licensing-and-reporting/deploy-jwt-with-csgs.md" >}}

After setup, the license syncs to all NGINX Plus instances in the group.  

{{< call-out "note" "About renewals" "" >}}
Starting in NGINX Plus R35, licenses can [renew automatically](#automatic-renewal) if license reporting is enabled.  
Config Sync Groups are still useful for initial deployment and for keeping instances consistent.  

If you’re running a release earlier than R35, you’ll need to [update the license](#update-jwt) in the Config Sync Group whenever your subscription renews.  
{{< /call-out >}}

{{< call-out "note" "If you’re using NGINX Instance Manager" "" >}}
If you use NGINX Instance Manager instead of the NGINX One Console, the equivalent feature is an *instance group*. You can manage your JWT license the same way by adding or updating the file in the instance group. For details, see [Manage instance groups]({{< ref "/nim/nginx-instances/manage-instance-groups.md" >}}).
{{< /call-out >}}

</details>

<details>
<summary>Deploy manually</summary>

### Deploy manually

You can copy the JWT license file directly to each NGINX Plus instance.

{{< include "/licensing-and-reporting/apply-jwt.md" >}}

{{< call-out "note" "About renewals" "" >}}
Starting in NGINX Plus R35, licenses can [renew automatically](#automatic-renewal) if license reporting is enabled.  
Manual deployment is still useful for the initial license, or in environments where auto-renewal is not available (such as disconnected networks).  

If you’re running a release earlier than R35, you’ll need to [update the license manually](#update-jwt) whenever your subscription renews.  
{{< /call-out >}}

</details>

<details>
<summary>Use custom paths</summary>

### Custom paths {#custom-paths}

{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}

</details>

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

You can delay reporting by setting [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#enforce_initial_report) to `off`. This starts a 180-day grace period where NGINX Plus keeps running while it continues trying to report.

```nginx
# Modify this directive to start the 180-day grace period for initial reporting.
mgmt {
  enforce_initial_report off;
}
```

{{< call-out "important" >}}After 180 days, if usage reporting still hasn’t been established, NGINX Plus will stop processing traffic.{{< /call-out >}}

---

## Update the JWT license {#update-jwt}

### Automatic renewal (R35 and later) {#automatic-renewal}

Starting in NGINX Plus R35, [JWT licenses are renewed automatically](https://community.f5.com/kb/technicalarticles/f5-nginx-plus-r35-release-now-available/342962/#community-342962-AutomaticJWTRenewal) for instances that report directly to the F5 licensing endpoint. NGINX Plus downloads the updated license and applies it without requiring a reload or restart.

- Begins 30 days before the current license expires and also applies if the license has expired but is still within the 90-day grace period.  
- Requires an active subscription and license reporting to the F5 licensing endpoint.  
- The licensing endpoint sends the updated license after the subscription is renewed.  
- NGINX Plus applies the renewed license automatically and stores it as **nginx-mgmt-license** in the [`state_path`](https://nginx.org/en/docs/ngx_mgmt_module.html#state_path) directory.  
- Traffic continues without interruption.  

  {{< call-out "important" "Important" >}}  
  Automatic renewal only works if:  
  - License reporting is enabled, **and**  
  - At least one usage report has already been sent successfully.  

  If these conditions aren’t met, you must [update the JWT license manually](#deploy-the-jwt-license).  
  {{< /call-out >}}

### Manual renewal (all releases)

If auto-renewal is not available (for example, in disconnected environments), update the license manually:

1. [Download the new JWT license](#download-jwt) from MyF5.  
2. [Deploy the JWT license](#deploy-the-jwt-license) to your NGINX Plus instances.  

### License files

The auto-renewed license is stored in the `state_path` directory. The original JWT license file at `/etc/nginx/license.jwt` (or a custom path set by [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token)) is not modified.  

You can replace the original file manually if needed, but this does not affect NGINX Plus operation.

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
