---
title: Getting started
toc: true
weight: 200
nd-content-type:
  - tutorial
nd-product: Solutions
nd-docs: DOCS-1780
nd-resource:
  - https://lucid.app/lucidchart/0abcb9d3-b36e-40af-b56a-e74771b384d5/edit?invitationId=inv_8ccda3dc-2306-468c-9cb6-b4684be1360f&page=0_0#
---

Starting with NGINX Plus R33, NGINX Plus instances require a valid JSON Web Token (JWT) license.  

The license:

- Is tied to your subscription (not to individual instances).  
- Checks your subscription and reports usage either to F5’s licensing endpoint (`product.connect.nginx.com`) or, in disconnected environments, through [NGINX Instance Manager]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).  

{{< call-out "note" "If you have multiple subscriptions" >}}

If you have multiple subscriptions, you’ll also have multiple JWT licenses. You can assign each NGINX Plus instance to the license you prefer. NGINX combines usage reporting across all licensed instances. 

Combining licenses with NGINX Instance Manager requires version **2.20 or later**.
{{</ call-out >}}  

---

## Important changes

NGINX Plus requires a valid license and regular usage reporting to run. The sections below explain the requirements and what happens if they aren’t met.  

{{< call-out "note" "Licensing workflows" >}}
For flowcharts that show how these requirements work in practice, see [NGINX Plus licensing workflows]({{< ref "/solutions/about-subscription-licenses/nginx-plus-licensing-workflows.md" >}}).
{{< /call-out >}}

### Starting NGINX Plus

Starting NGINX Plus requires:

- A valid license.
- A license that has not been expired for more than 90 days.

### Processing traffic

Processing traffic requires:  

- A successful initial usage report. If the initial report isn’t sent, NGINX Plus won’t process traffic until the report is sent successfully. To add a grace period, see [Postpone reporting enforcement](#postpone-reporting-enforcement).  
- Ongoing usage reports, at least every 180 days. If reporting stops, NGINX Plus keeps running but stops processing traffic once 180 days have passed without a report. To avoid disruption, send usage reports regularly instead of waiting until the 180-day cutoff.

---

## Download your license from MyF5 {#download-jwt}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

---

## Deploy the license {#deploy-jwt}

After you download the JWT license, deploy it to your NGINX Plus instances in one of two ways:

- **Use a group sync feature (recommended):**  
  - In the [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}}), use a **Config Sync Group** to keep instances consistent, avoid manual copying, and apply license updates automatically.  
  - In [NGINX Instance Manager]({{< ref "/nim/nginx-instances/manage-instance-groups.md" >}}), use an **instance group**, which works the same way as a Config Sync Group.  
- **Copy the license manually:** Place the license file on each NGINX Plus instance yourself.  

Both methods ensure your NGINX Plus instances have access to the required license file.  

Choose the option that fits your environment:  

<details>
<summary>Deploy with a group sync feature (recommended)</summary>

### Deploy with a group sync feature

<br>

{{< include "/licensing-and-reporting/deploy-jwt-with-csgs.md" >}}

{{< call-out "note" "" >}}
In NGINX Instance Manager, *instance groups* provide the same sync functionality as Config Sync Groups in the NGINX One Console.  
See [Manage instance groups]({{< ref "/nim/nginx-instances/manage-instance-groups.md" >}}) for setup instructions.
{{< /call-out >}}

</details>  

<details>
<summary>Deploy manually</summary>

### Deploy manually

<br>

Copy the JWT license file to each NGINX Plus instance.  

{{< include "/licensing-and-reporting/apply-jwt.md" >}}  

</details>

<details>
<summary>Use custom paths</summary>

### Custom paths {#custom-paths}

<br>

{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}

</details>

---

## Prepare your environment for reporting {#set-up-environment}

NGINX Plus R33 and later must send usage reports.  

Choose the setup steps that match your environment:

<details>
<summary>Configure reporting in internet-connected environments</summary>

### Internet-connected environments {#internet-connected}

<br>

In connected environments, NGINX Plus sends usage reports directly to the F5 licensing endpoint. 

<br>

Allow the necessary outbound traffic so reports can reach F5.

1. Allow NGINX Plus instances to connect to the F5 licensing endpoint (`product.connect.nginx.com`) over HTTPS (TCP `443`). Make sure the following IP addresses are allowed:

   - `3.135.72.139`  
   - `3.133.232.50`  
   - `52.14.85.249`  

