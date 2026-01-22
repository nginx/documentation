---
nd-docs: DOCS-275
title: "Disconnected or air-gapped environments"
weight: 500
toc: true
nd-content-type: how-to
nd-product: F5WAFN
---

This topic describes how to install F5 WAF for NGINX in a disconnected or air-gapped environment.

Many of the steps involved are similar to other installation methods: this document will refer to them when appropriate.

## Before you begin

To complete this guide, you will need the following prerequisites:

- The requirements of your installation method:
    - [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md#before-you-begin" >}})
    - [Docker]({{< ref "/waf/install/docker.md#before-you-begin" >}})
    - [Kubernetes]({{< ref "/waf/install/kubernetes.md#before-you-begin" >}})
- An active F5 WAF for NGINX subscription (purchased or trial) with repository credentials (JWT token or username/password).
- A connected environment with similar architecture and internet access to the NGINX package repositories.
- A method to transfer files between two environments (USB drive, SCP, rsync, etc.).
- For package downloads on apt-based systems: `wget`, `gnupg`, `ca-certificates`, and `apt-transport-https`.
- For package downloads on yum-based systems: `yum-utils`.

These instructions outline the broad, conceptual steps involved with working with a disconnected environment. You will need to make adjustments based on your specific security requirements.

Some users may be able to use a USB stick to transfer necessary set-up artifacts, whereas other users may be able to use tools such as SSH or SCP.

In the following sections, the term _connected environment_ refers to the environment with access to the internet you will use to download set-up artifacts.

The term _disconnected environment_ refers to the final environment the F5 WAF for NGINX installation is intended to run in, and is the target to transfer set-up artifacts from the connected environment.

## Download and run the documentation website locally

For a disconnected environment, you may want to browse documentation offline.

This is possible by cloning the repository and the binary file for Hugo.

In addition to accessing F5 WAF for NGINX documentation, you will be able to access any supporting documentation you may need from other products.

You will need `git` and `wget` in your connected environment.

Run the following two commands: replace `<hugo-release>` with the tarball appropriate to the environment from [the release page](https://github.com/gohugoio/hugo/releases/tag/v0.152.2):

```shell
git clone git@github.com:nginx/documentation.git
wget <hugo-release>
```

Move the repository folder and the tarball to your disconnected environment.

In your disconnected environment, extract the tarball archive, then move the `hugo` binary somewhere on your PATH.

Change into the cloned repository and run Hugo: you should be able to access the documentation on localhost.

```shell
cd documentation
hugo server
```

---

## Installation in Virtual Machine or Bare Metal

### Download the required packages

When working with package files, you can install the packages directly in your disconnected environment, or add them to an internal repository.

The first step is to download the package files from a connected environment that has internet access and your NGINX repository credentials.

See the section for your operating system below:

#### Alpine Linux

1. Download and install the repository signing key:
   
   ```shell
   sudo wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub
   ```

1. Add the F5 WAF for NGINX repositories:
 
   ```shell
    printf "https://pkgs.nginx.com/app-protect/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main\n" | sudo tee -a /etc/apk/repositories
   printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main\n" | sudo tee -a /etc/apk/repositories
   ```

1. Create a directory for packages and download app-protect:

   ```shell
   apk update
   mkdir -p /offline/packages && cd /offline/packages
   apk fetch --recursive app-protect app-protect-attack-signatures app-protect-bot-signatures app-protect-threat-campaigns
   ```

#### Amazon Linux 2023

1. Add the F5 WAF for NGINX repository and dependencies:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo
   ```

1. Create a directory for packages and download app-protect:

   ```shell
   mkdir -p /offline/packages/
   sudo dnf install --downloadonly --downloaddir=/offline/packages/ \
   app-protect \
   app-protect-attack-signatures \
   app-protect-bot-signatures \
   app-protect-threat-campaigns
   ```

#### Debian

1. Install required packages:

   ```shell
   sudo apt-get install -y wget gnupg ca-certificates apt-transport-https lsb-release
   ```

1. Download and install the NGINX repository signing key:

   ```shell
   wget -qO - https://cs.nginx.com/static/keys/nginx-archive.key | gpg --dearmor | \
   sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
   ```

1. Add the F5 WAF for NGINX repositories:

   ```shell
   RELEASE=$(lsb_release -cs)

   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/app-protect/debian $RELEASE nginx-plus\n" | \
   sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/app-protect-security-updates/debian $RELEASE nginx-plus\n" | \
   sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
   ```

1. Create a directory for packages and download app-protect:

   ```shell
   mkdir -p /offline/packages
   cd /offline/packages
   apt-get update

   apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect | grep "^\w" | sort -u)
   ```

#### Oracle Linux / RHEL / Rocky Linux 8

1. Add the F5 WAF for NGINX repository:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-rhel8.repo
   ```

1. Install the `yum-utils` package if not already installed:

   ```shell
   sudo dnf install yum-utils
   ```

1. Enable codeready-builder repository through subscription manager:

   ```shell
   subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
   ```

   1. Download the `epel-release` dependency package if not already installed:

   ```shell
   rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
   ```

1. Create a directory for packages and download app-protect:

   ```shell
   mkdir -p /offline/packages

   sudo yumdownloader --resolve --destdir=/offline/packages \
   app-protect \
   app-protect-attack-signatures \
   app-protect-bot-signatures \
   app-protect-threat-campaigns

   ```

#### RHEL / Rocky Linux 9

1. Add the F5 WAF for NGINX repository:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-rhel9.repo
   ```

1. Install the `yum-utils` package if not already installed:

   ```shell
   sudo dnf install yum-utils
   ```

1. Enable codeready-builder repository through subscription manager:

   ```shell
   subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
   ```

1. Download the `epel-release` dependency package if not already installed:

   ```shell
   rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
   ```

1. Create a directory for packages and download app-protect:

   ```shell
   mkdir -p /offline/packages

   sudo yumdownloader --resolve --destdir=/offline/packages \
   app-protect \
   app-protect-attack-signatures \
   app-protect-bot-signatures \
   app-protect-threat-campaigns
   ```

#### Ubuntu

1. Install required packages:

   ```shell
   sudo apt-get install -y wget gnupg ca-certificates apt-transport-https lsb-release
   ```

1. Download and install the NGINX repository signing key:

   ```shell
   wget -qO - https://cs.nginx.com/static/keys/nginx-archive.key | gpg --dearmor | \
   sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
   ```

1. Add the F5 WAF for NGINX repositories:

   ```shell
   RELEASE=$(lsb_release -cs)

   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/app-protect/ubuntu $RELEASE nginx-plus\n" | \
   sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/app-protect-security-updates/ubuntu $RELEASE nginx-plus\n" | \
   sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
   ```

1. Create a directory for packages and download app-protect:

   ```shell
   mkdir -p /offline/packages
   cd /offline/packages
   apt-get update

   apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances app-protect | grep "^\w" | sort -u)
   ```

### Transfer the packages

After you've downloaded the package files in your connected environment, transfer the `packages` directory to your disconnected environment using a method that works for you, such as a USB drive, SCP, or rsync.

### Install the packages

In the disconnected environment, install the packages:

- For Alpine Linux

   ```shell
   cd /offline/packages
   apk add --allow-untrusted app-protect*.apk nginx-plus*.apk
   ```

- For Amazon Linux 2023, RHEL 9, Rocky Linux 9

   ```shell
   cd /offline
   dnf localinstall -y *.rpm
   ```

- For Debian, Ubuntu

   ```shell
   cd /offline
   dpkg -i *.deb
   ```

- For Oracle Linux, RHEL 8, Rocky Linux 8

   ```shell
   sudo yum localinstall /offline/packages/*.rpm
   ```

---

## Download Docker images

After pulling or building Docker images in a connected environment, you can save them to `.tar` files:

   ```shell
   docker save -o waf-enforcer.tar waf-enforcer:{{< version-waf-enforcer >}}
   docker save -o waf-config-mgr.tar waf-config-mgr:{{< version-waf-config-mgr >}}
   # Optional, if using IP intelligence
   docker save -o waf-ip-intelligence.tar waf-ip-intelligence:{{< version-waf-ip-intelligence >}}
   ```

You can then transfer the files and load the images in your disconnected environment:

   ```shell
   docker load -i waf-enforcer.tar
   docker load -i waf-config-mgr.tar
   # Optional, if using IP intelligence
   docker load -i waf-ip-intelligence.tar
   ```

Ensure your Docker compose files use the tagged images you've transferred.