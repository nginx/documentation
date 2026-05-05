---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NONECO
title: Find a security event by Support ID
description: "Look up an F5 WAF for NGINX security event in NGINX One Console using its Support ID."
weight: 500
toc: true
f5-keywords: "support ID, security event, F5 WAF for NGINX, security dashboard, event lookup, Support ID Details, getSecurityEvent, listSecurityEvents, WAF block, rejection page, triage, 90-day retention"
f5-summary: >
  Use the Support ID Details page in NGINX One Console to look up a single F5 WAF for NGINX security event by its Support ID.
  This is the fastest way to drill from a customer report, an upstream log line, or an alert into the full WAF event record.
  This guide covers what a Support ID is, where to find one, and how to use the lookup page.
f5-audience: operator
---

## Overview

Use the Support ID Details page in NGINX One Console to look up a single F5 WAF for NGINX security event by its Support ID. F5 WAF for NGINX assigns a unique Support ID to every inspected request, and that ID travels through every system that touches the request: security logs, NGINX access logs, upstream application logs, and the security monitoring dashboard.

Use this page when you already know the ID of the event you want to inspect — for example, from a customer support case, a raw F5 WAF for NGINX log line, an alert payload, or an upstream application that captured the ID from a request header. To explore events without a known ID, use the Event Logs tab on the [security monitoring dashboard]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md#event-logs-tab" >}}) instead.

---

## Before you begin

Before you begin, ensure you have:

- **A Support ID**: A numeric Support ID for the event you want to inspect. See [Where to find a Support ID](#where-to-find-a-support-id) below.
- **Security monitoring set up**: F5 WAF for NGINX security events must already be flowing into NGINX One Console for the event to be available. See [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}}).

---

## Look up an event by Support ID

1. In NGINX One Console, go to **WAF** > **Support ID Details**.
2. Paste the Support ID into the **Enter a Support ID** field.
3. The page displays the **Security Event** detail panel for the matching event, including the request, source, and raw request data.

   {{< call-out "note" >}}Security events are retained for 90 days. Events older than 90 days are no longer available.{{< /call-out >}}

### Troubleshooting

If no event is found, the most likely causes are:

- The Support ID does not belong to a WAF-inspected request
- The event is older than the 90-day retention window
- The Support ID was mistyped

---

## What the detail panel shows

The Security Event detail panel surfaces every field stored on the event:

- **Request** — request method, URI, host, headers, and the **Raw Request** payload as captured by F5 WAF for NGINX. The raw request is the same payload that would appear in a NAP security log on the data plane.
- **Source** — client IP, X-Forwarded-For chain, and a geolocation map showing the country derived from the client IP.
- **Time of Request** — when F5 WAF for NGINX produced the event.
- **Triggered violations and signatures** — every violation and signature that fired on the event, with their full attributes (name, accuracy, risk, CVE, context).
- **Threat campaigns** — any threat campaigns matched by the event.
- **Policy and outcome** — the F5 WAF for NGINX policy that produced the event, the request status (`blocked`, `alerted`, or `passed`), and the outcome reason.

---

## Where to find a Support ID

A Support ID can come from any system that observed the request:

- **NGINX One Console Event Logs tab** — every row in the Event Logs table on the [security dashboard]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md#event-logs-tab" >}}) includes the Support ID. Copy a Support ID from there to share in a ticket, support case, or follow-up message.
- **F5 WAF for NGINX security logs on the data plane** — the Support ID is the first field in every log line emitted by the [`secops_dashboard` log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}}).
- **F5 WAF for NGINX rejection page** — when F5 WAF for NGINX blocks a request, the response page typically includes the Support ID so the user can quote it back to support.
- **Customer support cases** — end users who hit a Request Rejected page can be asked to provide the Support ID from that page.

---

## Use cases

### Operator: triage a customer-reported block

A customer reports that their request was rejected and provides the Support ID from the rejection page. The operator opens **WAF** > **Support ID Details**, pastes the ID, and sees the full event record, including which signature fired and which policy was in effect — enough to decide whether the block was a true positive or a candidate for policy tuning.

### Security engineer: correlate an upstream incident with WAF activity

An upstream service surfaces an incident referencing a Support ID extracted from request headers. The engineer pastes the ID into the Support ID Details page to see whether the request was blocked, alerted, or passed by F5 WAF for NGINX, and which violations or signatures it triggered, before deciding whether the incident is WAF-related.

---

## Querying by Support ID through the API

The same lookup is available through the analytics API. Use the [`getSecurityEvent`]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getSecurityEvent" >}}) operation to fetch a single event, or [`listSecurityEvents`]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listSecurityEvents" >}}) with `support_id` in `filter_fields` to look up by Support ID programmatically.

For more on querying events through the API, see [Query security events through the API]({{< ref "/nginx-one-console/api/query-events-api.md" >}}).

---

## References

For more information, see:

- [Security dashboard reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}})
- [Query security events through the API]({{< ref "/nginx-one-console/api/query-events-api.md" >}})
- [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}})
