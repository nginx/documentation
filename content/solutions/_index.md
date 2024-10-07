---
title: "NGINX Plus R33: Pre-release guidance for automatic upgrades"
type: "r33-pre-release"
---

## What to know before upgrading to NGINX Plus R33

### What's new

NGINX Plus R33, expected in **late October or early November 2024**, introduces a breaking change: **all commercial instances now require a valid JSON Web Token (JWT)**.

This JWT is tied to your NGINX Plus subscription and serves two purposes: **validating your subscription** and **reporting telemetry data**. In internet-connected environments, telemetry is sent to the F5 licensing endpoint; for offline environments without internet access, telemetry is sent to NGINX Instance Manager. 

Unlike individual licenses tied to one service, this JWT supports multiple services under one subscription, offering more flexibility.

##### What does this mean for you?

This change requires action if you've enabled automatic upgrades.

Take these steps **before** the R33 release to ensure a successful upgrade:

- Download and apply a valid JSON Web Token (JWT) to each NGINX Plus instance. Without the token, NGINX Plus **won’t start** and the upgrade may fail.
- Configure your network so NGINX Plus can connect to the licensing endpoint to validate the JWT and report telemetry data. If reporting or validation fails, NGINX Plus will **stop accepting new connections**.

Follow the pre-release steps below to complete the process.

##### Impacts to NGINX Ingress Controller

- **Do not upgrade to NGINX Plus R33 until the next version of NGINX Ingress Controller is released.** R33 is not compatible with NGINX Ingress Controller v3.7.0.

##### Impacts to previous NGINX Plus versions

- **No action needed**: If you’re using an NGINX Plus version before R33 and don’t have automatic upgrades enabled in your production environment, no action is required.

## Pre-release action items for NGINX Plus R33

Complete the following steps **before** R33 is released to ensure your systems are ready for the upgrade.

### Download the JWT from MyF5

1. Log in to [MyF5](https://my.f5.com/manage/s/).
2. Go to **My Products & Plans > Subscriptions** to view your active subscriptions.
3. Find the subscription for your NGINX products or services, and select the **Subscription ID** for details.
4. Download the **JSON Web Token** from the subscription page.

### Apply the JWT

1. Apply the JWT to `/etc/nginx/license.jwt` on each NGINX Plus instance.

##### **For custom paths**: 

If you plan to use a custom path for the JWT, you still need to create a placeholder file at `/etc/nginx/license.jwt` for the upgrade to proceed. Custom paths won’t work until **after** the R33 upgrade.

1. **Before upgrading**: Create the placeholder file by running:

   ```bash
   touch /etc/nginx/license.jwt
   ```

2. **After upgrading**: Update the `license_token` directive in the NGINX configuration [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block to point to your custom path.

   ```nginx
   mgmt {
   license_token <custom_path>;
   }
   ```

### Configure your network for reporting

Ensure NGINX Plus R33 can report telemetry data and validate the JWT, based on your environment:

#### For internet-connected environments:

1. **Open port 443**: Allow outbound HTTPS traffic on TCP port 443 for communication with the F5 licensing endpoint (`product.connect.nginx.com`). Ensure the following IP addresses are allowed:

     - `3.135.72.139`
     - `3.133.232.50`
     - `52.14.85.249`

#### For partially connected environments:

1. **Open port 443 for NGINX Instance Manager**: Ensure NGINX Plus can communicate with NGINX Instance Manager to validate the JWT. If Instance Manager has internet access, it will automatically report licensing and usage data to F5.

#### For fully disconnected environments:

- Starting with **NGINX Instance Manager 2.18**, you can manually export the JWT validation report for environments without internet access.

## Enabling the 180-day grace period

**After upgrading to R33, NGINX Plus will stop accepting new connections if telemetry reporting fails**.

To allow more time to configure reporting, you can enable a 180-day grace period by setting the `enforce_report_on_start` directive to `off`. This allows NGINX Plus to keep accepting connections during that time. **After 180 days, if reporting is still not configured, NGINX Plus will no longer accept new connections.**

To enable the 180-day grace period:

1. Open the NGINX configuration file at `/etc/nginx/nginx.conf`.
2. In the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block, set the `enforce_report_on_start` directive to `off`:

      ```nginx
      mgmt {
          enforce_report_on_start off;
      }
      ```

3.	Save the file.
4.	Restart or reload NGINX to apply the configuration changes:

      ``` bash
      sudo systemctl restart nginx
      ```

      or

      ``` bash
      sudo systemctl reload nginx
      ```

