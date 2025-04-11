---
docs: DOCS-000
---

To pin NGINX Plus to a specific version (for example, R33):

1. Edit the `/etc/apt/sources.list.d/nginx-plus.list` file.
1. Update the repository base URL to the desired version:

   - **For Ubuntu**:

      ```shell
      https://pkgs.nginx.com/plus/R33/ubuntu
      ```

   - **For Debian**:

      ```shell
      https://pkgs.nginx.com/plus/R33/debian
      ```

3. Save the changes and exit.

4. Update the repository information:

    ```shell
    sudo apt update
    ```
