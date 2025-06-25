---
docs:
files:
-
-
---

1. In the NGINX One Console, select **Manage > Config Sync Groups**, then pick your config sync group's name.  
2. Select the **Configuration** tab, then select **Edit Configuration**.  
3. Select **Add File**.  
4. Select **New Configuration File**.  
5. In the **File name** box, enter `/etc/nginx/conf.d/dashboard.conf`, then select **Add**.  
6. Paste the following into the new file workspace:

{{< include "config-snippets/enable-nplus-api-dashboard.md" >}}

7. Select **Next**, review the diff, then select **Save and Publish**.