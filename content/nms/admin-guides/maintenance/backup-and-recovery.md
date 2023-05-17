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
- (optional) An installed version of App Delivery Manager
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

- The NGINX Management Suite services are running:

    ```bash
    sudo systemctl start nms
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

    ```bash
    sudo ./backup.sh
    ```

4. To restore from a backup:

    - Run `sudo rm -rf /var/lib/nms/dqlite/*` to remove the existing database files.
  
    - Make sure the NGINX Management Suite service is stopped
    
    ```bash
    sudo systemctl stop nms
    ```

    - Run the restore script:

    ```bash
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```

---

## Back Up and Restore NGINX Management Suite and modules deployed in a Kubernetes Cluster

### Back up App Delivery Manager deployed in a Kubernetes Cluster

To back up App Delivery Manager deployed in a Kubernetes cluster, follow these steps:

1. Download the latest NGINX Management Suite Helm chart:

    ```bash
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update
    helm pull nginx-stable/nms
    tar zxvf nms-<version>.tgz
    cd nms-<version>
    ```

2. Copy the extracted `k8s-backup.sh` and `k8s-backup-adm.sh` scripts from the `nms/charts/nms-adm/backup-restore/`directory to your working directory:
    
    ```bash
    cp nms/charts/nms-adm/backup-restore/k8s-backup.sh .
    cp nms/charts/nms-adm/backup-restore/k8s-backup-adm.sh .
    ```

3. Make the scripts executable:
    
    ```bash
    chmod +x k8s-backup.sh
    chmod +x k8s-backup-adm.sh
    ```

4. Uncomment the App Delivery Manager section in the `k8s-backup.sh` script as follows:

    ```bash
    ##  Back up App Delivery Manager
    # Uncomment the following lines to back up App Delivery Manager.
    export PACKAGE_DIR NMS_HELM_NAMESPACE
    ./k8s-backup-adm.sh
    ```

5. Run the backup script:

    ```bash
    ./k8s-backup.sh
    ```
    {{< note >}}The backup script does not need the utility pod or sudo premissions to create a backup.{{< /note >}}

6. The command will ask for the NGINX Management Suite namespace. The script will create a backup-archive in the same directory called `k8s-backup-<timestamp>.tar.gz`.

### Full Restoration: Same Kubernetes Cluster

To restore App Delivery Manager in the same Kubernetes cluster, follow these steps:

1. Download the latest NGINX Management Suite Helm chart:

    ```bash
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update
    helm pull nginx-stable/nms
    tar zxvf nms-<version>.tgz
    ```

2. Copy the extracted `k8s-restore.sh` script from the `nms-<version>/nms/charts/nms-adm/backup-restore/`directory to your working directory:
    
    ```bash
    cp nms-<version>/nms/charts/nms-adm/backup-restore/k8s-restore.sh .
    ```

3. Make the script executable:
    
    ```bash
    chmod +x k8s-restore.sh
    ```

4. Copy your k8s-backup-<timestamp>.tar.gz file to the same directory as the k8s-restore.sh script.

5. Run the restore script:

    ```bash
    sudo ./k8s-restore.sh k8s-backup-<timestamp>.tar.gz
    ```
    {{< note >}}The restore script needs root access to kubernetes for the restore operation.{{< /note >}}

6. The script will ask for the NGINX Management Suite namespace after a 5 second delay. Once the namespace has been provided, the script will consume the specified backup-archive. 

    {{< note >}}The script will use the utility pod to access all the mounted volumes to restore database directories and core-secrets; and kubectl to restore the k8s configmaps and secrets. Before starting the restoration, the script will stop all service pods and start the utility pod. After finishing the restore, it will stop the utility pod and start all service pods.{{< /note >}}


### Data-only Restoration:  Restoration to a Different Cluster

1. Download the latest NGINX Management Suite Helm chart:

    ```bash
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update
    helm pull nginx-stable/nms
    tar zxvf nms-<version>.tgz
    ```

2. Copy the extracted `k8s-restore.sh` script from the `nms-<version>/nms/charts/nms-adm/backup-restore/`directory to your working directory:
    
    ```bash
    cp nms-<version>/nms/charts/nms-adm/backup-restore/k8s-restore.sh .
    ```

3. Make the script executable:
    
    ```bash
    chmod +x k8s-restore.sh
    ```

4. Copy your k8s-backup-<timestamp>.tar.gz file to the same directory as the k8s-restore.sh script.

5. Run the restore script:

    ```bash
    sudo ./k8s-restore.sh -r -i k8s-backup-<timestamp>.tar.gz -d
    ```
    {{< note >}}The restore script needs root access to kubernetes for the restore operation.{{< /note >}}

6. The script will ask for the NGINX Management Suite namespace after a 5 second delay. Once the namespace has been provided, the script will consume the specified backup-archive. 

The restore script will only restore the databases and core secrets. If you want to restore the user passwords too, run the following commands:

  ```bash
  cd nms-<version>/secrets   
  kubectl -n nms apply -f nms-auth.json   
  kubectl -n nms delete pod apigw-<hash> 
  ```

---


## ClickHouse

ClickHouse supports backup and restore on versions greater than v22.

For instructions on how to back up and restore the ClickHouse database, please refer to [ClickHouse's documentation](https://clickhouse.com/docs/en/operations/backup).

To check your ClickHouse version, run the following command:

``` bash
clickhouse-server --version
```
