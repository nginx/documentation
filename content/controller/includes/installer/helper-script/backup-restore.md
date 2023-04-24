This section explains how to restore the embedded config database from the latest backup file or a specific, timestamped file.

{{< important >}}If you restore the config database on top of a new installation of NGINX Controller, make sure to follow the steps to [restore your NGINX config and encryption keys]({{< relref "admin-guides/backup-restore/backup-restore-cluster-config.md" >}}) afterward. {{< /important >}}

- To restore the embedded NGINX Controller config database **from the latest automated backup**, run the following command:

  ```bash
  /opt/nginx-controller/helper.sh backup restore
  ```

- To restore the embedded config database from **a specific backup file**:

  ```bash
  /opt/nginx-controller/helper.sh backup restore <filename>
  ```

  - If you installed the embedded config database on a **local volume**, the backup files are located in `/opt/nginx-controller/postgres_data/`.

  - If you installed the embedded config database on an **NFS volume**, follow the steps in [(NFS) Copy Config Database Backup to Local Volume for Restoration]({{< relref "admin-guides/backup-restore/backup-restore-embedded-config-db.md#nfs-copy-config-database-backup-to-local-volume-for-restoration" >}}) to download the backup file to your local volume, and then use the `helper.sh` script to restore from it.

&nbsp;
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-270 -->
