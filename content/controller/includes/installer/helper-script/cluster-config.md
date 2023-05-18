After installing NGINX Controller, you should back up the cluster config and encryption keys. You'll need these if you ever need to restore the NGINX config database on top of a new NGINX Controller installation.

- To back up the NGINX Controller cluster configuration and encryption keys:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config save
  ```

  The file is saved to `/opt/nginx-controller/cluster-config.tgz`.

- To restore the cluster's config and encryption keys, take the following steps:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config load <filename>
  ```
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-271 -->
