To add an NGINX instance group to a BIG-IP cluster, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instance Groups** > **Overview**.
1. On the **Instance Groups** overview page, select **Create Instance Group**.
1. Add a name for the instance group.
1. (Optional) Provide a display name.
1. (Optional) Provide a description.
1. In the **HA Type** list, select `BIG-IP`.
1. In the **Integration Reference** list, select the name of your BIG-IP integration. 

   If you haven't created an integration already, refer to [Create a BIG-IP Integration]({{< relref "/platform/integrations/big-ip-self-service.md#create-a-big-ip-integration" >}}) for instructions.

1. In the **Server Pool IP** box, specify the IP address or CIDR of the NGINX instances to add to the BIG-IP server pool; for example, `198.51.100.0/24`. If using a CIDR, the NGINX instance IP addresses that match the mask will be the member addresses in the BIG-IP server pool. Otherwise, absolute IP addresses are used as pool member addresses.
1. Select **Submit** to create the instance group.

{{< important >}}
If you edit an instance group after you've used the group for a gateway placement, you'll need to update the placement as well.
{{< /important >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-735 -->