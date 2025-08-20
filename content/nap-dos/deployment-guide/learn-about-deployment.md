---
description: Learn about F5 NGINX App Protect DoS Deployment.
nd-docs: DOCS-666
title: NGINX App Protect DoS Deployment
toc: true
weight: 100
type:
- how-to
---

## Overview

F5 NGINX App Protect DoS provides behavioral protection against DoS for your web applications. <br><br>
This guide explains how to deploy NGINX App Protect DoS as well as upgrade App Protect DoS.

## Prerequisites

NGINX App Protect DoS is available to the customers as a downloadable dynamic module at an additional cost. To purchase or add NGINX App Protect DoS to an existing NGINX Plus subscription, contact the NGINX sales team.

NGINX Plus Release 24 and later supports NGINX App Protect DoS.

NGINX App Protect DoS supports the following operating systems:

- [RHEL 8.1+ / Rocky Linux 8](#rhel-8--rocky-linux-8-installation)
- [RHEL 9.0+ / Rocky Linux 9](#rhel-9--rocky-linux-9-installation)
- [Debian 11 (Bullseye)](#debian--ubuntu-installation)
- [Debian 12 (Bookworm)](#debian--ubuntu-installation)
- [Ubuntu 20.04 (Focal)](#debian--ubuntu-installation) - (Deprecated starting from NGINX Plus R35)
- [Ubuntu 22.04 (Jammy)](#debian--ubuntu-installation)
- [Ubuntu 24.04 (Noble)](#debian--ubuntu-installation)
- [Alpine 3.19](#alpine-installation)
- [Alpine 3.21](#alpine-installation)
- [AmazonLinux 2023](#amazon-linux-2023-installation)


The NGINX App Protect DoS package has the following dependencies:

1. **nginx-plus-module-appprotectdos** - NGINX Plus dynamic module for App Protect DoS
2. **libcurl** - Software library for HTTP access
3. **zeromq4** - Software library for fast, message-based applications
4. **boost** - The free peer-reviewed portable C++ source libraries
5. **openssl** - Toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocol
6. **libelf** - Software library for ELF access

See the NGINX Plus full list of prerequisites for more details. NGINX App Protect DoS can be installed as a module to an existing NGINX Plus installation or as a complete NGINX Plus with App Protect DoS installation in a clean environment or to a system with NGINX App Protect WAF.

{{< call-out "note" >}}

- gRPC, HTTP/2 and WebSocket protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for the attack to be detected.
- Monitor directive `app_protect_dos_monitor` with proxy_protocol parameter can not be configured on Ubuntu 18.04. As a result, gRPC and HTTP/2 DoS protection for proxy_protocol configuration is not supported.
- Regularly update the Operating System (OS) to avoid known OS vulnerabilities which may impact the service.
{{< /call-out >}}

## Platform Security Considerations

When deploying App Protect DoS on NGINX Plus take the following precautions to secure the platform. This avoids the risk of causing a Denial of Service condition or compromising the platform security.

- Restrict permissions to the files on the NGINX App Protect DoS platform to user **nginx** and group **nginx**, especially for the sensitive areas containing the configuration.
- Remove unnecessary remote access services on the platform.
- Configure a Syslog destination on the same machine as App Protect DoS and proxy to an external destination. This avoids eavesdropping and [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attacks on the Syslog channel.

## CentOS 7.4+ Installation

{{< call-out "note" >}}CentOS 7.4 and RHEL 7.4 are deprecated as of NGINX Plus Release 32 (R32) and are not supported in Release 33 (R33) or later. For the list of supported distributions, refer to the [NGINX Plus Tech Specs]({{< relref "nginx/technical-specs.md" >}}).{{< /call-out >}}

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the NGINX [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the CentOS server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo yum install ca-certificates epel-release wget
    ```

6. Add NGINX Plus and NGINX App Protect DoS repository:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-7.repo
    ```

7. In case of fresh installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo yum install app-protect-dos
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo yum --showduplicates list app-protect-dos
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo yum install app-protect-dos-27+2.4.0
    ```

8. In case of upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo yum remove nginx-plus
    sudo yum install app-protect-dos
    sudo systemctl start nginx
    ```

    {{< call-out "note" >}} Make sure to restore configuration from `/etc/nginx-plus-backup` back to `/etc/nginx-plus`.{{< /call-out >}}

9. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

10. Check the NGINX App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

11. Load the NGINX App Protect DoS module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

12. Enable NGINX App Protect DoS on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

13. Configure the SELinux to allow NGINX App Protect DoS:

    a. Using the vi editor, create a file:

    ```shell
    vi app-protect-dos.te
    ```

    b. Insert the following contents into the file created above:

    ```shell
    module app-protect-dos 2.0;
    require {
        type unconfined_t;
        type unconfined_service_t;
        type httpd_t;
        type tmpfs_t;
        type initrc_t;
        type initrc_state_t;
        class capability sys_resource;
        class shm { associate read unix_read unix_write write };
        class file { read write };
    }
    allow httpd_t initrc_state_t:file { read write };
    allow httpd_t self:capability sys_resource;
    allow httpd_t tmpfs_t:file { read write };
    allow httpd_t unconfined_service_t:shm { associate read unix_read unix_write write };
    allow httpd_t unconfined_t:shm { associate read write unix_read unix_write };
    allow httpd_t initrc_t:shm { associate read unix_read unix_write write };
    ```

    c. Run the following chain of commands:

    ```shell
    sudo checkmodule -M -m -o app-protect-dos.mod app-protect-dos.te
    sudo semodule_package -o app-protect-dos.pp -m app-protect-dos.mod
    sudo semodule -i app-protect-dos.pp;
    ```

    If you encounter any issues, refer to the [Troubleshooting Guide]({{< ref "/nap-dos/troubleshooting-guide/how-to-troubleshoot.md" >}}).

    {{< call-out "note" >}}Additional SELinux configuration may be required to allow NGINX Plus to listen on specific network ports, connect to upstreams, and send syslog entries to remote systems. Refer to the practices outlined in the [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) article for details.{{< /call-out >}}

14. To enable the NGINX/App-Protect-DoS service to start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

15. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## RHEL 7.4+ Installation

{{< call-out "note" >}}CentOS 7.4 and RHEL 7.4 are deprecated as of NGINX Plus Release 32 (R32) and are not supported in Release 33 (R33) or later. For the list of supported distributions, refer to the [NGINX Plus Tech Specs]({{< relref "nginx/technical-specs.md" >}}).{{< /call-out >}}
1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

3. Log in to the NGINX [Customer Portal](https://my.f5.com) and download the following two files:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

4. Copy the above two files to the CentOS server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

    ```shell
    sudo yum install ca-certificates wget

6. Enable Yum repositories to pull App Protect DoS dependencies:

    If you have a RHEL subscription:

    ```shell
     sudo subscription-manager repos --enable rhel-*-optional-rpms \
                                     --enable rhel-*-extras-rpms \
                                     --enable rhel-ha-for-rhel-*-server-rpms
     yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    ```

    If you don’t have a RHEL subscription, you can pull the dependencies from the CentOS repository: Create a new repository centos.repo in `/etc/yum.repos.d/` with the content:

    ```shell
    [centos]
    name=CentOS-7
    baseurl=http://ftp.heanet.ie/pub/centos/7/os/x86_64/
    enabled=1
    gpgcheck=1
    gpgkey=http://ftp.heanet.ie/pub/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
    [epel]
    name=epel packages for CentOS/RHEL 7
    baseurl=https://dl.fedoraproject.org/pub/epel/7/x86_64
    enabled=1
    gpgcheck=1
    gpgkey=https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
    [extras]
    name=extras packages for CentOS/RHEL 7
    mirrorlist=http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=extras
    enabled=1
    gpgcheck=1
    gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
    ```

7. Add NGINX Plus and NGINX App Protect DoS repository:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-7.repo
    ```

8. In case of fresh installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo yum install app-protect-dos
    ```

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo yum --showduplicates list app-protect-dos
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo yum install app-protect-dos-27+2.4.0
    ```

9. In case of upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo yum remove nginx-plus
    sudo yum install app-protect-dos
    sudo systemctl start nginx
    ```

    {{< call-out "note" >}} Make sure to restore configuration from `/etc/nginx-plus-backup` back to `/etc/nginx-plus`.{{< /call-out >}}

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Check the App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

12. Load the NGINX App Protect DoS module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

13. Enable NGINX App Protect DoS on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

14. Configure the SELinux to allow NGINX App Protect DoS:

    a. Using the vi editor, create a file:

    ```shell
    vi app-protect-dos.te
    ```

    b. Insert the following contents into the file created above:

    ```shell
    module app-protect-dos 2.0;
    require {
        type unconfined_t;
        type unconfined_service_t;
        type httpd_t;
        type tmpfs_t;
        type initrc_t;
        type initrc_state_t;
        class capability sys_resource;
        class shm { associate read unix_read unix_write write };
        class file { read write };
    }
    allow httpd_t initrc_state_t:file { read write };
    allow httpd_t self:capability sys_resource;
    allow httpd_t tmpfs_t:file { read write };
    allow httpd_t unconfined_service_t:shm { associate read unix_read unix_write write };
    allow httpd_t unconfined_t:shm { associate read write unix_read unix_write };
    allow httpd_t initrc_t:shm { associate read unix_read unix_write write };
    ```

    c. Run the following chain of commands:

    ```shell
    sudo checkmodule -M -m -o app-protect-dos.mod app-protect-dos.te &&  \
    sudo semodule_package -o app-protect-dos.pp -m app-protect-dos.mod &&  \
    sudo semodule -i app-protect-dos.pp;
    ```

    If you encounter any issues, refer to the [Troubleshooting Guide]({{< ref "/nap-dos/troubleshooting-guide/how-to-troubleshoot.md" >}}).

    {{< call-out "note" >}}Additional SELinux configuration may be required to allow NGINX Plus to listen on specific network ports, connect to upstreams, and send syslog entries to remote systems. Refer to the practices outlined in the [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) article for details.{{< /call-out >}}

15. To enable the NGINX/App-Protect-DoS service to start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

16. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

## RHEL 8+ / Rocky Linux 8 Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-jwt.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

5. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget

6. Enable Yum repositories to pull NGINX App Protect DoS dependencies:

    If you have a RHEL subscription:

    ```shell
    sudo subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms
    sudo subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms
    sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    ```

7. Add NGINX Plus and NGINX App Protect DoS repository:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-8.repo
    ```

8. In case of fresh installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect-dos
    ```

    For L4 accelerated mitigation feature (RHEL 8.6+):

    ```shell
    sudo dnf install app-protect-dos-ebpf-manager
    ```

    {{< call-out "note" >}}
   L4 accelerated mitigation feature (RHEL 8.6+):
   - `app-protect-dos-ebpf-manager` run with root privileges.
    {{< /call-out >}}

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-dos
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-dos-27+2.4.0
    ```

9. In case of upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo dnf remove nginx-plus
    sudo dnf install app-protect-dos
    sudo systemctl start nginx
    ```

    {{< call-out "note" >}} Make sure to restore configuration from `/etc/nginx-plus-backup` back to `/etc/nginx-plus`.{{< /call-out >}}

1. {{< include "nginx-plus/install/check-nginx-binary-version.md" >}}

11. Check the App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

12. Load the NGINX App Protect DoS module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

13. Enable NGINX App Protect DoS in an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

14. Enable the L4 accelerated mitigation feature (RHEL 8.6+) in an `http` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_accelerated_mitigation on;
    ```

15. Configure the SELinux to allow App Protect DoS:

    a. Using the vi editor, create a file:

    ```shell
    vi app-protect-dos.te
    ```

    b. Insert the following contents into the file that you have created:

    ```shell
    module app-protect-dos 2.0;
    require {
        type unconfined_t;
        type unconfined_service_t;
        type httpd_t;
        type tmpfs_t;
        type initrc_t;
        type initrc_state_t;
        class capability sys_resource;
        class shm { associate read unix_read unix_write write };
        class file { read write };
    }
    allow httpd_t initrc_state_t:file { read write };
    allow httpd_t self:capability sys_resource;
    allow httpd_t tmpfs_t:file { read write };
    allow httpd_t unconfined_service_t:shm { associate read unix_read unix_write write };
    allow httpd_t unconfined_t:shm { associate read write unix_read unix_write };
    allow httpd_t initrc_t:shm { associate read unix_read unix_write write };
    ```

    c. Run the following chain of commands:

    ```shell
    sudo checkmodule -M -m -o app-protect-dos.mod app-protect-dos.te &&  \
    sudo semodule_package -o app-protect-dos.pp -m app-protect-dos.mod &&  \
    sudo semodule -i app-protect-dos.pp;
    ```

    For L4 accelerated mitigation feature:

    a. Using the vi editor, create a file:

    ```shell
    vi app-protect-dos-ebpf-manager.te
    ```

    b. Insert the following contents into the file you have created:

    ```shell
    module app-protect-dos-ebpf-manager 1.0;
        require {
        type root_t;
        type httpd_t;
        type unconfined_service_t;
        class sock_file write;
        class unix_stream_socket connectto;
        class shm { unix_read unix_write };
    }
    allow httpd_t root_t:sock_file write;
    allow httpd_t unconfined_service_t:shm { unix_read unix_write };
    allow httpd_t unconfined_service_t:unix_stream_socket connectto;
    ```

    c. Run the following chain of commands:

    ```shell
    sudo checkmodule -M -m -o app-protect-dos-ebpf-manager.mod app-protect-dos-ebpf-manager.te &&  \
    sudo semodule_package -o app-protect-dos-ebpf-manager.pp -m app-protect-dos-ebpf-manager.mod &&  \
    sudo semodule -i app-protect-dos-ebpf-manager.pp;
    ```

    If you encounter any issues, refer to the [Troubleshooting Guide]({{< ref "/nap-dos/troubleshooting-guide/how-to-troubleshoot.md" >}}).

    {{< call-out "note" >}}Additional SELinux configuration may be required to allow NGINX Plus to listen on specific network ports, connect to upstreams, and send syslog entries to remote systems. Refer to the practices outlined in the [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) article for details.{{< /call-out >}}

16. To enable the NGINX/App-Protect-DoS service to start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

17. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

18. L4 mitigation

    To enable the `app-protect-dos-ebpf-manager` service to start at boot, run the command:
    ```shell
    sudo systemctl enable nginx.service
    ```
    Start the `app-protect-dos-ebpf-manager` service:
    ```
    sudo systemctl start app-protect-dos-ebpf-manager
    ```

## RHEL 9+ / Rocky Linux 9 Installation

1. If you already have NGINX packages on your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-jwt.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

5. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget
    ```

6. Enable the yum repositories to pull NGINX App Protect DoS dependencies:

    If you have a RHEL subscription:

    ```shell
    sudo subscription-manager repos --enable=rhel-9-for-x86_64-baseos-rpms
    sudo subscription-manager repos --enable=rhel-9-for-x86_64-appstream-rpms
    sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    ```

7. Add the NGINX Plus and NGINX App Protect DoS repositories:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-9.repo
    ```

8. If you are performing a fresh installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect-dos
    ```

    For L4 accelerated mitigation feature (RHEL 9):

    ```shell
    sudo dnf install app-protect-dos-ebpf-manager
    ```

    {{< call-out "note" >}}
   L4 accelerated mitigation feature (RHEL 9):
   - `app-protect-dos-ebpf-manager` run with root privileges.
    {{< /call-out >}}

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-dos
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-dos-32+4.4.0
    ```

9. In you are upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo dnf remove nginx-plus
    sudo dnf install app-protect-dos
    sudo systemctl start nginx
    ```

    {{< call-out "note" >}} Make sure to restore configuration from `/etc/nginx-plus-backup` back to `/etc/nginx-plus`.{{< /call-out >}}

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Check the App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

12. Load the NGINX App Protect DoS module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

13. Enable NGINX App Protect DoS on an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

14. Enable the L4 accelerated mitigation feature (RHEL 8.6+) in the `http` context of the `nginx.conf` file:

    ```nginx
    app_protect_dos_accelerated_mitigation on;
    ```

15. Configure the SELinux to allow App Protect DoS:

    a. Using the vi editor, create a file:

    ```shell
    vi app-protect-dos.te
    ```

    b. Insert the following contents into the file created above:

    ```shell
    module app-protect-dos 2.0;
    require {
        type unconfined_t;
        type unconfined_service_t;
        type httpd_t;
        type tmpfs_t;
        type initrc_t;
        type initrc_state_t;
        class capability sys_resource;
        class shm { associate read unix_read unix_write write };
        class file { read write };
    }
    allow httpd_t initrc_state_t:file { read write };
    allow httpd_t self:capability sys_resource;
    allow httpd_t tmpfs_t:file { read write };
    allow httpd_t unconfined_service_t:shm { associate read unix_read unix_write write };
    allow httpd_t unconfined_t:shm { associate read write unix_read unix_write };
    allow httpd_t initrc_t:shm { associate read unix_read unix_write write };
    ```

    c. Run the following chain of commands:

    ```shell
    sudo checkmodule -M -m -o app-protect-dos.mod app-protect-dos.te &&  \
    sudo semodule_package -o app-protect-dos.pp -m app-protect-dos.mod &&  \
    sudo semodule -i app-protect-dos.pp;
    ```

    For L4 accelerated mitigation feature:<br>
    a. Using the vi editor, create a file:

    ```shell
    vi app-protect-dos-ebpf-manager.te
    ```

    b. Insert the following contents into the file created above:

    ```shell
    module app-protect-dos-ebpf-manager 1.0;
        require {
        type root_t;
        type httpd_t;
        type unconfined_service_t;
        class sock_file write;
        class unix_stream_socket connectto;
        class shm { unix_read unix_write };
    }
    allow httpd_t root_t:sock_file write;
    allow httpd_t unconfined_service_t:shm { unix_read unix_write };
    allow httpd_t unconfined_service_t:unix_stream_socket connectto;
    ```

    c. Run the following chain of commands:

    ```shell
    sudo checkmodule -M -m -o app-protect-dos-ebpf-manager.mod app-protect-dos-ebpf-manager.te &&  \
    sudo semodule_package -o app-protect-dos-ebpf-manager.pp -m app-protect-dos-ebpf-manager.mod &&  \
    sudo semodule -i app-protect-dos-ebpf-manager.pp;
    ```

    If you encounter any issues, refer to the [Troubleshooting Guide]({{< ref "/nap-dos/troubleshooting-guide/how-to-troubleshoot.md" >}}).

    {{< call-out "note" >}}Additional SELinux configuration may be required to allow NGINX Plus to listen on specific network ports, connect to upstreams, and send syslog entries to remote systems. Refer to the practices outlined in the [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) article for details.{{< /call-out >}}

16. To enable the NGINX/App-Protect-DoS service to start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

17. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

18. L4 mitigation

    To enable the `app-protect-dos-ebpf-manager` service to start at boot, run the command:
    ```shell
    sudo systemctl enable nginx.service
    ```
    Start the `app-protect-dos-ebpf-manager` service:
    ```
    sudo systemctl start app-protect-dos-ebpf-manager
    ```


## Debian / Ubuntu Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-jwt.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

5. Install appropriate packages with `apt`:

    For Debian:

    ```shell
    sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring
    ```

    For Ubuntu:

    ```shell
    sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
    ```

    {{< call-out "note" >}}In case the apt installation or database update fails due to release info change, run the below command before you install.{{< /call-out >}}

    ```shell
    sudo apt-get update --allow-releaseinfo-change
    ```

6. Download and add the NGINX signing key:

    ```shell
    sudo wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    ```

7. Add NGINX Plus and NGINX App Protect DoS repository:

    For Debian:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect-dos.list
    ```

    For Ubuntu:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect-dos.list
    ```

8. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

9. In case of fresh Installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-dos
    ```

    For L4 accelerated mitigation feature (Debian 11 /  Debian 12 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04):

    ```shell
    sudo apt-get install app-protect-dos-ebpf-manager
    ```

   {{< call-out "note" >}}
   L4 accelerated mitigation feature (Debian 11 /  Debian 12 /  Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04):
   - `app-protect-dos-ebpf-manager` run with root privileges.
   {{< /call-out >}}

    Alternatively, to install a specific version, use the following commands to update and list available versions:

    ```shell
    sudo apt-get update
    sudo apt-cache policy app-protect-dos
    ```

    Finally, install a specific version from the output of command above.

    For example for Debian 10:

    ```shell
    sudo apt-get install app-protect-dos=27+2.4.0-1~buster nginx-plus-module-appprotectdos=27+2.4.0-1~buster
    ```

    For example for Debian 11:

    ```shell
    sudo apt-get install app-protect-dos=33+4.5.0-1~bullseye nginx-plus-module-appprotectdos=33+4.5.0--1~bullseye
    ```

    For example, for Debian 12:

    ```shell
    sudo apt-get install app-protect-dos=33+4.5.0-1~bookworm nginx-plus-module-appprotectdos=32+4.5.0-1~bookworm
    ```

    For example for Ubuntu 18.04:

    ```shell
    sudo apt-get install app-protect-dos=27+2.4.0-1~bionic nginx-plus-module-appprotectdos=27+2.4.0-1~bionic
    ```

    For example for Ubuntu 20.04:

     ```shell
    sudo apt-get install app-protect-dos=33+4.5.0-1~focal nginx-plus-module-appprotectdos=32+4.5.0-1~focal
    ```

    For example for Ubuntu 22.04:

     ```shell
    sudo apt-get install app-protect-dos=33+4.5.0-1~jammy nginx-plus-module-appprotectdos=32+4.5.0-1~jammy
    ```

    For example for Ubuntu 24.04:

     ```shell
    sudo apt-get install app-protect-dos=33+4.5.0-1~noble nginx-plus-module-appprotectdos=33+4.5.1-1~noble
    ```

10. In the case of upgrading from a previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo apt-get update
    sudo apt-get remove nginx-plus
    sudo apt-get install app-protect-dos
    sudo systemctl start nginx
    ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Check the App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

13. Load the NGINX App Protect DoS module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

14. Enable NGINX App Protect DoS on an `http/server/location` context in the `nginx.conf` via:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

15. Enable the L4 accelerated mitigation feature (Debian 11 / Debian 12 / Ubuntu 20.04 / Ubuntu 22.04) on the `http` context of the `nginx.conf` file:

    ```nginx
    app_protect_dos_accelerated_mitigation on;
    ```

16. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```
17. Start the L4 service:
    ```shell
     sudo systemctl start app-protect-dos-ebpf-manager
    ```

## Alpine Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-jwt.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

3. Upload `nginx-repo.key` to `/etc/apk/cert.key` and `nginx-repo.crt` to `/etc/apk/cert.pem`. Make sure that files do not contain other certificates and keys, as Alpine Linux does not support mixing client certificates for different repositories.

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

4. Add the NGINX public signing key to the directory `/etc/apk/keys`:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub  https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
    ```

5. Remove any previously configured NGINX Plus repository:

    ```shell
    sed "/plus-pkgs.nginx.com/d" /etc/apk/repositories
    ```

6. Add NGINX Plus repository to `/etc/apk/repositories` file:

    ```shell
    printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

7. Add NGINX App Protect DoS repository to `/etc/apk/repositories` file:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-dos/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

8. It is recommended to remove all community-supported NGINX packages. Note that all NGINX modules will be removed as well.

    ```shell
    sudo apk del -r app-protect-dos
    sudo apk del -r nginx
    ```

9. Update the repository and install the most recent version of the NGINX Plus and NGINX App Protect DoS:

    ```shell
    sudo apk update
    sudo apk add nginx-plus app-protect-dos
    ```

    For L4 accelerated mitigation feature:

    ```shell
    sudo sudo apk add app-protect-dos-ebpf-manager
    ```

   {{< call-out "note" >}}
   L4 accelerated mitigation feature:
   - `app-protect-dos-ebpf-manager` run with root privileges.
   {{< /call-out >}}

    Alternatively, to install a specific version, use the following commands to update and list available versions:

    ```shell
    sudo apk update
    sudo apk info app-protect-dos
    ```

    Finally, install a specific version from the output of command above. For example:

    ```shell
    sudo apk add nginx-plus app-protect-dos=33+4.5.0-r1
    ```

10. In case of upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo apk update
    sudo apk del -r app-protect-dos
    sudo apk del -r nginx-plus
    sudo apk add nginx-plus app-protect-dos
    rc-service nginx-app-protect-dos start
    ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Check the App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

13. Load the NGINX App Protect DoS module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

14. Enable NGINX App Protect DoS on an `http/server/location` context in the `nginx.conf` via:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

15. Enable the L4 accelerated mitigation feature on the `http` context of the `nginx.conf` file:

    ```nginx
    app_protect_dos_accelerated_mitigation on;
    ```

16. Start the NGINX service:

    ```shell
    rc-service nginx-app-protect-dos start
    ```

17. Start the L4 service:
    ```shell
    rc-service app-protect-dos-ebpf-manager start
    ```

## Amazon Linux 2023 Installation

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

1. {{< include "nginx-plus/install/create-dir-for-crt-key.md" >}}

1. {{< include "nginx-plus/install/create-dir-for-jwt.md" >}}

1. {{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

1. {{< include "nginx-plus/install/copy-crt-and-key.md" >}}

1. {{< include "nginx-plus/install/copy-jwt-to-etc-nginx-dir.md" >}}

5. Install prerequisite packages:

    ```shell
    sudo dnf install ca-certificates wget

6. Add NGINX Plus and NGINX App Protect DoS repository:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo
    ```

7. In case of fresh installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo dnf install app-protect-dos
    ```

    For L4 accelerated mitigation feature:

    ```shell
    sudo dnf install app-protect-dos-ebpf-manager
    ```

    {{< call-out "note" >}}
   L4 accelerated mitigation feature:
   - `app-protect-dos-ebpf-manager` run with root privileges.
    {{< /call-out >}}

    Alternatively, you can use the following command to list available versions:

    ```shell
    sudo dnf --showduplicates list app-protect-dos
    ```

    Then, install a specific version from the output of command above. For example:

    ```shell
    sudo dnf install app-protect-dos-34+4.6.0
    ```

8. In case of upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

    ```shell
    sudo dnf remove nginx-plus
    sudo dnf install app-protect-dos
    sudo systemctl start nginx
    ```

    {{< call-out "note" >}} Make sure to restore configuration from `/etc/nginx-plus-backup` back to `/etc/nginx-plus`.{{< /call-out >}}

9. Confirm the NGINX binary version to make sure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

10. Check the App Protect DoS binary version to ensure that you have the right version installed correctly:

    ```shell
    sudo admd -v
    ```

11. Load the NGINX App Protect DoS module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

12. Enable NGINX App Protect DoS in an `http/server/location` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

13. Enable the L4 accelerated mitigation feature in an `http` context in the `nginx.conf` file:

    ```nginx
    app_protect_dos_accelerated_mitigation on;
    ```

14. To enable the NGINX/App-Protect-DoS service to start at boot, run the command:

    ```shell
    sudo systemctl enable nginx.service
    ```

15. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

16. L4 mitigation

    To enable the `app-protect-dos-ebpf-manager` service to start at boot, run the command:
    ```shell
    sudo systemctl enable nginx.service
    ```
    Start the `app-protect-dos-ebpf-manager` service:
    ```
    sudo systemctl start app-protect-dos-ebpf-manager
    ```


## Docker Deployment

### Docker Deployment Instructions

You need root permissions to execute the following steps.

1. Create a Dockerfile (see examples below) which copies the following files into the docker image:

   - `nginx-repo.crt`: Certificate for NGINX repository access
   - `nginx-repo.key`: Private key for NGINX repository access
   - `license.jwt`: JWT license file for NGINX Plus license management
   - `nginx.conf`: User defined `nginx.conf` with `app-protect-dos` enabled
   - `entrypoint.sh`: Docker startup script which spins up all App Protect DoS processes, must have executable permissions
   - custom_log_format.json: Optional user-defined security log format file (if not used - remove its references from the nginx.conf and Dockerfile)

2. Log in to NGINX Plus Customer Portal and download your `nginx-repo.crt`, `nginx-repo.key` and `license.jwt` files.

3. Copy the files to the directory where the Dockerfile is located.

4. Add NGINX App Protect DoS to your `nginx.conf`. The configuration below is an example for an `http` and `grpc+tls` servers which has NGINX App Protect DoS enabled. Note that every NGINX App Protect DoS related directive starts with `app_protect_dos_`.

    `nginx.conf`

    ```nginx
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log error;
    worker_rlimit_nofile 65535;
    working_directory /tmp/cores;

    load_module modules/ngx_http_app_protect_dos_module.so; # NGINX App Protect DoS module

    events {
        worker_connections  65535;
    }

    http {
        include         /etc/nginx/mime.types;

        log_format log_napd ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, '
                            'outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, '
                            'ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';

        app_protect_dos_security_log_enable on; # Enable NGINX App Protect DoS's security logger
        app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" /var/log/adm/logger.log; # Security logger outputs to a file
        # app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=1.2.3.4:5261; # Security logger outputs to a syslog destination

        # HTTP/1 server
        server {
            default_type    application/octet-stream;
            listen          80 reuseport;
            server_name     serv80;

            set $loggable '0';
            access_log /var/log/nginx/access.log log_napd if=$loggable; # Access log with rate limiting and additional information
            # access_log syslog:server=1.1.1.1:5561 log_napd if=$loggable;

            app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json"; # Policy configuration for NGINX App Protect DoS

            location / {
                app_protect_dos_enable on; # Enable NGINX App Protect DoS in this block
                app_protect_dos_name "App80"; # PO name
                app_protect_dos_monitor uri=http://serv80/; # Health monitoring
                proxy_pass http://1.2.3.4:80;
            }
        }

        # gRPC server with ssl
        server {
            default_type    application/grpc;
            listen          443 http2 ssl reuseport;
            server_name     serv_grpc;

            # TLS config
            ssl_certificate      /etc/ssl/certs/grpc.example.com.crt;
            ssl_certificate_key  /etc/ssl/private/grpc.example.com.key;
            ssl_session_cache    shared:SSL:10m;
            ssl_session_timeout  5m;
            ssl_ciphers          HIGH:!aNULL:!MD5;
            ssl_protocols        TLSv1.2 TLSv1.3;

            set $loggable '0';
            access_log /var/log/nginx/access.log log_napd if=$loggable;
            #access_log syslog:server=1.1.1.1:5561 log_napd if=$loggable;

            location / {
                app_protect_dos_enable on;
                app_protect_dos_name "AppGRPC";
                app_protect_dos_monitor uri=https://serv_grpc:443/service/method protocol=grpc; # mandatory for gRPC
                grpc_pass grpc://1.2.3.4:1001;
            }
        }

        sendfile            on;
        tcp_nopush          on;
        keepalive_timeout   65;
    }
    ```

   {{< call-out "important" >}}
   Make sure to replace upstream and proxy pass directives in this example with relevant application backend settings.
   {{< /call-out >}}

5. In the same directory create an `entrypoint.sh` file with executable permissions, with the following content:

    ```shell
    #!/usr/bin/env bash

    USER=nginx
    LOGDIR=/var/log/adm

    # prepare environment
    mkdir -p /var/run/adm /tmp/cores ${LOGDIR}
    chmod55 /var/run/adm /tmp/cores ${LOGDIR}
    chown ${USER}:${USER} /var/run/adm /tmp/cores ${LOGDIR}

    # run processes
    /bin/su -s /bin/bash -c "/usr/bin/adminstall > ${LOGDIR}/adminstall.log 2>&1" ${USER}
    /bin/su -s /bin/bash -c "/usr/bin/admd -d --log info > ${LOGDIR}/admd.log 2>&1 &" ${USER}
    /usr/sbin/nginx -g 'daemon off;'
    ```

6. Create a Docker image:

    ```shell
    DOCKER_BUILDKIT=1 docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .
    ```

    The `--no-cache` option tells Docker to build the image from scratch and ensures the installation of the latest version of NGINX Plus and NGINX App Protect DoS. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses versions from the previously built image from the Docker cache.

   For RHEL8/9 with subctiption manager setup add build arguments:
   
    ```shell
    DOCKER_BUILDKIT=1 docker build --build-arg RHEL_ORG=... --build-arg RHEL_ACTIVATION_KEY=...  --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .
    ```

8. Verify that the `app-protect-dos` image was created successfully with the docker images command:

    ```shell
    docker images app-protect-dos
    ```

9. Create a container based on this image, for example, `my-app-protect-dos` container:

    ```shell
    docker run --name my-app-protect-dos -p 80:80 -d app-protect-dos
    ```

10. Verify that the `my-app-protect-dos` container is up and running with the `docker ps` command:

    ```shell
    docker ps
    ```

11. L4 Accelerated Mitigation Deployment Options:<br>
    There are three different ways to deploy the L4 accelerated mitigation feature:<br>
    1. Deploy in a Dedicated Container. <br>
       Create a shared folder on the host:
       ```shell
       mkdir /shared
       ```
       This folder will be used to share data between containers.
       Modify the `entrypoint.sh` to run the L4 mitigation:

       ```shell
       # run processes
       /usr/bin/ebpf_manager_dos
       ```

       Create and run the L4 container:
       ```shell
       docker run --privileged --network host --mount type=bind,source=/sys/fs/bpf,target=/sys/fs/bpf -v /shared:/shared --name my-app-protect-dos-ebpf-manager -d app-protect-dos-ebpf-manager
       ```

       Create and run the main `app-protect-dos` container:
       ```shell
       docker run --name my-app-protect-dos -v /shared:/shared -p 80:80 -d app-protect-dos
       ```
    2. Deploy Directly on the Host.<br>
       To run L4 mitigation directly on the host:<br>
        1. Install the L4 mitigation on the host, as described in the OS-specific instructions.
        2. Run the app-protect-dos container:
             ```shell
             docker run --name my-app-protect-dos -v /shared:/shared -p 80:80 -d app-protect-dos
             ```
    3. Run L4 Mitigation Inside the Same Container as `app-protect-dos`.<br>
       To run both L4 mitigation and the main application within the same container:<br>
        1. Modify the `entrypoint.sh`:
           ```shell
           ...
           # run processes
           /usr/bin/ebpf_manager_dos &
           ...
           ```
        2. run the container:
           ```shell
           docker run --name my-app-protect-dos -p 80:80 -d app-protect-dos
           ```

   {{< call-out "note" >}}
   L4 accelerated mitigation feature:
   - `app-protect-dos-ebpf-manager` need to run with root privileges.
   {{< /call-out >}}


### Alpine Docker Deployment Example

```Dockerfile
# syntax=docker/dockerfile:1
# For Alpine 3.19:
FROM alpine:3.19

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub

# Add NGINX Plus/NGINX App Protect Dos repository:
RUN printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories && \
    printf "https://pkgs.nginx.com/app-protect-dos/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Update the repository and install the most recent version of the NGINX App Protect Dos package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apk update && apk add app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### AmazonLinux 2023 Docker Deployment Example

```Dockerfile
# For AmazonLinux 2023:
FROM amazonlinux:2023

# Install prerequisite packages:
RUN dnf -y install ca-certificates

# Add NGINX Plus/NGINX App Protect Dos repository:
RUN curl -o /etc/yum.repos.d/plus-amazonlinux2023.repo https://cs.nginx.com/static/files/plus-amazonlinux2023.repo && \
    curl -o  /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo

# Install NGINX App Protect DoS:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    dnf install -y app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    rm /etc/yum.repos.d/plus-amazonlinux2023.repo && \
    rm /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### Debian 11 (Bullseye) / Debian 12 (Bookworm) Docker Deployment Example

```Dockerfile
# Where can be bullseye/bookworm
FROM debian:bullseye

# Setup repository keys
RUN mkdir -p /etc/ssl/nginx/ /etc/nginx/ && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/debian $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-app-protect-dos.list && \
    wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Install Nginx App Protect Dos
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nginx-app-protect-dos.list  && \
    rm -rf /etc/apt/apt.conf.d/90nginx /var/lib/apt/lists/*

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### Ubuntu 22.04 (Jammy) / 24.04 (Noble) Docker Deployment Example

```Dockerfile
# Where version can be: jammy/noble
FROM ubuntu:noble

# Setup repository keys
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/ubuntu $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-app-protect-dos.list && \
    wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Install Nginx App Protect Dos
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nginx-app-protect-dos.list && \
    rm -rf /etc/apt/apt.conf.d/90nginx /var/lib/apt/lists/*

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### RHEL 8 Docker Deployment Example

```Dockerfile
# For UBI 8
FROM registry.access.redhat.com/ubi8

ARG RHEL_ORG
ARG RHEL_ACTIVATION_KEY

# Setup repository keys
RUN subscription-manager register --org=${RHEL_ORG} --activationkey=${RHEL_ACTIVATION_KEY} && \
    subscription-manager refresh && \
    subscription-manager attach --auto || true && \
    subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms && \
    subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf -y install ca-certificates && \
    curl -o /etc/yum.repos.d/plus-8.repo https://cs.nginx.com/static/files/plus-8.repo && \
    curl -o /etc/yum.repos.d/app-protect-dos-8.repo https://cs.nginx.com/static/files/app-protect-dos-8.repo

# Install Nginx App Protect Dos
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    dnf -y install app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    rm /etc/yum.repos.d/plus-8.repo && \
    rm /etc/yum.repos.d/app-protect-dos-8.repo && \
    dnf clean all && \
    rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### Rocky Linux 9 Docker Deployment Example

```Dockerfile
# syntax=docker/dockerfile:1
# For Rocky Linux 9:
FROM rockylinux:9

# Install prerequisite packages:
RUN dnf -y install ca-certificates epel-release 'dnf-command(config-manager)'

# Add NGINX App-protect-DoS & NGINX Plus repo to Yum:
RUN curl -o /etc/yum.repos.d/plus-9.repo https://cs.nginx.com/static/files/plus-9.repo && \
    curl -o /etc/yum.repos.d/app-protect-dos-9.repo https://cs.nginx.com/static/files/app-protect-dos-9.repo && \
    dnf config-manager --set-enabled crb && \
    dnf clean all

# Install NGINX App Protect DoS:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    dnf install -y app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    rm /etc/yum.repos.d/plus-9.repo && \
    rm /etc/yum.repos.d/app-protect-dos-9.repo && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

## Docker Deployment with NGINX App Protect

### Docker Deployment Instructions

You need root permissions to execute the following steps.

1. Create a Dockerfile (see examples below) which copies the following files into the docker image:

    - `nginx-repo.crt`: Certificate for NGINX repository access
    - `nginx-repo.key`: Private key for NGINX repository access
    - `license.jwt`: JWT license file for NGINX Plus license management
    - `nginx.conf`: User defined `nginx.conf` with `app-protect-dos` enabled
    - `entrypoint.sh`: Docker startup script which spins up all App Protect DoS processes, must have executable permissions
    - `custom_log_format.json`: Optional user-defined security log format file (if not used - remove its references from the nginx.conf and Dockerfile)

2. Log in to NGINX Plus Customer Portal and download your `nginx-repo.crt`, `nginx-repo.key` and `license.jwt` files.

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

5. In the same directory create the `nginx.conf` file with the following contents:

    ```nginx
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log error;
    worker_rlimit_nofile 65535;
    working_directory /tmp/cores;

    load_module modules/ngx_http_app_protect_module.so;
    load_module modules/ngx_http_app_protect_dos_module.so;

    events {
        worker_connections 65535;

    }

    http {
        include         /etc/nginx/mime.types;

        log_format log_napd ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, '
                            'outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, '
                            'ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';

        app_protect_dos_security_log_enable on;
        app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" /var/log/adm/logger.log;
        #app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=1.2.3.4:5261;

        # HTTP/1 server
        server {
            default_type        application/octet-stream;
            listen              80 reuseport;
            server_name         serv80;
            proxy_http_version  1.1;

            app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json";
            app_protect_security_log_enable on;
            app_protect_security_log "/etc/nginx/custom_log_format.json" syslog:server=127.0.0.1:514;

            set $loggable '0';
            access_log /var/log/nginx/access.log log_napd if=$loggable;
            #access_log syslog:server=1.1.1.1:5561 log_napd if=$loggable;
            app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json";

            location / {
                app_protect_dos_enable on;
                app_protect_dos_name "App80";
                app_protect_dos_monitor uri=http://serv80/;

                proxy_pass http://1.2.3.4:80;
            }
        }

        # gRPC server with ssl
        server {
            default_type    application/grpc;
            listen          443 http2 ssl reuseport;
            server_name     serv_grpc;

            # TLS config
            ssl_certificate      /etc/ssl/certs/grpc.example.com.crt;
            ssl_certificate_key  /etc/ssl/private/grpc.example.com.key;
            ssl_session_cache    shared:SSL:10m;
            ssl_session_timeout  5m;
            ssl_ciphers          HIGH:!aNULL:!MD5;
            ssl_protocols        TLSv1.2 TLSv1.3;

            set $loggable '0';
            access_log /var/log/nginx/access.log log_napd if=$loggable;
            #access_log syslog:server=1.1.1.1:5561 log_napd if=$loggable;

            location / {
                app_protect_dos_enable on;
                app_protect_dos_name "AppGRPC";
                app_protect_dos_monitor uri=https://serv_grpc:443/service/method protocol=grpc; # mandatory for gRPC
                grpc_pass grpc://1.2.3.4:1001;
            }
        }

        sendfile            on;
        tcp_nopush          on;
        keepalive_timeout   65;
    }
    ```

{{< call-out "important" >}}
Make sure to replace upstream and proxy pass directives in this example with relevant application backend settings.
{{< /call-out >}}

6. For the L4 accelerated mitigation feature: <br />
   The following line in the `nginx.conf` file needs to be modified:<br />
   Change:
    ```nginx
   user nginx;
   ```
   To:
   ```nginx
   user root;
   ```

7. In the same directory create an `entrypoint.sh` file with executable permissions, with the following content:

   For Alpine / Debian / Ubuntu / UBI 8/ UBI 9:

     ```shell
     #!/usr/bin/env bash
    USER=nginx
    LOGDIR=/var/log/adm

    # prepare environment
    mkdir -p /var/run/adm /tmp/cores ${LOGDIR}
    chmod 755 /var/run/adm /tmp/cores ${LOGDIR}
    chown ${USER}:${USER} /var/run/adm /tmp/cores ${LOGDIR}

    # run processes
    /bin/su -s /bin/bash -c "/usr/bin/adminstall > ${LOGDIR}/adminstall.log 2>&1" ${USER}/bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' ${USER}
    /bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 > /var/log/app_protect/bd-socket-plugin.log &" ${USER}
    /bin/su -s /bin/bash -c "/usr/bin/admd -d --log info > ${LOGDIR}/admd.log 2>&1 &" ${USER}
    /usr/sbin/nginx -g 'daemon off;'
    ```
  
8. Create a Docker image:

    For Debian/Ubuntu/Alpine/Amazon Linux:

    ```shell
    DOCKER_BUILDKIT=1 docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .    ```

    For RHEL:

    ```shell
    DOCKER_BUILDKIT=1 docker build --build-arg RHEL_ORG=... --build-arg RHEL_ACTIVATION_KEY=...  --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .
    ```

**Notes:**
    - The `--no-cache` option tells Docker/Podman to build the image from scratch and ensures the installation of the latest version of NGINX Plus and NGINX App Protect WAF 4.x. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses versions from the previously built image from the cache.
    - For RHEL:<br>
    The subscription-manager is disabled when running inside containers based on Red Hat Universal Base images. You will need a registered and subscribed RHEL system.

9. Verify that the `app-protect-dos` image was created successfully with the docker images command:

    ```shell
    docker images app-protect-dos
    ```

10. Create a container based on this image, for example, `my-app-protect-dos` container:

    ```shell
    docker run --name my-app-protect-dos -p 80:80 -d app-protect-dos
    ```

11. Verify that the `my-app-protect-dos` container is up and running with the `docker ps` command:

    ```shell
    docker ps
    ```

### Alpine Dockerfile example

```dockerfile
# syntax=docker/dockerfile:1
# For Alpine 3.19:
FROM alpine:3.19

# Download and add the NGINX signing keys:
RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub && \
    wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub

# Add NGINX Plus repository:
RUN printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Add NGINX App Protect Waf & Dos repositories:
RUN printf "https://pkgs.nginx.com/app-protect-dos/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories && \
    printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories && \
    printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories

# Update the repository and install the most recent version of the NGINX App Protect DoS package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/apk/cert.pem,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/apk/cert.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apk update && apk add app-protect app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### Amazon Linux Dockerfile example

```dockerfile
# syntax=docker/dockerfile:1
FROM amazonlinux:2023

# Install prerequisite packages:
RUN dnf -y install ca-certificates

# Add NGINX/NAP WAF/NAP DOS repositories:
RUN curl -o /etc/yum.repos.d/plus-amazonlinux2023.repo https://cs.nginx.com/static/files/plus-amazonlinux2023.repo && \
    curl -o /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-dos-amazonlinux2023.repo && \
    curl -o /etc/yum.repos.d/app-protect-amazonlinux2023.repo https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo && \
    curl -o /etc/yum.repos.d/dependencies.amazonlinux2023.repo https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    dnf -y install app-protect app-protect-dos  && \
    cat license.jwt > /etc/nginx/license.jwt && \
    rm /etc/yum.repos.d/plus-amazonlinux2023.repo && \
    rm /etc/yum.repos.d/app-protect-dos-amazonlinux2023.repo && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### Debian Docker Deployment Example

```Dockerfile
# Where verionn can be: bullseye/bookworm
FROM debian:bullseye

# Install prerequisite packages:
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Add NGINX Plus, NGINX App Protect and NGINX App Protect DoS repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect-dos.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Install Nginx App Protect Dos
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nginx-app-protect-dos.list  && \
    rm -rf /etc/apt/apt.conf.d/90nginx /var/lib/apt/lists/*

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

### Ubuntu Docker Deployment Example

```Dockerfile
# Where version can be:jammy/noble
FROM ubuntu:noble

# Install prerequisite packages:
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Add NGINX Plus, NGINX App Protect and NGINX App Protect DoS repository:
RUN printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-dos/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect-dos.list \
    && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Install Nginx App Protect Dos
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    --mount=type=secret,id=license-jwt,dst=license.jwt,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect-dos && \
    cat license.jwt > /etc/nginx/license.jwt && \
    apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nginx-app-protect-dos.list  && \
    rm -rf /etc/apt/apt.conf.d/90nginx /var/lib/apt/lists/*

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["sh", "/root/entrypoint.sh"]
```

## NGINX App Protect DoS Arbitrator

### Overview

NGINX App Protect DoS arbitrator orchestrates all the running NGINX App Protect DoS instances to synchronize local/global attack start/stop.

NGINX App Protect DoS arbitrator serves as a central coordinating component for managing multiple instances of  App Protect DoS in a network. It is needed when there are more than one NGINX App Protect DoS instances. Its primary function is to ensure that all instances are aware of and share the same state for each protected object. Here's a clearer breakdown of how it works and why it's necessary:

How NGINX App Protect DoS Arbitrator Works:

- **Collecting State Periodically**: The arbitrator regularly collects the state information from all running instances of App Protect DoS. This collection occurs at set intervals, typically every 10 seconds.
- **State Initialization for New Instances**: When a new App Protect DoS instance is created, it doesn't start with a blank or uninitialized state for a protected object. Instead, it retrieves the initial state for the protected object from the arbitrator.
- **Updating State in Case of an Attack**: If an attack is detected by one of the App Protect DoS instances, that instance sends an attack notification to the arbitrator. The arbitrator then updates the state of the affected protected object to indicate that it is under attack. Importantly, this updated state is propagated to all other instances.

### Why NGINX App Protect DoS Arbitrator is Necessary

NGINX App Protect DoS Arbitrator is essential for several reasons:

- **Global State Management**: Without the arbitrator, each individual instance of App Protect DoS would manage its own isolated state for each protected object. This isolation could lead to inconsistencies. For example, if instance A declared an attack on a protected object named "PO-Example," instance B would remain unaware of this attack, potentially leaving the object vulnerable.
- **Uniform Attack Detection**: With the arbitrator in place, when instance A detects an attack on "PO-Example" and reports it to the arbitrator, the state of "PO-Example" is immediately updated to indicate an attack. This means that all instances, including instance B, are aware of the attack and can take appropriate measures to mitigate it.

In summary, NGINX App Protect DoS Arbitrator acts as a central coordinator to maintain a consistent and up-to-date global state for protected objects across multiple instances of App Protect DoS. This coordination helps ensure that attacks are properly detected and mitigated, and that knowledge gained by one instance is efficiently shared with others, enhancing the overall security of the network.


### NGINX App Protect DoS Arbitrator Deployment

1. Pull the official NGINX App Protect DoS Arbitrator image with the command:

   ```shell
   docker pull docker-registry.nginx.com/nap-dos/app_protect_dos_arb:latest
   ```

2. Create a container based on this image, for example, `app-protect-dos-arb` container:

   ```shell
   docker run --name app_protect_dos_arb -p 3000:3000 -d docker-registry.nginx.com/nap-dos/app_protect_dos_arb
   ```

3. Verify that the `app-protect-dos-arb` container is up and running with the `docker ps` command.

4. DNS records are required for NGINX App Protect DoS Arbitrator to work properly and be accessible by NGINX App Protect DoS servers. Ensure that the `svc-appprotect-dos-arb` or configured Arbitrator FQDN (with `app_protect_dos_arb_fqdn` directive) has a valid DNS resolution.
This step is necessary only for VM/Docker deployments with arbitrator. When the arbitrator is in the same Kubernetes namespace as NGINX App Protect DoS, this step is not needed.

### Multi-VM Deployment

The Arbitrator service is standalone. Once it is down, it can be seamlessly re-started. It will immediately recover all the needed information from NGINX App Protect DoS instances that communicate to it every 10 sec. It’s downtime is around 10-20 seconds which  will not affect the NGINX App Protect DoS working.

NGINX App Protect DoS Arbitrator service connects to port 3000 and can be seen under App Protect DoS instances. All modules try to connect to this service automatically. If it’s not accessible, each instance works in standalone mode.

There is no such option for authentications between NGINX App Protect DoS servers and Arbitrator service like MTLS or password . Currently Arbitrator service is not exposed outside of the namespace. It is customers responsibility to isolate it from outside. It is applicable to any deployment of Arbitrator, not only to multi-VM.

## Post-Installation Checks

You can run the following commands to ensure that NGINX App Protect DoS enforcement is operational.

1. Check that the three processes needed for NGINX App Protect DoS are running using `ps aux`:

    - admd
    - nginx: master process
    - nginx: worker process

    ```shell
    USER       PID   %CPU   %MEM    VSZ    RSS TTY      STAT  START     TIME  COMMAND
    nginx      7759   0.0    0.0   113120  1200 ?       Ss    Sep06     0:00  /bin/sh -c /usr/bin/admd -d --log info > /var/log/adm/admd.log 2>&1
    root       7765   0.0    0.0   87964   1464 ?       Ss    Sep06     0:00  nginx: master process /usr/sbin/nginx -g daemon off;
    nginx      7767   0.0    0.1   615868  8188 ?       Sl    Sep06     0:04  nginx: worker process
    ```

2. Verify that there are no NGINX errors in the `/var/log/nginx/error.log` and that the policy compiled successfully:

    ```shell
    2020/09/07 15:33:44 [notice] 9307#9307: using the "epoll" event method
    2020/09/07 15:33:44 [notice] 9307#9307: nginx/1.19.0 (nginx-plus-r22)
    2020/09/07 15:33:44 [notice] 9307#9307: built by gcc 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC)
    2020/09/07 15:33:44 [notice] 9307#9307: OS: Linux 3.10.0-327.28.3.el7.x86_64
    2020/09/07 15:33:44 [notice] 9307#9307: getrlimit(RLIMIT_NOFILE): 1024:4096
    2020/09/07 15:33:44 [notice] 9310#9310: start worker processes
    2020/09/07 15:33:44 [notice] 9310#9310: start worker process 9311
    PID <9311>, WORKER <0>, Function adm_ngx_init_process, line 684, version: 22+1.19.4-1.el7.ngx
    ```

3. Check that by applying an attack, the attacker IP addresses are blocked while the good traffic pass through:

    a. Simulate good traffic:

    ```shell
    echo "Start Good Traffic 2"
    while true; do
      curl ${VS}/good1 &
      curl ${VS}/good2 &
      curl ${VS}/good3 &
      curl ${VS}/good4
      sleep 0.1
      done &
    ```

    b. After 7 minutes start the attack:

   ```shell
   while [ true ]
   do
   ab -B ${BAD_IP1} -l -r -n 1000000 -c 150 -d -H "Host: evil.net" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: WireXBot" -H "x-requested-with:" -H "Referer: http://10.0.2.1/none.html" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US" http://${VS}/ &
   ab -B ${BAD_IP2} -l -r -n 1000000 -c 150 -d -H "Host: evil.net" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: WireXBot" -H "x-requested-with:" -H "Referer: http://10.0.2.1/none.html" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US" http://${VS}/ &
   ab -B ${BAD_IP3} -l -r -n 1000000 -c 150 -d -s 10 -H "Host: evil.net" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: WireXBot" -H "x-requested-with:" -H "Referer: http://10.0.2.1/none.html" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US" http://${VS}/

    killall ab
    done
    ```

    c. See that the good traffic continue as usual while the attackers receive denial of service.

To check NGINX App Protect WAF along side NGINX App Protect DoS, just perform the normal tests as specified at [Admin Guide](https://docs.nginx.com/nginx-app-protect/admin-guide/)

### Compatibility with NGINX Plus Releases

A threat campaign package is compatible with the NGINX Plus release supported during the time the threat campaign package was released and with all future releases from that point in time on. In other words, it is not compatible with earlier App Protect DoS releases. Those older releases are not supported at this point in time so you will have to upgrade App Protect DoS to benefit from the support which includes Threat campaigns updates.

## Upgrading App Protect DoS

You can upgrade to the latest NGINX Plus and App Protect DoS versions by downloading and installing the latest NGINX App Protect DoS package. When upgrading from this package, App Protect DoS will be uninstalled and reinstalled. The old default security policy is deleted and the new default security policy is installed. If you have created a custom security policy, the policy persists and you will need to update `nginx.conf` and point to the custom security policy by referencing the json file (using the full path).

If you upgrade your NGINX version outside of the App Protect DoS module, App Protect DoS will be uninstalled and you will need to reinstall it. You need to restart NGINX after an upgrade.

## SELinux

The default settings for Security-Enhanced Linux (SELinux) on modern Red Hat Enterprise Linux (RHEL) and related Linux distributions can be very strict, erring on the side of security rather than convenience.

Although the App Protect DoS applies its SELinux policy module during installation, your specific configuration might be blocked unless you adjust the policy or modify file labels.

### Modifying File Labels

For example, if you plan to store your log configuration files in `/etc/logs` - you should change the default SELinux file context for this directory:

```shell
semanage fcontext -a -t httpd_config_t /etc/logs
restorecon -Rv /etc/logs
```

### Syslog to Custom Port

If you want to send logs to some unreserved port, you can use semanage to add the desired port (here, 35514) to the syslogd_port_t type:

```shell
semanage port -a -t syslogd_port_t -p tcp 35514
```

Review the syslog ports by entering the following command:

```shell
semanage port -l | grep syslog
```

### Kubernetes Deployment Examples

#### App Protect DoS

`appprotect-dos.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: appprotect-dos
  namespace: appprotect-dos-wp-diff
  labels:
    app: appprotect-dos
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: appprotect-dos
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: appprotect-dos
    spec:
    containers:
    - name: centos-bados
      image: example.com/centos_app_protect_dos_r24:latest
      imagePullPolicy: Always
      resources:
        requests:
            cpu: "200m"
            memory: "500Mi"
        limits:
            cpu:  "900m"
            memory: "800Mi"
      ports:
        - containerPort: 80
          name: web
        - containerPort: 8090
          name: probe
        - containerPort: 8091
          name: probe500
        livenessProbe:
          httpGet:
            path: /app_protect_dos_liveness
            port: 8090
          initialDelaySeconds: 0
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /app_protect_dos_readiness
            port: 8090
          initialDelaySeconds: 0
          periodSeconds: 10
        volumeMounts:
        - name: shared
          mountPath: /shared/
        - name: conf
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: root-script
          mountPath: /root/entrypoint.sh
          subPath: entrypoint.sh
        - name: log-default
          mountPath: /etc/app_protect_dos/log-default.json
          subPath: log-default.json
    volumes:
    - name: shared
      persistentVolumeClaim:
        claimName: pvc-appprotect-dos-shared
    - name: conf
      configMap:
        name: cm-appprotect-dos-nginx
        items:
        - key: nginx.conf
          path: nginx.conf
    - name: root-script
      configMap:
          name: cm-appprotect-dos-entry
          defaultMode: 0755
          items:
          - key: entrypoint.sh
            path: entrypoint.sh
    - name: log-default
      configMap:
        name: cm-appprotect-dos-log-default
        defaultMode: 0755
        items:
        - key: log-default.json
          path: log-default.json
```

`svc-appprotect-dos.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-appprotect-dos
  namespace: appprotect-dos-wp-diff
  labels:
    app: appprotect-dos
spec:
  ports:
    - name: app
      port: 80
      protocol: TCP
      nodePort: 80
  selector:
    app: appprotect-dos
  type: NodePort
```

`log-default.json`:

```json
{
    "filter": {
        "traffic-mitigation-stats": "all",
        "bad-actors": "all",
        "attack-signatures": "all"
    }
}
```

`entrypoint.sh`:

```shell
#!/usr/bin/env bash
USER=nginx
LOGDIR=/var/log/adm

# prepare environment
mkdir -p /var/run/adm /tmp/cores ${LOGDIR}
chmod 755 /var/run/adm /tmp/cores ${LOGDIR}
chown ${USER}:${USER} /var/run/adm /tmp/cores ${LOGDIR}

# run processes
/bin/su -s /bin/bash -c "/usr/bin/adminstall > ${LOGDIR}/adminstall.log 2>&1" ${USER}
/usr/sbin/nginx -g 'daemon off;' &
/bin/su -s /bin/bash -c "/usr/bin/admd -d --log info > ${LOGDIR}/admd.log 2>&1 &" ${USER}
```

`install.sh`:

```shell
#!/bin/bash
set -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
kubectl -n appprotect-dos-wp-diff create cm cm-appprotect-dos-nginx --from-file ${DIR}/nginx.conf
kubectl -n appprotect-dos-wp-diff create cm cm-appprotect-dos-entry --from-file ${DIR}/entrypoint.sh
kubectl -n appprotect-dos-wp-diff create cm cm-appprotect-dos-log-default --from-file ${DIR}/log-default.json
kubectl create -f ${DIR}/appprotect-dos.yaml
#kubectl create -f ${DIR}/svc-appprotect-dos.yaml
```

`nginx.conf`:

```nginx
user nginx;
worker_processes 1;
error_log /var/log/nginx/error.log debug;
worker_rlimit_nofile 65535;
working_directory /tmp/cores;

load_module modules/ngx_http_app_protect_dos_module.so;

events {
    worker_connections  65535;
}
http {
    include         /etc/nginx/mime.types;
    default_type    application/octet-stream;

    log_format log_napd ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, '
                        'outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, '
                        'ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';

    app_protect_dos_security_log_enable on;
    app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" /var/log/adm/logger.log;
    # app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=1.2.3.4:5261;

    server {
        listen 80 reuseport;
        server_name serv;

        set $loggable '0';
        access_log /var/log/nginx/access.log log_napd if=$loggable;
        # access_log syslog:server=1.1.1.1:5561 log_napd if=$loggable;

        app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json";

        location / {
            app_protect_dos_enable on;
            app_protect_dos_name "App1";
            app_protect_dos_monitor uri=http://serv:80/ protocol=http1;
            proxy_pass http://1.2.3.4:80;
        }
    }

    server {
        listen 8090;
        server_name probe;

        app_protect_dos_liveness on;    # uri:/app_protect_dos_liveness port:8090
        app_protect_dos_readiness on;   # uri:/app_protect_dos_readiness port:8090

        location / {
            proxy_pass http://localhost:8091;
        }
    }

    server {
        listen 8091;
        return 503;
    }

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
}
```

#### App Protect DoS arb

Arbitrator (arb) is an internal service that is essential for the scaling scenarios. The arbitrator service should be deployed in the same namespace as NGINX App Protect DoS.

`appprotect-dos-arb.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: appprotect-dos-arb
  namespace: appprotect-dos-wp-diff
spec:
  replicas: 1
  selector:
    matchLabels:
      app: appprotect-dos-arb
  template:
    metadata:
      labels:
        app: appprotect-dos-arb
    spec:
      containers:
      - name: arb-svc
        image: example.com/app_protect_dos_arb:latest
        resources:
          requests:
            cpu: "200m"
            memory: "500Mi"
          limits:
            cpu:  "900m"
            memory: "800Mi"
        ports:
        - containerPort: 3000
```

`svc-appprotect-dos-arb.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-appprotect-dos-arb
  namespace: appprotect-dos-wp-diff
spec:
  selector:
    app: appprotect-dos-arb
  ports:
    - name: arb
      port: 3000
      protocol: TCP
      targetPort: 3000
  clusterIP: None
```

`install_appprotect-arb.sh`:

```shell
#!/bin/bash

set -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
kubectl -n appprotect-dos-wp-diff apply -f ${DIR}/appprotect-dos-arb.yaml
kubectl -n appprotect-dos-wp-diff apply -f ${DIR}/svc-appprotect-dos-arb.yaml
```

`install NGINX App Protect DoS with ARB service`:

```shell
#!/bin/bash

set -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
kubectl create ns appprotect-dos-wp-diff
${DIR}/appprotect-dos/install.sh
${DIR}/appprotect-dos-arb/install_appprotect-dos-arb.sh
```

---

## App Protect DoS eBPF manager

### Overview
The eBPF Manager is a powerful and efficient tool designed to simplify and secure the deployment of eBPF (Extended Berkeley Packet Filter) programs for advanced networking use cases.
Its primary responsibilities include program installation and managing client interactions to enable real-time packet processing and mitigation solutions.

### CLI Options for Flexible Configuration
The eBPF Manager comes with configurable command-line flags for ease of use and deployment customization. Key options include:

* Interface Selection:
    * -i, --interface [interfaces...]: Specify one or more network interfaces for eBPF XDP program deployment. If omitted, it defaults to all non-virtual, active network devices.
* gRPC UDS Ownership:
  * -u, --user <user_name>: Set the user ownership for the gRPC Unix Domain Socket (UDS). Defaults to nginx.
  * -g, --group <group_name>: Set the group ownership for the gRPC Unix Domain Socket (UDS). Defaults to nginx.

