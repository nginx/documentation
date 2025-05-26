---
description: ''
docs: DOCS-1211
title: Manually install on a virtual machine or bare metal (deprecated)
toc: true
weight: 10
noindex: true
type:
- tutorial
---

## Overview

Follow the steps in this guide to install or upgrade NGINX Instance Manager.

{{<call-out "caution" "Deprecated documentation notice" "fa fa-exclamation-triangle" >}}
This document outlines manual steps that have been replaced by a simplified script-based process. For most users, we recommend using the updated process documented [here]({{< ref "nim/deploy/vm-bare-metal/install.md" >}}).{{</call-out>}}

## Before You Begin

### Security Considerations

{{< include "installation/secure-installation.md" >}}

### Requirements {#requirements}

To install NGINX Instance Manager, you need the following:

- A trial or paid subscription for NGINX Instance Manager. [Sign up for NGINX Instance Manager at MyF5](https://account.f5.com/myf5).
- A Linux instance to host the NGINX Instance Manager platform and modules
- [NGINX Plus or NGINX OSS](#install-nginx) installed on the instance hosting NGINX Instance Manager

Allow external systems access by opening network firewalls. NGINX Instance Manager uses port `443` for both gRPC and API/web interfaces.

---

## Download Certificate and Key {#download-cert-key}

Follow these steps to download the certificate and private key for NGINX Instance Manager. You'll need these files when adding the official repository for installing NGINX Instance Manager. You can also use the certificate and key when installing NGINX Plus.

1. On the host where you're installing NGINX Instance Manager, create the `/etc/ssl/nginx/` directory:

   ``` bash
   sudo mkdir -p /etc/ssl/nginx
   ```

2. Download the NGINX Instance Manager `.crt` and `.key` files from [MyF5](https://account.f5.com/myf5) or follow the download link in your  trial activation email.

3. Move and rename the `.crt` and `.key` files:

   ```bash
   sudo mv <nginx-mgmt-suite-trial.crt> /etc/ssl/nginx/nginx-repo.crt
   sudo mv <nginx-mgmt-suite-trial.key> /etc/ssl/nginx/nginx-repo.key
   ```

   {{<note>}}The downloaded filenames may vary depending on your subscription type. Modify the commands above accordingly to match the actual filenames.{{</note>}}

---

## Install NGINX {#install-nginx}

Install NGINX Open Source or NGINX Plus on the host where you'll install NGINX Instance Manager. NGINX Instance Manager uses NGINX as a front-end proxy and for managing user access.

- [Installing NGINX and NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/)

   {{<note>}}If you're installing NGINX Plus, you can use the `nginx-repo.key` and `nginx-repo.crt` that you added in the [previous section](#download-cert-key).{{</note>}}

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

</details>

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "nim/tech-specs/supported-distros.md" >}}

</details>

{{<see-also>}}Make sure to review the [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs" >}}) guide for sizing requirements and other recommended specs.{{</see-also>}}

---

## Install ClickHouse {#install-clickhouse}

{{<note>}}NGINX Instance Manager requires ClickHouse 22.3.15.33 or later.{{</note>}}

NGINX Instance Manager uses [ClickHouse](https://clickhouse.com) to store metrics, events, and alerts, as well as configuration settings.

Select the tab for your Linux distribution, then follow the instructions to install ClickHouse.

{{<tabs name="clickhouse">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

To install and enable ClickHouse CentOS, RHEL, and RPM-Based distributions, take the following steps:

1. Set up the repository:

    ``` bash
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
    ```

1. Install the ClickHouse server and client:

    ```bash
    sudo yum install -y clickhouse-server clickhouse-client
    ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> When installing ClickHouse, you have the option to specify a password or leave the password blank (the default is an empty string). If you choose to specify a password for ClickHouse, you must also edit the `/etc/nms/nms.conf` file after installing NGINX Instance Manager and enter your ClickHouse password; otherwise, NGINX Instance Manager won't start.
    >
    > For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< ref "nim/system-configuration/configure-clickhouse.md" >}}) topic.

1. Enable ClickHouse so that it starts automatically if the server is restarted:

    ```bash
    sudo systemctl enable clickhouse-server
    ```

1. Start the ClickHouse server:

    ```bash
    sudo systemctl start clickhouse-server
    ```

1. Verify ClickHouse is running:

    ```bash
    sudo systemctl status clickhouse-server
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

To install and enable ClickHouse on Debian, Ubuntu, and Deb-Based distributions, take the following steps:

1. Set up the repository:

   ```bash
   sudo apt-get install -y apt-transport-https ca-certificates dirmngr
   GNUPGHOME=$(mktemp -d)
   sudo GNUPGHOME="$GNUPGHOME" gpg --no-default-keyring --keyring /usr/share/keyrings/clickhouse-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8919F6BD2B48D754
   sudo rm -r "$GNUPGHOME"
   sudo chmod +r /usr/share/keyrings/clickhouse-keyring.gpg

   echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb lts main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
   sudo apt-get update
   ```

1. Install the ClickHouse server and client:

    ``` bash
    sudo apt-get install -y clickhouse-server clickhouse-client
    ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> When installing ClickHouse, you have the option to specify a password or leave the password blank (the default is an empty string). If you choose to specify a password for ClickHouse, you must also edit the `/etc/nms/nms.conf` file after installing NGINX Instance Manager and enter your ClickHouse password; otherwise, NGINX Instance Manager won't start.
    >
    > For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< ref "nim/system-configuration/configure-clickhouse.md" >}}) topic.

1. Enable ClickHouse so that it starts automatically if the server is restarted:

    ```bash
    sudo systemctl enable clickhouse-server
    ```

1. Start the ClickHouse server:

    ``` bash
    sudo systemctl start clickhouse-server
    ```

1. Verify ClickHouse is running:

    ```bash
    sudo systemctl status clickhouse-server
    ```

{{%/tab%}}

{{</tabs>}}

### ClickHouse Default Settings

NGINX Instance Manager uses the following default values for ClickHouse:

{{<important>}}You can customize these settings. However, if you use custom settings, make sure to follow the [Configure ClickHouse]({{< ref "nim/system-configuration/configure-clickhouse.md" >}}) instructions to update the `nms.conf` file after you've installed NGINX Instance Manager; otherwise NGINX Instance Manager won't be able to connect to ClickHouse.{{</important>}}

{{< include "installation/clickhouse-defaults.md" >}}

---

## (Optional) Install and Configure Vault {#install-vault}

NGINX Instance Manager can use [Vault](https://www.vaultproject.io/) as a datastore for secrets.

To install and enable Vault, take the following steps:

- Follow Vault's instructions to [install Vault 1.8.8 or later](https://www.vaultproject.io/docs/install) for your distribution.
- Ensure you are running Vault in a [Production Hardened Environment](https://learn.hashicorp.com/tutorials/vault/production-hardening).
- After installing NGINX Instance Manager, follow the steps to [Configure Vault for Storing Secrets]({{< ref "nim/system-configuration/configure-vault.md" >}}).

---

## Add NGINX Instance Manager Repository {#add-nms-repo}

To install NGINX Instance Manager, you need to add the official repository to pull the pre-compiled `deb` and `rpm` packages from.

{{< include "installation/add-nms-repo.md" >}}

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

2. Enable and start the NGINX Instance Manager platform services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

### Post-Installation Steps

{{< include "installation/optional-installation-steps.md" >}}

### Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}


### Add License

{{< include "nim/admin-guide/license/connected-install-license-note.md" >}}

---

## Upgrade Instance Manager {#upgrade-nim}

{{<tabs name="upgrade_nim">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of the Instance Manager, run the following command:

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

2. Restart the NGINX Instance Manager platform services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

4. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "nim/system-configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Management suite.
