---
description: Complete the steps in this guide to install the Developer Portal directly
  from package files in environments without Internet access.
nd-docs: DOCS-1215
title: Install the Developer Portal in an Offline Environment
toc: true
weight: 30
type:
- tutorial
---

{{< dev-portal-dedicated-host >}}


## Prerequisites

The Developer Portal requires [PostgreSQL](https://www.postgresql.org), [F5 NGINX Plus R24](https://docs.nginx.com/nginx/) or later, and [njs](https://nginx.org/en/docs/njs/).

### PostgreSQL

You can install the PostgreSQL package from your distribution’s repo at the same time you install the operating system. Refer to the the [PostgreSQL download guide](https://www.postgresql.org/download/) for instructions.

### NGINX Plus and njs

To install NGINX Plus and njs, take the following steps on the Developer Portal host:

1. Log in to MyF5 and download your `nginx-repo.crt` and `nginx-repo.key` files.
2. Copy the `nginx-repo.crt` and `nginx-repo.key` files to the `/etc/ssl/nginx/` directory:

    ```bash
    sudo cp nginx-repo.crt /etc/ssl/nginx/
    sudo cp nginx-repo.key /etc/ssl/nginx/
    ```

3. Select the following link to download the `fetch-external-acm-dataplane-dependencies.sh` script. This script downloads the necessary NGINX Plus and njs packages to a `tar.gz` archive.

    {{<icon "download">}} {{<link "/scripts/fetch-external-acm-dataplane-dependencies.sh" "Download fetch-external-acm-dataplane-dependencies.sh script">}}

4. To download the NGINX Plus and njs dependencies, run the `fetch-external-acm-dataplane-dependencies.sh` script. As parameters, specify your Linux distribution and the location of your `nginx-repo.crt` and `nginx-repo.key` files.

    ```bash
    sudo bash fetch-external-acm-dataplane-dependencies.sh <linux distribution> /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key
    ```

    Supported Linux distributions:

    - `ubuntu18.04`
    - `ubuntu20.04`
    - `ubuntu22.04`
    - `debian10`
    - `debian11`
    - `centos7`
    - `rhel7`
    - `rhel8`
    - `rhel9`
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
sudo yum localinstall *.rpm
```

    {{%/tab%}}
    {{%tab name="Debian, Ubuntu, and Deb-Based"%}}

```bash
tar -kzxvf acm-dataplane-dependencies-<linux-distribution>.tar.gz
sudo dpkg -i ./*.deb
```

{{%/tab%}}
{{</tabs>}}

---

## Install the Developer Portal

{{<tabs name="install_devportal_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the NGINX Developer Portal package files.

2. Install the NGINX Developer Portal packages:

   ```bash
   sudo yum -y --nogpgcheck install /home/user/nginx-devportal-<version>.x86_64.rpm
   sudo yum -y --nogpgcheck install /home/user/nginx-devportal-ui-<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the NGINX Developer Portal package files.

2. Install the NGINX Developer Portal package:

   ```bash
   sudo apt-get -y install -f /home/user/nginx-devportal_<version>_amd64.deb
   sudo apt-get -y install -f /home/user/nginx-devportal-ui_<version>_amd64.deb
   ```

{{%/tab%}}
{{</tabs>}}

3. Enable the Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

4. Start the Developer Portal service:

   ```bash
   sudo systemctl restart nginx-devportal.service
   ```

---

## Upgrade the Developer Portal

To upgrade the Developer Portal in an offline environment, take the following steps:

{{<tabs name="upgrade_dev_portal_offline">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Developer Portal package files.

2. Upgrade the Developer Portal packages:

   ```bash
   sudo yum -y --nogpgcheck update /home/user/nginx-devportal_<version>.x86_64.rpm
   sudo yum -y --nogpgcheck update /home/user/nginx-devportal-ui_<version>.x86_64.rpm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. Log in to the [MyF5 Customer Portal](https://account.f5.com/myf5) and download the Developer Portal package files.

2. Upgrade the Developer Portal packages:

   ```bash
   sudo apt-get -y install -f /home/user/nginx-devportal_<version>_amd64.deb
   sudo apt-get -y install -f /home/user/nginx-devportal-ui_<version>_amd64.deb
   ```

{{%/tab%}}
{{</tabs>}}

3. Enable the following Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

4. Restart the Developer Portal service:

   ```bash
   sudo systemctl restart nginx-devportal.service
   ```
