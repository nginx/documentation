---
description: Follow the steps in this guide to install or upgrade NGINX Management
  Suite Instance Manager.
docs: DOCS-1211
doctypes:
- tutorial
tags:
- docs
title: Install or Upgrade Instance Manager
toc: true
weight: 10
---

---

## Before You Begin

### Security Considerations

{{< include "installation/secure-installation.md" >}}

### Installation Prerequisites

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

2. Enable and start the NGINX Management Suite platform services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
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

A valid license is required to make full use of all the features in Instance Manager.

Refer to the [Add a License]({{< relref "/nms/installation/add-license.md" >}}) topic for instructions on how to download and apply a trial license, subscription license, or Flexible Consumption Program license.

---

## Upgrade Instance Manager {#upgrade-nim}

{{<tabs name="upgrade_nim">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of the Instance Manger, run the following command:

   ```bash
   sudo yum update -y nms-instance-manager
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of the Instance Manager, run the following command:

   ```bash
   sudo apt-get update
   sudo apt-get install -y --only-upgrade nms-instance-manager
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

### Set Up the Data Plane

Complete the following steps for each data plane instance you want to manage using Instance Manager:

- [Install NGINX OSS or NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/) on your data plane instances.
- [Install the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) on your data plane instances to register them with NGINX Management Suite.

### Set up NGINX App Protect WAF

- To set up Instance Manager to manage configurations for NGINX App Protect WAF, follow the steps in the [Set Up App Protect WAF Configuration Management]({{< relref "/nms/nim/how-to/app-protect/setup-waf-config-management" >}}) guide.

### Install Other NGINX Management Suite Modules

- [Install API Connectivity Manager]({{< relref "/nms/acm/how-to/install-acm.md" >}})
- [Install Security Monitoring]({{< relref "/nms/installation/vm-bare-metal/install-security-monitoring.md" >}})
