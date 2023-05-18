Nodes are additional control-plane hosts that you can add to your cluster to improve uptime resilience. For a resilient cluster, you should have at least three nodes, of which **two nodes must always be operational**.

{{< important >}}
When adding a third node to the cluster for the first time, NGINX Controller may become momentarily unavailable while the cluster is being created. For this reason, we recommend updating NGINX Controller during a planned maintenance window to minimize disruptions.
{{< /important >}}

Take the following steps to add a node to the cluster:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, select **Create Node**.
1. Add a name for the node.
1. (Optional) Add a description.
1. Add the hostname or IP address -- or both -- for the node.
1. Select **Save**. The new node appears in the list of nodes on the **Cluster** overview page with a `Configuring` status.
1. Choose the new node's name in the list, then select **View** (eye icon). A page displays with command-line instructions for adding the node.
1. Copy the `install.sh` command and join-key that are shown.
1. Open an SSH connection to the node that you're adding to the cluster.
1. (Optional) If you're adding a node that was previously deleted, uninstall NGINX Controller from the node if you haven't already, and then continue with the remaining steps in this procedure:

    ```bash
    /opt/nginx-controller/uninstall.sh
    ```

1. Upload and extract the `controller-installer-<version>.tar.gz` tarball.
1. Run the `install.sh` command with the join-key that you copied in the previous step. If you get an error that the join-key has expired, you can get a new one by following the steps in this topic to add a node using the web interface or the [NGINX Controller REST API]({{< relref "api/_index.md" >}}).

    ```bash
    cd controller-installer
    ./install.sh --join-key <long-value>
   ```

1. After the installation finishes, the node status in the web interface changes to `Configured`.
1. Repeat these steps for each node that you want to add to the cluster.

{{< see-also >}}
To add nodes to your cluster using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a POST request to the `/platform/nodes` endpoint.
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-296 -->