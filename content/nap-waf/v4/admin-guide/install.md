---
title: NGINX App Protect WAF Administration Guide
weight: 100
toc: true
type: how-to
product: NAP-WAF
docs: DOCS-646

---

## Overview

F5 NGINX App Protect WAF provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10; response inspection; Meta characters check; HTTP protocol compliance; evasion techniques; disallowed file types; JSON & XML well-formedness; sensitive parameters & Data Guard. Refer to [Supported Security Policy Features]({{< relref "/nap-waf/v4/configuration-guide/configuration.md#supported-security-policy-features" >}}) section for a more detailed description.

This guide explains how to deploy NGINX App Protect WAF as well as upgrade App Protect and the App Protect signature sets.<br>

### Using NGINX App Protect with NGINX Instance Manager

NGINX Instance Manager provides centralized configuration management and visibility for your NGINX App Protect WAF fleet.
After completing the NGINX App Protect WAF installation, refer to the [NGINX Instance Manager Installation Guide](https://docs.nginx.com/nginx-instance-manager/deploy/) for the deployment instructions.<br>

## Prerequisites

NGINX App Protect WAF is available to customers as a downloadable dynamic module at an additional cost. To purchase or add NGINX App Protect WAF to an existing NGINX Plus subscription, contact the NGINX sales team.

NGINX Plus Release 22 and later supports NGINX App Protect WAF.

NGINX App Protect WAF supports the following operating systems:

- [CentOS/RHEL 7.4.x and above](#centos-74-installation) - (Deprecated starting from release 4.11)
- [RHEL 8.1.x and above](#rhel-81-installation)
- [RHEL 9 and above](#rhel-9-installation)
- [Oracle Linux 8.1.x and above](#oracle-linux-81-installation)
- [Amazon Linux 2](#amazon-linux-2-lts-installation) - (Deprecated starting from release 4.11)
- [Amazon Linux 2023](#amazon-linux-2023-installation)
- [Debian 10 (Buster)](#debian-10--debian-11--debian-12-installation) - (Deprecated starting from NGINX Plus R28)
- [Debian 11 (Bullseye)](#debian-10--debian-11--debian-12-installation)
- [Debian 12 (Bookworm)](#debian-10--debian-11--debian-12-installation)
- [Ubuntu 18.04 (Bionic)](#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation) - (Deprecated starting from NGINX Plus R30)
- [Ubuntu 20.04 (Focal)](#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation)
- [Ubuntu 22.04 (Jammy)](#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation)
- [Ubuntu 24.04 (Noble)](#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation)
- [Alpine 3.17](#alpine-316-317--319-installation)
- [Alpine 3.19](#alpine-316-317--319-installation)

The NGINX App Protect WAF package has the following dependencies:

1. **nginx-plus-module-appprotect** - NGINX Plus dynamic module for App Protect
1. **app-protect-engine** - The App Protect enforcement engine
1. **app-protect-plugin** - The App Protect connector API between the engine and the NGINX Plus dynamic module
1. **app-protect-compiler** - The App Protect enforcement engine compiler agent
1. **app-protect-common** - The App Protect shared libraries package
1. **app-protect-geoip** - The App Protect geolocation update package
1. **app-protect-graphql** - The App Protect shared library package for GraphQL protection
1. **app-protect-attack-signatures** - The App Protect attack signatures update package
1. **app-protect-threat-campaigns** - The App Protect threat campaigns update package
1. **app-protect-bot-signatures** - The App Protect bot signatures update package
1. **app-protect-selinux** - The prebuilt SELinux policy module for NGINX App Protect WAF (optional dependency)

See the NGINX Plus full list of prerequisites for more details. NGINX App Protect WAF can be installed as a module to an existing NGINX Plus installation or as a complete NGINX Plus with App Protect installation in a clean environment.

## Storage I/O Performance

When deploying App Protect on NGINX Plus take into consideration the performance of storage on which it is going to be installed.
The storage performance may greatly affect the time it takes NGINX Plus to reload whenever there is a configuration change, especially when NGINX App Protect WAF policies are being added or updated.
In order to assess the storage performance you can use a tool called [fio](https://fio.readthedocs.io/en/latest/fio_doc.html). An example of usage follows: (you may need to use `sudo`):

```shell
fio --filename=/opt/tst --size=100MB --direct=1 --rw=randrw --bs=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1
```

The output fields relevant in this context are: `read: IOPS=` and `write: IOPS=`.
Below is a table showing how many seconds it takes a reload to complete, when NGINX Plus is reloaded with an updated policy of an average size, in environments of varying I/O performance, and comparable CPU/memory specs:

{{<bootstrap-table "table table-striped table-bordered">}}
|Read IOPS | Write IOPS | Reload Time|
| ---| ---| --- |
|675 | 678 | 18 |
|1575 | 1575 | 12 |
|13400 | 13400 | 8 |

{{</bootstrap-table>}}

## Platform Security Considerations

When deploying App Protect on NGINX Plus take the following precautions to secure the platform. This avoids the risk of causing a Denial of Service condition or compromising the platform security.

- Restrict permissions to the files on the NGINX App Protect WAF platform to user **nginx** and group **nginx**, especially for the sensitive areas containing the configuration.
- Remove unnecessary remote access services on the platform.
- Configure a Syslog destination on the same machine as App Protect and proxy to an external destination. This avoids eavesdropping and [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attacks on the Syslog channel.
- Regularly update the Operating System (OS) to avoid known OS vulnerabilities which may impact the service.


## User Permissions

If a user other than **nginx** is to be used, note the following:

- If **nginx** user creation is disallowed on the platform, the following warning may be seen during installation:

  ```shell
  warning: user nginx does not exist - using root
  ```

- After first installation, upgrade, or security update installation, perform the following steps **before** starting/restarting/reloading NGINX:

  - Modify user permissions on all installed NGINX App Protect WAF files:

    ```shell
    chown -R <user>:<group> /usr/share/ts /var/log/app_protect /opt/app_protect /etc/app_protect
    ```

  - Modify user of NGINX App Protect WAF processes:

    For service startup modify the **User** in the following files on your platform:

    `nginx-app-protect.service`

    For [docker deployment](#general-docker-deployment-instructions), modify the `entrypoint.sh` script to use the correct user instead of **nginx** when starting up the `bd-socket-plugin` process.


## CentOS 7.4+ Installation

1. If you already have NGINX packages on your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the CentOS server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo yum install ca-certificates epel-release wget
    ```

6. Remove any previously downloaded NGINX Plus repository file from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx-plus-*.repo
    ```

7. Add NGINX Plus repository by downloading the file `nginx-plus-7.4.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

8. Add NGINX App Protect WAF repository by downloading the file `app-protect-7.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

9. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo yum install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo yum --showduplicates list app-protect
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo yum install app-protect-24+3.639.0
    ```

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

12. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

13. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo yum install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

14. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

15. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## RHEL 7.4+ Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the RHEL server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo yum install ca-certificates wget
    ```

6. Remove any previously downloaded NGINX Plus repository file from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx-plus-*.repo
    ```

7. Add NGINX Plus repository by downloading the file `nginx-plus-7.4.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

8. Add NGINX App Protect WAF repository by downloading the file `app-protect-7.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

9. Enable Yum repositories to pull App Protect dependencies:

    Download the file `dependencies.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

    If you have a RHEL subscription:

    ```shell
    sudo yum-config-manager --enable rhui-REGION-rhel-server-optional rhui-REGION-rhel-server-releases rhel-7-server-optional-rpms
    ```

    If you don't have a RHEL subscription, you can pull the dependencies from the CentOS repository:
    Create a new repository `centos.repo` in `/etc/yum.repos.d/` with the content:

    ```shell
    [centos]
    name=CentOS-7
    baseurl=http://ftp.heanet.ie/pub/centos/7/os/x86_64/
    enabled=1
    gpgcheck=1
    gpgkey=http://ftp.heanet.ie/pub/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
    ```

10. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo yum install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo yum --showduplicates list app-protect
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo yum install app-protect-24+3.639.0
    ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

13. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

14. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo yum install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

15. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

16. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## RHEL 8.1+ Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the RHEL server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget
    ```

6. Remove any previously downloaded NGINX Plus repository file from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx-plus-8.repo
    ```

7. Add NGINX Plus repository by downloading the file `nginx-plus-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    ```

8. Add NGINX App Protect WAF repository by downloading the file `app-protect-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
    ```

9. Enable Yum repositories to pull App Protect dependencies:

    Download the file `dependencies.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

    Enable `codeready-builder` repository through subscription manager:

    ```shell
    sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
    ```

10. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-31+4.641.0
    ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

13. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

14. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo dnf install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

15. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

16. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## RHEL 9+ Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the RHEL server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget
    ```

6. Remove any previously downloaded NGINX Plus repository file from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/plus-*.repo
    ```

7. Add NGINX Plus repository by downloading the file `plus-9.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
    ```

8. Add NGINX App Protect WAF repository by downloading the file `app-protect-9.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
    ```

9. Enable Yum repositories to pull App Protect dependencies:

    Download the file `dependencies.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

    Enable `codeready-builder` repository through subscription manager:

    ```shell
    sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
    ```

10. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-31+4.641.0
    ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

13. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

14. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo dnf install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

15. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

16. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## Oracle Linux 8.1+ Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the Oracle Linux server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget yum-utils
    ```

6. Remove any previously downloaded NGINX Plus repository file from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx-plus-*.repo
    ```

7. Add NGINX Plus repository by downloading the file `nginx-plus-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    ```

8. Add NGINX App Protect WAF repository by downloading the file `app-protect-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
    ```

9. Enable Yum repositories to pull App Protect dependencies:

    Download the file `dependencies.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

    Enable `ol8_codeready_builder` repository:

    ```shell
    dnf config-manager --set-enabled ol8_codeready_builder
    ```

10. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-26+3.890.0
    ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

13. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

14. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo dnf install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

15. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

16. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## Amazon Linux 2 LTS Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the Amazon Linux server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo amazon-linux-extras enable epel
    sudo yum clean metadata
    sudo yum install ca-certificates epel-release wget
    ```

6. Remove any previously downloaded NGINX Plus repository file from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx-plus-7.repo
    ```

7. Add NGINX Plus repository by downloading the file `nginx-plus-7.4.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

8. Add NGINX App Protect WAF repository by downloading the file `app-protect-7.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

9. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo yum install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo yum --showduplicates list app-protect
    ```

    Then, install a specific version from the output of the command above. For example:

    ```shell
    sudo yum install app-protect-24+3.639.0
    ```

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

12. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

13. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo yum install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

14. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

15. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

---

## Amazon Linux 2023 Installation

1. If you already have NGINX packages in your system, back up your configuration and log files:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

1. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

1. Log into [MyF5](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

1. Copy `nginx-repo.key` and `nginx-repo.crt` to the RHEL server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

1. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget
    ```

1. Remove any previously downloaded NGINX Plus repository files from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/plus-*.repo
    ```

1. Add the NGINX Plus repository by downloading the file `plus-amazonlinux2023.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
    ```

1. Add the NGINX App Protect WAF repository by downloading the file `app-protect-amazonlinux2023.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo
    ```

1. Enable Yum repositories to pull App Protect dependencies:

    Download the file `dependencies.amazonlinux2023.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo
    ```

1. Install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-31+4.641.0
    ```

1. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

1. Load the NGINX App Protect WAF module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

1. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_enable on;
    ```

1. Optionally, install a prebuilt SELinux policy module for NGINX App Protect WAF (or configure SELinux as appropriate per your organization's security policies):

    ```shell
    sudo dnf install app-protect-selinux
    ```

    If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

1. To enable the NGINX/App Protect WAF service start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

1. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## Debian 10 / Debian 11 / Debian 12 Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory and change the directory to the SSL certificate directory after creating the folder:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    cd /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the Debian server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo apt-get update && sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2
    ```

    {{< note >}} In case the apt installation or database update fails due to release info change, run the below command before you install. {{< /note >}}

    ```shell
    sudo apt-get update --allow-releaseinfo-change
    ```

6. Download and add the NGINX signing keys:

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | \
    sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | \
    sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

7. Remove any previous NGINX Plus repository and apt configuration files:

    ```shell
    sudo rm /etc/apt/sources.list.d/nginx-plus.list
    sudo rm /etc/apt/sources.list.d/*app-protect*.list
    sudo rm /etc/apt/apt.conf.d/90pkgs-nginx
    ```

8. Add NGINX Plus repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

9. Add NGINX App Protect WAF repositories:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

10. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

11. Update the repository and install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect
    ```

    Alternatively, to install a specific version, use the following commands to update and list available versions:

    ```shell
    sudo apt-get update
    sudo apt-cache policy app-protect
    ```

    {{< note >}} When installing an older version of NGINX App Protect WAF, the dependent packages have to be installed manually, as shown in the command above. The following script can be used to find out the dependent packages for a specific version of NGINX App Protect WAF.{{< /note >}}

    ```shell
    findDeps () { local pkgs=$(apt show $1 2>/dev/null | grep Depends: | grep -oE "(nginx-plus-module|app-protect)-[a-z]+ *\(= *[0-9\+\.-]+~`lsb_release -cs`\)" | tr -d ' ()'); for p in ${pkgs[@]}; do echo $p; findDeps $p; done; }
    findDeps app-protect=24+3.639.0-1~[OS_CODENAME]
    ```

    Finally, install a specific version from the output of command above. For example:

    ```shell
    sudo apt-get install -y app-protect-compiler=8.7.4-1~[OS_CODENAME] \
    app-protect-plugin=3.639.0-1~[OS_CODENAME] \
    nginx-plus-module-appprotect=24+3.639.0-1~[OS_CODENAME]\
    app-protect-engine=8.7.4-1~[OS_CODENAME] \
    app-protect=24+3.639.0-1~[OS_CODENAME] \
    app-protect-common=8.7.4-1~[OS_CODENAME]
    ```

    Replace the [OS_CODENAME] in the above example with: **buster** for Debian 10, **bullseye** for Debian 11 and **bookworm** for Debian 12.

12. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

13. Load the NGINX App Protect WAF module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

14. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` via:

    ```nginx
    app_protect_enable on;
    ```

15. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

{{< note >}} Debian 10 / Debian 11 / Debian 12 activates **AppArmor** by default, but NGINX App Protect WAF will run in unconfined mode after being installed as it is shipped with no AppArmor profile. To benefit from AppArmor access control capabilities for NGINX App Protect WAF, you will have to write your own AppArmor profile for NGINX App Protect WAF executables found in `/opt/app_protect/bin` such that it best suits your environment.
{{< /note >}}


## Ubuntu 18.04 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the Ubuntu server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo apt-get update && sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2
    ```

6. Download and add the NGINX signing keys:

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

7. Remove any previous NGINX Plus repository and apt configuration files:

    ```shell
    sudo rm /etc/apt/sources.list.d/nginx-plus.list
    sudo rm /etc/apt/sources.list.d/*app-protect*.list
    sudo rm /etc/apt/apt.conf.d/90pkgs-nginx
    ```

8. Add NGINX Plus repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

9. Add NGINX App Protect WAF repositories:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

10. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

11. Update the repository and install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect
    ```

    Alternatively, to install a specific version, use the following commands to update and list available versions:

    ```shell
    sudo apt-get update
    sudo apt-cache policy app-protect
    ```

    Finally, install a specific version from the output of command above. For example:

    ```shell
    sudo apt-get install -y app-protect-compiler=5.9.4-1~[OS_CODENAME] \
    app-protect-plugin=3.263.0-1~[OS_CODENAME] \
    nginx-plus-module-appprotect=23+3.263.0-1~[OS_CODENAME] \
    app-protect-engine=5.9.4-1~[OS_CODENAME] \
    app-protect=23+3.263.0-1~[OS_CODENAME]
    ```

    Replace the [OS_CODENAME] in above the example with: **bionic** for Ubuntu 18.04, **focal** for Ubuntu 20.04, **jammy** for Ubuntu 22.04 and **noble** for Ubuntu 24.04.
    <br>
    <br>

    {{< note >}} When installing an older version of NGINX App Protect WAF, the dependent packages have to be installed manually, as shown in the command above. The following script can be used to find out the dependent packages for a specific version of NGINX App Protect WAF.{{< /note >}}

    ```shell
    findDeps () { local pkgs=$(apt show $1 2>/dev/null | grep Depends: | grep -oE "(nginx-plus-module|app-protect)-[a-z]+ *\(= *[0-9\+\.-]+~`lsb_release -cs`\)" | tr -d ' ()'); for p in ${pkgs[@]}; do echo $p; findDeps $p; done; }
    findDeps app-protect=23+3.263.0-1~[OS_CODENAME]
    ```

12. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

13. Load the NGINX App Protect WAF module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

14. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` via:

    ```nginx
    app_protect_enable on;
    ```

15. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

{{< note >}} Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 activates **AppArmor** by default, but NGINX App Protect WAF will run in unconfined mode after being installed as it is shipped with no AppArmor profile. To benefit from AppArmor access control capabilities for NGINX App Protect WAF, you will have to write your own AppArmor profile for NGINX App Protect WAF executables found in `/opt/app_protect/bin` such that it best suits your environment.
{{< /note >}}


## Alpine 3.16, 3.17 & 3.19 Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

3. Upload `nginx-repo.key` to `/etc/apk/cert.key` and `nginx-repo.crt` to `/etc/apk/cert.pem`. Make sure that files do not contain other certificates and keys, as Alpine Linux does not support mixing client certificates for different repositories.

4. Add the NGINX public signing key to the directory `/etc/apk/keys`:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub  https://cs.nginx.com/static/keys/nginx_signing.rsa.pub

    sudo wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub
    ```

5. Remove any previously configured NGINX Plus repository:

    ```shell
    sed "/plus-pkgs.nginx.com/d" /etc/apk/repositories
    ```

6. Add the NGINX Plus repository to `/etc/apk/repositories` file:

    ```shell
    printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

7. Add the NGINX App Protect WAF repository to `/etc/apk/repositories` file:

    ```shell
    printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories

    printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

8. We recommend removing all community-supported NGINX packages. Note that all NGINX modules will be removed as well.

    ```shell
    sudo apk del -r app-protect
    sudo apk del -r nginx
    ```

9. Update the repository and install the most recent version of the NGINX Plus and NGINX App Protect WAF:

    ```shell
    sudo apk update
    sudo apk add app-protect
    ```

    Alternatively, use the following commands to install the most recent version of NGINX App Protect WAF for NGINX Plus R28:

    ```shell
    sudo apk update
    sudo apk add app-protect
    ```

    Alternatively, use the following commands to list available versions:

    ```shell
    sudo apk update
    sudo apk info app-protect
    ```

    Finally, install a specific version from the output of command above. For example:

    ```shell
    sudo apk add app-protect=30.4.457.0-r1
    ```

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Load the NGINX App Protect WAF module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

12. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` via:

    ```nginx
    app_protect_enable on;
    ```

13. Start the App Protect and NGINX services:

    ```shell
    sudo service nginx-app-protect start
    sudo service nginx start
    ```


## Docker Deployment

### General Docker Deployment Instructions

1. Create a Dockerfile (see examples below) which copies the following files into the docker image:

   - `nginx.conf`: User defined nginx.conf with app-protect enabled
   - `entrypoint.sh`: Docker startup script which spins up all App Protect processes, must have executable permissions
   - `custom_log_format.json`: Optional user-defined security log format file (if not used - remove its references from the `nginx.conf` and Dockerfile)

2. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

3. Copy the files to the directory where the Dockerfile is located.

4. Optionally, create `custom_log_format.json` in the same directory, for example:

    ```json
    {
        "filter": {
            "request_type": "all"
        },
        "content": {
            "format": "splunk",
            "max_request_size": "any",
            "max_message_size": "10k"
        }
    }
    ```

5. In the same directory create an `nginx.conf` file with the following contents:

    ```nginx
    user nginx;

    worker_processes auto;
    load_module modules/ngx_http_app_protect_module.so;

    error_log /var/log/nginx/error.log debug;

    events {
        worker_connections 10240;
    }

    http {
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        sendfile on;
        keepalive_timeout 65;

        upstream app_backend_com {
            server 192.168.0.1:8000;
            server 192.168.0.1:8001;
        }
        server {
            listen 80;
            server_name app.example.com;
            proxy_http_version 1.1;

            app_protect_enable on;
            app_protect_security_log_enable on;
            app_protect_security_log "/etc/nginx/custom_log_format.json" syslog:server=127.0.0.1:514;

            location / {
                client_max_body_size 0;
                default_type text/html;
                # set your backend here
                proxy_pass http://app_backend_com;
                proxy_set_header Host $host;
            }
        }
    }
    ```

    {{< important >}}Make sure to replace upstream and proxy pass directives in this example with relevant application backend settings.{{< /important >}}
6. In the same directory create an `entrypoint.sh` file with the following content:

    ```shell
    #!/bin/sh

    /bin/su -s /bin/sh -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 >> /var/log/app_protect/bd-socket-plugin.log &" nginx
    /usr/sbin/nginx -g 'daemon off;'
    ```

7. Create a Docker image:

    - For CentOS/Oracle Linux/Debian/Ubuntu/Alpine/Amazon Linux:

        ```shell
        DOCKER_BUILDKIT=1 docker build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t app-protect .
        ```

        The `DOCKER_BUILDKIT=1` enables `docker build` to recognize the `--secret` flag which allows the user to pass secret information to be used in the Dockerfile for building docker images in a safe way that will not end up stored in the final image. This is a recommended practice for the handling of the certificate and private key for NGINX repository access (`nginx-repo.crt` and `nginx-repo.key` files). More information [here](https://docs.docker.com/engine/reference/commandline/buildx_build/#secret).

    - For RHEL:

        ```shell
        podman build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t app-protect .
        ```

    **Notes:**
    - The `--no-cache` option tells Docker/Podman to build the image from scratch and ensures the installation of the latest version of NGINX Plus and NGINX App Protect WAF 4.x. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses versions from the previously built image from the cache.
    - For RHEL:<br>
    The subscription-manager is disabled when running inside containers based on Red Hat Universal Base images. You will need a registered and subscribed RHEL system.

8. Verify that the app-protect image was created successfully with the docker images command:

    ```shell
    docker images app-protect
    ```

9. Create a container based on this image, for example, my-app-protect container:

    ```shell
    docker run --name my-app-protect -p 80:80 -d app-protect
    ```

10. Verify that the my-app-protect container is up and running with the `docker ps` command:

    ```shell
    docker ps
    ```

### CentOS 7.4 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For CentOS 7:
FROM centos:7.4.1708

# Install prerequisite packages:
RUN yum -y install wget ca-certificates epel-release

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install app-protect \
    && yum clean all \
    && rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### RHEL UBI7 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi7:
FROM registry.access.redhat.com/ubi7/ubi

# Install prerequisite packages:
RUN yum -y install wget ca-certificates

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum install --enablerepo=rhel-7-server-extras-rpms --enablerepo=rhel-7-server-optional-rpms --enablerepo=rhel-7-server-rpms -y app-protect \
    && yum clean all \
    && rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### RHEL UBI8 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi8:
FROM registry.access.redhat.com/ubi8/ubi

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install --enablerepo=codeready-builder-for-rhel-8-x86_64-rpms -y app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### RHEL UBI9 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi9:
FROM registry.access.redhat.com/ubi9/ubi

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    && dnf clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install --enablerepo=codeready-builder-for-rhel-9-x86_64-rpms -y app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### Oracle Linux 8 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Oracle Linux 8:
FROM oraclelinux:8

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates yum-utils

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo

# Enable Yum repositories to pull App Protect dependencies:
RUN dnf config-manager --set-enabled ol8_codeready_builder \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install app-protect \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### Amazon Linux 2 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Amazon Linux 2:
FROM amazonlinux:2

# Install prerequisite packages:
RUN amazon-linux-extras enable epel
RUN yum clean metadata
RUN yum -y install wget ca-certificates epel-release shadow-utils

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install app-protect \
    && yum clean all \
    && rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### Amazon Linux 2023 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Amazon Linux 2023:
FROM amazonlinux:2023

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX Plus repo:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo

# Add NAP dependencies repo:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo

# Add NGINX App-protect repo:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf -y install app-protect \
    && dnf clean all \
    && rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### Debian 10 (Buster) / 11 (Bullseye) / 12 (Bookworm) Docker Deployment Example

```dockerfile
ARG OS_CODENAME
# Where OS_CODENAME can be: buster/bullseye/bookworm
# syntax=docker/dockerfile:1
# For Debian 10 / 11 / 12:
FROM debian:${OS_CODENAME}

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add NGINX Plus repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-plus.list

# Add NGINX App Protect WAF repositories:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && apt-get install -y app-protect

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```


### Ubuntu 18.04 (Bionic) / 20.04 (Focal) / 22.04 (Jammy) / 24.04 (Noble) Docker Deployment Example

```dockerfile
ARG OS_CODENAME
# Where OS_CODENAME can be: bionic/focal/jammy/noble
# syntax=docker/dockerfile:1
# For Ubuntu 18.04 / 20.04 /22.04 / 24.04:
FROM ubuntu:${OS_CODENAME}

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add NGINX Plus repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-plus.list

# Add NGINX App Protect WAF repositories:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```

### Alpine 3.16 / Alpine 3.17 / Alpine 3.19 Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Alpine 3.16/3.17/3.19:
FROM alpine:3.19

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
 && wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub

# Add NGINX Plus repository:
RUN printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Add NGINX App Protect repository:
RUN printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories \
 && printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Update the repository and install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    apk update && apk add app-protect

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
```


## Converter Tool Docker Image

This section explains how to build a Docker image for the purpose of converting policy files from other F5 WAF products to NGINX App Protect WAF JSON declarative format.
For more details regarding this feature refer to [Converter Tools]({{< relref "/nap-waf/v4/configuration-guide/configuration.md#converter-tools" >}}).

### Converter Docker Deployment Instructions
You need root permissions to execute the following steps.

1. Create a Dockerfile (see examples below).

2. Log in to the [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

3. Create a Docker image:

    - For CentOS/Oracle Linux/Debian/Ubuntu/Alpine/Amazon Linux:

        ```shell
        DOCKER_BUILDKIT=1 docker build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t app-protect-converter .
        ```

        The `DOCKER_BUILDKIT=1` enables `docker build` to recognize the `--secret` flag which allows the user to pass secret information to be used in the Dockerfile for building docker images in a safe way that will not end up stored in the final image. This is a recommended practice for the handling of the certificate and private key for NGINX repository access (`nginx-repo.crt` and `nginx-repo.key` files). More information [here](https://docs.docker.com/engine/reference/commandline/buildx_build/#secret).

    - For RHEL:

        ```shell
        podman build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t app-protect-converter .
        ```

    **Notes:**
    - The `--no-cache` option tells Docker/Podman to build the image from scratch and ensures the installation of the latest version of NGINX Plus and NGINX App Protect WAF 4.x. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses versions from the previously built image from the cache.
    - For RHEL:<br>
    The subscription-manager is disabled when running inside containers based on Red Hat Universal Base images. You will need a registered and subscribed RHEL system.

4. Create a temporary folder and copy your XML policy file(s) to it:

    ```shell
    mkdir /tmp/convert
    cp policy.xml /tmp/convert/
    ```

5. Run the docker image with the temporary folder as a mounted volume on the container, and run the policy converter script:

    ```shell
    docker run -v /tmp/convert:/tmp/convert app-protect-converter /opt/app_protect/bin/convert-policy -i /tmp/convert/policy.xml -o /tmp/convert/policy.json | jq
    ```

    Output:

    ```json
    {
        "completed_successfully": true,
        "file_size": 20604,
        "warnings": [
            "Default header '*-bin' cannot be deleted.",
            "Traffic Learning, Policy Building, and staging are unsupported",
            "/general/enableEventCorrelation must be '0' (was '1').",
            "Element '/websocket-urls' is unsupported.",
            "/signature-sets/learn value 1 is unsupported",
            "Element '/redirection-protection' is unsupported.",
            "/protocolIndependent must be '1' (was '0').",
            "Element '/gwt-profiles' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_ASM_COOKIE_HIJACKING' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_BLOCKING_CONDITION' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_BRUTE_FORCE' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_CONVICTION' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_CROSS_ORIGIN_REQUEST' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_CSRF' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_CSRF_EXPIRED' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_DYNAMIC_SESSION' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_FLOW' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_FLOW_DISALLOWED_INPUT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_FLOW_ENTRY_POINT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_FLOW_MANDATORY_PARAMS' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_GEOLOCATION' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_GWT_FORMAT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_GWT_MALFORMED' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_HOSTNAME_MISMATCH' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_LOGIN_URL_BYPASSED' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_LOGIN_URL_EXPIRED' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_MALICIOUS_DEVICE' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_MALICIOUS_IP' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_PARAMETER_DYNAMIC_VALUE' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_PLAINTEXT_FORMAT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_REDIRECT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_SESSION_AWARENESS' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_VIRUS' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BAD_REQUEST' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BINARY_MESSAGE_LENGTH' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BINARY_MESSAGE_NOT_ALLOWED' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_EXTENSION' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAMES_PER_MESSAGE_COUNT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAME_LENGTH' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAME_MASKING' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAMING_PROTOCOL' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_TEXT_MESSAGE_NOT_ALLOWED' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_TEXT_NULL_VALUE' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_XML_SCHEMA' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_XML_SOAP_ATTACHMENT' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_XML_SOAP_METHOD' is unsupported.",
            "/blocking-settings/violations/name value 'VIOL_XML_WEB_SERVICES_SECURITY' is unsupported.",
            "/blocking-settings/http-protocols/description value 'Unparsable request content' is unsupported.",
            "Element '/plain-text-profiles' is unsupported."
        ],
        "filename": "/tmp/convert/policy-ubuntu.json"
    }
    ```

6. Once completed, the newly exported JSON policy file should reside in the same folder as the source XML policy file:

    ```shell
    ls -l /tmp/convert/
    total 848
    -rw-r--r-- 1 root root  20604 Dec 20 12:33 policy.json    # Exported JSON policy file
    -rw-r--r-- 1 root root 841818 Dec 20 11:10 policy.xml     # Original XML policy file
    ```


### CentOS 7 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For CentOS 7:
FROM centos:7

# Install prerequisite packages:
RUN yum -y install wget ca-certificates epel-release

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo

# Update the repository and install the most recent version of the NGINX App Protect WAF Compiler package:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install app-protect-compiler \
    && yum clean all \
    && rm -rf /var/cache/yum
```

### RHEL UBI7 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi7:
FROM registry.access.redhat.com/ubi7/ubi

# Install prerequisite packages:
RUN yum -y install wget ca-certificates

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
     yum install --enablerepo=rhel-7-server-extras-rpms --enablerepo=rhel-7-server-optional-rpms --enablerepo=rhel-7-server-rpms -y app-protect-compiler \
    && yum clean all \
    && rm -rf /var/cache/yum
```

### RHEL UBI8 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi8:
FROM registry.access.redhat.com/ubi8/ubi

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install --enablerepo=codeready-builder-for-rhel-8-x86_64-rpms -y app-protect-compiler \
    && dnf clean all \
    && rm -rf /var/cache/dnf
```

### RHEL UBI9 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For RHEL ubi9:
FROM registry.access.redhat.com/ubi9/ubi

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates

# Add NGINX App-protect & dependencies repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    && dnf clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install --enablerepo=codeready-builder-for-rhel-9-x86_64-rpms -y app-protect-compiler \
    && dnf clean all \
    && rm -rf /var/cache/dnf
```

### Oracle Linux 8 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Oracle Linux 8:
FROM oraclelinux:8

# Install prerequisite packages:
RUN dnf -y install wget ca-certificates yum-utils

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo

# Enable Yum repositories to pull App Protect dependencies:
RUN dnf config-manager --set-enabled ol8_codeready_builder \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo \
    # You can use either of the dependencies or epel repo
    # && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    dnf install -y app-protect-compiler \
    && dnf clean all \
    && rm -rf /var/cache/dnf
```

### Amazon Linux 2 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Amazon Linux 2:
FROM amazonlinux:2

# Install prerequisite packages:
RUN amazon-linux-extras enable epel
RUN yum clean metadata
RUN yum -y install wget ca-certificates epel-release shadow-utils

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install app-protect-compiler \
    && yum clean all \
    && rm -rf /var/cache/yum
```

### Debian 10 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Debian 10:
FROM debian:buster

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget https://cs.nginx.com/static/keys/nginx_signing.key && apt-key add nginx_signing.key \
    && wget https://cs.nginx.com/static/keys/app-protect-security-updates.key && apt-key add app-protect-security-updates.key

# Add NGINX App Protect WAF repositories:
RUN printf "deb https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && printf "deb https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx

# Update the repository and install the most recent version of the NGINX App Protect WAF Compiler package:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && apt-get install -y app-protect-compiler

CMD ["sh"]
```

### Debian 11 / Debian 12 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Debian 11:
FROM debian:bullseye/bookworm

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add NGINX App Protect WAF repositories:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list 
RUN printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the NGINX App Protect WAF Compiler package:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-compiler
```

### Ubuntu 18.04 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 Converter Docker Deployment Example

```dockerfile
ARG OS_CODENAME
# Where OS_CODENAME can be: bionic/focal/jammy/noble
# syntax=docker/dockerfile:1
# For Ubuntu 18.04 / 20.04 /22.04 / 24.04:
FROM ubuntu:${OS_CODENAME}

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing keys:
RUN wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | \
    gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add NGINX App Protect WAF repositories:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list 
RUN printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \ 
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/app-protect-security-updates.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the NGINX App Protect WAF Compiler package:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-compiler
```

### Alpine 3.16 / Alpine 3.17 / Alpine 3.19 Converter Docker Deployment Example

```dockerfile
# syntax=docker/dockerfile:1
# For Alpine 3.16/3.17/3.19:
FROM alpine:3.19

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub \
 && wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub

# Add NGINX Plus repository:
RUN printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories \
 && printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Update the repository and install the most recent version of the NGINX App Protect WAF Compiler package:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    apk update && apk add app-protect-compiler
```

## Offline Installation

To perform an offline installation of NGINX App Protect WAF you can use a host with access to the NGINX repository to download all the packages (including dependencies) to your local repository.

### Example Deployment for CentOS/RHEL

#### Add the NGINX App Protect WAF Packages to an Internal Repository

On a host with access to the NGINX App Protect WAF repository:

1. Install the `downloadonly` plugin for Yum:

    ```shell
    yum -y install yum-plugin-downloadonly
    ```

2. Download all NGINX App Protect WAF packages, including all dependencies:

    ```shell
    mkdir -p /etc/packages/
    yum install --downloadonly --downloaddir=/etc/packages/ app-protect
    ```

3. Download the `epel-release` dependency package:

    For CentOS:

    ```shell
    yum install --downloadonly --downloaddir=/etc/packages/ epel-release
    ```

    For RHEL 7:

    ```shell
    wget -P /etc/packages https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    ```

    For RHEL 8.1+ / Oracle Linux 8.1+:

    ```shell
    wget -P /etc/packages https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    ```

    For RHEL 9+:

    ```shell
    wget -P /etc/packages https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    ```

4. Add the packages in `/etc/packages` to your local repository.


#### Install NGINX App Protect WAF from an Internal Repository

On an offline host:

1. Add your internal repository configuration.
2. Install NGINX App Protect WAF:

    ```shell
    yum -y install app-protect
    ```

### Example Deployment for Debian/Ubuntu

#### Add the NGINX App Protect WAF Packages to an Internal Repository

On a host with access to the NGINX App Protect WAF repository:

1. Download all NGINX App Protect WAF packages, including all dependencies:

    ```shell
    mkdir -p /etc/packages/
    cd /etc/packages/
    apt-get update
    for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect | grep "^\w" | sort -u); do apt-get download $i 2>>errors.txt; done
    ```

2. Add the packages in `/etc/packages` to your local repository.


#### Install NGINX App Protect WAF from an Internal Repository

On an offline host:

1. Add your internal repository configuration.
2. Install NGINX App Protect WAF:

    ```shell
    apt-get update
    apt-get install -y app-protect
    ```

## Post-Installation Checks

You can run the following commands to ensure that NGINX App Protect WAF enforcement is operational.

1. Check that the three processes needed for NGINX App Protect WAF are running using `ps aux`:
    - bd-socket-plugin
    - nginx: master process
    - nginx: worker process

    ```none
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root         8  1.3  2.4 3486948 399092 ?      Sl   09:11   0:02 /usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config
    root        14  0.0  0.1  71060 26680 ?        S    09:11   0:00 nginx: master process /usr/sbin/nginx -c /tmp/policy/test_nginx.conf -g daemon off;
    root        26  0.0  0.3  99236 52092 ?        S    09:12   0:00 nginx: worker process
    root        28  0.0  0.0  11788  2920 pts/0    Ss   09:12   0:00 bash
    root        43  0.0  0.0  47460  3412 pts/0    R+   09:14   0:00 ps aux
    ```

2. Verify that there are no NGINX errors in the `/var/log/nginx/error.log` and that the policy compiled successfully:

    ```none
    2020/05/10 13:21:04 [notice] 402#402: APP_PROTECT { "event": "configuration_load_start", "configSetFile": "/opt/f5waf/config/config_set.json" }
    2020/05/10 13:21:04 [notice] 402#402: APP_PROTECT policy 'app_protect_default_policy' from: /etc/app_protect/conf/NginxDefaultPolicy.json compiled successfully
    2020/05/10 13:21:04 [notice] 402#402: APP_PROTECT { "event": "configuration_load_success", "software_version": "1.1.1", "attack_signatures_package":{"revision_datetime":"2019-07-16T12:21:31Z"},"completed_successfully":true}
    2020/05/10 13:21:04 [notice] 402#402: using the "epoll" event method
    2020/05/10 13:21:04 [notice] 402#402: nginx/1.17.6 (nginx-plus-r20)
    2020/05/10 13:21:04 [notice] 402#402: built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)
    2020/05/10 13:21:04 [notice] 402#402: OS: Linux 3.10.0-957.27.2.el7.x86_64
    2020/05/10 13:21:04 [notice] 402#402: getrlimit(RLIMIT_NOFILE): 1048576:1048576
    2020/05/10 13:21:04 [notice] 406#406: start worker processes
    2020/05/10 13:21:04 [notice] 406#406: start worker process 407
    ```

3. Check that sending an attack signature in a request returns a response block page containing a support ID:

    ```none
    Request:
    http://10.240.185.211/?a=<script>

    Response:
    The requested URL was rejected. Please consult with your administrator.

    Your support ID is: 9847191526422998597

    [Go Back]
    ```

4. In case your policy includes JSON/XML profiles, please check `/var/log/app_protect/bd-socket-plugin.log` and make sure there aren't any errors by running:

    ```none
    grep '|ERR' /var/log/app_protect/bd-socket-plugin.log
    ```

    If you see an error similar to:

    ```none
    ... Cannot allocate 196744 more bytes for XML parser. current memory size 307089520 (in bytes) ...
    ```

    Increase the `bd-socket-plugin` process command line variable `total_xml_memory` in the `startup.sh` script or in the `nginx-app-protect.service` file.

    The NGINX App Protect's unit file can be modified with the following command:

    ```none
    sudo systemctl edit --full nginx-app-protect.service
    ```

    The file itself is located at `/lib/systemd/system/` in deb packages, at `/usr/lib/systemd/system/` in rpm
    packages.

    The number `471859200` should be enough for most use cases, you may need to use a bigger number if the number of profiles is large, or large json/xml schemas are used in the policy.

5. If there are additional problems, refer to the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#app-protect-troubleshooting-overview" >}}).


## Attack Signatures Dependency Change in NGINX App Protect WAF

Starting with release 3.12 there is a change in dependency of the Attack Signatures package. Until release 3.11, NGINX App Protect WAF used pre-packaged Attack Signatures that did not provide the latest Attack Signatures. <br>

From version 3.12, when the user performs the clean install (installing NGINX App Protect WAF for the first time), it will install the latest Attack Signatures package. This will keep the customers up to date with the latest Attack Signatures and provide protection against the latest threats. <br>

The way to achieve the goal of better protection will use the package dependency mechanism so the app protect package will be dependent on the signatures package thus ensuring that the latest signatures package is deployed once the app protect release is deployed for the first time.<br>

In case the user has an older version of NGINX App Protect WAF and never installed the Attack Signatures package, upgrading NGINX App Protect WAF will install the latest Attack Signatures. However, if they have installed Attack Signatures package previously at any point in time, NGINX App Protect WAF will not install the latest Attack Signatures.

{{< note >}}The user can upgrade or downgrade the Attack Signatures regardless of the installed version of NGINX App Protect WAF.{{< /note >}}

### Attack Signatures Package
The attack signature package is named: app-protect-attack-signatures-2022.08.04. The version number for this package reflects the date the package was released. The format is: _YYYY.MM.DD_ where:

- YYYY is the 4-digit year
- MM is the month
- DD is the day in the month

Example: app-protect-attack-signatures-2022.08.04

## Updating App Protect Attack Signatures

Attack Signatures updates are released at higher frequency than App Protect, therefore they are released in their own package, separate from the App Protect package. You can update the attack signatures without updating the App Protect release, and conversely, you can update App Protect without changing the attack signature package, unless you move to a new NGINX Plus release.

### Installing Attack Signature Update

After having updated the Attack Signature package you have to reload the configuration in order for the new version of the Signatures to take effect. Until then App Protect will run with the old version. That is useful when creating an environment with a specific tested version of the Attack Signatures.


### CentOS / RHEL 7.4+ / Amazon Linux 2

1. To add NGINX App Protect WAF Security Updates repository, download the file `app-protect-7.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

2. Update the attack signatures to the latest:

    ```shell
    sudo yum install app-protect-attack-signatures
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo yum --showduplicates list app-protect-attack-signatures
    ```

    To upgrade to a specific version:

    ```shell
    sudo yum install app-protect-attack-signatures-2020.04.30
    ```

    To downgrade to a specific version:

    ```shell
    sudo yum downgrade app-protect-attack-signatures-2019.07.16
    ```

### RHEL 8.1+ / Oracle Linux 8.1+

1. To add NGINX App Protect WAF Security Updates repository, download the file `app-protect-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
    ```

2. Update the attack signatures to the latest:

    ```shell
    sudo dnf install app-protect-attack-signatures
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-attack-signatures
    ```

    To upgrade to a specific version:

    ```shell
    sudo dnf install app-protect-attack-signatures-2021.12.30
    ```

    To downgrade to a specific version:

    ```shell
    sudo dnf downgrade app-protect-attack-signatures-2019.07.16
    ```

### RHEL 9+

1. To add NGINX App Protect WAF Security Updates repository, download the file `app-protect-9.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
    ```

2. Update the attack signatures to the latest:

    ```shell
    sudo dnf install app-protect-attack-signatures
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-attack-signatures
    ```

    To upgrade to a specific version:

    ```shell
    sudo dnf install app-protect-attack-signatures-2023.12.11
    ```

    To downgrade to a specific version:

    ```shell
    sudo dnf downgrade app-protect-attack-signatures-2023.12.11
    ```

### Debian 10 / Debian 11 / Debian 12

1. Add NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

2. Download and add the NGINX App Protect WAF signatures signing key:

    ```shell
    sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

3. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

4. Update the attack signatures to the latest:

    ```shell
    sudo apt-get update && sudo apt-get install app-protect-attack-signatures
    ```

5. To install a specific version, list the available versions:

    ```shell
    sudo apt-cache policy app-protect-attack-signatures
    ```

    Install a specific version:

    For Debian 10:

    ```shell
    sudo apt-get install app-protect-attack-signatures=2020.04.30-1~buster
    ```

    For Debian 11:

     ```shell
    sudo apt-get install app-protect-attack-signatures=2020.04.30-1~bulleye
    ```

    For Debian 12:

     ```shell
    sudo apt-get install app-protect-attack-signatures=2020.04.30-1~bookworm
    ```

### Ubuntu 18.04 / Ubuntu 20.04 / Ubuntu 22.04

1. Add NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

2. Download and add the NGINX App Protect WAF signatures signing key:

    ```shell
    sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

3. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

4. Update the attack signatures to the latest:

    ```shell
    sudo apt-get update && sudo apt-get install app-protect-attack-signatures
    ```

5. To install a specific version, list the available versions:

    ```shell
    sudo apt-cache policy app-protect-attack-signatures
    ```

    Install a specific version:

    For Ubuntu 18.04:

    ```shell
    sudo apt-get install app-protect-attack-signatures=2020.07.16-1~bionic
    ```

    For Ubuntu 20.04:

    ```shell
    sudo apt-get install app-protect-attack-signatures=2020.07.16-1~focal
    ```

    For Ubuntu 22.04:

    ```shell
    sudo apt-get install app-protect-attack-signatures=2020.07.16-1~jammy
    ```

    For Ubuntu 24.04:

    ```shell
    sudo apt-get install app-protect-attack-signatures=2020.07.16-1~noble
    ```

### Alpine 3.16 / Alpine 3.17 / Alpine 3.19

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

2. If not already downloaded, download and add the NGINX App Protect WAF Security Updates signing key:

    ```shell
    sudo wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub
    ```

3. Update the attack signatures:

    To install the latest version, first update the packages:

    ```shell
    sudo apk update && sudo apk add app-protect-attack-signatures
    ```

    To install a specific version, list the available versions:

    ```shell
    sudo apk search app-protect-attack-signatures
    ```

    Finally, install the latest version from the output:

    ```shell
    sudo apk add app-protect-attack-signatures=2023.08.03-r1
    ```


### Attack Signatures When Upgrading NGINX App Protect WAF

Upgrading App Protect does _not_ install new Attack Signatures. You will get the same Attack Signature release after upgrading App Protect. If you want to also upgrade the Attack Signatures, you will have to explicitly update them by the respective command above.

### Threat Campaigns Dependency Change in NGINX App Protect WAF

Starting with release 3.12 there is a change in dependency of the Threat Campaigns package. Until release 3.11, App Protect installation did not come with a built-in Threat Campaigns package like Attack Signatures. <br>

From version 3.12, when the user performs the clean install (installing NGINX App Protect WAF for the first time), it will install the latest Threat Campaigns package. This will keep the customers up to date with the latest Threat Campaigns and provide protection against the latest threats. <br>

The way to achieve the goal of better protection will use the package dependency mechanism so the app protect package will be dependent on the Threat Campaigns package thus ensuring that the latest Threat Campaigns package is deployed once the app protect release is deployed for the first time.<br>

In case the user has an older version of NGINX App Protect WAF and never installed the Threat Campaigns package, upgrading NGINX App Protect will install the latest Threat Campaigns. However, if they have installed Threat Campaigns package previously at any point in time, NGINX App Protect WAF will not install the latest Threat Campaigns.

{{< note >}}The user can upgrade or downgrade the Threat Campaigns regardless of the installed version of NGINX App Protect WAF.{{< /note >}}

### Installing Threat Campaigns Update

Until release 3.11 App Protect installation did not come with a built-in Threat Campaigns package like Attack Signatures. Threat Campaigns Updates are released periodically whenever new campaigns and vectors are discovered, so you might want to update your Threat Campaigns from time to time. You can upgrade the Threat Campaigns by updating the package any time after installing App Protect. We recommend you upgrade to the latest Threat Campaigns version right after installing App Protect.

After having updated the Threat Campaigns package you have to reload the configuration in order for the new version of the Threat Campaigns to take effect. Until then App Protect will run with the old version, if one exists. This is useful when creating an environment with a specific tested version of the Threat Campaigns.

## Updating App Protect Threat Campaigns

The Threat Campaigns feature is described [here]({{< relref "/nap-waf/v4/configuration-guide/configuration.md#threat-campaigns" >}}).

The Threat Campaigns package is named: app-protect-threat-campaigns-2022.07.21. The version number for this package reflects the date the package was released. The format is: _YYYY.MM.DD_ where:

- YYYY is the 4-digit year
- MM is the month
- DD is the day in the month

Example: app-protect-threat-campaigns-2022.07.21


### CentOS / RHEL 7.4+ / Amazon Linux 2

1. If not already configured, add NGINX App Protect WAF Security Updates repository by downloading the file `app-protect-7.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

2. Update Threat Campaigns  to the latest:

    ```shell
    sudo yum install app-protect-threat-campaigns
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo yum --showduplicates list app-protect-threat-campaigns
    ```

    To upgrade to a specific version:

    ```shell
    sudo yum install app-protect-threat-campaigns-2022.07.21
    ```

### RHEL 8.1+ / Oracle Linux 8.1+

1. If not already configured, add NGINX App Protect WAF Security Updates repository by downloading the file `app-protect-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
    ```

2. Update Threat Campaigns to the latest:

    ```shell
    sudo dnf install app-protect-threat-campaigns
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-threat-campaigns
    ```

    To upgrade to a specific version:

    ```shell
    sudo dnf install app-protect-threat-campaigns-2022.07.21
    ```

### RHEL 9+

1. If not already configured, add NGINX App Protect WAF Security Updates repository by downloading the file `app-protect-9.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
    ```

2. Update Threat Campaigns to the latest:

    ```shell
    sudo dnf install app-protect-threat-campaigns
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-threat-campaigns
    ```

    To upgrade to a specific version:

    ```shell
    sudo dnf install app-protect-threat-campaigns-2023.12.11
    ```

### Alpine 3.16 / Alpine 3.17 / Alpine 3.19

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

2. If not already downloaded, download and add the NGINX App Protect WAF Security Updates signing key:

    ```shell
    sudo wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub
    ```

3. Update Threat Campaigns to the latest:

    ```shell
    sudo apk update && sudo apk add app-protect-threat-campaigns
    ```

4. To install a specific version, list the available versions:

    ```shell
    sudo apk search app-protect-threat-campaigns
    ```

    Finally, install the latest version from the output:

    ```shell
    sudo apk add app-protect-threat-campaigns=2023.08.09-r1
    ```

### Debian 10 / Debian 11 / Debian 12

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

2. Download and add the NGINX App Protect WAF Threat Campaigns signing key:

    ```shell
    sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

3. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

4. Update Threat Campaigns to the latest:

    ```shell
    sudo apt-get update && sudo apt-get install app-protect-threat-campaigns
    ```

5. To install a specific version, list the available versions:

    ```shell
    sudo apt-cache policy app-protect-threat-campaigns
    ```

    Install a specific version:

    For Debian 10:

    ```shell
    sudo apt-get install app-protect-threat-campaigns=2020.06.25-1~buster
    ```

    For Debian 11:

    ```shell
    sudo apt-get install app-protect-threat-campaigns=2020.06.25-1~bullseye
    ```

      For Debian 12:

    ```shell
    sudo apt-get install app-protect-threat-campaigns=2020.06.25-1~bookworm
    ```

### Ubuntu 18.04 / Ubuntu 20.04 / Ubuntu 22.04

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

2. Download and add the NGINX App Protect WAF Threat Campaigns signing key:

    ```shell
    sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

3. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

4. Update Threat Campaigns to the latest:

    ```shell
    sudo apt-get update && sudo apt-get install app-protect-threat-campaigns
    ```

5. To install a specific version, list the available versions:

    ```shell
    sudo apt-cache policy app-protect-threat-campaigns
    ```

    Install a specific version:

    For Ubuntu 18.04:

    ```shell
    sudo apt-get install app-protect-threat-campaigns=2020.08.05-1~bionic
    ```

    For Ubuntu 20.04:

    ```shell
    sudo apt-get install app-protect-threat-campaigns=2020.08.05-1~focal
    ```

    For Ubuntu 22.04:

    ```shell
    sudo apt-get install app-protect-threat-campaigns=2020.08.05-1~jammy
    ```

    For Ubuntu 24.04:

    ```shell
    sudo apt-get install app-protect-attack-signatures=2024.06.26-1~noble
    ```

## Updating App Protect Bot Signatures

The App Protect Bot Signatures feature is described [here]({{< relref "/nap-waf/v4/configuration-guide/configuration.md#bot-signatures" >}}).<br>

The App Protect Bot Signatures is named: app-protect-bot-signatures and it is a dependency similar to attack signatures and threat campaigns and can be updated more often. The version number for this package reflects the date the package was released. For example: app-protect-bot-signatures-2023.11.14, where the format for app protect bot signatures is: YYYY.MM.DD.


### CentOS / RHEL 7.4+ / Amazon Linux 2

1. If not already configured, add NGINX App Protect WAF Security Updates repository by downloading the file `app-protect-7.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
    ```

2. Update bot signatures to the latest:

    ```shell
    sudo yum install app-protect-bot-signatures
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo yum --showduplicates list app-protect-bot-signatures
    ```

    To upgrade to a specific version:

    ```shell
    sudo yum install app-protect-bot-signatures-2023.11.14
    ```

    To downgrade to a specific version:

    ```shell
    sudo yum downgrade app-protect-bot-signatures-2023.11.14
    ```

### RHEL 8.1+ / Oracle Linux 8.1+

1. If not already configured, add NGINX App Protect WAF Security Updates repository by downloading the file `app-protect-8.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
    ```

2. Update Bot Signatures to the latest:

    ```shell
    sudo dnf install app-protect-bot-signatures
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-bot-signatures
    ```

    To upgrade to a specific version:

    ```shell
    sudo dnf install app-protect-bot-signatures-2023.11.14
    ```

    To downgrade to a specific version:

    ```shell
    sudo dnf downgrade app-protect-bot-signatures-2023.11.14
    ```

### RHEL 9+

1. If not already configured, add NGINX App Protect WAF Security Updates repository by downloading the file `app-protect-9.repo` to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
    ```

2. Update Bot Signatures to the latest:

    ```shell
    sudo dnf install app-protect-bot-signatures
    ```

3. To install a specific version, list the available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-bot-signatures
    ```

    To upgrade to a specific version:

    ```shell
    sudo dnf install app-protect-bot-signatures-2023.12.11
    ```

    To downgrade to a specific version:

    ```shell
    sudo dnf downgrade app-protect-bot-signatures-2023.12.11
    ```

### Alpine 3.16 / Alpine 3.17 / Alpine 3.19

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

2. If not already downloaded, download and add the NGINX App Protect WAF Security Updates signing key:

    ```shell
    sudo wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub
    ```

3. Update Bot Signatures to the latest:

    ```shell
    sudo apk update && sudo apk add app-protect-bot-signatures
    ```

4. To install a specific version, list the available versions:

    ```shell
    sudo apk search app-protect-bot-signatures
    ```

    Finally, install the latest version from the output:

    ```shell
    sudo apk add app-protect-bot-signatures=2023.11.14
    ```


### Debian 11 / Debian 12

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

2. Download and add the NGINX App Protect WAF Bot Signatures signing key:

    ```shell
    sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

3. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

4. Update Bot Signatures to the latest:

    ```shell
    sudo apt-get update && sudo apt-get install app-protect-bot-signatures
    ```

5. To install a specific version, list the available versions:

    ```shell
    sudo apt-cache policy app-protect-bot-signatures
    ```

    Install a specific version:

    For Debian 11:

    ```shell
    sudo apt-get install app-protect-bot-signatures=2023.11.14~bullseye
    ```

     For Debian 12:

    ```shell
    sudo apt-get install app-protect-bot-signatures=2023.11.14~bookworm
    ```


### Ubuntu 20.04 / Ubuntu 22.04

1. If not already configured, add the NGINX App Protect WAF Security Updates repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
    ```

2. Download and add the NGINX App Protect WAF Bot Signatures signing key:

    ```shell
    sudo wget https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
    ```

3. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

4. Update Bot Signatures to the latest:

    ```shell
    sudo apt-get update && sudo apt-get install app-protect-bot-signatures
    ```

5. To install a specific version, list the available versions:

    ```shell
    sudo apt-cache policy app-protect-bot-signatures
    ```

    Install a specific version:

    For Ubuntu 20.04:

    ```shell
    sudo apt-get install app-protect-bot-signatures=2023.11.14~focal
    ```

    For Ubuntu 22.04:

    ```shell
    sudo apt-get install app-protect-bot-signatures=2023.11.14~jammy
    ```

    For Ubuntu 24.04:

    ```shell
    sudo apt-get install app-protect-bot-signatures=2024.06.23~noble
    ```


## Upgrading App Protect

You can upgrade to the latest NGINX Plus and App Protect 4.x versions by downloading and installing the latest NGINX App Protect WAF 4.x package. When upgrading from this package, App Protect will be uninstalled and reinstalled. The old default security policy is deleted and the new default security policy is installed. If you have created a custom security policy, the policy persists and you will need to update `nginx.conf` and point to the custom security policy by referencing the json file (using the full path).

After upgrading the NGINX App Protect WAF version, restart NGINX manually:

```shell
sudo systemctl restart nginx
```

In case of using the prebuilt SELinux policy module for NGINX App Protect WAF (app-protect-selinux) - upgrade it by installing the latest 4.x available version.

## Uninstall App Protect

You can uninstall the App Protect in below Operating Systems by using the following commands:

### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

```shell
sudo yum remove app-protect \
app-protect-compiler \
app-protect-plugin \
app-protect-engine \
app-protect-graphql \
app-protect-geoip \
app-protect-common \
app-protect-attack-signatures \
app-protect-threat-campaigns \
app-protect-bot-signatures \
app-protect-selinux
```

### RHEL 8.1+ / Oracle Linux 8.1+ / RHEL 9+

```shell
sudo dnf remove app-protect app-protect-selinux
```

### Debian 11 / Debian 12 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04

```shell
sudo apt-get remove app-protect \
app-protect-plugin \
app-protect-engine \
app-protect-graphql \
app-protect-geoip \
app-protect-compiler \
app-protect-common \
app-protect-attack-signatures \
app-protect-threat-campaigns \
app-protect-bot-signatures
```

### Alpine 3.16 / Alpine 3.17 / Alpine 3.19

```shell
sudo apk del app-protect \
app-protect-plugin \
app-protect-engine \
app-protect-graphql \
app-protect-geoip \
app-protect-compiler \
app-protect-common \
app-protect-attack-signatures \
app-protect-threat-campaigns \
app-protect-bot-signatures
```

## Upgrading App Protect to a Specific Version

### CentOS / RHEL 7.4.x / Amazon Linux 2

1. Upgrade the NGINX App Protect WAF to the specific version:

    ```shell
    sudo yum -y update app-protect-27+3.1088.0-1
    ```

### RHEL 8.1+ / Oracle Linux 8.1+ / Rhel 9+

1. Upgrade the NGINX App Protect WAF to the specific version:

    ```shell
    sudo dnf -y update app-protect-27+3.1088.0-1
    ```

### Debian 10 / Debian 11 / Debian 12

1. Get the dependencies and their versions to be upgraded to by using the command:

    ```shell
    findDeps () { local pkgs=$(apt show $1 2>/dev/null | grep Depends: | grep -oE "(nginx-plus-module|app-protect)-[a-z]+ *\(= *[0-9\+\.-]+~`lsb_release -cs`\)" | tr -d ' ()'); for p in ${pkgs[@]}; do echo $p; findDeps $p; done; }
    findDeps app-protect=27+3.1088.2-1~[OS_CODENAME]
    ```

2. Upgrade the NGINX App Protect WAF to the specific version:

    ```shell
    sudo apt-get update && apt-get install -y app-protect-common=10.139.2-1~[OS_CODENAME]
    app-protect-compiler=10.139.2-1~[OS_CODENAME] \
    app-protect-plugin=3.1088.2-1~[OS_CODENAME] \
    nginx-plus-module-appprotect=27+3.1088.2-1~[OS_CODENAME] \
    app-protect-engine=10.139.2-1~[OS_CODENAME] \
    app-protect=27+3.1088.2-1~[OS_CODENAME]
    ```

    **Note**: Replace the [OS_CODENAME] in the above command with: **buster** for Debian 10, **bullseye** for Debian 11 and **bookworm** for Debian 12.

### Ubuntu 18.04 / Ubuntu 20.04 / Ubuntu 22.04

1. Get the dependencies and their versions to be upgraded to by using the command:

    ```shell
    findDeps () { local pkgs=$(apt show $1 2>/dev/null | grep Depends: | grep -oE "(nginx-plus-module|app-protect)-[a-z]+ *\(= *[0-9\+\.-]+~`lsb_release -cs`\)" | tr -d ' ()'); for p in ${pkgs[@]}; do echo $p; findDeps $p; done; }
    findDeps app-protect=27+3.1088.2-1~[OS_CODENAME]
    ```

2. Upgrade the NGINX App Protect WAF to the specific version:

    ```shell
    sudo apt-get update && apt-get install -y app-protect-common=10.139.2-1~[OS_CODENAME]
    app-protect-compiler=10.139.2-1~[OS_CODENAME] \
    app-protect-plugin=3.1088.2-1~[OS_CODENAME] \
    nginx-plus-module-appprotect=27+3.1088.2-1~[OS_CODENAME] \
    app-protect-engine=10.139.2-1~[OS_CODENAME] \
    app-protect=27+3.1088.2-1~[OS_CODENAME]
    ```

    **Note**: Replace the [OS_CODENAME] in the above command with: **bionic** for Ubuntu 18.04, **focal** for Ubuntu 20.04, **jammy** for Ubuntu 22.04 and **noble** for Ubuntu 24.04.


## Upgrading App Protect to the latest version

### CentOS / RHEL 7.4.x / Amazon Linux 2

- Upgrade the NGINX App Protect WAF to the latest 4.x version:

    ```shell
    sudo yum -y update app-protect
    ```

### RHEL 8.1+ / Oracle Linux 8.1+ / RHEL 9+

- Upgrade the NGINX App Protect WAF to the latest 4.x version:

    ```shell
    sudo dnf -y update app-protect
    ```

### Debian 10 / Debian 11 / Debian 12 / Ubuntu 18.04 / Ubuntu 20.04 / Ubuntu 22.04

- Upgrade the NGINX App Protect WAF to the latest 4.x version:

    ```shell
    sudo apt-get update && apt-get install -y app-protect
    ```

## SELinux Configuration

The default settings for Security-Enhanced Linux (SELinux) on modern Red Hat Enterprise Linux (RHEL) and related distros can be very strict, erring on the side of security rather than convenience.

Although the NGINX App Protect WAF provides an optional package with prebuilt SELinux policy module - `app-protect-selinux`, your specific configuration might be blocked unless you adjust the policy or modify file labels.

### Modifying File Labels

For example, if you plan to store your security policy files in `/etc/security_policies` - you should change the default SELinux file context for this directory:

```shell
semanage fcontext -a -t nap-compiler_conf_t /etc/security_policies
restorecon -Rv /etc/security_policies
```

### Syslog to Custom Port

If you want to send logs to some unreserved port, you can use `semanage` to add the desired port (here, 35514) to the syslogd_port_t type:

```shell
semanage port -a -t syslogd_port_t -p tcp 35514
```

Review the syslog ports by entering the following command:

```shell
semanage port -l | grep syslog
```

If there are additional problems, refer to the [Troubleshooting Guide]({{< relref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).
