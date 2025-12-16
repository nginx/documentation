---
description: ''
title: Install NGINX Instance Manager using a script (online deployment)
linkTitle: Install with script (online)
toc: true
weight: 10
type:
- tutorial
---

This guide shows you how to install or upgrade NGINX Instance Manager on a virtual machine or bare metal system using the installation script in **online mode**.

The script installs the **latest** versions of:

- NGINX Open Source
- NGINX Instance Manager
- ClickHouse (by default, unless you choose to skip it)
- Optionally, NGINX Plus (requires a license and additional flags)

The script also installs all required system packages.

If you need an **earlier version** of NGINX or NGINX Instance Manager, use the [manual installation process]({{< ref "nim/install/vm-bare-metal/install-manually-online.md" >}}) for online setups or the [offline manual process]({{< ref "nim/install/vm-bare-metal/install-manually-offline.md" >}}) for disconnected environments.

{{< include "/nim/install/check-existing-installation.md" >}}

{{< call-out "note" "Using Vault?" >}}
If you plan to use Vault for secrets management, set it up before you continue with the installation.  
After the installation, follow the steps in the [Vault configuration guide]({{< ref "/nim/system-configuration/configure-vault.md" >}}) to complete the setup.
{{< /call-out >}}

---

## Download the installation script

{{< include "/nim/install/script-download.md" >}}

---

## Download the SSL certificate, private key, and JWT {#download-crt-key-jwt}

To install and license NGINX Instance Manager, you need to download your SSL certificate, private key, and JSON web token (JWT) from MyF5.

{{< include "/licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

The downloaded files may have names like `nginx-one-<subscription-id>.crt`, depending on your product and subscription.

## Rename the SSL and JWT files

{{< include "/nim/install/rename-crt-key-jwt.md" >}}

---

## Run the installation script {#install-nim}

The `install-nim-bundle.sh` script automates the installation of NGINX Instance Manager and its dependencies.

By default, the script:

- Assumes a fresh system with no existing NGINX Instance Manager installation
- Reads SSL certificate and key files from `/etc/ssl/nginx`
- Installs the latest version of NGINX Open Source (OSS)
- Installs the ClickHouse database
- Installs the latest version of NGINX Instance Manager
- Requires an active internet connection

### Script options

{{< include "/nim/install/install-script-options.md" >}}

### View supported Linux distributions

To see the list of supported Linux distributions for the installation script, run:

```bash
bash install-nim-bundle.sh -l
```

### Example: Install with NGINX Open Source

To install NGINX Instance Manager with NGINX Open Source on Ubuntu 24.04 using the default certificate and key locations (see [Download your SSL and JWT files](#download-crt-key-jwt)):

```bash
sudo bash install-nim-bundle.sh \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -d ubuntu24.04
```

Replace the placeholder paths with the actual locations of your files.

### Install with NGINX Open Source without ClickHouse (lightweight mode)

To skip ClickHouse if you don't need monitoring metrics:

```bash
sudo bash install-nim-bundle.sh \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -s \
  -d ubuntu24.04
```

Replace the placeholder paths with the actual locations of your files.

### Example: Install with NGINX Plus

To install NGINX Instance Manager with NGINX Plus on Ubuntu 24.04 using the default certificate and key locations (see [Download your SSL and JWT files](#download-crt-key-jwt)):

```bash
sudo bash install-nim-bundle.sh \
  -p \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -j <path/to/license.jwt> \
  -d ubuntu24.04
```

Replace the placeholder paths with the actual locations of your files.

### Example: Install with NGINX Plus without ClickHouse

To install NGINX Instance Manager with NGINX Plus on Ubuntu 24.04 using the default certificate and key locations (see [Download your SSL and JWT files](#download-crt-key-jwt)):

```bash
sudo bash install-nim-bundle.sh \
  -p \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -j <path/to/license.jwt> \
  -s \
  -d ubuntu24.04
```

{{< include "/nim/install/save-admin-password-callout.md" >}}

---

## Access the web interface {#access-web-interface}

{{< include "nim/install/access-web-ui.md" >}}

---

## Upgrade {#upgrade-nim}

Follow these steps to upgrade NGINX Instance Manager and, if applicable, ClickHouse.

1. **Upgrade the NGINX Instance Manager package**:
   - **For CentOS, RHEL, and RPM-based distributions**:

     ```bash
     sudo yum update -y nms-instance-manager --allowerasing
     ```

   - **For Debian, Ubuntu, and Deb-based distributions**:

     ```bash
     sudo apt-get update
     sudo apt-get install -y --only-upgrade nms-instance-manager
     ```

2. **(If installed) Upgrade ClickHouse**:
   - **For CentOS, RHEL, and RPM-based distributions**:

     ```bash
     sudo yum update -y clickhouse-server clickhouse-client
     ```

   - **For Debian, Ubuntu, and Deb-based distributions**:

     ```bash
     sudo apt-get update
     sudo apt-get install -y --only-upgrade clickhouse-server clickhouse-client
     ```

3. **Restart the NGINX Instance Manager platform services**:

   ```bash
   sudo systemctl restart nms
   ```

4. **Restart the NGINX web server**:

   ```bash
   sudo systemctl restart nginx
   ```

5. **(If installed) Restart the ClickHouse server**:

   ```bash
   sudo systemctl restart clickhouse-server
   ```

6. **(Optional) Restore SELinux labels**:

   If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "nim/system-configuration/configure-selinux.md" >}}) guide to restore SELinux contexts using `restorecon` for the files and directories related to NGINX Instance Manager.

---

## Uninstall {#uninstall-nim}

{{< include "nim/install/uninstall-nim.md" >}}

---

## Next steps

- [Explore post-installation options]({{< ref "/nim/install/vm-bare-metal/post-install-options.md" >}}) — Learn how to configure optional components such as ClickHouse, SELinux, Vault, and metrics collection.
- [Add a license and set up usage reporting]({{< ref "/nim/license/" >}})