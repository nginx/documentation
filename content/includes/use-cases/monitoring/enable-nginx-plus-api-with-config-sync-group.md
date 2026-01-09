---
nd-docs: DOCS-191
nd-product: NONECO
nd-files:
- content/nginx-one-console/nginx-configs/metrics/enable-metrics.md
- content/nginx-one-console/workshops/lab5/upgrade-nginx-plus-to-latest-version.md
---

1. In the NGINX One Console, select **Manage > Config Sync Groups**, then pick your config sync group's name.  
2. Select the **Configuration** tab, then select **Edit Configuration**.  
3. Select **Add File**.  
4. Select **New Configuration File**.  
5. In the **File name** box, enter `/etc/nginx/conf.d/dashboard.conf`, then select **Add**.  
6. Paste the following into the new file workspace:


{{<tabs name="enable-nginx-metrics-with-sync-groups" >}}

{{%tab name="without SSL"%}}
{{< include "/nginx-one-console/config-snippets/enable-nplus-api-dashboard.md" >}}

{{% /tab %}}
{{%tab name="with SSL"%}}

{{< include "/use-cases/monitoring/enable-nginx-plus-api-with-ssl.md" >}}

{{% /tab %}}
{{% /tabs %}}

7. Select **Next**, review the diff, then select **Save and Publish**.
8. Open your browser to `http://<instance-ip>:9000/dashboard.html` (replace `<instance-ip>` with the IP or hostname of one of your group members). You should see the NGINX Plus dashboard.