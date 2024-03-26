---
description: This guide explains how to uninstall NGINX Management Suite, including
  Instance Manager and API Connectivity Manager.
docs: DOCS-804
doctypes: task
title: Uninstall Guide
toc: true
weight: 1000
---

## NGINX Management Suite {#uninstall-nms}

{{<tabs name="uninstall_nms">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

To uninstall NGINX Management Suite and all of its modules, complete the following steps:

1. To uninstall NGINX Management Suite, run the following command:

   ```bash
   yum remove nms-*
   ```

2. Stop the ClickHouse service:

   ```bash
   sudo systemctl stop clickhouse-server
   ```

3. To uninstall ClickHouse, run the following command:

   ```bash
   yum remove clickhouse-server
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

To uninstall NGINX Management suite and all of its modules, complete the following steps:

1. To uninstall NGINX Management Suite, run the following command:

   ```bash
   sudo apt-get remove nms-*
   ```

2. Stop the ClickHouse service:

   ```bash
   sudo systemctl stop clickhouse-server
   ```

3. To uninstall ClickHouse, run the following command:

   ```bash
   sudo apt-get remove clickhouse-server
   ```

   > **Note:** The `apt-get remove <package>` command will remove the package from your system, while keeping the associated configuration files for possible future use. If you want to completely remove the package and all of its configuration files, you should use `apt-get purge <package>`.


{{%/tab%}}
{{</tabs>}}

---

## API Connectivity Manager {#uninstall-acm}

{{< include "nms/EOS/acm-eos.md" >}}

{{<tabs name="uninstall_acm">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. To uninstall API Connectivity Manager, run the following command:

   ```bash
   yum remove nms-api-connectivity-manager
   ```

2. To uninstall the Developer Portal, run the following command:

   ```bash
   yum remove nginx-devportal
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. To uninstall API Connectivity Manager, run the following command:

   ```bash
   sudo apt-get remove nms-api-connectivity-manager
   ```

2. To uninstall the Developer Portal, run the following command:

   ```bash
   sudo apt-get remove nginx-devportal
   ```

   > **Note:** The `apt-get remove <package>` command will remove the package from your system, while keeping the associated configuration files for possible future use. If you want to completely remove the package and all of its configuration files, you should use `apt-get purge <package>`.

{{%/tab%}}
{{</tabs>}}
