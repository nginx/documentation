---
description: Learn about F5 DoS for NGINX Deployment.
nd-docs: DOCS-666
title: Virtual Machine and Docker
toc: true
weight: 90
type:
- how-to
---

## Overview

F5 DoS for NGINX provides behavioral protection against DoS for your web applications. <br><br>
This guide explains how to deploy F5 DoS for NGINX as well as upgrade App Protect DoS.

## Prerequisites

F5 DoS for NGINX is available to the customers as a downloadable dynamic module at an additional cost. To purchase or add F5 DoS for NGINX to an existing NGINX Plus subscription, contact the NGINX sales team.

NGINX Plus Release 24 and later supports F5 DoS for NGINX.

F5 DoS for NGINX supports the following operating systems:

- [RHEL 8.1+ / Rocky Linux 8](#rhel-8--rocky-linux-8-installation)
- [RHEL 9.0+ / Rocky Linux 9](#rhel-9--rocky-linux-9-installation)
- [Debian 11 (Bullseye)](#debian--ubuntu-installation)
- [Debian 12 (Bookworm)](#debian--ubuntu-installation)
- [Ubuntu 22.04 (Jammy)](#debian--ubuntu-installation)
- [Ubuntu 24.04 (Noble)](#debian--ubuntu-installation)
- [Alpine 3.21](#alpine-installation)
- [Alpine 3.22](#alpine-installation)
- [AmazonLinux 2023](#amazon-linux-2023-installation)


The F5 DoS for NGINX package has the following dependencies:

1. **nginx-plus-module-appprotectdos** - NGINX Plus dynamic module for App Protect DoS
2. **libcurl** - Software library for HTTP access
3. **zeromq4** - Software library for fast, message-based applications
4. **boost** - The free peer-reviewed portable C++ source libraries
5. **openssl** - Toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocol
6. **libelf** - Software library for ELF access

See the NGINX Plus full list of prerequisites for more details. F5 DoS for NGINX can be installed as a module to an existing NGINX Plus installation or as a complete NGINX Plus with App Protect DoS installation in a clean environment or to a system with F5 WAF for NGINX.

{{< call-out "note" >}}

- gRPC, HTTP/2 and WebSocket protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for the attack to be detected.
- Monitor directive `app_protect_dos_monitor` with proxy_protocol parameter can not be configured on Ubuntu 18.04. As a result, gRPC and HTTP/2 DoS protection for proxy_protocol configuration is not supported.
- Regularly update the Operating System (OS) to avoid known OS vulnerabilities which may impact the service.
{{< /call-out >}}

## Platform Security Considerations

When deploying App Protect DoS on NGINX Plus take the following precautions to secure the platform. This avoids the risk of causing a Denial of Service condition or compromising the platform security.

- Restrict permissions to the files on the F5 DoS for NGINX platform to user **nginx** and group **nginx**, especially for the sensitive areas containing the configuration.
- Remove unnecessary remote access services on the platform.
- Configure a Syslog destination on the same machine as App Protect DoS and proxy to an external destination. This avoids eavesdropping and [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attacks on the Syslog channel.

## Virtual machine or bare metal Deployment

### RHEL 8+ / Rocky Linux 8 Installation

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

6. Enable Yum repositories to pull F5 DoS for NGINX dependencies:

    For RHEL subscription:

    ```shell
    sudo subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms
    sudo subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms
    sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    ```

    For RockyLinux:
   
    ```shell
    sudo dnf -y install epel-release
    ```

8. Add NGINX Plus and NGINX App Protect DoS repository:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-8.repo
    ```

9. In case of fresh installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):

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
    sudo dnf install app-protect-dos-35+4.7.3
    ```

10. In case of upgrading from previously installed NGINX Plus App Protect DoS package (which includes NGINX Plus):

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

12. Load the F5 DoS for NGINX module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

13. Enable F5 DoS for NGINX in an `http/server/location` context in the `nginx.conf` file:

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

    If you encounter any issues, refer to the [Troubleshooting Guide]({{< ref "/nap-dos/troubleshooting/how-to-troubleshoot.md" >}}).

    {{< call-out "note" >}}Additional SELinux configuration may be required to allow NGINX Plus to listen on specific network ports, connect to upstreams, and send syslog entries to remote systems. Refer to the practices outlined in the [Using NGINX and NGINX Plus with SELinux](https://www.f5.com/company/blog/nginx/using-nginx-plus-with-selinux) article for details.{{< /call-out >}}

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

### RHEL 9+ / Rocky Linux 9 Installation

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

6. Enable the yum repositories to pull F5 DoS for NGINX dependencies:

    For RHEL subscription:

    ```shell
    sudo subscription-manager repos --enable=rhel-9-for-x86_64-baseos-rpms
    sudo subscription-manager repos --enable=rhel-9-for-x86_64-appstream-rpms
    sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    ```

    For RockyLinux:
   
    ```shell
    sudo dnf -y install epel-release
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
    sudo dnf install app-protect-dos-35+4.7.3
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

12. Load the F5 DoS for NGINX module on the main context in the `nginx.conf`:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

13. Enable F5 DoS for NGINX on an `http/server/location` context in the `nginx.conf` file:

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

    If you encounter any issues, refer to the [Troubleshooting Guide]({{< ref "/nap-dos/troubleshooting/how-to-troubleshoot.md" >}}).

    {{< call-out "note" >}}Additional SELinux configuration may be required to allow NGINX Plus to listen on specific network ports, connect to upstreams, and send syslog entries to remote systems. Refer to the practices outlined in the [Using NGINX and NGINX Plus with SELinux](https://www.f5.com/company/blog/nginx/using-nginx-plus-with-selinux/) article for details.{{< /call-out >}}

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


### Debian / Ubuntu Installation

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

7. Add NGINX Plus and F5 DoS for NGINX repository:

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

    For L4 accelerated mitigation feature (Debian 11 /  Debian 12 / Ubuntu 22.04 / Ubuntu 24.04):

    ```shell
    sudo apt-get install app-protect-dos-ebpf-manager
    ```

   {{< call-out "note" >}}
   L4 accelerated mitigation feature (Debian 11 /  Debian 12 /  Ubuntu 22.04 / Ubuntu 24.04):
   - `app-protect-dos-ebpf-manager` run with root privileges.
   {{< /call-out >}}

    Alternatively, to install a specific version, use the following commands to update and list available versions:

    ```shell
    sudo apt-get update
    sudo apt-cache policy app-protect-dos
    ```

    Finally, install a specific version from the output of command above.

    For example for Debian 11:

    ```shell
    sudo apt-get install app-protect-dos=35+4.7.3-1~bullseye nginx-plus-module-appprotectdos=35+4.7.3-1~bullseye
    ```

    For example, for Debian 12:

    ```shell
    sudo apt-get install app-protect-dos=35+4.7.3-1~bookworm nginx-plus-module-appprotectdos=35+4.7.3-1~bookworm
    ```

    For example for Ubuntu 22.04:

     ```shell
    sudo apt-get install app-protect-dos=35+4.7.3-1~jammy nginx-plus-module-appprotectdos=35+4.7.3-1~jammy
    ```

    For example for Ubuntu 24.04:

     ```shell
    sudo apt-get install app-protect-dos=35+4.7.3-1~noble nginx-plus-module-appprotectdos=35+4.7.3-1~noble
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

13. Load the F5 DoS for NGINX module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

14. Enable F5 DoS for NGINX on an `http/server/location` context in the `nginx.conf` via:

    ```nginx
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

15. Enable the L4 accelerated mitigation feature (Debian 11 / Debian 12 / Ubuntu 22.04 / Ubuntu 24.04) on the `http` context of the `nginx.conf` file:

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

### Alpine Installation

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

7. Add F5 DoS for NGINX repository to `/etc/apk/repositories` file:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-dos/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

8. It is recommended to remove all community-supported NGINX packages. Note that all NGINX modules will be removed as well.

    ```shell
    sudo apk del -r app-protect-dos
    sudo apk del -r nginx
    ```

9. Update the repository and install the most recent version of the NGINX Plus and F5 DoS for NGINX:

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

13. Load the F5 DoS for NGINX module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

14. Enable F5 DoS for NGINX on an `http/server/location` context in the `nginx.conf` via:

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

### Amazon Linux 2023 Installation

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

6. Add NGINX Plus and F5 DoS for NGINX repository:

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

11. Load the F5 DoS for NGINX module on the main context in the `nginx.conf` file:

    ```nginx
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

12. Enable F5 DoS for NGINX in an `http/server/location` context in the `nginx.conf` file:

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

4. Add F5 DoS for NGINX to your `nginx.conf`. The configuration below is an example for an `http` and `grpc+tls` servers which has F5 DoS for NGINX enabled. Note that every F5 DoS for NGINX related directive starts with `app_protect_dos_`.

    `nginx.conf`

    ```nginx
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log error;
    worker_rlimit_nofile 65535;
    working_directory /tmp/cores;

    load_module modules/ngx_http_app_protect_dos_module.so; # F5 DoS for NGINX module

    events {
        worker_connections  65535;
    }

    http {
        include         /etc/nginx/mime.types;

        log_format log_napd ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, '
                            'outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, '
                            'ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';

        app_protect_dos_security_log_enable on; # Enable F5 DoS for NGINX's security logger
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

            app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json"; # Policy configuration for F5 DoS for NGINX

            location / {
                app_protect_dos_enable on; # Enable F5 DoS for NGINX in this block
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

   {{< include "/dos/dos-entrypoint.md" >}}

6. Create a Docker image:

    ```shell
    DOCKER_BUILDKIT=1 docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .
    ```

    The `--no-cache` option tells Docker to build the image from scratch and ensures the installation of the latest version of NGINX Plus and F5 DoS for NGINX. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses versions from the previously built image from the Docker cache.

   For RHEL8/9 with subscription manager setup add build arguments:
   
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

{{< include "/dos/dockerfiles/alpine-plus-dos.md" >}}

### AmazonLinux 2023 Docker Deployment Example

{{< include "/dos/dockerfiles/amazon-plus-dos.md" >}}

### Debian 11 (Bullseye) / Debian 12 (Bookworm) Docker Deployment Example

{{< include "/dos/dockerfiles/debian-plus-dos.md" >}}

### Ubuntu 22.04 (Jammy) / 24.04 (Noble) Docker Deployment Example

{{< include "/dos/dockerfiles/ubuntu-plus-dos.md" >}}

### RHEL 8 Docker Deployment Example

{{< include "/dos/dockerfiles/rhel8-plus-dos.md" >}}

### RHEL 9 Docker Deployment Example

{{< include "/dos/dockerfiles/rhel9-plus-dos.md" >}}

### Rocky Linux 9 Docker Deployment Example

{{< include "/dos/dockerfiles/rocky9-plus-dos.md" >}}

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

   For Alpine /AmazonLinux 2023/ Debian / Ubuntu / UBI 8/ UBI 9:

{{< include "/dos/dos-waf-entrypoint.md" >}}

8. Create a Docker image:

    For Debian/Ubuntu/Alpine/Amazon Linux:

    ```shell
    DOCKER_BUILDKIT=1 docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .
    ```

    For RHEL:

    ```shell
    DOCKER_BUILDKIT=1 docker build --build-arg RHEL_ORG=... --build-arg RHEL_ACTIVATION_KEY=...  --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=./license.jwt -t app-protect-dos .
    ```

**Notes:**
    - The `--no-cache` option tells Docker/Podman to build the image from scratch and ensures the installation of the latest version of NGINX Plus and F5 WAF for NGINX 4.x. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses versions from the previously built image from the cache.
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

{{< include "/dos/dockerfiles/alpine-plus-dos-waf.md" >}}

### Amazon Linux Dockerfile example

{{< include "/dos/dockerfiles/amazon-plus-dos-waf.md" >}}

### Debian Docker Deployment Example

{{< include "/dos/dockerfiles/debian-plus-dos-waf.md" >}}

### Ubuntu Docker Deployment Example

{{< include "/dos/dockerfiles/ubuntu-plus-dos-waf.md" >}}

## F5 DoS for NGINX Arbitrator

{{< include "/dos/dos-arbitrator.md" >}}
    
## Post-Installation Checks

{{< include "dos/install-post-checks.md" >}}

To check F5 WAF for NGINX alongside F5 DoS for NGINX, just perform the normal tests as specified at [Admin Guide](https://docs.nginx.com/waf/install/virtual-environment/#post-installation-checks)

### Compatibility with NGINX Plus Releases

A threat campaign package is compatible with the NGINX Plus release supported during the time the threat campaign package was released and with all future releases from that point in time on. In other words, it is not compatible with earlier App Protect DoS releases. Those older releases are not supported at this point in time so you will have to upgrade App Protect DoS to benefit from the support which includes Threat campaigns updates.

## Upgrading App Protect DoS

You can upgrade to the latest NGINX Plus and App Protect DoS versions by downloading and installing the latest F5 DoS for NGINX package. When upgrading from this package, App Protect DoS will be uninstalled and reinstalled. The old default security policy is deleted and the new default security policy is installed. If you have created a custom security policy, the policy persists and you will need to update `nginx.conf` and point to the custom security policy by referencing the json file (using the full path).

If you upgrade your NGINX version outside the App Protect DoS module, App Protect DoS will be uninstalled and you will need to reinstall it. You need to restart NGINX after an upgrade.

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

