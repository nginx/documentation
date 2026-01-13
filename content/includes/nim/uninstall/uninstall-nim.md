---
nd-product: NIMNGR
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