---
docs: DOCS-000
---

To pin NGINX Plus to a specific version (for example, R32):

1. Edit the `/etc/apt/sources.list.d/nginx-plus.list` file.
1. Update the repository base URL to the desired version:

   - **For Ubuntu**:

      ```shell
      https://pkgs.nginx.com/plus/R32/ubuntu
      ```

   - **For Debian**:

      ```shell
      https://pkgs.nginx.com/plus/R32/debian
      ```

3. Save the changes and exit.