---
file:
  - content/solutions/about-subscription-licenses.md
---


{{<call-out "note" "Before you begin">}}
Before you deploy with a Config Sync Group, you need to create one in the NGINX One Console.  
If you haven’t created a group yet, see [Manage Config Sync Groups]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}) for instructions.
{{</call-out>}} 

1. In the NGINX One Console, go to **Manage > Config Sync Groups**, then select your group.  

2. Open the **Configuration** tab and select **Edit Configuration**.  

3. Select **Add File**, then choose **New Configuration File**.  

4. In the **File name** field, enter the exact path:  
   - On Linux: `/etc/nginx/license.jwt`  
   - On FreeBSD: `/usr/local/etc/nginx/license.jwt`  

5. Paste the contents of your JWT license file into the editor.  

6. Select **Next** to preview the changes, then choose **Save and Publish** to apply the update.  