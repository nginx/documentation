**For private cloud deployments**, you must set a floating IP to complete setting up your multi-node resilient cluster.

A floating IP -- also called a virtual IP -- is a static, routable IPv4 address that improves service resiliency by allowing NGINX Controller to continue to receive traffic if a node becomes unavailable. The floating IP is assigned to one of the cluster nodes, and if the node fails, the floating IP is automatically transferred to another node. The floating IP should not be in any DHCP pool.

{{< important>}}
The floating IP needs to be added as an A record for the domain that's used as the Fully Qualified Domain Name (FQDN) for NGINX Controller.

NGINX Controller **does not support IPv6** addresses for the floating IP.
{{< /important >}}

Take the following steps to add a floating IP for your private cloud cluster:

1. Open the NGINX Controller web interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Cluster**.
1. On the **Cluster** overview page, in the **Cluster Configuration** section, select the edit icon (pencil).
1. Select the **Use Floating IP** toggle to turn it on.
1. Add an IP address for the floating IP.
1. Select **Save**.
1. Complete the steps to [update the FQDN](#update-the-fqdn) to use the floating IP.

{{< see-also >}}
To set a floating IP using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint.
{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-295 -->