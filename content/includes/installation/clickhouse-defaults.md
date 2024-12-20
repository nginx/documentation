---
docs: DOCS-1238
---

{{<bootstrap-table "table table-striped table-bordered">}}

| Configuration            | Default                            | Notes |
|--------------------------|------------------------------------|-------|
| clickhouse.address       | tcp://localhost:9000               |       |
| clickhouse.username      |                                    |       |
| clickhouse.password      |                                    |       |
| clickhouse.tls_mode      | false                              |       |
| clickhouse.tls.address   | tcp://localhost:9440               |       |
| clickhouse.tls.skip_verify   | false                              |`clickhouse.tls.skip_verify` should be used only for self-signed certificates and is never recommended for production use. When set to `true`, certificates are not verified, which exposes the connection to man-in-the-middle attacks. |
| clickhouse.tls.key_path  |                                    |       |
| clickhouse.tls.cert_path |                                    |       |
| clickhouse.tls.ca_path   | /etc/ssl/certs/ca-certificates.crt |The default value for `clickhouse.tls.ca_path` works out-of-the-box for Ubuntu and Debian. You'll need to [configure a different Certificate Authority](#tls) for other distributions. Refer to your distribution's documentation for additional information.|

{{</bootstrap-table>}}

<br>
