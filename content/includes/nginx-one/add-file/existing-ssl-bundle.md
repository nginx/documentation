---
docs:
---

With this option, You can incorporate [Managed certificates]({{< ref "/nginx-one/how-to/certificates/manage-certificates.md#managed-and-unmanaged-certificates" >}}).
In the **Choose Certificate** drop-down, select the managed certificate of your choice, and select **Add**. You can then:

1. Review details of the certificate. The next steps depend on whether the certificate is a CA bundle or a certificate / key pair.
1. Enter the **Certificate File Path**, such as `/etc/ssl/nginx/mycert.crt` or `/etc/ssl/nginx/mycert.pem`.
1. If you selected a key pair, you'll also enter the **Key File Path**, such as `/etc/ssl/nginx/mycert.key`.
1. If you select **Add Item**, you can add the same certificate or key to another directory.
1. Select **Add**. You should now be returned to the **Edit Configuration** window.
   You should now see the files you specified in the directory tree.
1. Select **Next** and then **Save and Publish**.
   You may see a message that suggests publication is in progress.
1. When publication is complete, you're taken back to the **Configuration** tab. You should see the updated configuration in the window.
