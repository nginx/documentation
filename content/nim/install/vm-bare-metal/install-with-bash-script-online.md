---
description: ''
title: Install using a bash script (online)
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

{{< call-out "important" "Important: Start with a clean installation" >}}
{{< include "/nim/install/check-exsiting-installation.md" >}}
{{< /call-out >}}

{{< call-out "note" "Using Vault?" >}}
If you plan to use Vault for secrets management, set it up before you continue with the installation.  
After the installation, follow the steps in the [Vault configuration guide]({{< ref "/nim/system-configuration/configure-vault.md" >}}) to complete the setup.
{{< /call-out >}}

---

## Download the installation script

{{< include "/nim/install/script-download.md" >}}

---

## Download the SSL certificate, private key, and JWT {#download-crt-key-jwt}

{{< include "/nim/install/nim-download-crt-key-jwt.md" >}}

---

## Run the installation script

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

```shell
install-nim-bundle.sh -l
```

### Example: Install with NGINX Open Source using default certificate paths

To install NGINX Instance Manager with NGINX Open Source on Ubuntu 24.04 using the default certificate and key locations (see [Download your SSL and JWT files](#download-crt-key-jwt)):

```bash
sudo bash install-nim-bundle.sh -d ubuntu24.04
```

### Example: Install with NGINX Plus using default certificate paths

To install NGINX Instance Manager with NGINX Plus on Ubuntu 24.04 using the default certificate, key, and JWT license locations (see [Download your SSL and JWT files](#download-crt-key-jwt)):

```bash
sudo bash install-nim-bundle.sh -p -j /etc/nginx/license.jwt -d ubuntu24.04
```

### Example: Install with NGINX Plus using custom paths

If your certificate, key, or license files are stored in non-default locations, specify them with the appropriate flags:

```bash
sudo bash install-nim-bundle.sh \
  -c <path/to/nginx-repo.crt> \
  -k <path/to/nginx-repo.key> \
  -p \
  -d ubuntu24.04 \
  -j <path/to/license.jwt>
```

Replace the placeholder paths with the actual locations of your files.

{{< call-out "important" "Save the admin password" >}}
After installation completes, the script generates an admin password. It may take a few minutes to appear:

```text
Regenerated Admin password: <encrypted password>
```

Save this password. You’ll need it to sign in to the NGINX Instance Manager web interface.
{{< /call-out >}}

---

## Access the web interface {#access-web-interface}

{{< include "nim/install/access-web-ui.md" >}}

---

## Upgrade NGINX Instance Manager {#upgrade-nim}

{{<tabs name="upgrade_nim">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To upgrade to the latest version of the NGINX Instance Manager, run the following command:

   ```shell
   sudo yum update -y nms-instance-manager --allowerasing
   ```

1. To upgrade to the latest version of Clickhouse, run the following command:

   ```shell
   sudo yum update -y clickhouse-server clickhouse-client
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To upgrade to the latest version of the NGINX Instance Manager, run the following commands:

   ```shell
   sudo apt-get update
   sudo apt-get install -y --only-upgrade nms-instance-manager
   ```

1. To upgrade to the latest version of ClickHouse, run the following commands:

   ```shell
   sudo apt-get update
   sudo apt-get install -y --only-upgrade clickhouse-server clickhouse-client
   ```

{{%/tab%}}
{{</tabs>}}

2. Restart the NGINX Instance Manager platform services:

    ```shell
    sudo systemctl restart nms
    ```

    NGINX Instance Manager components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```shell
   sudo systemctl restart nginx
   ```

4. Restart the Clickhouse server:

   ```shell
   sudo systemctl restart clickhouse-server
   ```

5. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "nim/system-configuration/configure-selinux.md" >}}) guide to restore the default SELinux labels (`restorecon`) for the files and directories related to NGINX Instance Manager.

---

## Uninstall NGINX Instance Manager {#uninstall-nim}

{{< include "nim/uninstall/uninstall-nim.md" >}}

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
