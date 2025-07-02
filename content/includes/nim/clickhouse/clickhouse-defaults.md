---
nd-docs: DOCS-1238
files:
- content/nim/system-configuration/configure-clickhouse.md
- content/nim/deploy/vm-bare-metal/install-nim-manual.md
---

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration                 | Default                            | Notes |
|------------------------------|------------------------------------|-------|
| clickhouse.enable            | true                               | Set to `false` to disable metrics collection and run NGINX Instance Manager in lightweight mode. Requires a service restart. |
| clickhouse.address           | tcp://localhost:9000               | The address of the ClickHouse database. |
| clickhouse.username          |                                    | The username NGINX Instance Manager uses to connect to ClickHouse, if authentication is enabled. |
| clickhouse.password          |                                    | The password for the specified ClickHouse user. |
| clickhouse.tls_mode          | false                              | Set to `true` to enable TLS for the ClickHouse connection. This setting will be deprecated in a future release. Use the `clickhouse.tls` section instead. |
| clickhouse.tls.address       | tcp://localhost:9440               | The address NGINX Instance Manager uses to connect to ClickHouse over TLS. Format: `<ip-address>:<port>`. |
| clickhouse.tls.skip_verify   | false                              | Set to `true` to skip TLS certificate verification. Use only for self-signed certificates in non-production environments. |
| clickhouse.tls.key_path      |                                    | Path to the client TLS key file in PEM format. Required for client authentication. |
| clickhouse.tls.cert_path     |                                    | Path to the client TLS certificate file in PEM format. Required for client authentication. |
| clickhouse.tls.ca_path       | /etc/ssl/certs/ca-certificates.crt | Path to the system Certificate Authority used to verify the server certificate. The default path works for Ubuntu and Debian. Use a CA bundle appropriate to your system. See [TLS configuration](#tls) for details. |

{{</bootstrap-table>}}
