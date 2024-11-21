---
description: Install and upgrade F5 NGINX Plus with step-by-step instructions for the
  base package and dynamic modules on all supported Linux distributions.
docs: DOCS-414
doctypes:
- task
title: Installing NGINX Plus
toc: true
weight: 100
---

This article explains how to install NGINX Plus on different operating systems, upgrade existing NGINX Plus installation, install and enable dynamic modules, install in rootless mode or when offline.

<span id="prereq"></span>
## Prerequisites

- An NGINX Plus subscription (purchased or trial)
- Credentials to the [MyF5 Customer Portal](https://account.f5.com/myf5), provided by email from F5, Inc.
- A [supported operating system]({{< relref "../../technical-specs.md" >}})
- `root` privilege



<span id="install_amazon2023"></span>
## Installing NGINX Plus on Amazon Linux 2023

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).
 
2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more details, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

6.  Install the **ca-certificates** dependency:

    ```shell
    sudo dnf update
    sudo dnf install ca-certificates
    ```

7.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

8.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

9.  Add the NGINX Plus repository to your Amazon Linux 2023 instance. Download the [plus-amazonlinux2023.repo](https://cs.nginx.com/static/files/plus-amazonlinux2023.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
    ```

10. Install the **nginx-plus** package. Any older NGINX Plus package will be automatically replaced.

    ```shell
    sudo dnf install nginx-plus
    ```

11. Check the `nginx` binary version to confirm that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

12. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

13. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_amazon2"></span>
## Installing NGINX Plus on Amazon Linux 2

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).

2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), the JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

6.  Install the **ca-certificates** dependency:

    ```shell
    sudo yum update
    sudo yum install ca-certificates
    ```

7.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

8.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/

9.  Add the NGINX Plus repository to your Amazon Linux 2 instance. Download the [nginx-plus-amazon2.repo](https://cs.nginx.com/static/files/nginx-plus-amazon2.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo
    ```

10. Install the **nginx-plus** package. Any older NGINX Plus package will be automatically replaced.

    ```shell
    sudo yum install nginx-plus
    ```

11. Check the `nginx` binary version to confirm that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

12. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

13.  If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_rhel_centos"></span>
## Installing NGINX Plus on RHEL 7.4+, CentOS RHEL 7.4+, and Oracle Linux 7.4+

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).

2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

3. Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal.

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

6.  Install the **ca-certificates** dependency:

    ```shell
    sudo yum update
    sudo yum install ca-certificates
    ```

7.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

8.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

9.  Add the NGINX Plus repository by downloading the [nginx-plus-7.4.repo](https://cs.nginx.com/static/files/nginx-plus-7.4.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

10. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo yum install nginx-plus
    ```

11. If you have NGINX App Protect subscription:

    * install **epel-release** dependency:

    ```shell
    sudo yum install epel-release
    ```

    * add the NGINX App Protect repository by downloading the [app-protect-7.repo](https://cs.nginx.com/static/files/app-protect-7.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

    * install NGINX App Protect and its signatures:

    ```shell
    sudo yum install nginx-plus app-protect app-protect-attack-signatures
    ```

12. To enable the nginx service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

13. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

14. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

15. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_rhel8"></span>
## Installing NGINX Plus on RHEL 8.1+, Oracle Linux 8.1+, AlmaLinux 8, Rocky Linux 8

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).

2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

6.  Install the **ca-certificates** dependency:

    ```shell
    sudo dnf update
    sudo dnf install ca-certificates
    ```

7.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

8.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

9.  Add the NGINX Plus repository by downloading the [nginx-plus-8.repo](https://cs.nginx.com/static/files/nginx-plus-8.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    ```

10. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo dnf install nginx-plus
    ```

11. To enable the nginx service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

12. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

13. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

14. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_rhel9"></span>
## Installing NGINX Plus on RHEL 9.0+, Oracle Linux 9, AlmaLinux 9, Rocky Linux 9

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).
 
2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

6.  Install the **ca-certificates** dependency:

    ```shell
    sudo dnf update
    sudo dnf install ca-certificates
    ```

7.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

8.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

9.  Add the NGINX Plus repository by downloading the [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
    ```

10. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo dnf install nginx-plus
    ```

11. To enable the nginx service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

12. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

13. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

14. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_debian_ubuntu"></span>
## Installing NGINX Plus on Debian or Ubuntu

NGINX Plus can be installed on the following versions of Debian or Ubuntu:

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).
 
2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

6.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

7.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

8.  Install the prerequisites packages.

    For Debian:

    ```shell
    sudo apt update
    sudo apt install apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring
    ```

    For Ubuntu:

    ```shell
    sudo apt update
    sudo apt install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
    ```

9.  Download and add [NGINX signing key](https://cs.nginx.com/static/keys/nginx_signing.key) and [App Protect security updates signing key](https://cs.nginx.com/static/keys/app-protect-security-updates.key):

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

10. Add the NGINX Plus repository.

    For Debian:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

    For Ubuntu:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

11. If you have NGINX App Protect subscription, add its repositories.

    For Debian:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nginx-app-protect.list
    ```

    For Ubuntu:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nginx-app-protect.list
    ```

12. Download the **nginx-plus** apt configuration to **/etc/apt/apt.conf.d**:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

13. Update the repository information:

    ```shell
    sudo apt update
    ```

14. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo apt install -y nginx-plus
    ```

15. If you have NGINX App Protect subscription, install NGINX App Protect and its signatures:

    ```shell
    sudo apt install app-protect app-protect-attack-signatures
    ```

16. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

17. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

18. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_freebsd"></span>
## Installing NGINX Plus on FreeBSD

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).
 
