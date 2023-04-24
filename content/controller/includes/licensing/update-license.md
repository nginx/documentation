To update a license, follow the same steps to [add a license]({{< relref "/platform/licensing-controller.md#add-a-license-to-nginx-controller" >}}). Upload the new license to replace the previous one.

{{< note >}}If you're running NGINX Controller v3.16 or earlier, it's not possible to replace a [connected license]({{< relref "/platform/licensing-controller.md#license-types" >}}) with a [disconnected license]({{< relref "/platform/licensing-controller.md#license-types" >}}). To transition from a connected to a disconnected license on these versions, you first need to [delete the connected license]({{< relref "/platform/licensing-controller.md#delete-a-license" >}}) and then [add the disconnected license]({{< relref "/platform/licensing-controller.md#add-a-license-to-nginx-controller" >}}).{{< /note >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-757 -->