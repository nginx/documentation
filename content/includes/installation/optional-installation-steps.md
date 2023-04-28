The following steps may be optional, depending on your installation configuration.

1. (Optional) If you used a custom address, username, or password or enabled TLS when [installing ClickHouse]({{< relref "installation/on-prem/prerequisites.md#install-clickhouse" >}}), follow the steps in the [Configure ClickHouse]({{< relref "admin-guides/configuration/configure-clickhouse.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to ClickHouse.

1. (Optional) If you use Vault, follow the steps in the [Configure Vault]({{< relref "admin-guides/configuration/configure-vault.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to Vault.

1. (Optional) If you use SELinux, follow the steps in the [Configure SELinux]({{< relref "admin-guides/configuration/configure-selinux.md" >}}) guide to load the SELinux policy that's included with NGINX Management Suite.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1030 -->