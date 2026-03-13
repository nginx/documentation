---
nd-product: NONECO
nd-files:
- content/nginx-one-console/nginx-configs/config-sync-groups/add-file-csg.md
- content/nginx-one-console/nginx-configs/one-instance/add-file.md
---

With this option, you can deploy an existing log profile that you created in NGINX One Console.
In the **Select a Log Profile** drop-down menu, select the log profile of your choice. Then take the following steps:

1. In **Log Profile Destination**, specify the file path where the log profile bundle should be deployed, such as `/etc/app_protect/conf/log_default.tgz`.
1. Select **Add**. NGINX One Console displays a code snippet for using the log profile bundle in your NGINX configuration.
1. Paste the code snippet into your NGINX configuration. The snippet includes the required directives as described in the [WAF logging documentation](https://docs.nginx.com/waf/logging/security-logs/#directives-in-nginxconf):
   - `app_protect_security_log_enable on`
   - `app_protect_security_log` with the log profile bundle path and destination
1. Select **Next** and then **Save and Publish**.
   When publication is complete, you'll be returned to the **Configuration** tab where you can see the updated configuration.
