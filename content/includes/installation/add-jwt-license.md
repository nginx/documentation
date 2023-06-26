To upload and apply a JWT license for NGINX Management Suite:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** gear icon.
3. On the **Settings** menu, select **Licenses**.
4. Select **Getting Started**.
5. Locate the `.jwt` file you [downloaded from MyF5]({{< relref "/nms/installation/add-license.md#download-license" >}}), then select **Upload**. NGINX Management Suite will automatically retrieve your product entitlements from F5's licensing servers.
6. Select **Review Entitlements** and confirm the correct product entitlements are listed.
7. Select **Submit**.

Your NGINX entitlements will now be visible on the Licenses page, along with information about your product usage relative to your entitled capacity.

If needed, you can return to this page at any time to cancel the license by removing the `.jwt` file, revoking your entitlements, and notifying F5 that the license has been terminated.
