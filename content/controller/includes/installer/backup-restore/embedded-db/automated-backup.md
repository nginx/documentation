NGINX Controller automatically takes a snapshot of the embedded config database every 60 minutes and saves the backups on the config DB volume. The backup file location varies depending on the volume chosen at setup:

- **Local**: The backup files are located in `/opt/nginx-controller/postgres_data/` with the following naming scheme: `backup_<timestamp>.tar`.

- **NFS**: The backup files are located in the path on the NFS server host that was specified during installation and have the following naming scheme: `backup_<timestamp>.tar`.

These automated config backups do not include backups of metrics data, which must be backed up separately; refer to [Backup & Restore the Metrics Database]({{< relref "admin-guides/backup-restore/backup-restore-metrics-db.md" >}}) for those instructions.

{{< tip >}}
As a best practice, we recommend that you make scheduled backups of the entire config DB volume and keep the backups off-site for safekeeping.
{{< /tip >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-262 -->