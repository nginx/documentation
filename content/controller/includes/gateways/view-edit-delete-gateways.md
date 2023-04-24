To view, edit, and delete Gateways:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Gateways**.
4. On the **Gateways** menu, select **Overview**. The **Gateways Overview** page is displayed and shows a list of your Gateways.
5. To view the details for a Gateway, choose the Gateway from the list. This opens a side panel where you can view the Gateway's linked Components, Certs, and Placements.
6. To edit a Gateway, choose the Gateway from the list, then select **Edit** (pencil icon).
7. To delete a Gateway, choose the Gateway from the list, then select **Delete** (trash icon).

   {{< note >}}If your Gateway has external references, such as Components that reference the Gateway, you'll need to delete or reconfigure the external references before removing the Gateway. Refer to [Manage Apps & Components]({{< relref "/app-delivery/manage-apps.md#edit-or-delete-apps-and-components" >}}) to learn how to edit and delete Components.{{< /note >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-505 -->