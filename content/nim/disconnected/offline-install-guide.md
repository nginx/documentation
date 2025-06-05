---
title: Install in a disconnected environment using a script
toc: true
weight: 100
type: how-to
product: NIM
docs: DOCS-803
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide shows you how to install and upgrade NGINX Instance Manager in environments without internet access. It covers key steps, including downloading packages, managing dependencies, and configuring the system for offline use. You’ll also learn how to set up NGINX Instance Manager in disconnected mode and update the CVE list manually to keep your system secure.

{{<call-out "note" "Access the deprecated manual steps" "">}}If you prefer to follow the original manual steps, you can access the [deprecated guide]({{< ref "nim/disconnected/offline-install-guide-deprecated.md" >}}). Please note that this guide is no longer actively maintained and may not reflect the latest updates or best practices.{{</call-out>}}

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

If the script fails or if you prefer more control over the process, consider using the [manual installation steps]({{< ref "nim/disconnected/offline-install-guide-deprecated.md" >}}). These steps provide a reliable alternative for troubleshooting or handling complex setups.

### Download the SSL Certificate and Private Key from MyF5

Download the SSL certificate and private key required for NGINX Instance Manager:

1. Log in to [MyF5](https://my.f5.com/manage/s/).
1. Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
1. Find your NGINX products or services subscription, and select the **Subscription ID** for details.
1. Download the **SSL Certificate** and **Private Key** files.

### Download the installation script

{{<fa "download">}} {{<link "/scripts/install-nim-bundle.sh" "Download the install-nim-bundle.sh script.">}}

### Use the script to Download the necessary packages to Install NGINX Instance Manager in a Disconnected environment

To run the script, enter the following command, replacing `<path/to/certificate.crt>` and `<path/to/private.key>` with the full paths and filenames of your SSL certificate and private key files:

```shell
sudo bash install-nim-bundle.sh \
  -c <path/to/certificate.crt> \
  -k <path/to/private.key> \
  -m offline \
  -d <distribution> \
  -v <version>
```

<br>

By default, this command installs the latest version of NGINX Open Source to run NGINX Instance Manager. NGINX Plus is currently not supported when using the script in Disconnected mode. Please see this guide to install NGINX Plus offline if you would like to use this in front of NGINX Instance Manager

<br>

**Explanation of options:**

- **`-c`**: Uses the specified SSL certificate file. Copies the file to the /etc/ssl/nginx directory.
- **`-k`**: Uses the specified private key file. Copies the file to the /etc/ssl/nginx directory.
- **`-m`**: Sets the installation mode (use `offline` for disconnected environments).
- **`-d`**: Defines the target distribution (replace `<distribution>` with one of the supported options below).
- **`-n`**: Installs a specific version of NGINX Open Source. Use `latest` to install the most recent version or specify a version like `1.27.1`. The script defaults to installing the latest version of NGINX Open Source.
- **`-v`**: Installs the specified version of NGINX Instance Manager. Use `latest` for the newest version or a specific release like `2.18.0`. If you skip this option, the script assumes you want to install `latest`.

**Supported distributions:**

To get the latest list supported by the script, run the following command:

```bash
grep '\-d distribution' install-nim-bundle.sh
```

The script downloads the required packages and adds them to a tarball file. You’ll need to copy this tarball to the target machine in the disconnected environment.

---

## Install NGINX Instance Manager

1. Copy the following files to the target system:
   - `install-nim-bundle.sh` script
   - SSL certificate file
   - Private key file
   - Tarball file with the required packages

2. Run the installation script:

    ```shell
    sudo bash install-nim-bundle.sh \
    -c <path/to/certificate.crt>
    -k <path/to/private.key> \
    -m offline \
    -d <distribution> \
    -i <path/to/tarball.tar.gz>
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

## Post-installation steps (optional)

{{< include "installation/optional-installation-steps.md"  >}}

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

