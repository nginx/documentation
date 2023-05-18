Use the `helper.sh` script to change the external config database address; port; and optionally, the username, password, and certificate authentication. However, if your current installation uses an internal config database, then these settings are read-only and cannot be modified using the `helper.sh` script (password and certificates will be automatically rotated with each Controller update).

``` bash
/opt/nginx-controller/helper.sh configdb <address> <port> [username] [password] [ssl] [ca] [cert] [key]
```

For example:

``` bash
/opt/nginx-controller/helper.sh configdb 192.0.2.1 5432 user1 password1 false
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `address`  | The host name or IP address of config database. |
| `port`     | The port of the database. |
| `username` | The username to use for access to the config database. |
| `password` | The password to use for access to the config database. |
| `ssl` | `true` or `false`. Set to 'true' to require SSL for connections to the config database. |
| `ca` | CA certificate file path. |
| `cert` | Certificate file path. |
| `key` | Key file path. |

&nbsp;

### Environment Variables

We strongly recommend that you use environment variables, especially for passwords, to prevent exposing sensitive information in system processes (for example, `ps`, `top`) and the bash history.

You can use these database environment variables with NGINX Controller:

| Environment Variables  | Description |
|----------|-------------|
| `CTR_DB_HOST` | The host name or IP address of the config database. |
| `CTR_DB_PORT` | The port of the config database used for incoming connections. |
| `CTR_DB_USER` | The username for the account to use for access to the config database; must be provided with password. |
| `CTR_DB_PASS` | The password for the account to use for access to the config database; must be provided with username. |
| `CTR_DB_ENABLE_SSL` | `true` or `false`; Set to `true` to require SSL for connections to the config database. |
| `CTR_DB_CA` | CA certificate file path. |
| `CTR_DB_CLIENT_CERT` | Certificate file path. |
| `CTR_DB_CLIENT_KEY` | Key file path. |

For example:

``` bash
CTR_DB_HOST=192.0.2.1 \
CTR_DB_PORT=5432 \
CTR_DB_USER=user1 \
CTR_DB_PASS=password1 \
CTR_DB_ENABLE_SSL=false \
/opt/nginx-controller/helper.sh configdb
```
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-281 -->
