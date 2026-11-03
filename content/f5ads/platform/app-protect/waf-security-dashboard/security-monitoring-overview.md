---
f5-content-type: concept
f5-docs: DOCS-000
f5-product: F5 Application Delivery Service
title: Security monitoring overview
description: "What the F5 WAF for NGINX security monitoring module is, the data pipeline behind it, and what you can do with the data."
weight: 100
toc: true
f5-keywords: "security monitoring, security dashboard, F5 WAF for NGINX, security events, analytics, F5 ADS Console"
f5-summary: >
  Security monitoring in the F5 ADS Console centralizes security events from F5 WAF for your deployments and exposes them through dashboards.
  Use this document to understand what the dashboard shows, where the data comes from, and how it is scoped and retained.
  This document is conceptual; for setup steps see Set up security monitoring.
f5-audience: operator
---

Security monitoring brings F5 WAF for NGINX events from every deployment into a single place in the F5 ADS Console. This page explains what data the system collects, how it is organized, and how to use it.

## What is security monitoring?

Security monitoring is the F5 ADS Console module that ingests F5 WAF for NGINX security events from your deployments, stores them centrally, and exposes them through a security dashboard. It gives you a single view of attacks, violations, and triggered signatures across every deployment you have created in the F5 ADS Console. Every event carries the support ID, the policy that matched it, the violation and signature details, and the request context (method, URL, host, client IP, X-Forwarded-For, geolocation). Those fields are what the dashboard groups and filters on. For deployment steps, see [Set up security monitoring]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/set-up-security-monitoring.md" >}}). For details on what each dashboard widget shows, see the [dashboard metrics reference]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/dashboard-metrics-reference.md" >}}).
## Data scoping

Every security event carries enough context to attribute it to a specific deployment, a specific policy, and the application it targeted.

- **Deployment**: Each event records the F5 ADS deployment ID that produced it. Use this to scope by deployment.
- **Policy**: Each event records the F5 WAF for NGINX policy that produced it, so you can compare activity across policy versions or rollouts — useful for measuring the impact of a policy change before promoting it.
- **Destination hostname**: Each event records the HTTP `Host` header sent by the client — the *application* being attacked.
## Retention

Security events are retained for **90 days**. Queries that reach further back than 90 days return no results. If you need long-term retention, forward events to an external Security Information and Event Management (SIEM) system with a [custom log profile]({{< ref "/nginx-one-console/waf-integration/log-profiles/_index.md" >}}) in addition to the `secops_dashboard` log profile.
## Use cases

### Operator: triage an active attack

An operator notices a spike in attack volume on the security dashboard. The operator uses the global filters to narrow down to the affected policy and time window, then drills into the top signatures and attacked endpoints to identify which signatures fired and which URLs were targeted. From a single event, the operator pulls the Support ID, the X-Forwarded-For chain, and the raw request to confirm the source and decide whether to change the policy.

### Security engineer: tune a noisy policy

A security engineer suspects a policy is producing false positives. The engineer opens the security dashboard, filters by policy and blocked requests, and reviews the breakdown of triggered signatures. The high-volume signatures with low risk and accuracy stand out as candidates for tuning. The engineer cross-checks a few events against the raw requests to confirm the signature is firing on legitimate traffic before changing the policy.
## What security monitoring does not cover

- **Access logs and performance metrics** — security monitoring only ingests F5 WAF for NGINX security events. NGINX access logs and performance telemetry are handled by other parts of the F5 ADS Console.
- **Long-term archival** — events expire after 90 days. Forward to an external SIEM if you need longer retention.
## References

For more information, see:

- [Set up security monitoring]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [Dashboard metrics reference]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/dashboard-metrics-reference.md" >}})
- [Find a security event by Support ID]({{< ref "/f5ads/platform/app-protect/waf-security-dashboard/find-event-by-support-id.md" >}})
