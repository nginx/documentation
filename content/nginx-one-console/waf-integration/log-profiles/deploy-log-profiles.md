---
# We use sentence case and present imperative tone
title: "Deploy log profiles"
# Weights are assigned in increments of 100: determines sorting order
weight: 660
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NONECO
---

After you've set up a log profile, it won't capture security events until you deploy it to instances or Config Sync Groups.

This page assumes you've created a log profile in NGINX One Console that you're ready to deploy.

## Deploy a log profile

To deploy a log profile from NGINX One Console, take the following steps:

1. Select **WAF** > **Log Profiles**.
1. Select the log profile that you're ready to deploy.
1. From **Actions**, select **Deploy**.
1. In the **Deploy Log Profile** window that appears, you can confirm the name of the current log profile. NGINX One Console defaults to the selected log profile.
1. In the **Target** section, select Instance or Config Sync Group.
1. In the drop-down menu that appears, select the instance or Config Sync Group.
1. Choose how to deploy the log profile:
   - **Add a new log profile path**: Specify a new file path where the log profile bundle should be deployed
   - **Update all log profiles**: Sync all log profiles on the target instance or Config Sync Group. This updates all existing log profiles by compiling their latest JSON contents into bundles and deploying them to all existing file paths

When you deploy, if the log profile has not already been compiled for the WAF compiler version used by the target instance or Config Sync Group, NGINX One Console automatically compiles it into a bundle before deployment.

## Alternative: Deploy during configuration editing

You can also deploy a log profile directly when editing the NGINX configuration for an instance or Config Sync Group. This method integrates log profile deployment into your regular configuration workflow.

To deploy a log profile using the configuration editor:

1. Select **Instances** or **Config Sync Groups** and choose the target instance or Config Sync Group.
1. Select the **Configuration** tab and then **Edit Configuration**.
1. Select **Add File** and then choose **Existing Log Profile**.
1. In the **Select a Log Profile** drop-down menu, select the log profile you want to deploy.
1. In **Log Profile Destination**, specify the file path where the log profile bundle should be deployed, such as `/etc/nginx/app_protect/log_default.tgz`.
1. Select **Add**. NGINX One Console displays a code snippet with the required directives.
1. Paste the code snippet into your NGINX configuration. The snippet includes:
   - `app_protect_security_log_enable on`
   - `app_protect_security_log` with the log profile bundle path and destination

   For example:
   ```
   app_protect_security_log_enable on;
   app_protect_security_log /etc/nginx/log-profile-bundle.tgz syslog:server=localhost:514;
   ```

1. Select **Next** and then **Save and Publish**.

For more information about adding files through the configuration editor, see [Add a file to a Config Sync Group]({{< ref "/nginx-one-console/nginx-configs/config-sync-groups/add-file-csg.md" >}}) or [Add a file to an instance]({{< ref "/nginx-one-console/nginx-configs/one-instance/add-file.md" >}}).

## Verify log profile deployment

After deployment, verify that your log profile is active on the target instances or Config Sync Groups:

1. Confirm that the NGINX configuration includes the required directives:
   - `app_protect_security_log_enable on`
   - `app_protect_security_log` with the correct log profile bundle path and destination

2. Check that security logs are being generated at the configured destination (file path or syslog server).

3. Review the log entries to ensure they match the format and filter settings you configured in the log profile.

For troubleshooting log profile deployment issues, see the [Container-related configuration requirements]({{< ref "/nginx-one-console/waf-integration/overview.md#container-related-configuration-requirements" >}}) section to ensure volumes and paths are correctly configured.
