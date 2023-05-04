+++
authors = []
categories = ["controller guide"]
date = "2021-04-14T13:32:41+00:00"
description = "Take the steps in this guide to deploy NGINX App Protect WAF as a datapath instance for use with NGINX Controller."
doctypes = ["task"]
draft = false
journeys = ["researching", "getting started", "using", "self service"]
personas = ["devops", "netops", "secops", "support"]
roles = ["admin", "user"]
title = "Using NGINX App Protect WAF with NGINX Controller"
toc = true
versions = ["4.3"]
weight = 500
docs= "DOCS-645"

[menu]
  [menu.docs]
    parent = "NGINX App Protect WAF"
    weight = 45
+++


Take the steps in this guide to deploy NGINX App Protect WAF as a datapath instance for use with NGINX Controller.

{{< note >}}Refer to the [NGINX Controller Technical Specifications](/nginx-controller/admin-guides/install/nginx-controller-tech-specs/) guide to find out which distributions are supported for use with NGINX Controller and NGINX Controller Agent.{{< /note >}}

## Setup

Before proceeding, you should review the [Prerequisites]({{< relref "/nap-waf/admin-guide/install#prerequisites" >}}), [Platform Security Considerations]({{< relref "/nap-waf/admin-guide/install#platform-security-considerations" >}}) and [User Permissions]({{< relref "/nap-waf/admin-guide/install#user-permissions" >}}) sections of the NGINX App Protect WAF Admin Guide.


## Install NGINX App Protect WAF

{{< note >}}If a version of NGINX App Protect WAF prior to 3.6 is required, please contact the NGINX Sales team to assist with this configuration.{{< /note >}}

### CentOS 7.4+

1. If you already have NGINX packages in your system, back up your configs and logs:

   ```shell
   sudo cp -a /etc/nginx /etc/nginx-plus-backup
   sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
   ```

2. Create the `/etc/ssl/nginx/` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

3. Log in to the [NGINX Customer Portal](https://my.f5.com) and download the following two files:

   ```shell
   nginx-repo.key
   nginx-repo.crt
   ```
   {{< see-also >}}You can use the [NGINX Controller REST API to download the key and cert files](https://docs.nginx.com/nginx-controller/admin-guides/install/get-n-plus-cert-and-key/).{{< /see-also >}}

4. Copy the above two files to the CentOS server's `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

   ```shell
   sudo yum install ca-certificates epel-release wget
   ```

6. Remove any previously downloaded NGINX Plus repository file from /etc/yum.repos.d:

   ```shell
   sudo rm /etc/yum.repos.d/nginx-plus-*.repo
   ```

7. Add NGINX Plus repository by downloading the file nginx-plus-7.4.repo to /etc/yum.repos.d:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
   ```

8. Add NGINX App Protect WAF repository by downloading the file app-protect-7.repo to /etc/yum.repos.d:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
   ```

9. If NGINX Plus or NGINX App Protect WAF was previously installed on the system, clean up package manager cache information:

   ```shell
   sudo yum clean all
   ```

10. Install NGINX App Protect WAF package `app-protect-25+3.671.0`, which includes NGINX Plus 25 and NGINX App Protect WAF 3.6:

   ```shell
   sudo yum install app-protect-25+3.671.0
   ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

12. Configure SELinux as appropriate per your organization’s security policies. NGINX App Protect WAF applies the prebuilt SELinux policy module during the installation. If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/troubleshooting-guide/troubleshooting#selinux" >}}).

    {{< note >}}NGINX Controller has specific [requirements regarding SELinux configuration](http://docs.nginx.com/nginx-controller/admin-guides/install/nginx-controller-tech-specs/#supported-distributions).{{< /note >}}

13. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

14. Start the `bd_agent` service (for Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2 only)

If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, you need to start the `bd_agent`:

   ```shell
   /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
   ```

15. Verify NGINX Plus and BD processes are running:

    ```shell
    ps -ef | grep nginx
    ps -ef | grep bd
    ```

   {{< note >}} If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running: {{< /note >}}

   ```shell
   ps -ef | grep bd_agent
   ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< relref "/nap-waf/admin-guide/install#centos-rhel-74-amazon-linux-2">}}).

### Red Hat Enterprise Linux 7.4+

1. If you already have NGINX packages in your system, back up your configs and logs:

   ```shell
   sudo cp -a /etc/nginx /etc/nginx-plus-backup
   sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
   ```

2. Create the `/etc/ssl/nginx/` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

