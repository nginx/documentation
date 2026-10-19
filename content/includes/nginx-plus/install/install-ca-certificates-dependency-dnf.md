---
f5-docs: DOCS-144
f5-product: F5 NGINX Plus
f5-files:
- content/nginx/admin-guide/installing-nginx/installing-nginx-plus-lts.md
- content/nginx/admin-guide/installing-nginx/installing-nginx-plus.md
---

Install the **ca-certificates** dependency:

```shell
sudo dnf update && \
sudo dnf install ca-certificates
```