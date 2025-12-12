---
---

Rename the JWT file to `license.jwt`, but **do not move it to `/etc/nginx/`** — the installation script does this automatically. If the JWT file is already in `/etc/nginx/`, the script will fail.

For example:

```shell
mv nginx-one-<subscription-id>.jwt license.jwt
```

When running the script with the `-p` flag (NGINX Plus), you must also include the `-j` flag to specify the path to the `license.jwt` file.