---
title: Upgrade NGINX Agent v3 to a new version 
toc: true
weight: 400
nd-content-type: how-to
nd-docs: DOCS-1875
nd-product: NAGENT
---

## Overview

Follow the steps below to upgrade NGINX v3 Agent to the latest version.

1. Open an SSH connection to the server where you've installed NGINX Agent.

1. Make a backup copy of the following locations to ensure that you can recover if the upgrade does not complete
   successfully:

    - `/etc/nginx-agent`
    - Every configuration directory specfied in `/etc/nginx-agent/nginx-agent.conf` as a `config_dirs` value

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

