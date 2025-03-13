---
title: R33 pre-release guidance for automatic upgrades
weight: 1
toc: true
noindex: true
type: []
draft: true
type: concept
product: Solutions
docs: DOCS-000
---

{{<call-out "caution" "NGINX R33: Immediate action required for automatic upgrades" "fa-solid fa-triangle-exclamation" >}}
NGINX Plus R33 requires a valid JSON Web Token (JWT) to start and accept new connections. 
<br>
If automatic upgrades are enabled, apply the JWT and configure your network <strong>now</strong> to avoid downtime when R33 is released. 
{{</call-out>}}

## What to know before upgrading to NGINX Plus R33

### What's new

Starting with NGINX Plus R33, expected in **Q4 of 2024**, all **NGINX Plus instances will require a valid JSON Web Token (JWT)**. The JWT is tied to your subscription, not individual instances, and is used to **validate your subscription** and **report telemetry data**. In internet-connected environments, telemetry is sent to F5’s licensing endpoint. In offline environments, telemetry is routed through [NGINX Instance Manager]({{< relref "/nim" >}}).

This change is part of F5's broader licensing program, designed to make subscription renewals and usage reporting easier. The [telemetry data](#telemetry) helps us improve our products and services to better meet your needs.

##### What this means for you

If you’ve enabled automatic upgrades, you need to act **before** NGINX Plus R33 releases to ensure a smooth upgrade:

- [**Download and apply a valid JSON Web Token (JWT)**](#jwt) to each NGINX Plus instance.  
  **Without this token, NGINX Plus won’t start**, and the upgrade won’t complete.

- [**Configure your network**](#configure-network) to allow NGINX Plus to report telemetry data.  
  **If telemetry reporting fails, NGINX Plus will stop accepting new connections**.  
  There’s an exception for previously reported instances — refer to [handling outages](#handling-outages) for more details.

Follow the [pre-release steps](#steps) below to complete the process.

##### Impacts to NGINX Ingress Controller

- **Don’t upgrade to NGINX Plus R33 until the next version of NGINX Ingress Controller is released.**  
  NGINX Plus R33 isn’t compatible with NGINX Ingress Controller v3.7.0.

##### Impacts to previous NGINX Plus versions

- **No action needed**:  
  If you use NGINX Plus before R33 and haven’t enabled automatic upgrades, no action is required.
---

## Pre-release action items for NGINX Plus R33 {#steps}

Complete these steps **before** NGINX R33 releases to prepare your systems.

### Download the JWT from MyF5 {#jwt}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

### Apply the JWT

{{< include "licensing-and-reporting/apply-jwt.md" >}}

##### Custom paths:

{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}


### Set up your network for reporting {#configure-network}

To ensure NGINX Plus R33 can report telemetry data, follow these steps based on your environment:

#### For internet-connected environments:

1. **Open port 443**:  
   Allow outbound HTTPS traffic on TCP port 443 to communicate with F5's licensing endpoint (`product.connect.nginx.com`). Ensure that the following IP addresses are allowed:

   - `3.135.72.139`
   - `3.133.232.50`
   - `52.14.85.249`

#### For partially connected environments:

1. On each NGINX Plus instance, update the `usage_report` directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX configuration (**/etc/nginx/nginx.conf**) to point to your NGINX Instance Manager host:

   ``` nginx
   usage_report endpoint=<NGINX_INSTANCE_MANAGER_HOST_FQDN> interval=1hr;
   ```

1. **Open port 443 for NGINX Instance Manager**:  
   Ensure NGINX Plus can connect to NGINX Instance Manager to report usage data.

If NGINX Instance Manager has internet access, it will automatically report usage data to F5. If it doesn't doesn't have internet access, you can manually [submit usage reports to F5 for verification and acknowledgement]({{< relref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).


#### For fully disconnected environments:

Starting with **NGINX Instance Manager 2.18** (**coming soon**), you’ll be able to manually export usage reports for fully disconnected environments. You will need to:

1. **Export the usage report**: Manually export the usage report from NGINX Instance Manager.
2. **Send the report to F5**: Submit the report to F5 for verification from a location with internet access.
3. **Upload the acknowledgment**: After verification, upload the acknowledgment from F5 to NGINX Instance Manager.

### Handling outages

If a temporary outage occurs, either on your side or F5’s:

- As long as your instance has successfully reported at least once, you’ll have a **180-day grace period** to resolve the issue.  
  During this grace period, NGINX Plus will continue running without any restrictions.

---

## What’s reported and how it’s protected {#telemetry}

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

### Security and privacy of reported data

All communication between your NGINX Plus instances, NGINX Instance Manager, and F5’s licensing endpoint (`product.connect.nginx.com`) is protected using **SSL/TLS** encryption.

Only **operational metrics** are reported — no **personally identifiable information (PII)** or **sensitive customer data** is transmitted.
