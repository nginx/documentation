---
description: Install and upgrade F5 NGINX Plus with step-by-step instructions for
  the base package and dynamic modules on all supported Linux distributions.
nd-docs: DOCS-414
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
- A [supported operating system]({{< ref "nginx/technical-specs.md" >}})
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
        sudo apt update && \
        sudo apt install apt-transport-https \
                         lsb-release \
                         ca-certificates \
                         wget \
                         gnupg2 \
                         debian-archive-keyring
        ```

    - **For Ubuntu**:

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

NGINX Plus functionality can be extended with dynamically loadable modules. They can be added or updated independently of the core binary, enabling powerful capabilities such as advanced security, traffic shaping, telemetry, embedded scripting, geolocation, and many more.

Dynamic modules are shared object files (`.so`) that can be loaded at runtime using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the NGINX configuration.

 ### Types of dynamic modules

{{< bootstrap-table "table table-striped table-bordered" >}}
| Type                    | Description        | Distribution Method   | F5 NGINX Support|
|-------------------------|--------------------|-----------------------|-----------------|
| [NGINX-authored](#nginx-authored-dynamic-modules) | Developed and distributed by NGINX | Packaged binaries from `nginx-plus` official repo | Full support |
| [NGINX-certified Community](#nginx-certified-community-dynamic-modules) | Tested and distributed by NGINX | Packaged binaries from `nginx-plus` official repo | Installation and basic configuration support |
| [NGINX Certified Partner](#nginx-certified-partner-dynamic-modules) | Partner-built modules verified through [NGINX’s certification](https://www.f5.com/go/partner/nginx-certified-module-program-documentation) | Provided by partners | Provided by partners |
| [Community](#community-dynamic-modules) | Developed and distributed by third‑party contributors | [Self-compiled](#install_modules_oss) | No support|
{{< /bootstrap-table >}}

 ### NGINX-authored dynamic modules

NGINX-authored dynamic modules are developed and officially maintained by the F5 NGINX team. These modules are available as packaged binaries for various operating systems and can be installed [from the `nginx-plus` repository](#install-from-official-repository).

{{< bootstrap-table "table table-striped table-bordered" >}}
| Name                            | Description                       | Package name       |
|---------------------------------|-----------------------------------|--------------------|
| [ACME](https://github.com/nginx/nginx-acme) | Automatic certificate management ([ACMEv2](https://www.rfc-editor.org/rfc/rfc8555.html)) protocol support. | [`nginx-plus-module-acme`]({{< ref "nginx/admin-guide/dynamic-modules/acme.md" >}}) |
| [GeoIP](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) | Enables IP-based geolocation using the precompiled MaxMind databases. | [`nginx-plus-module-geoip`]({{< ref "nginx/admin-guide/dynamic-modules/geoip.md" >}}) |
| [Image-Filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) | Adds on-the-fly support for JPEG, GIF, PNG, and WebP image resizing and cropping. | [`nginx-plus-module-image-filter`]({{< ref "nginx/admin-guide/dynamic-modules/image-filter.md" >}})                   |
| [njs Scripting Language](https://nginx.org/en/docs/njs/) | Adds JavaScript-like scripting for advanced server-side logic in NGINX configuration file. | [`nginx-plus-module-njs`]({{< ref "nginx/admin-guide/dynamic-modules/nginscript.md" >}}) |
| [OpenTelemetry](https://github.com/nginxinc/nginx-otel) | Adds distributed tracing support via OpenTelemetry. | [`nginx-plus-module-otel`]({{< ref "nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) |
| [Perl](https://nginx.org/en/docs/http/ngx_http_perl_module.html)| Integrates Perl scripting for advanced customization. | [`nginx-plus-module-perl`]({{< ref "nginx/admin-guide/dynamic-modules/perl.md" >}}) |
| [XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) | Applies XSLT transformations to XML responses. | [`nginx-plus-module-xslt`]({{< ref "nginx/admin-guide/dynamic-modules/xslt.md" >}}) |
{{< /bootstrap-table >}}

 ### NGINX-certified community dynamic modules

NGINX-certified community dynamic modules are popular third‑party modules tested and distributed by F5 NGINX, with installation and basic configuration support provided. They are also distributed as precompiled packages for various operating systems and can be installed [from the `nginx-plus` repository](#install-from-official-repository).

{{< bootstrap-table "table table-striped table-bordered" >}}
| Name                            | Description                       | Package name     |
|---------------------------------|-----------------------------------|--------------------|
| [Brotli](https://github.com/google/ngx_brotli) | Brotli compression support with modules for dynamic compression and for serving pre-compressed `.br` files. | [`nginx-plus-module-brotli`]({{< ref "nginx/admin-guide/dynamic-modules/brotli.md" >}}) |
| [Encrypted-Session](https://github.com/openresty/encrypted-session-nginx-module) | AES-256 based encryption/decryption of NGINX variables. | [`nginx-plus-module-encrypted-session`]({{< ref "nginx/admin-guide/dynamic-modules/encrypted-session.md" >}}) |
| [FIPS Status Check](https://github.com/ogarrett/nginx-fips-check-module) | Verifies if OpenSSL is operating in FIPS mode. | [`nginx-plus-module-fips-check`]({{< ref "nginx/admin-guide/dynamic-modules/fips.md" >}})|
| [GeoIP2](https://github.com/leev/ngx_http_geoip2_module)  | Uses MaxMind GeoIP2 for enhanced geolocation. | [`nginx-plus-module-geoip2`]({{< ref "nginx/admin-guide/dynamic-modules/geoip2.md" >}})|
| [Headers-More](https://github.com/openresty/headers-more-nginx-module) | Extends the NGINX [Headers](https://nginx.org/en/docs/http/ngx_http_headers_module.html) module to modify request and response headers. | [`nginx-plus-module-headers-more`]({{< ref "nginx/admin-guide/dynamic-modules/headers-more.md" >}}) |
| [HTTP Substitutions Filter](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) | Enables regex and string-based substitutions in response bodies. | [`nginx-plus-module-subs-filter`]({{< ref "nginx/admin-guide/dynamic-modules/http-substitutions-filter.md" >}}) |
| [Lua](https://github.com/openresty/lua-nginx-module) | Embeds Lua programming language. | [`nginx-plus-module-lua`]({{< ref "nginx/admin-guide/dynamic-modules/lua.md" >}})|
| [NGINX Developer Kit](https://github.com/vision5/ngx_devel_kit) | Provides helper macros for module development. | [`nginx-plus-module-ndk`]({{< ref "nginx/admin-guide/dynamic-modules/ndk.md" >}}) |
| [Phusion Passenger](https://www.phusionpassenger.com/library/install/nginx/) | Application server for Node.js, Python, Ruby. | [`nginx-plus-module-passenger`]({{< ref "nginx/admin-guide/dynamic-modules/passenger-open-source.md" >}}) |
| [Prometheus-njs](https://github.com/nginx/nginx-prometheus-exporter) | Converts [NGINX Plus metrics](https://demo.nginx.com/swagger-ui/) into Prometheus format. | [`nginx-plus-module-prometheus`]({{< ref "nginx/admin-guide/dynamic-modules/prometheus-njs.md" >}}) |
| [RTMP](https://github.com/arut/nginx-rtmp-module) | Adds streaming capabilities (RTMP, HLS, MPEG-DASH, FFmpeg support).| [`nginx-plus-module-rtmp`]({{< ref "nginx/admin-guide/dynamic-modules/rtmp.md" >}}) |
| [Set-Misc](https://github.com/openresty/set-misc-nginx-module) | Adds `set_*` directives for scripting (extend NGINX [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module). | [`nginx-plus-module-set-misc`]({{< ref "nginx/admin-guide/dynamic-modules/set-misc.md" >}}) |
| [SPNEGO for Kerberos](https://github.com/stnoonan/spnego-http-auth-nginx-module) | Adds support for [GSS‑API based](https://www.rfc-editor.org/rfc/rfc2743) SPNEGO/Kerberos authentication. | [`nginx-plus-module-auth-spnego`]({{< ref "nginx/admin-guide/dynamic-modules/spnego.md" >}}) |
{{< /bootstrap-table >}}

### Install from official repository
[NGINX‑authored](#nginx-authored-dynamic-modules) and [NGINX‑certified community](#nginx-certified-community-dynamic-modules) dynamic modules can be installed as packaged binaries directly from the official `nginx-plus` repository.

To install a binary package, run the command in a terminal that corresponds to your operating system, replacing `<MODULE-NAME>` with the actual binary package name, for example, `nginx-plus-module-njs`.

- For RHEL, Amazon Linux 2, CentOS, Oracle Linux:

  ```shell
  sudo yum update && \
  sudo yum install <MODULE-NAME>
  ```
  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Amazon Linux 2023,  AlmaLinux and Rocky Linux:

  ```shell
  sudo dnf update && \
  sudo dnf install <MODULE-NAME>
  ```
  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Debian and Ubuntu:

  ```shell
  sudo apt update && \
  sudo apt install <MODULE-NAME>
  ```
  The resulting  `.so` file will be installed to: `/usr/lib/nginx/modules`

- For FreeBSD:

  ```shell
  sudo pkg update && \
  sudo pkg install <MODULE-NAME>
  ```
  The resulting  `.so` file will be installed to: `/usr/local/etc/nginx/modules`

- For SUSE Linux Enterprise:

  ```shell
  sudo zypper refresh && \
  sudo zypper install <MODULE-NAME>
  ```
  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Alpine Linux:

  ```shell
  sudo apk update && \
  sudo apk add <MODULE-NAME>
  ```
  The resulting  `.so` file will be installed to: `/usr/lib/nginx/modules`

For detailed description and installation steps for each dynamic module, see [NGINX Plus Dynamic Modules]({{< ref "nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}).

Some modules may not be available on specific operating systems due to platform-level limitations. For detailed modules compatibility, see the [Dynamic Modules]({{< ref "nginx/technical-specs.md#dynamic-modules" >}}) section of the [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}}).

After installing the module, you will need to:

- enable it with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive
- configure it according to the module's documentation

### Enabling Dynamic Modules {#enable_dynamic}

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
   load_module modules/<MODULE-NAME-1>.so;
   load_module modules/<MODULE-NAME-2>.so;

   http {
       #...
   }

   stream {
       #...
   }
   ```

