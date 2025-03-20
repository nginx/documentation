---
description: Install and upgrade F5 NGINX Plus with step-by-step instructions for
  the base package and dynamic modules on all supported Linux distributions.
docs: DOCS-414
title: Installing NGINX Plus
toc: true
weight: 100
type:
- how-to
---

This article explains how to install NGINX Plus on different operating systems, upgrade existing NGINX Plus installation, install and enable dynamic modules, install in rootless mode or when offline.

## Prerequisites {#prereq}

- An NGINX Plus subscription (purchased or trial)
- Credentials to the [MyF5 Customer Portal](https://account.f5.com/myf5), provided by email from F5, Inc.
- A [supported operating system]({{< relref "nginx/technical-specs.md" >}})
- `root` privilege

## Install NGINX Plus on Amazon Linux 2023 {#install_amazon2023}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}
 
1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository to your Amazon Linux 2023 instance. Download the [plus-amazonlinux2023.repo](https://cs.nginx.com/static/files/plus-amazonlinux2023.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
    ```

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on Amazon Linux 2 {#install_amazon2}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-yum.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository to your Amazon Linux 2 instance. Download the [nginx-plus-amazon2.repo](https://cs.nginx.com/static/files/nginx-plus-amazon2.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo
    ```

1. {{< include "nginx-plus/install/install-nginx-plus-package-yum.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on RHEL 7.4+, CentOS 7.4+, and Oracle Linux 7.4+ {#install_rhel_centos}

{{< call-out "important" "Deprecation notice" "" >}}
CentOS 7.4, RHEL 7.4, and Oracle Linux 7.4 are deprecated as of NGINX Plus Release 32 (R32) and are not supported in Release 33 (R33) or later. For the list of supported distributions, refer to the [NGINX Plus Tech Specs]({{< relref "nginx/technical-specs.md" >}}).
{{</ call-out >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. Download the SSL certificate and private key associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    - Log in to [MyF5](https://my.f5.com/manage/s/).
    - Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
    - Find your NGINX products or services subscription, and select the **Subscription ID** for details.
    - Download the **nginx-repo.crt** and **nginx-repo.key** from the subscription page.

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-yum.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository by downloading the [nginx-plus-7.4.repo](https://cs.nginx.com/static/files/nginx-plus-7.4.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

    <details open>
    <summary style="font-weight:bold;">Learn how to pin NGINX Plus to a specific version</summary>
    {{<call-out "tip" "Tip: Pin NGINX Plus to a specific version" "fa-solid fa-thumbtack">}}{{< include "nginx-plus/install/pin-to-version/pin-rhel7-R32.md" >}}{{</call-out>}}
    </details>

1. {{< include "nginx-plus/install/install-nginx-plus-package-yum.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on RHEL 8.1+, Oracle Linux 8.1+, AlmaLinux 8, Rocky Linux 8 {#install_rhel8}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository by downloading the [nginx-plus-8.repo](https://cs.nginx.com/static/files/nginx-plus-8.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    ```

    <details open>
    <summary style="font-weight:bold;">Learn how to pin NGINX Plus to a specific version</summary>
    {{<call-out "tip" "Tip: Pin NGINX Plus to a specific version" "fa-solid fa-thumbtack">}}{{< include "nginx-plus/install/pin-to-version/pin-rhel8-R32.md" >}}{{</call-out>}}
    </details>

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on RHEL 9.0+, Oracle Linux 9, AlmaLinux 9, Rocky Linux 9 {#install_rhel}

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}
 
1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/install-ca-certificates-dependency-dnf.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Add the NGINX Plus repository by downloading the [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
    ```

    <details open>
    <summary style="font-weight:bold;">Learn how to pin NGINX Plus to a specific version</summary>
    {{<call-out "tip" "Tip: Pin NGINX Plus to a specific version" "fa-solid fa-thumbtack">}}{{< include "nginx-plus/install/pin-to-version/pin-rhel9-R32.md" >}}{{</call-out>}}
    </details>

1. {{< include "nginx-plus/install/install-nginx-plus-package-dnf.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/enable-nginx-service-at-boot.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on Debian or Ubuntu {#install_debian_ubuntu}

NGINX Plus can be installed on the following versions of Debian or Ubuntu:

1. {{< include "nginx-plus/install/check-tech-specs.md" >}}
 
1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Install the prerequisites packages:

    - **For Debian**:

        ```shell
        sudo apt update
        sudo apt install apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring
        ```

    - **For Ubuntu**:

        ```shell
        sudo apt update
        sudo apt install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
        ```

1. Download and add NGINX signing key:

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
        | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

1. Add the NGINX Plus repository:

    - **For Debian**:

        ```shell
        printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
        https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" \
        | sudo tee /etc/apt/sources.list.d/nginx-plus.list
        ```

    - **For Ubuntu**:

        ```shell
        printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
        https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" \
        | sudo tee /etc/apt/sources.list.d/nginx-plus.list
        ```

    <details open>
    <summary style="font-weight:bold;">Learn how to pin NGINX Plus to a specific version</summary>
    {{<call-out "tip" "Tip: Pin NGINX Plus to a specific version" "fa-solid fa-thumbtack">}}{{< include "nginx-plus/install/pin-to-version/pin-debian-ubuntu-R32.md" >}}{{</call-out>}}
    </details>

1. Download the **nginx-plus** apt configuration to **/etc/apt/apt.conf.d**:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

1. Update the repository information:

    ```shell
    sudo apt update
    ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo apt install -y nginx-plus
    ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on FreeBSD {#install_freebsd}

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

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced. Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

    ```shell
    sudo pkg install nginx-plus
    ```

1. Copy the downloaded JWT file to the **/usr/local/etc/nginx** directory and make sure it is named **license.jwt**:

    ```shell
    sudo cp license.jwt /usr/local/etc/nginx
    ```

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on SUSE Linux Enterprise Server {#install_suse}

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

    **For SLES 12**:

    ```shell
    zypper addrepo -G -t yum -c \
    "https://pkgs.nginx.com/plus/sles/12?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
    nginx-plus
    ```

    **For SLES 15**:

    ```shell
    zypper addrepo -G -t yum -c \
    "https://pkgs.nginx.com/plus/sles/15?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer" \
    nginx-plus
    ```

1. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    zypper install nginx-plus
    ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install NGINX Plus on Alpine Linux {#install_alpine}

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

1. Install the NGINX Plus package:

    ```shell
    sudo apk add nginx-plus
    ```

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

1. {{< include "nginx-plus/install/configure-usage-reporting.md" >}}

1. {{< include "nginx-plus/install/install-nginx-agent-for-nim.md" >}}

## Install Dynamically Loadable Modules {#install_modules}

NGINX Plus functionality can be extended with dynamically loadable modules that are not included in the prebuilt packages:

- NGINX-authored dynamic modules – Modules developed and maintained by F5 NGINX. These modules can be installed directly from the official repository:
  - [GeoIP]({{< relref "nginx/admin-guide/dynamic-modules/geoip.md" >}})
  - [Image-Filter]({{< relref "nginx/admin-guide/dynamic-modules/image-filter.md" >}})
  - [njs Scripting Language]({{< relref "nginx/admin-guide/dynamic-modules/nginscript.md" >}})
  - [OTel]({{< relref "nginx/admin-guide/dynamic-modules/opentelemetry.md" >}})
  - [Perl]({{< relref "nginx/admin-guide/dynamic-modules/perl.md" >}})
  - [XSLT]({{< relref "nginx/admin-guide/dynamic-modules/xslt.md" >}})

- NGINX-certified community dynamic modules – Popular third‑party modules tested and distributed by F5 NGINX, with installation and basic configuration support provided. These modules are also available directly from the official repository:
  - [Brotli]({{< relref "nginx/admin-guide/dynamic-modules/brotli.md" >}})
  - [Encrypted-Session]({{< relref "nginx/admin-guide/dynamic-modules/encrypted-session.md" >}})
  - [FIPS Status Check]({{< relref "nginx/admin-guide/dynamic-modules/fips.md" >}})
  - [GeoIP2]({{< relref "nginx/admin-guide/dynamic-modules/geoip2.md" >}})
  - [Headers-More]({{< relref "nginx/admin-guide/dynamic-modules/headers-more.md" >}})
  - [HTTP Substitutions Filter]({{< relref "nginx/admin-guide/dynamic-modules/http-substitutions-filter.md" >}})
  - [Lua]({{< relref "nginx/admin-guide/dynamic-modules/lua.md" >}})
  - [NGINX Developer Kit]({{< relref "nginx/admin-guide/dynamic-modules/ndk.md" >}})
  - [OpenTelemetry]({{< relref "nginx/admin-guide/dynamic-modules/opentelemetry.md" >}})
  - [OpenTracing]({{< relref "nginx/admin-guide/dynamic-modules/opentracing.md" >}})
  - [Phusion Passenger]({{< relref "nginx/admin-guide/dynamic-modules/passenger-open-source.md" >}})
  - [Prometheus-njs]({{< relref "nginx/admin-guide/dynamic-modules/prometheus-njs.md" >}})
  - [RTMP]({{< relref "nginx/admin-guide/dynamic-modules/rtmp.md" >}})
  - [Set-Misc]({{< relref "nginx/admin-guide/dynamic-modules/set-misc.md" >}})
  - [SPNEGO]({{< relref "nginx/admin-guide/dynamic-modules/spnego.md" >}})

- Community dynamic modules – Modules written and distributed by third‑party members of the NGINX community. To use these modules, download the source code from the author's repository and [compile it against the NGINX Open Source version](#install_modules_oss) corresponding to your NGINX Plus version. These modules are not available in the official repository but can be found in different community resources such as [awesome-nginx GitHub project](https://github.com/agile6v/awesome-nginx#third-party-modules).

### Install Dynamic Modules from Official Repository {#install_modules_plus}

NGINX‑authored and NGINX‑certified dynamic modules can be installed directly from the modules repository. To install the modules:

- For RHEL, Amazon Linux 2, CentOS, Oracle Linux:

  ```shell
  yum update
  yum install <MODULE-NAME>
  ```

- For Amazon Linux 2023,  AlmaLinux and Rocky Linux:

  ```shell
  dnf update
  dnf install <MODULE-NAME>
  ```

- For Debian and Ubuntu:

  ```shell
  apt update
  apt install <MODULE-NAME>
  ```

- For FreeBSD:

  ```shell
  pkg update
  pkg install <MODULE-NAME>
  ```

- For SLES:

  ```shell
  zypper refresh
  zypper install <MODULE-NAME>
  ```

- For Alpine Linux:

  ```shell
  sudo apk update
  sudo apk add <MODULE-NAME>
  ```

See [NGINX Plus Dynamic Modules]({{< relref "nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) for detailed installation instructions for each dynamic module.

Note that some modules may not be available for certain OS versions because of operating system limitations. For details and descriptions of the modules, see the [NGINX Plus Technical Specifications]({{< relref "nginx/technical-specs.md" >}}).

After installing the module, you need to enable it in the NGINX Plus configuration file. For more information, see [Enabling Dynamic Modules](#enable_dynamic).

### Install NGINX Community Modules {#install_modules_oss}

For a community dynamic module to work with NGINX Plus, it must be compiled alongside the corresponding version of NGINX Open Source.

1. Prepare the build environment.

   We strongly recommend compiling dynamic modules on a separate system, referred to as the “build environment”. This approach minimizes the risk and complexity for the system where NGINX Plus will be upgraded, referred to as the “production environment”. The build environment should meet the following requirements:

   - The same operating system as the production environment
   - The same NGINX version as the production environment
   - Compiler and `make` utilities
   - [PCRE](http://pcre.org/) library (development files)
   - [Zlib](http://www.zlib.net/) compression libraries (development files)

   To verify that the required prerequisites are installed in your build environment, run the following commands:

   - For Debian and Ubuntu:

     ```shell
     sudo apt update
     sudo apt install gcc make libpcre3-dev zlib1g-dev
     ```

   - For CentOS, Oracle Linux, and RHEL:

     ```shell
     sudo yum update
     sudo yum install gcc make pcre-devel zlib-devel
     ```

1. Obtain NGINX Open Source.

   - Identify the NGINX Open Source version that corresponds to your version of NGINX Plus. See [NGINX Plus Releases]({{< relref "nginx/releases.md" >}}).

   - Download the sources for the appropriate NGINX Open Source mainline version, in this case 1.27.2:

     ```shell
     wget -qO - https://nginx.org/download/nginx-1.27.2.tar.gz | tar zxfv -
     ```

1. Obtain the source for the dynamic module.

   The source code for the dynamic module can be placed in any directory in the build environment. As an example, here we're copying the [NGINX “Hello World” module](https://github.com/perusio/nginx-hello-world-module.git/) from GitHub:

   ```shell
   git clone https://github.com/perusio/nginx-hello-world-module.git
   ```

1. Compile the dynamic module.

   First establish binary compatibility by running the `configure` script with the `‑‑with‑compat` option. Then compile the module with `make modules`.

   ```shell
   cd nginx-1.27.2/
   ./configure --with-compat --add-dynamic-module=../<MODULE-SOURCES>
   make modules
   ```

   The **.so** file generated by the build process is placed in the **objs** subdirectory

   ```shell
   ls objs/*.so
   objs/ngx_http_hello_world.so
   ```

1. Make a copy of the module file and include the NGINX Open Source version in the filename. This makes it simpler to manage multiple versions of a dynamic module in the production environment.

   ```shell
   cp objs/ngx_http_hello_world.so ./ngx_http_hello_world_1.27.2.so
   ```

### Enabling Dynamic Modules {#enable_dynamic}

Dynamic modules are located in the **/etc/nginx/modules** directory, which is created automatically at NGINX Plus installation.

To enable a dynamic module:

1. In the `main` (top-level) context in **/etc/nginx/nginx.conf**, add a [load_module](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive for each dynamically loadable module you installed.

   ```nginx
   load_module modules/<MODULE-NAME>.so;
   ```

1. Check the new configuration for syntactic validity and reload NGINX Plus.

   ```shell
   nginx -t && nginx -s reload
   ```

## NGINX Plus Unprivileged Installation {#unpriv_install}

In some environments, access to the root account is restricted for security reasons. On Linux systems, this limitation prevents the use of package managers to install NGINX Plus without root privileges.

As a workaround, in such environments NGINX Plus can be installed with a special script that modifies NGINX Plus configuration file to allow it to run from a non-root user. This script performs the following actions:

- Downloads the NGINX Plus packages

- Extracts the content of the archives into a user-defined directory of the packages

- Updates the paths in the NGINX configuration file to use relative paths in the specified directory

- Makes a backup copy of the configuration directory

- Provides an option to upgrade an existing unprivileged installation of NGINX Plus

Comparing to a standard installation of NGINX Plus, an unprivileged installation has certain limitations and restrictions:

- Root privileges are still required in order to listen on ports below `1024`.

- The script is not intended to replace your operating system's package manager and does not allow for the installation of any software other than NGINX Plus and its modules. Modifications to the script for other installations are not covered by the support program.

- NGINX Plus will not start automatically, so, you must add a custom `init` script or a `systemd` unit file for each unprivileged installation on the host.

- all dependencies and libraries required by the NGINX Plus binary and its modules are not installed automatically and should be checked and installed manually.

The script can be run on the following operating systems:

- RedHat, CentOS
- Amazon Linux 2
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

1. Download NGINX Plus and its module packages for your operating system. The `<cert_file>` and `<key_file>` are your NGINX Plus certificate and a private key required to access the NGINX Plus repo:

   ```shell
   ./ngxunprivinst.sh fetch -c <cert_file> -k <key_file>
   ```

   If you need to install a particular version of NGINX Plus:

   - first, list all available NGINX Plus versions from the repository:

       ```shell
       ./ngxunprivinst.sh list -c <cert_file> -k <key_file>
       ```

   - then specify a particular NGINX Plus version with the `-v` parameter:

       ```shell
       ./ngxunprivinst.sh fetch -c <cert_file> -k <key_file> -v <version>
       ```

1. Extract the downloaded packages to the program prefix `<path>` specified by the `-p` parameter and specify the **license.jwt** `<license_file>` with the `-j` parameter. The optional `-y` parameter allows overwriting an existing installation:

   ```shell
   ./ngxunprivinst.sh install [-y] -p <path> -j <license_file> <file1.rpm> <file2.rpm>
   ```

1. When the installation procedure is finished, run NGINX Plus. The `-p` parameter sets a path to the directory that keeps nginx files. The `-c` parameter sets a path to an alternative NGINX configuration file. Please note NGINX Plus must listen on ports above `1024`:

   ```shell
   <path>/usr/sbin/nginx -p <path>/etc/nginx -c <path>/etc/nginx/conf.d
   ```

With this script, you can also upgrade an existing unprivileged installation of NGINX Plus in the provided `<path>`. The optional `-y` parameter performs a forced upgrade without any confirmation:

```shell
./ngxunprivinst.sh upgrade [-y] -p <path> <file1.rpm> <file2.rpm>
```

## NGINX Plus Offline Installation {#offline_install}

This section explains how to install NGINX Plus and its [dynamic modules]({{< relref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) on a server with limited or no Internet access.

To install NGINX Plus offline, you will need a machine connected to the Internet to get the NGINX Plus package, JWT license, SSL certificate and key. Then your can transfer these files to the target server for offline installation.

### Step 1: Obtaining files on the machine connected to the Internet {#offline-obtain-files}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. Transfer the files to the target server that doesn't have online access and where NGINX Plus will be installed.

### Step 2: Installing NGINX Plus on a server without Internet connectivity

1. {{< include "nginx-plus/install/back-up-config-and-logs.md" >}}

1. Make sure you’ve downloaded the SSL certificate, private key, and the JWT file required for your NGINX Plus subscription. You can find these files in the MyF5 Customer Portal. For details on how to obtain these files, see [Step 1: Obtaining files on the machine connected to the Internet](#offline-obtain-files).

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. Install the NGINX Plus package or a dynamic module. Any older NGINX Plus package is automatically replaced.

    - **For RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux and Rocky Linux**:

         ```shell
         sudo rpm -ihv <rpm_package_name>
         ```

    - **For Debian, Ubuntu**:

         ```shell
         sudo dpkg -i <deb_package_name>
         ```

    - **For Alpine**:

         ```shell
         apk add <apk_package_name>
         ```

    - **For SLES**:

         ```shell
         rpm -ivh <rpm_package_name>
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

## Upgrade NGINX Plus {#upgrade}

{{< note >}} Starting from [Release 24]({{< ref "nginx/releases.md#r24" >}}) (R24), NGINX Plus repositories have been separated into individual repositories based on operating system distribution and license subscription. Before upgrading from previous NGINX Plus versions, you must first reconfigure your repositories to point to the correct location. To reconfigure your repository, follow the installation instructions above for your operating system. {{< /note >}}

To upgrade your NGINX Plus installation to the newest version:

1. If your system has previous NGINX or NGINX Plus packages on it, back up the configuration and log files.

   - **For Linux distributions**:

     ```shell
     sudo cp -a /etc/nginx /etc/nginx-plus-backup
     sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
     ```

   - **For FreeBSD**:

      ```shell
      sudo cp -a /usr/local/etc/nginx /usr/local/etc/nginx-plus-backup
      sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
      ```

1. Get the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

   {{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

   {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

1. Create the **/etc/nginx/** directory for Linux or the **/usr/local/etc/nginx** directory for FreeBSD:

    - **For Linux**:
    
        ```shell
        sudo mkdir -p /etc/nginx
        ```

    - **For FreeBSD**:
    
        ```shell
        sudo mkdir -p /usr/local/etc/nginx
        ```

    {{<call-out "note" "Using custom paths" "" >}}{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}{{</call-out>}}

1. After downloading the JWT file, copy it to the **/etc/nginx/** directory for Linux, or to the **/usr/local/etc/nginx** directory for FreeBSD, and make sure it's named **license.jwt**:

    - **For Linux**:
    
        ```shell
        sudo cp <downloaded-file-name>.jwt /etc/nginx/license.jwt
        ```

    - **For FreeBSD**:

        ```shell
        sudo cp <downloaded-file-name>.jwt /usr/local/etc/nginx/license.jwt
        ```

2. Upgrade to the new NGINX Plus package.

   - **For RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux and Rocky Linux**:

        ```shell
        sudo yum upgrade nginx-plus
        ```

   - **For Debian and Ubuntu**:

        ```shell
        sudo apt update
        sudo apt install nginx-plus
        ```

   - **For FreeBSD**:

        ```shell
        sudo pkg upgrade nginx-plus
        ```

3. Configure NGINX Plus usage reporting which is mandatory starting from R33. By default, no configuration is required. However, configuration is required in specific scenarios, such as NGINX Plus is installed in an offline environment or if the JWT license file is located in a non-default directory.

   For offline environments, usage reporting should be configured for NGINX Instance Manager 2.18 or later. In the `nginx.conf` configuration file, specify the following directives:

   - the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) context handles NGINX Plus licensing and usage reporting configuration,

   - the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive specifies the domain name or IP address of the NGINX Instance Manager,

   - the [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive enables a 180-day grace period for sending the initial usage report. The initial usage report must be received by F5 licensing endpoint within this grace period. If the report is not received in time, traffic processing will be stopped:

   ```nginx
   mgmt {
       usage_report endpoint=NIM_FQDN;
       enforce_initial_report off;
   }
   ```

   {{< include "nginx-plus/install/nim-disconnected-report-usage.md" >}}

   If the JWT license file is located in a directory other than **/etc/nginx/** for Linux or **usr/local/etc/nginx/** for FreeBSD, you must specify its name and path in the [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token) directive:

   ```nginx
   mgmt {
       license_token custom/file/path/license.jwt;
   }
   ```

   For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

4. To verify that the new NGINX Plus version is upgraded, run:

   ```shell
   nginx -v
   ```

   The output of the command:

   ```shell
   nginx version: nginx/1.27.2 (nginx-plus-r33)
   ```

## Upgrade NGINX Plus Modules {#upgrade_modules}

The upgrade procedure depends on how the module was supplied and installed.

- NGINX‑authored and NGINX‑certified community dynamic modules are updated automatically together with NGINX Plus.

  {{< note >}} For FreeBSD, each NGINX‑authored and NGINX‑certified module must be updated separately using FreeBSD package management tool. {{< /note >}}

- Community dynamic modules must be recompiled against the corresponding NGINX Open Source  version. See [Installing NGINX Community Modules](#install_modules_oss).

## Explore Related Topics

### Install NGINX App Protect

To install NGINX App Protect, follow the steps in the [NGINX App Protect installation guide]({{< relref "nap-waf/v5/admin-guide/install.md" >}}).
