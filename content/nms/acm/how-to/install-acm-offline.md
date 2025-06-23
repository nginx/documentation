---
title: "Offline Installation Guide"
nd-docs: "DOCS-1669"
---

## Install or Upgrade API Connectivity Manager {#install-or-upgrade-acm-offline}

{{< eol-call-out "warning" "End of Sale Notice:" >}}
F5 NGINX is announcing the **End of Sale (EoS)** for NGINX Instance Manager API Connectivity Manager Module, **effective January 1, 2024**.

F5 maintains generous lifecycle policies that allow customers to continue support and receive product updates. Existing API Connectivity Manager Module customers can continue to use the product past the EoS date. **License renewals are not available after September 30, 2024**.

See our [End of Sale announcement](https://my.f5.com/manage/s/article/K000137989) for more details.
{{< /eol-call-out >}}

### Dependencies with Instance Manager {#acm-nim-dependencies}

{{< include "tech-specs/acm-nim-dependencies.md" >}}

### Install API Connectivity Manager {#install-acm}

{{< call-out "important" >}}
API Connectivity Manager requires Instance Manager to be installed first.

Before you begin:

1. Review the [Dependencies with Instance Manager](#acm-nim-dependencies) table above.
2. [Install a compatible version of Instance Manager](#install-nim-offline).
{{< /call-out >}}

&nbsp;

{{<tabs name="install_acm_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

To install API Connectivity Manager, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the API Connectivity Manager package files.

2. Install the API Connectivity Manager package:

   ```bash
   sudo rpm -ivh --nosignature /home/<user>/nms-api-connectivity-manager_<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

To install API Connectivity Manager, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the API Connectivity Manager package files.

2. Install the API Connectivity Manager package:

   ```bash
   sudo apt-get install -f /home/<user>/nms-api-connectivity-manager_<version>_amd64.deb
   ```


{{%/tab%}}
{{</tabs>}}

3. Enable and start the API Connectivity Manager service:

    ```bash
    sudo systemctl enable nms-acm --now
    ```

    F5 NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

4. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

### Post-Installation Steps {#acm-post-install-steps}

{{< include "installation/optional-installation-steps.md" >}}

See these topics below for instructions on how to access the web interface and add your license:

- [Access the web interface](#access-web-ui)
- [Add a license](#add-license)

### Upgrade API Connectivity Manager {#upgrade-acm-offline}

{{<tabs name="upgrade-acm-offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

To upgrade API Connectivity Manager to a newer version, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the API Connectivity Manager package file.

2. Upgrade the API Connectivity Manager package:

   ```bash
   sudo rpm -Uvh --nosignature /home/user/nms-api-connectivity-manager_<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

To upgrade API Connectivity Manager to a newer version, take the following steps:

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the API Connectivity Manager package file.

2. Upgrade the API Connectivity Manager package:

   ```bash
   sudo apt-get -y install -f /home/user/nms-api-connectivity-manager_<version>_amd64.deb
   ```

{{%/tab%}}
{{</tabs>}}


3. Restart the NGINX Management Suite platform services:

    ```bash
    sudo systemctl restart nms
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

4. Restart the API Connectivity Manager service:

   ```bash
    sudo systemctl restart nms-acm
    ```

5. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

6. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore SELinux contexts (`restorecon`) for the files and directories related to NGINX Management Suite.


### Set Up the Data Plane {#acm-offline-dependencies}

The API Connectivity Manager data plane requires [NGINX Plus R24](https://docs.nginx.com/nginx/) or later and [njs](https://nginx.org/en/docs/njs/)..

1. Log in to MyF5 and download your `nginx-repo.crt` and `nginx-repo.key` files.
2. Copy the `nginx-repo.crt` and `nginx-repo.key` files to the `/etc/ssl/nginx/` directory:

    ```bash
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

3. Select the following link to download the `fetch-external-acm-dataplane-dependencies.sh` script. This script downloads the necessary NGINX Plus and njs packages to a `tar.gz` archive.

    {{< icon "download">}} {{<link "/scripts/fetch-external-acm-dataplane-dependencies.sh" "Download fetch-external-acm-dataplane-dependencies.sh script">}}

4. To download the NGINX Plus and njs dependencies, run the `fetch-external-acm-dataplane-dependencies.sh` script. As parameters, specify your Linux distribution and the location of your `nginx-repo.crt` and `nginx-repo.key` files.

    ```bash
    sudo bash fetch-external-acm-dataplane-dependencies.sh <linux distribution> /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key
    ```

    Supported Linux distributions:

    - `ubuntu18.04`
    - `ubuntu20.04`
    - `debian10`
    - `debian11`
    - `centos7`
    - `centos8`
    - `rhel7`
    - `rhel8`
    - `amzn2`

    For example, to download external dependencies for Ubuntu 20.04:

    ```bash
    sudo bash fetch-external-acm-dataplane-dependencies.sh ubuntu20.04 /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key
    ```

    In this example, the script creates an archive called `acm-dataplane-dependencies-ubuntu20.04.tar.gz` with the external dependencies.

5. After you copy and extract the bundle onto your target machine, take the following steps to install the packages:

    {{< call-out "note" >}}The bundled NGINX Plus package may conflict with installed versions of NGINX Plus. Delete the package from the bundle if you want to keep the existing version.{{< /call-out >}}

    {{<tabs name="install-acm-dataplane-dependencies">}}
    {{%tab name="CentOS, RHEL, and RPM-Based"%}}

```bash
tar -kzxvf acm-dataplane-dependencies-<linux-distribution>.tar.gz
sudo rpm -ivh *.rpm
```

    {{%/tab%}}
    {{%tab name="Debian, Ubuntu, and Deb-Based"%}}

```bash
tar -kzxvf acm-dataplane-dependencies-<linux-distribution>.tar.gz
sudo dpkg -i ./*.deb
```

{{%/tab%}}
{{</tabs>}}
