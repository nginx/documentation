---
title: F5 WAF for NGINX security monitoring
description: Monitor F5 WAF for NGINX security events in NGINX One Console.
weight: 425
url: /nginx-one-console/waf-integration/waf-security-dashboard
---

Use the security monitoring module in NGINX One Console to collect, visualize, and query security events from F5 WAF for NGINX running on NGINX Plus instances. Review attacks, violations, and triggered signatures to assess threats and fine-tune your policies.

This section covers:

- [Security monitoring overview]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/security-monitoring-overview.md" >}}) — what the security dashboard is, the data pipeline behind it, and what you can do with it.
- [secops_dashboard log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}}) — the immutable, pre-compiled log profile the dashboard depends on.
- [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}}) — install F5 WAF for NGINX, configure the log profile, and forward events through NGINX Agent.
- [Security dashboard reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}}) — dashboard tabs, global controls, and how each widget maps to an underlying dimension.
- [Find a security event by Support ID]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/find-event-by-support-id.md" >}}) — look up a single security event by its Support ID for quick triage.
- [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}}) — list events and run analytics queries programmatically.
