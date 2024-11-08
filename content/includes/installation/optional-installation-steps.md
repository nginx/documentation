---
docs: DOCS-1030
---

The following steps may be necessary depending on your installation configuration.

- If you used a custom address, username, or password, or enabled TLS when [installing ClickHouse]({{< relref "/nim/deploy/vm-bare-metal/install.md#install-clickhouse" >}}), follow the steps in the [Configure ClickHouse]({{< relref "/nim/system-configuration/configure-clickhouse.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Instance Manager won't be able to connect to ClickHouse.

- If you use Vault, follow the steps in the [Configure Vault]({{< relref "/nim/system-configuration/configure-vault.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Instance Manager won't be able to connect to Vault.

- If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore SELinux contexts (`restorecon`) for the files and directories related to NGINX Instance Manager.

