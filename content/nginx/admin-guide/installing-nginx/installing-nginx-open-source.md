---
description: Install NGINX Open Source either as a prebuilt package or from source,
  following step-by-step instructions for all supported Linux distributions.
docs: DOCS-410
title: Installing NGINX Open Source
toc: true
weight: 200
type:
- how-to
---

This article explains how to install NGINX Open Source on various operating systems, including an overview of existing NGINX Open Source versions, installation types and methods, modules included in the default package and dynamic modules packages, and the basics of compiling NGINX from the source code.

## Stable and mainline versions {#stable_vs_mainline}

NGINX Open Source is available in two versions: Mainline and Stable. The source code and release notes for both versions are available from [NGINX download page](https://nginx.org/en/download.html).

### Mainline version

Mainline version (also Mainline release, Mainline branch) is the latest development version, updated approximately every 1 or 2 months, includes the latest features, bug fixes and security fixes. This version is recommended for production unless your organization has strict requirements for stability, in which case the stable version might be the better choice. The Mainline version always has an odd middle number, for example, 1.*27*.X.

### Stable version

Stable version (also Stable release, Stable branch) is updated typically once a year or as needed for critical bug fixes or security fixes that are always backported from the Mainline version. This version is recommended for environments with strict requirements for stability. The Stable version is always even-numbered, for example, 1.*28*.X.

##  Distribution and installation methods {#compile_vs_package}

Both the NGINX Open Source Mainline and Stable versions can be obtained and installed in several ways:

- A package from the [official NGINX Open Source repository](#official-repository) (recommended for production). This is the most reliable method: you have to set up the repository once, but after that the provided package is always up to date.

- A package from your [operating system’s default package repository](#os-default-repository) (suitable for learning or testing). This is the easiest method, but generally the provided package is outdated.

- Your own package [compiled from source](#sources) (recommended for advanced and custom builds). This method is the most flexible: you can include non-standard or third‑party modules, apply the latest security patches, or build the binary for almost any Unix-like operating system using different compilers and custom compiler options.

- A container: suitable for development, testing, production deployments in container environments such as Docker, Podman, Kubernetes: see [Deploying NGINX with Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md#using-nginx-open-source-docker-images" >}})

## OS default repository

Installing from your operating system’s default repository is the simplest and fastest method. It is suitable for demos, learning, or testing environments. However, for production use, there are some considerations:
- The package is maintained by the distribution’s repository maintainers, so F5/NGINX cannot verify its contents, build process, or update frequency.
- The package may be outdated. To compare release versions and features, see the [Changelog](https://nginx.org/en/CHANGES).
- Some Linux distros, especially those focused on long-term support, provide the Stable version only.

For the latest official release and better control over updates, it is recommended to configure your package manager to install [from the official NGINX repository](#official-repository).

The installation steps include updating the package repository and installing the `nginx` binary.

- For MacOS:

  ```shell
  # ensure Homebrew is installed, see https://brew.sh/
  brew update && \
  brew install nginx
  ```

- For RHEL-based distributions and Amazon Linux 2023:

  ```shell
  sudo dnf update -y && \
  sudo dnf install nginx
  ```

  If the output of the command is `no nginx package found`, install the [EPEL repository](https://docs.fedoraproject.org/en-US/epel/) that contains the nginx package and run the command again. The EPEL installation steps include installing the repository, clearing the packages cache and updating the repository info:

  ```shell
  sudo dnf update -y && \
  sudo dnf install epel-release -y && \
  sudo dnf clean all && \
  sudo dnf update -y
  ```

- For Debian-based distributions:

  ```shell
  sudo apt update -y && \
  sudo apt install nginx
  ```

- For FreeBSD or DragonFly BSD:

  ```shell
  sudo pkg update -y && \
  sudo pkg install nginx
  ```

- For SUSE Linux Enterprise or openSUSE:

  ```shell
  # ensure Web-Scripting-Module repo is enabled
  sudo zypper refresh -y && \
  sudo zypper install nginx
  ```

- For Alpine:

  ```shell
  # ensure community repo is enabled in /etc/apk/repositories
  sudo apk update && \
  sudo apk add nginx
  ```
- For Amazon Linux 2:

  ```shell
  sudo yum install -y amazon-linux-extras
  amazon-linux-extras list | grep nginx # get package name, e.g. nginx1
  sudo amazon-linux-extras install nginx1
  ```
  
Check the version installed:

```shell
sudo nginx -v
```
It is recommended to review the [Changelog](https://nginx.org/en/CHANGES) and compare the features, bugfixes, and security fixes between the installed version and the latest release. The latest NGINX Open Source version is always available from [the official repository](#official-repository).

You can find out the path to NGINX configuration file, error log, and access log files using the command:

```shell
nginx -V 2>&1 | awk -F: '/configure arguments/ {print $2}' | xargs -n1
```
where:
- `--conf-path=` is the path to the `nginx.conf` configuration file
- `--error-log-path=` is the path to the error log
- `--http-log-path=` is the path to the access log


##  Official repository

You can configure your package manager to install NGINX Open Source from the official **nginx.org** repository, which provides both the latest [Mainline and Stable](#stable_vs_mainline) versions for most major production operating systems. See the [Changelog](https://nginx.org/en/CHANGES) for version details.

You need to set up the repository once, but after that the provided package will stay up to date with the latest releases. Before installing, ensure your operating system and architecture are [supported](https://nginx.org/en/linux_packages.html#distributions).

This installation method is recommended for production environments.

### Repository contents

The repository contains the latest versions of the following packages:

{{<bootstrap-table "table table-striped table-bordered">}}
| Package name               | Description                                  |
| ---------------------------| ---------------------------------------------|
| `nginx`                    | Main NGINX Open Source package, contains [core modules](#prebuilt_modules) and [statically linked modules](#statically-linked-modules). |
| `nginx-module-geoip`       | The [`ngx_http_geoip_module`](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) as a [dynamic module](#dynamic-modules). |
| `nginx-module-image-filter`| The [`ngx_http_image-filter_module`](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) as a [dynamic module](#dynamic-modules). |
| `nginx-module-njs`         | The [`ngx_http_js_module`](https://nginx.org/en/docs/http/ngx_http_js_module.html) and [`ngx_stream_js_module`](https://nginx.org/en/docs/stream/ngx_stream_js_module.html) as [dynamic modules](#dynamic-modules). |
| `nginx-module-perl`        | The [`ngx_http_perl_module`](https://nginx.org/en/docs/http/ngx_http_perl_module.html) as a [dynamic module](#dynamic-modules). |
| `nginx-module-xslt`        | The [`ngx_http_xsl_module`](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) as a [dynamic module](#dynamic-modules). |
| `nginx-module-otel`        | The [`ngx_otel_module`](https://nginx.org/en/docs/ngx_otel_module.html) as a [dynamic module](#dynamic-modules). |
{{</bootstrap-table>}}


### RHEL-based packages {#prebuilt_redhat}

RHEL-based operating systems include RHEL, CentOS, Oracle Linux, AlmaLinux, Rocky Linux.

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Set up the `yum` or `dnf` repository.

   - In the `/etc/yum.repos.d` directory, create the `nginx.repo` file using any text editor, for example, `vi`:

     ```shell
     sudo vi /etc/yum.repos.d/nginx.repo
     ```

   - Add the following lines to the file, where `nginx-stable` and `nginx-mainline` point to the latest Stable or Mainline version of NGINX Open Source:

     ```text
     [nginx-stable]
     name=nginx stable repo
     baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
     gpgcheck=1
     enabled=1
     gpgkey=https://nginx.org/keys/nginx_signing.key
     module_hotfixes=true

     [nginx-mainline]
     name=nginx mainline repo
     baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
     gpgcheck=1
     enabled=0
     gpgkey=https://nginx.org/keys/nginx_signing.key
     module_hotfixes=true
     ```

     - Save the file.

4. If needed, switch to `nginx-mainline` packages instead of `nginx-stable` that are enabled by default (the `enable=1` parameter):

   ```shell
   sudo dnf config-manager --enable nginx-mainline
   ```

5. Update the repository:

   ```shell
   sudo dnf update
   ```

6. Install the `nginx` package:

   ```shell
   sudo dnf install nginx
   ```

   When prompted to accept the GPG key, verify that the following three fingerprints match, and if so, accept them:

   ```shell
   Importing GPG key 0xB49F6B46:
    UserID     : "nginx signing key <signing-key-2@nginx.com"
    Fingerprint: 8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46
    From       : https://nginx.org/keys/nginx_signing.key
   ```

   ```shell
   Importing GPG key 0x7BD9BF62:
    UserID     : "nginx signing key <signing-key@nginx.com"
    Fingerprint: 573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62
    From       : https://nginx.org/keys/nginx_signing.key
    ```

   ```shell
   Importing GPG key 0x8D88A2B3:
    UserID     : "nginx signing key <signing-key-3@nginx.com"
    Fingerprint: 9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3
    From       : https://nginx.org/keys/nginx_signing.key
   ```

7. Start NGINX Open Source:

    ```shell
    sudo nginx
    ```

8. Verify that NGINX Open Source is up and running using the `curl` command:

    ```shell
    curl -I 127.0.0.1
    ```
   Expected output:
    ```shell
    HTTP/1.1 200 OK
    Server: nginx/1.27.5
    ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`

9. If needed, install one or more [dynamic module packages](#repository-contents):

   ```shell
   sudo dnf install nginx-module-<name>
   ```
   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib/nginx/modules` directory.


### Debian packages {#prebuilt_debian}

This section covers Debian packages only. For Ubuntu-specific instructions, see [Ubuntu packages](#prebuilt_ubuntu).

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Install the prerequisites:

   ```shell
   sudo apt update && \
   sudo apt install curl \
                    gnupg2 \
                    ca-certificates \
                    lsb-release \
                    debian-archive-keyring
   ```

2. Import an official nginx signing key to allow `apt` to verify the authenticity of packages. Fetch the key:

   ```shell
   curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
   ```

3. Verify that the downloaded file contains the correct signing key:

   ```shell
   gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
   ```
   The output should list the following three full fingerprints:

   ```none
   pub   rsa4096 2024-05-29 [SC]
         8540A6F18833A80E9C1653A42FD21310B49F6B46
   uid                      nginx signing key <signing-key-2@nginx.com>

   pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
         573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
   uid                      nginx signing key <signing-key@nginx.com>

   pub   rsa4096 2024-05-29 [SC]
         9E9BE90EACBCDE69FE9B204CBCDCD8A38D88A2B3
   uid                      nginx signing key <signing-key-3@nginx.com>
   ```

   If the fingerprints do not match, delete the file immediately.


4. Set up the `apt` repository to fetch packages from either `stable` or `mainline` branch.

   - For `stable`:

     ```shell
     echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
     http://nginx.org/packages/debian `lsb_release -cs` nginx" \
         | sudo tee /etc/apt/sources.list.d/nginx.list
     ```

   - For `mainline`:

     ```shell
     echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
     http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
         | sudo tee /etc/apt/sources.list.d/nginx.list
     ```

5. Set up repository pinning to prioritize official nginx packages over those provided by the distribution:

   ```shell
   echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
      | sudo tee /etc/apt/preferences.d/99nginx
   ```

6. Install the `nginx` package:

   ```shell
   sudo apt update && \
   sudo apt install nginx
   ```

7. Start NGINX Open Source:

   ```shell
   sudo nginx
   ```

8. Verify that NGINX Open Source is up and running using the `curl` command:

   ```shell
   curl -I 127.0.0.1
   ```
   Expected output:

   ```shell
   HTTP/1.1 200 OK
   Server: nginx/1.27.5
   ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`

9. If needed, install one or more [dynamic module packages](#repository-contents):

   ```shell
   sudo apt install nginx-module-<name>
   ```
   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib/nginx/modules` directory.


### Ubuntu packages {#prebuilt_ubuntu}

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Install the prerequisites:

   ```shell
   sudo apt update && \
   sudo apt install curl \
                    gnupg2 \
                    ca-certificates \
                    lsb-release \
                    ubuntu-keyring
    ```

2. Import an official nginx signing key to allow `apt` to verify the authenticity of packages. Fetch the key:

   ```shell
   curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
       | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
   ```

3. Verify that the downloaded file contains the correct signing key:

   ```shell
   gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
   ```

   The output should list the following three full fingerprints:

   ```none
   pub   rsa4096 2024-05-29 [SC]
         8540A6F18833A80E9C1653A42FD21310B49F6B46
   uid                      nginx signing key <signing-key-2@nginx.com>

   pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
         573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
   uid                      nginx signing key <signing-key@nginx.com>

   pub   rsa4096 2024-05-29 [SC]
         9E9BE90EACBCDE69FE9B204CBCDCD8A38D88A2B3
   uid                      nginx signing key <signing-key-3@nginx.com>
   ```
   If the fingerprints do not match, delete the file immediately.

4. Set up the `apt` repository to fetch packages from either `stable` or `mainline` branch.

   - For `stable`:
     ```shell
     echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
     http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
         | sudo tee /etc/apt/sources.list.d/nginx.list
     ```

   - For `mainline`:

     ```shell
     echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
     http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
         | sudo tee /etc/apt/sources.list.d/nginx.list
     ```

5. Set up repository pinning to prioritize official nginx packages over those provided by the distribution:

   ```shell
   echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
       | sudo tee /etc/apt/preferences.d/99nginx
    ```

6. Install the `nginx` package: 

   ```shell
   sudo apt update && \
   sudo apt install nginx
   ```

7. Start NGINX Open Source:

   ```shell
   sudo nginx
   ```

8. Verify that NGINX Open Source is up and running using the `curl` command:

   ```shell
   curl -I 127.0.0.1
   ```
   Expected output:

   ```shell
   HTTP/1.1 200 OK
   Server: nginx/1.27.5
   ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`

9. If needed, install one or more [dynamic module packages](#repository-contents):

   ```shell
   sudo apt install nginx-module-<name>
   ```
   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib/nginx/modules` directory.


### SUSE Linux Enterprise packages {#prebuilt_suse}

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Install the prerequisites:

   ```shell
   sudo zypper refresh && \
   sudo zypper install curl  \
                       ca-certificates  \
                       gpg2
    ```

2. Set up the `zypper` repository to fetch packages from either `stable` or `mainline` branch.

   - For `stable`:

   ```shell
   sudo zypper addrepo --gpgcheck --type yum --refresh --check \
      'http://nginx.org/packages/sles/$releasever_major' nginx-stable
   ```

   - For `mainline`:

   ```shell
   sudo zypper addrepo --gpgcheck --type yum --refresh --check \
        'http://nginx.org/packages/mainline/sles/$releasever_major' nginx-mainline
   ```

3. Import the official nginx signing key so `zypper` and `rpm` could verify the packages authenticity. Fetch the key:

   ```shell
   curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
   ```

4. Verify that the downloaded file contains the proper key:

   ```shell
   gpg --show-keys /tmp/nginx_signing.key
   ```

   The output should list the following three full fingerprints:

   ```none
   pub   rsa4096 2024-05-29 [SC]
         8540A6F18833A80E9C1653A42FD21310B49F6B46
   uid                      nginx signing key <signing-key-2@nginx.com>

   pub   rsa2048 2011-08-19 [SC] [expires: 2027-05-24]
         573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
   uid                      nginx signing key <signing-key@nginx.com>

   pub   rsa4096 2024-05-29 [SC]
         9E9BE90EACBCDE69FE9B204CBCDCD8A38D88A2B3
   uid                      nginx signing key <signing-key-3@nginx.com>
    ```
   If the fingerprints do not match, delete the file immediately.

5. Import the key to the `rpm` database:

   ```shell
   sudo rpmkeys --import /tmp/nginx_signing.key
   ```

6. Install the `nginx` package:

   ```shell
   sudo zypper install nginx
   ```

7. Verify that NGINX Open Source is up and running using the `curl` command:

    ```shell
    curl -I 127.0.0.1
    ```
   Expected output:
    ```shell
    HTTP/1.1 200 OK
    Server: nginx/1.27.5
    ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`

8. If needed, install one or more [dynamic module packages](#repository-contents):

   ```shell
   sudo zypper install nginx-module-<name>
   ```

   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib64/nginx/modules` directory.

### Alpine Linux packages {#prebuilt_alpine}

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Install the prerequisites:

    ```shell
    sudo apk add openssl \
                 curl \
                 ca-certificates
    ```

2. Set up the `apk` repository to fetch packages from either `stable` or `mainline` branch by adding the repository URL to the  `/etc/apk/repositories` file and the `@nginx` tag.

   - For `stable`:

    ```shell
    printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | sudo tee -a /etc/apk/repositories

    ```

   - For `mainline`:

    ```shell
    printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/mainline/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | sudo tee -a /etc/apk/repositories
    ```

3. Import the official nginx signing key so that `apk` can verify the authenticity of packages. Fetch the key:

    ```shell
    curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
    ```

4. Verify that the downloaded file contains the proper public key:

    ```shell
    openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout
    ```

    The output should contain the following modulus:

    ```none
    Public-Key: (2048 bit)
    Modulus:
        00:fe:14:f6:0a:1a:b8:86:19:fe:cd:ab:02:9f:58:
        2f:37:70:15:74:d6:06:9b:81:55:90:99:96:cc:70:
        5c:de:5b:e8:4c:b2:0c:47:5b:a8:a2:98:3d:11:b1:
        f6:7d:a0:46:df:24:23:c6:d0:24:52:67:ba:69:ab:
        9a:4a:6a:66:2c:db:e1:09:f1:0d:b2:b0:e1:47:1f:
        0a:46:ac:0d:82:f3:3c:8d:02:ce:08:43:19:d9:64:
        86:c4:4e:07:12:c0:5b:43:ba:7d:17:8a:a3:f0:3d:
        98:32:b9:75:66:f4:f0:1b:2d:94:5b:7c:1c:e6:f3:
        04:7f:dd:25:b2:82:a6:41:04:b7:50:93:94:c4:7c:
        34:7e:12:7c:bf:33:54:55:47:8c:42:94:40:8e:34:
        5f:54:04:1d:9e:8c:57:48:d4:b0:f8:e4:03:db:3f:
        68:6c:37:fa:62:14:1c:94:d6:de:f2:2b:68:29:17:
        24:6d:f7:b5:b3:18:79:fd:31:5e:7f:4c:be:c0:99:
        13:cc:e2:97:2b:dc:96:9c:9a:d0:a7:c5:77:82:67:
        c9:cb:a9:e7:68:4a:e1:c5:ba:1c:32:0e:79:40:6e:
        ef:08:d7:a3:b9:5d:1a:df:ce:1a:c7:44:91:4c:d4:
        99:c8:88:69:b3:66:2e:b3:06:f1:f4:22:d7:f2:5f:
        ab:6d
    Exponent: 65537 (0x10001)
    ```

5. Move the key to `apk` trusted keys storage:

    ```shell
    sudo mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/
    ```

6. Install the `nginx` package:

    ```shell
    sudo apk add nginx@nginx
    ```

7. Start NGINX Open Source:

    ```shell
    sudo nginx
    ```

8. Verify that NGINX Open Source is up and running using the `curl` command:

    ```shell
    curl -I 127.0.0.1
    ```
    Expected output:

    ```shell
    HTTP/1.1 200 OK
    Server: nginx/1.27.5
    ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`

9. If needed, install one or more [dynamic module packages](#repository-contents). The `@nginx` tag should also be specified:

    ```shell
    sudo apk add nginx-module-<name1>@nginx nginx-module-<name2>@nginx
    ```

   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib/nginx/modules` directory.

### Amazon Linux 2 packages {#prebuilt_amazon}

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Install the prerequisites:

    ```shell
    sudo yum install yum-utils
    ```

2. Set up the `yum` repository.

   - In the `/etc/yum.repos.d` directory, create the `nginx.repo` file using any text editor, for example, `vi`:

     ```shell
     sudo vi /etc/yum.repos.d/nginx.repo
     ```

   - Add the following lines to file, where the `nginx-stable` and `nginx-mainline` elements point to the latest stable or mainline version of NGINX Open Source:

    ```none
    [nginx-stable]
    name=nginx stable repo
    baseurl=http://nginx.org/packages/amzn2/$releasever/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/amzn2/$releasever/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true
    ```
    - Save the file.

3. If needed, switch to `nginx-mainline` packages instead of `nginx-stable` that are enabled by default (the `enable=1` parameter):

    ```shell
    sudo yum-config-manager --enable nginx-mainline
    ```

4. Update the repository:

   ```shell
   sudo yum update
   ```

5. Install nginx:

    ```shell
    sudo yum install nginx
    ```

    When prompted to accept the GPG key, verify that the following three fingerprints match:
    `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`,
    `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`,
    `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3`,
    and if so, accept them.

6. Start NGINX Open Source:

    ```shell
    sudo nginx
    ```

7. Verify that NGINX Open Source is up and running using the `curl` command:

    ```shell
    curl -I 127.0.0.1
    ```
   Expected output:
    ```shell
    HTTP/1.1 200 OK
    Server: nginx/1.27.5
    ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`

8. If needed, install one or more [dynamic module packages](#repository-contents):

   ```shell
   sudo yum install nginx-module-<name>
   ```
   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib64/nginx/modules` directory.


### Amazon Linux 2023 packages

Before installing, check if your operating system and architecture are supported, see [Supported distributions and versions](https://nginx.org/en/linux_packages.html#distributions).

1. Install the prerequisites:

    ```shell
    sudo yum install yum-utils
    ```

2. To set up the `yum` repository for Amazon Linux 2023, create the file named `/etc/yum.repos.d/nginx.repo` with the following contents:

    ```none
    [nginx-stable]
    name=nginx stable repo
    baseurl=http://nginx.org/packages/amzn/2023/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true

    [nginx-mainline]
    name=nginx mainline repo
    baseurl=http://nginx.org/packages/mainline/amzn/2023/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true
    ```
    By default, the repository for `stable` nginx packages is used. If you would like to use `mainline` nginx packages, run the following command:

    ```shell
    sudo yum-config-manager --enable nginx-mainline
    ```

3. Install nginx:

    ```shell
    sudo yum install nginx
    ```

    When prompted to accept the GPG key, verify that the following three fingerprints match:
    `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`,
    `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`,
    `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3`
    and if so, accept them.

4. Start NGINX Open Source:

    ```shell
    sudo nginx
    ```

5. Verify that NGINX Open Source is up and running using the `curl` command:

    ```shell
    curl -I 127.0.0.1
    ```
   Expected output:
    ```shell
    HTTP/1.1 200 OK
    Server: nginx/1.27.5
    ```

   After installation, the following files are available for configuration and troubleshooting:

   - Configuration file: `nginx.conf`, located in `/etc/nginx/`
   - Log files: `access.log` and `error.log`, located in `/var/log/nginx/`


6. If needed, install one or more [dynamic module packages](#repository-contents):

   ```shell
   sudo dnf install nginx-module-<name>
   ```
   Then, enable each module in the `nginx.conf` configuration file using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. The resulting `.so` files are located in the `/usr/lib64/nginx/modules` directory.

## Package contents {#prebuilt}

NGINX has a modular architecture that allows functionality to be included selectively. Some modules are built into the core and are always included in the package. Others are not part of the core, but are compiled at build time using the `--with-` configuration flag. Additionally, some modules, usually those with external dependencies, are distributed as separate packages that can be loaded at runtime as [dynamic modules](#dynamic-modules).

Packaging sources and scripts can be found in the [packaging sources repository](https://github.com/nginx/pkg-oss).

### Core modules {#prebuilt_modules}

NGINX core modules are built-in components that provide essential functionality such as configuration parsing, event handling, process management, and HTTP request processing. They are statically compiled into the NGINX binary and cannot be disabled or excluded.

{{<bootstrap-table "table table-striped table-bordered">}}
|Module Name               | Description                                  |
| -------------------------| ---------------------------------------------|
| [`ngx_core_module`](https://nginx.org/en/docs/ngx_core_module.html)      | Internal core functionality. |
| [`ngx_http_core_module`](https://nginx.org/en/docs/http/ngx_http_core_module.html) | Essential HTTP functionality ([`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)). |
| [`ngx_http_access_module`](https://nginx.org/en/docs/http/ngx_http_access_module.html)|  Access control ([`allow`](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow), [`deny`](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny)). |
| [`ngx_http_auth_basic_module`](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html) | HTTP Basic Auth. |
| [`ngx_http_autoindex_module`](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html) |Directory listing. |
| [`ngx_http_browser_module`](https://nginx.org/en/docs/http/ngx_http_browser_module.html)      | Browser-based conditional logic.|
| [`ngx_http_charset_module`](https://nginx.org/en/docs/http/ngx_http_charset_module.html)      | Character set conversion.|
| [`ngx_http_empty_gif_module`](https://nginx.org/en/docs/http/ngx_http_empty_gif_module.html) | Serves a 1x1 transparent GIF.|
| [`ngx_http_fastcgi_module`](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)      | FastCGI backend support. |
| [`ngx_http_geo_module`](https://nginx.org/en/docs/http/ngx_http_geo_module.html)      | IP-based variable creation. |
| [`ngx_http_gzip_module`](https://nginx.org/en/docs/http/ngx_http_gzip_module.html)      | Gzip compression. |
| [`ngx_http_headers_module`](https://nginx.org/en/docs/http/ngx_http_headers_module.html) | Add/modify response headers.|
| [`ngx_http_index_module`](https://nginx.org/en/docs/http/ngx_http_index_module.html) | Default index file (e.g. index.html). |
| [`ngx_http_limit_conn_module`](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html) | Limits concurrent connections. |
| [`ngx_http_limit_req_module`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html)  | Limits request rate. |
| [`ngx_http_log_module`](https://nginx.org/en/docs/http/ngx_http_log_module.html) | Logging support. |
| [`ngx_http_map_module`](https://nginx.org/en/docs/http/ngx_http_map_module.html) | Variable mapping logic. |
| [`ngx_http_memcached_module`](https://nginx.org/en/docs/http/ngx_http_memcached_module.html) | Memcached backend. |
| [`ngx_http_mirror_module`](https://nginx.org/en/docs/http/ngx_http_mirror_module.html) | Mirrors requests to another location. |
| [`ngx_http_proxy_module`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) | HTTP reverse proxy. |
| [`ngx_http_referer_module`](https://nginx.org/en/docs/http/ngx_http_referer_module.html) | Referer-based access control.|
| [`ngx_http_rewrite_module`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) | URL rewriting. |
| [`ngx_http_scgi_module`](https://nginx.org/en/docs/http/ngx_http_scgi_module.html) | SCGI backend. |
| [`ngx_http_split_clients_module`](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html) | A/B testing logic. |
| [`ngx_http_ssi_module`](https://nginx.org/en/docs/http/ngx_http_ssi_module.html) | Server Side Includes. |
| [`ngx_http_upstream_module`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html) | Upstream group and load balancing logic. |
| [`ngx_http_userid_module`](https://nginx.org/en/docs/http/ngx_http_userid_module.html) | Cookie-based user ID generation. |
| [`ngx_http_uwsgi_module`](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) | uWSGI backend. |
{{</bootstrap-table>}}

### Statically linked modules

In addition to core modules, the `nginx` package includes other nginx modules that do not require additional libraries to avoid extra dependencies. These modules are compiled at build time and specified using the` --with-` configure option. Unlike [dynamic modules](#dynamic-modules), they cannot be enabled or disabled dynamically after compilation. You can get the list of these modules in the output of the `nginx -V` command output in `configure arguments`.

{{<bootstrap-table "table table-striped table-bordered">}}
|Module Name               | Description                                  |
| -------------------------| ---------------------------------------------|
| `--with-compat`        |Enables dynamic modules compatibility.  |
| `--with-file-aio` |Enables the use of [asynchronous file I/O](https:/ /nginx.org/en/docs/http/ngx_http_core_module.html#aio) (AIO) on FreeBSD and Linux. |
| `--with-threads` | Enables NGINX to use thread pools. For details, see [Thread Pools in NGINX Boost Performance 9x!](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) on the NGINX blog. |
|[`--with-http_addition_module`](https://nginx.org/en/docs/http/ngx_http_addition_module.html)| Adds text before and after a response. |
|[`--with-http_auth_request_module`](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html)|Implements client authorization based on the result of a subrequest. |
|[`--with-http_dav_module`](https://nginx.org/en/docs/http/ngx_http_dav_module.html)|Enables file management automation using the WebDAV protocol. |
|[`--with-http_flv_module`](https://nginx.org/en/docs/http/ngx_http_flv_module.html)|Provides pseudo-streaming server-side support for Flash Video (FLV) files. |
|[`--with-http_gunzip_module`](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html)|Decompresses responses with `Content-Encoding: gzip` for clients that do not support the _zip_ encoding method. |
|[`--with-http_gzip_static_module`](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)| Allows sending precompressed files with the **.gz** filename extension instead of regular files. |
|[`--with-http_mp4_module`](https://nginx.org/en/docs/http/ngx_http_mp4_module.html)| Provides pseudo-streaming server-side support for MP4 files.                                              |
|[`--with-http_random_index_module`](https://nginx.org/en/docs/http/ngx_http_random_index_module.html) | Processes requests ending with the slash character (‘/’) and picks a random file in a directory to serve as an index file. |
|[`--with-http_realip_module`](https://nginx.org/en/docs/http/ngx_http_realip_module.html) | Changes the client address to the one sent in the specified header field. |
|[`--with-http_secure_link_module`](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html) | Used to check authenticity of requested links, protect resources from unauthorized access, and limit link lifetime. |
|[`--with-http_slice_module`](https://nginx.org/en/docs/http/ngx_http_slice_module.html) | Allows splitting a request into subrequests, each subrequest returns a certain range of response. Provides more effective caching of large files. |
|[`--with-http_ssl_module`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) | Enables HTTPS support. Requires an SSL library such as [OpenSSL](https://www.openssl.org/). |
|[`--with-http_stub_status_module`](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html)| Provides access to basic status information. Note that NGINX Plus customers do not require this module as they are already provided with extended status metrics and interactive dashboard. |
|[`--with-http_sub_module`](https://nginx.org/en/docs/http/ngx_http_sub_module.html) |  Modifies a response by replacing one specified string by another.  |
|[`--with-http_v2_module`](https://nginx.org/en/docs/http/ngx_http_v2_module.html)| Enable support for [HTTP/2](https://datatracker.ietf.org/doc/html/rfc7540). See [The HTTP/2 Module in NGINX](https://www.nginx.com/blog/http2-module-nginx/) on the NGINX blog for details.|
|[`--with-http_v3_module`](https://nginx.org/en/docs/http/ngx_http_v3_module.html)| Provides experimental support for [HTTP/3](https://datatracker.ietf.org/doc/html/rfc9114). |
|[`--with-mail`](https://nginx.org/en/docs/mail/ngx_mail_core_module.html)| Enables mail proxy functionality. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-mail=dynamic`. |
|[`--with-mail_ssl_module`](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html)| Provides support for a mail proxy server to work with the SSL/TLS protocol. Requires an SSL library such as [OpenSSL](https://www.openssl.org/). |
|[`--with-stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) | Enables the TCP and UDP proxy functionality. To compile as a separate [dynamic module]({{< ref "nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-stream=dynamic`. |
|[`--with-stream_realip_module`](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) | Changes the client address and port to the ones sent in the PROXY protocol header. |
|[`--with-stream_ssl_module`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html)| Provides support for a stream proxy server to work with the SSL/TLS protocol. Requires an SSL library such as [OpenSSL](https://www.openssl.org/). |
{{</bootstrap-table>}}


## Dynamic modules

Some modules, especially those with external dependencies, are not included in the `nginx` package. However, they are available as separate packages from the official NGINX repository. After installation they can be connected as a dynamic modules, or shared object (.so) files via the `load_module` directive in the NGINX configuration.

{{<bootstrap-table "table table-striped table-bordered">}}
|Module Name               | Description                                  | Package name  |
| -------------------------| ---------------------------------------------|---------------|
| [`ngx_http_geoip_module`](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) | Creates variables with values depending on the client IP address, using the precompiled MaxMind databases.  | `nginx-module-geoip` |
| [`ngx_http_image-filter_module`](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html)| Transforms images in JPEG, GIF, PNG, and WebP formats.  | `nginx-module-image-filter` |
| [`ngx_http_js_module`](https://nginx.org/en/docs/http/ngx_http_js_module.html), [`ngx_stream_js_module`](https://nginx.org/en/docs/stream/ngx_stream_js_module.html)| Extends the server's functionality through JavaScript scripting, enabling the creation of custom server-side logic. | `nginx-module-njs` |
| [`ngx_http_perl_module`](https://nginx.org/en/docs/http/ngx_http_perl_module.html) | Implements location and variable handlers in Perl and inserts Perl calls into SSI. | `nginx-module-perl` |
| [`ngx_http_xsl_module`](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) | Transforms XML responses using one or more XSLT stylesheets. | `nginx-module-xslt` |
| [`ngx_otel_module`](https://nginx.org/en/docs/ngx_otel_module.html) | Provides OpenTelemetry distributed tracing support. | `nginx-module-otel` |
{{</bootstrap-table>}}

## Compile and install from source {#sources}

Compiling from source affords more flexibility than using prebuilt packages: you can add specific modules, both official and third party, and apply the latest security patches.

### Install NGINX dependencies {#dependencies}

Prior to compiling NGINX Open Source from source, you need to install libraries for its dependencies:

- [PCRE](http://pcre.org/) – Supports regular expressions. Required by the NGINX [Core](https://nginx.org/en/docs/ngx_core_module.html) and [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) modules.

  ```shell
  wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.43/pcre2-10.43.tar.gz && \
  tar -zxf pcre2-10.43.tar.gz && \
  cd pcre2-10.43 && \
  ./configure && \
  make && \
  sudo make install
  ```

- [zlib](http://www.zlib.net/) – Supports header compression. Required by the NGINX [Gzip](https://nginx.org/en/docs/http/ngx_http_gzip_module.html) module.

  ```shell
  wget http://zlib.net/zlib-1.3.1.tar.gz && \
  tar -zxf zlib-1.3.1.tar.gz && \
  cd zlib-1.3.1 && \
  ./configure && \
  make && \
  sudo make install
  ```

- [OpenSSL](https://www.openssl.org/) – Supports the HTTPS protocol. Required by the NGINX [SSL](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) module and others.

  ```shell
  wget http://www.openssl.org/source/openssl-3.0.13.tar.gz
  tar -zxf openssl-3.0.13.tar.gz
  cd openssl-3.0.13
  ./Configure darwin64-x86_64-cc --prefix=/usr
  make
  sudo make install
  ```

  Example for Ubuntu and Debian:
  ```shell
  wget https://www.openssl.org/source/openssl-3.0.13.tar.gz
  tar -zxf openssl-3.0.13.tar.gz
  cd openssl-3.0.13
  ./config --prefix=/usr/local --openssldir=/usr/local/ssl
  make -j$(nproc)
  sudo make install
  ```

  Example for RHEL-based:
  ```shell
  curl -LO https://www.openssl.org/source/openssl-3.0.13.tar.gz
  tar -zxf openssl-3.0.13.tar.gz
  cd openssl-3.0.13
  ./config --prefix=/usr/local --openssldir=/usr/local/ssl
  make -j$(nproc)
  sudo make install
  ```

### Download the sources {#sources_download}

Download the source files for both the stable and mainline versions from [**nginx.org**](https://www.nginx.org/en/download.html).

To download and unpack the source for the latest _mainline_ version, run:

```shell
wget https://nginx.org/download/nginx-1.27.5.tar.gz && \
tar zxf nginx-1.27.5.tar.gz && \
cd nginx-1.27.5
```

To download and unpack source files for the latest _stable_ version, run:

```shell
wget https://nginx.org/download/nginx-1.28.0.tar.gz && \
tar zxf nginx-1.28.0.tar.gz && \
cd nginx-1.28.0
```

### Configure the build options {#configure}

Configure options are specified with the `./configure` script that sets up various NGINX parameters, including paths to source and configuration files, compiler options, connection processing methods, and the list of modules. The script finishes by creating the `Makefile` required to compile the code and install NGINX Open Source.

An example of options to the `configure` script:

```shell
./configure \
--sbin-path=/usr/local/nginx/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-pcre=../pcre2-10.43 \
--with-zlib=../zlib-1.3.1 \
--with-http_ssl_module \
--with-stream \
--with-mail=dynamic \
--add-module=/usr/build/nginx-rtmp-module \
--add-dynamic-module=/usr/build/3party_module
```

### Configure NGINX paths {#configure_paths}

The `configure` script allows you to set paths to NGINX binary and configuration files, and to dependent libraries such as PCRE or SSL, in order to link them statically to the NGINX binary.



{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Parameter | Description |
| ---| --- |
|`--prefix=<PATH>` | Directory for NGINX files, and the base location for all relative paths set by the other `configure` script options (excluding paths to libraries) and for the path to the **nginx.conf** configuration file. Default: **/usr/local/nginx**. |
|`--sbin-path=<PATH>` | Name of the NGINX executable file, which is used only during installation. Default: **<prefix>/sbin/nginx |
|`--conf-path=<PATH>` | Name of the NGINX configuration file. You can, however, always override this value at startup by specifying a different file with the `-c <FILENAME>` option on the `nginx` command line. Default: **<prefix>conf/nginx.conf |
|`--pid-path=<PATH>` | Name of the **nginx.pid** file, which stores the process ID of the `nginx` master process. After installation, the path to the filename can be changed with the [pid](https://nginx.org/en/docs/ngx_core_module.html#pid) directive in the NGINX configuration file. Default: **<prefix>/logs/nginx.pid |
|`--error-log-path=<PATH>` | Name of the primary log file for errors, warnings, and diagnostic data. After installation, the filename can be changed with the [error_log](https://nginx.org/en/docs/ngx_core_module.html#error_log) directive in the NGINX configuration file. Default: **<prefix>/logs/error.log |
|`--http-log-path=<PATH>` | Name of the primary log file for requests to the HTTP server. After installation, the filename can always be changed with the [access_log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) directive in the NGINX configuration file. Default: **<prefix>/logs/access.log |
|`--user=<NAME>` | Name of the unprivileged user whose credentials are used by the NGINX worker processes. After installation, the name can be changed with the [user](https://nginx.org/en/docs/ngx_core_module.html#user) directive in the NGINX configuration file. Default: `nobody` |
|`--group=<NAME>` | Name of the group whose credentials are used by the NGINX worker processes. After installation, the name can be changed with the [user](https://nginx.org/en/docs/ngx_core_module.html#user) directive in the NGINX configuration file. Default: the value set by the `--user`` option. |
|`--with-pcre=<PATH>` | Path to the source for the PCRE library, which is required for regular expressions support in the [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directive and the [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module. |
|`--with-pcre-jit` | Builds the PCRE library with “just-in-time compilation” support (the [pcre_jit](https://nginx.org/en/docs/ngx_core_module.html#pcre_jit) directive). |
|`--with-zlib=<PATH>` | Path to the source for the `zlib` library, which is required by the [Gzip](https://nginx.org/en/docs/http/ngx_http_gzip_module.html) module. |
{{</bootstrap-table>}}


### GCC options {#configure_gcc}

With the `configure` script you can also specify compiler‑related options.


{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Parameter | Description |
| ---| --- |
|`--with-cc-opt="<PARAMETERS>"` | Additional parameters that are added to the ``CFLAGS`` variable. When using the system PCRE library under FreeBSD, the mandatory value is `--with-cc-opt="-I /usr/local/include"`. If the number of files supported by `select()` needs to be increased, it can also specified here as in this example: `--with-cc-opt="-D FD_SETSIZE=2048"`. |
|`--with-ld-opt="<PARAMETERS>"` | Additional parameters that are used during linking. When using the system PCRE library under FreeBSD, the mandatory value is `--with-ld-opt="-L /usr/local/lib"`. |

{{</bootstrap-table>}}


### Connection processing methods {#configure_methods}

With the `configure` script you can redefine the method for event‑based polling. For more information, see [Connection processing methods](https://nginx.org/en/docs/events.html) in the NGINX reference documentation.


{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Module Name | Description |
| ---| --- |
|`--with-select_module`, `--without-select_module` | Enables or disables building a module that enable NGINX to work with the ``select()`` method. The modules is built automatically if the platform does not appear to support more appropriate methods such as `kqueue`, `epoll`, or `/dev/poll`. |
|`--with-poll_module`, `--without-poll_module` | Enables or disables building a module that enables NGINX to work with the `poll()` method. The module is built automatically if the platform does not appear to support more appropriate methods such as `kqueue`, `epoll`, or `/dev/poll`. |

{{</bootstrap-table>}}

### Select the NGINX modules to build {#modules}

NGINX consists of a set of function‑specific _modules_, which are specified with `configure` script along with other build options.

Some modules are built by default – they do not have to be specified with the `configure` script. Default modules can however be explicitly excluded from the NGINX binary with the <span style="white-space: nowrap;">`--without-<MODULE-NAME>`</span> option on the `configure` script.

Modules not included by default, as well as third‑party modules, must be explicitly specified in the `configure` script together with other build options. Such modules can be linked to NGINX binary either _statically_ (they are then loaded each time NGINX starts) or _dynamically_ (they are loaded only if associated directives are included in the NGINX configuration file.

#### Modules built by default {#modules_default}

If you do not need a module that is built by default, you can disable it by naming it with the <span style="white-space: nowrap;">`--without-<MODULE-NAME>`</span> option on the `configure` script, as in this example which disables the [Empty GIF](https://nginx.org/en/docs/http/ngx_http_empty_gif_module.html) module (should be typed as a single line):

```shell
./configure
--sbin-path=/usr/local/nginx/nginx  \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_ssl_module \
--with-stream \
--with-pcre=../pcre2-10.43 \
--with-zlib=../zlib-1.3.1 \
--without-http_empty_gif_module
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Module Name | Description |
| ---| --- |
|[`http_access_module`](https://nginx.org/en/docs/http/ngx_http_access_module.html) | Accepts or denies requests from specified client addresses. |
|[`http_auth_basic_module`](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html) | Limits access to resources by validating the user name and password using the HTTP Basic Authentication protocol. |
|[`http_autoindex_module`](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html) | Processes requests ending with the forward-slash character (_/_) and produces a directory listing. |
|[`http_browser_module`](https://nginx.org/en/docs/http/ngx_http_browser_module.html) | Creates variables whose values depend on the value of the ``User-Agent`` request header. |
|[`http_charset_module`](https://nginx.org/en/docs/http/ngx_http_charset_module.html) | Adds the specified character set to the ``Content-Type`` response header. Can convert data from one character set to another. |
|[`http_empty_gif_module`](https://nginx.org/en/docs/http/ngx_http_empty_gif_module.html) | Emits a single-pixel transparent GIF. |
|[`http_fastcgi_module`](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) | Passes requests to a FastCGI server. |
|[`http_geo_module`](https://nginx.org/en/docs/http/ngx_http_geo_module.html) | Creates variables with values that depend on the client IP address. |
|[`http_gzip_module`](https://nginx.org/en/docs/http/ngx_http_gzip_module.html) | Compresses responses using `gzip`, reducing the amount of transmitted data by half or more. |
|[`http_limit_conn_module`](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html) | Limits the number of connections per a defined key, in particular, the number of connections from a single IP address. |
|[`http_limit_req_module`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) | Limits the request processing rate per a defined key, in particular, the processing rate of requests coming from a single IP address. |
|[`http_map_module`](https://nginx.org/en/docs/http/ngx_http_map_module.html) | Creates variables whose values depend on the values of other variables. |
|[`http_memcached_module`](https://nginx.org/en/docs/http/ngx_http_memcached_module.html) | Passes requests to a memcached server. |
|[`http_proxy_module`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) | Passes HTTP requests to another server. |
|[`http_referer_module`](https://nginx.org/en/docs/http/ngx_http_referer_module.html) | Blocks requests with invalid values in the `Referer` header. |
|[`http_rewrite_module`](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) | Changes the request URI using regular expressions and return redirects; conditionally selects configurations. Requires the [PCRE](http://pcre.org/) library. |
|[`http_scgi_module`](https://nginx.org/en/docs/http/ngx_http_scgi_module.html) | Passes requests to an SCGI server. |
|[`http_ssi_module`](https://nginx.org/en/docs/http/ngx_http_ssi_module.html) | Processes SSI (Server Side Includes) commands in responses passing through it. |
|[`http_split_clients_module`](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html) | Creates variables suitable for A/B testing, also known as split testing. |
|[`http_upstream_hash_module`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash) | Enables the generic Hash load-balancing method. |
|[`http_upstream_ip_hash_module`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash) | Enables the IP Hash load-balancing method. |
|[`http_upstream_keepalive_module`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) | Enables keepalive connections. |
|[`http_upstream_least_conn_module`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn) | Enables the Least Connections load-balancing method. |
|[`http_upstream_zone_module`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) | Enables shared memory zones. |
|[`http_userid_module`](https://nginx.org/en/docs/http/ngx_http_userid_module.html) | Sets cookies suitable for client identification. |
|[`http_uwsgi_module`](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) | Passes requests to a uwsgi server. |
{{</bootstrap-table>}}


### Include modules not built by default {#modules_not_default}

Many NGINX modules are not built by default, and must be listed on the `configure` command line to be built.

The [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html), [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html), [geoip](https://nginx.org/en/docs/http/ngx_http_geoip_module.html), [image_filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html), [perl](https://nginx.org/en/docs/http/ngx_http_perl_module.html) and [xslt](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) modules can be compiled as dynamic. See [Dynamic Modules]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) for details.

An example of the `configure` command that includes nondefault modules (should be typed as a single line):

```shell
./configure \
--sbin-path=/usr/local/nginx/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-pcre=../pcre2-10.43 \
--with-zlib=../zlib-1.3.1 \
--with-http_ssl_module \
--with-stream \
--with-mail
```

{{<bootstrap-table "table table-striped table-bordered">}}
|Module Name               | Description                                  |
| -------------------------| ---------------------------------------------|
|`--with-cpp_test_module`   | Tests the C++ compatibility of header files.|
|`--with-debug`   | Enables the [debugging log]({{< ref "/nginx/admin-guide/monitoring/debugging.md" >}})|
| `--with-file-aio`        |Enables asynchronous I/O. |
|  `--with-google-perftools` | Allows using [Google Performance tools](https://github.com/gperftools/gperftools) library. |
|[`--with-http_addition_module`](https://nginx.org/en/docs/http/ngx_http_addition_module.html)| Adds text before and after a response. |
|[`--with-http_auth_request_module`](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html)|Implements client authorization based on the result of a subrequest. |
|[`--with-http_dav_module`](https://nginx.org/en/docs/http/ngx_http_dav_module.html)|Enables file management automation using the WebDAV protocol. |
|`--with-http_degradation_module`|Allows returning an error when a memory size exceeds the defined value. |
|[`--with-http_flv_module`](https://nginx.org/en/docs/http/ngx_http_flv_module.html)|Provides pseudo-streaming server-side support for Flash Video (FLV) files. |
|[`--with-http_geoip_module`](https://nginx.org/en/docs/http/ngx_http_geoip_module.html)|Enables creating variables whose values depend on the client IP address. The module uses [MaxMind](http://www.maxmind.com) GeoIP databases. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-http_geoip_module=dynamic`. |
|[`--with-http_gunzip_module`](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html)|Decompresses responses with `Content-Encoding: gzip` for clients that do not support the _zip_ encoding method. |
|[`--with-http_gzip_static_module`](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)| Allows sending precompressed files with the **.gz** filename extension instead of regular files. |
|[`--with-http_image_filter_module`](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html)|T ransforms images in JPEG, GIF, and PNG formats. The module requires the [LibGD](http://libgd.github.io/) library. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-http_image_filter_module=dynamic`. |
|[`--with-http_mp4_module`](https://nginx.org/en/docs/http/ngx_http_mp4_module.html)| Provides pseudo-streaming server-side support for MP4 files.                                              |
|[`--with-http_perl_module`](https://nginx.org/en/docs/http/ngx_http_perl_module.html)| Used to implement location and variable handlers in Perl and insert Perl calls into SSI. Requires the [PERL](https://www.perl.org/get.html) library. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-http_perl_module=dynamic`. |
|[`--with-http_random_index_module`](https://nginx.org/en/docs/http/ngx_http_random_index_module.html) | Processes requests ending with the slash character (‘/’) and picks a random file in a directory to serve as an index file. |
|[`--with-http_realip_module`](https://nginx.org/en/docs/http/ngx_http_realip_module.html) | Changes the client address to the one sent in the specified header field. |
|[`--with-http_secure_link_module`](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html) | Used to check authenticity of requested links, protect resources from unauthorized access, and limit link lifetime. |
|[`--with-http_slice_module`](https://nginx.org/en/docs/http/ngx_http_slice_module.html) | Allows splitting a request into subrequests, each subrequest returns a certain range of response. Provides more effective caching of large files. |
|[`--with-http_ssl_module`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) | Enables HTTPS support. Requires an SSL library such as [OpenSSL](https://www.openssl.org/). |
|[`--with-http_stub_status_module`](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html)| Provides access to basic status information. Note that NGINX Plus customers do not require this module as they are already provided with extended status metrics and interactive dashboard. |
|[`--with-http_sub_module`](https://nginx.org/en/docs/http/ngx_http_sub_module.html) |  Modifies a response by replacing one specified string by another.  |
|[`--with-http_xslt_module`](https://nginx.org/en/docs/http/ngx_http_xslt_module.html)| Transforms XML responses using one or more XSLT stylesheets. The module requires the [Libxml2](http://xmlsoft.org/) and [XSLT](http://xmlsoft.org/XSLT/) libraries. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-http_xslt_module=dynamic`. |
|[`--with-http_v2_module`](https://nginx.org/en/docs/http/ngx_http_v2_module.html)| Enable support for [HTTP/2](https://datatracker.ietf.org/doc/html/rfc7540). See [The HTTP/2 Module in NGINX](https://www.nginx.com/blog/http2-module-nginx/) on the NGINX blog for details.                                             |
| [`--with-mail`](https://nginx.org/en/docs/mail/ngx_mail_core_module.html)| Enables mail proxy functionality. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-mail=dynamic`.                                            |
|[`--with-mail_ssl_module`](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html)| Provides support for a mail proxy server to work with the SSL/TLS protocol. Requires an SSL library such as [OpenSSL](https://www.openssl.org/). |
| [`--with-stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) | Enables the TCP and UDP proxy functionality. To compile as a separate [dynamic module]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}}) instead, change the option to `--with-stream=dynamic`. |
| [`--with-stream_ssl_module`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html)| Provides support for a stream proxy server to work with the SSL/TLS protocol. Requires an SSL library such as [OpenSSL](https://www.openssl.org/). |
| `--with-threads` | Enables NGINX to use thread pools. For details, see [Thread Pools in NGINX Boost Performance 9x!](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) on the NGINX blog. |
{{</bootstrap-table>}}

### Include third-party modules

You can extend NGINX functionality by compiling NGINX Open Source with your own module or a third‑party module. Some third‑party modules are listed in the [NGINX Wiki](https://nginx.com/resources/wiki/modules/). Use third‑party modules at your own risk as their stability is not guaranteed.

#### Statically linked modules {#modules_third_party}

Most modules built into NGINX Open Source are _statically linked_: they are built into NGINX Open Source at compile time and are linked to the NGINX binary statically. These modules can be disabled only by recompiling NGINX.

To compile NGINX Open Source with a statically linked third‑party module, include the `--add-module=<PATH>` option on the `configure` command, where `<PATH>` is the path to the source code (this example is for the [RTMP](https://github.com/arut/nginx-rtmp-module)  module):

```shell
./configure ... --add-module=/usr/build/nginx-rtmp-module
```

#### Dynamically linked modules

NGINX modules can also be compiled as a shared object (**\*.so** file) and then dynamically loaded into NGINX Open Source at runtime. This provides more flexibility, as the module can be loaded or unloaded at any time by adding or removing the associated [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the NGINX configuration file and reloading the configuration. Note that the module itself must support dynamic linking.

To compile NGINX Open Source with a dynamically loaded third‑party module, include the `--add-dynamic-module=<PATH>` option on the `configure` command, where `<PATH>` is the path to the source code:


```shell
./configure ... --add-dynamic-module=<PATH>
```

The resulting **\*.so** files are written to the _prefix_**/modules/** directory, where the _prefix_ is a directory for server files such as **/usr/local/nginx/**.

To load a dynamic module, add the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive to the NGINX configuration after installation:

```nginx
load_module modules/ngx_mail_module.so;
```

For more information, see [Compiling Third‑Party Dynamic Modules for NGINX and NGINX Plus](https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/) on the NGINX blog and [Extending NGINX](https://nginx.com/resources/wiki/extending/) in the Wiki.

### Complete the installation from source {#install_complete}

- Compile and install the build:

    ```shell
    make
    sudo make install
    ```

- After the installation is finished, start NGINX Open Source:

    ```shell
    sudo nginx
    ```