1. *(R34 and later)* If your company restricts outbound traffic, configure NGINX Plus instances to connect through an outbound proxy. Update the [`proxy`](https://nginx.org/en/docs/ngx_mgmt_module.html#proxy) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of (`/etc/nginx/nginx.conf`) to point to your proxy server:

   ```nginx
   mgmt {
       proxy          PROXY_ADDR:PORT; # can be http or https
       proxy_username USER;            # optional
       proxy_password PASS;            # optional
   }
   ```

</details>

<details>
<summary>Configure reporting in network-restricted environments</summary>

### Network-restricted environments {#network-restricted}

<br>

In environments without internet access, NGINX Plus sends usage reports to NGINX Instance Manager. NGINX Instance Manager collects the reports and later forwards them to F5. 

<br>

To configure NGINX Plus to send usage reports to NGINX Instance Manager:

{{< include "/licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

<br>

{{< call-out "note" "Forwarding reports in network-restricted environments" >}} For instructions on forwarding usage reports from NGINX Instance Manager to F5, see [Report usage data to F5 (disconnected)]({{< ref "/nim/disconnected/report-usage-disconnected-deployment.md" >}}).{{< /call-out >}}


</details>

### Postpone reporting enforcement {#postpone-reporting-enforcement}

By default, NGINX Plus requires a successful initial usage report before it continues processing traffic.  

If you need to delay this requirement, you can set [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#enforce_initial_report) to `off`. This starts a 180-day grace period where NGINX Plus keeps running while it continues trying to report.

```nginx
# Modify this directive to start the 180-day grace period for initial reporting.
mgmt {
  enforce_initial_report off;
}
```

{{< call-out "important" "Important" >}}
After 180 days, if usage reporting still hasn’t been established,
NGINX Plus will stop processing traffic.
{{< /call-out >}}

---

## Update the license {#update-license}

How you update the JWT license depends on your NGINX Plus release and environment:

- In R35 and later, the license is updated automatically when the subscription renews (if reporting is configured).  
- In earlier releases or disconnected environments, you need to update the license manually.  

<details>
<summary>Update the license automatically (R35 and later)</summary>

### Automatic update (R35 and later) {#automatic-renewal}

<br>

Starting in NGINX Plus R35, [JWT licenses are updated automatically](#automatic-renewal) for instances that report directly to the F5 licensing endpoint. NGINX Plus downloads the new license and applies it without requiring a reload or restart.

Here’s how the automatic update works:  

- Beginning 30 days before the current license expires, NGINX Plus notifies the licensing endpoint as part of usage reporting.  
- The licensing endpoint checks for a renewed subscription with F5.  
- After the subscription is renewed, the licensing endpoint sends the updated JWT license to the instance.  
- NGINX Plus applies the updated license automatically and stores it as **nginx-mgmt-license** in the [`state_path`](https://nginx.org/en/docs/ngx_mgmt_module.html#state_path) directory.  
- The original JWT license file at `/etc/nginx/license.jwt` (or a custom path set by [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token)) is not modified. You can replace the original file manually if needed, but this does not affect NGINX Plus operation.  
- This process also applies if the license has already expired but is still within the 90-day grace period.  
- Traffic continues without interruption.  

{{< call-out "important" "Important" >}}  
Automatic updates only work if:  
- License reporting is configured, and  
- At least one usage report has already been sent successfully.  

If these conditions aren’t met, you must [update the JWT license manually](#manually-update-license).  
{{< /call-out >}}

</details>

<details>
<summary>Update the license manually (all releases)</summary>

### Manual update (all releases) {#manually-update-license}

<br>

If automatic updates are not available (for example, in disconnected environments), update the license manually:

1. [Download the new JWT license](#download-jwt) from MyF5.  
2. [Deploy the JWT license](#deploy-jwt) to your NGINX Plus instances.

</details>

---

## Error log location and monitoring {#log-monitoring}

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}

---

## Reported usage metrics {#usage-metrics}

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

---

## What's Next

- [Watch instructional videos]({{< ref "/solutions/about-subscription-licenses/instructional-videos.md" >}}) on how to upgrade to R33 or later, and how to submit usage reports