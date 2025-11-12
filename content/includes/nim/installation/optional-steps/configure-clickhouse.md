---
files:
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/deploy/vm-bare-metal/install-nim-manual.md
- content/nim/disconnected/offline-install-guide.md
- content/nim/disconnected/offline-install-guide-manual.md
---

If you installed ClickHouse and set a password (the default is an empty string), you must add it to the `clickhouse.password` setting in the `/etc/nms/nms.conf` file after installing NGINX Instance Manager. If the password is missing or incorrect, NGINX Instance Manager will not start.

You can also configure additional ClickHouse settings in the same section:

- `clickhouse.username` – the username used to connect to ClickHouse
- `clickhouse.address` – the address of the ClickHouse server (default is `tcp://localhost:9000`)
- `clickhouse.tls_mode` – set to `true` to enable TLS
- TLS certificate settings, such as:
  - `clickhouse.tls.cert_path`
  - `clickhouse.tls.key_path`
  - `clickhouse.tls.ca_path`
  - `clickhouse.tls.skip_verify`

For more details, see [Configure ClickHouse]({{< ref "nim/system-configuration/configure-clickhouse.md" >}}).