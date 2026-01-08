---
nd-docs: DOCS-173
nd-product: NONECO
nd-files:
- content/nginx-one-console/workshops/lab3/explore-nginx-one-console-features.md
- content/nginx-one-console/workshops/lab4/config-sync-groups.md
- content/nginx-one-console/workshops/lab5/upgrade-nginx-plus-to-latest-version.md
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
