---
description: This guide explains how to upgrade the NGINX Management Suite modules,
  NGINX Agent, and NGINX Plus.
docs: DOCS-920
doctypes:
- tutorial
tags:
- docs
title: Upgrade Guide
toc: true
weight: 500
---

## Overview

This guide explains how to upgrade the NGINX Management Suite modules, NGINX Agent, and NGINX Plus to their latest versions, including how to back up your current configuration, run the upgrade script, and verify the results. Also included are instructions for troubleshooting any potential upgrade errors.

---

## Pre-Upgrade Steps {#pre-upgrade-steps}

It's useful to have an upgrade plan before upgrading. Creating an upgrade plan can help you determine which tasks to complete before and after installing new versions the NGINX Management Suite modules and NGINX Agent.

### Review Essential Documentation {#essential-docs}

#### Release Notes {#release-notes}

Read the release notes for information about the latest features and changes, resolved issues, known issues, and supported upgrade paths.

- [Instance Manager Release Notes]({{< relref "/nms/nim/releases/release-notes.md" >}})
- [API Connectivity Manager Release Notes]({{< relref "/nms/acm/releases/release-notes.md" >}})
- [Security Monitoring Module]({{< relref "/nms/security/releases/release-notes.md" >}})

#### Tech Specs {#tech-specs}

Ensure your system meets the recommended requirements and settings NGINX Management Suite:

- [Technical Specifications Guide]({{< relref "/nms/tech-specs.md" >}})

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

Follow the steps in the [Backup and Recovery Guide]({{< relref "/nms/admin-guides/maintenance/backup-and-recovery.md" >}}) to back up essential system files for NGINX Management Suite.

### Upgrade a Test Server

We recommend upgrading NGINX Management Suite in a test environment before upgrading your production environment. By doing this, you will be able to identify any potential issues that might interfere with the upgrade.

---

## Upgrade NGINX Management Suite Modules

### Instance Manager

- [Upgrade Instance Manager on a virtual machine or bare metal]({{< relref "/nms/installation/vm-bare-metal/install-nim.md#upgrade-nim" >}})
- [Upgrade Instance Manager from a Helm Chart]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md#helm-upgrade-nim" >}})
- [Upgrade Instance Manager in an offline environment]({{< relref "/nms/installation/vm-bare-metal/offline-install-guide.md#upgrade-nim-offline" >}})

### Security Monitoring

- [Upgrade Security Monitoring on a virtual machine or bare metal]({{< relref "/nms/installation/vm-bare-metal/install-security-monitoring.md#upgrade-security-monitoring" >}})

---

## Upgrade NGINX Agent {#upgrade-nginx-agent}

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

- You can [create a support package]({{< relref "/nms/support/support-package.md" >}}) if you have problems with the upgrade. The support package script packages system and service information into a tar archive for troubleshooting and debugging purposes. If you need to [contact NGINX Customer support]({{< relref "/nms/support/contact-support.md" >}}), they may ask you to provide a support package file.
- The [AskF5 knowledge base](https://support.f5.com/csp/home) is a helpful place to look for articles related to upgrade issues and solutions.
