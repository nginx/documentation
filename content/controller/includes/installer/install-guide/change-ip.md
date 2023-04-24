To change the IP of a single node:

1. Change the IP of the node (public and private). Refer to your Linux distribution documentation for specific instructions.

1. Reboot the node.

1. Run the following command (only required if smtp was affected by the IP change):
   ```bash
   opt/nginx-controller/helper.sh configsmtp <smtp_host> <smtp_port> false <do-not-reply-email>
   ```

1. [Change the FQDN]({{< relref "/platform/manage-cluster.md#update-the-fqdn">}}) if it has been affected by the IP change.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-732 -->