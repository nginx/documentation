---
f5-product: NGINX Plus
f5-files:
- content/nap-dos/deployment-guide/learn-about-deployment.md
- content/nginx/admin-guide/installing-nginx/installing-nginx-plus.md
---

Copy the downloaded **.crt** and **.key** files to the **/etc/ssl/nginx/** directory and make sure they are named **nginx-repo.crt** and **nginx-repo.key**:

```shell
sudo cp <DOWNLOADED_FILE_NAME>.crt /etc/ssl/nginx/nginx-repo.crt
sudo cp <DOWNLOADED_FILE_NAME>.key /etc/ssl/nginx/nginx-repo.key
```

Replace `<DOWNLOADED_FILE_NAME>` with the name of the file you downloaded.
