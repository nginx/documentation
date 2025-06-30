---
description: Learn how to safely change the management IP of F5 NGINX Controller.
nd-docs: DOCS-779
title: Changing the IP address
toc: true
weight: 135
type:
- how-to
- tutorial
---

## Overview

This topic explains how to safely update the management IP of F5 NGINX Controller.

{{< see-also >}}
For instructions on how to deploy NGINX Controller as a multi-node resilient cluster, refer to the following deployment guide:

- [Deploy NGINX Controller as a Resilient Cluster on a Private Cloud]({{< ref "/controller/admin-guides/install/resilient-cluster-private-cloud.md" >}})

{{< /see-also >}}

## Changing the IP of a multi-node cluster

To change the IP of a multi-node cluster, follow the steps below for each node in the cluster:

- [Remove the node from the cluster]({{< ref "#remove-node">}})
- [Change the IP address (public and private)]({{< ref "#change-ip">}})
- [Reboot the node]({{< ref "#reboot-node">}})
- [Add the node back to the cluster]({{< ref "#add-node">}})
- [Change the FQDN]({{< ref "#fqdn">}})

### 1. <a name="remove-node"></a>Remove node from the cluster

   {{< important >}}
Deleting nodes makes NGINX Controller momentarily unavailable while the cluster is being updated. Therefore, we recommend updating NGINX Controller during a planned maintenance window to minimize disruptions. When deleting nodes, make sure that **at least two nodes are always operational**. If the cluster has fewer than two working nodes, NGINX Controller may become unresponsive, and you may not be able to add new nodes.
   {{< /important >}}

   To delete a node from the cluster using the web interface:

   1. Open the NGINX Controller web interface and log in.
   2. Select the NGINX Controller menu icon, then select **Platform**.
   3. On the **Platform** menu, select **Cluster**.
   4. On the **Cluster** overview page, choose the node you want to delete, then select **Delete** (trash icon).
   5. Select **Delete** to confirm.

   {{< see-also >}}
 To delete nodes from your cluster using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a DELETE request to the `/platform/nodes` endpoint.
   {{< /see-also >}}


### 2. <a name="change-ip"></a>Change the IP address (public & private)

Refer to your Linux distribution documentation for specific instructions.

### 3. <a name="reboot-node"></a>Reboot the node


### 4. <a name="add-node"></a>Add the node back to the cluster

   Take the following steps to add a node to the cluster:

   1. Open the NGINX Controller web interface and log in.
   1. Select the NGINX Controller menu icon, then select **Platform**.
   1. On the **Platform** menu, select **Cluster**.
   1. On the **Cluster** overview page, select **Create Node**.
   1. Add a name for the node.
   1. (Optional) Add a description.
   1. Add the hostname or IP address -- or both -- for the node.
   1. Select **Save**. The new node appears in the list of nodes on the **Cluster** overview page with a `Configuring` status.
   1. Choose the new node's name in the list, then select **View** (eye icon). A page with command-line instructions for adding the node appears.
   1. Copy the `install.sh` command and join-key that are shown.
   1. Open an SSH connection to the node that you're adding to the cluster.
   1. Uninstall NGINX Controller from the node if you haven't already, and then continue with the remaining steps in this procedure:

       ```bash
       /opt/nginx-controller/uninstall.sh
       ```

   1. Upload and extract the `controller-installer-<version>.tar.gz` tarball.
   1. Run the `install.sh` command with the join-key copied in the previous step. If the join-key has expired, you can get a new one by following the steps in this topic to add a node using the web interface or the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}).

       ```bash
       cd controller-installer
       ./install.sh --join-key <long-value>
      ```

   1. After the installation is complete, the node status in the web interface changes to `Configured`.

   {{< see-also >}}
To add nodes to your cluster using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a POST request to the `/platform/nodes` endpoint.
   {{< /see-also >}}

### 5. <a name="fqdn"></a>Change the FQDN

[Change the FQDN]({{< ref "/controller/platform/manage-cluster.md#update-the-fqdn">}}) if it has been affected by the IP change.

{{< important >}}
Repeat the steps for each node in the cluster.
{{< /important >}}

## Changing the IP of a single node

To change the IP of a single node:

1. Change the IP of the node (public and private). Refer to your Linux distribution documentation for specific instructions.

1. Reboot the node.

1. Run the following command (only required if smtp was affected by the IP change):

   ```bash
   opt/nginx-controller/helper.sh configsmtp <smtp_host> <smtp_port> false <do-not-reply-email>
   ```

1. [Change the FQDN]({{< ref "/controller/platform/manage-cluster.md#update-the-fqdn">}}) if it has been affected by the IP change.

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
