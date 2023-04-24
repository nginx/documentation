Take the following steps to back up the external NGINX Controller config database:

1. Stop NGINX Controller:

    ``` bash
    /opt/nginx-controller/helper.sh controller stop
    ```

1. Run the following script to back up the NGINX Controller database. The backup files are saved in a directory that looks like `pgbackup_<timestamp>`.

    ``` bash
    DATE=$(date +"%Y%m%d%H%M")
    mkdir ~/pgbackup_${DATE}

    for db in common data system vault; do
      pg_dump -w -E utf8 ${db} -F c -f ~/pgbackup_${DATE}/${db}-${DATE}.backup
    done
    ```

1. Start NGINX Controller:

    ``` bash
    /opt/nginx-controller/helper.sh controller start
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-265 -->