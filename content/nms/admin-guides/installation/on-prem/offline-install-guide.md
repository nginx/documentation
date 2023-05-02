---
categories:
- installation
date: "2021-12-21T12:00:00-07:00"
description: Complete the steps in this guide to install NGINX Management Suite modules directly from package files in environments without Internet access.
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
title: Offline Installation Guide
toc: true
versions: []
weight: 300
docs: "DOCS-803"
aliases:
- /nginx-instance-manager/getting-started/installation/offline-install/
- /nginx-instance-manager/installation/offline-install-guide/
- /admin-guides/installation/offline-install-guide/
---

{{< custom-styles >}}

## Overview

{{< include "nms/nim-core-module.md" >}}

---

## Before You Begin

- Download the NGINX Management Suite package files from the [MyF5 Customer Portal](https://account.f5.com/myf5).

---

## Offline Dependencies

NGINX Management Suite has both local and external dependencies. Before installing an NGINX Management Suite module, make sure to install these local and external dependencies.

### Local Dependencies

Local dependencies are common Linux packages like `curl` or `openssl`, which most Linux distributions include by default. These dependencies are installed automatically by your package manager when installing an NGINX Management Suite module. Without internet access, you need to ensure that your package manager can use a local package repository, such as your distribution DVD/ISO image or internal network mirror. Refer to your Linux distribution documentation for more details.

{{< note >}}**RedHat on AWS**: If you're using Amazon Web Services and, for security reasons, you can't attach remote or local RedHat package repositories, you can download the necessary packages on another RedHat machine and copy them to your machine. To do this, you can use the `yumdownloader` utility:
https://access.redhat.com/solutions/10154.{{< / note >}}

### External Dependencies

External dependencies are packages that aren't available by default in regular Linux distributions.

Before installing NGINX Management Suite on an offline system, you must manually download the external dependencies and copy them to your machine.

1. Download the `fetch-external-dependencies.sh` script. This script downloads the necessary packages to a `tar.gz` archive.

    {{<fa "download">}} {{<link "/scripts/fetch-external-dependencies.sh" "fetch-external-dependencies.sh">}}

1. Run the `fetch-external-dependencies.sh` script to download the external dependencies. Specify your Linux distribution for the packages.

    ```bash
    ./fetch-external-dependencies <linux distribution>
    ```

    Linux distributions:

    - `ubuntu18.04`
    - `ubuntu20.04`
    - `ubuntu22.04`
    - `debian10`
    - `debian11`
    - `centos7`
    - `oracle7`
    - `oracle8`
    - `rhel7`
    - `rhel8`
    - `rhel9`
    - `amzn2`

    For example:

    ```bash
    ./fetch-external-dependencies ubuntu18.04
    ```

1. After you copy and extract the bundle onto your target machine, take the following steps to install the packages:

    {{< note >}}The bundled NGINX server package may conflict with installed versions of NGINX or NGINX Plus. Delete the package from the bundle if you want to keep the existing version.{{< /note >}}

    - CentOS, RHEL, and RPM-Based distributions:

        ```bash
        tar -kzxvf nms-dependencies-rhel7.tar.gz
        sudo yum localinstall *.rpm
        ```

    - Debian, Ubuntu, and Deb-Based distributions

        ```bash
        tar -kzxvf nms-dependencies-ubuntu18.04.tar.gz
        sudo dpkg -i ./*.deb
        ```

    {{< note >}} Even though the ClickHouse server may not be exposed to the network, you should use a non-default username and strong password for improved security.{{< /note >}}

---

## Install Instance Manager {#install-nim-offline}

{{< include "nim/installation/install-nim-offline.md" >}}

- See the [Access the Web Interface](#web-interface). After you log in, you can [add a license]({{< relref "/admin-guides/getting-started/add-license.md" >}}).

---

## Install API Connectivity Manager {#install-acm-offline}

### Dependencies with Instance Manager

{{< include "tech-specs/acm-nim-dependencies.md" >}}

### Install the Management Plane {#install-acm-data-plane-offline}

{{< include "acm/installation/install-acm-offline.md" >}}

- See the section on how to [access the NGINX Management Suite web interface](#web-interface). After you log in, you can [add a license]({{< relref "/admin-guides/getting-started/add-license.md" >}}).

### Install the Data Plane {#acm-offline-dependencies}

{{< include "acm/installation/install-acm-dataplane-dependencies.md" >}}

### Install the Developer Portal {#install-acm-devportal-offline}

{{< include "acm/installation/install-acm-dev-portal-offline.md" >}}

---

## Access the Web Interface {#web-interface}

{{< include "nms/access-web-interface.md" >}}

---

## NGINX Management Suite Services {#nms-services}

{{< include "nms/nms-services.md" >}}

---

## How To Look Up the Installed Version

{{< include "nms/look-up-version.md" >}}

---

## CVE Checking {#cve-check}

Instance Manager connects to the internet to get a list of the current CVEs (Common Vulnerabilities and Exposures) to use with the [scan function]({{< relref "/nim/how-to/nginx/scan-instances.md" >}}). To manually update the CVE list, download and overwrite the `cve.xml` file in the `/usr/share/nms` directory.

To download the CVE file, take the following steps:

1. Download the CVE file:

    ```bash
    curl -s http://hg.nginx.org/nginx.org/raw-file/tip/xml/en/security_advisories.xml > /usr/share/nms/cve.xml
    ```

1. Restart the dpm service to pick up the new CVE file:

    ```bash
    systemctl restart nms-dpm
    ```

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}