3. Log in to the [NGINX Customer Portal](https://my.f5.com) and download the following two files:

   ```shell
   nginx-repo.key
   nginx-repo.crt
   ```

4. Copy the above two files to the RHEL server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install prerequisite packages:

   ```shell
   sudo yum install ca-certificates wget
   ```

6. Remove any previously downloaded NGINX Plus repository file from /etc/yum.repos.d:

   ```shell
   sudo rm /etc/yum.repos.d/nginx-plus-*.repo
   ```

7. Add NGINX Plus repository by downloading the file `nginx-plus-7.4.repo` to `/etc/yum.repos.d`:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
   ```

8. Add NGINX App Protect WAF repository by downloading the file app-protect-7.repo to /etc/yum.repos.d:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
   ```

9. Enable Yum repositories to pull App Protect dependencies:

   - Download the file `dependencies.repo` to `/etc/yum.repos.d`:

      ```shell
      sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
      ```

   - If you have a RHEL subscription:

      ```shell
      sudo yum-config-manager --enable rhui-REGION-rhel-server-optional rhui-REGION-rhel-server-releases rhel-7-server-optional-rpms
      ```

   - If you don't have a RHEL subscription, you can pull the dependencies from the CentOS repository.

      Create a new repository, `centos.repo`, in `/etc/yum.repos.d/` with the content:

      ```shell
      [centos]
      name=CentOS-7
      baseurl=http://ftp.heanet.ie/pub/centos/7/os/x86_64/
      enabled=1
      gpgcheck=1
      gpgkey=http://ftp.heanet.ie/pub/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
      ```

8. If NGINX Plus or NGINX App Protect WAF was previously installed on the system, clean up package manager cache information:

   ```shell
   sudo yum clean all
   ```

9. Install NGINX App Protect WAF package `app-protect-25+3.671.0`, which includes NGINX Plus 25 and NGINX App Protect WAF 3.6:

    ```shell
    sudo yum install app-protect-25+3.671.0
    ```

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Configure SELinux as appropriate per your organization’s security policies. NGINX App Protect WAF applies the prebuilt SELinux policy module during the installation. If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/troubleshooting-guide/troubleshooting#selinux" >}}).

    {{< note >}}NGINX Controller has specific [requirements regarding SELinux configuration](http://docs.nginx.com/nginx-controller/admin-guides/install/nginx-controller-tech-specs/#supported-distributions).{{< /note >}}

12. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

13. Start the `bd_agent` service (for Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2 only)

If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, you need to start the `bd_agent`:

   ```shell
   /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
   ```

14. Verify NGINX Plus and BD processes are running:

    ```shell
    ps -ef | grep nginx
    ps -ef | grep bd
    ```

   {{< note >}} If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running: {{< /note >}}

   ```shell
   ps -ef | grep bd_agent
   ```

15. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< relref "/nap-waf/admin-guide/install#centos-rhel-74-amazon-linux-2" >}}).

### Debian 9

{{< note >}}As of NGINX Plus R24, support for Debian 9 is no longer available. As a consequence, NGINX App Protect WAF 3.1 is the final version available for this operating system version.{{< /note >}}

1. If you already have NGINX packages in your system, back up your configs and logs:

   ```shell
   sudo cp -a /etc/nginx /etc/nginx-plus-backup
   sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
   ```

2. Create the `/etc/ssl/nginx/` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

