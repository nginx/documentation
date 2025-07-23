---
docs:
files:
   - content/agent/install-upgrade/uninstall.md
   - content/nginx-one/agent/install-upgrade/uninstall.md
---

Complete the following steps on each host where you've installed NGINX Agent:

1. Stop NGINX Agent:

   ```shell
   sudo systemctl stop nginx-agent
   ```

1. To uninstall NGINX Agent, run the following command:

   ```shell
   sudo apt-get remove nginx-agent
   ```

   {{< note >}} The `apt-get remove <package>` command will remove the package from your system, while keeping the associated configuration files for possible future use. If you want to completely remove the package and all of its configuration files, you should use `apt-get purge <package>`. {{< /note >}}