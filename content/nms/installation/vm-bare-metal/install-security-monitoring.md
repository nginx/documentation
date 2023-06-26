---
title: "Install or Upgrade Security Monitoring"
date: 2023-04-06T12:00:00-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to install or upgrade or upgrade the NGINX Management Suite Security Monitoring module."
# Assign weights in increments of 100
weight: 40
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1208"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
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

{{< include "tech-specs/security-management-plane-dependencies.md" >}}

---

## Install Security Monitoring

{{<tabs name="install-security-monitoring">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the latest version of the Security Monitoring module, run the following command:

     ```bash
     sudo yum -y install nms-sm
     ```

1. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

1. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of the Security Monitoring module, run the following commands:

    ```bash
    sudo apt-get update
    sudo apt-get install -y nms-sm
    ```

1. Restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

1. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

{{%/tab%}}

{{</tabs>}}

### Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}

### Add License

A valid license is required in order to use the Security Monitoring module.

#### Download License

{{< include "installation/download-trial-license.md" >}}

#### Apply License

{{< include "installation/add-license.md" >}}

---

## Upgrade Security Monitoring {#upgrade-security-monitoring}

{{<call-out "important" "Instance Manager Dependency" >}}The upgrade process for Security Monitoring **does not** automatically upgrade Instance Manager, which is a package dependency. To ensure compatibility with Security Monitoring, you will need to manually [upgrade Instance Manager]({{< relref "/nms/installation/vm-bare-metal/install-nim.md#upgrade-nim" >}}) to a version supported by Security Monitoring. For specific version dependencies between Security Monitoring and Instance Manager, refer to the [Security Monitoring release notes]({{< relref "/nms/security/releases/release-notes.md" >}}).{{</call-out>}}

<br>

{{<tabs name="upgrade_adm">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of Security Monitoring, run the following command:

   ```bash
   sudo yum update -y nms-sm
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of the Security Monitoring, run the following command:

   ```bash
   sudo apt-get update
   sudo apt-get install -y --only-upgrade nms-sm
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

4. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nms/admin-guides/configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Management suite.

---

## What's Next

### Set Up Data Plane

To set up your NGINX App Protect WAF data plane instances for use with Security Monitoring, refer to the following instructions:

- [Set Up App Protect Instances for Security Monitoring]({{< relref "/nms/security/how-to/set-up-app-protect-instances" >}})

### Install Other NGINX Management Suite Modules

- [Install API Connectivity Manager]({{< relref "/nms/installation/vm-bare-metal/install-acm.md" >}})
- [Install App Delivery Manager]({{< relref "/nms/installation/vm-bare-metal/install-adm.md" >}})
