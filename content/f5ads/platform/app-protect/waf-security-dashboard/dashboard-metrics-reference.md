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

The Security Dashboard is divided up into separate tabs - Main, Advanced, and Event Logs - where you can get a high level overview of WAF events across your resources, drill into attack details, or see a complete list of all WAF events. Active filters and time ranges persist across tabs.

## Global controls

Two controls at the top of the page apply to every widget on every tab.

### Time window

This control sets the query window for all widgets. The picker offers preset time windows and the ability to select a custom range.

### Add Filter

This control applies one or more filter expressions to every widget on every tab. Use filters to scope the dashboard to a specific policy, deployment, IP, signature, violation, or any combination. To go from a metric on the dashboard to the underlying events, apply the relevant filter and switch to the **Event Logs** tab.
## Main tab widgets

Each widget on the Main tab has a tooltip that describes the widget's values. These tables add context that the tooltips don't cover, such as how each widget counts rows and which distinct counts each ranked widget reports.
## Advanced tab widgets

The Advanced tab provides signature and violation analytics to help you tune policies and investigate events. Widgets on this tab use the same data store as the Main tab. They apply the same global filters and time window.
## Event Logs tab

The Event Logs tab lists individual security events matching the global filters and time window. The tab has two parts:

- A **Security Events** time-series chart at the top showing event volume by request status (`blocked` and `alerted`), the same view as the **Attack Requests Over Time** widget on the Main tab.
- A paginated **events table** below the chart, where each row corresponds to one security event.

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
