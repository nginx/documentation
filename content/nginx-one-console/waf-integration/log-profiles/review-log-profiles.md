---
# We use sentence case and present imperative tone
title: "Review log profiles"
# Weights are assigned in increments of 100: determines sorting order
weight: 655
# Creates a table of contents and sidebar, useful for large document
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NONECO
---

Before you deploy a log profile to an NGINX instance or Config Sync Group, you may want to review it. F5 NGINX One Console creates a log profile for your F5 WAF for NGINX security logging.

## Review F5 WAF for NGINX log profiles

From NGINX One Console, select **WAF** > **Log Profiles**. Select the name of the log profile that you want to review. You'll see the following tabs:

- **Details**: Displays log profile information, including:
  - Last modified date and time (for example, 1/16/2026, 3:35:25 PM PST)
  - Total deployments
  - Log profile JSON configuration

- **Deployments**: Shows deployment details for each instance or Config Sync Group, including:
  - Compiled version
  - Deployment status
  - Date deployed
  - Whether the latest log profile JSON was deployed

- **Bundles**: Lists all WAF compiler versions with the following information:
  - Compiler version
  - Compilation status (Compiled, Not compiled, or Compiling)
  - Actions to compile or download the compiled bundle

## Modify existing log profiles

From the NGINX One Console, you can also manage existing log profiles. In the Log Profiles screen, identify a log profile, and select **Actions**. From the menu that appears, you can:

- **Edit**: Opens the log profile configuration editor where you can reconfigure settings. See [Configure log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/configure-log-profiles.md" >}}) for details.
- **Make a Copy**: Creates a new log profile by copying the JSON content into a new log profile object. You can use an existing log profile as a baseline for further customization.
- **Deploy**: Applies the latest revision of the log profile to the configured instances and Config Sync Groups.
- **Download JSON**: Downloads the log profile JSON configuration.
- **Manage Bundles**: Opens a view to manage compiled bundles for different WAF compiler versions.
- **Delete**: Removes the log profile. Once confirmed, you'll lose all work you've done on that log profile.
