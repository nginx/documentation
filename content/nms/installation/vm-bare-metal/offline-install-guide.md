---
description: Complete the steps in this guide to install F5 NGINX Management Suite modules
  directly from package files in environments without Internet access.
docs: DOCS-803
doctypes:
- tutorial
tags:
- docs
title: Offline Installation Guide
toc: true
weight: 300
---

## Overview

{{< include "nms/nim-core-module.md" >}}

---

## Prerequisites

{{<important>}}
You must complete the following prerequisite steps before installing any of the F5 NGINX Management Suite modules. Neglecting to do so could result in a module not installing correctly or not installing at all.
{{</important>}}

### Security Considerations

{{< include "installation/secure-installation.md" >}}

### Download Package Files

To complete the steps in this guide, you need the following:

- Download the NGINX Management Suite package files from the [MyF5 Customer Portal](https://account.f5.com/myf5).

### Local Dependencies

Local dependencies are common Linux packages like `curl` or `openssl`, which most Linux distributions include by default. These dependencies are installed automatically by your package manager when installing an NGINX Management Suite module. Without internet access, you need to ensure that your package manager can use a local package repository, such as your distribution DVD/ISO image or internal network mirror. Refer to your Linux distribution documentation for more details.

{{< note >}}**RedHat on AWS**: If you're using Amazon Web Services and, for security reasons, you can't attach remote or local RedHat package repositories, you can download the necessary packages on another RedHat machine and copy them to your machine. To do this, you can use the `yumdownloader` utility:
<https://access.redhat.com/solutions/10154>.
{{< / note >}}

### Download and Install External Dependencies

External dependencies are packages that aren't available by default in regular Linux distributions. For example, ClickHouse and NGINX Plus.

Before installing NGINX Management Suite on an offline system, you must manually download the external dependencies and copy them to your machine.

To download the external dependencies:

1. Select the following link to download the `fetch-external-dependencies.sh` script. This script downloads the necessary packages to a `tar.gz` archive.

    {{<fa "download">}} {{<link "/scripts/fetch-external-dependencies.sh" "Download fetch-external-dependencies.sh script">}}

2. Run the `fetch-external-dependencies.sh` script to download the external dependencies. Specify your Linux distribution for the packages.

    ```bash
    sudo bash fetch-external-dependencies.sh <linux distribution>
    ```

    Supported Linux distributions:

    - `ubuntu20.04`
    - `ubuntu22.04`
    - `debian11`
    - `debian12`
    - `centos7`
    - `oracle7`
    - `oracle8`
    - `rhel7`
    - `rhel8`
    - `rhel9`
    - `amzn2`

    For example, to download external dependencies for Ubuntu 20.04:

    ```bash
    sudo bash fetch-external-dependencies.sh ubuntu20.04
    ```

    In this example, the script creates an archive called `nms-dependencies-ubuntu20.04.tar.gz` with the external dependencies.

3. After you copy and extract the bundle onto your target machine, take the following steps to install the packages:

    {{< note >}}The bundled NGINX server package may conflict with installed versions of NGINX or NGINX Plus. Delete the package from the bundle if you want to keep the existing version.{{< /note >}}

    {{<tabs name="install-nms-dependencies">}}
    {{%tab name="CentOS, RHEL, and RPM-Based"%}}

  ```bash
  tar -kzxvf nms-dependencies-<linux-distribution>.tar.gz
  sudo rpm -ivh *.rpm
  ```

    {{%/tab%}}
    {{%tab name="Debian, Ubuntu, and Deb-Based"%}}

```bash
tar -kzxvf nms-dependencies-<linux-distribution>.tar.gz
sudo dpkg -i ./*.deb
```

{{%/tab%}}
{{</tabs>}}

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> When installing ClickHouse, you have the option to specify a password or leave the password blank (the default is an empty string). If you choose to specify a password for ClickHouse, you must also edit the `/etc/nms/nms.conf` file after installing NGINX Management Suite and enter your ClickHouse password; otherwise, NGINX Management Suite won't start.
    >
    > For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< relref "/nms/admin-guides/configuration/configure-clickhouse.md" >}}) topic.

---

## Install or Upgrade Instance Manager {#install-or-upgrade-nim-offline}

### Install Instance Manager {#install-nim-offline}

{{<tabs name="install_nim_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

To install Instance Manager, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files.

2. Install the Instance Manager package:

   ```bash
   sudo rpm -ivh --nosignature /home/<user>/nms-instance-manager_<version>.x86_64.rpm
   ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> The Instance Manager's administrator username (default is `admin`) and generated password are displayed in the terminal during installation. You should make a note of the password and store it securely.

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

To install Instance Manager, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files.

2. Install the Instance Manager package:

   ```bash
   sudo apt-get -y install -f /home/<user>/nms-instance-manager_<version>_amd64.deb
   ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> The Instance Manager's administrator username (default is `admin`) and generated password are displayed in the terminal during installation. You should make a note of the password and store it securely.

{{%/tab%}}
{{</tabs>}}

3. Enable and start the NGINX Management Suite platform services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

4. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

### Post-Installation Steps {#nim-post-install-steps}

{{< include "installation/optional-installation-steps.md" >}}

See these topics below for instructions on how to access the web interface and add your license:

- [Access the web interface](#access-web-ui)
- [Add a license](#add-license)

### Upgrade Instance Manager {#upgrade-nim-offline}

{{<tabs name="upgrade-nim-offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

To upgrade Instance Manager to a newer version, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files.

2. Upgrade the Instance Manager package:

   ```bash
   sudo rpm -Uvh --nosignature /home/user/nms-instance-manager_<version>.x86_64.rpm
   ```

3. Restart the NGINX Management Suite platform services:

   ```bash
   sudo systemctl restart nms
   ```

   NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

To upgrade Instance Manager to a newer version, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Instance Manager package files.

2. Upgrade the Instance Manager package:

   ```bash
   sudo apt-get -y install -f /home/user/nms-instance-manager_<version>_amd64.deb
   ```

   ```bash
   sudo systemctl restart nms
   ```

{{%/tab%}}
{{</tabs>}}

4. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

5. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nms/admin-guides/configuration/configure-selinux.md" >}}) guide to restore SELinux contexts (`restorecon`) for the files and directories related to NGINX Management Suite.

---

## Accessing the Web Interface {#access-web-ui}

{{< include "installation/access-web-ui.md" >}}

---
## Add License {#add-license}

A valid license is required to make full use of all the features in NGINX Management Suite.

Refer to the [Add a License]({{< relref "/nms/installation/add-license.md" >}}) topic for instructions on how to download and apply a trial license, subscription license, or Flexible Consumption Program license.

---

## CVE Checking {#cve-check}

Instance Manager connects to the Internet to get a list of the current CVEs (Common Vulnerabilities and Exposures) to use with the [scan function]({{< relref "/nms/nim/how-to/monitoring/scan-instances.md" >}}). To manually update the CVE list, download and overwrite the `cve.xml` file in the `/usr/share/nms` directory.

To download the CVE file, take the following steps:

1. Change permissions of the CVE file:

    ```bash
    sudo chmod 777 /usr/share/nms/cve.xml
    ```

2. Download the CVE file:

    ```bash
    sudo curl -s http://hg.nginx.org/nginx.org/raw-file/tip/xml/en/security_advisories.xml > /usr/share/nms/cve.xml
    ```

3. Change permissions of the CVE file:

    ```bash
    sudo chmod 644 /usr/share/nms/cve.xml
    ```

4. Restart the Data Plane Manager service to pick up the new CVE file:

    ```bash
    systemctl restart nms-dpm
    ```

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}
