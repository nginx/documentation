When updating NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

{{< warning >}}Do not update the nodes in a multi-node cluster in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

{{< important >}}
Active users will be logged out from NGINX Controller during an update. We recommend updating NGINX Controller during a planned maintenance window to minimize disruptions.
{{< /important >}}

To update your cluster to a newer version of NGINX Controller, take the following steps:

1. Before updating the cluster, [check each node's status]({{< relref "platform/manage-cluster.md#view-node-status" >}}) to confirm the nodes are healthy. Resolve any degradations before updating.
1. Download the new installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

1. Extract the installer package and save the contents to each node:

   ```bash
   tar xzf controller-installer-<version>.tar.gz
   ```

1. Run the update script on each node -- the order in which you update the nodes doesn't matter:

   ```bash
   cd controller-installer
   ./update.sh
   ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-309 -->