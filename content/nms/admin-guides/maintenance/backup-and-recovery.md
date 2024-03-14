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
weight: 1
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1098"

---

## Overview

- NGINX Management Suite includes several scripts, which you can run to back up and restore the configuration files, secrets, and databases used by the NGINX Management Suite platform.

- Additionally, to back up and restore data for specific modules, such as API Connectivity Manager, you can edit the provided scripts and uncomment the commands in the relevant sections.

{{<important>}}The backup and recovery scripts are provided for reference and may need to be adapted to suit the requirements of your deployment.{{</important>}}

---

## NGINX Management Suite and modules deployed in a Virtual Machine or Bare Metal

### Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of Instance Manager
- (optional) An installed version of API Connectivity Manager
- An installed version of SQLite. Refer to the [Install SQLite]({{< relref "/nms/admin-guides/maintenance/sqlite-installation.md" >}}) guide for installation instructions.
- The NGINX Management Suite services must be running:

    ```shell
    sudo systemctl start nms
    ```

### Make Scripts Executable

To run the backup and restore scripts, you need to set their permissions to make them executable.

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. Change to the directory where the scripts are located:

    ```shell
    cd /etc/nms/scripts
    ```

3. Run the following commands to make the scripts executable:

    ```shell
    sudo chmod +x backup.sh
    sudo chmod +x restore.sh
    sudo chmod +x backup-acm.sh
    sudo chmod +x restore-acm.sh
    sudo chmod +x backup-adm.sh
    sudo chmod +x restore-adm.sh
    sudo chmod +x support-package.sh
    ```

---

### Back Up and Restore NGINX Management Suite

To back up the NGINX Management Suite configuration files, secrets, and databases:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. To back up NGINX Management Suite, run the following commands:

    ```shell
    cd /etc/nms/scripts
    sudo ./backup.sh
    ```

    The backup is saved to a tarball file similar to the following example: `/tmp/nms-backup-<DATETIME>.tgz`

To restore NGINX Management Suite:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
2. To restore NGINX Management Suite, run the following commands:

    ```shell
    cd /etc/nms/scripts
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```

---

## NGINX Management Suite and modules deployed in a Kubernetes Cluster

### Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of NGINX Management Suite and Instance Manager
- (optional) An installed version of API Connectivity Manager
- An installed version of SQLite. Refer to the [Install SQLite]({{< relref "/nms/admin-guides/maintenance/sqlite-installation.md" >}}) guide for installation instructions.


<a name="root-access"></a>

- Root Access

    The Kubernetes backup and restore scripts for NGINX Management Suite are executed using `sudo` and use the Kubernetes command `kubectl` internally to access the Kubernetes API. It is necessary to ensure the target Kubernetes cluster is accessible to the root user.

    To confirm that the root user has access to the Kubernetes API, execute the following command:

    ```shell
    sudo kubectl -n nms get pods
    ```

    If the result is error-free and the output is the list of currently running pods/nodes the root user has the required access.

    If the root user does not have the required access, you will need to configure the root user to have Kubernetes API access, or provide the script with the location of the Kubernetes configuration via the environment variable `KUBECONFIG`. For example:

  - To back up NGINX Management Suite:

        ```shell
        sudo KUBECONFIG=/etc/kubernetes/admin.conf ./k8s-backup.sh
        ```

  - To restore NGINX Management Suite:

        ```shell
        sudo KUBECONFIG=/etc/kubernetes/admin.conf ./k8s-restore.sh -i <path to backup file> -r
        ```

    In the examples above, `/etc/kubernetes/admin.conf` is the default configuration location of a Kubernetes cluster. If the configuration location is different for the target Kubernetes cluster, update the commands above accordingly.

- Utility pod

    {{< beta-badge >}}

    To back up and restore NGINX Management Suite in a Kubernetes cluster, you need to install the `utility` pod in your Kubernetes cluster. Optionally, for each module you want to back up and restore, you need to configure the `utility` pod accordingly:

    1. Update your [Helm Deployment values.yaml file]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md#configure-chart" >}}), add the `utility: true` line to enable the utility pod, and the required sections under `nmsModules` to enable the modules you want to back up and restore. For example, if you have API Connectivity Manager installed, add the following:

        ```yaml
        global:
            utility: true
            nmsModules :
                nsm—acm:
                    enabled: true
                    addClaimsToUtility: true
        ```

    2. [Upgrade your NGINX Management Suite deployment]({{< relref "/nms/installation/kubernetes/deploy-instance-manager#helm-upgrade-nim" >}}) to apply the changes.

    3. Download the NGINX Management Suite Helm chart for your currently installed version of NGINX Management Suite:

        ```shell
        helm repo add nginx-stable https://helm.nginx.com/stable
        helm repo update
        helm pull nginx-stable/nms
        tar zxvf nms-<version>.tgz
        ```

