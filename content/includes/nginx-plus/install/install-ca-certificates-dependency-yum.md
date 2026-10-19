---
f5-docs: DOCS-145
f5-product: F5 NGINX Plus
f5-files:
- content/nginx/admin-guide/installing-nginx/installing-nginx-plus-lts.md
- content/nginx/admin-guide/installing-nginx/installing-nginx-plus.md
---

Install the **ca-certificates** dependency:

```shell
sudo yum update && \
sudo yum install ca-certificates
```