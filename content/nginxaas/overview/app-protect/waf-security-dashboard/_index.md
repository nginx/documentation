---
title: F5 WAF for NGINX security monitoring
description: Monitor F5 WAF for NGINX security events in NGINXaaS Console.
weight: 425
url: /nginxaas/overview/app-protect/waf-security-dashboard
---

Use the security monitoring module in NGINXaaS Console to collect, visualize, and query security events from F5 WAF for NGINX running on NGINX Plus instances. Review attacks, violations, and triggered signatures to assess threats.

This section covers:

- [Security monitoring overview]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/security-monitoring-overview.md" >}}) — what the security dashboard is, the data pipeline behind it, and what you can do with it.
- [secops_dashboard log profile]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/default-log-profile.md" >}}) — the immutable, pre-compiled log profile the dashboard depends on.
- [Set up security monitoring]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/set-up-security-monitoring.md" >}}) — enable F5 WAF for NGINX, configure the log profile, and forward events through NGINX Agent.
- [Security dashboard reference]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/dashboard-metrics-reference.md" >}}) — dashboard tabs, global controls, and how each widget maps to an underlying dimension.
- [Find a security event by Support ID]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/find-event-by-support-id.md" >}}) — look up a single security event by its Support ID for quick triage.
