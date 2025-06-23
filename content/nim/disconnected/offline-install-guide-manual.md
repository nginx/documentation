---
title: Manually install any version of NGINX Instance Manager (disconnected)
weight: 100
toc: true
noindex: true
type: how-to
product: NIM
nd-docs: DOCS-000
---

## Overview

This guide explains how to install and upgrade NGINX Instance Manager in environments without Internet access. It covers key steps, including downloading packages, managing dependencies, and configuring the system for offline use. You’ll also learn how to set up NGINX Instance Manager in disconnected mode and manually update the CVE list to keep your system secure.

## Before you begin

{{< call-out "important" "Complete the required prerequisites" "fas fa-exclamation-triangle" >}}
You must complete the following prerequisite steps **before** installing NGINX Instance Manager. **Skipping these steps could cause installation issues**.
{{</ call-out >}}

### Security considerations

To ensure that your NGINX Instance Manager deployment remains secure, follow these recommendations:

- Install NGINX Instance Manager on a dedicated machine (bare metal, container, cloud, or VM).
- Make sure no other services are running on the same machine.
- Ensure the machine is not accessible from the Internet.
- Place the machine behind a firewall.

### Download package files

To complete the steps in this guide, you need to download the NGINX Instance Manager package files from the [MyF5 Customer Portal](https://account.f5.com/myf5).

### Install local dependencies

Local dependencies are common Linux packages like `curl` or `openssl`, which most Linux distributions include by default. When installing NGINX Instance Manager, your package manager will automatically install these dependencies. Without internet access, ensure your package manager can use a local package repository, such as a distribution DVD/ISO image or internal network mirror. Check your Linux distribution's documentation for details.

{{< call-out "note" "RedHat on AWS" "fa-brands fa-aws" >}}If you're using AWS and can't attach remote or local RedHat package repositories, download the necessary packages on another RedHat machine and copy them to your target machine. Use the `yumdownloader` utility for this task:
<https://access.redhat.com/solutions/10154>.
{{</ call-out >}}

### Download and install external dependencies

External dependencies, such as ClickHouse and NGINX Plus, aren't included by default in standard Linux distributions. You need to manually download and transfer these to your offline system.

To download external dependencies:

1. Download the `fetch-external-dependencies.sh` script:

    {{< icon "download">}} {{<link "/scripts/fetch-external-dependencies.sh" "Download fetch-external-dependencies.sh script">}}

2. Run the script to download the external dependencies for your specific Linux distribution:

    ```bash
    sudo bash fetch-external-dependencies.sh <linux distribution>
    ```

    Supported Linux distributions:

    - `ubuntu20.04`
    - `ubuntu22.04`
    - `debian11`
    - `debian12`
    - `oracle7`
    - `oracle8`
    - `rhel8`
    - `rhel9`
    - `amzn2`

    **For example**, to download external dependencies for Ubuntu 20.04:

    ```bash
    sudo bash fetch-external-dependencies.sh ubuntu20.04
    ```

    This will create an archive, such as `nms-dependencies-ubuntu20.04.tar.gz`, containing the required dependencies.

3. Copy the archive to your target machine and extract the contents:

    {{< call-out "note" >}}The bundled NGINX server package may conflict with existing versions of NGINX or NGINX Plus. Delete the package from the bundle if you want to keep your current version.{{< /call-out >}}

    - **For RHEL and RPM-Based systems**:

        ```bash
        tar -kzxvf nms-dependencies-<linux-distribution>.tar.gz
        sudo rpm -ivh *.rpm
        ```

    - **For Debian, Ubuntu, Deb-based systems**:

        ```bash
        tar -kzxvf nms-dependencies-<linux-distribution>.tar.gz
        sudo dpkg -i ./*.deb
        ```

---

## Install NGINX Instance Manager {#install-nim-offline}

{{< call-out "important" "Save the password!" "" >}}
The administrator username (default: **admin**) and the generated password are displayed in the terminal during installation. Be sure to record the password and store it securely.
{{</ call-out >}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the NGINX Instance Manager package files.

2. Install the NGINX Instance Manager package:

   - **For RHEL and RPM-based systems**:

        ```bash
        sudo rpm -ivh --nosignature /home/<user>/nms-instance-manager_<version>.x86_64.rpm
        ```

   - **For Debian, Ubuntu, Deb-based systems**:

        ```bash
        sudo apt-get -y install -f /home/<user>/nms-instance-manager_<version>_amd64.deb
        ```

3. Enable and start NGINX Instance Manager services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
    ```

    {{< include "installation/nms-user.md" >}}

4. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

---

## Set the operation mode to disconnected {#set-mode-disconnected}

{{< include "nim/disconnected/set-mode-of-operation-disconnected.md" >}}

---

## Optional post-installation steps

### Configure ClickHouse

{{< include "nim/installation/optional-steps/configure-clickhouse.md" >}}

### Disable metrics collection

{{< include "nim/installation/optional-steps/disable-metrics-collection.md" >}}


### Install and configure Vault {#install-vault}

{{< include "nim/installation/optional-steps/install-configure-vault.md" >}}


### Configure SELinux

{{< include "nim/installation/optional-steps/configure-selinux.md" >}}

## Upgrade NGINX Instance Manager {#upgrade-nim-offline}

To upgrade NGINX Instance Manager to a newer version:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the latest package files.
2. Upgrade the package:
   - **For RHEL and RPM-based systems**:

        ``` bash
        sudo rpm -Uvh --nosignature /home/user/nms-instance-manager_<version>.x86_64.rpm
        sudo systemctl restart nms
        sudo systemctl restart nginx
        ```

   - **For Debian, Ubuntu, Deb-based systems**:

        ```bash
        sudo apt-get -y install -f /home/user/nms-instance-manager_<version>_amd64.deb
        sudo systemctl restart nms
        sudo systemctl restart nginx
        ```

    {{< include "installation/nms-user.md"  >}}

3.	(Optional) If you use SELinux, follow the [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md"  >}}) guide to restore SELinux contexts using restorecon for files and directories related to NGINX Instance Manager.

---

## CVE checking {#cve-check}

To manually update the CVE list in an air-gapped environment, follow these steps to download and overwrite the `cve.xml` file in the `/usr/share/nms` directory and restart the Data Plane Manager service:

```bash
sudo chmod 777 /usr/share/nms/cve.xml && \
sudo curl -s http://hg.nginx.org/nginx.org/raw-file/tip/xml/en/security_advisories.xml > /usr/share/nms/cve.xml && \
sudo chmod 644 /usr/share/nms/cve.xml && \
sudo systemctl restart nms-dpm
```

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
