---
nd-content-type: concept
nd-docs: DOCS-000
nd-product: NONECO
title: Security monitoring overview
description: "What the F5 WAF for NGINX security monitoring module is, the data pipeline behind it, and what you can do with the data."
weight: 100
toc: true
nd-keywords: "security monitoring, security dashboard, F5 WAF for NGINX, security events, analytics, NGINX One Console"
nd-summary: >
  Security monitoring in NGINX One Console centralizes security events from F5 WAF for NGINX instances and exposes them through dashboards and an analytics API.
  Use this document to understand what the dashboard shows, where the data comes from, and how it is scoped and retained.
  This document is conceptual; for setup steps see Set up security monitoring.
nd-audience: operator
---

Security monitoring brings F5 WAF for NGINX events from every connected instance into a single place in NGINX One Console. Before you set it up, it helps to understand what data the system collects, how it gets there, and how it is organized.

## What is security monitoring?

Security monitoring is the NGINX One Console module that ingests F5 WAF for NGINX security events from your data planes, stores them centrally, and exposes them through a security dashboard and an analytics API. It gives you a single view of attacks, violations, and triggered signatures across every NGINX Plus instance you have connected to NGINX One Console.

This document covers what the module is and how data flows through it. For deployment steps, see [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}}). For details on what each dashboard widget shows, see the [dashboard metrics reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}}).

---

## How security events reach the dashboard

The data pipeline has four stages:

1. **Detection.** F5 WAF for NGINX inspects requests on the data plane and produces a security log entry whenever a request matches a violation, signature, or threat campaign.
2. **Forwarding.** F5 WAF for NGINX writes the entry over syslog (port `1514` on localhost) using the [`secops_dashboard` log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}}). NGINX Agent's OpenTelemetry collector receives it through the `tcplog/nginx_app_protect` receiver.
3. **Transport.** The collector batches events and exports them to NGINX One Console through the `otlp/default` exporter. Batching keeps the upstream call rate low while keeping per-event delivery latency under a minute.
4. **Storage and query.** NGINX One Console parses, indexes, and stores the events. The security dashboard and the analytics API both read from the same store.

Every event carries the support ID, the policy that matched it, the violation and signature details, and the request context (method, URL, host, client IP, X-Forwarded-For, geolocation). Those fields are what the dashboard groups and filters on.

---

## How data is scoped

Every security event carries enough context to attribute it to a specific data plane, a specific policy, and the application it targeted.

- **Instance**: Each event records the NGINX instance hostname that produced it. Use this to scope by data plane.
- **Policy**: Each event records the F5 WAF for NGINX policy that produced it, so you can compare activity across policy versions or rollouts.
- **Destination hostname**: Each event records the HTTP `Host` header sent by the client. Use this to scope by the application being attacked, which is often distinct from the instance hostname when the same data plane fronts multiple applications.

---

## Retention

Security events are retained for **90 days**. Queries that reach further back than 90 days return no results. If you need long-term retention, forward events to an external Security Information and Event Management (SIEM) system with a [custom log profile]({{< ref "/nginx-one-console/waf-integration/log-profiles/_index.md" >}}) in addition to the `secops_dashboard` log profile.

---

## Use cases

### Operator: triage an active attack

An operator notices a spike in attack volume on the security dashboard. They use the global filters to narrow down to the affected policy and time window, then drill into the top signatures and attacked endpoints to identify which signatures fired and which URLs were targeted. From a single event, they pull the Support ID, the X-Forwarded-For chain, and the raw request to confirm the source and decide whether to tighten the policy.

### Security engineer: tune a noisy policy

A security engineer suspects a policy is producing false positives. They open the security dashboard, filter by policy and blocked requests, and review the breakdown of triggered signatures. The high-volume signatures with low risk and accuracy stand out as candidates for tuning. They cross-check a few events against the raw requests to confirm the signature is firing on legitimate traffic before adjusting the policy.

### Platform team: report on WAF activity across the fleet

A platform team needs a weekly summary of WAF activity across hundreds of instances. They use the analytics API to pull attack counts, top signatures, and top violations grouped by instance, then render the result in their own reporting tool. The dashboard remains the interactive surface for ad-hoc investigation; the API is the integration point for automation.

---

## What security monitoring does not cover

- **Access logs and performance metrics** — security monitoring only ingests F5 WAF for NGINX security events. NGINX access logs and performance telemetry are handled by other parts of NGINX One Console.
- **Policy authoring** — use [WAF policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}) to create and deploy F5 WAF for NGINX policies. Security monitoring shows you the effect of those policies, not the policies themselves.
- **Long-term archival** — events expire after 90 days. Forward to an external SIEM if you need longer retention.

---

## References

For more information, see:

- [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [secops_dashboard log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}})
- [Dashboard metrics reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}})
- [Find a security event by Support ID]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/find-event-by-support-id.md" >}})
- [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}})
