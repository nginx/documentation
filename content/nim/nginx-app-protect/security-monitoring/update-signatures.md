---
title: Update the Attack Signature Database
weight: 300
toc: true
type: how-to
product: NIM
nd-docs: DOCS-1109
---

## Overview

The F5 NGINX Security Monitoring module tracks security violations on F5 WAF for NGINX instances. Its analytics dashboards use a Signature Database to provide details about Attack Signatures, including their name, accuracy, and risk.

If the Signature Database is outdated and doesn’t match the version used in App Protect WAF, new signatures may appear without attributes like a name, risk, or accuracy.

Follow these steps to update the Security Monitoring module with the latest Attack Signature data, ensuring the dashboards display complete and accurate information.

---

## Before you begin

Ensure the following prerequisites are met:

- NGINX App Protect is configured, and the Security Monitoring dashboard is collecting security violations.

---

## Update the Signature Database

1. Open an SSH connection to the data plane host and log in.
1. Generate a Signature Report file using the [Attack Signature Report Tool]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#attack-signature-report-tool" >}}). Save the file as `signature-report.json`:

    ```bash
    sudo /opt/app_protect/bin/get-signatures -o ./signature-report.json
    ```

1. Open an SSH connection to the management plane host and log in.
1. Copy the `signature-report.json` file to the NGINX Instance Manager control plane at `/usr/share/nms/sigdb/`:

    ```bash
    sudo scp /path/to/signature-report.json {user}@{host}:/usr/share/nms/sigdb/signature-report.json
    ```

1. Restart the NGINX Instance Manager services to apply the update:

    ```bash
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```
