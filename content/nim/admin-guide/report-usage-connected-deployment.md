---
title: Report usage data to F5 (connected)
draft: false
description: ''
weight: 20
toc: true
docs: DOCS-1650
personas:
- devops
- netops
- secops
- support
type:
- how-to
---

{{< note >}}For disconnected environments, see [Report usage data to F5 (disconnected)]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).{{< /note >}}

## Overview

In environments where NGINX Instance Manager has internet access but NGINX Plus doesn’t, NGINX Plus sends usage data to NGINX Instance Manager. NGINX Instance Manager will automatically send the usage reports to F5 for verification, or you can choose to send them manually.

**If usage reporting fails, NGINX Plus will stop processing traffic.** There's an exception for previously reported instances — refer to [handling outages](#handling-outages) for more details.

See the steps below to configure NGINX Plus to report usage data to NGINX Instance Manager and how to submit the report to F5 for verification.

---

## Before you begin

Before submitting usage data to F5, first ensure that the appropriate network ports are open for NGINX Instance Manager to report to F5, and then configure NGINX Plus to report telemetry data to NGINX Instance Manager.

### Configure network ports for reporting usage

To allow NGINX Instance Manager to report usage data to F5, make sure port `443` is open for these URLs:

- `https://product.apis.f5.com/`
- `https://product-s.apis.f5.com/ee`

### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus (R33 and later) to report usage data to NGINX Instance Manager:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

---

## Submit usage report to F5

### Automatic reporting

When you [add your JSON Web Token (JWT)]({{< ref "nim/admin-guide/add-license.md" >}}) to NGINX Instance Manager, usage reporting is enabled by default.

NGINX Instance Manager will automatically report subscription entitlement and usage data to F5 if internet access is available.

### Manual reporting

{{<call-out "important" "Usage reporting requirement:" "fa-solid fa-exclamation-triangle" >}}You need to report usage to F5 regularly. **If usage isn’t reported for 180 days, NGINX Plus will stop processing traffic**. For more details about the usage reporting process, see [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}).{{</call-out>}}

If you prefer submitting usage reports to F5 manually, follow these steps:

1. Log in to the NGINX Instance Manager web interface (`https://<NIM-FQDN>/ui/`).
2. Select the **Settings** (gear) icon.
3. On the **Licenses > Overview** page, turn off **Enable Continuous Connection**.
4. To manually submit a usage report, select **Send Usage to F5**.

---

## What's reported

{{< include "licensing-and-reporting/reported-usage-data.md" >}}

---

## Error log location and monitoring {#log-monitoring}

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}
