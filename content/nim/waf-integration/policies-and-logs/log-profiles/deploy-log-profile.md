---
nd-content-type: how-to
nd-docs: DOCS-000
nd-product: NIMNGR
title: Deploy log profiles
description: "Deploy an F5 WAF for NGINX security log profile to NGINX instances or instance groups in NGINX Instance Manager."
weight: 300
toc: true
nd-keywords: "deploy log profile, security log profile, WAF, NGINX Instance Manager, NIM, app protect, instance groups, log profile bundle, tgz, app_protect_security_log, app_protect_security_log_enable, configuration editor"
nd-summary: >
  Deploy a configured F5 WAF for NGINX security log profile to NGINX instances or instance groups in NGINX Instance Manager.
  A log profile must be deployed before it can capture security events on your NGINX instances.
  If the log profile has not yet been compiled for the target WAF compiler version, NGINX Instance Manager automatically compiles it into a bundle before deployment.
nd-audience: operator
---

## Overview

Use this guide to deploy a security log profile to NGINX instances or instance groups in NGINX Instance Manager. A log profile does not capture security events until it is deployed. You can deploy a log profile directly from the Log Profiles screen, or as part of editing the NGINX configuration for an instance or instance group.

---

## Before you begin

Before you begin, ensure you have:

- **A configured log profile**: A log profile already created and saved in NGINX Instance Manager. See [Configure a log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}}).
- **A target instance or instance group**: One or more NGINX instances or instance groups registered in NGINX Instance Manager to deploy the log profile to.
- **NGINX Instance Manager access**: An account with sufficient permissions to deploy WAF log profiles. See [Manage roles and permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).

---

## Deploy a log profile

1. In NGINX Instance Manager, select **WAF** > **Log Profiles**.

2. Select the log profile that you want to deploy.

3. From **Actions**, select **Deploy**.

   The **Deploy Log Profile** window opens.

4. Confirm the name of the log profile shown. NGINX Instance Manager defaults to the selected log profile.

5. In the **Target** section, select **Instance** or **Instance Group**.

6. In the drop-down menu that appears, select the instance or instance group to deploy to.

7. Choose how to deploy the log profile:

   - **Add a new log profile path**: Specify a new file path where the log profile bundle should be deployed.
   - **Update all log profiles**: Sync all log profiles on the target instance or instance group. This updates all existing log profiles by compiling their latest JSON contents into bundles and deploying them to all existing file paths.

   If the log profile has not already been compiled for the WAF compiler version used by the target instance or instance group, NGINX Instance Manager automatically compiles it into a bundle before deployment.

---

## (Optional) Deploy during configuration editing

You can also deploy a log profile directly when editing the NGINX configuration for an instance or instance group. Use this method to integrate log profile deployment into your regular configuration workflow.

1. In NGINX Instance Manager, select **Instances** or **Instance Groups** and choose the target instance or instance group.

1. Select the **Configuration** tab, then select **Edit Configuration**.

1. Select **Apply security** and select which log profile to deploy.

1. Copy the code snippet with the required directives and paste it into your NGINX configuration. The snippet includes:

   - `app_protect_security_log_enable on`
   - `app_protect_security_log` with the log profile bundle path and destination

   For example:

   ```nginx
   app_protect_security_log_enable on;
   app_protect_security_log /etc/nginx/log-profile-bundle.tgz syslog:server=localhost:514;
   ```

8. Select **Save**, then select **Publish**.

---

## Verify log profile deployment

After deployment, verify that the log profile is active on the target instances or instance groups.

1. Confirm that the NGINX configuration includes the required directives:

   - `app_protect_security_log_enable on`
   - `app_protect_security_log` with the correct log profile bundle path and destination

2. Check that security logs are being generated at the configured destination (file path or syslog server).

3. Review the log entries to confirm they match the format and filter settings configured in the log profile.

To troubleshoot log profile deployment issues, see the [Container-related configuration requirements]({{< ref "/nim/waf-integration/overview.md#container-related-configuration-requirements" >}}) section to ensure volumes and paths are correctly configured.

---

## References

For more information, see:

- [Configure a log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}})
- [Review log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/review-log-profile.md" >}})
- [Compile a security log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/compile-log-profile.md" >}})
- [Security log directives]({{< ref "/waf/logging/security-logs.md#directives-in-nginxconf" >}})
- [Security Logs]({{< ref "/waf/logging/security-logs.md" >}})