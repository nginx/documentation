---
description:
docs: DOCS-1211
doctypes:
- tutorial
tags:
- docs
title: Install on a virtual machine or bare metal
toc: true
weight: 10
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}


## Overview

This guide explains how to install NGINX Instance Manager on a virtual machine (VM) or bare metal. It includes key prerequisites like installing NGINX and setting up ClickHouse, as well as steps for adding a license, accessing the web interface, and optionally securing your deployment with Vault.

{{<call-out "note" "Access the deprecated manual steps" "">}}If you prefer to follow the original manual steps, you can access the [deprecated guide]({{< relref "nim/deploy/vm-bare-metal/install-nim-deprecated.md" >}}). Please note that this guide is no longer actively maintained and may not reflect the latest updates or best practices.{{</call-out>}}

## Supported versions

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

</details>

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "nim/tech-specs/supported-distros.md" >}}

</details>

---

## Security considerations

To ensure that your NGINX Instance Manager deployment remains secure, follow these recommendations:

- Install NGINX Instance Manager on a dedicated machine (bare metal, container, cloud, or VM).
- Ensure that no other services are running on the same machine.

---

## Prerequisites

Complete the following steps before installing NGINX Instance Manager:

- [ ] Download the certificate and private key for NGINX Instance Manager.
  - [ ] The downloaded files have .crt and .key extensions
  - [ ] Record the location of these files on the target system. The default filenames / locations are:
    - `/etc/ssl/nginx/nginx-repo.crt`
    - `/etc/ssl/nginx/nginx-repo.key`
- [ ] Record your current version of NGINX Instance Manager, along with the supported version of NGINX OSS or NGINX Plus that you want to use.
- [ ] (*Optional*) Install and configure Vault if you plan to use it.

### Download certificate and key {#download-cert-key}

Download the certificate and private key required for NGINX Instance Manager. These files are necessary for adding the official repository during installation and can also be used when installing NGINX Plus.

1. On the host where you're installing NGINX Instance Manager, create the **/etc/ssl/nginx/** directory:

    ```bash
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Download the **SSL Certificate** and **Private Key** files from [MyF5](https://account.f5.com/myf5) or use the download link provided in your trial activation email.

3. Move and rename the downloaded files to the correct directory:

    ```bash
    sudo mv nginx-<subscription id>.crt /etc/ssl/nginx/nginx-repo.crt
    sudo mv nginx-<subscription id>.key /etc/ssl/nginx/nginx-repo.key
    ```

### Download and run the installation script {#download-install}

{{< tip >}}

The installation script also works for upgrades of both NGINX Instance Manager and ClickHouse.

{{< /tip >}}

We created an installation script, `install-nim-bundle.sh` to automate the NGINX Instance Manager installation process. By default, it:

- Installs the latest version of NGINX OSS
- Assumes you're connected to the internet for installations and upgrades
- Reads SSL files from the /etc/ssl/nginx directory
- Reads your JWT token from the directory defined in your NGINX configuration

{{< warning >}}

As noted in [About subscription licenses]({{< relref "solutions/about-subscription-licenses.md#apply-the-jwt" >}}), **custom paths won't work until you upgrade to NGINX Plus R33**.

{{< /warning >}}

Download the `install-nim-bundle.sh` script: 

{{<fa "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download install-nim-bundle.sh script">}}

When you run the script, it downloads and installs NGINX Instance Manager.

If you want to use the script with non-default options, use these switches:

- To point to a repository key stored in a directory other than **/etc/ssl/nginx**: `-k /path/to/your/<nginx-repo.crt>` file
- To point to a repository certificate stored in a directory other than **/etc/ssl/nginx**: `-c /path/to/your/<nginx-repo.crt>` file
- To install NGINX Plus (instead of NGINX OSS): `-p <nginx_plus_version>`

You also need to specify the current operating system. To get the latest list supported by the script, run the following command:

```bash
grep '\-d distribution' install-nim-bundle.sh
```

For example, to use the script to install NGINX Instance Manager on Ubuntu 24.04, with repository keys in the default `/etc/ssl/nginx` directory, with the latest version of NGINX Plus, run the following command:

```bash
sudo bash install-nim-bundle.sh -p latest -d ubuntu24.04
```

In most cases, the script completes the installation of NGINX Interface Manager and associated packages. At the end of the process, you'll see an autogenerated password:

```bash
Regenerated Admin password: <encrypted password>
```

Save that password. You'll need it when you sign in to NGINX Instance Manager.

### Problems

If you see fatal errors when running the script, first run the following command, which includes command options that can help you bypass problems:

```bash
bash install-nim-bundle.sh -h
```

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

---

##### How to access the web interface

To access the NGINX Instance Manager web interface, open a web browser and go to `https://<NIM_FQDN>`, replacing `<NIM_FQDN>` with the Fully Qualified Domain Name of your NGINX Instance Manager host.

The default administrator username is `admin`, and the generated password is saved, in encrypted format, to the `/etc/nms/nginx/.htpasswd` file. The password was displayed in the terminal during installation. If you'd like to change this password, refer to the "[Set or Change User Passwords]({{< relref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md#set-basic-passwords-script" >}})" section in the Basic Authentication topic.

---

## Post-installation steps (optional)

- If you use Vault, follow the steps in the [Configure Vault]({{< relref "/nim/system-configuration/configure-vault.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Instance Manager won't be able to connect to Vault.

- If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore SELinux contexts (`restorecon`) for the files and directories related to NGINX Instance Manager.

---

## Upgrade NGINX Instance Manager {#upgrade-nim}

You can now use the [installation script](#download-install) to upgrade NGINX Instance Manager and ClickHouse.

If you use SELinux, after an upgrade, follow the steps in the [Configure SELinux]({{< relref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for files and directories related to NGINX Instance Manager.

---

## Uninstall NGINX Instance Manager

Follow the steps below to uninstall NGINX Instance Manager and ClickHouse.

- **For CentOS, RHEL, and RPM-based distributions:**

   ```bash
   sudo yum remove -y nms-*
   sudo systemctl stop clickhouse-server
   sudo yum remove -y clickhouse-server
   ```

- **For Debian, Ubuntu, and Deb-based distributions:**

   ``` bash
   sudo apt-get remove -y nms-*
   sudo systemctl stop clickhouse-server
   sudo apt-get remove -y clickhouse-server
   ```

	If you want to remove the package and its configuration files, use `apt-get purge -y <package>` instead of `apt-get remove -y`.
