---
nd-files:
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/disconnected/offline-install-guide.md
---

Follow the steps below to uninstall NGINX Instance Manager and ClickHouse.

- **For CentOS, RHEL, and RPM-based distributions:**

   ```shell
   sudo yum remove -y nms-*
   sudo systemctl stop clickhouse-server
   sudo yum remove -y clickhouse-server
   ```

- **For Debian, Ubuntu, and Deb-based distributions:**

   ```shell
   sudo apt-get remove -y nms-*
   sudo systemctl stop clickhouse-server
   sudo apt-get remove -y clickhouse-server
   ```

   If you want to remove the package and its configuration files, use `apt-get purge -y <package>` instead of `apt-get remove -y`.

{{< call-out "note" "Fully remove NGINX Instance Manager and reset the environment" >}}
Want to fully remove NGINX Instance Manager and all related components?

Use the `-r` option with the installation script for a more thorough cleanup. This removes NGINX Instance Manager, ClickHouse, configuration files, services, and related user accounts.

```bash
sudo bash install-nim-bundle.sh -r
```

**Use with caution.** This option permanently deletes data unless you have backups. Recommended when cleaning up before a fresh install.
{{< /call-out >}}