---
title: Installing NGINX Plus LTS
description: Install F5 NGINX Plus LTS with step-by-step instructions for
  the base package on all supported distributions.
toc: true
weight: 120
nd-content-type: how-to
f5-product: F5 NGINX Plus
f5-docs: DOCS-000
---

Since May 13, 2026, NGINX Plus is published in two release types: Long-Term Support (LTS) and Continuous Release (CR).

The NGINX Plus LTS release model is designed for mission-critical production environments. Each LTS release is supported for three years and receives security fixes and CVE mitigations without introducing new features. New features are delivered in CRs during the same annual LTS cycle.

- **Cadence**: one LTS per year
- **Patching model**: security/CVE fixes only, no feature changes
- **Support window**: up to 3 years for each LTS release
- **Concurrency**: up to 3 LTS versions supported at the same time
- **Version format**: an LTS release has `0` as the second numeric component, for example: `PLS.37.0.0.1`. LTS updates increment the third component, for example: `PLS.37.0.1.1`.

NGINX Plus CRs are published several times within an annual LTS cycle. Each CR contains the latest features and performance improvements. The CR cycle ends when a new LTS is released.


## Repository configuration options {#repo-options}

By default, NGINX Plus repositories are configured to receive [Continuous Releases]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). To use LTS, update your repository configuration to point to the LTS package URL, replacing the default URL. You can choose one of the options during installation:

