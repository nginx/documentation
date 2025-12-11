---
title: Installation from NGINX Plus repository
weight: 400
toc: true
nd-docs: DOCS-1217
nd-content-type: how-to
nd-product: NAGENT
---

## Overview

Learn how to install NGINX Agent from NGINX Plus repository

## Prerequisites

- An NGINX Plus subscription (purchased or trial)
- NGINX Plus installed. Once installed, ensure it is running. If you don't have it installed already, follow these steps to install [NGINX Plus](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)
- A [supported operating system and architecture]({{< ref "/agent/technical-specifications.md#supported-distributions" >}})
- `root` privilege
- Your credentials to the MyF5 Customer Portal, provided by email from F5, Inc.
- Your NGINX Plus certificate and public key (`nginx-repo.crt` and `nginx-repo.key` files), provided by email from F5, Inc.

## Configure NGINX Plus Repository for installing NGINX Agent

Before you install NGINX Agent for the first time on your system, you need to set up the `nginx-agent` packages repository. Afterward, you can install and update NGINX Agent from the repository.

### Installing NGINX Agent on RHEL, CentOS, Rocky Linux, AlmaLinux, and Oracle Linux

{{< details summary="Expand instructions" >}}

{{< include "agent/installation/plus/plus-rhel.md" >}}

{{< /details >}}

### Installing NGINX Agent on Ubuntu

{{< details summary="Expand instructions" >}}

{{< include "agent/installation/plus/plus-ubuntu.md" >}}

{{< /details >}}

### Installing NGINX Agent on Debian

{{< details summary="Expand instructions" >}}

{{< include "agent/installation/plus/plus-debian.md" >}}

{{< /details >}}

### Installing NGINX Agent on SLES

{{< details summary="Expand instructions" >}}

{{< include "agent/installation/plus/plus-sles.md" >}}

{{< /details >}}

### Installing NGINX Agent on Alpine Linux

{{< details summary="Expand instructions" >}}

{{< include "agent/installation/plus/plus-alpine.md" >}}

{{< /details >}}

### Installing NGINX Agent on Amazon Linux 2023

{{< details summary="Expand instructions" >}}

1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

1. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download your `nginx-repo.crt` and `nginx-repo.key` files.

1. Copy the `nginx-repo.crt` and `nginx-repo.key` files to the `/etc/ssl/nginx/` directory:

    ```shell
    sudo cp nginx-repo.crt nginx-repo.key /etc/ssl/nginx/
    ```

1. Install the prerequisites:

    ```shell
    sudo dnf install yum-utils procps-ng ca-certificates
    ```

1. To set up the dnf repository for Amazon Linux 2023, create the file named `/etc/yum.repos.d/nginx-agent.repo` with the following contents:

    ```
    [nginx-agent]
    name=nginx-agent repo
    baseurl=https://packages.nginx.org/nginx-agent/amzn/2023/$basearch/
    sslclientcert=/etc/ssl/nginx/nginx-repo.crt
    sslclientkey=/etc/ssl/nginx/nginx-repo.key
    gpgcheck=0
    enabled=1
    ```

1. To install `nginx-agent` with a specific version (for example, 2.42.0):

    ```shell
    sudo dnf install -y nginx-agent-2.42.0
    ```

1. When prompted to accept the GPG key, verify that the fingerprint matches `8540 A6F1 8833 A80E 9C16 53A4 2FD2 1310 B49F 6B46`, `573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`, `9E9B E90E ACBC DE69 FE9B 204C BCDC D8A3 8D88 A2B3`, and if so, accept it.

1. Verify the installation:

    ```shell
    sudo nginx-agent -v
    ```

{{< /details >}}

### Installing NGINX Agent on Amazon Linux 2

{{< details summary="Expand instructions" >}}

{{< include "agent/installation/plus/plus-amazon-linux.md" >}}

{{< /details >}}

### Installing NGINX Agent on FreeBSD

{{< details summary="Expand instructions" >}}

1. Create the `/etc/ssl/nginx` directory:

    ```shell
    sudo mkdir -p /etc/ssl/nginx
    ```

1. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5/) and download your `nginx-repo.crt` and `nginx-repo.key` files.

1. Copy the files to the `/etc/ssl/nginx/` directory:

    ```shell
    sudo cp nginx-repo.crt nginx-repo.key /etc/ssl/nginx/
    ```

1. Install the prerequisite `ca_root_nss` package:

    ```shell
    sudo pkg install ca_root_nss
    ```

1. To setup the pkg repository create the file named `/etc/pkg/nginx-agent.conf` with the following content:

    ```
    nginx-agent: {
    URL: pkg+https://pkgs.nginx.com/nginx-agent/freebsd/${ABI}/latest
    ENABLED: yes
    MIRROR_TYPE: SRV
    }
    ```

1. Add the following lines to the `/usr/local/etc/pkg.conf` file:

    ```
    PKG_ENV: { SSL_NO_VERIFY_PEER: "1",
    SSL_CLIENT_CERT_FILE: "/etc/ssl/nginx/nginx-repo.crt",
    SSL_CLIENT_KEY_FILE: "/etc/ssl/nginx/nginx-repo.key" }
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
