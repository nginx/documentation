---
title: Upgrade NGINX Agent package
draft: false
weight: 600
toc: true
nd-docs: DOCS-1227
nd-content-type: how-to
---

## Overview

Learn how to upgrade NGINX Agent.

## Upgrade NGINX Agent

To upgrade NGINX Agent, follow these steps:

1. Open an SSH connection to the server where you’ve installed NGINX Agent and log in.

1. Make a backup copy of the following locations to ensure that you can successfully recover if the upgrade has issues:

    - `/etc/nginx-agent`
    - `config_dirs` values for any configuration specified in `/etc/nginx-agent/nginx-agent.conf`

1. Install the updated version of NGINX Agent:

    - CentOS, RHEL, RPM-Based

        ```shell
        sudo yum -y makecache
        sudo yum update -y nginx-agent
        ```

    - Debian, Ubuntu, Deb-Based

        ```shell
        sudo apt-get update
        sudo apt-get install -y --only-upgrade nginx-agent -o Dpkg::Options::="--force-confold"
        ```

## Upgrade NGINX Agent to a Specific Version

To upgrade NGINX Agent to a specific **v2.x version**, follow these steps:

#### Steps to Upgrade:

1. Open an SSH connection to the server running  NGINX Agent and log in.

1. Back up the following files and directories to ensure you can restore the environment in case of issues during the upgrade:

    - `/etc/nginx-agent`
    - Any `config_dirs` directory specified in `/etc/nginx-agent/nginx-agent.conf`.

1. Perform the version-controlled upgrade.

   - Debian, Ubuntu, Deb-Based

        ```shell
        sudo apt-get update
        sudo apt-get install -y nginx-agent=<specific-version> -o Dpkg::Options::="--force-confold"
        ```

        Example (to upgrade to version 2.41.1~noble):

        ```shell
        sudo apt-get install -y nginx-agent=2.41.1~noble -o Dpkg::Options::="--force-confold"
        ```

    - CentOS, RHEL, RPM-Based

        ```shell
        sudo yum install -y nginx-agent-<specific-version>
        ```

        Example (to upgrade to version `2.41.1`):

        ```shell
        sudo yum install -y nginx-agent-2.41.1
        ```

1. Verify the installed version:

    ```shell
    sudo nginx-agent --version
    ```
