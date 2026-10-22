---
f5-content-type: reference
f5-docs: DOCS-000
f5-product: F5 Application Delivery Service
title: Security dashboard reference
description: "Tabs, global controls, and widget-to-dimension mapping for the F5 WAF for NGINX security monitoring dashboard."
weight: 400
toc: true
f5-keywords: "security dashboard, tabs, global filters, widgets, dimensions, F5 WAF for NGINX"
f5-summary: >
  Use this reference to look up how the security monitoring dashboard is organized and which underlying dimension each widget reads from.
  This article covers the dashboard tabs, the global filter and time controls, and the mapping from widget to dimension.
  Each widget has an in-product tooltip explaining what its values mean; this article focuses on what is not in those tooltips.
f5-audience: operator
---

## Overview

Use this reference to look up how the F5 WAF for NGINX security monitoring dashboard is organized and which underlying dimension each widget reads from. Every widget in the dashboard has an in-product tooltip that explains what the displayed values mean. This article covers the dashboard structure and the global controls that affect every widget.
## Dashboard layout

The security dashboard has three tabs. All three tabs share one filter bar and one time window control. A change to either applies to every widget on every tab.

| Tab | Purpose |
|:--- |:--- |
| **Main** | Summarizes WAF activity in the selected window, including attack counts, threat intelligence, attack volume over time, and ranked lists by geolocation, policy, IP address, violation, and signature. Start here to find attacks quickly. |
| **Advanced** | Provides deeper analytics to tune policies and investigate events, including signature attributes (risk, accuracy, CVE) and violation context. Use this tab for details that are too specific for the Main tab. |
| **Event Logs** | Lists individual security events that match your filters. Open an event to see its support ID, violation and signature details, request context, and raw matched request. Use this tab to inspect the events behind a metric. |
## Global controls

Two controls at the top of the page apply to every widget on every tab.

### Time window

This control sets the query window for all widgets. The picker offers preset windows from **Last 5 minutes** to **Last 60 days**. You can also select a custom range by highlighting an area of interest on any time-series chart.

Time-series widgets divide the selected window into intervals automatically. Shorter windows produce shorter intervals.

### Add Filter

This control applies one or more filter expressions to every widget on every tab. The dashboard supports these filters.

| Filter | Description |
|:--- |:--- |
| **Config Sync Group** | Events from instances in a specific Config Sync Group. |
| **Country** | A two-letter country code derived from the client IP address. |
| **Destination Hostname** | The HTTP `Host` header that the client sent, which identifies the application being attacked. |
| **Hostname** | The NGINX instance hostname (the data plane host), which identifies the data plane that produced the events. |
| **Instance** | A specific NGINX instance, identified by object identity rather than hostname. |
| **IP Address** | The originating client IP address. |
| **Outcome Reason** | The reason F5 WAF for NGINX produced its decision, such as a matched violation or a blocking rule. |
| **Policy** | The F5 WAF for NGINX policy that produced the event. |
| **Request Method** | The HTTP request method, such as `GET` or `POST`. |
| **Response Code** | The HTTP response code returned for the request. |
| **Signature Accuracy** | The accuracy level of a triggered signature. Accepted values: `low`, `medium`, `high`. |
| **Signature CVE** | A CVE identifier that a triggered signature references. |
| **Signature ID** | The numeric ID of the signature in F5 WAF for NGINX. |
| **Signature Name** | The name of a triggered signature. |
| **Signature Risk** | The risk level of a triggered signature. Accepted values: `low`, `medium`, `high`. |
| **Status** | The final WAF decision. Accepted values: `blocked`, `alerted`, `passed`. |
| **Subviolation** | The name of the subviolation within a violation. |
| **Support ID** | The unique identifier that F5 WAF for NGINX assigns to each event. |
| **Threat Campaign** | The name of a matched threat campaign. |
| **URI** | The request Uniform Resource Identifier (URI) path. |
| **Violation** | The name of a triggered violation. |
| **Violation Context** | The location in the request where the violation occurred. Accepted values: `cookie`, `header`, `parameter`, `request`, `URI`. |
| **Violation Context Key** | The field name where the violation occurred, such as a parameter or header name. |
| **Violation Context Value** | The field value where the violation occurred. |
| **Violation Rating** | The numeric severity rating (0–5) that F5 WAF for NGINX assigned to the violation. |

Use filters to scope the dashboard to a specific policy, instance, hostname, country, IP, signature, violation, or any combination. To go from a metric on the dashboard to the underlying events, apply the relevant filter and switch to the **Event Logs** tab.
## Main tab widgets