2.  Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see [Upgrading NGINX Plus](#upgrade).


3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/usr/local/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /usr/local/etc/nginx
    cd /usr/local/etc/nginx
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/usr/local/etc/nginx** directory:

    ```shell
    sudo cp license.jwt /usr/local/etc/nginx
    ```

6.  Install the prerequisite **ca_root_nss** package:

    ```shell
    sudo pkg update
    sudo pkg install ca_root_nss
    ```

7.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

8.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

9.  Copy the [nginx-plus.conf](https://cs.nginx.com/static/files/nginx-plus.conf) file to the **/etc/pkg/** directory:

    ```shell
    sudo fetch -o /etc/pkg/nginx-plus.conf http://cs.nginx.com/static/files/nginx-plus.conf
    ```

10. Add the following lines to the **/usr/local/etc/pkg.conf** file:

    ```none
    PKG_ENV: { SSL_NO_VERIFY_PEER: "1",
    SSL_CLIENT_CERT_FILE: "/etc/ssl/nginx/nginx-repo.crt",
    SSL_CLIENT_KEY_FILE: "/etc/ssl/nginx/nginx-repo.key" }
    ```

11. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced. Back up your NGINX Plus configuration and log files if you have an older NGINX Plus package installed. For more information, see "[Upgrading NGINX Plus](#upgrade)".

    ```shell
    sudo pkg install nginx-plus
    ```

12. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

13. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

14. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_suse"></span>
## Installing NGINX Plus on SUSE Linux Enterprise Server

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).
 
2.  If you have an older NGINX Plus package installed, it is recommended backing up the configuration and log files. For more information, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp nginx-repo.jwt /etc/nginx/
    ```

6.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

7.  Copy the downloaded **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

8.  Create a file bundle of the certificate and key:

    ```shell
    cat /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key > /etc/ssl/nginx/nginx-repo-bundle.crt
    ```

9.  Install the required **ca-certificates** dependency:

    ```shell
    zypper refresh
    zypper install ca-certificates
    ```

10. Add the **nginx-plus** repo.

    For SLES 12:

    ```shell
    zypper addrepo -G -t yum -c 'https://pkgs.nginx.com/plus/sles/12?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer' nginx-plus
    ```

    For SLES 15:

    ```shell
    zypper addrepo -G -t yum -c 'https://pkgs.nginx.com/plus/sles/15?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer' nginx-plus
    ```

11. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    zypper install nginx-plus
    ```

12. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

13. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

14. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_alpine"></span>
## Installing NGINX Plus on Alpine Linux

1.  Check if your operating system and architecture are supported. For a complete list of supported platforms and architectures, see the [Technical Specifications]({{< relref "../../technical-specs.md" >}}).
 
2.  If you have an older NGINX Plus package installed, it is recommended backing up the configuration and log files. For more information, see [Upgrading NGINX Plus](#upgrade).

3.  Get the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

    {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

    {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

4.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

5.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory.

6.  Upload **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. Please make sure that files do not contain other certificates and keys: Alpine Linux does not support mixing client certificates for different repositories.

7.  Put NGINX signing public key to directory **/etc/apk/keys**:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
    ```

8.  Add the NGINX repository to **/etc/apk/repositories** file:

    ```shell
    printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

9.  If you have NGINX App Protect subscription, add the NGINX App Protect repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

10. It is recommended to remove all community-supported NGINX packages. Please note all NGINX modules will be removed too.

    ```shell
    sudo apk del -r nginx
    ```

11. Install the NGINX Plus package:

    ```shell
    sudo apk add nginx-plus
    ```

12. If you have NGINX App Protect subscription, install NGINX App Protect and its signatures:

    ```shell
    sudo apk add app-protect app-protect-attack-signatures
    ```

13. Check the `nginx` binary version to verify that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

14. In the `nginx.conf` file, configure license reporting to F5 licensing endpoint using the
[`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html) block. By default, no configuration is required. However, it becomes necessary when your NGINX Plus instance is installed in a disconnected environment, uses NGINX Instance manager for usage reporting, or uses a custom path for the license file. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

15. If you are using [NGINX Instance Manager]({{<relref "/nms/about.md">}}) in your infrastructure, install and enable [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/). See [Install and Configure NGINX Agent](https://github.com/nginx/agent/blob/main/README.md) for details.


<span id="install_modules"></span>
## Installing Dynamically Loadable Modules

NGINX Plus functionality can be extended with dynamically loadable modules that are not included in the prebuilt packages:

- NGINX-authored dynamic modules – Modules developed and maintained by F5 NGINX. These modules can be installed directly from the official repository:
  - [GeoIP]({{< relref "../dynamic-modules/geoip.md" >}})
  - [Image-Filter]({{< relref "../dynamic-modules/image-filter.md" >}})
  - [njs Scripting Language]({{< relref "../dynamic-modules/nginscript.md" >}})
  - [OTel]({{< relref "../dynamic-modules/opentelemetry.md" >}})
  - [Perl]({{< relref "../dynamic-modules/perl.md" >}})
  - [XSLT]({{< relref "../dynamic-modules/xslt.md" >}})

- NGINX-certified community dynamic modules – Popular third‑party modules tested and distributed by F5 NGINX, with installation and basic configuration support provided. These modules are also available directly from the official repository:
  - [Brotli]({{< relref "../dynamic-modules/brotli.md" >}})
  - [Encrypted-Session]({{< relref "../dynamic-modules/encrypted-session.md" >}})
  - [FIPS Status Check]({{< relref "../dynamic-modules/fips.md" >}})
  - [GeoIP2]({{< relref "../dynamic-modules/geoip2.md" >}})
  - [Headers-More]({{< relref "../dynamic-modules/headers-more.md" >}})
  - [HTTP Substitutions Filter]({{< relref "../dynamic-modules/http-substitutions-filter.md" >}})
  - [Lua]({{< relref "../dynamic-modules/lua.md" >}})
  - [NGINX Developer Kit]({{< relref "../dynamic-modules/ndk.md" >}})
  - [OpenTelemetry]({{< relref "../dynamic-modules/opentelemetry.md" >}})
  - [OpenTracing]({{< relref "../dynamic-modules/opentracing.md" >}})
  - [Phusion Passenger]({{< relref "../dynamic-modules/passenger-open-source.md" >}})
  - [Prometheus-njs]({{< relref "../dynamic-modules/prometheus-njs.md" >}})
  - [RTMP]({{< relref "../dynamic-modules/rtmp.md" >}})
  - [Set-Misc]({{< relref "../dynamic-modules/set-misc.md" >}})
  - [SPNEGO]({{< relref "../dynamic-modules/spnego.md" >}})

- Community dynamic modules – Modules written and distributed by third‑party members of the NGINX community. To use these modules, download the source code from the author's repository and [compile it against the NGINX Open Source version](#install_modules_oss) corresponding to your NGINX Plus version. These modules are not available in the official repository but can be found in different community resources such as [awesome-nginx GitHub project](https://github.com/agile6v/awesome-nginx#third-party-modules).

<span id="install_modules_plus"></span>
### Installing Dynamic Modules from Official Repository

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

See [NGINX Plus Dynamic Modules]({{< relref "../dynamic-modules/dynamic-modules.md" >}}) for detailed installation instructions for each dynamic module.

Note that some modules may not be available for certain OS versions because of operating system limitations. For details and descriptions of the modules, see the [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}}).

After installing the module, you need to enable it in the NGINX Plus configuration file. For more information, see [Enabling Dynamic Modules](#enable_dynamic).

<span id="install_modules_oss"></span>
### Installing NGINX Community Modules

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

2. Obtain NGINX Open Source.

   - Identify the NGINX Open Source version that corresponds to your version of NGINX Plus. See [NGINX Plus Releases]({{< relref "../../releases.md" >}}).

   - Download the sources for the appropriate NGINX Open Source mainline version, in this case 1.27.2:

     ```shell
     wget -qO - https://nginx.org/download/nginx-1.27.2.tar.gz | tar zxfv -
     ```

3. Obtain the source for the dynamic module.

   The source code for the dynamic module can be placed in any directory in the build environment. As an example, here we're copying the [NGINX “Hello World” module](https://github.com/perusio/nginx-hello-world-module.git/) from GitHub:

   ```shell
   git clone https://github.com/perusio/nginx-hello-world-module.git
   ```

4. Compile the dynamic module.

   First establish binary compatibility by running the `configure` script with the <span style="white-space: nowrap;">`‑‑with‑compat`</span> option. Then compile the module with `make modules`.

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

5. Make a copy of the module file and include the NGINX Open Source version in the filename. This makes it simpler to manage multiple versions of a dynamic module in the production environment.

   ```shell
   cp objs/ngx_http_hello_world.so ./ngx_http_hello_world_1.27.2.so
   ```

<span id="enable_dynamic"></span>
### Enabling Dynamic Modules

Dynamic modules are located in the **/etc/nginx/modules** directory, which is created automatically at NGINX Plus installation.

To enable a dynamic module:

1. In the `main` (top-level) context in **/etc/nginx/nginx.conf**, add a [load_module](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive for each dynamically loadable module you installed.

   ```nginx
   load_module modules/<MODULE-NAME>.so;
   ```

2. Check the new configuration for syntactic validity and reload NGINX Plus.

   ```shell
   nginx -t && nginx -s reload
   ```

<span id="unpriv_install"></span>
## NGINX Plus Unprivileged Installation

In some environments, access to the root account is restricted for security reasons. On Linux systems, this limitation prevents the use of package managers to install NGINX Plus without root privileges.

As a workaround, in such environments NGINX Plus can be installed with a special script that modifies NGINX Plus configuration file to allow it to run from a non-root user. This script performs the following actions:

* Downloads the NGINX Plus packages

* Extracts the content of the archives into a user-defined directory of the packages

* Updates the paths in the NGINX configuration file to use relative paths in the specified directory

* Makes a backup copy of the configuration directory

* Has an option to upgrade an existing unprivileged installation of NGINX Plus

Comparing to a standard installation of NGINX Plus, an unprivileged installation has certain limitations and restrictions:

* Root privileges are still required in order to listen on ports below `1024`.

* The script is not intended to replace your operating system's package manager and does not allow for the installation of any software other than NGINX Plus and its modules. Modifications to the script for other installations are not covered by the support program.

* NGINX Plus will not start automatically, so, you must add custom `init` script/`systemd`unit file for each unprivileged installation on the host.

* all dependencies and libraries required by the NGINX Plus binary and its modules are not installed automatically and should be checked and installed manually.

The script can be run on the following operating systems:

- RedHat, CentOS
- Amazon Linux 2
- Amazon Linux 2023
- Debian, Ubuntu
- Alpine Linux
- AlmaLinux, Rocky Linux

Before starting the unprivileged installation, make sure you have all the prerequisites listed in the [Prerequisites](#prereq) section (excluding `root` privileges). For RPM-based distributions, verify that you have [`rpm2cpio`](https://man7.org/linux/man-pages/man8/rpm2cpio.8.html) installed.

To perform an unprivileged installation of NGINX Plus:

1. Obtain the script:

   ```shell
   wget https://raw.githubusercontent.com/nginxinc/nginx-plus-install-tools/main/ngxunprivinst.sh
   ```

2. Make the script executable:

   ```shell
   chmod +x ngxunprivinst.sh
   ```

3. Download NGINX Plus and its module packages for your operating system. The &lt;cert_file&gt;, &lt;key_file&gt; and &lt;license_file&gt; are your NGINX Plus certificate, private key, and JWT license obtained from [MyF5 Customer Portal](https://account.f5.com/myf5/):

   ```shell
   ./ngxunprivinst.sh fetch -c <cert_file> -k <key_file> -j <license_file>
   ```
   {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT license file (&lt;license_file&gt;) is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

   If you need to install a particular version of NGINX Plus:

   - first, list all available NGINX Plus versions from the repository:

   ```shell
   ./ngxunprivinst.sh list -c <cert_file> -k <key_file>
   ```

   - then specify a particular NGINX Plus version with the `-v` option:

   ```shell
   ./ngxunprivinst.sh fetch -c <cert_file> -k <key_file> -v <version>
   ```

4. Extract the downloaded packages to the provided NGINX Plus prefix &lt;path&gt; An optional `-y` option will overwrite an existing installation (if any). Starting from version R33, the `-j` option that specifies the &lt;license_file&gt; is mandatory:



   ```shell
   ./ngxunprivinst.sh install [-y] -p <path> -j <license_file> <file1.rpm> <file2.rpm>
   ```

5. When the installation procedure is finished, run NGINX Plus. The `-p` parameter sets a path to the directory that keeps nginx files. The `-c` parameter sets a path to an alternative NGINX configuration file. Please note NGINX Plus must listen on ports above `1024`:

   ```shell
   <path>/usr/sbin/nginx -p <path>/etc/nginx -c <path>/etc/nginx/conf.d
   ```

With this script, you can also upgrade an existing unprivileged installation of NGINX Plus in the provided <path>. An optional `-y` option performs a forced upgrade without any confirmation:

```shell
./ngxunprivinst.sh upgrade [-y] -p <path> <file1.rpm> <file2.rpm>
```


<span id="offline_install"></span>
## NGINX Plus Offline Installation

This section explains how to install NGINX Plus and its [dynamic modules]({{< relref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) on a server with limited or no Internet access.

To install NGINX Plus offline, you will need a machine connected to the Internet to get the NGINX Plus package, JWT license, SSL certificate and key. Then your can transfer these files to the target server for offline installation.

### Step 1: Obtaining files on the machine connected to the Internet

1. Download your SSL certificate, private key, NGINX Plus installation file, and JWT license file from [MyF5 Customer Portal](https://account.f5.com/myf5/).

   {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

   {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

2. Transfer the files to the target server that doesn't have online access and where NGINX Plus will be installed.


### Step 2: Installing NGINX Plus on a server without Internet connectivity

1.  If you have an older NGINX Plus package installed, it is recommended backing up the configuration and log files. For more information, see "[Upgrading NGINX Plus](#upgrade)".

2.  Make sure you have obtained the SSL certificate, SSL key, and the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal.

   {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

3.  Create the **/etc/nginx/** directory for the JWT license file:

    ```shell
    sudo mkdir -p /etc/nginx/
    cd /etc/nginx/
    ```

4.  Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory:

    ```shell
    sudo cp license.jwt /etc/nginx/
    ```

5.  Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

6.  Copy the downloaded SSL certificate and key files files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

7.  Install the NGINX Plus package or a dynamic module. Any older NGINX Plus package is automatically replaced.

    - for RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux and Rocky Linux:
     ```shell
     sudo rpm -ihv <rpm_package_name>
     ```

    - for Debian, Ubuntu:
     ```shell
     sudo dpkg -i <deb_package_name>
     ```

    - for Alpine:
     ```shell
     apk add <apk_package_name>
     ```

    - for SLES:
     ```shell
     rpm -ivh <rpm_package_name>
     ```

8.  Check the `nginx` binary version to confirm that NGINX Plus is installed correctly:

    ```shell
    nginx -v
    ```

9.  Install NGINX Instance Manager 2.18 or later in your local environment to enable usage reporting, which is mandatory since R33. For more information, see [Disconnected environments](https://docs.nginx.com/nginx-instance-manager/disconnected/) and [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

10. Configure usage reporting of the NGINX Plus instance to NGINX Instance Manager which is mandatory starting from R33.

    In the `nginx.conf` configuration file, specify the following directives:

    * the [`mgmt {}`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) block that handles NGINX Plus licensing and usage reporting configuration,

    * the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive that sets the domain name or IP address of NGINX Instance Manager,

    * the [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive that enables the 180-day grace period for sending the initial usage report. The initial usage report must be received by F5 licensing endpoint during the grace period, otherwise traffic processing will be stopped:

    ```nginx
    mgmt {
        usage_report endpoint=NIM_FQDN;
        enforce_initial_report off;
    }
    ```

11. In NGINX Instance Manager, prepare and send the usage report to F5 licensing endpoint. For more information, see [Report usage to F5 in a disconnected environment](https://docs.nginx.com/nginx-instance-manager/disconnected/report-usage-disconnected-deployment/).

12. Upload the usage acknowledgement to NGINX Instance Manager. For more information, see [Report usage to F5 in a disconnected environment](https://docs.nginx.com/nginx-instance-manager/disconnected/report-usage-disconnected-deployment/#submit-usage-report).


<span id="upgrade"></span>
## Upgrading NGINX Plus

{{< note >}} Starting from [Release 24]({{< ref "nginx/releases.md#r24" >}}) (R24), NGINX Plus repositories have been separated into individual repositories based on operating system distribution and license subscription. Before upgrading from previous NGINX Plus versions, you must first reconfigure your repositories to point to the correct location. To reconfigure your repository, follow the installation instructions above for your operating system. {{< /note >}}

To upgrade your NGINX Plus installation to the newest version:

1. If your system has previous NGINX or NGINX Plus packages on it, back up the configuration and log files.

   - For Linux distributions:

     ```shell
     sudo cp -a /etc/nginx /etc/nginx-plus-backup
     sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
     ```

   - For FreeBSD:

      ```shell
      sudo cp -a /usr/local/etc/nginx /usr/local/etc/nginx-plus-backup
      sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
      ```
1. Get the JWT file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

   {{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

   {{< note >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /note >}}

1. Create the **/etc/nginx/** directory for Linux or the **/usr/local/etc/nginx** directory for FreeBSD:

    ```shell
    sudo mkdir -p /etc/nginx #for Linux
    cd /etc/nginx
    ```

    ```shell
    sudo mkdir -p /usr/local/etc/nginx #for FreeBSD
    cd /usr/local/etc/nginx
    ```
    {{< note >}} {{< include "licensing-and-reporting/custom-paths-jwt.md" >}}  {{< /note >}}

1. Rename the downloaded JWT file to **license.jwt** and copy it to the **/etc/nginx/** directory for Linux, or to the **/usr/local/etc/nginx** directory for FreeBSD:

    ```shell
    sudo cp license.jwt /etc/nginx/  #for Linux
    ```

    ```shell
    sudo cp license.jwt /usr/local/etc/nginx/  #for FreeBSD
    ```

1. Upgrade to the new NGINX Plus package.

   - For RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux and Rocky Linux:

     ```shell
     sudo yum upgrade nginx-plus
     ```

   - For Debian and Ubuntu:

     ```shell
     sudo apt update
     sudo apt install nginx-plus
     ```

   - For FreeBSD:

     ```shell
     sudo pkg upgrade nginx-plus
     ```

1. Configure NGINX Plus usage reporting which is mandatory starting from R33. By default, no configuration is required. However, configuration is required in specific scenarios, such as NGINX Plus is installed in an offline environment or if the JWT license file is located in a non-default directory.

   For offline environments, usage reporting should be configured for NGINX Instance Manager 2.18 or later. In the `nginx.conf` configuration file, specify the following directives:

   * the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) context handles NGINX Plus licensing and usage reporting configuration,

   * the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive specifies the domain name or IP address of the NGINX Instance Manager,

   * the [`enforce_initial_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive enables a 180-day grace period for sending the initial usage report. The initial usage report must be received by F5 licensing endpoint within this grace period. If the report is not received in time, traffic processing will be stopped:

   ```nginx
   mgmt {
       usage_report endpoint=NIM_FQDN;
       enforce_initial_report off;
   }
   ```
   Then, in NGINX Instance Manager, prepare and send the usage report to F5 licensing endpoint. For more information, see [Report usage to F5 in a disconnected environment](https://docs.nginx.com/nginx-instance-manager/disconnected/report-usage-disconnected-deployment/).

   If the JWT license file is located in a directory other than **/etc/nginx/** for Linux or **usr/local/etc/nginx/** for FreeBSD, you must specify its name and path in the [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token) directive:

   ```nginx
   mgmt {
       license_token custom/file/path/license.jwt;
   }
   ```
   For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}).

1. To verify that the new NGINX Plus version is upgraded, run:

   ```shell
   nginx -v
   ```

   The output of the command:

   ```shell
   nginx version: nginx/1.27.2 (nginx-plus-r33)
   ```

<span id="upgrade_modules"></span>
## Upgrading NGINX Plus Modules

The upgrade procedure depends on how the module was supplied and installed.

- NGINX‑authored and NGINX‑certified community dynamic modules are updated automatically together with NGINX Plus.

  {{< note >}} For FreeBSD, each NGINX‑authored and NGINX‑certified module must be updated separately using FreeBSD package management tool. {{< /note >}}

- Community dynamic modules must be recompiled against the corresponding NGINX Open Source  version. See [Installing NGINX Community Modules](#install_modules_oss).
