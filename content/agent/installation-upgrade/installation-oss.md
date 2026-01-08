---
title: Installation from NGINX repository
weight: 300
toc: true
nd-docs: DOCS-1216
nd-content-type: how-to
nd-product: NAGENT
---

## Overview

Learn how to install NGINX Agent from the NGINX Open Source repository.

## Prerequisites

- NGINX installed. Once installed, ensure it is running. If you don't have it installed already, follow these steps to install [NGINX](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)
- A [supported operating system and architecture]({{< ref "/agent/technical-specifications.md#supported-distributions" >}})
- `root` privilege

## Configure NGINX OSS Repository for installing NGINX Agent

Before you install NGINX Agent for the first time on your system, you need to set up the `nginx-agent` packages repository. Afterward, you can install and update NGINX Agent from the repository.

### Installing NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/oss/oss-rhel.md" >}}

{{< /details >}}

### Installing NGINX Agent on Ubuntu

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/oss/oss-ubuntu.md" >}}

{{< /details >}}

### Installing NGINX Agent on Debian

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/oss/oss-debian.md" >}}

{{< /details >}}

### Installing NGINX Agent on SLES

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/oss/oss-sles.md" >}}

{{< /details >}}

### Installing NGINX Agent on Alpine Linux

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/oss/oss-alpine.md" >}}

{{< /details >}}

### Installing NGINX Agent on Amazon Linux 2023

{{< details summary="Expand instructions" >}}

1. Install the prerequisites:

    ```shell
    sudo dnf install yum-utils procps-ng
    ```

1. To set up the dnf repository for Amazon Linux 2023, create the file named `/etc/yum.repos.d/nginx-agent.repo` with the following contents:

    ```shell
    [nginx-agent]
    name=nginx agent repo
    baseurl=https://packages.nginx.org/nginx-agent/amzn/2023/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://nginx.org/keys/nginx_signing.key
    module_hotfixes=true
    ```

1. To install `nginx-agent` with a specific version (for example, 2.42.0):

    ```shell
    sudo dnf install -y nginx-agent-2.42.0
    ```

1. When prompted to accept the GPG key, verify that the fingerprint matches
    `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`,
    `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`,
    `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3`
     and if so, accept it.

1. Verify the installation:

    ```shell
    sudo nginx-agent -v
    ```

{{< /details >}}

### Installing NGINX Agent on Amazon Linux 2

{{< details summary="Expand instructions" >}}

{{< include "/agent/installation/oss/oss-amazon-linux.md" >}}

{{< /details >}}

### Installing NGINX Agent on FreeBSD

{{< details summary="Expand instructions" >}}

1. To setup the pkg repository create the file named `/etc/pkg/nginx-agent.conf` with the following content:

    ```shell
    nginx-agent: {
    URL: pkg+http://packages.nginx.org/nginx-agent/freebsd/${ABI}/latest
    ENABLED: true
    MIRROR_TYPE: SRV
    }
    ```

1. To install `nginx-agent` with a specific version (for example, 2.42.0):

    ```shell
    sudo pkg install nginx-agent-2.42.0
    ```

1. Verify the installation:

    ```shell
    sudo nginx-agent -v
    ```

{{< /details >}}
