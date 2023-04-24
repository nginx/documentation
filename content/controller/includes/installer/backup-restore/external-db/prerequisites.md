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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-266 -->