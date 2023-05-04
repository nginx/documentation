---
title: "Uninstall Guide"
description: "This guide explains how to uninstall NGINX Management Suite, including Instance Manager and API Connectivity Manager."
date: 2021-12-21T12:00:00-07:00
draft: false 
weight: 1000 
doctypes: task
toc: true
docs: "DOCS-804"
aliases:
- /nginx-instance-manager/getting-started/installation/uninstall-guide/
- /nginx-instance-manager/installation/uninstall-guide/
---


{{< custom-styles >}}

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

---

## App Delivery Manager {#uninstall-app-delivery-manager}

{{<tabs name="uninstall_app_delivery_manager">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. To uninstall App Delivery Manager, run the following command:

   ```bash
   yum remove nms-adm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. To uninstall App Delivery Manager, run the following command:

   ```bash
   sudo apt-get remove nms-adm
   ```

   > **Note:** The `apt-get remove <package>` command will remove the package from your system, while keeping the associated configuration files for possible future use. If you want to completely remove the package and all of its configuration files, you should use `apt-get purge <package>`.

{{%/tab%}}
{{</tabs>}}

---

## Security Monitoring {#uninstall-security-monitoring}

{{<tabs name="uninstall_security_monitoring">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. To uninstall the Security Monitoring module, run the following command:

   ```bash
   yum remove nms-sm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}


1. To uninstall the Security Monitoring module, run the following command:

   ```bash
   sudo apt-get remove nms-sm
   ```

   > **Note:** The `apt-get remove <package>` command will remove the package from your system, while keeping the associated configuration files for possible future use. If you want to completely remove the package and all of its configuration files, you should use `apt-get purge <package>`.

{{%/tab%}}
{{</tabs>}}

---

## NGINX Agent

{{<tabs name="uninstall_agent">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

Complete the following steps on each host where you've installed the NGINX Agent:

1. Stop the NGINX Agent:

   ```bash
   sudo systemctl stop nginx-agent
   ```

2. To uninstall the NGINX Agent, run the following command:

   ```bash
   yum remove nginx-agent
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

Complete the following steps on each host where you've installed the NGINX Agent:

1. Stop the NGINX Agent:

   ```bash
   sudo systemctl stop nginx-agent
   ```

2. To uninstall the NGINX Agent, run the following command:

   ```bash
   sudo apt-get remove nginx-agent
   ```

   > **Note:** The `apt-get remove <package>` command will remove the package from your system, while keeping the associated configuration files for possible future use. If you want to completely remove the package and all of its configuration files, you should use `apt-get purge <package>`.

{{%/tab%}}
{{</tabs>}}

