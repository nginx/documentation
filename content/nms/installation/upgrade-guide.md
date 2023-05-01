---
title: "Upgrade Guide"
date: 2022-03-30T14:13:00-07:00
description: "This guide explains how to upgrade the NGINX Management Suite modules, NGINX Agent, and NGINX Plus."
# Assign weights in increments of 100
weight: 500
draft: false
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-920"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
aliases:
- /nginx-instance-manager/installation/upgrade-guide/
---

{{< custom-styles >}}

## Overview

This guide explains how to upgrade the NGINX Management Suite modules, NGINX Agent, and NGINX Plus to their latest versions, including how to back up your current configuration, run the upgrade script, and verify the results. Also included are instructions for troubleshooting any potential upgrade errors.

<br>

{{<see-also>}}If you're upgrading from Instance Manager v1.x, follow the steps in the [migration guide]({{< relref "nim/migration-guide.md" >}}) to get started. It is not possible to upgrade directly from Instance Manager v1.x to v2.x.{{</see-also>}}

---

## Pre-Upgrade Steps {#pre-upgrade-steps}

It's useful to have an upgrade plan before upgrading. Creating an upgrade plan can help you determine which tasks to complete before and after installing new versions the NGINX Management Suite modules and NGINX Agent.

### Review Essential Documentation {#essential-docs}

#### Release Notes {#release-notes}

Read the release notes for information about the latest features and changes, resolved issues, known issues, and supported upgrade paths.

- [Instance Manager Release Notes]({{< relref "/nim/releases/release-notes.md" >}})
- [API Connectivity Manager Release Notes]({{< relref "/acm/releases/release-notes.md" >}})
- [App Delivery Manager Release Notes]({{< relref "/adm/releases/release-notes.md" >}})
- [Security Monitoring Module]({{< relref "/security/releases/release-notes.md" >}})

#### Tech Specs {#tech-specs}

Ensure your system meets the recommended requirements and settings NGINX Management Suite:

- [Technical Specifications Guide]({{< relref "/tech-specs.md" >}})

### Verify the Upgrade Path {#verify-upgrade-path}

