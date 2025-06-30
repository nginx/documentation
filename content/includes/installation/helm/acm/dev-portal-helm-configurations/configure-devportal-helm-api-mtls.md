---
nd-docs: DOCS-1309
---

When deploying the Developer Portal using a helm chart, you can configure TLS to secure communication between the NGINX API Gateway and backend API service.

To use TLS with the backend API service, you need the following:

- An installed, licensed, and running version of API Connectivity Manager
- Access to a Kubernetes (or similar) cluster
- (Optional) A TLS CA certificate to verify NGINX API Gateway client TLS certificates
- (Optional) A TLS server certificate and key pair for validation with the NGINX API Gateway

Set the following configuration options to use TLS with the backend API service:

{{<bootstrap-table "table table-striped table-bordered">}}

| Parameter                   | Value    |
| --------------------------- | -------- |
| `api.db.external`           | `false`  |
| `api.db.type`               | `sqlite` |
| `api.tls.clientNames`       | ``       |
| `api.tls.clientValidation`  | `true`   |
| `api.tls.secretName`        | `test`   |

{{% /bootstrap-table %}}
