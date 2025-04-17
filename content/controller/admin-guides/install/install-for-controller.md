---
description: Take the steps in this guide to deploy F5 NGINX App Protect WAF as a
  datapath instance for use with NGINX Controller.
docs: DOCS-645
title: Using NGINX App Protect WAF with NGINX Controller
toc: true
weight: 500
type:
- how-to
---

**Note:** Refer to the [F5 NGINX Controller Technical Specifications]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) guide to find out which distributions are supported for use with NGINX Controller and NGINX Controller Agent.

## Setup

Before proceeding, you should review the [Prerequisites]({{< ref "/nap-waf/v4/admin-guide/install#prerequisites" >}}), [Platform Security Considerations]({{< ref "/nap-waf/v4/admin-guide/install#platform-security-considerations" >}}) and [User Permissions]({{< ref "/nap-waf/v4/admin-guide/install#user-permissions" >}}) sections of the NGINX App Protect WAF Admin Guide.


## Install NGINX App Protect WAF

**Note:** If a version of NGINX App Protect WAF prior to 3.6 is required, please contact the NGINX Sales team to assist with this configuration.

{{<tabs name="install-nap-waf">}}

{{%tab name="CentOS 7.4+"%}}

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

   **See Also:** You can use the [NGINX Controller REST API to download the key and cert files]({{< ref "/controller/admin-guides/install/get-n-plus-cert-and-key" >}}).

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

10. Install the latest NGINX App Protect WAF package.

      **See Also:** Please refer to [NGINX App Protect Compatibility Matrix]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-app-protect-compatibility-matrix" >}}) for specific version compatibility.

      If you wish to install a specific version, please replace `app-protect` with the target version, for example `app-protect-25+3.671.0`:

      ```shell
      sudo yum install app-protect
      ```

11. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

      ```shell
      sudo nginx -v
      ```

