---
nd-docs: DOCS-000
nd-files:
- content/nginxaas-azure/monitoring/enable-logging/logging-using-cli.md
- content/nginxaas-azure/monitoring/enable-logging/logging-using-portal.md
- content/nginxaas-azure/monitoring/enable-logging/logging-using-terraform.md
---

1. File-based logs must be configured to use the path **/var/log/nginx**.
1. The **gzip** parameter for the **access_log** directive is not supported, and uploading a config with this parameter will cause an error.
1. Logging **error_log** to a cyclic memory buffer using the **memory:** prefix is not allowed and will cause a config upload error.
1. Egress Networking charges apply for traffic sent from the NGINX deployment to a syslog server present in a different VNet.
