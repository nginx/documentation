The following steps may be optional, depending on your installation configuration.

1. (Optional) If you used a custom address, username, or password or enabled TLS when [installing ClickHouse]({{< relref "installation/on-prem/prerequisites.md#install-clickhouse" >}}), follow the steps in the [Configure ClickHouse]({{< relref "admin-guides/configuration/configure-clickhouse.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to ClickHouse.

1. (Optional) If you use Vault, follow the steps in the [Configure Vault]({{< relref "admin-guides/configuration/configure-vault.md" >}}) guide to update the `/etc/nms/nms.conf` file. If you don't do so, NGINX Management Suite won't be able to connect to Vault.

1. (Optional) To use the SELinux policy that's included with NGINX Management Suite, take the following steps:

   {{< include "installation/load-selinux-policy.md" >}}

   {{<see-also>}}For additional SELinux configuration options, refer to the [Enforce Security with SELinux Policy]({{< relref "admin-guides/configuration/selinux-guide.md" >}}) topic.{{</see-also>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1030 -->