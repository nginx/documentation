---
nd-content-type: reference
nd-docs: DOCS-000
nd-product: NONECO
title: Security dashboard reference
description: "Tabs, global controls, and widget-to-dimension mapping for the F5 WAF for NGINX security monitoring dashboard."
weight: 400
toc: true
nd-keywords: "security dashboard, tabs, global filters, widgets, dimensions, F5 WAF for NGINX"
nd-summary: >
  Use this reference to look up how the security monitoring dashboard is organized and which underlying dimension each widget reads from.
  This article covers the dashboard tabs, the global filter and time controls, and the mapping from widget to API dimension.
  Each widget has an in-product tooltip explaining what its values mean; this article focuses on what is not in those tooltips.
nd-audience: operator
---

## Overview

Use this reference to look up how the F5 WAF for NGINX security monitoring dashboard is organized and which underlying dimension each widget reads from. Every widget in the dashboard has an in-product tooltip that explains what the displayed values mean. This article mainly covers the dashboard structure, the global controls that affect every widget, and the mapping you need when you want to reproduce a widget's view through the [analytics API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}}).

---

## Dashboard layout

The security dashboard is organized into three tabs. All three tabs share the same global filter bar and time window control at the top of the page, so any filter or time change applies to every widget on every tab.

| Tab | Purpose |
|:--- |:--- |
| **Main** | High-level summary of WAF activity in the selected window. Shows attack counts, threat intelligence, attack volume over time, and top-N breakdowns by geolocation, policy, IP, violation, and signature. This is the landing tab for triage. |
| **Advanced** | Deeper analytics for tuning and investigation. Use this tab to drill into signature attributes (risk, accuracy, CVE), violation context, and other dimensions that are too detailed for the Main tab. |
| **Event Logs** | A filterable list of individual security events. Open an event to see its support ID, full violation and signature detail, request context, and the raw matched request. This tab is the drill-down target when you want to inspect specific events behind a metric. |

---

## Global controls

Two controls at the top of the page apply to every widget on every tab.

### Time window

Selects the query window for all widgets. The picker offers preset windows from **Last 5 minutes** to **Last 60 days**. You can also select a custom range by highlighting an area of interest on any time-series chart.

Time-series widgets bucket their data automatically based on the selected window — shorter windows produce finer buckets.

{{< call-out "note" >}}Security events are retained for **90 days**, but the dashboard time window picker tops out at the **last 60 days**. To query the full retention window, use the [analytics API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}}), which accepts any time range up to 90 days.{{< /call-out >}}

### Add Filter

Applies one or more filter expressions to every widget on every tab. The dashboard supports the following filters:

| Filter | Description |
|:--- |:--- |
| **Config Sync Group** | Scope events to instances belonging to a specific Config Sync Group. |
| **Country** | Two-letter country code derived from the client IP. |
| **Destination Hostname** | The HTTP `Host` header sent by the client. Use this to scope by the application being attacked. |
| **Hostname** | The NGINX instance hostname (the data plane host). Use this to scope by the data plane producing the events. |
| **Instance** | Scope events to a specific NGINX instance by object identity rather than hostname. |
| **IP Address** | The originating client IP. |
| **Outcome Reason** | The reason F5 WAF for NGINX produced its decision, such as a matched violation or a blocking rule. |
| **Policy** | The F5 WAF for NGINX policy that produced the event. |
| **Request Method** | The HTTP request method (`GET`, `POST`, and so on). |
| **Response Code** | The HTTP response code returned for the request. |
| **Signature Accuracy** | The accuracy level of a triggered signature: `low`, `medium`, or `high`. |
| **Signature CVE** | A CVE identifier referenced by a triggered signature. |
| **Signature ID** | The numeric F5 WAF for NGINX signature ID. |
| **Signature Name** | The name of a triggered signature. |
| **Signature Risk** | The risk level of a triggered signature: `low`, `medium`, or `high`. |
| **Status** | The final WAF decision: `blocked`, `alerted`, or `passed`. |
| **Subviolation** | The sub-violation name within a violation. |
| **Support ID** | The unique identifier F5 WAF for NGINX assigns to each event. |
| **Threat Campaign** | The name of a matched threat campaign. |
| **URI** | The request URI path. |
| **Violation** | The name of a triggered violation. |
| **Violation Context** | Where in the request the violation occurred: `cookie`, `header`, `parameter`, `request`, or `URI`. |
| **Violation Context Key** | The field name (for example, the parameter or header name) where the violation occurred. |
| **Violation Context Value** | The field value where the violation occurred. |
| **Violation Rating** | The numeric severity rating (0–5) F5 WAF for NGINX assigned to the violation. |

Use filters to scope the dashboard to a specific policy, instance, hostname, country, IP, signature, violation, or any combination. To go from a metric on the dashboard to the underlying events, apply the relevant filter and switch to the **Event Logs** tab.

