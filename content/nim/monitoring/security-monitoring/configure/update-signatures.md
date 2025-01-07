---
title: Update the Attack Signature Database
description: Learn how to update the Attack Signature Database used in F5 NGINX Management
  Suite Security Monitoring dashboards.
toc: true
weight: 300
type: how-to
product: NIM
docs: DOCS-1109
---

## Overview

You can use the F5 NGINX Security Monitoring module to monitor NGINX App Protect WAF instances for security. The Security Monitoring module analytics dashboards utilize a Signature Database to give more detail about the Attack Signatures that have caused a Security Violation, like the Signature's name, accuracy, and risk. 

If the Signature Database is not updated to match the Attack Signature version used for App Protect WAF protection, new signatures may be triggered without a name or other attributes like risk and accuracy.

The steps in this topic ensure that dashboards show the correct information by updating the Security Monitoring module with the newest Attack Signature data.

---

## Before you begin

Complete the following prerequisites before proceeding with this guide:

- NGINX Security Monitoring is [installed]({{< relref "/nim/monitoring/security-monitoring/install-security-monitoring.md" >}}) and running
- NGINX App Protect is configured, and the Security Monitoring dashboard is gathering security violations

---

## Update the Signature Database

1. Open an SSH connection to the data plane host and log in.
1. Use the [Attack Signature Report Tool]({{< relref "/nap-waf/v4/configuration-guide/configuration.md#attack-signature-report-tool" >}}) to generate a Signature Report file. The filename must be `signature-report.json`.

    ```bash
    sudo /opt/app_protect/bin/get-signatures -o ./signature-report.json
    ```

1. Open an SSH connection to the management plane host and log in.
1. Replace the `signature-report.json` on your NGINX Instance Manager's control plane at `/usr/share/nms/sigdb/signature-report.json` with the newly generated Signature Report.

    ```bash
    sudo scp /path/to/signature-report.json {user}@{host}:/usr/share/nms/sigdb/signature-report.json
    ```

1. Restart the NGINX Instance Manager services:

    ```bash
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```