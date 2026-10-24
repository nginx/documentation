---
title: Installing NGINX Plus
description: Install F5 NGINX Plus with step-by-step instructions for
  the base package and dynamic modules on all supported distributions.
toc: true
weight: 100
f5-content-type: how-to
f5-product: NGINX Plus
---

This guide provides step-by-step instructions for installing NGINX Plus from an official repository on different operating systems. It also covers installing and enabling dynamic modules, as well as enabling NGINX Plus in rootless or offline environments.

## Release types and versioning

Since May 13, 2026, NGINX Plus is published in two release types:

- [Long-Term Support (LTS)](#lts) — stability and security-focused
- [Continuous Release (CR)](#cr) — feature and performance-focused

### Long-Term Support (LTS) {#lts}

The NGINX Plus LTS release model is intended for mission-critical production environments. During an LTS lifecycle, F5 delivers security fixes and CVE mitigations without introducing new features. New features are delivered in Continuous Releases (CR) during the same annual cycle.

- **Cadence**: annual (one LTS per year)
- **Patching model**: security/CVE fixes only (no feature changes within the LTS line)
- **Support window**: up to 3 years
- **Concurrency**: up to 3 LTS versions supported at the same time
- **Version format**: an LTS release has `0` as the second numeric component, for example: `PLS.37.0.0.1`. LTS updates increment the third component, for example: `PLS.37.0.1.1`.

{{< call-out class="note" title="Important" >}} To use the LTS release, update your repository configuration to point to the LTS package URL, replacing the default URL. See [Installing NGINX Plus LTS](). {{< /call-out >}}

### Continuous Release (CR) {#cr}

NGINX Plus Continuous Releases (CR) are published several times within an annual [LTS](#lts) cycle. Each CR contains the latest features and performance improvements. The CR cycle ends when a new LTS is released.

- **Cadence**: every 2–6 months
- **Patching model**: CRs are never patched; fixes, including CVEs, are delivered as the next CR
- **Support window**: latest CR only; when a new CR is released, the previous CR immediately reaches End of Support
- **Version format**: CRs increment the second numeric component, for example: `PLS.37.1.0.0`, `PLS.37.2.0.0`


### Repository configuration options

By default, NGINX Plus repositories are configured to receive Continuous Releases. To use LTS, update your repository configuration to point to the LTS package URL, replacing the default URL. See [Installing NGINX Plus LTS]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus-lts.md" >}}).

Available repository configuration options:

- **Default**: receive Continuous Releases within the current LTS release, upgrade to each new LTS when it is released annually and then receive its CRs. Follow the steps for your operating system in this guide.
- **Pin to current LTS only**: receive only security updates for this LTS, no CRs, no upgrade to next LTS; supported up to three years. See [Installing NGINX Plus LTS]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus-lts.md" >}}).
- **Pin to LTS track**: upgrade to the newest LTS when it is released annually, no CRs. See [Installing NGINX Plus LTS]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus-lts.md" >}}).

## Prerequisites {#prereq}

Before you begin, make sure you have:

- [MyF5 Customer Portal](https://account.f5.com/myf5) access, credentials are provided in the email from F5, Inc.
- An active paid or trial NGINX Plus subscription. Details can be verified on the [MyF5 Customer Portal](https://account.f5.com/myf5).
- A [supported operating system and architecture]({{< ref "nginx/technical-specs.md" >}}).
- Administrative privileges: `root` access or `sudo`, or see [Unprivileged installation](#unpriv_install).
- Internet access, or see [Offline installation](#offline_install).


## Amazon Linux 2023 CR packages {#install_amazon2023}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository to your Amazon Linux 2023 instance. Download the [plus-amazonlinux2023.repo](https://cs.nginx.com/static/files/plus-amazonlinux2023.repo) file to **/etc/yum.repos.d**:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
   ```

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## RHEL-based 8.1+ CR packages {#install_rhel8}

Supported RHEL-based systems include RHEL 8.1+, Oracle Linux 8.1+, AlmaLinux 8, and Rocky Linux 8. 

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository by downloading the [nginx-plus-8.repo](https://cs.nginx.com/static/files/plus-8.repo) file to **/etc/yum.repos.d**:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-8.repo
   ```

   {{< details summary="Pin NGINX Plus to a specific version" >}}{{< call-out class="note">}}{{< include "nginx-plus/install/pin-to-version/pin-rhel8-R32.md" >}}{{< /call-out >}}

   {{< /details >}}

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## RHEL-based 9.0+ CR packages {#install_rhel}

Supported RHEL-based systems include RHEL 9.0+, Oracle Linux 9, AlmaLinux 9, Rocky Linux 9.

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository by downloading the [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) file to **/etc/yum.repos.d**:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
   ```

   {{< details summary="Pin NGINX Plus to a specific version" >}}{{< call-out class="note">}}{{< include "nginx-plus/install/pin-to-version/pin-rhel9-R32.md" >}}{{< /call-out >}}{{< /details >}}

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## RHEL-based 10.0+ CR packages {#install_rhel10}

Supported RHEL-based systems include RHEL 10.0+, Oracle Linux 10.0+, AlmaLinux 10.0+, Rocky Linux 10.0+.

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository by downloading the [plus-10.repo](https://cs.nginx.com/static/files/plus-10.repo) file to **/etc/yum.repos.d**:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-10.repo
   ```

   {{< details summary="Pin NGINX Plus to a specific version" >}}{{< call-out class="note">}}{{< include "nginx-plus/install/pin-to-version/pin-rhel9-R32.md" >}}{{< /call-out >}}{{< /details >}}

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Debian CR packages {#install_debian}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Install the prerequisites packages:

   ```shell
   sudo apt update && \
   sudo apt install apt-transport-https \
                    lsb-release \
                    ca-certificates \
                    wget \
                    gnupg2 \
                    debian-archive-keyring
   ```

1. Download and add NGINX signing key:

   ```shell
   wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
       | gpg --dearmor \
       | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

   ```
1. Add the NGINX Plus repository:

   ```shell
   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" \
   | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

1. Download the **nginx-plus** apt configuration to **/etc/apt/apt.conf.d**:

   ```shell
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
   ```

   {{< details summary="Pin NGINX Plus to a specific version" >}}{{< call-out class="note">}}{{< include "nginx-plus/install/pin-to-version/pin-debian-ubuntu-R32.md" >}}{{< /call-out >}}{{< /details >}}

1. Update the repository information:

   ```shell
   sudo apt update
   ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

   ```shell
   sudo apt install -y nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Ubuntu CR packages {#install_debian_ubuntu}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Install the prerequisites packages:

   ```shell
   sudo apt update && \
   sudo apt install apt-transport-https \
                    lsb-release \
                    ca-certificates \
                    wget \
                    gnupg2 \
                    ubuntu-keyring
   ```

1. Download and add NGINX signing key:

   ```shell
   wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
   | gpg --dearmor \
   | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
   ```
1. Add the NGINX Plus repository:

   ```shell
   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" \
   | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

1. Download the **nginx-plus** apt configuration to **/etc/apt/apt.conf.d**:

   ```shell
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
   ```

   {{< details summary="Pin NGINX Plus to a specific version" >}}{{< call-out class="note">}}{{< include "nginx-plus/install/pin-to-version/pin-debian-ubuntu-R32.md" >}}{{< /call-out >}}{{< /details >}}

1. Update the repository information:

   ```shell
   sudo apt update
   ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

   ```shell
   sudo apt install -y nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## FreeBSD CR packages {#install_freebsd}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. Install the prerequisite **ca_root_nss** package:

   ```shell
   sudo pkg update
   sudo pkg install ca_root_nss
   ```

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Copy the [nginx-plus.conf](https://cs.nginx.com/static/files/nginx-plus.conf) file to the **/etc/pkg/** directory:

   ```shell
   sudo fetch -o /etc/pkg/nginx-plus.conf http://cs.nginx.com/static/files/nginx-plus.conf
   ```

1. Add the following lines to the **/usr/local/etc/pkg.conf** file:

    ```none
    PKG_ENV: { SSL_NO_VERIFY_PEER: "1",
    SSL_CLIENT_CERT_FILE: "/etc/ssl/nginx/nginx-repo.crt",
    SSL_CLIENT_KEY_FILE: "/etc/ssl/nginx/nginx-repo.key" }
    ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced. Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

   ```shell
   sudo pkg install nginx-plus
   ```

1. Copy the downloaded JWT file to the **/usr/local/etc/nginx** directory and make sure it is named **license.jwt**:

   ```shell
   sudo cp license.jwt /usr/local/etc/nginx
   ```

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. Make sure license reporting to F5 licensing endpoint is configured. By default, no configuration is required. However, it becomes necessary when NGINX Plus is installed in a disconnected environment, uses NGINX Instance Manager for usage reporting, or uses a custom path for the license file. Configuration can be done in the [`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX Plus configuration file (`/usr/local/etc/nginx/nginx.conf`). For more information, see [About Subscription Licenses](https://docs.nginx.com/solutions/about-subscription-licenses/).

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## SLES CR packages {#install_suse}

NGINX Plus can be installed on SUSE Linux Enterprise Server.

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Create a file bundle of the certificate and key:

   ```shell
   cat /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key > /etc/ssl/nginx/nginx-repo-bundle.crt
   ```

1. Install the required **ca-certificates** dependency:

   ```shell
   zypper refresh
   zypper install ca-certificates
   ```

1. Add the **nginx-plus** repo.

   For **SLES 15**:

   ```shell
   zypper addrepo -G -t yum -c \
   "https://pkgs.nginx.com/plus/sles/15?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
   nginx-plus
   ```

   For **SLES 16**:

   ```shell
   zypper addrepo -G -t yum -c \
   "https://pkgs.nginx.com/plus/sles/16?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
   nginx-plus
   ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

   ```shell
   zypper install nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Alpine CR packages {#install_alpine}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. Upload **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. Ensure these files contain only the specific key and certificate — Alpine Linux doesn't support mixing client certificates for multiple repositories.

1. Put the NGINX signing public key in the **/etc/apk/keys** directory:

   ```shell
   sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
   ```

1. Add the NGINX repository to the **/etc/apk/repositories** file:

   ```shell
   printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" \
   | sudo tee -a /etc/apk/repositories
   ```

1. Remove all community-supported NGINX packages. Note that this will also remove all NGINX modules:

   ```shell
   sudo apk del -r nginx
   ```

1. Install the NGINX Plus package:

   ```shell
   sudo apk add nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Dynamic modules {#install_modules}

NGINX Plus functionality can be extended with dynamic modules, which are shared object (`.so`) files installed and updated independently of the core NGINX Plus binary. Modules are installed as packaged binaries from NGINX official repository, and then loaded through the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive into NGINX Plus.

From the official repository, NGINX provides packaged binaries of their own modules and most popular third-party community modules. You can also compile and connect your own or other community dynamic module.

Full information about dynamic modules is available in the [Dynamic Modules]({{< ref "nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) section.


### Install dynamic module package 

NGINX‑authored and NGINX‑certified Community dynamic modules can be installed as packaged binaries directly from the official `nginx-plus` repository.

To install a binary package, run the command in a terminal that corresponds to your operating system, replacing `<MODULE_NAME>` with the actual binary package name, for example, `nginx-plus-module-njs`.

- For RHEL, CentOS, Oracle Linux:

  ```shell
  sudo yum update && \
  sudo yum install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Amazon Linux 2023,  AlmaLinux and Rocky Linux:

  ```shell
  sudo dnf update && \
  sudo dnf install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Debian and Ubuntu:

  ```shell
  sudo apt update && \
  sudo apt install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib/nginx/modules`

- For FreeBSD:

  ```shell
  sudo pkg update && \
  sudo pkg install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/local/etc/nginx/modules`

- For SUSE Linux Enterprise:

  ```shell
  sudo zypper refresh && \
  sudo zypper install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Alpine Linux:

  ```shell
  sudo apk update && \
  sudo apk add <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib/nginx/modules`

For detailed description and installation steps for each dynamic module, see [NGINX Plus Dynamic Modules]({{< ref "nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}).

Some modules may not be available on specific operating systems due to platform-level limitations. For detailed modules compatibility, see the [Dynamic Modules]({{< ref "nginx/technical-specs.md#dynamic-modules" >}}) section of the [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}}).

After installing the module, you will need to:

- enable it with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive
- configure it according to the module's documentation

### Enable dynamic modules {#enable_dynamic}

To enable a dynamic module:

1. In a text editor, open the NGINX Plus configuration file:
   - `/etc/nginx/nginx.conf` for Linux
   - `/usr/local/etc/nginx/nginx.conf` for FreeBSD

1. On the top-level (or the “`main`” context, before any `http` or `stream` blocks), specify the path to the `.so` file with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. By default, the files are expected to be in the `/modules` directory. The path to the directory depends on your operating system:

   - `/usr/lib64/nginx/modules/` for most Linux operating systems
   - `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
   - `/usr/local/etc/nginx/modules` for FreeBSD

   If there are several dynamic modules, specify each module with a separate `load_module` directive:

   ```nginx
   load_module modules/<MODULE_NAME_1>.so;
   load_module modules/<MODULE_NAME_2>.so;

   http {
       #...
   }

   stream {
       #...
   }
   ```

   Replace `<MODULE_NAME_1>` with the name of the first dynamic module and `<MODULE_NAME_2>` with the name of the second dynamic module.

1. Save the changes.

1. Check the new configuration for syntactic validity:

   ```shell
   nginx -t
   ```

1. Reload the NGINX Plus configuration:

   ```shell
   nginx -s reload
   ```

   After installing the module, you will need to configure the module in the NGINX Plus configuration file. Follow the usage and setup instructions provided in the module’s official documentation.


## NGINX Plus unprivileged installation {#unpriv_install}

In some environments, access to the root account is restricted for security reasons. On Linux systems, this limitation prevents the use of package managers to install NGINX Plus without root privileges.

As a workaround, in such environments NGINX Plus can be installed with a special script that modifies NGINX Plus configuration file to allow it to run from a non-root user. This script performs the following actions:

- Downloads the NGINX Plus packages

- Extracts the content of the archives into a user-defined directory of the packages

- Updates the paths in the NGINX configuration file to use relative paths in the specified directory

- Makes a backup copy of the configuration directory

- Provides an option to upgrade an existing unprivileged installation of NGINX Plus

Comparing to a standard installation of NGINX Plus, an unprivileged installation has certain limitations and restrictions:

- Root privileges are still required in order to listen on ports below `1024`.

- The script is not intended to replace your operating system's package manager and does not allow for the installation of any software other than NGINX Plus and its modules. Modifications to the script for other installations are not covered by the support program.

- NGINX Plus will not start automatically, so, you must add a custom `init` script or a `systemd` unit file for each unprivileged installation on the host.

- all dependencies and libraries required by the NGINX Plus binary and its modules are not installed automatically and should be checked and installed manually.

The script can be run on the following operating systems:

- RedHat, CentOS
- Amazon Linux 2023
- Debian, Ubuntu
- Alpine Linux
- AlmaLinux, Rocky Linux

Before starting the unprivileged installation, make sure you have all the prerequisites listed in the [Prerequisites](#prereq) section (excluding `root` privileges). For RPM-based distributions, verify that you have [`rpm2cpio`](https://man7.org/linux/man-pages/man8/rpm2cpio.8.html) installed.

To perform an unprivileged installation of NGINX Plus:

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. Ensure that the downloaded JWT license file is named **license.jwt**.

1. Obtain the script:

   ```shell
   wget https://raw.githubusercontent.com/nginxinc/nginx-plus-install-tools/main/ngxunprivinst.sh
   ```

1. Make the script executable:

   ```shell
   chmod +x ngxunprivinst.sh
   ```

1. Download NGINX Plus and its module packages for your operating system. The `<CERT_FILE>` and `<KEY_FILE>` are your NGINX Plus certificate and a private key required to access the NGINX Plus repo:

   ```shell
   ./ngxunprivinst.sh fetch -c <CERT_FILE> -k <KEY_FILE>
   ```

   If you need to install a particular version of NGINX Plus:

   - first, list all available NGINX Plus versions from the repository:

       ```shell
       ./ngxunprivinst.sh list -c <CERT_FILE> -k <KEY_FILE>
       ```

   - then specify a particular NGINX Plus version with the `-v` parameter:

       ```shell
       ./ngxunprivinst.sh fetch -c <CERT_FILE> -k <KEY_FILE> -v <VERSION>
       ```

       Replace `<VERSION>` with the version of the NGINX Plus API.

1. Extract the downloaded packages to the program prefix `<INSTALL_PATH>` specified by the `-p` parameter and specify the **license.jwt** `<LICENSE_FILE>` with the `-j` parameter. The optional `-y` parameter allows overwriting an existing installation:

   ```shell
   ./ngxunprivinst.sh install [-y] -p <INSTALL_PATH> -j <LICENSE_FILE> <FILE1.RPM> <FILE2.RPM>
   ```

   Replace `<FILE1.RPM>` with the name of the first downloaded RPM package and `<FILE2.RPM>` with the name of the second downloaded RPM package.

1. When the installation procedure is finished, run NGINX Plus. The `-p` parameter sets a path to the directory that keeps nginx files. The `-c` parameter sets a path to an alternative NGINX configuration file. Please note NGINX Plus must listen on ports above `1024`:

   ```shell
   <INSTALL_PATH>/usr/sbin/nginx -p <INSTALL_PATH>/etc/nginx -c <INSTALL_PATH>/etc/nginx/conf.d
   ```

With this script, you can also upgrade an existing unprivileged installation of NGINX Plus in the provided `<INSTALL_PATH>`. The optional `-y` parameter performs a forced upgrade without any confirmation:

```shell
./ngxunprivinst.sh upgrade [-y] -p <INSTALL_PATH> <FILE1.RPM> <FILE2.RPM>
```

## NGINX Plus offline installation {#offline_install}

This section explains how to install NGINX Plus and its [dynamic modules]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) on a server with limited or no Internet access.

To install NGINX Plus offline, you will need a machine connected to the Internet to get the NGINX Plus package, JWT license, SSL certificate and key. Then your can transfer these files to the target server for offline installation.

### Step 1: Obtaining files on the machine connected to the Internet {#offline-obtain-files}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. Transfer the files to the target server that doesn't have online access and where NGINX Plus will be installed.

### Step 2: Installing NGINX Plus on a server without Internet connectivity

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. Make sure you’ve downloaded the SSL certificate, private key, and the JWT file required for your NGINX Plus subscription. You can find these files in the MyF5 Customer Portal. For details on how to obtain these files, see [Step 1: Obtaining files on the machine connected to the Internet](#offline-obtain-files).

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Install the NGINX Plus package or a dynamic module. Any older NGINX Plus package is automatically replaced.

    - **For RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux and Rocky Linux**:

         ```shell
         sudo rpm -ihv <RPM_PACKAGE_NAME>
         ```

         Replace `<RPM_PACKAGE_NAME>` with the name of the RPM package.

    - **For Debian, Ubuntu**:

         ```shell
         sudo dpkg -i <DEB_PACKAGE_NAME>
         ```

         Replace `<DEB_PACKAGE_NAME>` with the name of the DEB package.

    - **For Alpine**:

         ```shell
         apk add <APK_PACKAGE_NAME>
         ```

         Replace `<APK_PACKAGE_NAME>` with the name of the APK package.

    - **For SLES**:

         ```shell
         rpm -ivh <RPM_PACKAGE_NAME>
         ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. Install NGINX Instance Manager 2.18 or later in your local environment to enable usage reporting, which is mandatory since R33. For more information, see [Disconnected environments](https://docs.nginx.com/nginx-instance-manager/disconnected/) and [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

1. Configure usage reporting of the NGINX Plus instance to NGINX Instance Manager which is mandatory starting from R33.

    In the `nginx.conf` configuration file, specify the following directives:

    - the [`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) block that handles NGINX Plus licensing and usage reporting configuration,

    - the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive that sets the domain name or IP address of NGINX Instance Manager,

    - the [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive that enables the 180-day grace period for sending the initial usage report. The initial usage report must be received by F5 licensing endpoint during the grace period, otherwise traffic processing will be stopped:

    ```nginx
    mgmt {
        usage_report endpoint=NIM_FQDN;
        enforce_initial_report off;
    }
    ```

1. {{< include "nginx-plus/install/nim-disconnected-report-usage.md" >}}

1. Upload the usage acknowledgement to NGINX Instance Manager. For more information, see [Report usage to F5 in a disconnected environment](https://docs.nginx.com/nginx-instance-manager/disconnected/report-usage-disconnected-deployment/#submit-usage-report).


## Explore related topics

### Install F5 WAF for NGINX

To install F5 WAF for NGINX, follow the steps in the [F5 WAF for NGINX install section]({{< ref "/waf/install/" >}}).

## Upgrade NGINX Plus {#upgrade}

For upgrade instructions, see [Upgrading NGNIX Plus]({{< ref "/nginx/admin-guide/installing-nginx/upgrading-nginx-plus.md" >}})

