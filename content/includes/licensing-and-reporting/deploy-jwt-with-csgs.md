---
file:
  - content/solutions/about-subscription-licenses.md
---

1. In the NGINX One Console, go to **Manage > Config Sync Groups**, then select your group.
   
   If you haven't created a Config Sync Group yet, see [Manage Config Sync Groups]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}) for setup instructions.
2. Select the **Configuration** tab, then choose **Edit Configuration**.
3. Select **Add File**, then choose **New Configuration File**.
4. In the **File name** field, enter:
   - On Linux: `/etc/nginx/license.jwt`  
   - On FreeBSD: `/usr/local/etc/nginx/license.jwt`  
   The name must be exact.
5. Paste the contents of your JWT license file into the editor.
6. Select **Next** to preview the diff, then **Save and Publish** to apply the update.