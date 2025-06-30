---
nd-docs: DOCS-1312
---

You can use an SQLite database for backend API service storage when deploying the Developer Portal from a Helm chart. This configuration uses a [PersistentVolumeClaim (PVC)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) for storage of the SQLite data files.

To use SQLite database, you need the following:

- An installed, licensed, and running version of API Connectivity Manager
- Access to a Kubernetes (or similar) cluster

Set the following configuration options to use a SQLite database:

{{<bootstrap-table "table table-striped table-bordered">}}

| Parameter         | Value    |
| ----------------- | -------- |
| `api.db.external` | `false`  |
| `api.db.type`     | `sqlite` |

{{</bootstrap-table>}}
