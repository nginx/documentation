---
description: Learn how to back up and restore the external F5 NGINX Controller config
  database.
docs: DOCS-249
title: Back Up & Restore an External Config Database
toc: true
weight: 99
type:
- tutorial
---

## Overview

Follow the steps in this guide to back up and restore an external F5 NGINX Controller config database. Use this guide if you selected the option to use an external PostgreSQL config database when you installed NGINX Controller. External config means that you set up NGINX Controller to store configuration data in your own Postgres database.

## Before You Begin

To backup and restore the external config database, you'll need the following:

- Login credentials for your NGINX Controller PostgreSQL database
- A connection to your NGINX Controller PostgreSQL database
- [psql](https://www.postgresql.org/docs/9.5/app-psql.html) and [pg_dump](https://www.postgresql.org/docs/9.5/app-pgdump.html) installed on the server where you'll be performing the backup or restore

### Set the PostgreSQL Environment Variables

1. Log in to the NGINX Controller host using SSH.
2. Set the following environment variables using the credentials for your NGINX Controller PostgreSQL database:

    ``` bash
    export PGHOST=<postgres host>
    export PGPORT=5432
    export PGUSER=<postgres user>
    export PGPASSWORD=<postgres password>
    ```

    {{< note >}}
If you've configured PostgreSQL to use SSL, ensure that you've placed your certs in `~/.postgresql`. For more information, see [Client Certificates](https://www.postgresql.org/docs/9.5/libpq-ssl.html#LIBPQ-SSL-CLIENTCERT) in the PostgreSQL documentation.
    {{< /note >}}

&nbsp;

---

## Back Up External Config Database

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


&nbsp;

---

## Restore External Config Database

{{< important >}}If you restore the config database on top of a new installation of NGINX Controller, make sure to follow the steps to [restore your NGINX config and encryption keys]({{< ref "/controller/admin-guides/backup-restore/backup-restore-cluster-config.md" >}}) afterward. {{< /important >}}

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


&nbsp;

---

## What's Next

- [Backup & Restore the Metrics Database]({{< ref "/controller/admin-guides/backup-restore/backup-restore-metrics-db.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
