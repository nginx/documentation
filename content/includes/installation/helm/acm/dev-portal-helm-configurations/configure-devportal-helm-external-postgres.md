---
nd-docs: DOCS-1307
---

You can use an external PostgreSQL database for backend API service storage when deploying the Developer Portal from a Helm chart. Access between the backend API service and the database can be secured using TLS server certificates and optional client TLS certificates.

To use an external PostgreSQL database, you need the following:

- An installed, licensed, and running version of API Connectivity Manager
- Access to a Kubernetes (or similar) cluster
- A PostgreSQL service that your Kubernetes cluster can connect to using the required TCP port
- (Optional) a TLS CA certificate for verifying PostgreSQL server TLS certificates
- (Optional) a TLS client certificate and key for authenticating with the PostgreSQL server

Set the following configuration options to use an external PostgreSQL database:

{{<bootstrap-table "table table-striped table-bordered">}}

| Parameter                | Value          |
| ------------------------ | -------------- |
| `api.db.external`        | `true`         |
| `api.db.host`            | `pg.nginx.com` |
| `api.db.pass`            | `nginxdm`      |
| `api.db.tls.secretName`  | `db-certs`     |
| `api.db.tls.verifyMode`  | `verify-full`  |
| `api.db.type`            | `psql`         |
| `api.db.user`            | `nginxdm`      |

{{% /bootstrap-table %}}
