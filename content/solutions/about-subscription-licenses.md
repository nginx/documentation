---
title: "About subscription licenses"
date: 2024-09-12T08:50:27-07:00
# Change draft status to false to publish doc
draft: true
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

## Overview

Starting with **NGINX Plus R33**, all NGINX Plus instances must use a **subscription token** (also known as a **JWT** or **JSON Web Token**) to validate their license and report usage data.

This secure file holds important details, like your license expiration date, and every NGINX Plus instance needs a valid, unexpired JWT to start and keep running.

We know this is a big change, but we’ve simplified the process to make your transition as smooth as possible. Here’s what you need to know:

### Key changes with NGINX Plus R33

- **License validation with JWT**: Every NGINX Plus instance now needs a JSON Web Token (JWT) for validation. This token includes key details like your subscription's expiration date and is checked at startup and during regular operation. If the JWT is missing or expired, NGINX Plus won't start. This new JWT-based model replaces older licensing methods, offering a more secure and consistent experience.

  - **90-day grace period**: If your JWT expired within the last 90 days, NGINX Plus keeps running but won't restart until you apply a valid token. This grace period gives you time to update the license without service interruptions.
- **Usage reporting**:
  - **Connected environments**: If your NGINX Plus instances have external internet connectivity, they will automatically report usage data directly to F5’s licensing endpoint at `product.connect.nginx.com`. Once configured, no manual action is required for usage reporting in these environments.
  - **Partially connected environments**: If your NGINX Plus instances do not have direct internet access, but your **NGINX Instance Manager** instance does, all NGINX Plus instances will communicate with NGINX Instance Manager. NGINX Instance Manager will then handle forwarding the usage data to F5.
  - **Disconnected environments**: In fully disconnected environments, where neither NGINX Plus instances nor NGINX Instance Manager have internet connectivity, usage reporting needs to be managed manually. NGINX Plus will collect the usage data locally, and you will need to export this data from NGINX Instance Manager. Once exported, the data must be uploaded to F5 from a machine with internet access.
  - **180-day grace period**: If usage data isn’t reported for an extended period, NGINX Plus enters a **180-day grace period**. During this time, NGINX Plus will continue to operate, but it will log errors to notify you that reporting needs to be restored. After 180 days, NGINX Plus will stop accepting new connections until reporting is restored. This grace period provides time to address any issues without immediate disruption to your service.
- **Preparation for upgrade**: 
  - **Download and install the new JWT**: Before upgrading to NGINX Plus R33, download and install the new JWT from **MyF5**. This simple step ensures your instances transition smoothly and keep running without interruption.
  - **Upgrade to NGINX Instance Manager 2.18**: If you're in a **disconnected environment**, NGINX Plus R33 requires NGINX Instance Manager 2.18 or later to manage license validation and usage reporting locally. Be sure to [install or upgrade NGINX Instance Manager]({{< relref "/nms/installation/upgrade-guide.md" >}}) to the latest version before proceeding with the R33 upgrade.

---

## Pre-release planning for existing customers

### Download the JWT

