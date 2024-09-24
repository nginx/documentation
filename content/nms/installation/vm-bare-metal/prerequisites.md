---
description: Follow the steps in this guide to install the prerequisites for NGINX
  Management Suite.
docs: DOCS-1212
doctypes:
- tutorial
tags:
- docs
title: Prerequisites
toc: true
weight: 1
---

## Overview

### Requirements {#requirements}

To install F5 NGINX Management Suite, you need the following:

- A trial or paid subscription for NGINX Management Suite. [Sign up for NGINX Management Suite at MyF5](https://account.f5.com/myf5).
- A Linux instance to host the NGINX Management Suite platform and modules
- [NGINX Plus or NGINX OSS](#install-nginx) installed on the instance hosting NGINX Management Suite

Allow external systems access by opening network firewalls. NGINX Management Suite uses port `443` for both gRPC and API/web interfaces.

### Installation Workflow {#installation-workflow}

The following diagram shows the steps required to install NGINX Management Suite. This page will guide you through the process of installing the prerequisites.

![NGINX Management Suite installation workflow](/install/nms-installation.png)

---

## Download Certificate and Key {#download-cert-key}

Follow these steps to download the certificate and private key for NGINX Management Suite. You'll need these files when adding the official repository for installing NGINX Management Suite. You can also use the certificate and key when installing NGINX Plus.

1. On the host where you're installing NGINX Management Suite, create the `/etc/ssl/nginx/` directory:

   ``` bash
   sudo mkdir -p /etc/ssl/nginx
   ```

2. Download the NGINX Management Suite `.crt` and `.key` files from [MyF5](https://account.f5.com/myf5) or follow the download link in your  trial activation email.

3. Move and rename the `.crt` and `.key` files:

   ```bash
   sudo mv <nginx-mgmt-suite-trial.crt> /etc/ssl/nginx/nginx-repo.crt
   sudo mv <nginx-mgmt-suite-trial.key> /etc/ssl/nginx/nginx-repo.key
   ```

   {{<note>}}The downloaded filenames may vary depending on your subscription type. Modify the commands above accordingly to match the actual filenames.{{</note>}}

---

## Install NGINX {#install-nginx}

Install NGINX Open Source or NGINX Plus on the host where you'll install NGINX Management Suite. NGINX Management Suite uses NGINX as a front-end proxy and for managing user access.

- [Installing NGINX and NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/)

   {{<note>}}If you're installing NGINX Plus, you can use the `nginx-repo.key` and `nginx-repo.crt` that you added in the [previous section](#download-cert-key).{{</note>}}

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

{{< include "tech-specs/supported-nginx-versions.md" >}}

</details>

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/nms-supported-distros.md" >}}

</details>

{{<see-also>}}Make sure to review the [Technical Specifications]({{< relref "tech-specs" >}}) guide for sizing requirements and other recommended specs.{{</see-also>}}

---

## Install ClickHouse {#install-clickhouse}

{{<note>}}NGINX Management Suite requires ClickHouse 22.3.15.33 or later.{{</note>}}

NGINX Management Suite uses [ClickHouse](https://clickhouse.com) to store metrics, events, and alerts, as well as configuration settings.

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

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> When installing ClickHouse, you have the option to specify a password or leave the password blank (the default is an empty string). If you choose to specify a password for ClickHouse, you must also edit the `/etc/nms/nms.conf` file after installing NGINX Management Suite and enter your ClickHouse password; otherwise, NGINX Management Suite won't start.
    >
    > For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< relref "/nms/admin-guides/configuration/configure-clickhouse.md" >}}) topic.

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

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> When installing ClickHouse, you have the option to specify a password or leave the password blank (the default is an empty string). If you choose to specify a password for ClickHouse, you must also edit the `/etc/nms/nms.conf` file after installing NGINX Management Suite and enter your ClickHouse password; otherwise, NGINX Management Suite won't start.
    >
    > For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< relref "/nms/admin-guides/configuration/configure-clickhouse.md" >}}) topic.

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

NGINX Management Suite uses the following default values for ClickHouse:

{{<important>}}You can customize these settings. However, if you use custom settings, make sure to follow the [Configure ClickHouse]({{< relref "/nms/admin-guides/configuration/configure-clickhouse.md" >}}) instructions to update the `nms.conf` file after you've installed NGINX Management Suite; otherwise NGINX Management Suite won't be able to connect to ClickHouse.{{</important>}}

{{< include "installation/clickhouse-defaults.md" >}}

---

## (Optional) Install and Configure Vault {#install-vault}

NGINX Management Suite can use [Vault](https://www.vaultproject.io/) as a datastore for secrets.

To install and enable Vault, take the following steps:

- Follow Vault's instructions to [install Vault 1.8.8 or later](https://www.vaultproject.io/docs/install) for your distribution.
- Ensure you are running Vault in a [Production Hardened Environment](https://learn.hashicorp.com/tutorials/vault/production-hardening).
- After [installing NGINX Management Suite]({{< relref "/nms/installation/vm-bare-metal/">}}), follow the steps to [Configure Vault for Storing Secrets]({{< relref "/nms/admin-guides/configuration/configure-vault.md" >}}).

---

## Add NGINX Management Suite Repository {#add-nms-repo}

To install NGINX Management Suite, you need to add the official repository to pull the pre-compiled `deb` and `rpm` packages from.

{{< include "installation/add-nms-repo.md" >}}

---

## What's Next

### Install NGINX Management Suite Modules

- [Install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/install-nim.md" >}})
- [Install Security Monitoring]({{< relref "/nms/installation/vm-bare-metal/install-security-monitoring.md" >}})
