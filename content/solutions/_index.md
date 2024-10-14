---
title: "NGINX Plus R33: Pre-release guidance for automatic upgrades"
type: "r33-pre-release"
noindex: true
docs: 
tags:
- docs
toc: true
weight: 1
---

## What to know before upgrading to NGINX Plus R33

### What's new

Starting with NGINX Plus R33, expected in **Q4 of 2024**, all **NGINX Plus instances will require a valid JSON Web Token (JWT).**

This requirement is part of F5’s broader licensing program and aligns with industry best practices. The JWT will streamline subscription renewals and usage reporting, helping you manage your NGINX Plus subscription more efficiently. The [telemetry data](#telemetry) we collect helps us improve our products and services to better meet your needs.

The JWT is required for **validating your subscription** and **reporting telemetry data**. For environments connected to the internet, telemetry is automatically sent to F5’s licensing endpoint. In offline environments, telemetry is routed through [NGINX Instance Manager]({{< relref "/nms/nim" >}}).

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

1. Log in to [MyF5](https://my.f5.com/manage/s/).
2. Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
3. Find your NGINX products or services subscription, and select the **Subscription ID** for details.
4. Download the **JSON Web Token (JWT)** from the subscription page.

### Apply the JWT

1. Apply the JWT to `/etc/nginx/license.jwt` on each NGINX Plus instance.

##### Custom paths:

If you plan to use a custom path for the JWT, note that **custom paths won’t work until after the R33 upgrade**. You’ll need to create a placeholder file at `/etc/nginx/license.jwt` **before upgrading**.

1. **Before upgrading**: Create the placeholder file by running:

   ```bash
   touch /etc/nginx/license.jwt
   ```

2. **After upgrading**: Update the `license_token` directive in the NGINX configuration [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block to point to your custom path:

   ```nginx
   mgmt {
     license_token <custom_path>;
   }
   ```

### Set up your network for reporting {#configure-network}

To ensure NGINX Plus R33 can report telemetry data, follow these steps based on your environment:

#### For internet-connected environments:

1. **Open port 443**:  
   Allow outbound HTTPS traffic on TCP port 443 to communicate with F5's licensing endpoint (`product.connect.nginx.com`). Ensure that the following IP addresses are allowed:

   - `3.135.72.139`
   - `3.133.232.50`
   - `52.14.85.249`

#### For partially connected environments:

1. **Open port 443 for NGINX Instance Manager**:  
   Ensure NGINX Plus can connect to NGINX Instance Manager to report usage data. If NGINX Instance Manager has internet access, it will automatically send the usage data to F5.

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

NGINX Plus reports the following data every hour by default:

- **NGINX version and status**: The version of NGINX Plus running on the instance.
- **NGINX App Protect version and status**: The version of NGINX App Protect running on the instance.
- **Instance UUID**: A unique identifier for each NGINX Plus instance.
- **Traffic data**:
  - **Bytes received from and sent to clients**: HTTP and stream traffic volume between clients and NGINX Plus.
  - **Bytes received from and sent to upstreams**: HTTP and stream traffic volume between NGINX Plus and upstream servers.
  - **Client connections**: The number of accepted client connections (HTTP and stream traffic).
  - **Requests handled**: The total number of HTTP requests processed.
- **NGINX uptime**: The number of reloads and worker connections during uptime.
- **Usage report timestamps**: Start and end times for each usage report.
- **Kubernetes node details**: Information about Kubernetes nodes in deployments involving NGINX Ingress Controller or NGINX Gateway Fabric.

### Security and privacy of reported data

All communication between your NGINX Plus instances, NGINX Instance Manager, and F5’s licensing endpoint (`product.connect.nginx.com`) is protected using **SSL/TLS** encryption.

Only **operational metrics** are reported — no **personally identifiable information (PII)** or **sensitive customer data** is transmitted.