Each widget on the Main tab has a tooltip that describes the widget's values. These tables add context that the tooltips don't cover, such as how each widget counts rows and which distinct counts each ranked widget reports.

### Summary widgets

| Widget | Notes |
|:--- |:--- |
| **All Web Attacks** | Shows the total count of security events for the selected window and filters. |
| **Threat Intelligence** | Shows the unique counts of threat campaigns and signatures observed in the window. |
| **Attack Requests Over Time** | Shows a stacked time series of `blocked` and `alerted` events. The interval size depends on the selected window. |
| **Top Attack Geolocations** | Shows the highest-volume client countries in the window. |
| **Request Methods** | Shows a donut chart of the share of events for each HTTP method observed in the window. |
| **Response Codes** | Shows a donut chart of the share of events for each response code observed in the window. |

### Ranked widgets

Each row in a ranked widget shows the hit count for the ranked item and the distinct counts listed for that widget.

| Widget | Ranked item | Distinct counts |
|:--- |:--- |:--- |
| **Top WAF Policies** | Policy | URIs, IP addresses, and violations |
| **Top Attack IP Addresses** | Client IP address | URIs, violations, and policies |
| **Top Violations** | Violation | IP addresses, URIs, and policies |
| **Top Signatures** | Signature | URIs, IP addresses, violations, and policies |
| **Top Subviolations** | Subviolation | IP addresses, URIs, and policies |
| **Top Attack URIs** | URI | IP addresses, violations, and policies |
## Advanced tab widgets

The Advanced tab provides signature and violation analytics to help you tune policies and investigate events. Widgets on this tab use the same data store as the Main tab. They apply the same global filters and time window.

| Widget | Notes |
|:--- |:--- |
| **Signatures** | Shows the total signature hits and the unique signature count, with distributions across signature accuracy and risk levels. |
| **Signature Hits Request Status** | Shows a donut chart of the `blocked`, `alerted`, and `passed` shares of signature hits. |
| **Violation Context** | Shows a donut chart of where in the request the violation occurred (`cookie`, `header`, `parameter`, `request`, `URI`). |
| **Signature Hits Over Time** | Shows a time series of signature hit volume. The interval size depends on the selected window. |

### Ranked widgets

Each row in a ranked widget shows the hit count for the ranked item and the distinct counts listed for that widget.

| Widget | Ranked item | Distinct counts |
|:--- |:--- |:--- |
| **Top Signatures** | Signature (the same as the **Top Signatures** widget on the Main tab) | URIs, IP addresses, violations, and policies |
| **Top Signature CVEs** | CVE referenced by one or more signatures | URIs, IP addresses, violations, and policies |
| **Top Threat Campaigns** | Threat campaign | URIs, IP addresses, violations, and policies |
| **Top Attacked Instances** | NGINX instance hostname (not the HTTP `Host` header) | URIs, IP addresses, violations, and policies |
## Event Logs tab

The Event Logs tab lists individual security events matching the global filters and time window. The tab has two parts:

- A **Security Events** time-series chart at the top showing event volume by request status (`blocked` and `alerted`), the same view as the **Attack Requests Over Time** widget on the Main tab.
- A paginated **events table** below the chart, where each row corresponds to one security event.

### Events table columns

| Column | Description |
|:--- |:--- |
| **Status** | The final WAF decision. Accepted values: `blocked`, `alerted`, `passed`. |
| **URI** | The request URI that triggered the event. |
| **Policy** | The F5 WAF for NGINX policy that produced the event. |
| **Time** | The time when F5 WAF for NGINX produced the event. |
| **Source Location** | The country derived from the client IP address, when available. |
| **Source IP** | The originating client IP address. |
| **Violation Rating** | The numeric severity rating (0–5) that F5 WAF for NGINX assigned to the violation. |
| **Support ID** | The unique identifier that F5 WAF for NGINX assigns to the event, which you can use to correlate the event with raw logs on the data plane. |

### Pagination

The events table has multiple pages. The default page size is `50` rows. Use the pagination controls at the bottom of the table to change the page size or move between pages. The table also shows the total event count for the current filters and time window.

### Event detail panel

When you select a row, the event detail panel opens. The panel shows every field stored on the event, including these items:

- **Triggered violations and signatures**, with the full attributes of each violation and signature that fired on the event
- **Request context**, including the method, URL, host, client IP address, `X-Forwarded-For` chain, country, response code, and request status
- **Raw matched request**, which is the captured request payload, when available.
## References

For more information, see:

- [Security monitoring overview]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/security-monitoring-overview.md" >}})
- [Set up security monitoring]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [Find a security event by Support ID]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/find-event-by-support-id.md" >}})
