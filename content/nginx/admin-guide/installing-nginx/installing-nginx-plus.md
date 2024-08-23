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
- A [supported operating system]({{< relref "../../technical-specs.md" >}})
- `root` privilege
- Your credentials to the [MyF5 Customer Portal](https://account.f5.com/myf5), provided by email from F5, Inc.
- Your F5 NGINX Plus certificate and public key (<span style="white-space: nowrap;">**nginx-repo.crt**</span> and <span style="white-space: nowrap;">**nginx-repo.key**</span> files) or JWT token file provided by F5, Inc.


<span id="install_amazon2023"></span>
## Installing NGINX Plus on Amazon Linux 2023

NGINX Plus can be installed on Amazon Linux 2023 (x86_64, aarch64).

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/), select the subscription ID that corresponds to your NGINX Plus subscription, and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Install the required **ca-certificates** dependency:

    ```shell
    sudo dnf update
    sudo dnf install ca-certificates
    ```

5. Copy the **nginx-repo.crt** and **nginx-repo.key** files to the Amazon Linux server in the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

6. Add NGINX Plus repository by downloading the [plus-amazonlinux2023.repo](https://cs.nginx.com/static/files/plus-amazonlinux2023.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
    ```

7. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo dnf install nginx-plus
    ```

8. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

9. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_amazon2"></span>
## Installing NGINX Plus on Amazon Linux 2

NGINX Plus can be installed on Amazon Linux 2 LTS (x86_64, aarch64).

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Install the required **ca-certificates** dependency:

    ```shell
    sudo yum update
    sudo yum install ca-certificates
    ```

5. Copy the **nginx-repo.crt** and **nginx-repo.key** files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

6. Add NGINX Plus repository by downloading the [nginx-plus-amazon2.repo](https://cs.nginx.com/static/files/nginx-plus-amazon2.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo
    ```

7. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo yum install nginx-plus
    ```

8. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

9. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_rhel_centos"></span>
## Installing NGINX Plus on RHEL 7.4+, CentOS RHEL 7.4+, and Oracle Linux 7.4+

NGINX Plus can be installed on the following versions of CentOS/Oracle Linux/RHEL:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                       | Version        | Architecture           |
|------------------------------------|----------------|------------------------|
| CentOS                             | 7.4+           | x86_64, aarch64        |
| Oracle Linux                       | 7.4+           | x86_64                 |
| Red Hat Enterprise Linux           | 7.4+           | x86_64, aarch64        |

{{</bootstrap-table>}}

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Copy the files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

5. Install the required **ca-certificates** dependency:

    ```shell
    sudo yum update
    sudo yum install ca-certificates
    ```

6. If you have NGINX App Protect subscription, install **epel-release** dependency:

    ```shell
    sudo yum install epel-release
    ```

7. Add NGINX Plus repository by downloading the [nginx-plus-7.4.repo](https://cs.nginx.com/static/files/nginx-plus-7.4.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

8. If you have NGINX App Protect subscription, add theNGINX App Protect repository by downloading the [app-protect-7.repo](https://cs.nginx.com/static/files/app-protect-7.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

9. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo yum install nginx-plus
    ```

10. If you have NGINX App Protect subscription, install NGINX App Protect and its signatures:

    ```shell
    sudo yum install nginx-plus app-protect app-protect-attack-signatures
    ```

11. To enable the nginx service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

12. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

13. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_rhel8"></span>
## Installing NGINX Plus on RHEL 8.1+, Oracle Linux 8.1+, AlmaLinux 8, Rocky Linux 8

NGINX Plus can be installed on the following versions of CentOS/RHEL:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                       | Version        | Architecture           |
|------------------------------------|----------------|------------------------|
| Red Hat Enterprise Linux           | 8.1+           | x86_64, aarch64, s390x |
| Oracle Linux                       | 8.1+           | x86_64, aarch64        |
| AlmaLinux                          | 8.6+           | x86_64, aarch64        |
| Rocky Linux                        | 8.6+           | x86_64, aarch64        |

{{</bootstrap-table>}}

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Copy the files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

5. Install the required **ca-certificates** dependency:

    ```shell
    sudo dnf update
    sudo dnf install ca-certificates
    ```

6. Add NGINX Plus repository by downloading the [nginx-plus-8.repo](https://cs.nginx.com/static/files/nginx-plus-8.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    ```

7. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo dnf install nginx-plus
    ```

8. To enable the nginx service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

9. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

10. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_rhel9"></span>
## Installing NGINX Plus on RHEL 9.0+, Oracle Linux 9, AlmaLinux 9, Rocky Linux 9

NGINX Plus can be installed on the following versions of CentOS/RHEL:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                       | Version        | Architecture           |
|------------------------------------|----------------|------------------------|
| Red Hat Enterprise Linux           | 9.0+           | x86_64, aarch64, s390x |
| Oracle Linux                       | 9              | x86_64                 |
| AlmaLinux                          | 9              | x86_64, aarch64        |
| Rocky Linux                        | 9              | x86_64, aarch64        |

{{</bootstrap-table>}}

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Copy the files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

5. Install the required **ca-certificates** dependency:

    ```shell
    sudo dnf update
    sudo dnf install ca-certificates
    ```

6. Add NGINX Plus repository by downloading the [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) file to **/etc/yum.repos.d**:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
    ```

7. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo dnf install nginx-plus
    ```

8. To enable the nginx service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

9. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

10. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_debian_ubuntu"></span>
## Installing NGINX Plus on Debian or Ubuntu

NGINX Plus can be installed on the following versions of Debian or Ubuntu:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution  | Version   | Codename     | Architecture           |
|---------------|-----------|--------------|------------------------|
| Debian        | 11        | Bullseye     | x86_64, aarch64        |
| Debian        | 12        | Bookworm     | x86_64, aarch64        |
| Ubuntu        | 20.04 LTS | Focal        | x86_64, aarch64, s390x |
| Ubuntu        | 22.04 LTS | Jammy        | x86_64, aarch64, s390x |
| Ubuntu        | 24.04 LTS | Noble Numbat | x86_64, aarch64        |

{{</bootstrap-table>}}

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Copy the files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

5. Install the prerequisites packages.

    For Debian:

    ```shell
    sudo apt-get update
    sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring
    ```

    For Ubuntu:

    ```shell
    sudo apt-get update
    sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
    ```

6. Download and add [NGINX signing key](https://cs.nginx.com/static/keys/nginx_signing.key) and [App Protect security updates signing key](https://cs.nginx.com/static/keys/app-protect-security-updates.key):

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

7. Add the NGINX Plus repository.

    For Debian:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

    For Ubuntu:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

8. If you have NGINX App Protect subscription, add its repositories.

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

9. Download the **nginx-plus** apt configuration to **/etc/apt/apt.conf.d**:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

10. Update the repository information:

    ```shell
    sudo apt-get update
    ```

11. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    sudo apt-get install -y nginx-plus
    ```

12. If you have NGINX App Protect subscription, install NGINX App Protect and its signatures:

    ```shell
    sudo apt-get install app-protect app-protect-attack-signatures
    ```

13. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

14. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_freebsd"></span>
## Installing NGINX Plus on FreeBSD

NGINX Plus can be installed on the following versions of FreeBSD:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution      | Version        | Architecture      |
|-------------------|----------------|-------------------|
| FreeBSD           | 13             | amd64             |
| FreeBSD           | 14             | amd64             |

{{</bootstrap-table>}}

To install NGINX Plus on FreeBSD:

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files.

4. Copy the files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

5. Install the prerequisite **ca_root_nss** package:

    ```shell
    sudo pkg update
    sudo pkg install ca_root_nss
    ```

6. Copy the [nginx-plus.conf](https://cs.nginx.com/static/files/nginx-plus.conf) file to the **/etc/pkg/** directory:

    ```shell
    sudo fetch -o /etc/pkg/nginx-plus.conf http://cs.nginx.com/static/files/nginx-plus.conf
    ```

7. Add the following lines to the **/usr/local/etc/pkg.conf** file:

    ```none
    PKG_ENV: { SSL_NO_VERIFY_PEER: "1",
    SSL_CLIENT_CERT_FILE: "/etc/ssl/nginx/nginx-repo.crt",
    SSL_CLIENT_KEY_FILE: "/etc/ssl/nginx/nginx-repo.key" }
    ```

8. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files (see "[Upgrading NGINX Plus](#upgrade)" for details).

    ```shell
    sudo pkg install nginx-plus
    ```

9. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

10. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_suse"></span>
## Installing NGINX Plus on SUSE Linux Enterprise Server

NGINX Plus can be installed on the following versions of SUSE Linux Enterprise Server:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                 | Version        | Architecture      |
|------------------------------|----------------|-------------------|
| SUSE Linux Enterprise Server | 12 SP5         | x86_64            |
| SUSE Linux Enterprise Server | 15 SP2         | x86_64            |

{{</bootstrap-table>}}

To install NGINX Plus on SLES:

1. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

2. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files.

3. Copy the files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

4. Create a file bundle of the certificate and key:

    ```shell
    cat /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key > /etc/ssl/nginx/nginx-repo-bundle.crt
    ```

5. Install the required **ca-certificates** dependency:

    ```shell
    zypper refresh
    zypper install ca-certificates
    ```

6. Add the **nginx-plus** repo.

    For SLES 12:

    ```shell
    zypper addrepo -G -t yum -c 'https://pkgs.nginx.com/plus/sles/12?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer' nginx-plus
    ```

    For SLES 15:

    ```shell
    zypper addrepo -G -t yum -c 'https://pkgs.nginx.com/plus/sles/15?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=peer' nginx-plus
    ```

7. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced.

    ```shell
    zypper install nginx-plus
    ```

8. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_alpine"></span>
## Installing NGINX Plus on Alpine Linux

NGINX Plus can be installed on the following versions of Alpine Linux:

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution      | Version        | Architecture      |
|-------------------|----------------|-------------------|
| Alpine Linux      | 3.15           | x86_64, aarch64   |
| Alpine Linux      | 3.16           | x86_64, aarch64   |
| Alpine Linux      | 3.17           | x86_64, aarch64   |
| Alpine Linux      | 3.18           | x86_64, aarch64   |

{{</bootstrap-table>}}

To install NGINX Plus on Alpine Linux:

1. If you have older NGINX Plus package installed, it is recommended backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files.

3. Upload **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. Please make sure that files do not contain other certificates and keys: Alpine Linux does not support mixing client certificates for different repositories.

4. Put NGINX signing public key to directory **/etc/apk/keys**:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
    ```

5. Add NGINX repository to **/etc/apk/repositories** file:

    ```shell
    printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

6. If you have NGINX App Protect subscription, add the NGINX App Protect repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

7. It is recommended to remove all community-supported NGINX packages. Please note all NGINX modules will be removed too.

    ```shell
    sudo apk del -r nginx
    ```

8. Install the NGINX Plus package:

    ```shell
    sudo apk add nginx-plus
    ```

9. If you have NGINX App Protect subscription, install NGINX App Protect and its signatures:

    ```shell
    sudo apk add app-protect app-protect-attack-signatures
    ```

10. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

11. If [NGINX Management Suite Instance Manager]({{<relref "/nms/about.md">}}) is used in your infrastructure, install and enable NGINX Agent. See [Install and Configure NGINX Agent]({{<relref "/nms/nginx-agent/install-nginx-agent.md">}}) for details.


<span id="install_modules"></span>
## Installing Dynamically Loadable Modules

NGINX Plus functionality can be extended with dynamically loadable modules that are not included in the prebuilt packages:

- NGINX-authored dynamic modules – Modules written and maintained by F5, Inc. Install these modules directly from the official repository:
  - [GeoIP]({{< relref "../dynamic-modules/geoip.md" >}})
  - [Image-Filter]({{< relref "../dynamic-modules/image-filter.md" >}})
  - [njs Scripting Language]({{< relref "../dynamic-modules/nginscript.md" >}})
  - [OTel]({{< relref "../dynamic-modules/opentelemetry.md" >}})
  - [Perl]({{< relref "../dynamic-modules/perl.md" >}})
  - [XSLT]({{< relref "../dynamic-modules/xslt.md" >}})

- NGINX-certified community dynamic modules – Popular third‑party modules that NGINX tests and distributes, and for which NGINX provides installation and basic configuration support. Install these modules directly from the official repository:
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

- Community dynamic modules – Modules written and distributed by third‑party members of the NGINX community. Download the source code from the author's repository and [compile it against the NGINX Open Source version](#install_modules_oss) corresponding to your NGINX Plus version. For a list, see the [NGINX Wiki](https://www.nginx.com/resources/wiki/modules/index.html).

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
  apt-get update
  apt-get install <MODULE-NAME>
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

Note that some modules are not available for certain OS versions because of OS limitations. For details as well as descriptions of the modules, see the [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}}).

After installing the module, you need to enable it in the NGINX Plus configuration file. See [Enabling Dynamic Modules](#enable_dynamic) for details.

<span id="install_modules_oss"></span>
### Installing NGINX Community Modules

For a community dynamic module to work with NGINX Plus, it must be compiled alongside the corresponding NGINX Open Source version.

1. Prepare the build environment.

   We strongly recommend that you compile dynamic modules on a separate system we will refer to as the “build environment”. Doing so minimizes the risk and complexity of the system you plan to upgrade NGINX Plus on (we will refer to this as the “production environment”). The build environment must meet the following requirements:

   - The same operating system as the production environment
   - The same NGINX version as the production environment
   - Compiler and make utilities
   - [PCRE](http://pcre.org/) library (development files)
   - [Zlib](http://www.zlib.net/) compression libraries (development files)

   To ensure your build environment has these prerequisites installed, run the appropriate command.

   - For Debian and Ubuntu:

     ```shell
     sudo apt-get update
     sudo apt-get install gcc make libpcre3-dev zlib1g-dev
     ```

   - For CentOS, Oracle Linux, and RHEL:

     ```shell
     sudo yum update
     sudo yum install gcc make pcre-devel zlib-devel
     ```

2. Obtain NGINX Open Source.

   - Identify the NGINX Open Source version that corresponds to your version of NGINX Plus. See [NGINX Plus Releases]({{< relref "../../releases.md" >}}).

   - Download the sources for the appropriate NGINX Open Source mainline version, in this case 1.25.5:

     ```shell
     wget -qO - https://nginx.org/download/nginx-1.25.5.tar.gz | tar zxfv -
     ```

3. Obtain the source for the dynamic module.

   The source code for the dynamic module can be placed in any directory in the build environment. As an example, here we're copying the [NGINX “Hello World” module](https://github.com/perusio/nginx-hello-world-module.git/) from GitHub:

   ```shell
   git clone https://github.com/perusio/nginx-hello-world-module.git
   ```

4. Compile the dynamic module.

   First establish binary compatibility by running the `configure` script with the <span style="white-space: nowrap;">`‑‑with‑compat`</span> option. Then compile the module with `make modules`.

   ```shell
   cd nginx-1.25.5/
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
   cp objs/ngx_http_hello_world.so ./ngx_http_hello_world_1.25.5.so
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

In some environments access to root account is limited for security restrictions. If you are using a Linux operating system, you will not be able to run a package manager for NGINX Plus installation without root privileges.

As a workaround, in such environments NGINX Plus can be installed with a special script that modifies NGINX Plus configuration file to run from a non-root user. The script also:

- downloads NGINX Plus packages
- extracts the content of the archives into a user-defined folder of the packages
- changes paths to user folders in NGINX configuration file to relative paths in user-defined folder
- makes a backup copy of the configuration directory
- has an option of upgrading existing unprivileged installation of NGINX Plus

Comparing to general installation of NGINX Plus, unprivileged installation has some limitations and restrictions:

- root privileges are still required in order to listen on ports below `1024`
- the script is not intended to replace a package manager of your operating system. It also does not allow any other software installations except NGINX Plus and its modules. The script modified for any other installations is not covered by the support program.
- NGINX Plus will not start automatically, so, you have to add custom `init` script/`systemd`unit file for every unprivileged installation on the host
- all dependencies and libraries required by NGINX Plus binary and its modules are not installed automatically and should be checked and installed manually

The script can be run on the following operating systems

- RedHat/CentOS
- Amazon Linux 2
- Amazon Linux 2023
- Debian, Ubuntu
- Alpine Linux
- AlmaLinux, Rocky Linux

Before starting unprivileged installation, make sure you have all the prerequisites listed in the [Prerequisites](#prereq) section (except the `root` privileges). For RPM-based distributes, make sure that you have [`rpm2cpio`](https://man7.org/linux/man-pages/man8/rpm2cpio.8.html) installed.

To perform unprivileged installation of NGINX Plus:

1. Obtain the script:

   ```shell
   wget https://raw.githubusercontent.com/nginxinc/nginx-plus-install-tools/main/ngxunprivinst.sh
   ```

2. Make the script executable:

   ```shell
   chmod +x ngxunprivinst.sh
   ```

3. Download NGINX Plus and its module packages for your operating system. The <cert_file> and <key_file> are your NGINX Plus certificate and private key obtained from [MyF5 Customer Portal](https://account.f5.com/myf5/):

   ```shell
   ./ngxunprivinst.sh fetch -c <cert_file> -k <key_file>
   ```

   If you need to install a particular version of NGINX Plus:

   - first, list all available NGINX Plus versions from the repository:

   ```shell
   ./ngxunprivinst.sh list -c <cert_file> -k <key_file>
   ```

   - then specify a particular NGINX Plus version with the `-v` option:

   ```shell
   ./ngxunprivinst.sh fetch -c <cert_file> -k <key_file> -v <version>
   ```

4. Extract the downloaded packages to the provided NGINX Plus prefix &lt;path&gt; An optional `-y` option will overwrite an existing installation (if any):

   ```shell
   ./ngxunprivinst.sh install [-y] -p <path> <file1.rpm> <file2.rpm>
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

To install NGINX Plus offline, you will need a machine connected to the Internet to get the NGINX Plus package, SSL certificate and key. Then your can transfer these files to the target server for offline installation.

### Obtaining files on the machine connected to the Internet

1. Download your SSL certificate, private key, and NGINX Plus installation file from [MyF5 Customer Portal](https://account.f5.com/myf5/).

   - Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/)

   - Choose the subscription ID that corresponds to your NGINX Plus subscription.

   - To download the SSL certificate and private key, select the `SSL certificate` and `Private Key` in the `Subscription Details` area.

   - To download the NGINX Plus package and corresponding dynamic modules, select `Downloads`. Choose `NGINX` product group, `NGINX Plus` product line, Linux distribution, its version, and architecture. Choose the target file from the list and select `Download`.

2. Transfer the files to the target server that doesn't have online access and where NGINX Plus will be installed.


### Installing NGINX Plus on a server without internet connectivity

1. If you have an older NGINX Plus package installed, we recommend backing up the configuration and log files. See "[Upgrading NGINX Plus](#upgrade)" for details.

2. Create the **/etc/ssl/nginx** directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Copy the downloaded SSL certificate and product key files files to the **/etc/ssl/nginx/** directory:

    ```shell
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

4.  Install the NGINX Plus package or a dynamic module. Any older NGINX Plus package is automatically replaced.

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

5. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    nginx -v
    ```

<span id="upgrade"></span>
## Upgrading NGINX Plus

{{< note >}} Starting from <a href="../../../releases/#r24">Release 24</a> (R24), NGINX Plus repositories have been separated into individual repositories based on operating system distribution and license subscription. Before upgrading from previous NGINX Plus versions, you must first reconfigure your repositories to point to the correct location. To reconfigure your repository, follow the installation instructions above for your operating system. {{< /note >}}

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

2. Upgrade to the new NGINX Plus package.

   - For RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux and Rocky Linux:

     ```shell
     sudo yum upgrade nginx-plus
     ```

   - For Debian and Ubuntu:

     ```shell
     sudo apt-get update
     sudo apt-get install nginx-plus
     ```

   - For FreeBSD:

     ```shell
     sudo pkg upgrade nginx-plus
     ```

   To verify that the new NGINX Plus version is running, run:

   ```shell
   nginx -v
   ```

   The output of the command:

   ```shell
   nginx version: nginx/1.25.5 (nginx-plus-r32)
   ```

<span id="upgrade_modules"></span>
## Upgrading NGINX Plus Modules

The upgrade procedure depends on how the module was supplied and installed.

- NGINX‑authored and NGINX‑certified community dynamic modules are updated automatically together with NGINX Plus.

  {{< note >}} For FreeBSD, each NGINX‑authored and NGINX‑certified module must be updated separately using FreeBSD package management tool. {{< /note >}}

- Community dynamic modules must be recompiled against the corresponding NGINX Open Source  version. See [Installing NGINX Community Modules](#install_modules_oss).
