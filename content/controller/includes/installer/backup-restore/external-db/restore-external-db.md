To restore the external NGINX Controller config database:

1. Stop NGINX Controller:

    ``` bash
    /opt/nginx-controller/helper.sh controller stop
    ```

1. Locate the backup directory and save the name as a local environment variable. The name of the backup directory follows the format `pgbackup_<timestamp>`.

    ``` bash
    BACKUP_PATH=~/pgbackup_<timestamp>
    ```

1. Run the restore script:

    ``` bash
    for backup_file in "$BACKUP_PATH"/*.backup; do
      db="$(basename "$backup_file" | cut -d '-' -f 1)"
      pg_restore -c -C -d "$db" "$backup_file"
    done
    ```

1. Start NGINX Controller:

    ``` bash
    /opt/nginx-controller/helper.sh controller start
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-267 -->