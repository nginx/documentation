---
title: Update the attack signature database
weight: 300
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: DOCS-1109
description: "Update the attack signature database used by Security Monitoring in F5 NGINX Instance Manager to keep signature names, risk scores, and accuracy data current."
nd-summary: >
  Update the attack signature database in F5 NGINX Instance Manager so Security Monitoring dashboards show accurate signature names, risk scores, and accuracy ratings.
  The signature database version must match the version used in F5 WAF for NGINX; a mismatch causes new signatures to appear without attributes.
---

The Security Monitoring module tracks security violations on F5 WAF for NGINX instances. Its analytics dashboards use a Signature Database to show details about Attack Signatures, including their name, accuracy, and risk.

If the Signature Database is outdated and doesn't match the version used in F5 WAF for NGINX, new signatures may appear without attributes like a name, risk, or accuracy.

Follow these steps to update the Security Monitoring module with the latest Attack Signature data so the dashboards show complete and accurate information.

---

## Before you begin

Make sure you have the following:

- [F5 WAF for NGINX is set up]({{< ref "/nim/waf-integration/configuration/_index.md" >}}), and the Security Monitoring dashboard is collecting security violations.

---

## Update the signature database

{{< include "/nim/security-monitoring/update-security-monitoring-attack-signature-database.md" >}}