- **Pin to current LTS only**: receive only security updates for this LTS, no CRs, no upgrade to next LTS; supported up to three years. Follow the steps for your operating system in this guide.
- **Pin to LTS track**: upgrade to the newest LTS when it is released annually, no CRs. Follow the steps for your operating system in this guide.
- **Default**: receive Continuous Releases within the current LTS release, upgrade to each new LTS when it is released annually and then receive its CRs. See [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

## Prerequisites {#prereq}

Before you begin, make sure you have:

- [MyF5 Customer Portal](https://account.f5.com/myf5) access, credentials are provided in the email from F5, Inc.
- An active NGINX Plus subscription. Details can be verified on the [MyF5 Customer Portal](https://account.f5.com/myf5).
- A [supported operating system and architecture]({{< ref "nginx/technical-specs.md" >}}).
- Administrative privileges: `root` access or `sudo`, or see [Unprivileged installation]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#unpriv_install" >}}).
- Internet access, or see [Offline installation]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#offline_install" >}}).

## Preparation steps for all operating systems {#common-steps}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Follow the installation instructions for your operating system: [Amazon Linux 2023](#install_amazon2023), [Amazon Linux 2](#install_amazon2), [RHEL-based](#install_rhel), [Debian](#install_debian), [Ubuntu](#install_debian_ubuntu), [FreeBSD](#install_freebsd), [SLES](#install_suse), [Alpine](#install_alpine).


## Amazon Linux 2023 LTS packages {#install_amazon2023}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. Add the NGINX Plus repository to your Amazon Linux 2023 instance. Download the [plus-amazonlinux2023.repo](https://cs.nginx.com/static/files/plus-amazonlinux2023.repo) file to **/etc/yum.repos.d**:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
   ```

1. **Modify your NGINX Plus repository configuration to pin to the desired LTS track**. To change your update channel, edit the `/etc/yum.repos.d/plus-amazonlinux2023.repo` file and update the `baseurl` to the [appropriate value](#repo-options) for your target version.

   - Pin to current LTS version:

     ```none
     baseurl=https://pkgs.nginx.com/plus/R37.0/amzn/2023/$basearch
     ```
   - Pin to LTS track:

     ```none
     baseurl=https://pkgs.nginx.com/plus/LTS/amzn/2023/$basearch
     ```

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Amazon Linux 2 LTS packages {#install_amazon2}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-yum.md" >}}

1. Add the NGINX Plus repository to your Amazon Linux 2 instance. Download the [nginx-plus-amazon2.repo](https://cs.nginx.com/static/files/nginx-plus-amazon2.repo) file to **/etc/yum.repos.d**:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo
   ```
1. **Modify your NGINX Plus repository configuration to pin to the desired LTS track**. To change your update channel, edit the `/etc/yum.repos.d/nginx-plus-amazon2` file and update the `baseurl` to the [appropriate value](#repo-options) for your target version.

   - Pin to current LTS version:

     ```none
     baseurl=https://pkgs.nginx.com/plus/R37.0/amzn2/$releasever/$basearch
     ```
   - Pin to LTS track:

     ```none
     baseurl=https://pkgs.nginx.com/plus/LTS/amzn2/$releasever/$basearch
     ```

1. {{< include "nginx-plus/install/install-nginx-plus-package-yum.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## RHEL-based systems LTS packages {#install_rhel}

Supported RHEL-based operating systems include Red Hat Enterprise Linux, Oracle Linux, AlmaLinux, and Rocky Linux for versions 8.1+, 9.7+, and 10+.

1. Make sure you meet the [prerequisites](#prereq) and have completed the [common steps for all operating systems](#common-steps).

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. Add the NGINX Plus repository by downloading **nginx-plus-<version>.repo** file that matches your OS major version to **/etc/yum.repos.d**.

   - For **RHEL-based 8.1+**, download the [plus-8.repo](https://cs.nginx.com/static/files/plus-8.repo) file:

     ```shell
     sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-8.repo
     ```

   - For **RHEL-based 9.7+**, download the [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) file:

     ```shell
     sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
     ```

   - For **RHEL-based 10+**, download the [plus-10.repo](https://cs.nginx.com/static/files/plus-10.repo) file:

     ```shell
     sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-10.repo
     ```

1. **Modify your NGINX Plus repository configuration to pin to the desired LTS track**. To change your update channel, edit the `/etc/yum.repos.d/plus-<version>.repo` file and update the `baseurl` to the [appropriate value](#repo-options) for your target version.
   <br/>
   <br/>
   For **RHEL-based 8.1+**

   - Pin to current LTS version:

     ```none
     baseurl=https://pkgs.nginx.com/plus/R37.0/centos/8/$basearch/
     ```
   - Pin to LTS track:

     ```none
     baseurl=https://pkgs.nginx.com/plus/LTS/centos/8/$basearch/
     ```

   For **RHEL-based 9.7+**

   - Pin to current LTS version:

     ```none
     baseurl=https://pkgs.nginx.com/plus/R37.0/centos/9/$basearch/
     ```
   - Pin to LTS track:

     ```none
     baseurl=https://pkgs.nginx.com/plus/LTS/centos/9/$basearch/
     ```
     
   For **RHEL-based 10+**

   - Pin to current LTS version:

     ```none
     baseurl=https://pkgs.nginx.com/plus/R37.0/centos/10/$basearch/
     ```
   - Pin to LTS track:

     ```none
     baseurl=https://pkgs.nginx.com/plus/LTS/centos/10/$basearch/
     ```

   - Save the changes and exit.

   - Update the repository information:

     ```shell
     sudo dnf update
     ```

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Debian LTS packages {#install_debian}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

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

1. **Modify your NGINX Plus repository configuration to pin to the desired LTS track**. To change your update channel, edit the `/etc/apt/sources.list.d/nginx-plus.list` file and update the URL to the [appropriate value](#repo-options) for your target version.

   - Pin to current LTS version:

     ```none
     https://pkgs.nginx.com/plus/R37.0/debian
     ```
   - Pin to LTS track:

     ```none
     https://pkgs.nginx.com/plus/LTS/debian
     ```

1. Update the repository information:

   ```shell
   sudo apt update
   ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

   ```shell
   sudo apt install -y nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Ubuntu LTS packages {#install_debian_ubuntu}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

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

1. **Modify your NGINX Plus repository configuration to pin to the desired LTS track**. To change your update channel, edit the `/etc/apt/sources.list.d/nginx-plus.list` file and update the URL to the [appropriate value](#repo-options) for your target version.

   - Pin to current LTS version:

     ```none
     https://pkgs.nginx.com/plus/R37.0/ubuntu
     ```
   - Pin to LTS track:

     ```none
     https://pkgs.nginx.com/plus/LTS/ubuntu
     ```

1. Update the repository information:

   ```shell
   sudo apt update
   ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

   ```shell
   sudo apt install -y nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## FreeBSD LTS packages {#install_freebsd}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

1. Install the prerequisite **ca_root_nss** package:

   ```shell
   sudo pkg update && \
   sudo pkg install ca_root_nss
   ```

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

1. **Modify your NGINX Plus repository configuration to pin to the desired LTS track**. To change your update channel, edit the `/etc/pkg/nginx-plus.conf` file and update the `URL` to the [appropriate value](#repo-options) for your target version.

   - Pin to current LTS version:

     ```none
     URL: pkg+https://pkgs.nginx.com/plus/R37.0/freebsd/${ABI}/latest
     ```
   - Pin to LTS track:

     ```none
     URL: pkg+https://pkgs.nginx.com/plus/LTS/freebsd/${ABI}/latest
     ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced. Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

   ```shell
   sudo pkg install nginx-plus
   ```

1. Copy the downloaded JWT file to the **/usr/local/etc/nginx** directory and make sure it is named **license.jwt**:

   ```shell
   sudo cp license.jwt /usr/local/etc/nginx
   ```

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. Make sure license reporting to F5 licensing endpoint is configured. By default, no configuration is required. However, it becomes necessary when NGINX Plus is installed in a disconnected environment, uses NGINX Instance Manager for usage reporting, or uses a custom path for the license file. Configuration can be done in the [`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX Plus configuration file (`/usr/local/etc/nginx/nginx.conf`). For more information, see [About Subscription Licenses](https://docs.nginx.com/solutions/about-subscription-licenses/).

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## SUSE Linux Enterprise LTS packages {#install_suse}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

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

   For **SLES 15**, pinned to current LTS version:

   ```shell
   zypper addrepo -G -t yum -c \
   "https://pkgs.nginx.com/plus/R37.0/sles/15?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
   nginx-plus
   ```

   For **SLES 15**, pinned to LTS track:

   ```shell
   zypper addrepo -G -t yum -c \
   "https://pkgs.nginx.com/plus/LTS/sles/15?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
   nginx-plus
   ```

   For **SLES 16**, pinned to current LTS version:

   ```shell
   zypper addrepo -G -t yum -c \
   "https://pkgs.nginx.com/plus/R37.0/sles/16?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
   nginx-plus
   ```

   For **SLES 16**, pinned to LTS track:

   ```shell
   zypper addrepo -G -t yum -c \
   "https://pkgs.nginx.com/plus/LTS/sles/16?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
   nginx-plus
   ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

   ```shell
   zypper install nginx-plus
   ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Alpine LTS packages {#install_alpine}

1. Make sure you have met all [prerequisites](#prereq) and completed the [common steps for all operating systems](#common-steps).

1. Upload **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. Ensure these files contain only the specific key and certificate — Alpine Linux doesn't support mixing client certificates for multiple repositories.

1. Put the NGINX signing public key in the **/etc/apk/keys** directory:

   ```shell
   sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
   ```

1. Add the NGINX repository to the **/etc/apk/repositories** file.

   - Pin to current LTS version:

     ```shell
     printf "https://pkgs.nginx.com/plus/R37.0/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" \
     | sudo tee -a /etc/apk/repositories
     ```
   - Pin to LTS track:

     ```shell
     printf "https://pkgs.nginx.com/plus/LTS/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" \
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

1. Check the `nginx` version to verify that NGINX Plus LTS is installed correctly:

   ```shell
   nginx -v
   ```
   The command output should indicate an LTS release: the second numeric component of the Plus release version should be `0`:

   ```none
   nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
   ```

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}


## Upgrade NGINX Plus {#upgrade}

For general upgrade instructions, see [Upgrading NGNIX Plus]({{< ref "/nginx/admin-guide/installing-nginx/upgrading-nginx-plus.md" >}}).

