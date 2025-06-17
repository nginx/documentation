---
description: ''
docs: DOCS-1211
title: Manually install any version of NGINX Instance Manager
toc: true
weight: 10
noindex: true
type:
- tutorial
---

## Overview

Follow the steps in this guide to install or upgrade a specific version of NGINX Instance Manager.

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

   The downloaded filenames may vary depending on your subscription type. Modify the commands above accordingly to match the actual filenames.

---

## Install NGINX {#install-nginx}

Install NGINX Open Source or NGINX Plus on the host where you'll install NGINX Instance Manager. NGINX Instance Manager uses NGINX as a front-end proxy and for managing user access.

- [Installing NGINX and NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}})

   <br>

   If you're installing NGINX Plus, you can use the `nginx-repo.key` and `nginx-repo.crt` that you added in the [previous section](#download-cert-key).

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

</details>

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "nim/tech-specs/supported-distros.md" >}}

</details>

Make sure to review the [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs" >}}) guide for sizing requirements and other recommended specs.

---

## Configure metrics collection

### Disable metrics collection

NGINX Instance Manager uses ClickHouse to store metrics, events, alerts, and configuration data.

Starting in version 2.20.0, you can run NGINX Instance Manager in Lightweight mode, which skips the ClickHouse installation entirely. This setup works well if you don’t need monitoring data or want to reduce system requirements. It also avoids the effort of managing a metrics database. You can add ClickHouse later if your needs change.

If you don’t need to store metrics, you can skip installing ClickHouse. But you must use NGINX Agent version {{< lightweight-nim-nginx-agent-version >}}, and you must disable metrics collection in the `/etc/nms/nms.conf` and `/etc/nms-sm.conf.yaml` files.

For instructions, see [Disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}).

### Install ClickHouse to enable metrics

{{< include "nim/clickhouse/clickhouse-install.md" >}}

#### ClickHouse Default Settings

NGINX Instance Manager uses the following default values for ClickHouse. To change these values, see the [Configure ClickHouse](nim/system-configuration/configure-clickhouse.md) guide.

{{< include "nim/clickhouse/clickhouse-defaults.md" >}}

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

## Optional post-installation steps

### Configure ClickHouse

{{< include "nim/installation/optional-steps/configure-clickhouse.md" >}}

### Install and configure Vault {#install-vault}

{{< include "nim/installation/optional-steps/install-configure-vault.md" >}}


### Configure SELinux

{{< include "nim/installation/optional-steps/configure-selinux.md" >}}

## Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}


## Add License

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
   sudo apt-get update && \
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

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
