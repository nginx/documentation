---
nd-content-type: reference
nd-docs: DOCS-000
nd-product: NONECO
title: Query security events through the API
description: "List F5 WAF for NGINX security events and run analytics queries through the NGINX One Console API."
weight: 600
toc: true
nd-keywords: "security events API, analytics API, F5 WAF for NGINX, app-protect, NGINX One Console API"
nd-summary: >
  Use the NGINX One Console API to list F5 WAF for NGINX security events and run analytics queries against the same data store the security dashboard uses.
  This article lists the available operations and points to the API reference for request and response details.
  The same filter fields and group-by dimensions used by the dashboard apply to every operation here.
nd-audience: developer
---

## Overview

You can use the NGINX One Console API to query F5 WAF for NGINX security events programmatically. The API exposes the same security event store the security monitoring dashboard reads from, so any view you can build in the dashboard can also be reproduced through the API. Use the API to integrate WAF activity into your own dashboards, automated reports, Security Information and Event Management (SIEM) enrichment pipelines, or alerting workflows.

For the full request and response schema of each operation, including the supported filter fields and group-by dimensions, see the [API reference guide]({{< ref "/nginx-one-console/api/api-reference-guide.md" >}}).

## Events

Use these operations to list security events and retrieve a single event by ID.

- [List security events]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listSecurityEvents" >}})
  - Returns a paginated list of F5 WAF for NGINX security events. Accepts `filter_fields` to narrow results by any of the documented filter fields, a time range for the query window, and standard pagination parameters.
- [Get security event details]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getSecurityEvent" >}})
  - Returns the full detail for a single security event by ID, including all triggered violations, all triggered signatures, threat campaign matches, and the raw matched request when available.

---

## Attack analytics

Use these operations to count security events grouped by event-level dimensions.

- [Query attack analytics]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/queryAttackAnalytics" >}})
  - Returns event counts grouped by an event-level dimension (`request_status`, `ip`, `country`, `policy`, `url`, `hostname`, and others). Supports filter fields, time range, group-by, and limit.
- [Query attack analytics time series]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/queryAttackAnalyticsTimeSeries" >}})
  - Returns the same counts bucketed over time. Use this to drive time-series widgets and trend reports.

---

## Signature analytics

Use these operations to count security events grouped by attributes of the signatures that fired on them.

- [Query signature analytics]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/querySignatureAnalytics" >}})
  - Returns event counts grouped by a signature-level dimension (`signature`, `accuracy`, `risk`, `cve`, `request_status`). Filtering on signature-level fields narrows results to events whose matching signatures pass the filter.
- [Query signature analytics time series]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/querySignatureAnalyticsTimeSeries" >}})
  - Returns the same counts bucketed over time.

---

## Violation analytics

Use this operation to count security events grouped by attributes of the violations they triggered.

- [Query violation analytics]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/queryViolationAnalytics" >}})
  - Returns event counts grouped by a violation-level dimension (`violation`, `sub_violation`, `context`, `context_key`, `context_value`).

---

## References

For more information, see:

- [API reference guide]({{< ref "/nginx-one-console/api/api-reference-guide.md" >}})
- [Authentication]({{< ref "/nginx-one-console/api/authentication.md" >}})
- [Dashboard metrics reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}})
- [Security monitoring overview]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/security-monitoring-overview.md" >}})