---
description: Learn how to add and manage additional F5 NGINX Controller nodes to create
  a resilient cluster.
nd-docs: DOCS-788
title: Manage Your Cluster
toc: true
weight: 140
type:
- how-to
- tutorial
---

## Overview

This topic explains how to update your cluster settings and how to manage nodes for a multi-node cluster.

{{< call-out "note" >}}
For instructions on how to deploy NGINX Controller as a multi-node resilient cluster, refer to the following deployment guide:

- [Deploy F5 NGINX Controller as a Resilient Cluster on a Private Cloud]({{< ref "/controller/admin-guides/install/resilient-cluster-private-cloud.md" >}})

{{< /call-out>}}

## Set the Floating IP

**For private cloud deployments**, you must set a floating IP to complete setting up your multi-node resilient cluster.

A floating IP -- also called a virtual IP -- is a static, routable IPv4 address that improves service resiliency by allowing NGINX Controller to continue to receive traffic if a node becomes unavailable. The floating IP is assigned to one of the cluster nodes, and if the node fails, the floating IP is automatically transferred to another node. The floating IP should not be in any DHCP pool.

{{< call-out "important" >}}
The floating IP needs to be added as an A record for the domain that's used as the Fully Qualified Domain Name (FQDN) for NGINX Controller.

NGINX Controller **does not support IPv6** addresses for the floating IP.
{{< /call-out >}}

Take the following steps to add a floating IP for your private cloud cluster:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, in the **Cluster Configuration** section, select the edit icon (pencil).
1. Select the **Use Floating IP** toggle to turn it on.
1. Add an IP address for the floating IP.
1. Select **Save**.
1. Complete the steps to [update the FQDN](#update-the-fqdn) to use the floating IP.

{{< call-out "note" >}}
To set a floating IP using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint.
{{< /call-out>}}


## Update the FQDN

The Fully Qualified Domain Name (FQDN) should be a proper domain. The FQDN is used by Controller Agents to access NGINX Controller. It's also used to access the web interface.

Updating the FQDN for NGINX Controller is a two-step process:

1. Update the FQDN for NGINX Controller using the web interface or the REST API.
1. Update the Controller Agents to use the new FQDN.

### Update the FQDN for NGINX Controller

To change the FQDN for NGINX Controller using the web interface, take the following steps:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the Cluster overview page, in the **Cluster Configuration** section, select the edit icon (pencil).
1. In the FQDN box, type the new FQDN that you want to use. If you've [set a floating IP](#set-the-floating-ip), use that value for the FQDN.
1. Select the **Update API Gateway SSL Certificate** toggle.
1. Select an option for updating the API Gateway cert:

    - **Paste**: Paste the cert and key contents in the respective boxes.
    - **File**: Browse for and upload the cert and key files.

1. Select **Save**. The cluster services will restart. During this time, the web interface will be briefly unavailable.
1. Follow the steps to [update the FQDN for Controller Agents](#update-the-fqdn-for-controller-agents).

{{< call-out "note" >}}
To change the FQDN for NGINX Controller using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint.
{{< /call-out>}}

### Update the FQDN for Controller Agents

To update the FQDN for Controller Agents, take the following steps on each instance where the Controller Agent is installed:

1. Open the `/etc/controller-agent/agent.conf` file for editing.
1. Update the `api_url` value with the new FQDN:

    ```nginx
    [cloud]
    api_url = https://<NEW_FQDN>:8443/1.4
    ```

1. Save the changes.
1. Restart the Controller Agent:

    ```bash
    sudo service controller-agent restart
    ```

## Update the API Gateway SSL Certificate

Take the following steps to update the API Gateway SSL certificate:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, in the **Cluster Configuration** section, select the edit icon (pencil).
1. Select the **Update API Gateway SSL Certificate** toggle.
1. Select an option for updating the cert:

    - **Paste**: Paste the cert and key contents in the boxes.
    - **File**: Browse for and upload the cert and key files.

1. Select **Save**.

{{< call-out "note" >}}
To update the API Gateway SSL certificate and key using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint.
{{< /call-out>}}


## Add Nodes to a Cluster

Nodes are additional control-plane hosts that you can add to your cluster to improve uptime resilience. For a resilient cluster, you should have at least three nodes, of which **two nodes must always be operational**.

{{< call-out "important" >}}
When adding a third node to the cluster for the first time, NGINX Controller may become momentarily unavailable while the cluster is being created. For this reason, we recommend updating NGINX Controller during a planned maintenance window to minimize disruptions.
{{< /call-out >}}

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
1. Run the `install.sh` command with the join-key that you copied in the previous step. If you get an error that the join-key has expired, you can get a new one by following the steps in this topic to add a node using the web interface or the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}).

    ```bash
    cd controller-installer
    ./install.sh --join-key <long-value>
   ```

1. After the installation finishes, the node status in the web interface changes to `Configured`.
1. Repeat these steps for each node that you want to add to the cluster.

{{< call-out "note" >}}
To add nodes to your cluster using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a POST request to the `/platform/nodes` endpoint.
{{< /call-out>}}

## View Node Status

Take the following steps to view the status for a node:

{{< call-out "note" >}}
To view a node's status using the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}), send a GET request to the Nodes endpoint.
{{< /call-out>}}

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, choose the node you want to view details for, then select **View** (eye icon). A panel opens and displays the node's current condition, including any errors. If you're adding a node to the cluster, the node status panel shows the command-line instructions to follow to complete setting up the node.

## Delete a Node

There might be situations when you need to delete a node, either temporarily for maintenance or permanently to decommission a node.

If you need to remove a node temporarily, follow the steps in the [Add Nodes to the Cluster](#add-nodes-to-the-cluster) topic when you are ready to re-add it. Make sure to uninstall NGINX Controller from the node before re-installing NGINX Controller with the new join-key.

{{< call-out "important" >}}
Deleting nodes can cause NGINX Controller to become momentarily unavailable while the cluster is being updated. For this reason, we recommend updating NGINX Controller during a planned maintenance window to minimize disruptions. When deleting nodes, make sure that **at least two nodes are always operational**. If the cluster has fewer than two working nodes, NGINX Controller may become unresponsive, and you may not be able to add new nodes.
{{< /call-out >}}

{{< call-out "note" >}}
To delete nodes from your cluster using the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}), send a DELETE request to the Nodes endpoint.
{{< /call-out>}}

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

{{< call-out "note" >}}
To delete nodes from your cluster using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a DELETE request to the `/platform/nodes` endpoint.
{{< /call-out>}}


## Replace a Failed Node

To be resilient, a cluster requires three working nodes. That's two nodes for a quorum and one node for failure tolerance.

If one of the nodes in a multi-node cluster becomes degraded or fails, you must take action **as soon as possible** to recover or replace the failed node or risk losing resiliency.

To replace a failed node:

1. [Delete the failed node](#delete-a-node).
1. [Add a new node](#add-nodes-to-a-cluster).


## Update Cluster

When updating NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

{{< call-out "warning" >}}Do not update the nodes in a multi-node cluster in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /call-out >}}

{{< call-out "important" >}}
Active users will be logged out from NGINX Controller during an update. We recommend updating NGINX Controller during a planned maintenance window to minimize disruptions.
{{< /call-out >}}

To update your cluster to a newer version of NGINX Controller, take the following steps:

1. Before updating the cluster, [check each node's status]({{< ref "/controller/platform/manage-cluster.md#view-node-status" >}}) to confirm the nodes are healthy. Resolve any degradations before updating.
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


{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
