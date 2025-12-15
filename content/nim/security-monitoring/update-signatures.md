---
title: Update the attack signature database
weight: 300
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: DOCS-1109
---

The F5 NGINX Security Monitoring module tracks security violations on F5 WAF for NGINX instances. Its analytics dashboards use a Signature Database to provide details about Attack Signatures, including their name, accuracy, and risk.

If the Signature Database is outdated and doesn’t match the version used in F5 WAF for NGINX, new signatures may appear without attributes like a name, risk, or accuracy.

Follow these steps to update the Security Monitoring module with the latest Attack Signature data, ensuring the dashboards display complete and accurate information.

---

## Before you begin

Ensure the following prerequisites are met:

- [F5 WAF for NGINX is configured]({{< ref "/nim/waf-integration/configuration/_index.md" >}}), and the Security Monitoring dashboard is collecting security violations.

---

## Update the signature database

{{< include "/nim/security-monitoring/update-security-monitoring-attack-signature-database.md" >}}
