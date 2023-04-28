---
title: "Install Instance Manager"
date: 2023-04-06T11:59:44-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to install NGINX Management Suite Instance Manager."
# Assign weights in increments of 100
weight: 10
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
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

### Install Prerequisites

{{< include "installation/nms-prerequisites.md" >}}

---

## Install Instance Manager

{{<tabs name="install-nim">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the latest version of Instance Manager, run the following command:

    ```bash
    sudo yum install -y nms-instance-manager
    ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> The Instance Manager's administrator username (default is `admin`) and generated password are displayed in the terminal during installation. You should make a note of the password and store it securely.

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of Instance Manager, run the following commands:

    ```bash
    sudo apt-get update
    sudo apt-get install -y nms-instance-manager
    ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> The Instance Manager's administrator username (default is `admin`) and generated password are displayed in the terminal during installation. You should make a note of the password and store it securely.

{{%/tab%}}

{{</tabs>}}

2. Enable and start the platform services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

</details>

### Post-Installation Steps

{{< include "installation/optional-installation-steps.md" >}}

### Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}

---

## Add License

A valid license is required in order to use all of the features in Instance Manager.

### Download License

{{< include "installation/download-license.md" >}}

### Apply License

{{< include "installation/add-license.md" >}}

---

## Set Up the Data Plane

To manage your data plane with NGINX Management Suite, complete the following tasks:

- [Install NGINX OSS or NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/) on your data plane instances.
- [Install the NGINX Agent]({{< relref "nginx-agent/install-nginx-agent.md" >}}) on your data plane instances to register them with NGINX Management Suite.

---

## What's Next

### Set up NGINX App Protect WAF

- To set up Instance Manager to manage configurations for NGINX App Protect WAF, follow the steps in the [Set Up App Protect WAF Configuration Management]({{< relref "/nim/how-to/app-protect/setup-waf-config-management" >}}) guide.

### Install Other NGINX Management Suite Modules

- [Install API Connectivity Manager]({{< relref "installation/on-prem/install-acm.md" >}})
- [Install App Delivery Manager]({{< relref "installation/on-prem/install-adm.md" >}})
- [Install Security Monitoring]({{< relref "installation/on-prem/install-security-monitoring.md" >}})