12. Configure SELinux as appropriate per your organization’s security policies. NGINX App Protect WAF applies the prebuilt SELinux policy module during the installation. If you encounter any issues, check the [Troubleshooting Guide]({{< ref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

      **Note:** NGINX Controller has specific [requirements regarding SELinux configuration]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#supported-distributions" >}}).

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

      **Note:** If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running:

      ```shell
      ps -ef | grep bd_agent
      ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< ref "/nap-waf/v4/admin-guide/install#centos--rhel-74--amazon-linux-2">}}).

{{%/tab%}}

{{%tab name="Red Hat Enterprise Linux 7.4+"%}}

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

10. If NGINX Plus or NGINX App Protect WAF was previously installed on the system, clean up package manager cache information:

    ```shell
    sudo yum clean all
    ```

11. Install the latest NGINX App Protect WAF package.

      **See Also:** Please refer to [NGINX App Protect Compatibility Matrix]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-app-protect-compatibility-matrix" >}}) for specific version compatibility.

      If you wish to install a specific version, please replace `app-protect` with the target version, for example `app-protect-25+3.671.0`:

      ```shell
      sudo yum install app-protect
      ```

12. Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:

      ```shell
      sudo nginx -v
      ```

13. Configure SELinux as appropriate per your organization’s security policies. NGINX App Protect WAF applies the prebuilt SELinux policy module during the installation. If you encounter any issues, check the [Troubleshooting Guide]({{< ref "/nap-waf/v4/troubleshooting-guide/troubleshooting#selinux" >}}).

      **Note:** NGINX Controller has specific [requirements regarding SELinux configuration]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#supported-distributions" >}}).

14. Start the NGINX service:

      ```shell
      sudo systemctl start nginx
      ```

15. Start the `bd_agent` service (for Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2 only)

      If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, you need to start the `bd_agent`:

      ```shell
      /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
      ```

16. Verify NGINX Plus and BD processes are running:

      ```shell
      ps -ef | grep nginx
      ps -ef | grep bd
      ```

      **Note:**  If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running:

      ```shell
      ps -ef | grep bd_agent
      ```

17. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< ref "/nap-waf/v4/admin-guide/install#centos--rhel-74--amazon-linux-2" >}}).

{{%/tab%}}

{{%tab name="Debian"%}}

**Note:** As of NGINX Plus R24, support for Debian 9 is no longer available. As a consequence, NGINX App Protect WAF 3.1 is the final version available for this operating system version.

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

11. Update the repository and install the lastest supported NGINX App Protect WAF packages.

      **See Also:** Please refer to [NGINX App Protect Compatibility Matrix]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-app-protect-compatibility-matrix" >}}) for specific version compatibility.

      ```shell
      sudo apt-get update
      sudo apt-get install nginx-plus-module-appprotect
      ```

      To install a specific version based on the NGINX Plus version, for example `r25`, follow these steps:

      ```shell
      sudo apt-cache policy app-protect | grep 25+
            25+3.760.0-1~buster 500
            25+3.733.0-1~buster 500
            25+3.671.0-1~buster 500

      sudo apt-get install  nginx-plus-module-appprotect=25+3.671.0-1~buster
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

    **Note:** If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that the `bd_agent` is running:

      ```shell
      ps -ef | grep bd_agent
      ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< ref "/nap-waf/v4/admin-guide/install#debian-10" >}}).

{{%/tab%}}

{{%tab name="Ubuntu"%}}

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

11. Update the repository and install the latest App Protect WAF package.

      **See Also:** Please refer to [NGINX App Protect Compatibility Matrix]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-app-protect-compatibility-matrix" >}}) for specific version compatibility.

      ```shell
      sudo apt-get update
      sudo apt-get install app-protect
      ```

      To install a specific version based on the NGINX Plus version, for example `r25`, follow these steps:

      ```shell
      sudo apt-cache policy app-protect | grep 25+
         25+3.760.0-1~bionic 500
         25+3.733.0-1~bionic 500
         25+3.671.0-1~bionic 500

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

      **Note:**  If you plan to use this instance with Controller ADC Agent 3.20.1 or Controller APIM Agent 3.19.2, also verify that `bd_agent` is running:

      ```shell
      ps -ef | grep bd_agent
      ```

16. To upgrade your signature package to the latest version and obtain the best protection, refer to [Updating App Protect Attack Signatures]({{< ref "/nap-waf/v4/admin-guide/install#ubuntu-1804" >}}).

   **Note:** Ubuntu 20.04 activates **AppArmor** by default, but NGINX App Protect WAF will run in unconfined mode after being installed as it is shipped with no AppArmor profile. To benefit from AppArmor access control capabilities for NGINX App Protect WAF, you will have to write your own AppArmor profile for NGINX App Protect WAF executables found in `/opt/app_protect/bin` such that it best suits your environment.

{{%/tab%}}

{{%tab name="Amazon Linux 2 LTS"%}}

Using NGINX App Protect WAF with NGINX Controller isn't supported on Amazon Linux 2 LTS.

{{%/tab%}}

{{%tab name="Alpine"%}}

Using NGINX App Protect WAF with NGINX Controller isn't supported on Alpine.

{{%/tab%}}
{{</tabs>}}

<hr>

## Add NGINX App Protect WAF to NGINX Controller

If this NGINX Plus instance is already managed by Controller, [restart the Agent]({{< ref "/controller/admin-guides/install/agent-restart" >}}) after NGINX App Protect WAF is installed.

Otherwise, complete the tasks in the NGINX Controller [Add an NGINX App Protect WAF Instance]({{< ref "/controller/infrastructure/instances/add-nap-instance.md#add-the-nginx-app-protect-instance" >}}) guide.

## Use NGINX App Protect WAF with NGINX Controller

**Note:** When configuring NGINX App Protect WAF as a datapath instance for NGINX Controller, **you should not modify the `nginx.conf` file**. The `nginx.conf` file will be automatically updated when enabling WAF on a Component in NGINX Controller.

Refer to the following NGINX Controller user guides for further information about how to secure your apps and/or APIs with NGINX Controller:

- [Learn about App Security for the NGINX Controller App Delivery module]({{< ref "/controller/app-delivery/security/concepts/what-is-waf" >}})
- [Add Security to your Apps with the NGINX Controller App Delivery module]({{< ref "/controller/app-delivery/security/tutorials/add-app-security-with-waf" >}})
- [Add Advanced Security (WAF) to your APIs with the NGINX Controller API Management module]({{< ref "/controller/api-management/manage-apis.md#define-the-routing-rules" >}}).
