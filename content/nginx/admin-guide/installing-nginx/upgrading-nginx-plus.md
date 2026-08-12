---
title: Upgrading NGINX Plus
description: Upgrade F5 NGINX Plus with step-by-step instructions for
  the base package and dynamic modules on all supported Linux distributions.
toc: true
weight: 150
nd-content-type: how-to
f5-product: F5 NGINX Plus
f5-docs: DOCS-000
---

This article explains how to upgrade existing NGINX Plus installation and dynamic modules.

## About {#upgrade}

Keeping your NGINX Plus installation updated ensures it includes the latest features, security patches, and fixes. Critical bug patches and security updates are provided for the **two** most recent releases of NGINX Plus. Each NGINX Plus release reaches End of Software Development upon the next version's release, meaning no new features or routine bug fixes will be added to that version.

## Prerequisites

Before upgrading, verify the following:

1. Your operating system is configured to retrieve binary packages from the official NGINX Plus repository: ensure that `nginx-plus.crt` and `nginx-plus.key` and repository file are set. See installation instructions for your operating system: [Amazon Linux 2023]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_amazon2023" >}}), [Amazon Linux 2]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_amazon2" >}}), [RHEL-based 8.1]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_rhel8" >}}), [RHEL-based 9]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_rhel" >}}), [RHEL-based 10]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_rhel10" >}}), [Debian]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_debian" >}}), [Ubuntu]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_debian_ubuntu" >}}), [FreeBSD]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_freebsd" >}}), [SLES]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_suse" >}}), [Alpine]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_alpine" >}}).

2. Your NGINX Plus subscription is active. You can verify your subscription on the [MyF5 Customer Portal](https://account.f5.com/myf5).

3. For NGINX Plus R33 and later, [license reporting]({{< ref "/solutions/about-subscription-licenses/getting-started.md">}}) is configured. If upgrading from R32 or earlier, add the license file before upgrading and configure usage reporting. See [NGINX Plus R32 upgrade note](#nginx-plus-r32-and-earlier).

## Upgrade steps

1. Back up the configuration and log files.

   - For **Linux**:

     ```shell
     sudo cp -a /etc/nginx /etc/nginx-plus-backup && \
     sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
     ```

   - For **FreeBSD**:

      ```shell
      sudo cp -a /usr/local/etc/nginx /usr/local/etc/nginx-plus-backup && \
      sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
      ```

2. Upgrade to the newest NGINX Plus package.

   - For **RHEL-based**:

        ```shell
        sudo yum upgrade nginx-plus
        ```

   - For **Debian** and **Ubuntu**:

        ```shell
        sudo apt update && \
        sudo apt install nginx-plus
        ```

   - For **FreeBSD**:

        ```shell
        sudo pkg upgrade nginx-plus
        ```

3. Verify the upgrade:

   - Check the NGINX Plus version:

     ```shell
     nginx -v
     ```

     The output of the command:

     ```shell
     nginx version: nginx/1.29.8 (nginx-plus-r37.0.0)
     ```

   - Check the error log:

     ```shell
     tail /var/log/nginx/error.log
     ```

## Upgrade notes

### NGINX Plus R24 and earlier

Starting from [Release 24]({{< ref "nginx/releases.md#r24" >}}) (R24), NGINX Plus repositories have been separated into individual repositories based on operating system distribution and license subscription. Before upgrading from NGINX Plus R24 and earlier versions, you must first reconfigure your repositories to point to the correct location. To reconfigure your repository, follow the installation instructions above for your operating system: [Amazon Linux 2023](#install_amazon2023), [Amazon Linux 2](#install_amazon2), [RHEL-based 8.1](#install_rhel8), [RHEL-based 9](#install_rhel), [Debian or Ubuntu](#install_debian_ubuntu), [FreeBSD](#install_freebsd), [SLES](#install_suse).

### NGINX Plus R32 and earlier

Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT license file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

1. Get the JWT file associated with your NGINX Plus subscription from the [MyF5 Customer Portal](https://account.f5.com/myf5):

   {{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

2. Create the **/etc/nginx/** directory for Linux or the **/usr/local/etc/nginx** directory for FreeBSD:

   - For **Linux**:

       ```shell
       sudo mkdir -p /etc/nginx
       ```

   - For **FreeBSD**:

       ```shell
       sudo mkdir -p /usr/local/etc/nginx
       ```

    {{<call-out class="note" title="Using custom paths" >}}{{< include "licensing-and-reporting/custom-paths-jwt.md" >}}{{</call-out>}}

3. After downloading the JWT file, copy it to the **/etc/nginx/** directory for Linux, or to the **/usr/local/etc/nginx** directory for FreeBSD, and make sure it's named **license.jwt**:

   - For **Linux**:

     ```shell
     sudo cp <downloaded-file-name>.jwt /etc/nginx/license.jwt
     ```

   - For **FreeBSD**:

     ```shell
     sudo cp <downloaded-file-name>.jwt /usr/local/etc/nginx/license.jwt
     ```

4. Perform an upgrade.

5. After upgrade, it is possibly necessary to configure NGINX Plus usage reporting. By default, no configuration is required. However, if NGINX Plus is installed in an [offline environment](#offline_install) or if the JWT license file is located in a non-default directory, extra configuration is required.

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

## Upgrade NGINX Plus modules {#upgrade_modules}

The upgrade procedure depends on how the module was supplied and installed.

- [NGINX‑authored]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-authored-dynamic-modules" >}}) and [NGINX‑certified community]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-certified-community-dynamic-modules" >}}) dynamic modules are updated automatically together with NGINX Plus.

  {{< call-out class="note" >}} For FreeBSD, each NGINX‑authored and NGINX‑certified module must be updated separately using FreeBSD package management tool. {{< /call-out >}}

- [Community]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#community-dynamic-modules" >}}) dynamic modules must be recompiled against the corresponding NGINX Open Source  version. See [Installing NGINX Community Modules]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_modules_oss" >}}).
