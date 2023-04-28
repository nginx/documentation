---
title: "Back Up and Recovery"
date: 2022-12-13T13:17:52-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to back up and restore the essential system files for the NGINX Management Suite platform and modules."
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1098"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management"]
doctypes: ["task"]
journeys: ["using", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{< custom-styles >}}

## Overview

- NGINX Management Suite includes `backup.sh` and `restore.sh` scripts in `/etc/nms/scripts`, which you can run to back up and restore the configuration files, secrets, and databases used by the NGINX Management Suite platform.

- Additionally, to back up and restore data for specific modules, such as API Connectivity Manager, you can edit the `backup.sh` and `restore.sh` scripts and uncomment the commands in the relevant sections.

{{<important>}}The backup and recovery scripts are provided for reference and may need to be adapted to suit the requirements of your deployment.{{</important>}}

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of Instance Manager
- (optional) An installed version of API Connectivity Manager
- An installed version of SQLite.

    To install SQLite, run the following command(s):

    - CentOS, RHEL, RPM-Based distributions:

        ```bash
        sudo yum install -y sqlite
        ```

    - Debian, Ubuntu, Deb-Based distributions:

        ```bash
        sudo apt-get update
        sudo apt-get install -y sqlite3
        ```

### Make Scripts Executable

To run the backup and restore scripts, you need to set their permissions to make them executable.

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. Change to the directory where the scripts are located:

    ```bash
    cd /etc/nms/scripts
    ```

3. Run the following commands to make the scripts executable:

    ```bash
    sudo chmod +x backup.sh
    sudo chmod +x restore.sh
    sudo chmod +x backup-acm.sh
    sudo chmod +x restore-acm.sh
    sudo chmod +x backup-adm.sh
    sudo chmod +x restore-adm.sh
    ```

---

## Back Up and Restore NGINX Management Suite

To back up the NGINX Management Suite configuration files, secrets, and databases:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. To back up NGINX Management Suite, run the following commands:

    ```bash
    cd /etc/nms/scripts
    sudo ./backup.sh
    ```

    The backup is saved to a tarball file similar to the following example: `/tmp/nms-backup-<DATETIME>.tgz`

To restore NGINX Management Suite:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. To restore NGINX Management Suite, run the following commands:

    ```bash
    cd /etc/nms/scripts
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```

---

## Back Up and Restore Individual Modules

By default, the data for modules isn't included in backups for NGINX Management Suite. If you'd like to back up the module data, follow these steps:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. Edit the `backup.sh` and `restore.sh` scripts and uncomment the commands in the relevant sections.

    To back up and restore data for **API Connectivity Manager**, uncomment the following lines, like so:

    <details open>
    <summary>backup.sh: enable backups for API Connectivity Manager</summary>

    ```text
    ## Back up API Connectivity Manager
    # Uncomment the following line to back up API Connectivity Manager.
    ./backup-acm.sh
    ```

    </details>

    <details open>
    <summary>restore.sh: enable restore for API Connectivity Manager</summary>

    ```text
    ## Restore the API Connectivity Manager database.
    # Uncomment the following line to restore API Connectivity Manager.
    ./restore-acm.sh
    ```

    </details>



    To back up and restore data for **App Delivery Manager**, uncomment the following lines, like so:
    <details open>
    <summary>backup.sh: enable backups for App Delivery Manager</summary>

    ```text
    ## Back up App Delivery Manager
    # Uncomment the following line to back up App Delivery Manager.
    ./backup-adm.sh
    ```

    </details>

    <details open>
    <summary>restore.sh: enable restore for App Delivery Manager</summary>

    ```text
    ## Restore the App Delivery Manager database.
    # Uncomment the following line to restore App Delivery Manager.
    ./restore-adm.sh
    ```

    </details>


3. To create a backup, run the back up script:

{{< important >}} Before starting a backup, ensure SQLite is installed and NGINX Management Suite service is running. {{< /important >}}

    ```bash
    sudo ./backup.sh
    ```

4. To restore from a backup, run the restore script:

{{< important >}} Before starting a restore, run `sudo rm -rf /var/lib/nms/dqlite/*` and make sure the NGINX Management Suite service is stopped. {{< /important >}}


    ```bash
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```

---

## ClickHouse

ClickHouse supports backup and restore on versions greater than v22.

For instructions on how to back up and restore the ClickHouse database, please refer to [ClickHouse's documentation](https://clickhouse.com/docs/en/operations/backup).

To check your ClickHouse version, run the following command:

``` bash
clickhouse-server --version
```
