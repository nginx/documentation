Use the `helper.sh` script to update or replace the TLS certificates that are used to connect to NGINX Controller.

``` bash
/opt/nginx-controller/helper.sh configtls <cert_file> <key_file>
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
| `cert_file` | Certificate file path. |
| `key_file` | Key file path. |
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-272 -->
