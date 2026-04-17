---
title: Update the attack signature database
weight: 300
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: DOCS-1109
---

The Security Monitoring module tracks security violations on F5 WAF for NGINX instances. Its analytics dashboards use a signature database to provide details about attack signatures, including their name, accuracy, and risk.

If the signature database is outdated and doesn’t match the version used in F5 WAF for NGINX, new signatures may appear without attributes like a name, risk, or accuracy.

Update the Security Monitoring module with the latest attack signature data to keep dashboards complete and accurate.

---

## Before you begin

Before you begin, make sure [F5 WAF for NGINX is configured]({{< ref "/nim/waf-integration/configuration/_index.md" >}}) and the Security Monitoring dashboard is collecting security violations.

---

## Update the signature database

{{< include "/nim/security-monitoring/update-security-monitoring-attack-signature-database.md" >}}
