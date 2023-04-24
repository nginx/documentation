[Gateways]({{< relref "/services/manage-gateways.md#overview" >}}) include placements that reference NGINX instances or instance groups. Gateway placements can be for multiple instances or instance groups, allowing a gateway to deliver services in multiple data centers and/or clouds. Placements define the physical machines that are used to manifest a particular path associated with an [application component]({{< relref "/app-delivery/about-app-delivery.md#components" >}}).

On the **Gateways > Create Gateway > Placements** page:

1. Select the **Placement Type**:

    - `Instances`
    - `Instance Groups`

1. In the **Instance Refs/Instance Groups Refs** box, select the NGINX instance(s) or instance group(s) on which you want to deploy the gateway.

   {{< note >}}
   If you're enabling **High Availability Mode**, select the [high-availability instances that you prepared]({{< relref "/infrastructure/instances/ha-data-plane.md#prepare-the-high-availability-instances" >}}). NGINX Controller supports up to two high-availability instances.
   {{< /note >}}

1. In the **Listen IPs** box, add the IP address(es) on which the server listens for and accepts requests. If you're creating a placement for a BIG-IP Integration, add the virtual IP (VIP) address for the BIG-IP cluster.

   You can add multiple placements with different Listen IPs. When multiple placements are defined within a gateway, each placement represents a resilient path for any app component that references that gateway.

   {{< note >}}
   - To use non-local **Listen IPs**, you must enable `net.ipv4.ip_nonlocal_bind` on the instance.
   - When **High Availability Mode** is enabled, Virtual Router Redundancy Protocol ([VRRP](https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol#:~:text=The%20Virtual%20Router%20Redundancy%20Protocol,selections%20on%20an%20IP%20subnetwork.)) is configured for the Listen IP address(es).
   {{< /note >}}

1. To enable high-availability mode for your data paths, select **Use High Availability Mode**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-504 -->