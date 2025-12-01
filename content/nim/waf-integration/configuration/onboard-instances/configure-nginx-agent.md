---
title: Configure NGINX Agent
description: Update the NGINX Agent configuration to enable F5 WAF for NGINX.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIMNGR
nd-docs:
---

{{< call-out "note" "Before you begin" >}}
- [Install NGINX Agent]({{< ref "/nim/waf-integration/configuration/onboard-instances/install-nginx-agent.md" >}})
{{< /call-out >}}

Follow these steps to enable F5 WAF for NGINX in NGINX Agent.

1. Edit the NGINX Agent configuration file.

   Use any text editor. For example:

   ```shell
   sudo vi /etc/nginx-agent/nginx-agent.conf
   ```

1. Add or confirm the following settings:

   ```yaml
   config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"
   extensions:
     - nginx-app-protect
   nginx_app_protect:
     report_interval: 15s
     precompiled_publication: true
   ```

   These settings:

   - Let NGINX Agent read F5 WAF for NGINX configuration directories.
   - Enable change detection for security configurations.
   - Turn on precompiled publication of WAF configurations from NGINX Instance Manager.

   To apply these settings during installation, use the `--nginx-app-protect-mode` flag:

   ```shell
   curl https://<NIM_FQDN>/install/nginx-agent > install.sh
   sudo sh ./install.sh --nginx-app-protect-mode precompiled-publication
   ```

1. Restart NGINX Agent:

   ```shell
   sudo systemctl restart nginx-agent
   ```

{{< call-out "note" "Next steps" >}}
- [Verify the installation]({{< ref "/nim/waf-integration/configuration/onboard-instances/verify-installation.md" >}})
{{< /call-out >}}