### Back Up

To back up NGINX Management Suite deployed in a Kubernetes cluster, follow these steps:

1. Copy the extracted backup scripts to your working directory:
    - For NGINX Management Suite and API Connectivity Manager, copy`k8s-backup.sh` from the `nms-<version>/charts/nms-hybrid/backup-restore/` directory.

    ```shell
    cp nms-<version>/charts/nms-hybrid/backup-restore/k8s-backup.sh .
    cp nms-<version>/charts/nms-adm/backup-restore/k8s-backup-adm.sh .
    ```

1. Make the scripts executable:

    ```shell
    chmod +x k8s-backup.sh
    chmod +x k8s-backup-adm.sh
    ```

1. Run the backup script:

    ```shell
    ./k8s-backup.sh
    ```

    {{< note >}}The backup script does not need the utility pod or sudo permissions to create a backup.{{< /note >}}

5. The command will ask for the NGINX Management Suite namespace. The script will create a backup archive in the same directory called `k8s-backup-<timestamp>.tar.gz`.

### Full Restoration: Same Kubernetes Cluster

To restore NGINX Management Suite and the installed modules deployed in the same Kubernetes cluster, follow these steps:

1. Copy the extracted backup scripts to your working directory:

    - For NGINX Management Suite and API Connectivity Manager, copy`k8s-restore.sh` from the `nms-<version>/charts/nms-hybrid/backup-restore/` directory.

    ```shell
    cp nms-<version>/nms/charts/nms-hybrid/backup-restore/k8s-restore.sh .
    ```

2. Make the scripts executable:

    ```shell
    chmod +x k8s-restore.sh
    ```

3. Copy your k8s-backup-<timestamp>.tar.gz file to the same directory as the k8s-restore.sh script.

4. Run the restore script:

    ```shell
    sudo ./k8s-restore.sh -r -i k8s-backup-<timestamp>.tar.gz
    ```

    {{< note >}}The restore script [needs root access]({{< relref "/nms/admin-guides/maintenance/backup-and-recovery.md#root-access" >}}) to Kubernetes for the restore operation.{{< /note >}}

5. The script will ask for the NGINX Management Suite namespace. Once the namespace has been provided, the script will consume the specified backup archive.

    {{< note >}}The script will use the utility pod to access all the mounted volumes to restore database directories and core-secrets; and kubectl to restore the k8s configmaps and secrets. Before starting the restoration, the script will stop all service pods and start the utility pod. After finishing the restore, it will stop the utility pod and start all service pods.{{< /note >}}


### Data-only Restoration: Restoration to a Different Cluster

To restore NGINX Management Suite and the installed modules into a different Kubernetes cluster, follow these steps:

1. Copy the extracted backup scripts to your working directory:

    - For NGINX Management Suite and API Connectivity Manager, copy`k8s-restore.sh` from the `nms-<version>/charts/nms-hybrid/backup-restore/` directory.

    ```shell
    cp nms-<version>/nms/charts/nms-hybrid/backup-restore/k8s-restore.sh .
    ```

2. Make the scripts executable:

    ```shell
    chmod +x k8s-restore.sh
    chmod +x k8s-restore-adm.sh
    ```

3. Copy your k8s-backup-<timestamp>.tar.gz file to the same directory as the k8s-restore.sh script.

4. Run the restore script:

    ```shell
    sudo ./k8s-restore.sh -r -i k8s-backup-<timestamp>.tar.gz -d
    ```

    {{< note >}}The restore script [needs root access]({{< relref "/nms/admin-guides/maintenance/backup-and-recovery.md#root-access" >}}) to Kubernetes for the restore operation.{{< /note >}}

5. The script will ask for the NGINX Management Suite namespace. Once the namespace has been provided, the script will consume the specified backup archive.

The restore script will only restore the databases and core secrets. If you want to restore the user passwords too, run the following commands:

  ```shell
  cd nms-<version>/secrets
  kubectl -n nms apply -f nms-auth.json
  kubectl -n nms delete pod apigw-<hash>
  ```

---

## ClickHouse

ClickHouse supports backup and restore on versions greater than v22.

For instructions on how to back up and restore the ClickHouse database, please refer to [ClickHouse's documentation](https://clickhouse.com/docs/en/operations/backup).

To check your ClickHouse version, run the following command:

```shell
clickhouse-server --version
```
