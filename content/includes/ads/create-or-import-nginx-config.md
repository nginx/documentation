---
f5-product: F5 Application Delivery Service
f5-files:
- content/ads/overview/nginx-configuration/nginx-configuration-console.md
- content/ads/aws/deploy/create-deployment/deploy-console.md
- content/ads/aws/deploy/nginx-configuration/nginx-configuration-console.md
- content/ads/google/deploy/create-deployment/deploy-console.md
- content/ads/google/deploy/nginx-configuration/nginx-configuration-console.md
---

In the F5 Application Delivery Service Console,

1. On the left menu, select **Configurations**.
1. Select **Add Configuration** to add a new NGINX configuration.
1. You can either create a new configuration from scratch or copy an existing configuration:

   - Select **New configuration** to create a new config.
      - Provide a name for your configuration and an optional description.
      - Select to start with the "F5 Application Delivery Service Default" (a basic NGINX setup) or an empty configuration file.
      - Select **Next**.
   - Select **Copy existing configuration** to use one of the existing configuration files in your account as template.
      - Provide a name for your configuration and an optional description.
      - Use the **Choose configuration to copy** list to select the configuration file you want to copy.
      - Use the **Choose configuration version to copy** list to select the version of the configuration file you want to copy.
      - Select **Next**.

1. Modify the configuration file as needed.
   - Select **Add File** to stage new content such as certificates, configuration files, or upload non-configuration files.
   - Select **File Actions** to rename, move, delete, or copy files as you build out the overall configuration filesystem.
   - Warnings, errors, and recommendations appear in the editor as you modify your configuration content.
   - You can hover over an NGINX configuration directive to view helpful descriptions and usage details.
1. Select **Save**.
