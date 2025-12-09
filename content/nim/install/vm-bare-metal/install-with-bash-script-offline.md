---
title: Install NGINX Instance Manager using a script (offline deployment)
linkTitle: Install with script (offline)
toc: true
weight: 20
type: how-to
product: NIM
nd-docs: DOCS-803
---

This guide shows you how to install or upgrade NGINX Instance Manager on a virtual machine or bare metal system using the installation script in **offline mode**.

The script installs the **latest** versions of:

- NGINX Open Source
- NGINX Instance Manager
- ClickHouse (by default, unless you choose to skip it)

The script also installs all required system packages.

If you need an **earlier version** of NGINX or NGINX Instance Manager, use the [manual installation process]({{< ref "nim/install/vm-bare-metal/install-manually-online.md" >}}) for online setups or the [offline manual process]({{< ref "nim/install/vm-bare-metal/install-manually-offline.md" >}}) for disconnected environments.

{{< call-out "important" "NGINX Plus not supported in offline mode" >}}
The script does not support installing NGINX Plus in offline mode. To install NGINX Plus, run the script in [online mode]({{< ref "nim/install/vm-bare-metal/install-with-bash-script-online.md" >}}) or follow the [manual offline instructions]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md#offline_install" >}}).
{{< /call-out >}}

{{< include "/nim/install/check-existing-installation.md" >}}

{{< call-out "note" "Using Vault?" >}}
If you plan to use Vault for secrets management, set it up before you continue with the installation. After the installation, follow the steps in the [Vault configuration guide]({{< ref "nim/system-configuration/configure-vault.md" >}}) to complete the setup.
{{< /call-out >}}

## Download the installation script

{{< include "/nim/install/temporary-internet-required-note.md" >}}

{{< include "/nim/install/script-download.md" >}}

## Download the SSL certificate, private key, and JWT {#download-crt-key-jwt}

{{< include "/nim/install/temporary-internet-required-note.md" >}}

{{< include "/nim/install/nim-download-crt-key-jwt.md" >}}

## Prepare offline install package

{{< include "/nim/install/temporary-internet-required-note.md" >}}

Run the installation script in `offline` mode to download NGINX Instance Manager, NGINX Open Source, ClickHouse (unless skipped), and all required dependencies into a tarball for use in offline environments.

### Script options

{{< include "/nim/install/install-script-options.md" >}}

### Example: Package with NGINX Open Source using default certificate paths

To package NGINX Instance Manager with NGINX Open Source for Ubuntu 24.04 using the default certificate and key locations:

```bash
sudo bash install-nim-bundle.sh \
  -m offline \
  -d ubuntu24.04
```

This command uses the default certificate and key paths in `/etc/ssl/nginx`, and the default version of ClickHouse.

### Example: Package with NGINX Open Source without ClickHouse (lightweight mode)

To skip ClickHouse if you don't need monitoring metrics:

```bash
sudo bash install-nim-bundle.sh \
  -m offline \
  -s \
  -d ubuntu24.04
```

### Example: Package with NGINX Open Source using custom certificate paths

If your certificate and key files are stored in non-default locations, specify them with the `-c` and `-k` options:

```bash
sudo bash install-nim-bundle.sh \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -m offline \
  -d ubuntu24.04
```

Replace the placeholder paths with the actual locations of your files.

---

## Install required OS packages {#install-os-packages}

{{< include "/nim/install/temporary-internet-required-note.md" >}}

Before installing NGINX Instance Manager, you must install the required operating system (OS) packages on the **offline target system** where you plan to run the installer.

In online mode, these packages are resolved automatically. In offline mode, you must install them manually.

### Required OS packages

{{< table >}}
| Component                   | Debian/Ubuntu packages                                                     | Red Hat-based packages                                                   |
|----------------------------|-----------------------------------------------------------------------------|----------------------------------------------------------------------------|
| **NGINX**                  | `libc6`, `libcrypt1`, `libpcre2-8-0`, `libssl3`, `lsb-base`, `zlib1g`       | `bash`, `glibc`, `libxcrypt`, `openssl-libs`, `pcre2`, `procps-ng`, `shadow-utils`, `systemd`, `zlib` |
| **NGINX&nbsp;Instance&nbsp;Manager** | `gawk`, `lsb-release`, `openssl`, `rsyslog`, `systemd`, `tar`               | `glibc`, `openssl`, `rsyslog`, `systemd`, `tar`, `which`, `yum-utils`, `zlib` |
| **ClickHouse**             | `libcap2-bin`                                                              | *(None)*                                                                  |
{{< /table >}}

You can find the latest dependencies on a system with internet access using the following commands:

- **Debian/Ubuntu**:

  ```bash
  apt-cache depends <package_name>=<version>
  ```

- **Red Hat**:

  ```bash
  yum deplist <package_name>-<version>
  ```

---

## Install NGINX Instance Manager {#install-nim}

After you’ve packaged the installation files on a connected system, copy the following files to your **offline target system**:

- `install-nim-bundle.sh` script
- SSL certificate file (default: `/etc/ssl/nginx/nginx-repo.crt`)
- Private key file (default: `/etc/ssl/nginx/nginx-repo.key`)
- Tarball file with the required packages

### Required flags for offline installation

- `-m offline`: Required to run the script in offline mode.
- `-i <path/to/tarball.tar.gz>`: Path to the tarball created during the packaging step.
- `-c <path/to/nginx-repo.crt>`: Path to your SSL certificate file.
- `-k <path/to/nginx-repo.key>`: Path to your private key file.
- `-d <distribution>`: Target Linux distribution (must match what was used during packaging).

### Installation command

```bash
sudo bash install-nim-bundle.sh \
  -m offline \
  -i <path/to/tarball.tar.gz> \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -d <distribution>
```

{{< include "/nim/install/save-admin-password-callout.md" >}}

---

## Set the operation mode to disconnected {#set-mode-disconnected}

To configure NGINX Instance Manager for use in an offline (disconnected) environment:

{{< include "nim/disconnected/set-mode-of-operation-disconnected.md" >}}

---

## Access the web interface {#access-web-interface}

{{< include "nim/install/access-web-ui.md" >}}

---

## Upgrade {#upgrade-nim}

{{< include "/nim/install/temporary-internet-required-note.md" >}}

To upgrade NGINX Instance Manager to the latest version:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the latest package files for your operating system.

2. Upgrade the package on your target system:

   - **For RHEL and RPM-based systems**:

     ```bash
     sudo rpm -Uvh --nosignature /home/user/nms-instance-manager_<version>.x86_64.rpm
     sudo systemctl restart nms
     sudo systemctl restart nginx
     ```

   - **For Debian, Ubuntu, and other DEB-based systems**:

     ```bash
     sudo apt-get -y install -f /home/user/nms-instance-manager_<version>_amd64.deb
     sudo systemctl restart nms
     sudo systemctl restart nginx
     ```

3. (Optional) If you use SELinux, restore the default security contexts after the upgrade. For instructions, see [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md" >}}).

---

## Uninstall NGINX Instance Manager {#uninstall-nim}

{{< include "nim/install/uninstall-nim.md" >}}

---

## Next steps

- [Explore post-installation options]({{< ref "/nim/install/vm-bare-metal/post-install-options.md" >}}) — Learn how to configure optional components such as ClickHouse, SELinux, Vault, and metrics collection. You can also download and apply the latest CVE file to keep your offline system up to date.