---
title: Upgrade F5 WAF for NGINX on Managed Instances
description: How to Upgrade F5 F5 WAF for NGINX on managed NGINX instances
weight: 300
toc: true
nd-docs: DOCS-1198
---

## Overview

Learn how to upgrade F5 NGINX App Protect on your managed NGINX instances using NGINX Instance Manager. This guide covers the steps to update both the NGINX Management Suite server and NGINX App Protect on the data plane, ensuring your security policies and configurations are up-to-date.

Before starting, confirm that your data plane has the latest NGINX Agent compatible with NGINX App Protect. Also, verify that your NGINX Management Suite server has the [WAF compiler installed]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}). If you're updating the WAF compiler, simply upload the F5 WAF for NGINX certificate and key to NGINX Management Suite following the instructions to [Automatically Download and Install New WAF Compiler]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#automatically-download-and-install-new-waf-compiler" >}}).

## Upgrade WAF Compiler on NGINX Management Suite

Upgrade NGINX App Protect by installing the new version of _nms-nap-compiler_ on the NGINX Management Suite server. Keep the current version installed to maintain support for ongoing policy updates during the upgrade.

Ensure the **nms-integrations** service recognizes both the new and existing _nms-nap-compiler_ versions. Complete this step before upgrading NGINX App Protect on your data planes.

For details on matching F5 WAF for NGINX releases with their WAF compiler versions, refer to the the [WAF Compiler and Supported App Protect Versions]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}) topic.

## Upgrade NGINX App Protect on the Data Plane

Before you start, make sure you're using NGINX Management Suite for your policy management. Your NGINX configuration should be set up to use WAF policies with a _.tgz_ extension.

To update NGINX App Protect on an NGINX data plane instance, follow these steps:

1. **Stop the NGINX Agent**: Begin the upgrade process by stopping the NGINX Agent. This action prevents any ongoing processes from interfering with the upgrade.

2. **Upgrade NGINX App Protect**: Proceed to upgrade your NGINX App Protect. For detailed instructions on deployment and upgrading, refer to the [F5 WAF for NGINX Administration Guide](https://docs.nginx.com/nginx-app-protect-waf/admin-guide/install/). This guide provides information essential for a successful upgrade.

3. **Restart NGINX App Protect**: After upgrading, restart NGINX App Protect to implement the new updates.

4. **Restart NGINX Agent**: Concluding the upgrade, restart the NGINX Agent.

Refer to the [F5 WAF for NGINX Release Notes]({{< ref "/nap-waf/v4/releases" >}}) to determine the correct package version for installation. It's important to adjust the version string in the provided commands to match your specific operating system version.

### Debian, Ubuntu

For Debian and Ubuntu:

1. Begin by stopping the NGINX Agent:

   ```bash
   sudo systemctl stop nginx-agent
   ```

2. Upgrade NGINX App Protect by running:

   ```bash
   sudo apt-get install app-protect
   ```

3. Next, restart NGINX App Protect to apply the upgrade:

   ```bash
   sudo systemctl restart nginx-app-protect
   ```

4. Complete the process by restarting the NGINX Agent:

   ```bash
   sudo systemctl restart nginx-agent
   ```

### CentOS, RHEL. and Other Systems

For CentOS, RHEL, and Other Systems:

1. Stop the NGINX Agent:

   ```bash
   sudo systemctl stop nginx-agent
   ```

2. Next, upgrade NGINX App Protect. Refer to the [F5 WAF for NGINX Administration Guide]({{< ref "/nap-waf/v4/admin-guide/install.md" >}}) for detailed information on how to deploy and upgrade F5 WAF for NGINX.

3. After the upgrade, restart NGINX App Protect:

   ```bash
   sudo systemctl restart nginx-app-protect
   ```

4. Finally, restart the NGINX Agent:

   ```bash
   sudo systemctl restart nginx-agent
   ```

## Verify the Upgrade

Here's how you can verify if the upgrade was successful:

- **Check NGINX App Protect version**: Confirm the upgrade by checking the 'build' version of NGINX App Protect in Instance Manager. Ensure the details reflect the latest deployment and status. Use the command:

   ``` bash
   sudo more /etc/nms/app_protect_metadata.json
   ```

- **Check NGINX status**: To confirm NGINX is running, use this command:

   ``` bash
   sudo systemctl status nginx
   ```