3. Log in to the [NGINX Customer Portal](https://my.f5.com) and download the following two files:

   ```shell
   nginx-repo.key
   nginx-repo.crt
   ```

4. Copy the above two files to the Debian server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install apt utils:

   ```shell
   sudo apt-get install apt-transport-https lsb-release ca-certificates wget
   ```

6. Download and add the NGINX signing key:

   ```shell
   sudo wget https://cs.nginx.com/static/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
   ```

7. Add NGINX Plus repository:

   ```shell
   printf "deb https://plus-pkgs.nginx.com/R23/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

8. Download the apt configuration to `/etc/apt/apt.conf.d`:

   ```shell
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx
   ```

9. Update the repository and install NGINX Plus 23 and NGINX App Protect WAF 3.1 packages:

   ```shell
   sudo apt-get update
   sudo apt-get install app-protect-compiler=6.53.1-1~stretch
   sudo apt-get install app-protect-engine=6.53.1-1~stretch
   sudo apt-get install app-protect-plugin=3.462.0-1~stretch
   sudo apt-get install nginx-plus-module-appprotect=23+3.462.0-1~stretch
   sudo apt-get install app-protect=23+3.462.0-1~stretch
   ```

10. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

11. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

12. Verify NGINX Plus and BD processes are running:

    ```shell
    ps -ef | grep nginx
    ps -ef | grep bd
    ```

13. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< relref "/nap-waf/admin-guide/install#debian-9" >}}).

### Debian 10

1. If you already have NGINX packages in your system, back up your configs and logs:

   ```shell
   sudo cp -a /etc/nginx /etc/nginx-plus-backup
   sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
   ```

2. Create the `/etc/ssl/nginx/` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

3. Log in to the [NGINX Customer Portal](https://my.f5.com) and download the following two files:

   ```shell
   nginx-repo.key
   nginx-repo.crt
   ```

4. Copy the above two files to the Debian server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install apt utils:

   ```shell
   sudo apt-get install apt-transport-https lsb-release ca-certificates wget
   ```

6. Download and add the NGINX signing key:

   ```shell
   sudo wget https://cs.nginx.com/static/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
   ```

7. Remove any previous NGINX Plus repository and apt configuration files:

   ```shell
   sudo rm /etc/apt/sources.list.d/nginx-plus.list
   sudo rm /etc/apt/apt.conf.d/90nginx
   ```

8. Add NGINX Plus repository:

   ```shell
   printf "deb https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

9. Add NGINX App Protect WAF repository:

   ```shell
   printf "deb https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
   ```

10. Download the apt configuration to `/etc/apt/apt.conf.d`:

   ```shell
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
   ```

11. Update the repository and install NGINX Plus 25 and NGINX App Protect WAF 3.6 packages:

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-compiler=8.12.1-1~buster
    sudo apt-get install app-protect-plugin=3.671.0-1~buster
    sudo apt-get install app-protect-engine=8.12.1-1~buster
    sudo apt-get install nginx-plus-module-appprotect=25+3.671.0-1~buster
    sudo apt-get install app-protect=25+3.671.0-1~buster
    ```

12. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

13. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

14. Start the `bd_agent` service (for Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2 only)

If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, you need to start the `bd_agent`:

   ```shell
   /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
   ```

15. Verify NGINX Plus and BD processes are running:

    ```shell
    ps -ef | grep nginx
    ps -ef | grep bd
    ```

   {{< note >}} If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that the `bd_agent` is running: {{< /note >}}

   ```shell
   ps -ef | grep bd_agent
   ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< relref "/nap-waf/admin-guide/install#debian-10" >}}).

### Ubuntu 18.04

1. If you already have NGINX packages in your system, back up your configs and logs:

   ```shell
   sudo cp -a /etc/nginx /etc/nginx-plus-backup
   sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
   ```

2. Create the `/etc/ssl/nginx/` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

