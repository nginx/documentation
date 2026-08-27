---
f5-product: F5 Application Delivery Service
f5-files:
- content/ads/overview/nginx-configuration/nginx-configuration-console.md
- content/ads/aws/deploy/nginx-configuration/nginx-configuration-console.md
- content/ads/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md
- content/ads/google/deploy/nginx-configuration/nginx-configuration-console.md
- content/ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md
---

1. On the left menu, select **Configurations**.
1. On the list of configurations, select the ellipsis (three dots) icon next to the configuration you want to update.
1. Select **Edit**.
1. Update the "Description" field as needed and select **Next**.
1. Modify the configuration file(s) as needed.
   - Select a config file in the file tree to update its content.
   - Select **Add File** to stage new content such as certificates, configuration files, or upload non-configuration files.
   - Select **File Actions** to rename, move, delete, or copy files as you build out the overall configuration filesystem.
   - Warnings, errors, and recommendations appear in the editor as you modify your configuration content.
   - You can hover over an NGINX configuration directive to view helpful descriptions and usage details.
1. Select **Next** when you have completed your changes.
1. Review the changes using the "Inline" or "Side-by-side" views and select **Save**.

You will see a notification confirming that the configuration was updated successfully, and a new config version will be available to apply to your F5 Application Delivery Service deployments.
