---
nd-content-type: concept
nd-docs: DOCS-000
nd-product: NONECO
title: secops_dashboard log profile
description: "An immutable, pre-compiled F5 WAF for NGINX log profile that captures the security telemetry the security dashboard needs."
weight: 200
toc: true
nd-keywords: "secops_dashboard, default log profile, security dashboard, F5 WAF for NGINX, log profile, security telemetry, NAP log profile, system-managed profile, pre-compiled, immutable log profile, NGINX One Console, WAF log profile"
nd-summary: >
  The `secops_dashboard` log profile is a pre-configured F5 WAF for NGINX log profile that captures security violations in a standardized format for the security monitoring dashboard. It is the default log profile used by the security dashboard.
  Use it to send security telemetry from your NGINX Plus data planes to NGINX One Console without authoring or compiling a custom log profile.
  This document covers what the `secops_dashboard` log profile is, when to use it, and how it differs from custom log profiles.
nd-audience: operator
---

The security monitoring dashboard depends on a consistent set of fields being present on every security event. The `secops_dashboard` log profile is the guarantee of that consistency: it ensures every data plane forwards the same set of fields, so the dashboard can render every event correctly.

## What is the `secops_dashboard` log profile?

The `secops_dashboard` log profile is a pre-configured, system-managed F5 WAF for NGINX log profile that captures the security telemetry fields the NGINX One Console security monitoring dashboard expects. It is the default log profile used by the security dashboard. NGINX One Console maintains it as a system asset; you cannot edit or delete it.

It is similar in structure and function to other [log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/_index.md" >}}), but it is treated as a system asset rather than a user-managed resource. The `secops_dashboard` log profile is the only log profile guaranteed to produce data the security dashboard can render correctly. Custom log profiles can coexist with it and continue to serve other logging destinations such as Security Information and Event Management (SIEM) systems, file logs, or custom syslog endpoints, but they are not interpreted by the security dashboard.

This document covers what the `secops_dashboard` log profile is and when to use it. For the steps to deploy it as part of setting up an instance, see [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}}).

---

## How to identify it in the console

In NGINX One Console, go to **WAF** > **Log Profiles**. The `secops_dashboard` log profile appears in the list with an **F5** badge next to its name. The badge marks it as a system-managed profile created and maintained by F5.

The available **Actions** on the `secops_dashboard` log profile are limited compared to a user-created log profile. You can **Deploy**, **Download JSON**, **Manage Bundle**, and **Make a copy**, but **Edit** and **Delete** are not exposed — the profile is system-managed and cannot be modified or removed.

To see the compiled bundles for the `secops_dashboard` log profile, open the profile and select **Actions** > **Manage Bundle**. The **Bundles** tab lists every available WAF compiler version with its compilation status (`Compiled` or `Compiling`) and a **Download** action for each compiled bundle. NGINX One Console keeps these bundles up to date automatically — you do not need to compile them yourself.

If you need a log profile with a different field set or filter rules, use **Make a copy** to create an editable, user-owned log profile based on `secops_dashboard`. The copy is a regular custom log profile and is not used by the security dashboard.

---

## Key characteristics

The `secops_dashboard` log profile has three properties that distinguish it from user-created log profiles.

- **Immutable**: You cannot edit or delete the `secops_dashboard` log profile. NGINX One Console manages it as a system resource so the security monitoring data format remains consistent across every instance and tenant.
- **Pre-compiled**: NGINX One Console automatically compiles the `secops_dashboard` log profile for every available WAF compiler version. Deployment completes immediately without an on-demand compilation step.
- **Standardized field set**: It captures every field the security dashboard reads, including the support ID, violation details, signature information, threat campaign matches, request context, and client geolocation. Filters and analytics in the dashboard assume these fields are present.

---

## Use cases

### Operator: enable security monitoring for an NGINX Plus fleet

A platform operator wants central visibility into F5 WAF for NGINX events across a fleet of NGINX Plus instances. They deploy the `secops_dashboard` log profile to every instance, knowing that every event will land in NGINX One Console with the same field set, so dashboard widgets, filters, and analytics behave the same regardless of which instance produced the event. They do not need to author, compile, or version-control a log profile to get the dashboard working.

### Security engineer: rolling out a policy change without touching telemetry

A security engineer is rolling out a new WAF policy to a subset of instances and wants the security dashboard to continue showing comparable metrics across the migration. Because the `secops_dashboard` log profile is immutable and shared, the data format does not change with the policy, and the engineer can compare attack counts and signature trends before and after the rollout without normalizing fields.

### Operator: combine dashboard monitoring with a custom SIEM pipeline

An operator already forwards security logs to an external SIEM with a custom log profile that uses a different field layout. They deploy the `secops_dashboard` log profile alongside the existing custom profile so that NGINX One Console gets the standardized format the dashboard requires, while the SIEM continues to receive the custom format unchanged.

---

## Comparison with custom log profiles

| | Default log profile | Custom log profile |
|:--- |:--- |:--- |
| **Editable** | No | Yes |
| **Deletable** | No | Yes |
| **Compilation** | Pre-compiled for all WAF compiler versions | Compiled on demand for the target compiler version |
| **Field layout** | Fixed; matches the security dashboard | User-defined |
| **Used by the security dashboard** | Yes | No |
| **Best for** | Sending data to the NGINX One Console security dashboard | Forwarding to SIEMs, custom syslog endpoints, or file logs with a non-standard field set |

---

## References

For more information, see:

- [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [F5 WAF for NGINX security monitoring overview]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/security-monitoring-overview.md" >}})
- [Log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/_index.md" >}})
- [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}})