3. Log in to the [NGINX Customer Portal](https://my.f5.com) and download the following two files:

   ```shell
   nginx-repo.key
   nginx-repo.crt
   ```

4. Copy the above two files to the Ubuntu server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install apt utils:

   ```shell
   sudo apt-get install apt-transport-https lsb-release ca-certificates wget
   ```

6. Download and add the NGINX signing key:

   ```shell
   sudo wget https://cs.nginx.com/static/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
   ```

7. Remove any previous NGINX Plus repository and apt configuration files:

   ```shell
   sudo rm /etc/apt/sources.list.d/nginx-plus.list
   sudo rm /etc/apt/apt.conf.d/90nginx
   ```

8. Add NGINX Plus repository:

   ```shell
   printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

9. Add NGINX App Protect WAF repository:

   ```shell
   printf "deb https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
   ```

10. Download the apt configuration to `/etc/apt/apt.conf.d`:

   ```shell
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
   ```

11. Update the repository and install NGINX Plus 25 and NGINX App Protect WAF 3.6 packages:

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-compiler=8.12.1-1~bionic
    sudo apt-get install app-protect-plugin=3.671.0-1~bionic
    sudo apt-get install app-protect-engine=8.12.1-1~bionic
    sudo apt-get install nginx-plus-module-appprotect=25+3.671.0-1~bionic
    sudo apt-get install app-protect=25+3.671.0-1~bionic
    ```

12. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

13. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

14. Start the `bd_agent` service (for Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2 only)

If you plan to use this instance with Controller Agent 3.20.1, you need to start `bd_agent`:

   ```shell
   /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
   ```

15. Verify NGINX Plus and BD processes are running:

    ```shell
    ps -ef | grep nginx
    ps -ef | grep bd
    ```

   {{< note >}} If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running: {{< /note >}}

   ```shell
   ps -ef | grep bd_agent
   ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< relref "/nap-waf/admin-guide/install#ubuntu-18-04" >}}).

### Ubuntu 20.04

1. If you already have NGINX packages in your system, back up your configs and logs:

   ```shell
   sudo cp -a /etc/nginx /etc/nginx-plus-backup
   sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
   ```

2. Create the `/etc/ssl/nginx/` directory:

   ```shell
   sudo mkdir -p /etc/ssl/nginx
   ```

3. Log in to the [NGINX Customer Portal](https://my.f5.com) and download the following two files:

   ```shell
   nginx-repo.key
   nginx-repo.crt
   ```

4. Copy the above two files to the Ubuntu server’s `/etc/ssl/nginx/` directory. Use an SCP client or another secure file transfer tool to perform this task.

5. Install apt utils:

   ```shell
   sudo apt-get install apt-transport-https lsb-release ca-certificates wget
   ```

6. Download and add the NGINX signing key:

   ```shell
   sudo wget https://cs.nginx.com/static/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
   ```

7. Remove any previous NGINX Plus repository and apt configuration files:

   ```shell
   sudo rm /etc/apt/sources.list.d/nginx-plus.list
   sudo rm /etc/apt/apt.conf.d/90nginx
   ```

8. Add NGINX Plus repository:

   ```shell
   printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

9. Add NGINX App Protect WAF repository:

   ```shell
   printf "deb https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
   ```

10. Download the apt configuration to `/etc/apt/apt.conf.d`:

   ```shell
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
   ```

11. Update the repository and install NGINX Plus 25 and NGINX App Protect WAF 3.6 packages:

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-compiler=8.12.1-1~focal
    sudo apt-get install app-protect-plugin=3.671.0-1~focal
    sudo apt-get install app-protect-engine=8.12.1-1~focal
    sudo apt-get install nginx-plus-module-appprotect=25+3.671.0-1~focal
    sudo apt-get install app-protect=25+3.671.0-1~focal
    ```

12. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

    ```shell
    sudo nginx -v
    ```

13. Start the NGINX service:

    ```shell
    sudo systemctl start nginx
    ```

14. Start the `bd_agent` service (for Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2 only)

If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, you need to start `bd_agent`:

   ```shell
   /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
   ```

15. Verify NGINX Plus and BD processes are running:

    ```shell
    ps -ef | grep nginx
    ps -ef | grep bd
    ```

   {{< note >}} If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running: {{< /note >}}

   ```shell
   ps -ef | grep bd_agent
   ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< relref "/nap-waf/admin-guide/install#ubuntu-20-04" >}}).

{{< note >}}Ubuntu 20.04 activates __AppArmor__ by default, but NGINX App Protect WAF will run in unconfined mode after being installed as it is shipped with no AppArmor profile. To benefit from AppArmor access control capabilities for NGINX App Protect WAF, you will have to write your own AppArmor profile for NGINX App Protect WAF executables found in `/opt/app_protect/bin` such that it best suits your environment. {{< /note >}}

### Amazon Linux 2 LTS 

Using NGINX App Protect WAF with NGINX Controller isn't supported on Amazon Linux 2 LTS.

### Alpine

Using NGINX App Protect WAF with NGINX Controller isn't supported on Alpine.

## Add NGINX App Protect WAF to NGINX Controller

If this NGINX Plus instance is already managed by Controller, [restart the Agent](https://docs.nginx.com/nginx-controller/admin-guides/install/agent-restart) after NGINX App Protect WAF is installed.

Otherwise, complete the tasks in the NGINX Controller [Add an NGINX App Protect WAF Instance](https://docs.nginx.com/nginx-controller/infrastructure/instances/add-nap-instance/#add-the-nginx-app-protect-instance) guide.

## Use NGINX App Protect WAF with NGINX Controller

{{< note >}}When configuring NGINX App Protect WAF as a datapath instance for NGINX Controller, **you should not modify the `nginx.conf` file**. The `nginx.conf` file will be automatically updated when enabling WAF on a Component in NGINX Controller. {{< /note >}}

Refer to the following NGINX Controller user guides for further information about how to secure your apps and/or APIs with NGINX Controller:

- [Learn about App Security for the NGINX Controller App Delivery module](https://docs.nginx.com/nginx-controller/app-delivery/security/concepts/what-is-waf/)
- [Add Security to your Apps with the NGINX Controller App Delivery module](https://docs.nginx.com/nginx-controller/app-delivery/security/tutorials/add-app-security-with-waf/)
- [Add Advanced Security (WAF) to your APIs with the NGINX Controller API Management module](https://docs.nginx.com/nginx-controller/api-management/manage-apis/#define-the-routing-rules).
