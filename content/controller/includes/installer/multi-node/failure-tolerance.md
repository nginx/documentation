To be resilient, a cluster requires three working nodes. That's two nodes for a quorum and one node for failure tolerance.

If a node fails in a resilient cluster, NGINX Controller automatically redirects traffic to the other working nodes. A multi-node cluster is operational with only two nodes; however, a two-node cluster isn't resilient to further failures. If one of the nodes in a multi-node cluster becomes degraded or fails, you must take action **as soon as possible** to recover or replace the failed node or risk losing resiliency.

{{< important >}}The failover time can take **up to 5 minutes** when a node fails. During this time, NGINX Controller may be unavailable while services are migrated and restarted. Resiliency will be restored once there are **three working nodes** in the cluster.
{{< /important >}}

The following table shows how many nodes are needed for a cluster to have a quorum and what the failure tolerance is:

<style type="text/css">
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
table {
  width: 400px;
}
th {
  text-align: left;
}
</style>

| Cluster Size | Quorum | Failure Tolerance |
|--------------|--------|-------------------|
| 1            | 1      | 0                 |
| 2            | 2      | 0                 |
| 3            | 2      | 1                 |

Larger clusters aren't supported.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-302 -->