---
title: Report usage data to F5 (connected)
description: "Configure NGINX Plus to report usage data to NGINX Instance Manager, and submit the report to F5 for verification in a connected (internet-accessible) environment."
weight: 20
toc: true
nd-docs: DOCS-1650
nd-personas:
- devops
- netops
- secops
- support
nd-content-type: how-to
nd-product: NIMNGR
---

{{< call-out "note" >}}For disconnected environments, see [Report usage data to F5 (disconnected)]({{< ref "nim/licensing-and-reporting/report-usage-disconnected-deployment.md" >}}).{{< /call-out >}}

## Overview

In environments where NGINX Instance Manager has internet access but NGINX Plus doesn't, NGINX Plus sends usage data to NGINX Instance Manager. NGINX Instance Manager automatically sends the usage reports to F5 for verification, or you can send them manually.

**If usage reporting fails, NGINX Plus stops processing traffic.** Previously reported instances are an exception — see [handling outages](#handling-outages) for details.

Use the steps below to configure NGINX Plus to report usage data to NGINX Instance Manager and submit the report to F5 for verification.

---

## Before you begin

Before submitting usage data to F5, open the required network ports and configure NGINX Plus to report to NGINX Instance Manager.

### Configure network ports for reporting usage


#### NGINX Instance Manager 2.22 and later

Open port 443 for `https://product.connect.nginx.com/api/nginx-usage/batch`.

{{< call-out "important" >}}
   There is no [Manual reporting]({{< ref "/nim/licensing-and-reporting/report-usage-connected-deployment.md#manual-reporting" >}}) option for connected mode in NGINX Instance Manager 2.22 and later versions (The "licensing page", "Enable Continuous Connection" toggle and "Send Usage to F5" button are not available).
   {{< /call-out >}}

#### NGINX Instance Manager 2.21 and earlier

Open port `443` for these URLs:

- `https://product.apis.f5.com/`
- `https://product-s.apis.f5.com/ee`

### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus (R33 and later) to report usage data to NGINX Instance Manager:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

---

## Submit usage report to F5

### Automatic reporting

When you [add your JSON Web Token (JWT)]({{< ref "nim/licensing-and-reporting/add-license-connected-deployment.md" >}}) to NGINX Instance Manager, usage reporting is enabled by default. NGINX Instance Manager automatically reports subscription entitlement and usage data to F5.

### Manual reporting

{{<call-out "important" "Usage reporting requirement:" "fa-solid fa-exclamation-triangle" >}}Report usage to F5 regularly. **If usage isn't reported for 180 days, NGINX Plus stops processing traffic**. See [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}) for details.{{</call-out>}}

To submit usage reports manually:

1. Log in to NGINX Instance Manager (`https://<NIM_FQDN>/ui/`).
1. Select the **Settings** (gear) icon.
1. On the **Licenses > Overview** page, turn off **Enable Continuous Connection**.
1. Select **Send Usage to F5**.

---

## What's reported

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

---

## Error log location and monitoring {#log-monitoring}

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}