1. Save the changes.

1. Check the new configuration for syntactic validity:

   ```shell
   nginx -t
   ```

1. Reload the NGINX Plus configuration:

   ```shell
   nginx -s reload
   ```

   After installing the module, you will need to configure the module in the NGINX Plus configuration file. Follow the usage and setup instructions provided in the module’s official documentation.

 ### NGINX Certified Partner dynamic modules

NGINX Certified Partner dynamic modules are partner-built extensions that enhance NGINX Plus with advanced features such as security, identity and access management, device detection, application delivery, and many more. These modules are verified through [NGINX’s certification process](https://www.f5.com/go/partner/nginx-certified-module-program-documentation). Installation packages, documentation, and support are provided directly by the partners.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Name                            | Description                       | Commercial Support |
|---------------------------------|-----------------------------------|--------------------|
| [CQ botDefence](https://www.cequence.ai/contact-us/) | Simplify traffic analysis to prevent fraud and theft that may result from automated bot attacks against your public-facing web, mobile, and API-based applications. | [Support](https://www.cequence.ai/demo/) provided by [Cequence](https://www.cequence.ai) |
| [Curity Identity Server](https://developer.curity.io/) | Powerful OAuth and OpenID Connect server, used for logging in and securing millions of users, access to API and mobile apps over APIs and microservices. | [Support](https://curity.io/support/professional-services/) and docs [[1]](https://curity.io/resources/learn/nginx-phantom-token-module/), [[2]](https://curity.io/resources/learn/nginx-oauth-proxy/) provided by [Curity](https://curity.io/support/professional-services/) |
| [DeviceAtlas ](https://deviceatlas.com/deviceatlas-nginx-module) | Detect what devices users are using, including smartphones, laptops, and weareable devices, and use this data to deliver customized experiences. | [Support](https://deviceatlas.com/resources/support) and [docs](https://docs.deviceatlas.com/apis/enterprise/c/3.1.3/README.Nginx.html) provided by [DeviceAtlas](https://deviceatlas.com/resources/support) |
| [ForgeRock Policy Agent](https://backstage.forgerock.com/downloads/browse/am/featured/web-agents) | In conjunction with ForgeRock Access Management, allows you to authenticate your application and API access. | [Support](https://support.pingidentity.com/s/) and [docs](https://backstage.forgerock.com/docs/openam-web-policy-agents/2023.9/installation-guide/install-nginx.html) provided by [PingIdentity](https://www.pingidentity.com) |
| [HUMAN Security for F5 NGINX](https://www.humansecurity.com/contact-us/) | Provides the required enforcement layer to protect websites and apps from modern automated security threats. | Support provided by [HUMAN Security](https://www.humansecurity.com/) |
| [IDFConnect SSO/Rest](http://www.idfconnect.com/about/contact/) | Integrates your web access management platform's full capabilities with NIGNX Plus. | [Support](http://www.idfconnect.com/about/contact/) and [docs](https://www.idfconnect.com/nginx-ssorest-plugin/) provided by [IDFConnect](http://www.idfconnect.com) |
| [OPSWAT](https://www.f5.com/go/product/nginx-modules/opswat) | Scalable solutions to protect your networks and applications from malware and unknown (zero-day) malicious file content. | [Support](https://www.opswat.com/support) and [docs](https://www.opswat.com/docs/mdicap/integrations/nginx-integration-module) provided by [OPSWAT](https://www.opswat.com/) |
| [Passenger Enterprise](https://www.phusionpassenger.com/features) | An application server with support for Meteor, Node.js, Python, and Ruby apps. | [Support](https://www.phusionpassenger.com/support) and [docs](https://www.phusionpassenger.com/docs/advanced_guides/install_and_upgrade/nginx/install_as_nginx_module.html) provided by [Phusion](https://www.phusionpassenger.com/) |
| [Ping Access](https://support.pingidentity.com/s/marketplace-integration/a7i1W0000004ICRQA2/pingaccess-agent-for-nginx-plus) | Centralized management of access security with advanced contextual policies to secure your mobile and web properties in any domain. | [Support](https://support.pingidentity.com/s/) and [docs](https://docs.pingidentity.com/pingaccess/latest/agents_and_integrations/pa_agent_for_nginx.html) provided by [PingIdentity](https://www.pingidentity.com) |
| [PingIntelligence](https://hub.pingidentity.com/datasheets/3742-pingintelligence-apis) | A complete solution to secure an organization's API across on-premises, public and private clouds, and hybrid IT environments. | [Support](https://support.pingidentity.com/s/) and [docs](https://docs.pingidentity.com/pingintelligence/5.1/pingintelligence_integrations/pingintelligence_nginx_plus_integration.html) provided by [PingIdentity](https://www.pingidentity.com) |
| [Seer Box by Plurbius One](https://seerbox.it/en/) | Cloud-native web application security manager which provides thorough monitoring and protection capabilities. | Support provided by [Seer Box](https://support.seerbox.it/) |
| [Signal Sciences](https://docs.fastly.com/en/ngwaf/about-the-nginx-module) | Intelligently detects malicious requests and blocks them without false positives, while the patented fail-open architecture allows legitimate requests through. | [Support](https://support.fastly.com/s/) and [docs](https://docs.fastly.com/en/ngwaf/installing-the-nginx-dynamic-module) provided by [Fastly](https://www.fastly.com/)|
| [Wallarm](https://docs.wallarm.com/updating-migrating/nginx-modules/) | The Wallarm WAF provides enterprise-grade protection against advanced Layer 7 application attacks. | [Support](https://www.wallarm.com/support) and [docs](https://docs.wallarm.com/installation/nginx/all-in-one/) provided by [Wallarm](https://wallarm.com/) |
| [WURFL InFuse](https://www.scientiamobile.com/secondary-products/wurfl-infuze-module-for-nginx-plus/) | Give developers the most advanced, accurate, and high-performance device detection in the industry. | [Support](https://www.scientiamobile.com/support/) and [docs](https://docs.scientiamobile.com/documentation/infuze/infuze-nginx-plus-module-user-guide) provided by [Scientiamobile](https://www.scientiamobile.com/) |
| [51Degrees Device Detection](https://github.com/51Degrees/device-detection-nginx) | Improve speed of response and accuracy, delivering an optimal user experience and high-fidelity analysis. | [Support](https://51degrees.com/pricing/index) and [docs](https://github.com/51Degrees/device-detection-nginx/blob/main/README.md) provided by [51Degrees](https://51degrees.com/about-us) |
{{< /bootstrap-table >}}

The complete list of Certified Partner Modules can be found on the [F5.com Dynamic Modules](https://www.f5.com/go/product/nginx-modules?filter=module-author%3Anginx-certified-partner) page.

 ### Community dynamic modules

Community dynamic modules are open source extensions developed and distributed by third‑party contributors of the NGINX community.

These modules are not available in the official NGINX repository. To use them, you must download the source code from the module's repository and [compile it against the NGINX Open Source version](#install_modules_oss) that matches your NGINX Plus version.

The lists of community modules can be found across different community-driven resources, for example, [Awesome NGINX GitHub project](https://github.com/agile6v/awesome-nginx#third-party-modules).

### Installing a community dynamic module {#install_modules_oss}

For a community dynamic module to work with NGINX Plus, it must be compiled alongside the corresponding version of NGINX Open Source.

1. Find out the NGINX Open Source version that matches your NGINX Plus version. In a terminal, run the command:

   ```shell
   nginx -v
   ```
   Expected output of the command:

   ```shell
   nginx version: nginx/1.29.0 (nginx-plus-r35)
   ```

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
     sudo apt update && \
     sudo apt install gcc make libpcre3-dev zlib1g-dev
     ```

   - For CentOS, Oracle Linux, and RHEL:

     ```shell
     sudo yum update && \
     sudo yum install gcc make pcre-devel zlib-devel
     ```

1. Obtain NGINX Open Source.

   - Identify the NGINX Open Source version that corresponds to your version of NGINX Plus. See [NGINX Plus Releases]({{< ref "nginx/releases.md" >}}).

   - Download the sources for the appropriate NGINX Open Source mainline version, in this case 1.29.0:

     ```shell
     wget -qO - https://nginx.org/download/nginx-1.29.0.tar.gz | tar zxfv -
     ```

1. Obtain the source for the dynamic module.

   The source code for the dynamic module can be placed in any directory in the build environment. As an example, here we're copying the [NGINX “Hello World” module](https://github.com/perusio/nginx-hello-world-module.git/) from GitHub:

   ```shell
   git clone https://github.com/perusio/nginx-hello-world-module.git
   ```

1. Compile the dynamic module.

   First, establish binary compatibility by running the `configure` script with the `‑‑with‑compat` option. Then compile the module with `make modules`.

   ```shell
   cd nginx-1.29.0/ && \
   ./configure --with-compat --add-dynamic-module=../<MODULE-SOURCES> && \
   make modules
   ```

   The **.so** file generated by the build process is placed in the **objs** subdirectory:

   ```shell
   ls objs/*.so
   ```

   Expected command output:
   ```shell
   objs/ngx_http_hello_world_module.so
   ```

1. Make a copy of the module file and include the NGINX Open Source version in the filename. This makes it simpler to manage multiple versions of a dynamic module in the production environment.

   ```shell
   cp objs/ngx_http_hello_world_module.so ./ngx_http_hello_world_module_1.29.0.so
   ```

1. Transfer the resulting `.so` file from your build environment to the production environment.

1. In your production environment, copy the resulting `.so` file to the dynamic modules directory. The path to the directory depends on your operating system:

   - `/usr/lib64/nginx/modules/` for most Linux operating systems
   - `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
   - `/usr/local/etc/nginx/modules` for FreeBSD

   ```shell
   sudo cp ngx_http_hello_world_module_1.29.0.so /usr/local/nginx/modules/ngx_http_hello_world_module_1.29.0.so
   ```

After installing the module, you need to enable it in the NGINX Plus configuration file. For more information, see [Enabling Dynamic Modules](#enable_dynamic).

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

{{< call-out "note" >}} Starting from [Release 24]({{< ref "nginx/releases.md#r24" >}}) (R24), NGINX Plus repositories have been separated into individual repositories based on operating system distribution and license subscription. Before upgrading from previous NGINX Plus versions, you must first reconfigure your repositories to point to the correct location. To reconfigure your repository, follow the installation instructions above for your operating system. {{< /call-out >}}

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

   {{< call-out "note" >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /call-out >}}

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
   nginx version: nginx/1.29.0 (nginx-plus-r35)
   ```

## Upgrade NGINX Plus Modules {#upgrade_modules}

The upgrade procedure depends on how the module was supplied and installed.

- [NGINX‑authored](#nginx-authored-dynamic-modules) and [NGINX‑certified community](#nginx-certified-community-dynamic-modules) dynamic modules are updated automatically together with NGINX Plus.

  {{< call-out "note" >}} For FreeBSD, each NGINX‑authored and NGINX‑certified module must be updated separately using FreeBSD package management tool. {{< /call-out >}}

- [Community](#community-dynamic-modules) dynamic modules must be recompiled against the corresponding NGINX Open Source  version. See [Installing NGINX Community Modules](#install_modules_oss).

## Explore Related Topics

### Install NGINX App Protect

To install NGINX App Protect, follow the steps in the [NGINX App Protect installation guide]({{< ref "nap-waf/v5/admin-guide/install.md" >}}).
