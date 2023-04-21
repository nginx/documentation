---
title: "Manage the Security Monitoring Signature Database"
date: 2023-01-13T14:23:27-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to update the Attack Signature Database used in NGINX Management Suite Security Monitoring dashboards."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1109"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "waf", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{< shortversions "1.0.0" "latest" "secvers" >}}

{{<custom-styles>}}

## Overview

You can use the NGINX Management Suite Security Monitoring module to monitor NGINX App Protect WAF instances for security. The Security Monitoring module analytics dashboards utilize a Signature Database to give more detail about the Attack Signatures that have caused a Security Violation, like the Signature's name, accuracy, and risk. If the Signature Database is not updated to match the Attack Signature version used for App Protect WAF protection, new signatures may be triggered without a name or other attributes like risk and accuracy.

Make sure the dashboards show the right info by following the steps in this topic to update the Security Monitoring module with the newest Attack Signature data.

## Before You Begin

Complete the following prerequisites before proceeding with this guide: 

- NGINX Management Suite Security Monitoring is [installed]({{< relref "/admin-guides/installation/on-prem/install-guide#install-nms-modules" >}}) and running 
- NGINX App Protect is configured, and the Security Monitoring dashboard is gathering security violations

## How to Update the Signature Database

1. Open an SSH connection to the data plane host and log in.
1. Use the [Attack Signature Report Tool](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#attack-signature-report-tool) to generate a Signature Report file. The filename must be `signature-report.json`.

    Example:
    ```bash
    sudo /opt/app_protect/bin/get-signatures -o ./signature-report.json
    ```
1. Open an SSH connection to the management plane host and log in.
1. Replace the `signature-report.json` on your NGINX Management Suite's control plane at `/usr/share/nms/sigdb/signature-report.json` with the newly generated Signature Report.

    Example:
    ```bash
    sudo scp /path/to/signature-report.json {user}@{host}:/usr/share/nms/sigdb/signature-report.json
    ```
1. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```