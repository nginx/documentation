---
f5-product: NGINX Plus
f5-files:
- content/nap-dos/deployment-guide/learn-about-deployment.md
- content/nginx/admin-guide/installing-nginx/installing-nginx-plus.md
---

Copy the downloaded JWT file to the **/etc/nginx/** directory and make sure it is named **license.jwt**:

```shell
sudo cp <DOWNLOADED_FILE_NAME>.jwt /etc/nginx/license.jwt
```

Replace `<DOWNLOADED_FILE_NAME>` with the downloaded filename without the `.jwt` extension.
