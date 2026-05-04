---
title: Report usage data to F5 (connected)
description: "Configure NGINX Plus to report usage data to F5 NGINX Instance Manager, and submit the report to F5 for verification in a connected (internet-accessible) environment."
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
nd-summary: >
  Configure NGINX Plus to report usage data to F5 NGINX Instance Manager, which then forwards the report automatically to F5 in a connected environment.
  This setup is used when NGINX Plus instances don't have direct internet access but NGINX Instance Manager does.
---

{{< call-out "note" >}}For disconnected environments, see [Report usage data to F5 (disconnected)]({{< ref "nim/licensing-and-reporting/report-usage-disconnected-deployment.md" >}}).{{< /call-out >}}

## Overview

In environments where F5 NGINX Instance Manager has internet access but NGINX Plus doesn't, NGINX Plus sends usage data to NGINX Instance Manager. NGINX Instance Manager automatically sends the usage reports to F5 for verification, or you can send them manually.

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

{{< include "licensing-and-reporting/nim-service-log-location.md" >}}

Monitor the following log prefixes to identify issues with automatic usage reporting to F5.

**`[INT-NC]`** — usage report polling and submission:

```text
[error] [INT-NC] failed to get pending count: <error>
[error] [INT-NC] failed to process NC usage batch: <error>
[info]  [INT-NC] successfully processed NC usage batch
[error] [INT-NC] failed to upsert telemetry event: <error>
[info]  [INT-NC] stopping NC usage subscriber (context done)
```

**`[AIDF-SUB]`** — usage message processing:

```text
[error] [AIDF-SUB] corrupted proto msg[<i>]: <error>; terminating message
[error] [AIDF-SUB] msg[<i>] missing jwt_token; terminating unprocessable message
[warn]  [AIDF-SUB] no valid reports after parsing <n> messages
[error] [AIDF-SUB] failed to create NC client for jwt group: <error>
[warn]  [AIDF-SUB] NC submission failed for chunk <start>-<end>: <error>
[error] [AIDF-SUB] failed to ack msg after NC success: <error>
[warn]  [AIDF-SUB] completed with <n> errors: <errors>
[info]  [AIDF-SUB] successfully processed <n> valid messages
```

**`[NC-POST]` / `[NC-RETRY]`** — HTTP communication with F5:

```text
[info]  [NC-POST]  NC response status=<code> batch_size=<n>
[warn]  [NC-RETRY] retrying after error: <error> wait=<duration>
[error] [NC-SUBMIT] failed to convert report <i>: <error>
```

**`[AIDF-PUB]`** — usage data publishing from the data plane manager:

```text
[error] [AIDF-PUB] failed to marshal proto report: <error>
[error] [AIDF-PUB] failed to publish proto report: <error>
[info]  [AIDF-PUB] published proto report seq=<n> nginx_version=<ver>
```

{{< include "licensing-and-reporting/log-location-and-monitoring.md" >}}
