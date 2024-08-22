---
description: Follow the steps in this guide to install or upgrade or upgrade the NGINX
  Management Suite Security Monitoring module.
docs: DOCS-1208
doctypes:
- tutorial
tags:
- docs
title: Install or Upgrade Security Monitoring
toc: true
weight: 40
---

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

{{%/tab%}}
{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of the Security Monitoring module, run the following commands:

    ```bash
    sudo apt-get update
    sudo apt-get install -y nms-sm
    ```

{{%/tab%}}

{{</tabs>}}

2. Restart the F5 NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

4. If running Security Monitoring v1.7.0 or higher, start the module:

   ```bash
   sudo systemctl start nms-sm
   ```


### Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}

### Add License

A valid license is required to make full use of all the features in Security Monitoring module.

Refer to the [Add a License]({{< relref "/nms/installation/add-license.md" >}}) topic for instructions on how to download and apply a trial license, subscription license, or Flexible Consumption Program license.

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

4. If running Security Monitoring v1.7.0 or higher, start the module:

   ```bash
   sudo systemctl start nms-sm
   ```

5. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nms/admin-guides/configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Management suite.

---

## What's Next

### Set Up Data Plane

To set up your NGINX App Protect WAF data plane instances for use with Security Monitoring, refer to the following instructions:

- [Set Up App Protect Instances for Security Monitoring]({{< relref "/nms/security/how-to/set-up-app-protect-instances" >}})
