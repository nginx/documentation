---
title: "R33 pre-release guidance for automatic upgrades"
docs: 
tags:
- docs
toc: true
weight: 1
cascade:
type: r33-pre-release
---

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

Complete these steps **before** NGINX R33 releases to prepare your systems.

## Add the JWT license {#add-jwt}

Before you install or upgrade to NGINX Plus R33 or later, make sure to:

### Download the license from MyF5 {#download-jwt}
    
{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

### Copy the license to each NGINX Plus instance

{{< include "licensing-and-reporting/apply-jwt.md" >}}

#### Custom paths: {#custom-paths}

{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}

---

## Set up your network for reporting {#configure-network}

To ensure NGINX Plus R33 can report telemetry data, follow these steps based on your environment:

### For internet-connected environments:

{{< include "licensing-and-reporting/configure-internet-connected-environment.md" >}}

### For network-restricted environments

In environments where NGINX Plus instances cannot access the internet, you'll need NGINX Instance Manager to handle usage reporting.

#### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus R33 or later to report usage data to NGINX Instance Manger:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

#### Submit usage reports to F5 from NGINX Instance Manager

- **Internet-connected**: If NGINX Instance Manager is connected to the internet, see [Report usage to F5]({{< relref "nim/admin-guide/license/report-usage-connected-deployment.md" >}}) for instructions.
- **Network-restricted**: If NGINX Instance Manager cannot access the internet, follow the steps in [Report usage to F5 in a network-restricted environment]({{< relref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).

### Handling outages

If a temporary outage occurs, either on your side or F5’s:

- As long as your instance has successfully reported at least once, you’ll have a **180-day grace period** to resolve the issue.  
  During this grace period, NGINX Plus will continue running without any restrictions.

---

## What’s reported {#telemetry}

{{< include "licensing-and-reporting/reported-usage-data.md" >}}
