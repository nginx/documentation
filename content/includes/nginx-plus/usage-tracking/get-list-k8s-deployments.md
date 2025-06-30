---
nd-docs: DOCS-1352
---

To report your NGINX Ingress Controller clusters to F5, follow these steps:

1. Run the following command in your terminal to get a list of NGINX Ingress Controller instances and nodes in your cluster. Remember to replace `<NMS_FQDN>` with the fully-qualified domain name of your NGINX Instance Manager host:

   ```sh
   curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
   ```

2. Once you have the list of instances and nodes, send it to your F5 representative.

