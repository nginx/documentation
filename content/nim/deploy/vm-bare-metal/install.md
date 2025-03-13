---
description: null
docs: DOCS-1211
title: Install on a virtual machine or bare metal using a script
toc: true
weight: 10
type:
- tutorial
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide explains how to install F5 NGINX Instance Manager on a virtual machine or bare metal system using the `install-nim-bundle.sh` script.

The script simplifies the installation by automating tasks such as verifying system requirements, configuring services, and managing environment-specific options. For more control or an alternative approach, you can refer to the [manual installation guide]({{< relref "nim/deploy/vm-bare-metal/install-nim-deprecated.md" >}}), which provides detailed, step-by-step instructions.

---

## Before you begin

Follow these steps to prepare for installing NGINX Instance Manager:

- **Download the certificate and private key** (see the steps [below](#download-cert-key)):  
  Use the certificate and private key for NGINX Instance Manager (the same files used for NGINX Plus).  
  - Ensure the files have `.crt` and `.key` extensions.  
  - Save them to the target system. The default locations are:  
    - `/etc/ssl/nginx/nginx-repo.crt`  
    - `/etc/ssl/nginx/nginx-repo.key`  

- **Check for previous deployments**:  
  Ensure that NGINX Instance Manager and its components are not already installed.  
  - If NGINX Instance Manager or its components (such as ClickHouse or NGINX) are detected, either follow the [upgrade instructions](#upgrade-nim) to update them or [manually remove the components](#uninstall-nim) before proceeding with the installation.

- **Record the version details**:  
  Note the current version of NGINX Instance Manager and confirm the supported version of NGINX OSS or NGINX Plus you intend to use.  
  - By default, the script installs the latest version.

- **(Optional) Install and configure Vault**:  
  If you plan to use Vault, set it up before proceeding.

### Security considerations

To ensure that your NGINX Instance Manager deployment remains secure, follow these recommendations:

- Install NGINX Instance Manager on a dedicated machine (bare metal, container, cloud, or VM).
- Ensure that no other services are running on the same machine.

---

## Requirements

### Supported NGINX versions and Linux distributions

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

</details>

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "nim/tech-specs/supported-distros.md" >}}

</details>



---

## Download certificate and key {#download-cert-key}

Download the certificate and private key required for NGINX Instance Manager. These files are necessary for adding the official repository during installation and can also be used when installing NGINX Plus.

1. On the host where you're installing NGINX Instance Manager, create the **/etc/ssl/nginx/** directory:

    ```bash
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Download the **SSL Certificate**, **Private Key** and ***JSON Web Token*** files from [MyF5](https://account.f5.com/myf5) or use the download link provided in your trial activation email.

3. Move and rename the cert and key files to the correct directory:

    ```bash
    sudo mv nginx-<subscription id>.crt /etc/ssl/nginx/nginx-repo.crt
    sudo mv nginx-<subscription id>.key /etc/ssl/nginx/nginx-repo.key
    ```

---

## Download and run the installation script {#download-install}

Download the `install-nim-bundle.sh` script: 

{{<fa "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download install-nim-bundle.sh script">}}

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

#### Use the manual installation steps if needed

If the script fails or if you prefer more control over the process, consider using the [manual installation steps]({{< relref "nim/deploy/vm-bare-metal/install-nim-deprecated.md" >}}). These steps provide a reliable alternative for troubleshooting or handling complex setups.

### Run the installation script

The `install-nim-bundle.sh` script automates the installation of NGINX Instance Manager. By default, the script:

- Assumes no prior installation of NGINX Instance Manager or its dependencies and performs a fresh installation.
- Reads SSL files from the `/etc/ssl/nginx` directory.
- Installs the latest version of NGINX Open Source (OSS).
- Installs the ClickHouse database.
- Installs NGINX Instance Manager.
- Requires an active internet connection.

{{< warning >}}

As noted in [About subscription licenses]({{< relref "solutions/about-subscription-licenses.md#apply-the-jwt" >}}), **custom paths won't work until you upgrade to NGINX Plus R33**.

{{< /warning >}}

When you run the script, it downloads and installs NGINX Instance Manager.

If you want to use the script with non-default options, use these switches:

- To point to a repository key stored in a directory other than **/etc/ssl/nginx**: `-k /path/to/your/<nginx-repo.key>` file
- To point to a repository certificate stored in a directory other than **/etc/ssl/nginx**: `-c /path/to/your/<nginx-repo.crt>` file
- To install NGINX Plus (instead of NGINX OSS): `-p <nginx_plus_version>  -j /path/to/license.jwt`

{{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

You also need to specify the current operating system. To get the latest list supported by the script, run the following command:

```bash
grep '\-d distribution' install-nim-bundle.sh
```

For example, to use the script to install NGINX Instance Manager on Ubuntu 24.04, with repository keys in the default `/etc/ssl/nginx` directory, with the latest version of NGINX OSS, run the following command:

```bash
sudo bash install-nim-bundle.sh -n latest -d ubuntu24.04 -j /path/to/license.jwt
```

To install NGINX Instance Manager on Ubuntu 24.04 with the latest version of NGINX Plus by pointing to the location of your NGINX cert and key, run the following command:

```bash
sudo bash install-nim-bundle.sh -c /path/to/nginx-repo.crt -k /path/to/nginx-repo.key -p latest -d ubuntu24.04 -j /path/to/license.jwt
```

In most cases, the script completes the installation of NGINX Instance Manager and associated packages. After installation is complete, the script takes a few minutes to generate a password. At the end of the process, you'll see an autogenerated password:

```bash
Regenerated Admin password: <encrypted password>
```

Save that password. You'll need it when you sign in to NGINX Instance Manager.

### Problems and additional script parameters

There are multiple parameters to configure in the Installation script. If you see fatal errors when running the script, first run the following command, which includes command options that can help you bypass problems:

```bash
bash install-nim-bundle.sh -h
```

### Access the web interface {#access-web-interface}

After installation, you can access the NGINX Instance Manager web interface to begin managing your deployment.

1. Open a web browser.
2. Navigate to `https://<NIM_FQDN>`, replacing `<NIM_FQDN>` with the fully qualified domain name of your NGINX Instance Manager host.
3. Log in using the default administrator username (`admin`) and the autogenerated password displayed during installation.

Save the autogenerated password displayed at the end of the installation process. If you want to change the admin password, refer to the [Set user passwords]({{< relref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md#set-basic-passwords" >}}) section in the Basic Authentication topic.


### Using the script to uninstall NGINX Instance Manager and its dependencies

In some cases, the script may need to be re-run due to parameters not being set correctly, or wrong versions being specified. You can remove NGINX Instance Manager and all of its dependencies (including NGINX) so that the script can be re-run. 

{{<call-out "warning" "Potential for data loss" "">}}The `-r` option removes all NGINX configuration files, NGINX Instance Manager, and ClickHouse. Once you run this command, the data is gone and cannot be recovered unless you have backups. Use this option only if you need to remove NGINX Instance Manager to re-run the script in a fresh environment for a new installation. See "[Uninstall NGINX Instance Manager](#uninstall-nim)" below to perform these steps manually. If you do not want to lose your NGINX Configuration, you should take a backup of `/etc/nginx/`. {{</call-out>}}

```bash
bash install-nim-bundle.sh -r
```
---

## Post-installation steps

### Configure ClickHouse {#configure-clickhouse}

<!-- Updated per latest info in install-nim-bundle.sh  -->
{{<call-out "note" "ClickHouse version requirement" "" >}}NGINX Instance Manager relies on [ClickHouse](https://clickhouse.com) **24.9.2.42** or later to store essential data, including metrics, events, alerts, and configuration settings.{{</call-out>}}

<!-- Based on my understanding of the script, it is a blank password -->
{{<call-out "important" "Setting a custom ClickHouse password" "fas fa-exclamation-triangle" >}}The NGINX Instance Manager installation script also installs ClickHouse with a blank password. Update the **/etc/nms/nms.conf** file with it after installing NGINX Instance Manager. Otherwise, NGINX Instance Manager won't start. For more information on customizing ClickHouse settings, refer to the [Configure ClickHouse]({{< relref "/nim/system-configuration/configure-clickhouse.md" >}}) topic. {{</call-out>}}

#### ClickHouse default settings

NGINX Instance Manager uses the following default values for ClickHouse:

{{<call-out "note" "Customizing ClickHouse" >}}You can customize these settings. However, if you use custom settings, make sure to follow the [Configure ClickHouse]({{< relref "/nim/system-configuration/configure-clickhouse.md" >}}) instructions to update the **nms.conf** file after you've installed NGINX Instance Manager. Otherwise, NGINX Instance Manager won't be able to connect to ClickHouse.{{</call-out>}}

{{< include "installation/clickhouse-defaults.md" >}}

### (Optional) Install and configure Vault {#install-vault}

NGINX Instance Manager can use [Vault](https://www.vaultproject.io/) as a datastore for secrets.

To install and enable Vault, follow these steps:

- Follow Vault's instructions to [install Vault 1.8.8 or later](https://www.vaultproject.io/docs/install) for your distribution.
- Ensure you're running Vault in a [production-hardened environment](https://learn.hashicorp.com/tutorials/vault/production-hardening).
- After installing NGINX Instance Manager, follow the steps to [configure Vault for storing secrets]({{< relref "/nim/system-configuration/configure-vault.md" >}}).

### (Optional) Configure SELinux

SELinux helps secure your deployment by enforcing mandatory access control policies.

If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore SELinux contexts (`restorecon`) for the files and directories related to NGINX Instance Manager.

### License NGINX Instance Manager

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

1. To upgrade to the latest version of Clickhouse, run the following commands:

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

5. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "nim/system-configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Instance Manager.

---

## Uninstall NGINX Instance Manager {#uninstall-nim}

{{< include "nim/uninstall/uninstall-nim.md" >}}