You can find the supported upgrade paths in the [release notes](#release-notes), linked above.

Make sure your current installation can be updated to the target version. You may be able to upgrade directly to the target version, or you may have to upgrade first to an intermediate version.

{{< include "nms/look-up-version.md" >}}

### Schedule a Maintenance Window

Plan the time when the upgrade will take place. Be sure to let users know when the upgrade will take place and how they might be affected.

Upgrades take under a minute for NGINX Management Suite modules and as long for the NGINX Agent. How long the entire upgrade process takes depends on how many NGINX Agents you need to upgrade. Include time for testing and verifying the upgrade as well.

During an upgrade, you will need to stop the NGINX Agent. Stopping the NGINX Agent results in the following conditions:

- You won't be able to publish configuration changes;
- Metrics reporting will be queued and picked up once the NGINX Agent is restarted;
- Client connections to the NGINX Management Suite host may be disconnected;
- In the course of the upgrade, users may be logged out and will need to re-authenticate.

### Back Up System Files

Follow the steps in the [Backup and Recovery Guide]({{< relref "/admin-guides/maintenance/backup-and-recovery.md" >}}) to back up essential system files for NGINX Management Suite.

### Upgrade a Test Server

We recommend upgrading NGINX Management Suite in a test environment before upgrading your production environment. By doing this, you will be able to identify any potential issues that might interfere with the upgrade.

---

## Upgrade Instance Manager {#upgrade-instance-manager}

Select the upgrade procedure that's appropriate for your environment:

<details>
<summary>Upgrade Instance Manager from the NGINX Management Suite repo</summary>

#### Upgrade Instance Manager from NGINX Management Suite Repo

This section explains how to upgrade Instance Manager using a Linux package manager -- Yum or Apt -- to retrieve packages from a public repository. You'll need to have Internet access to complete these steps.

If you don't have access to the Internet, refer to the [Upgrade in an Offline Environment](#upgrade-nim-offline) section.

{{< include "nim/installation/upgrade-nim.md" >}}
</details>

<details>
<summary>Upgrade Instance Manager in an offline environment</summary>

#### Upgrade Instance Manager Offline

{{< include "nim/installation/upgrade-nim-offline.md" >}}

</details>

<details>
<summary>Upgrade Instance Manager from a Helm chart</summary>

- Follow the upgrade steps in the [Deploy NGINX Management Suite using Helm]({{<relref "installation/kubernetes/nms-helm.md#helm-upgrade-nms" >}}) guide.

</details>

---

## Upgrade API Connectivity Manager {#upgrade-api-connectivity-manager}

Select the upgrade procedure that's appropriate for your environment:

<details>
<summary>Upgrade API Connectivity Manager from the NGINX Management Suite repo</summary>

#### Upgrade API Connectivity Manager from NGINX Management Suite Repo

Upgrade API Connectivity Manager from the NGINX Management Suite Repo:

This section explains how to upgrade API Connectivity Manager using a Linux package manager -- Yum or Apt -- to retrieve packages from a public repository. You'll need to have Internet access to complete these steps.

{{< include "acm/installation/upgrade-acm.md" >}}

</details>

<details>
<summary>Upgrade Developer Portal from the NGINX Management Suite repo</summary>

#### Upgrade the Developer Portal from NGINX Management Suite Repo {#upgrade-acm-dev-portal}

This section explains how to upgrade the Developer Portal using a Linux package manager -- Yum or Apt -- to retrieve packages from a public repository. You'll need to have Internet access to complete these steps.

{{< include "acm/installation/upgrade-acm-dev-portal.md" >}}

</details>

<details>
<summary>Upgrade API Connectivity Manager in an offline environment</summary>

#### Upgrade API Connectivity Manager Offline {#upgrade-acm-offline}

{{< include "acm/installation/upgrade-acm-offline.md" >}}

</details>

<details>
<summary>Upgrade Developer Portal in an offline environment</summary>

#### Upgrade the Developer Portal Offline {#upgrade-acm-dev-portal-offline}

{{< include "acm/installation/upgrade-acm-dev-portal-offline.md" >}}

</details>

---

## Upgrade App Delivery Manager {#upgrade-app-delivery-manager}

Select the upgrade procedure that's appropriate for your environment:

<details>
<summary>Upgrade App Delivery Manager from the NGINX Management Suite repo</summary>

#### Upgrade App Delivery Manager from NGINX Management Suite Repo

Upgrade App Delivery Manager from the NGINX Management Suite Repo:

This section explains how to upgrade App Delivery Manager using a Linux package manager -- Yum or Apt -- to retrieve packages from a public repository. You'll need to have Internet access to complete these steps.

{{< include "adm/installation/upgrade-adm.md" >}}

</details>

<details>
<summary>Upgrade App Delivery Manager in an offline environment</summary>

#### Upgrade App Delivery Manager Offline {#upgrade-adm-offline}

{{< include "adm/installation/upgrade-adm-offline.md" >}}

</details>

---

## Upgrade the Security Monitoring module {#upgrade-security-monitoring}

{{< important >}}Confirm that you have [updated Instance Manager](#upgrade-instance-manager) to the correct version before upgrading the Security Monitoring module.
See the [Dependencies with Instance Manager]({{< relref "/overview/tech-specs.md#dependencies-with-instance-manager-1" >}}) topic for more information.{{< /important >}}

{{< include "security/upgrade-security-module.md" >}}

## Upgrade the NGINX Agent {#upgrade-nginx-agent}

{{< important >}}You should upgrade the NGINX Agent whenever you upgrade NGINX Management Suite in order to ensure compatibility between the two versions. Failing to do so could lead to potential issues.{{< /important >}}

{{< include "agent/installation/upgrade-nginx-agent.md" >}}

---

## Upgrade NGINX Plus

We encourage you to upgrade NGINX Plus to take advantage of the latest improvements and features.

1. Follow the steps to [upgrade NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/#upgrading-nginx-plus) for your distribution.

2. After upgrading NGINX Plus, restart the NGINX Agent:

   ```bash
   sudo systemctl restart nginx-agent
   ```

---

## Troubleshooting

- {{< include "support/troubleshooting-guide.md" >}}

- You can [create a support package]({{< relref "/support-package.md" >}}) if you have problems with the upgrade. The support package script packages system and service information into a tar archive for troubleshooting and debugging purposes. If you need to [contact NGINX Customer support]({{< relref "/support/contact-support.md" >}}), they may ask you to provide a support package file.
- The [AskF5 knowledge base](https://support.f5.com/csp/home) is a helpful place to look for articles related to upgrade issues and solutions.
