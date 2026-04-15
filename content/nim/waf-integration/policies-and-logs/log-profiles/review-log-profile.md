---
title: Review log profiles
weight: 400
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-summary: >
  Review WAF log profiles in NGINX Instance Manager to inspect configuration details, deployment status, and bundle compilation state.
  Manage profiles via Actions to edit, copy, export as JSON, manage bundles, or delete.
nd-keywords: "log profiles, WAF, NGINX Instance Manager, NIM, review log profiles, security logs, app protect, deployment status, bundle compilation, instance groups, manage bundles, export JSON"
nd-audience: operator
---

## Overview

Use this guide to review security log profiles for F5 WAF for NGINX in NGINX Instance Manager. Before you deploy a log profile to an NGINX instance or instance group, you can inspect its configuration, check deployment history, and verify bundle compilation state.

---

## Review F5 WAF for NGINX security log profiles

1. In NGINX Instance Manager, select **WAF** > **Log Profiles**.

1. Select the name of the log profile that you want to review.

   The log profile detail view opens with the following tabs:

   - **Details**: Displays log profile information, including:
     - Last modified date and time (for example, 1/16/2026, 3:35:25 PM PST)
     - Total deployments
     - Log profile JSON configuration

   - **Deployments**: Shows deployment details for each instance or instance group, including:
     - Compiled version
     - Deployment status
     - Date deployed
     - Whether the latest log profile JSON was deployed

   - **Bundles**: Lists all WAF compiler versions with the following information:
     - Compiler version
     - Compilation status (Compiled, Not compiled, or Compiling)
     - Actions to compile or download the compiled bundle

---

## Modify existing log profiles

1. In NGINX Instance Manager, select **WAF** > **Log Profiles**.

2. Identify the log profile you want to modify, then select **Actions**.

3. From the menu that appears, select one of the following:

   - **Edit**: Opens the log profile configuration editor where you can reconfigure settings. See [Configure log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}}) for details.
   - **Make a Copy**: Creates a new log profile by copying the JSON content into a new log profile object. Use an existing log profile as a baseline for further customization.
   - **Export as JSON**: Downloads the log profile JSON configuration.
   - **Manage Bundles**: Opens a view to manage compiled bundles for different WAF compiler versions.
   - **Delete**: Removes the log profile. Once confirmed, all configuration work on that log profile is permanently lost.

---

## References

For more information, see:

- [Configure log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}})
- [Deploy log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/deploy-log-profile.md" >}})
- [Security Logs]({{< ref "/waf/logging/security-logs.md" >}})