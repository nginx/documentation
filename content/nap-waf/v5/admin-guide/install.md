---
description: This guide describes the steps to install the F5 NGINX App Protect WAF v5
  for host-based NGINX setups.
docs: DOCS-1363
doctypes:
- task
title: Installing NGINX App Protect WAF
toc: true
---

## Prerequisites

- Active F5 NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial).
- Docker (with Docker Compose) is [installed and running](https://docs.docker.com/engine/install/).
- A [supported operating system]({{< relref "/nginx/technical-specs.md#appprotect" >}}) (OS).

## Install NGINX and NGINX App Protect WAF module

1. If you already have NGINX packages in your system, back up your configs and logs:

    ```shell
    sudo cp -a /etc/nginx /etc/nginx-plus-backup
    sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
    ```

2. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your **nginx-repo.crt** and **nginx-repo.key** files.

3. If any old NGINX App Protect packages are installed, make sure to remove them.

4. Follow the steps below for the operating system you are working with.

{{< note >}}
If not already installed, `nginx` or `nginx-plus` will be installed automatically as a dependency.
{{< /note >}}

### Alpine Linux 3.16 / Alpine Linux 3.17

#### Common steps for NGINX Open Source and NGINX Plus

1. Upload **nginx-repo.key** to **/etc/apk/cert.key** and **nginx-repo.crt** to **/etc/apk/cert.pem**. Make sure that files do not contain other certificates and keys: Alpine Linux does not support mixing client certificates for different repositories.

2. Install prerequisite packages:

    ```shell
    sudo apk add openssl ca-certificates
    ```

3. Put NGINX signing public key to directory `/etc/apk/keys`:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
    ```

#### For NGINX Open source

1. Set up the apk repository for mainline nginx packages:

    ```shell
    printf "%s%s%s\n" \
    "http://nginx.org/packages/mainline/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | sudo tee -a /etc/apk/repositories
    ```

2. Add the NGINX App Protect WAF v5 apk repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-x-oss/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

3. Install the NGINX App Protect WAF v5 package:

    ```shell
    sudo apk add app-protect-module-oss
    ```

#### For NGINX Plus

1. Add the NGINX Plus apk repository to `/etc/apk/repositories` file:

    ```shell
    printf "https://pkgs.nginx.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

2. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "https://pkgs.nginx.com/app-protect-x-plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
    ```

3. Install the NGINX App Protect WAF v5 package:

    ```shell
    sudo apk add app-protect-module-plus
    ```

### Amazon Linux 2

#### Common steps for NGINX Open Source and NGINX Plus

1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

3. Install required dependencies:

    ```shell
    sudo yum install ca-certificates wget
    ```

4. Remove any previously downloaded NGINX repository files from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx*.repo
    sudo rm /etc/yum.repos.d/*app-protect*.repo
    ```

#### For NGINX Open source

1. Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

    ```none
    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/amzn2/$releasever/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

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

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum install app-protect-module-oss
    sudo apt-get install nginx=1.25.4-1~`lsb_release -cs` app-protect-module-oss

    ```

    When prompted to accept the GPG key, verify that the fingerprint matches `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.

#### For NGINX Plus

1. Download the NGINX Plus repository file [nginx-plus-amazon2.repo](https://cs.nginx.com/static/files/nginx-plus-amazon2.repo) to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

    ```none
    [app-protect-x-plus]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/7/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum install app-protect-module-plus
    ```

### Debian 11 / Debian 12

#### Common steps for NGINX Open Source and NGINX Plus

1. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

3. Remove any previous NGINX repository and apt configuration files:

    ```shell
    sudo rm /etc/apt/sources.list.d/nginx*.list
    sudo rm /etc/apt/sources.list.d/*app-protect*.list
    sudo rm /etc/apt/apt.conf.d/90pkgs-nginx
    ```

4. Install prerequisite packages:

    ```shell
    sudo apt-get update && sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring
    ```

5. Download and add the NGINX signing key:

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    ```

6. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

7. Verify that the downloaded file contains the proper key:

    ```shell
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    ```

    The output should contain the full fingerprint `573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62` as follows:

    ```none
    pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
          573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
    uid                      nginx signing key <signing-key@nginx.com>
    ```

    If the fingerprint is different, remove the file.

#### For NGINX Open source

1. Add the NGINX Open Source repository:

    ```shell
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    ```

2. Set up repository pinning to prefer our packages over distribution-provided ones:

    ```shell
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
        | sudo tee /etc/apt/preferences.d/99nginx
    ```

3. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-x-oss/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
    ```

4. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get update
    sudo apt-get install nginx=1.25.4-1~`lsb_release -cs` app-protect-module-oss
    ```

#### For NGINX Plus

1. Add the NGINX Plus repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

2. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-x-plus/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-module-plus
    ```

### RHEL 7.4+ / CentOS 7.4+

#### Common steps for NGINX Open Source and NGINX Plus

1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

3. Remove any previously downloaded NGINX repository files from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx*.repo
    sudo rm /etc/yum.repos.d/*app-protect*.repo
    ```

4. Install required dependencies:

    ```shell
    sudo yum install ca-certificates wget
    ```

5. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

#### For NGINX Open source

1. Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

    ```none
    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
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

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum install app-protect-module-oss
    ```

    When prompted to accept the GPG key, verify that the fingerprint matches `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.

#### For NGINX Plus

1. Download the NGINX Plus repository file [nginx-plus-7.4.repo](https://cs.nginx.com/static/files/nginx-plus-7.4.repo) to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

    ```none
    [app-protect-x-plus]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/7/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum install app-protect-module-plus
    ```

### RHEL 8.1+ / Oracle Linux 8.1+

#### Common steps for NGINX Open Source and NGINX Plus

1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

3. Remove any previously downloaded NGINX repository files from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx*.repo
    sudo rm /etc/yum.repos.d/*app-protect*.repo
    ```

4. Install required dependencies:

    ```shell
    sudo dnf install ca-certificates wget
    ```

5. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

#### For NGINX Open source

1. Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

    ```none
    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/centos/8/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-oss.repo` with the following contents:

    ```none
    [app-protect-x-oss]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/8/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf install app-protect-module-oss
    ```

    When prompted to accept the GPG key, verify that the fingerprint matches `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.

#### For NGINX Plus

1. Download the NGINX Plus repository file [nginx-plus-8.repo](https://cs.nginx.com/static/files/nginx-plus-8.repo) to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

    ```none
    [app-protect-x-plus]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/8/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf install app-protect-module-plus
    ```

### RHEL 9

#### Common steps for NGINX Open Source and NGINX Plus

1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

3. Remove any previously downloaded NGINX repository files from `/etc/yum.repos.d`:

    ```shell
    sudo rm /etc/yum.repos.d/nginx*.repo
    sudo rm /etc/yum.repos.d/*app-protect*.repo
    ```

4. Install required dependencies:

    ```shell
    sudo dnf install ca-certificates wget
    ```

5. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

#### For NGINX Open source

1. Create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

    ```none
    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/centos/9/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-oss.repo` with the following contents:

    ```none
    [app-protect-x-oss]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-oss/centos/9/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf install app-protect-module-oss
    ```

    When prompted to accept the GPG key, verify that the fingerprint matches `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, and if so, accept it.

#### For NGINX Plus

1. Download the NGINX Plus repository file [plus-9.repo](https://cs.nginx.com/static/files/plus-9.repo) to `/etc/yum.repos.d`:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-9.repo
    ```

2. Create NGINX App Protect WAF v5 repository file, named `/etc/yum.repos.d/app-protect-x-plus.repo` with the following contents:

    ```none
    [app-protect-x-plus]
    name=nginx-app-protect repo
    baseurl=https://pkgs.nginx.com/app-protect-x-plus/centos/9/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

3. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf install app-protect-module-plus
    ```

### Ubuntu 20.04 / Ubuntu 22.04

#### Common steps for NGINX Open Source and NGINX Plus

1. Create the `/etc/ssl/nginx/` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

2. Upload **nginx-repo.crt** and **nginx-repo.key** files to the `/etc/ssl/nginx/` directory.

3. Remove any previous NGINX repository and apt configuration files:

    ```shell
    sudo rm /etc/apt/sources.list.d/nginx*.list
    sudo rm /etc/apt/sources.list.d/*app-protect*.list
    sudo rm /etc/apt/apt.conf.d/90pkgs-nginx
    ```

4. Install prerequisite packages:

    ```shell
    sudo apt-get update && sudo apt-get install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
    ```

5. Download and add the NGINX signing key:

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    ```

6. Download the apt configuration to `/etc/apt/apt.conf.d`:

    ```shell
    sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
    ```

7. Verify that the downloaded file contains the proper key:

    ```shell
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    ```

    The output should contain the full fingerprint `573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62` as follows:

    ```none
    pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
          573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
    uid                      nginx signing key <signing-key@nginx.com>
    ```

    If the fingerprint is different, remove the file.

#### For NGINX Open source

1. Add the NGINX Open Source repository:

    ```shell
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    ```

2. Set up repository pinning to prefer our packages over distribution-provided ones:

    ```shell
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
        | sudo tee /etc/apt/preferences.d/99nginx
    ```

3. Add the NGINX App Protect WAF v5 repository:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect-x-oss/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
    ```

4. Install the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get update
    sudo apt-get install app-protect-module-oss
    ```

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

Replace `1.0.0` with the actual release version you are deploying.

```yaml
version: "3.9"

services:
  waf-enforcer:
    container_name: waf-enforcer
    image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
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
    image: private-registry.nginx.com/nap/waf-config-mgr:1.0.0
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

{{< note >}}
In some operating systems, security mechanisms like **SELinux** or **AppArmor** are enabled by default, potentially blocking necessary file access for the `nginx` process and `waf-config-mgr` and `waf-enforcer` containers. To ensure NGINX App Protect WAF v5 operates smoothly without compromising security, consider setting up a custom SELinux policy or AppArmor profile. For short-term troubleshooting, you may use `permissive` (SELinux) or `complain` (AppArmor) mode to avoid these restrictions, but keep in mind that this lowers security and isn't advised for prolonged use.
{{< /note >}}

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

## Using Policy and Logging Profile Bundles

{{< include "nap-waf/bundles-volume-mount.md" >}}

After deploying NGINX App Protect WAF, learn how to utilize the [NGINX App Protect WAF Compiler]({{< relref "/nap-waf/v5/admin-guide/compiler.md" >}}) for applying your custom policies and logging profiles.

## Uninstall NGINX and NGINX App Protect WAF module

Stop the docker deployment and uninstall the NGINX packages.

### Stop the Docker Deployment

To stop the WAF services, navigate to the directory that contains the `docker-compose.yml` file and run:

    ```shell
    sudo docker compose stop -d
    ```

### Alpine Linux 3.16 / Alpine Linux 3.17

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package:

    ```shell
    sudo apk del app-protect-module-oss
    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package:

    ```shell
    sudo apk del app-protect-module-plus
    ```

### Amazon Linux 2

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum remove app-protect-module-oss
    sudo apt-get remove nginx=1.25.4-1~`lsb_release -cs` app-protect-module-oss

    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum remove app-protect-module-plus
    ```


### Debian 11 / Debian 12

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get remove app-protect-module-oss
    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get remove app-protect-module-plus
    ```

### RHEL 7.4+ / CentOS 7.4+

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum remove app-protect-module-oss
    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo yum remove app-protect-module-plus
    ```

### RHEL 8.1+ / Oracle Linux 8.1+

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf remove app-protect-module-oss
    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf remove app-protect-module-plus
    ```

### RHEL 9

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf remove app-protect-module-oss
    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo dnf remove app-protect-module-plus
    ```

### Ubuntu 20.04 / Ubuntu 22.04

#### For NGINX Open source

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get remove app-protect-module-oss
    ```

#### For NGINX Plus

Uninstall the NGINX App Protect WAF v5 package.

    ```shell
    sudo apt-get remove app-protect-module-plus
    ```
