---
title: "Report usage data to F5"
date: 2024-10-14T11:29:57-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 10
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1650"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

## Overview

In environments where NGINX Instance Manager has internet access but NGINX Plus doesn’t, NGINX Plus sends usage data to NGINX Instance Manager. NGINX Instance Manager will automatically send the usage reports to F5 for verification, or you can choose to send them manually.

**If usage reporting fails, NGINX Plus will stop processing traffic.** There's an exception for previously reported instances — refer to [handling outages](#handling-outages) for more details.

See the steps below to configure NGINX Plus to report usage data to NGINX Instance Manager and how to submit the report to F5 for verification.

{{<call-out "tip" "For network-restricted environments:" "" >}}If your deployment of NGINX Instance Manager doesn’t allow internet access, follow the steps in [Report usage data in network-restricted environments]({{< relref "nim/disconnected/report-usage-disconnected-deployment.md" >}}) to report usage data to F5.{{</call-out>}}

---

## Before you begin

Before submitting usage data to F5, first ensure that the appropriate network ports are open for NGINX Instance Manager to report to F5, and then configure NGINX Plus to report telemetry data to NGINX Instance Manager.

### Configure network ports for reporting usage

To allow NGINX Instance Manager to report usage data to F5, make sure port `443` is open for these URLs:

- `https://product.apis.f5.com/`
- `https://product-s.apis.f5.com/ee`

### Configure NGINX Plus to report usage to NGINX Instance Manager

To configure NGINX Plus (R33 and later) to report usage data to NGINX Instance Manger:

{{< include "licensing-and-reporting/configure-nginx-plus-report-to-nim.md" >}}

---

## Submit usage report to F5

### Automatic reporting

When you [add your JSON Web Token (JWT)]({{< relref "nim/admin-guide/license/add-license.md" >}}) to NGINX Instance Manager, usage reporting is enabled by default.

NGINX Instance Manager will automatically report subscription entitlement and usage data to F5 if internet access is available.

### Manual reporting

{{<call-out "important" "Usage reporting requirement:" "fa-solid fa-exclamation-triangle" >}}You need to report usage to F5 regularly. **If usage isn’t reported for 180 days, NGINX Plus will stop processing traffic**. For more details about the usage reporting process, see [About subscription licenses]({{< relref "solutions/about-subscription-licenses.md" >}}).{{</call-out>}}

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