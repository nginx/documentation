---
description: ''
title: Install the latest NGINX Instance Manager with a script
toc: true
weight: 10
type:
- tutorial
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide shows you how to install and upgrade F5 NGINX Instance Manager on a virtual machine or bare metal system using the installation script in online mode.

The script installs:

- The latest version of NGINX Open Source
- The latest version of NGINX Instance Manager
- ClickHouse by default, unless you choose to skip it
- Optionally, NGINX Plus (requires a license and additional flags)

The script also installs all required operating system packages automatically. If you need to install earlier versions of NGINX or NGINX Instance Manager, follow the [manual installation process]({{< ref "nim/deploy/vm-bare-metal/install-nim-manual.md" >}}) instead.

---

## Before you begin

Follow these steps to prepare for installing NGINX Instance Manager:

- **Download the installation script**:

  {{< icon "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download install-nim-bundle.sh script">}}

- **Download the certificate and private key** (see the steps [below](#download-cert-key)):
  Use the certificate and private key for NGINX Instance Manager (the same files used for NGINX Plus).
  - Ensure the files have `.crt` and `.key` extensions.
  - Save them to the target system. The default locations are:
    - `/etc/ssl/nginx/nginx-repo.crt`
    - `/etc/ssl/nginx/nginx-repo.key`

- **Check for previous deployments**:
  Ensure that NGINX Instance Manager and its components are not already installed.

  If NGINX Instance Manager or its components (such as ClickHouse or NGINX) are detected, either follow the [upgrade instructions](#upgrade-nim) to update them or [manually remove the components](#uninstall-nim) before proceeding with the installation.

- **(Optional) Install and configure Vault**:
  If you plan to use Vault, set it up before proceeding.

### Supported NGINX versions and Linux distributions

The installation script installs the latest version of [NGINX Open Source](https://nginx.org/news.html) or [NGINX Plus](https://docs.nginx.com/nginx/releases/).

To see the list of supported distributions, run:

```shell
install-nim-bundle.sh -l
```

### Security considerations

To ensure that your NGINX Instance Manager deployment remains secure, follow these recommendations:

- Install NGINX Instance Manager on a dedicated machine (bare metal, container, cloud, or VM).
- Ensure that no other services are running on the same machine.

---

## Download certificate and key {#download-cert-key}

Download the certificate and private key required for NGINX Instance Manager. These files are necessary for adding the official repository during installation and can also be used when installing NGINX Plus.

1. On the host where you're installing NGINX Instance Manager, create the **/etc/ssl/nginx/** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Download the **SSL Certificate**, **Private Key** and ***JSON Web Token*** files from [MyF5](https://account.f5.com/myf5) or use the download link provided in your trial activation email.

3. Move and rename the cert and key files to the correct directory:

    ```shell
    sudo mv nginx-<subscription id>.crt /etc/ssl/nginx/nginx-repo.crt
    sudo mv nginx-<subscription id>.key /etc/ssl/nginx/nginx-repo.key
    ```

---

## Prepare the system and run the installation script {#download-install}

If you haven’t already downloaded the script, you can download it here:

{{< icon "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download install-nim-bundle.sh script">}}

### Prepare your system for installation

Follow these steps to get your system ready for a successful installation with the `install-nim-bundle.sh` script:

#### Resolve existing installations of NGINX Instance Manager

The script supports only new installations. If NGINX Instance Manager is already installed, take one of the following actions:

- **Upgrade manually**
  The script cannot perform upgrades. To update an existing installation, follow the [upgrade steps](#upgrade-nim) in this document.

- **Uninstall first**
  Remove the current installation and its dependencies for a fresh start. Use the [uninstall steps](#uninstall-nim) to delete the primary components. Afterward, manually check for and remove leftover files such as repository configurations or custom settings to ensure a clean system.

#### Verify SSL certificates and private keys

Ensure that the required `.crt` and `.key` files are available, preferably in the default **/etc/ssl/nginx** directory. Missing certificates or keys will prevent the script from completing the installation.

#### Verify If Metrics Are Required (Exclude ClickHouse)

In 2.20.0, we introduced Lightweight mode, which means you can skip the ClickHouse installation entirely. It’s ideal if you don’t need monitoring data or want a simpler setup. This reduces system requirements and avoids the work of managing a metrics database. You can add ClickHouse later if your needs change.

#### Use the manual installation steps if needed

If the script fails or if you prefer more control over the process, consider using the [manual installation steps]({{< ref "nim/deploy/vm-bare-metal/install-nim-manual.md" >}}). These steps provide a reliable alternative for troubleshooting or handling complex setups.

### Run the installation script

The `install-nim-bundle.sh` script automates installing NGINX Instance Manager.

By default, the script:

- Assumes no prior installation of NGINX Instance Manager or its dependencies
- Reads SSL files from the `/etc/ssl/nginx` directory
- Installs the latest version of NGINX Open Source (OSS)
- Installs the ClickHouse database
- Installs the latest version of NGINX Instance Manager
- Requires an active internet connection

#### Installation script options

You can customize the installation using the following options:


| Category | Option or Flag |
|----------|----------------|
| **Installation platform** | {{< include "nim/installation/install-script-flags/distribution.md" >}} |
| **SSL certificate and key** | {{< include "nim/installation/install-script-flags/cert.md" >}}<br>{{< include "nim/installation/install-script-flags/key.md" >}} |
| **NGINX installation** | `-n` Install the latest version of NGINX Open Source. *(Default if `-n` or `-p` not specified)*<br><br>`-p` Install NGINX Plus as the API gateway. Must be used with `-j` to provide a JWT license.<br><br>`-j <path>` Path to the `license.jwt` file. Required when using `-p`. |
| **ClickHouse installation** | {{< include "nim/installation/install-script-flags/skip-clickhouse.md" >}}<br>{{< include "nim/installation/install-script-flags/clickhouse-version.md" >}} |

**Example: install with default key and certificate paths**

To use the script to install NGINX Instance Manager on Ubuntu 24.04, with repository keys in the default `/etc/ssl/nginx` directory, with the latest version of NGINX Open Source, run the following command:

```bash
sudo bash install-nim-bundle.sh -d ubuntu24.04
```

<br>

**Example: install with custom repo key and certificate**

To install NGINX Instance Manager on Ubuntu 24.04 with the latest version of NGINX Plus by pointing to the location of your NGINX cert and key, run the following command:

```bash
sudo bash install-nim-bundle.sh \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -p \
  -d ubuntu24.04 \
  -j <path/to/license.jwt>
```

<br>

After installing NGINX Instance Manager and related packages, the script generates an admin password. This may take a few minutes to appear:

```bash
Regenerated Admin password: <encrypted password>
```

Save this password. You'll need it to log in to NGINX Instance Manager.

### Problems and additional script parameters

There are multiple parameters to configure in the installation script. If you see fatal errors when running the script, first run the following command, which includes command options that can help you bypass problems:

```bash
bash install-nim-bundle.sh -h
```

### Access the web interface {#access-web-interface}

After installation, you can access the NGINX Instance Manager web interface to begin managing your deployment.

1. Open a web browser.
2. Navigate to `https://<NIM_FQDN>`, replacing `<NIM_FQDN>` with the fully qualified domain name of your NGINX Instance Manager host.
3. Log in using the default administrator username (`admin`) and the autogenerated password displayed during installation.

Save the autogenerated password displayed at the end of the installation process. If you want to change the admin password, refer to the [Set user passwords]({{< ref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md#set-basic-passwords" >}}) section in the Basic Authentication topic.


### Using the script to uninstall NGINX Instance Manager and its dependencies

In some cases, the script may need to be re-run due to parameters not being set correctly, or wrong versions being specified. You can remove NGINX Instance Manager and all of its dependencies (including NGINX) so that the script can be re-run.

{{<call-out "warning" "Potential for data loss" "">}}The `-r` option removes all NGINX configuration files, NGINX Instance Manager, and ClickHouse. Once you run this command, the data is gone and cannot be recovered unless you have backups. Use this option only if you need to remove NGINX Instance Manager to re-run the script in a fresh environment for a new installation. See "[Uninstall NGINX Instance Manager](#uninstall-nim)" below to perform these steps manually. If you do not want to lose your NGINX Configuration, you should take a backup of `/etc/nginx/`. {{</call-out>}}

```bash
bash install-nim-bundle.sh -r
```

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

## License NGINX Instance Manager

{{< include "nim/admin-guide/license/connected-install-license-note.md" >}}

---

## Upgrade NGINX Instance Manager {#upgrade-nim}

{{<tabs name="upgrade_nim">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of the NGINX Instance Manager, run the following command:

   ```bash
   sudo yum update -y nms-instance-manager --allowerasing
   ```

1. To upgrade to the latest version of Clickhouse, run the following command:

   ```bash
   sudo yum update -y clickhouse-server clickhouse-client
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of the NGINX Instance Manager, run the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get install -y --only-upgrade nms-instance-manager
   ```

1. To upgrade to the latest version of ClickHouse, run the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get install -y --only-upgrade clickhouse-server clickhouse-client
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

4. Restart the Clickhouse server:

   ```bash
   sudo systemctl restart clickhouse-server
   ```

5. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "nim/system-configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Instance Manager.

---

## Uninstall NGINX Instance Manager {#uninstall-nim}

{{< include "nim/uninstall/uninstall-nim.md" >}}

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
