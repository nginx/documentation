---
description: Learn how to back up and restore the embedded F5 NGINX Controller config
  database.
docs: DOCS-248
title: Back Up & Restore an Embedded Config Database
toc: true
weight: 98
type:
- tutorial
---

## Overview

Follow the steps in this guide to back up and restore an internal F5 NGINX Controller config database. Use this guide if you selected the option to use an embedded config database when you installed NGINX Controller. Embedded config means that NGINX Controller is using an internal database to store configuration data.

## Automated Backups of Embedded Config Database

NGINX Controller automatically takes a snapshot of the embedded config database every 60 minutes and saves the backups on the config DB volume. The backup file location varies depending on the volume chosen at setup:

- **Local**: The backup files are located in `/opt/nginx-controller/postgres_data/` with the following naming scheme: `backup_<timestamp>.tar`.

- **NFS**: The backup files are located in the path on the NFS server host that was specified during installation and have the following naming scheme: `backup_<timestamp>.tar`.

These automated config backups do not include backups of metrics data, which must be backed up separately; refer to [Backup & Restore the Metrics Database]({{< relref "/controller/admin-guides/backup-restore/backup-restore-metrics-db.md" >}}) for those instructions.

{{< tip >}}
As a best practice, we recommend that you make scheduled backups of the entire config DB volume and keep the backups off-site for safekeeping.
{{< /tip >}}

&nbsp;

---

## Restore Embedded Config Database

This section explains how to restore the embedded config database from the latest backup file or a specific, timestamped file.

{{< important >}}If you restore the config database on top of a new installation of NGINX Controller, make sure to follow the steps to [restore your NGINX config and encryption keys]({{< relref "/controller/admin-guides/backup-restore/backup-restore-cluster-config.md" >}}) afterward. {{< /important >}}

- To restore the embedded NGINX Controller config database **from the latest automated backup**, run the following command:

  ```bash
  /opt/nginx-controller/helper.sh backup restore
  ```

- To restore the embedded config database from **a specific backup file**:

  ```bash
  /opt/nginx-controller/helper.sh backup restore <filename>
  ```

  - If you installed the embedded config database on a **local volume**, the backup files are located in `/opt/nginx-controller/postgres_data/`.

  - If you installed the embedded config database on an **NFS volume**, follow the steps in [(NFS) Copy Config Database Backup to Local Volume for Restoration]({{< relref "/controller/admin-guides/backup-restore/backup-restore-embedded-config-db.md#nfs-copy-config-database-backup-to-local-volume-for-restoration" >}}) to download the backup file to your local volume, and then use the `helper.sh` script to restore from it.

&nbsp;

### (NFS) Copy Config Database Backup to Local Volume for Restoration



To restore the embedded config database from a specific backup file, the file needs to be on your local volume.

Take the following steps to copy an embedded config database backup file from an NFS volume to your local volume for restoration:

1. Log on to the node where PostgreSQL is installed as a user with sudo privileges.

1. Change to the `/opt/nginx-controller` directory:

    ``` bash
    cd /opt/nginx-controller
    ```

1. Create a local backup directory to copy the backup file to:

    ``` bash
    mkdir local_backups
    ```

1. Get the NFS volume details:

    ``` bash
    mount | grep nfs
    ```

    The output looks similar to the following:

    ``` bash
    <nfs_host>:<path_on_host> on <local path> type nfs4 (mount options...)
    ```

    For example:

    ``` bash
    192.0.2.1:/mnt/nfs_share/nfs_postgresql on /var/lib/kubelet/pods/1ce4e221-d6d6-434f-9e73-bc81c879530e/volumes/kubernetes.io~nfs/controller-postgres type nfs4 (mount options ...)
    ```

1. Record the `<nfs_host>:<path_on_host>` details corresponding to the `nfs_postgresql` volume, namely the volume mounted on the Kubernetes `controller-postgres` container.

    For example:

    ``` bash
    192.0.2.1:/mnt/nfs_share/nfs_postgresql
    ```

1. Create a parent directory to mount the NFS path to:

    ``` bash
    sudo mkdir -p /mnt/local_pgdata
    ```

1. Mount the NFS path:

    ``` bash
    sudo mount <nfs_host>:<path_on_host> /mnt/local_pgdata
    ```

    For example:

    ``` bash
    sudo mount 192.0.2.1:/mnt/nfs_share/nfs_postgresql /mnt/local_pgdata
    ```

1. View the list of the available backup files. The files have the following naming scheme: `backup_<timestamp>.tar`.

    ```bash
    ls /mnt/local_pgdata/
    ```

1. Copy the backup file from which you want to restore to the `local_backups/` directory:

    ``` bash
    sudo cp /mnt/local_pgdata/backup_<timestamp>.tar local_backups/
    ```

1. Use the NGINX Controller `helper.sh` script to restore the backup file:

    ``` bash
    /opt/nginx-controller/helper.sh backup restore local_backups/backup_<timestamp>.tar
    ```

1. After the backup has been restored, you can unmount the NFS path and delete the backup file in the `local_backups` directory:

    ``` bash
    sudo umount /mnt/local_pgdata
    rm -i local_backups/backup_<timestamp>.tar
    ```




&nbsp;

---

## What's Next

- [Backup & Restore the Metrics Database]({{< relref "/controller/admin-guides/backup-restore/backup-restore-metrics-db.md" >}})

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