1. Visit [MyF5](https://my.f5.com/manage/s/) and log in with your credentials.
1. Go to **My Products & Plans > Subscriptions**, where you'll find all your active subscriptions.
1. Find the subscription associated with your NGINX products or services and select the **Subscription ID** to view its details, including the expiration date and status.
1. Select the **JSON Web Token** link to download the token.

### Apply the JWT

1. Apply the JWT to `/etc/nginx/license.jwt` on each NGINX Plus instance.
   - If you’re using a custom path, update the `auth_jwt_file` directive in the NGINX configuration `mgmt` block to point to the new location.

---

## Configure requirements for reporting

### Connected environments

To ensure smooth operation, make sure that HTTPS port `443` is open for communication with F5’s licensing endpoint at `product.connect.nginx.com`. This endpoint handles both license validation and usage reporting. NGINX Plus will automatically send usage data and validate your license, so you won’t need to take any further action once the port is configured.

### Disconnected environments

In disconnected environments, such as air-gapped networks, **NGINX Instance Manager** is used to manage both license validation and usage reporting. Depending on your environment’s connectivity, there are two scenarios to consider:

1. **NGINX Plus instances are disconnected, but NGINX Instance Manager has internet access**: 
   - In this case, all NGINX Plus instances will communicate with NGINX Instance Manager locally, and NGINX Instance Manager will forward usage data to F5.

2. **Both NGINX Plus instances and NGINX Instance Manager are disconnected**: 
   - If neither NGINX Plus nor NGINX Instance Manager has external connectivity, license and usage reporting must be handled manually. NGINX Instance Manager will collect usage data locally, and you’ll need to export this data and upload it to F5 from a machine with internet access.

Here's what you'll need to do:

1. **Install or upgrade to NGINX Instance Manager 2.18**: This version is required to handle license validation and usage reporting locally for NGINX Plus R33. Follow the steps in the [NGINX Instance Manager installation and upgrade guide]({{< relref "/nms/installation/vm-bare-metal/install-nim.md" >}}) to ensure everything is set up properly.

2. **Update the `usage_report` directive**: In your NGINX configuration, modify the `mgmt` block to point to your **NGINX Instance Manager** host. This ensures that NGINX Plus reports usage data locally.
   - Example configuration:
     ```nginx
     usage_report endpoint=<NGINX_INSTANCE_MANAGER_HOST_IP> interval=1hr;
     ```

3. **Manual report submission** (for fully disconnected environments): If both NGINX Plus instances and NGINX Instance Manager are disconnected, you will need to manually export the collected usage data and upload it to F5 from a machine with internet access. For detailed steps, refer to the [Reporting NGINX Plus Installation Counts for Compliance](https://docs.nginx.com/nginx-management-suite/nim/how-to/monitoring/count-nginx-plus-instances/) guide.

You’ll have up to **180 days** to configure reporting and submit the data before NGINX Plus stops accepting new connections.


---

## Management configuration block {#mgmt}

The **mgmt** block is automatically added to the NGINX configuration when you install **NGINX Plus R33**. This block manages both **license enforcement** and **usage reporting**.

By default, NGINX Plus sends usage data to F5’s licensing endpoint at `product.connect.nginx.com` every 60 minutes over a secure SSL connection. This ensures your subscription is compliant, and it tracks how your licenses are being used.

In **disconnected environments**, where NGINX Plus can’t communicate directly with F5, you’ll need to modify the `usage_report` directive to send usage data to your **NGINX Instance Manager** host. This ensures license validation and usage reporting can still be handled locally.

Here’s a sample configuration of the **mgmt** block:

```nginx
mgmt {
  usage_report endpoint=<HOST_IP> interval=1hr;
  resolver DNS_IP;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers DEFAULT;
  ssl_certificate client.pem;
  ssl_certificate_key client.key;
  ssl_trusted_certificate trusted_ca_cert.crt;
  ssl_verify on;
  ssl_verify_depth 2;
  uuid_file /var/lib/nginx/nginx.id;
  auth_jwt_file /etc/nginx/license.jwt;
  deployment_context conf/deployment;
  enforce_report_on_start off;
}
```

#### Key directives explained

- **auth_jwt_file**: This directive points to the JWT file for license validation. By default, it looks for the JWT in `/etc/nginx/license.jwt`.
- **usage_report**: Specifies where usage data is sent and how often it is reported. By default, data is sent to `product.connect.nginx.com` every 60 minutes.
- **ssl_certificate settings**: These ensure secure communication when NGINX Plus sends usage data.
- **enforce_report_on_start**: When set to `on`, NGINX will enforce a usage report at startup.

For disconnected environments, update the `usage_report` directive to point to your NGINX Instance Manager host.

---

## What's reported and how it's protected

With NGINX Plus R33, usage data is securely sent to F5 for licensing and subscription compliance. In **connected environments**, this data is automatically sent to `product.connect.nginx.com`, and in **disconnected environments**, it’s sent to **NGINX Instance Manager**.

Here’s what's reported at regular intervals (usually every hour):

- **NGINX version and status**: Information about which version of NGINX Plus you’re running and its current state.
- **Instance UUID**: A unique identifier for each NGINX Plus instance.
- **Bytes received/sent**: Details about how much traffic is being handled, both to and from clients and upstreams.
- **Client connections**: The number of active and past connections to your NGINX Plus instance.
- **Requests handled**: The total number of HTTP requests processed.
- **Kubernetes node details**: Information specific to NGINX Ingress Controller (NIC) deployments, like the relevant Kubernetes node details.

### Security and privacy of reported data

Security and privacy are top priorities for NGINX Plus. All reported data is **encrypted** and securely transmitted to F5. The data is limited to operational metrics—**no personally identifiable information (PII)** or sensitive customer data is included.

Communication between your NGINX Plus instances, NGINX Instance Manager, and F5’s licensing endpoint at `product.connect.nginx.com` is secured with **SSL/TLS encryption**. This ensures that only authorized systems can access the data during transmission, keeping your information safe from unauthorized access.



---

## Entitlement workflow

NGINX Plus R33 introduces a new **entitlement workflow** to help ensure that every instance is properly licensed and that usage data is reported. This workflow operates in the background to minimize disruptions and maintain continuous operation.

Here’s a breakdown of how the entitlement workflow checks your license and usage reporting:

<span style="display: inline-block; margin-top: 20px; margin-bottom: 0px;">
{{< img src="solutions/R33-state-flowchart.png" alt="R33 state flowchart">}}
</span>

#### In brief

1. **JWT check**: Each time NGINX Plus starts, it checks for a valid **JSON Web Token (JWT)** to confirm your subscription is active.
2. **Expiration check**: If the JWT is expired or missing, NGINX Plus won’t start. However, if the JWT has expired within the last 90 days, NGINX Plus will keep running and log warnings.
3. **90-day grace period for expired JWTs**: During this grace period, NGINX Plus continues running, but you’ll need to renew the token before restarting. After 90 days, it will stop accepting new connections.
4. **License and usage reporting**: NGINX Plus regularly checks whether it can connect to F5’s licensing endpoint or NGINX Instance Manager to report usage data.
5. **Bypass directive and 180-day grace period for reporting**: If the **bypass directive** is configured, NGINX Plus will continue operating for up to 180 days without reporting usage data. If reporting isn’t restored after 180 days, NGINX will stop accepting new connections.

---

## Grace periods

### Grace period for subscriptions

If your subscription expires, NGINX Plus has built-in safeguards to ensure continued operation while you update your license. Specifically, there’s a **90-day grace period** after your subscription expires, during which NGINX Plus will continue to operate.

Here’s how it works:

- **Existing connections** will remain active throughout the grace period.
- **New connections** will still be accepted during this time, but once the grace period ends, NGINX Plus will stop accepting new connections.

To avoid any disruptions, it's important to renew your subscription and download a new JWT before the grace period ends. After the grace period, NGINX Plus will no longer restart without a valid JWT, so be sure to update your license in time.

### Grace period for usage reporting

When NGINX Plus is unable to report usage data, it enters a **180-day grace period**. This allows you time to restore reporting without causing immediate disruptions to your services.

During this grace period:

- **NGINX Plus will continue to operate**, but it will log critical errors indicating the need to restore reporting.
- You’ll have **180 days** to resolve the issue before NGINX Plus stops accepting new connections.

It’s important to address the issue as soon as possible. Once reporting is restored, NGINX Plus will resume normal operation and reset the grace period.

---

## Trial licenses

If you're evaluating NGINX Plus, a **trial JWT** is provided. The trial JWT functions similarly to a standard subscription, but with a **shorter expiration period**. Even during the trial, NGINX Plus reports usage data to F5 to help you stay compliant.

Key points about trial licenses:

- **Trial duration**: Trial licenses typically last 30 days. You’ll need to convert the trial to a paid subscription before it expires to avoid disruptions.
- **Usage reporting**: During the trial period, usage reporting is still required. However, enforcement might be more lenient, allowing you to evaluate NGINX Plus without strict interruptions.

Make sure to convert your trial to a full subscription to continue using NGINX Plus after the trial period ends. This will ensure uninterrupted service and compliance with subscription requirements.

---

## Special scenarios and exemptions

There are some cases where reporting and license enforcement work a little differently. Let’s walk through the exceptions so you know what to expect:

- **Trial mode**: If you're evaluating NGINX Plus, usage reporting is still required, but enforcement is more flexible. Trial licenses typically last for 30 days, and after that, you'll need to switch to a full subscription.
  
- **Marketplace customers**: If you're using NGINX Plus through a cloud marketplace (like **NGINX for Azure**), reporting requirements might vary. Be sure to check your specific platform’s guidelines.

- **Internal use**: For environments set up for **development**, **testing**, or **CI/CD pipelines**, reporting can be disabled since these environments aren't typically tied to a commercial license.

In each of these cases, be sure to follow the specific guidelines for your deployment to avoid any unexpected issues.