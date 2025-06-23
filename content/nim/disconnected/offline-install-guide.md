---
title: Install the latest NGINX Instance Manager with a script (disconnected)
toc: true
weight: 100
type: how-to
product: NIM
nd-docs: DOCS-803
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide shows you how to install and upgrade F5 NGINX Instance Manager in disconnected environments.

The script installs:

- The latest version of NGINX Open Source
- The latest version of NGINX Instance Manager
- ClickHouse by default, unless you choose to skip it

NGINX Plus is not supported in disconnected mode.

If you need to install earlier versions of NGINX or NGINX Instance Manager, follow the [manual installation process]({{< ref "nim/disconnected/offline-install-guide-manual.md" >}}) instead.

---

## Before you begin

You’ll need internet access for the steps in this section.

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

If the script fails or if you prefer more control over the process, consider using the [manual installation steps]({{< ref "nim/disconnected/offline-install-guide-manual.md" >}}). These steps provide a reliable alternative for troubleshooting or handling complex setups.

### Download the SSL Certificate and Private Key from MyF5

Download the SSL certificate and private key required for NGINX Instance Manager:

1. Log in to [MyF5](https://my.f5.com/manage/s/).
1. Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
1. Find your NGINX products or services subscription, and select the **Subscription ID** for details.
1. Download the **SSL Certificate** and **Private Key** files.

### Download the installation script

{{< icon "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download the install-nim-bundle.sh script.">}}

## Package NGINX Instance Manager and dependencies for offline installation

Run the installation script in `offline` mode to download NGINX Instance Manager, NGINX Open Source, ClickHouse (unless skipped), and all required dependencies into a tarball for use in disconnected environments.

### Installation script options

| Category | Option or Flag |
|----------|----------------|
| **Installation mode and platform** | `-m offline`: Required to package the installation files into a tarball for disconnected environments.<br>{{< include "nim/installation/install-script-flags/distribution.md" >}} |
| **SSL certificate and key** | {{< include "nim/installation/install-script-flags/cert.md" >}}<br>{{< include "nim/installation/install-script-flags/key.md" >}} |
| **NGINX installation** | `-n`: Include the latest version of NGINX Open Source in the tarball.<br><br>This option is optional in `offline` mode—if not specified, the script installs the latest version of NGINX Open Source by default.<br><br>NGINX Plus is **not supported** when using the script in offline mode.<br><br>To install NGINX Plus offline, see the [manual installation guide]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md#offline_install" >}}). |
| **ClickHouse installation** | {{< include "nim/installation/install-script-flags/skip-clickhouse.md" >}}<br>{{< include "nim/installation/install-script-flags/clickhouse-version.md" >}} |

### Example: packaging command

  ```shell
  sudo bash install-nim-bundle.sh \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -m offline \
  -d <distribution> \
  -v <clickhouse-version>
  ```

---

## Install NGINX Instance Manager

After you’ve packaged the installation files on a connected system, copy the tarball, script, and SSL files to your disconnected system. Then, run the script again to install NGINX Instance Manager using the tarball.

### Required flags for installing in offline mode

- `-m offline`: Required to run the script in offline mode. When used with `-i`, the script installs NGINX Instance Manager and its dependencies from the specified tarball.
- `-i <path/to/tarball.tar.gz>`: Path to the tarball created during the packaging step.
- {{< include "nim/installation/install-script-flags/cert.md" >}}
- {{< include "nim/installation/install-script-flags/key.md" >}}
- `-d <distribution>`: Target Linux distribution (must match what was used during packaging).

### Install from the tarball

1. Copy the following files to the target system:
   - `install-nim-bundle.sh` script
   - SSL certificate file
   - Private key file
   - Tarball file with the required packages

2. Run the installation script:

    ```shell
    sudo bash install-nim-bundle.sh \
    -m offline
    -i <path/to/tarball.tar.gz>
    -c <path/to/nginx-repo.crt>
    -k <path/to/nginx-repo.key> \
    -d <distribution> \
    ```

3. **Save the admin password**. In most cases, the script completes the installation of NGINX Instance Manager and associated packages. After installation is complete, the script takes a few minutes to generate a password. At the end of the process, you'll see an autogenerated password:

    ```shell
    Regenerated Admin password: <encrypted password>
    ```

    Save that password. You'll need it when you sign in to NGINX Instance Manager.

3. After installation, open a web browser, go to `https://<NIM-FQDN>` (the fully qualified domain name of the NGINX Instance Manager host), and log in.

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

---

## Upgrade NGINX Instance Manager {#upgrade-nim}

To upgrade NGINX Instance Manager to a newer version:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the latest package files.
2. Upgrade the package:
   - **For RHEL and RPM-based systems**:

        ```shell
        sudo rpm -Uvh --nosignature /home/user/nms-instance-manager_<version>.x86_64.rpm
        sudo systemctl restart nms
        sudo systemctl restart nginx
        ```

   - **For Debian, Ubuntu, Deb-based systems**:

        ```shell
        sudo apt-get -y install -f /home/user/nms-instance-manager_<version>_amd64.deb
        sudo systemctl restart nms
        sudo systemctl restart nginx
        ```

    {{< include "installation/nms-user.md"  >}}

3.	(Optional) If you use SELinux, follow the [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md"  >}}) guide to restore SELinux contexts using restorecon for files and directories related to NGINX Instance Manager.

---

## Uninstall NGINX Instance Manager {#uninstall-nim}

{{< include "nim/uninstall/uninstall-nim.md" >}}

---

## CVE checking {#cve-check}

To manually update the CVE list in an air-gapped environment, follow these steps to download and overwrite the `cve.xml` file in the `/usr/share/nms` directory and restart the Data Plane Manager service:

```shell
sudo chmod 777 /usr/share/nms/cve.xml && \
sudo curl -s http://hg.nginx.org/nginx.org/raw-file/tip/xml/en/security_advisories.xml > /usr/share/nms/cve.xml && \
sudo chmod 644 /usr/share/nms/cve.xml && \
sudo systemctl restart nms-dpm
```

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
