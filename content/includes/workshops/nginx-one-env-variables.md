---
files:
- content/nginx-one/workshops/lab4/config-sync-groups.md
- content/nginx-one/workshops/lab5/upgrade-nginx-plus-to-r34.md

---

Set these environment variables:

- **TOKEN**: your data plane key, for example:

   ```shell
   export TOKEN="your-data-plane-key"
   ```

- **JWT**: your NGINX Plus license JWT. Save it as `nginx-repo.jwt`, then run:

   ```shell
   export JWT=$(cat path/to/nginx-repo.jwt)
   ```

- **NAME**: a unique ID for your workshop (for example, `s.jobs`):

   ```shell
   export NAME="s.jobs"
   ```
