---
title: Install NGINX Instance Manager using a script (disconnected)
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: DOCS-803
description: "Use the install-nim-bundle.sh script to install or upgrade F5 NGINX Instance Manager in a disconnected (offline) environment."
nd-summary: >
  Install or upgrade F5 NGINX Instance Manager in a disconnected environment using the install-nim-bundle.sh script.
  The script automates package transfer and installation for systems without internet access after you download the bundle on a connected host.
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

Use the `install-nim-bundle.sh` script to install and upgrade F5 NGINX Instance Manager in disconnected environments.

The script installs:

- The latest version of NGINX Open Source
- The latest version of NGINX Instance Manager
- ClickHouse, unless you choose to skip it

NGINX Plus is not supported in disconnected mode. To install earlier versions of NGINX or NGINX Instance Manager, use the [manual installation process]({{< ref "nim/disconnected/offline-install-guide-manual.md" >}}) instead.

---

## Before you begin

You’ll need internet access for the steps in this section.

### Prepare for installation

Before running `install-nim-bundle.sh`, address the following:

#### Handle an existing NGINX Instance Manager installation

The script supports only new installations. If NGINX Instance Manager is already installed, take one of the following actions:

- **Upgrade manually**
  The script can't perform upgrades. To update an existing installation, follow the [upgrade steps](#upgrade-nim) in this guide.

- **Uninstall first**
  To start fresh, use the [uninstall steps](#uninstall-nim) to remove the primary components, then manually check for and remove leftover files such as repository configurations or custom settings.

#### Verify SSL certificates and private keys

Make sure the required `.crt` and `.key` files are available, preferably in the default **/etc/ssl/nginx** directory. Missing certificates or keys will prevent the script from completing the installation.

#### Use manual installation if the script fails

If the script fails or you need more control, use the [manual installation steps]({{< ref "nim/disconnected/offline-install-guide-manual.md" >}}) instead.

### Download the SSL certificate and private key from MyF5

Download the SSL certificate and private key required for NGINX Instance Manager:

1. Log in to [MyF5](https://my.f5.com/manage/s/).
1. Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
1. Find your NGINX products or services subscription, and select the **Subscription ID** for details.
1. Download the **SSL Certificate** and **Private Key** files.

### Download the installation script

{{<icon "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download the install-nim-bundle.sh script.">}}

## Package NGINX Instance Manager for offline installation

Run the script in `offline` mode to download NGINX Instance Manager, NGINX Open Source, ClickHouse (unless skipped), and all required dependencies into a tarball.

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
  -c <PATH/TO/NGINX_REPO.CRT> \
  -k <PATH/TO/NGINX_REPO.KEY> \
  -m offline \
  -d <DISTRIBUTION> \
  -v <CLICKHOUSE_VERSION>
  ```

---

## Install NGINX Instance Manager

After you’ve packaged the installation files on a connected system, copy the tarball, script, and SSL files to your disconnected system. Then, run the script again to install NGINX Instance Manager using the tarball.

## OS dependencies for offline installation

The installation script packages NGINX Open Source, NGINX Instance Manager, and ClickHouse. In offline mode, these packages are bundled but their OS-level dependencies are not. Make sure those dependencies are installed before running the script. The following packages are required for each supported distribution type:

### Debian/Ubuntu

- NGINX: libc6, libcrypt1, libpcre2-8-0, libssl3, zlib1g, lsb-base
- NGINX Instance Manager: openssl, rsyslog, systemd, tar, lsb-release, gawk
- ClickHouse: libcap2-bin

### Red Hat-based operating systems

- NGINX: bash, glibc, libxcrypt, openssl-libs, pcre2, zlib, procps-ng, shadow-utils, systemd
- NGINX Instance Manager: glibc, openssl, rsyslog, systemd, tar, which, zlib, yum-utils
- ClickHouse: none

To find the latest dependencies for a specific package version:

- Ubuntu/Debian: `apt-cache depends <PACKAGE_NAME>=<VERSION>`
- Red Hat: `yum deplist <PACKAGE_NAME_VERSION>`


### Required flags for installing in offline mode

- `-m offline`: Required to run the script in offline mode. When used with `-i`, the script installs NGINX Instance Manager and its dependencies from the specified tarball.
- `-i <path/to/tarball.tar.gz>`: Path to the tarball created during the packaging step.
- {{< include "nim/installation/install-script-flags/cert.md" >}}
- {{< include "nim/installation/install-script-flags/key.md" >}}
- `-d <DISTRIBUTION>`: Target Linux distribution (must match what was used during packaging).

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
    -i <PATH/TO/TARBALL.TAR.GZ>
    -c <PATH/TO/NGINX_REPO.CRT>
    -k <PATH/TO/NGINX_REPO.KEY> \
    -d <DISTRIBUTION>
    ```

3. **Save the admin password**. After installation completes, the script takes a few minutes to generate a password. At the end of the process, you'll see:

    ```shell
    Regenerated Admin password: <encrypted password>
    ```

    Save that password. You'll need it when you sign in to NGINX Instance Manager.

4. After installation, open a browser, go to `https://<NIM_FQDN>`, and log in.

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
        sudo rpm -Uvh --nosignature /home/user/nms-instance-manager_<VERSION>.x86_64.rpm
        sudo systemctl restart nms
        sudo systemctl restart nginx
        ```

   - **For Debian, Ubuntu, Deb-based systems**:

        ```shell
        sudo apt-get -y install -f /home/user/nms-instance-manager_<VERSION>_amd64.deb
        sudo systemctl restart nms
        sudo systemctl restart nginx
        ```

    {{< include "installation/nms-user.md"  >}}

3.	(Optional) If you use SELinux, follow the [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md"  >}}) guide to restore SELinux contexts using restorecon for files and directories related to NGINX Instance Manager.

---

## Uninstall NGINX Instance Manager {#uninstall-nim}

{{< include "nim/uninstall/uninstall-nim.md" >}}

---

## Update the CVE list {#cve-check}

To manually update the CVE list in an air-gapped environment, run the following command to overwrite `cve.xml` and restart the Data Plane Manager service:

```shell
sudo chmod 777 /usr/share/nms/cve.xml && \
sudo curl -s http://hg.nginx.org/nginx.org/raw-file/tip/xml/en/security_advisories.xml > /usr/share/nms/cve.xml && \
sudo chmod 644 /usr/share/nms/cve.xml && \
sudo systemctl restart nms-dpm
```

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