Every dashboard filter is also available through the analytics API. To call the same filters from the API, see the [API reference guide]({{< ref "/nginx-one-console/api/api-reference-guide.md" >}}).

---

## Main tab widgets

Each widget on the Main tab has a tooltip describing what it displays. The table below adds context the tooltips do not cover, such as how rows are counted and what distinct counts each Top-N table reports.

| Widget | Notes |
|:--- |:--- |
| **All Web Attacks** | Total count of security events for the selected window and filters. |
| **Threat Intelligence** | Unique counts of threat campaigns and signatures observed in the window. |
| **Attack Requests Over Time** | Stacked time series of `blocked` and `alerted` events. Bucket size depends on the selected window. |
| **Top Attack Geolocations** | Highest-volume client countries in the window. |
| **Top WAF Policies** | Each row shows hits, distinct URIs, IPs, and violations for the policy. |
| **Top Attack IP Addresses** | Each row shows hits, distinct URIs, violations, and policies for the client IP. |
| **Top Violations** | Each row shows hits, distinct IPs, URIs, and policies for the violation. |
| **Top Signatures** | Each row shows hits, distinct URIs, IPs, violations, and policies for the signature. |
| **Top Subviolations** | Each row shows hits, distinct IPs, URIs, and policies for the sub-violation. |
| **Top Attack URIs** | Each row shows hits, distinct IPs, violations, and policies for the URI. |
| **Request Methods** | Donut chart showing the share of events for each HTTP method observed in the window. |
| **Response Codes** | Donut chart showing the share of events for each response code observed in the window. |

To reproduce these widgets through the analytics API, see [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}}).

---

## Advanced tab widgets

The Advanced tab exposes signature- and violation-level analytics for tuning and deeper investigation. Widgets on this tab read from the same data store as the Main tab and respect the same global filters and time window.

| Widget | Notes |
|:--- |:--- |
| **Signatures** | Total signature hits and unique signature count, with distributions across signature accuracy and risk levels. |
| **Signature Hits Request Status** | Donut chart of `blocked`, `alerted`, and `passed` shares of signature hits. |
| **Violation Context** | Donut chart showing where in the request the violation occurred (`cookie`, `header`, `parameter`, `request`, `URI`). |
| **Signature Hits Over Time** | Time series of signature hit volume. Bucket size depends on the selected window. |
| **Top Signatures** | Same as the Top Signatures widget on the Main tab. Each row shows hits, distinct URIs, IPs, violations, and policies. |
| **Top Signature CVEs** | Each row shows hits, distinct URIs, IPs, violations, and policies for signatures that reference the CVE. |
| **Top Threat Campaigns** | Each row shows hits, distinct URIs, IPs, violations, and policies for the threat campaign. |
| **Top Attacked Instances** | Each row shows hits, distinct URIs, IPs, violations, and policies, scoped to the NGINX instance hostname (not the HTTP `Host` header). |

To reproduce these widgets through the analytics API, see [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}}).

---

## Event Logs tab

The Event Logs tab lists individual security events matching the global filters and time window. The tab has two parts:

- A **Security Events** time-series chart at the top showing event volume by request status (`blocked` and `alerted`), the same view as the **Attack Requests Over Time** widget on the Main tab.
- A paginated **events table** below the chart, where each row corresponds to one security event.

### Events table columns

| Column | Description |
|:--- |:--- |
| **Status** | The final WAF decision: `blocked`, `alerted`, or `passed`. |
| **URI** | The request URI that triggered the event. |
| **Policy** | The F5 WAF for NGINX policy that produced the event. |
| **Time** | When F5 WAF for NGINX produced the event. |
| **Source Location** | Country derived from the client IP, when available. |
| **Source IP** | The originating client IP. |
| **Violation Rating** | Numeric severity rating (0–5) assigned by F5 WAF for NGINX. |
| **Support ID** | The unique identifier F5 WAF for NGINX assigns to the event. Use this to correlate with raw F5 WAF for NGINX logs on the data plane. |

To list events with the same columns through the analytics API, see [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}}).

### Pagination

The table is paginated. Use the controls in the bottom-right of the table to:

- Change the page size (default `50` rows per page).
- Navigate to a specific page or step through pages with the arrow controls.

The total event count for the current filter and time window is shown in the bottom-left of the table.

### Event detail panel

Selecting a row opens the event detail panel. The panel surfaces every field stored on the event, including:

- **Triggered violations and signatures** — every violation and signature that fired on the event, with their full attributes.
- **Request context** — method, URL, host, client IP, X-Forwarded-For chain, country, response code, and request status.
- **Raw matched request** — the captured request payload, when available.


---

## References

For more information, see:

- [Security monitoring overview]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/security-monitoring-overview.md" >}})
- [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [Find a security event by Support ID]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/find-event-by-support-id.md" >}})
- [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}})
