---
description: Learn how to update the Attack Signature Database used in F5 NGINX Management
  Suite Security Monitoring dashboards.
docs: DOCS-1109
doctypes:
- task
tags:
- docs
title: Manage the Security Monitoring Signature Database
toc: true
weight: 200
---

{{< shortversions "1.0.0" "latest" "secvers" >}}

## Overview

You can use the F5 NGINX Security Monitoring module to monitor NGINX App Protect WAF instances for security. The Security Monitoring module analytics dashboards utilize a Signature Database to give more detail about the Attack Signatures that have caused a Security Violation, like the Signature's name, accuracy, and risk. If the Signature Database is not updated to match the Attack Signature version used for App Protect WAF protection, new signatures may be triggered without a name or other attributes like risk and accuracy.

Make sure the dashboards show the right info by following the steps in this topic to update the Security Monitoring module with the newest Attack Signature data.

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- NGINX Security Monitoring is [installed]({{< relref "/nim/monitoring/security-monitoring/deploy/install-security-monitoring.md" >}}) and running
- NGINX App Protect is configured, and the Security Monitoring dashboard is gathering security violations

## How to Update the Signature Database

1. Open an SSH connection to the data plane host and log in.
1. Use the [Attack Signature Report Tool](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#attack-signature-report-tool) to generate a Signature Report file. The filename must be `signature-report.json`.

    Example:

    ```bash
    sudo /opt/app_protect/bin/get-signatures -o ./signature-report.json
    ```

1. Open an SSH connection to the management plane host and log in.
1. Replace the `signature-report.json` on your NGINX Instance Manager's control plane at `/usr/share/nms/sigdb/signature-report.json` with the newly generated Signature Report.

    Example:

    ```bash
    sudo scp /path/to/signature-report.json {user}@{host}:/usr/share/nms/sigdb/signature-report.json
    ```

1. Restart the NGINX Instance Manager services:

    ```bash
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```
