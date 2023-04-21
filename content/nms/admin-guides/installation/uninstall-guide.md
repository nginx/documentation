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


<style>
  h2 {
    margin-top: 30px;
    margin-bottom: 10px;
    }
  h3 {
    margin-top: 20px;
    margin-bottom: 10px;
    }
  hr {
    margin-top: 40px; 
    margin-bottom: 40px;
    }
</style>

## Uninstall NGINX Management Suite {#uninstall-nms}

{{<tabs name="uninstall_nms">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

To remove NGINX Management Suite and all of its modules, complete the following steps in the given order:

1. Remove NGINX Management Suite:

   ```bash
   yum remove nms-*
   ```

2. Stop the ClickHouse process:

   ```bash
   sudo systemctl stop clickhouse-server
   ```

3. Uninstall ClickHouse:

   ```bash
   yum remove clickhouse-server
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

To remove the NGINX Management suite and modules altogether, complete the following steps in the given order:

1. Remove NGINX Management Suite:

   ```bash
   sudo apt-get remove nms-*
   ```

2. Stop the ClickHouse process:

   ```bash
   sudo systemctl stop clickhouse-server
   ```

3. Uninstall ClickHouse:

   ```bash
   sudo apt-get remove clickhouse-server
   ```

{{%/tab%}}
{{</tabs>}}

---

## Uninstall API Connectivity Manager {#uninstall-acm}

{{<tabs name="uninstall_acm">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. To uninstall the API Connectivity Manager module, run the following command:

   ```bash
   yum remove nms-api-connectivity-manager*
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. To uninstall the API Connectivity Manager module, run the following command:

   ```bash
   sudo apt-get remove nms-api-connectivity-manager*
   ```

{{%/tab%}}
{{</tabs>}}

---

## Uninstall Developer Portal

{{<tabs name="uninstall_acm_dev_portal">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. To uninstall the Developer Portal, run the following command:

   ```bash
   yum remove nginx-devportal*
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. To uninstall the Developer Portal, run the following command:

   ```bash
   sudo apt-get remove nginx-devportal*
   ```

{{%/tab%}}
{{</tabs>}}

---

## Uninstall Security Monitoring {#uninstall-security-monitoring}

{{<tabs name="uninstall_security_monitoring">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

1. To uninstall the Security Monitoring module, run the following command:

   ```bash
   yum remove nms-sm
   ```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

1. To uninstall the Developer Portal, run the following command:

   ```bash
   sudo apt-get remove nms-sm
   ```

{{%/tab%}}
{{</tabs>}}

---

## Uninstall NGINX Agent

{{<tabs name="uninstall_agent">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

Complete the following steps on each host where you've installed the NGINX Agent:

1. Stop the NGINX Agent:

   ```bash
   sudo systemctl stop nginx-agent
   ```

2. Uninstall the NGINX Agent:

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

2. Uninstall the NGINX Agent:

   ```bash
   sudo apt-get remove nginx-agent
   ```

{{%/tab%}}
{{</tabs>}}
