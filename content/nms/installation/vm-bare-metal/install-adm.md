---
title: "Install or Upgrade App Delivery Manager"
date: 2023-04-13T15:19:49-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to install or upgrade NGINX Management Suite App Delivery Manager."
# Assign weights in increments of 100
weight: 30
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1210"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["beta", "tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{< custom-styles >}}

---

## Before You Begin

### Security Considerations

{{< include "installation/secure-installation.md" >}}

### Installation Prerequisites

{{< include "installation/nms-prerequisites.md" >}}

### Dependencies with Instance Manager

{{< include "tech-specs/adm-nim-dependencies.md" >}}

---

## Install App Delivery Manager

{{<tabs name="install-adm">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the latest version of App Delivery Manager, run the following command:

    ```bash
    sudo yum install -y nms-app-delivery-manager
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of App Delivery Manager, run the following commands:

    ```bash
    sudo apt-get update
    sudo apt-get install nms-app-delivery-manager
    ```

{{%/tab%}}

{{</tabs>}}

2. Enable and start the NGINX Management Suite services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations nms-adm --now
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

### Post-Installation Steps

{{< include "installation/optional-installation-steps.md" >}}

### Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}

### Add License

A valid license is required in order to use App Delivery Manager.

#### Download License

{{< include "adm/installation/license-adm.md" >}}

#### Apply License

{{< include "installation/add-license.md" >}}

---

## Upgrade App Delivery Manager {#upgrade-adm}

{{<note>}}When you confirm the upgrade, the upgrade process will automatically upgrade dependent packages as needed, including Instance Manager. If you prefer to [back up NGINX Management Suite]({{< relref "/nms/admin-guides/maintenance/backup-and-recovery.md" >}}) before upgrading, you can cancel the upgrade when prompted.{{</note>}}

<br>

{{<tabs name="upgrade_adm">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of App Delivery Manager, run the following command:

   ```bash
   sudo yum update -y nms-app-delivery-manager
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of App Delivery Manager, run the following command:

   ```bash
   sudo apt-get update
   sudo apt-get install -y --only-upgrade nms-app-delivery-manager
   ```

{{%/tab%}}
{{</tabs>}}

2. Restart the NGINX Management Suite platform services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

4. Restart the App Delivery service:

   ```bash
   sudo systemctl restart nms-adm
   ```

5. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nms/admin-guides/configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Management suite.

---

## What's Next

### Set Up the Data Plane

{{< include "adm/installation/install-adm-dataplane-dependencies.md" >}}

### Install Other NGINX Management Suite Modules

- [Install API Connectivity Manager]({{< relref "/nms/installation/vm-bare-metal/install-acm.md" >}})
- [Install Security Monitoring]({{< relref "/nms/installation/vm-bare-metal/install-security-monitoring.md" >}})
