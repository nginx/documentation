---
nd-docs: DOCS-1311
---

You can use an embedded PostgreSQL database for backend API service storage when deploying the Developer Portal from a Helm chart. This configuration uses a [PersistentVolumeClaim (PVC)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) for storage of the the PostgreSQL data files. Access between the backend API service and the database is secured using auto-generated client TLS certificates.

To use an embedded PostgreSQL database, you need the following:

- An installed, licensed, and running version of API Connectivity Manager
- Access to a Kubernetes (or similar) cluster

Set the following configuration options to use an embedded PostgreSQL database:

{{<bootstrap-table "table table-striped table-bordered">}}

| Parameter                              | Value           |
| -------------------------------------- | --------------- |
| `api.db.external`                      | `false`         |
| `api.db.pass`                          | `nginxdm`       |
| `api.db.type`                          | `psql`          |
| `api.db.user`                          | `nginxdm`       |
| `api.persistence.claims.accessMode`    | `ReadWriteOnce` |
| `api.persistence.claims.existingClaim` | `false`         |
| `api.persistence.claims.size`          | `250Mi`         |
| `api.persistence.enabled`              | `true`          |

{{% /bootstrap-table %}}
