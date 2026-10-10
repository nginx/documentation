---
f5-content-type: concept
f5-docs: DOCS-000
f5-product: F5 NGINXaaS
title: secops_dashboard log profile
description: "An immutable, pre-compiled F5 WAF for NGINX log profile that captures the security telemetry the security dashboard needs."
weight: 200
toc: true
f5-keywords: "secops_dashboard, default log profile, security dashboard, F5 WAF for NGINX, log profile, security telemetry, NAP log profile, system-managed profile, pre-compiled, immutable log profile, NGINXaaS Console, WAF log profile"
f5-summary: >
  The `secops_dashboard` log profile is a pre-configured F5 WAF for NGINX log profile that captures security violations in a standardized format for the security monitoring dashboard. It is the default log profile used by the security dashboard.
  Use it to send security telemetry from your NGINX Plus data planes to NGINXaaS Console.
  This document covers what the `secops_dashboard` log profile is, when to use it, and how it differs from custom log profiles.
f5-audience: operator
---

The security monitoring dashboard depends on a consistent set of fields being present on every security event. The `secops_dashboard` log profile is the guarantee of that consistency: it ensures every data plane forwards the same set of fields, so the dashboard can render every event correctly.

## What is the `secops_dashboard` log profile?

The `secops_dashboard` log profile is a pre-configured, system-managed F5 WAF for NGINX log profile that captures the security telemetry fields the NGINXaaS Console security monitoring dashboard expects. It is the default log profile used by the security dashboard.

The `secops_dashboard` log profile is the only log profile guaranteed to produce data the security dashboard can render correctly. Other log profiles can coexist with it and continue to serve other logging destinations such as Security Information and Event Management (SIEM) systems, file logs, or custom syslog endpoints, but they are not interpreted by the security dashboard.

This document covers what the `secops_dashboard` log profile is and when to use it. For the steps to deploy it as part of setting up an instance, see [Set up security monitoring]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/set-up-security-monitoring.md" >}}).

---

## References

For more information, see:

- [Set up security monitoring]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [F5 WAF for NGINX security monitoring overview]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/security-monitoring-overview.md" >}})
- [Default Log profiles]({{< ref "/waf/logging/logs-overview.md#default-logging-profile-bundles" >}})
