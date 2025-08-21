---
title: Upgrade F5 WAF for NGINX on Managed Instances
weight: 600
toc: true
type: how-to
product: NAP-WAF
nd-docs: DOCS-1640
---

## Overview

Learn how to upgrade F5 F5 WAF for NGINX on your managed NGINX instances using NGINX Instance Manager. This guide covers the steps to update both the NGINX Management Suite server and NGINX App Protect on the data plane, ensuring your security policies and configurations are up-to-date.

Before starting, confirm that your data plane has the latest NGINX Agent compatible with NGINX App Protect. Also, verify that your NGINX Management Suite server has the [WAF compiler installed]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}). If you're updating the WAF compiler, simply upload the F5 WAF for NGINX certificate and key to NGINX Management Suite following the instructions to [Automatically Download and Install New WAF Compiler]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#automatically-download-and-install-new-waf-compiler" >}}). The compiler version may not be greater than the enforcer one.

if you're updating the WAF enforcer, make sure that its major version is the same as of the WAF compiler and the minor version is greater than the compiler's.

## Upgrade WAF Compiler on NGINX Management Suite

Upgrade NGINX App Protect by installing the new version of _nms-nap-compiler_ on the NGINX Management Suite server. Keep the current version installed to maintain support for ongoing policy updates during the upgrade.

Ensure the **nms-integrations** service recognizes both the new and existing _nms-nap-compiler_ versions. Complete this step before upgrading NGINX App Protect on your data planes.

For details on matching F5 WAF for NGINX releases with their WAF compiler versions, refer to the the [WAF Compiler and Supported App Protect Versions]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}) topic.

## Upgrade NGINX App Protect on the Data Plane

Before you start, make sure you're using NGINX Management Suite for your policy management. Your NGINX configuration should be set up to use WAF policies with a _.tgz_ extension.

To update NGINX App Protect on an NGINX data plane instance, follow these steps:

1. **Stop the NGINX Agent**: Begin the upgrade process by stopping the NGINX Agent. This action prevents any ongoing processes from interfering with the upgrade.

2. **Upgrade NGINX App Protect**: Proceed to upgrade your NGINX App Protect. For detailed instructions on deployment and upgrading, refer to the [F5 WAF for NGINX Administration Guide]({{< ref "nap-waf/v5/admin-guide/install.md" >}}). This guide provides information essential for a successful upgrade.

3. **Restart NGINX App Protect**: After upgrading, restart NGINX App Protect to implement the new updates.

4. **Restart NGINX Agent**: Concluding the upgrade, restart the NGINX Agent.

Refer to the [F5 WAF for NGINX Release Notes]({{< ref "/nap-waf/v5/releases" >}}) to determine the correct package version for installation. It's important to adjust the version string in the provided commands to match your specific operating system version.

## Verify the Upgrade

Here's how you can verify if the upgrade was successful:

- **Check NGINX App Protect Version**: Confirm the upgrade by checking the 'build' version of NGINX App Protect in Instance Manager. Ensure the details reflect the latest deployment and status. Use the command:

   ``` bash
   sudo more /etc/nms/app_protect_metadata.json
   ```

- **Check NGINX status**: To confirm NGINX is running, use this command:

   ``` bash
   sudo systemctl status nginx
   ```
