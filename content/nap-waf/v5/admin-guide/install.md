---
title: Installing NGINX App Protect WAF
weight: 200
toc: true
type: how-to
product: NAP-WAF
nd-docs: DOCS-1363
---

## Prerequisites

- Active F5 NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial).
- Docker (with Docker Compose) is [installed and running](https://docs.docker.com/engine/install/).
- A [supported operating system]({{< ref "/nginx/technical-specs.md#appprotect" >}}) (OS).

## Install NGINX and NGINX App Protect WAF Module

If you already have NGINX packages in your system, back up your configuration and log files:

```shell
sudo cp -a /etc/nginx /etc/nginx-plus-backup
sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
```

1. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files.

1. If any old NGINX App Protect packages are installed, make sure to remove them.

1. Follow the steps below for the operating system you are working with.

{{< call-out "note" >}}
If not already installed, `nginx` or `nginx-plus` will be installed automatically as a dependency.
{{< /call-out >}}


### Common Steps for NGINX Open Source and NGINX Plus
Please follow these steps before you install either NGINX Open Source or NGINX Plus.

{{<tabs name="common_steps_for_nginx_oss_and_plus">}}

{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-alpine" >}}

{{%/tab%}}

{{%tab name="Amazon Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-amazon.md" >}}

{{%/tab%}}

{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-debian" >}}

{{%/tab%}}

{{%tab name="Oracle Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}

{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}

{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}

{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-ubuntu.md" >}}

{{%/tab%}}

{{</tabs>}}

### For NGINX Open Source

{{<tabs name="for_nginx_open_source">}}


{{%tab name="Amazon Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-amazon.md" >}}

{{%/tab%}}

{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-alpine.md" >}}

{{%/tab%}}

{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-debian.md" >}}

{{%/tab%}}

{{%tab name="Oracle Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-centos.md" >}}

{{%/tab%}}

{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-centos.md" >}}

{{%/tab%}}

{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-centos.md" >}}

{{%/tab%}}

{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-ubuntu.md" >}}

{{%/tab%}}

{{</tabs>}}

---

### For NGINX Plus

To use NGINX Plus, you will need to download the the JWT license file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

Once you have the license file:

{{< include "licensing-and-reporting/apply-jwt.md" >}}

Then you can move onto the next step, depending on your chosen operating system.

{{<tabs name="for_nginx_plus">}}

{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-alpine.md" >}}

{{%/tab%}}

{{%tab name="Amazon Linux"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-amazon.md" >}}

{{%/tab%}}

{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-debian.md" >}}

{{%/tab%}}

{{%tab name="Oracle Linux / RHEL 8.1+"%}}

Download the NGINX Plus repository file [nginx-plus-8.repo](https://cs.nginx.com/static/files/nginx-plus-8.repo) to `/etc/yum.repos.d`:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
```

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-centos-8.md" >}}


{{%/tab%}}

{{%tab name="RHEL 9 / Rocky Linux 9"%}}

Download the NGINX Plus repository file [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) to `/etc/yum.repos.d`:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
```

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-centos-9.md" >}}

{{%/tab%}}

{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-ubuntu.md" >}}

{{%/tab%}}

{{</tabs>}}

---

## NGINX Configuration

In your nginx configuration:

1. Load the NGINX App Protect WAF v5 module at the main context:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

2. Configure the Enforcer address at the `http` context:

    ```nginx
    app_protect_enforcer_address 127.0.0.1:50000;
    ```

3. Enable NGINX App Protect WAF on an `http/server/location` context (make sure you only enable NGINX App Protect WAF with `proxy_pass`/`grpc_pass` locations):

    ```nginx
    app_protect_enable on;
    ```

In this guide, the following files are used:

{{<tabs name="nap5_install_conf_files_localhost">}}
{{%tab name="nginx.conf"%}}

`/etc/nginx/nginx.conf`

{{< include "nap-waf/nginx-conf-localhost.md" >}}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/etc/nginx/conf.d/default.conf`

{{< include "nap-waf/default-conf-localhost.md" >}}

{{%/tab%}}
{{</tabs>}}

## WAF Services Configuration

### Permissions

Set up the directories with the correct ownership for NGINX App Protect WAF v5 services, where `101:101` are the default UID/GID.

Create Directories:

```shell
sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config
```

Set Ownership:

```shell
sudo chown -R 101:101 /opt/app_protect/
```

### Set up Docker for F5 Container Registry

{{< include "nap-waf/setup-docker-registry.md" >}}

### Docker Compose File

Create a `docker-compose.yml` with the following configuration:

Replace `waf-enforcer` and `waf-config-mgr` tag with the actual release version tag you are deploying. We are using version `5.2.0` for this example deployment.

```yaml
services:
  waf-enforcer:
    container_name: waf-enforcer
    image: private-registry.nginx.com/nap/waf-enforcer:5.2.0
    environment:
      - ENFORCER_PORT=50000
    ports:
      - "50000:50000"
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always

  waf-config-mgr:
    container_name: waf-config-mgr
    image: private-registry.nginx.com/nap/waf-config-mgr:5.2.0
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /opt/app_protect/config:/opt/app_protect/config
      - /etc/app_protect/conf:/etc/app_protect/conf
    restart: always
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

networks:
  waf_network:
    driver: bridge
```

{{< call-out "note" >}}
In some operating systems, security mechanisms like **SELinux** or **AppArmor** are enabled by default, potentially blocking necessary file access for the `nginx` process and `waf-config-mgr` and `waf-enforcer` containers. To ensure NGINX App Protect WAF v5 operates smoothly without compromising security, consider setting up a custom SELinux policy or AppArmor profile. For short-term troubleshooting, you may use `permissive` (SELinux) or `complain` (AppArmor) mode to avoid these restrictions, but keep in mind that this lowers security and isn't advised for prolonged use.
{{< /call-out >}}

### Docker Compose File with IP Intelligence

{{< include "nap-waf/ip-intelligence.md" >}}

## Start the Deployment

1. To start the WAF services, navigate to the directory that contains the `docker-compose.yml` file and run:

    ```shell
    sudo docker compose up -d
    ```

2. To start the NGINX, run:

    ```shell
    sudo nginx
    ```

3. To verify the enforcement functionality, ensure the following request is rejected:

    ```shell
    curl "localhost/<script>"
    ```

## Using IP intelligence feature

{{< include "nap-waf/ip-intelligence.md" >}}

## Using Policy and Logging Profile Bundles

{{< include "nap-waf/bundles-volume-mount.md" >}}

After deploying NGINX App Protect WAF, learn how to utilize the [NGINX App Protect WAF Compiler]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}}) for applying your custom policies and logging profiles.

## Air-Gap Install: Secure Offline Installation

### Install NGINX and NGINX App Protect WAF module

1. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files on your online machine.

2. If any old NGINX App Protect packages are installed, make sure to remove them.

3. Follow the steps below for the operating system you are working with.

{{< call-out "note" >}}
If not already installed, `nginx` or `nginx-plus` will be installed automatically as a dependency.
{{< /call-out >}}

### Common Steps for NGINX Open Source and NGINX Plus

Follow these steps before you install NGINX Open Source or NGINX Plus.

{{<tabs name="offline_common_steps_for_nginx_oss_and_plus">}}

{{%tab name="Alpine Linux 3.16/3.17/3.19"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-alpine" >}}

{{%/tab%}}

{{%tab name="Amazon Linux 2023"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-amazon.md" >}}

{{%/tab%}}
{{%tab name="Debian 11"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-debian" >}}

{{%/tab%}}
{{%tab name="Debian 12"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-debian" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8.1+"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}
{{%tab name="RHEL 8.1+"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}
{{%tab name="RHEL 9"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}
{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-dnf.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu 20.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-ubuntu.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu 22.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-ubuntu.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu 24.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/common-steps-with-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

### For NGINX Open Source

{{<tabs name="offline_for_nginx_open_source">}}

{{%tab name="Alpine Linux 3.16"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-alpine.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir /etc/packages/
    sudo apk update
    sudo apk fetch --recursive --output /etc/packages app-protect-module-oss
    ```

{{%/tab%}}

{{%tab name="Alpine Linux 3.17"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-alpine.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir /etc/packages/
    sudo apk update
    sudo apk fetch --recursive --output /etc/packages app-protect-module-oss
    ```

{{%/tab%}}

{{%tab name="Alpine Linux 3.19"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-alpine.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir /etc/packages/
    sudo apk update
    sudo apk fetch --recursive --output /etc/packages app-protect-module-oss
    ```

{{%/tab%}}

{{%tab name="Amazon Linux 2"%}}

1. Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

    ```none
    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/amzn2/$releasever/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-oss.repo` with the following contents:

    ```none
    [app-protect-x-oss]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/7/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package:

    ```shell
    sudo yum install app-protect-module-oss
    sudo apt-get install nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss
    ```

    When prompted to accept the GPG key, verify that the fingerprint matches `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.

{{%/tab%}}
{{%tab name="Amazon Linux 2023"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-amazon.md" >}}

3. Download all NGINX Open Source packages, including all dependencies: We used `repotrack` for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-oss
    ```

{{%/tab%}}
{{%tab name="Debian 11"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-debian.md" >}}

4. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Debian 12"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-debian.md" >}}

4. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}

{{%tab name="Oracle Linux 8.1+"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-centos.md" >}}


3. Download all NGINX Open Source packages, including all dependencies: We used `repotrack` for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-oss
    ```

{{%/tab%}}

{{%tab name="RHEL 8.1+"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-centos.md" >}}

3. Download all NGINX Open Source packages, including all dependencies: We used `repotrack` for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-oss
    ```

{{%/tab%}}
{{%tab name="RHEL 9 / Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-centos.md" >}}

3. Download all NGINX Open Source packages, including all dependencies: We used `repotrack` for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-oss
    ```

{{%/tab%}}
{{%tab name="Ubuntu 20.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-ubuntu.md" >}}

4. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Ubuntu 22.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-ubuntu.md" >}}

4. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Ubuntu 24.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-oss-ubuntu.md" >}}

4. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{</tabs>}}

### For NGINX Plus

To use NGINX Plus, you will need to download the the JWT license file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

Once you have the license file:

{{< include "licensing-and-reporting/apply-jwt.md" >}}

Then you can move onto the next step, depending on your chosen operating system.

{{<tabs name="offline_for_nginx_plus">}}

{{%tab name="Alpine Linux 3.16/3.17/3.19"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-alpine.md" >}}

3. Download all NGINX Plus packages, including all dependencies:

    ```shell
    sudo mkdir /etc/packages/
    sudo apk update
    sudo apk fetch --recursive --output /etc/packages app-protect-module-plus
    ```

{{%/tab%}}

{{%tab name="Amazon Linux 2023"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-amazon.md" >}}

3. Download all NGINX Plus packages, including all dependencies: We used repotrack for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-plus
    ```

{{%/tab%}}
{{%tab name="Debian 11"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-debian.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect-module-plus | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Debian 12"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-debian.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect-module-plus | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Oracle Linux 8.1+"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-centos-8.md" >}}

3. Download all NGINX Plus packages, including all dependencies: We used repotrack for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-plus
    ```

{{%/tab%}}
{{%tab name="RHEL 8.1+"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-centos-8.md" >}}

3. Download all NGINX Plus packages, including all dependencies: We used repotrack for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-plus
    ```

{{%/tab%}}
{{%tab name="RHEL 9 / Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-centos-9.md" >}}

3. Download all NGINX Plus packages, including all dependencies: We used repotrack for example:

    Install yum-utils
    ```script
    sudo dnf install yum-utils
    ```

    For this test deployment we download the packages inside `/etc/packages/`
    ```script
    sudo mkdir /etc/packages/
    cd /etc/packages/
    sudo repotrack --forcearch x86_64 app-protect-module-plus
    ```

{{%/tab%}}
{{%tab name="Ubuntu 20.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-ubuntu.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect-module-plus | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Ubuntu 22.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-ubuntu.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo bash -c 'for i in $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect-module-plus | grep "^\w" | sort -u); do apt-get download $i; done 2>>/etc/packages/errors.txt'
    ```

{{%/tab%}}
{{%tab name="Ubuntu 24.04"%}}

{{< include "nap-waf/config/v5/host-based-nginx-instructions/nginx-plus-ubuntu.md" >}}

3. Download all NGINX Open Source packages, including all dependencies:

    ```shell
    sudo mkdir -p /etc/packages/
    cd /etc/packages/
    sudo apt-get update
    sudo apt-get install nginx app-protect-module-oss
    ```
{{%/tab%}}
{{</tabs>}}

#### For NGINX Plus

1. Add the NGINX Plus repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

2. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-module-plus
    ```

### NGINX Configuration

In your NGINX configuration:

1. Load the NGINX App Protect WAF v5 module at the main context:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

2. Configure the Enforcer address at the `http` context:

    ```nginx
    app_protect_enforcer_address 127.0.0.1:50000;
    ```

3. Enable NGINX App Protect WAF on an `http/server/location` context (make sure you only enable NGINX App Protect WAF with `proxy_pass`/`grpc_pass` locations):

    ```nginx
    app_protect_enable on;
    ```

In this guide, the following files are used on the offline/air-gap machine:

{{<tabs name="offline_nap5_install_conf_files_localhost">}}
{{%tab name="nginx.conf"%}}

`/etc/nginx/nginx.conf`

{{< include "nap-waf/nginx-conf-localhost.md" >}}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/etc/nginx/conf.d/default.conf`

{{< include "nap-waf/default-conf-localhost.md" >}}

{{%/tab%}}
{{</tabs>}}

### WAF Services Configuration

#### Permissions

Set up the directories with the correct ownership for NGINX App Protect WAF v5 services, where `101:101` are the default UID/GID.

Create Directories:

```shell
sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config
```

Set Ownership:

```shell
sudo chown -R 101:101 /opt/app_protect/
```

#### Set up Docker for F5 Container Registry

{{< include "nap-waf/setup-docker-registry.md" >}}

#### Download waf-enforcer and waf-config-mgr Images
 Pull the `waf-enforcer` and `waf-config-mgr` images. Replace `5.2.0` with the actual release version you are deploying.

```shell
docker pull private-registry.nginx.com/nap/waf-enforcer:5.2.0
docker pull private-registry.nginx.com/nap/waf-config-mgr:5.2.0
```

If IP Intelligence feature is to be used on the deployment, download the `waf-ip-intelligence` as well:

```shell
docker pull private-registry.nginx.com/nap/waf-ip-intelligence:5.2.0
```

#### Saving and Transferring Images

1. Save the `waf-enforcer` and `waf-config-mgr` docker images:

    ```shell
    docker save -o waf-enforcer.tar waf-enforcer:5.2.0
    docker save -o waf-config-mgr.tar waf-config-mgr:5.2.0
    ```

2. If IP Intelligence feature is to be used on the deployment, save the `waf-ip-intelligence` docker image:

    ```shell
    docker save -o waf-ip-intelligence.tar waf-ip-intelligence:5.2.0
    ```

3. Transfer the tar files from the online machine to the offline/air-gapped machine:

4. On the offline machine load the docker images:

    ```shell
    docker load -i waf-enforcer.tar
    docker load -i waf-config-mgr.tar
    ```

5. If IP Intelligence feature is to be used on the deployment, on the offline machine load the docker images:

    ```shell
    docker load -i waf-ip-intelligence.tar
    ```

#### Docker Compose File

Create a `docker-compose.yml` with the following configuration on the offline machine:

Replace `waf-enforcer` and `waf-config-mgr` tag with the actual release version tag you are deploying. We are using version `5.2.0` for this example deployment.

```yaml
services:
  waf-enforcer:
    container_name: waf-enforcer
    image: waf-enforcer:5.2.0
    environment:
      - ENFORCER_PORT=50000
    ports:
      - "50000:50000"
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always

  waf-config-mgr:
    container_name: waf-config-mgr
    image: waf-config-mgr:5.2.0
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /opt/app_protect/config:/opt/app_protect/config
      - /etc/app_protect/conf:/etc/app_protect/conf
    restart: always
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

networks:
  waf_network:
    driver: bridge
```

{{< call-out "note" >}}
In some operating systems, security mechanisms like **SELinux** or **AppArmor** are enabled by default, potentially blocking necessary file access for the `nginx` process and `waf-config-mgr` and `waf-enforcer` containers. To ensure NGINX App Protect WAF v5 operates smoothly without compromising security, consider setting up a custom SELinux policy or AppArmor profile. For short-term troubleshooting, you may use `permissive` (SELinux) or `complain` (AppArmor) mode to avoid these restrictions, but keep in mind that this lowers security and isn't advised for prolonged use.
{{< /call-out >}}

#### Docker Compose File with IP Intelligence

{{< include "nap-waf/ip-intelligence.md" >}}

### Start the Deployment

1. To start the WAF services, navigate to the directory that contains the `docker-compose.yml` file and run:

    ```shell
    sudo docker compose up -d
    ```

2. To start the NGINX, run:

    ```shell
    sudo nginx
    ```

3. To verify the enforcement functionality, ensure the following request is rejected:

    ```shell
    curl "localhost/<script>"
    ```

## Uninstall NGINX and NGINX App Protect WAF module

Stop the docker deployment and uninstall the NGINX packages.

### Stop the Docker Deployment

To stop the WAF services, navigate to the directory that contains the `docker-compose.yml` file and run:

```shell
sudo docker compose stop
```

### Uninstall the NGINX App Protect WAF v5 Package

{{<tabs name="uninstall_nginx_and_nginx_nap">}}

{{%tab name="Alpine Linux 3.16/3.17/3.19"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apk del app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apk del app-protect-module-plus
```

{{%/tab%}}

{{%tab name="Amazon Linux 2"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo yum remove app-protect-module-oss
sudo apt-get remove nginx=1.25.5-1~`lsb_release -cs` app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo yum remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Centos 7.4+"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo yum remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo yum remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Debian 11"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Debian 12"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Oracle Linux 8.1+"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo dnf remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo dnf remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="RHEL 7.4+"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo yum remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo yum remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="RHEL 8.1+"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo dnf remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo dnf remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="RHEL 9 / Rocky Linux 9"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:
```shell
sudo dnf remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo dnf remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Ubuntu 20.04"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Ubuntu 22.04"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-plus
```

{{%/tab%}}
{{%tab name="Ubuntu 24.04"%}}

For NGINX Open Source
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-oss
```

For NGINX Plus
Uninstall the NGINX App Protect WAF v5 package:

```shell
sudo apt-get remove app-protect-module-plus
```

{{%/tab%}}
{{</tabs>}}
