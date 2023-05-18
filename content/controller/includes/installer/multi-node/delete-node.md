There might be situations when you need to delete a node, either temporarily for maintenance or permanently to decommission a node.

If you need to remove a node temporarily, follow the steps in the [Add Nodes to the Cluster](#add-nodes-to-the-cluster) topic when you are ready to re-add it. Make sure to uninstall NGINX Controller from the node before re-installing NGINX Controller with the new join-key.

{{< important >}}
Deleting nodes can cause NGINX Controller to become momentarily unavailable while the cluster is being updated. For this reason, we recommend updating NGINX Controller during a planned maintenance window to minimize disruptions. When deleting nodes, make sure that **at least two nodes are always operational**. If the cluster has fewer than two working nodes, NGINX Controller may become unresponsive, and you may not be able to add new nodes.
{{< /important >}}

{{< see-also >}}
To delete nodes from your cluster using the [NGINX Controller API Reference]({{< relref "api/_index.md" >}}), send a DELETE request to the Nodes endpoint.
{{< /see-also >}}

To delete a node from the cluster using the web interface:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, choose the node you want to delete, then select **Delete** (trash icon).
1. Select **Delete** to confirm.
1. To finish deleting a node from the cluster, uninstall NGINX Controller from the node:

   1. SSH into the node that you're deleting from the cluster.
   1. Run the NGINX Controller uninstall script:

      ```bash
      /opt/nginx-controller/uninstall.sh
      ```

{{< see-also >}}
To delete nodes from your cluster using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a DELETE request to the `/platform/nodes` endpoint.
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-300 -->