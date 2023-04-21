The following steps may be optional, depending on your installation configuration.

1. (Optional) If you used a custom address, username, or password or enabled TLS when [installing ClickHouse](#install-clickhouse), follow the steps in the [Configure ClickHouse]({{< relref "admin-guides/getting-started/configure-clickhouse.md" >}}) guide to update the `nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to ClickHouse.

1. (Optional) If you use Vault, follow the steps in the [Configure Vault]({{< relref "admin-guides/getting-started/configure-vault.md" >}}) guide to update the `nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to Vault.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1030 -->