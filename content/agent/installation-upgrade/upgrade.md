---
title: Upgrade NGINX Agent package
weight: 600
toc: true
nd-docs: DOCS-1227
nd-content-type: how-to
nd-product: NAGENT
---

## Overview

Learn how to upgrade NGINX Agent.

## Upgrade NGINX Agent

{{< include "agent/installation/update.md" >}}

## Upgrade NGINX Agent to a Specific Version

To upgrade NGINX Agent to a specific **v2.x version**, follow these steps:

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

        Example (to upgrade to version 2.42.0~noble):

        ```shell
        sudo apt-get install -y nginx-agent=2.42.0~noble -o Dpkg::Options::="--force-confold"
        ```

    - CentOS, RHEL, RPM-Based

        ```shell
        sudo yum install -y nginx-agent-<specific-version>
        ```

        Example (to upgrade to version `2.42.0`):

        ```shell
        sudo yum install -y nginx-agent-2.42.0
        ```

1. Verify the installed version:

    ```shell
    sudo nginx-agent --version
    ```
