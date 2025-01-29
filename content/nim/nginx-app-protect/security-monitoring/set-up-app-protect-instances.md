---
title: Set up App Protect WAF instances for Security Monitoring
weight: 100
toc: true
type: how-to
product: NIM
docs: DOCS-1107
---

## Overview

F5 NGINX Security Monitoring supports two main use cases:

- **Security Monitoring only**: Monitor data from NGINX App Protect WAF instances. You can view security dashboards to identify threats and adjust policies. WAF configurations are managed outside NGINX Instance Manager.
- **Security Monitoring and Instance Manager**: Monitor security data and manage WAF configurations and policies in one place. Push pre-compiled updates to individual instances or groups.

---

## Before you begin

Complete these steps before starting:

1. If you’re new to NGINX App Protect WAF, follow these guides:

   - [Install NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/admin-guide/install/) on each data plane instance. Ensure connectivity to the NGINX Instance Manager host.
   - [Configure NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration-overview) as needed for each instance.

2. Review NGINX App Protect WAF dependencies:

   {{< include "nim/tech-specs/security-data-plane-dependencies.md" >}}

3. Determine your use case: **Security Monitoring only** or **Security Monitoring and Configuration Management**.

---

## Install NGINX Agent

NGINX Agent collects metrics, manages configurations, and sends events. Install and configure it on each WAF data plane host.

1. Connect to the host via SSH.
2. Install the NGINX Agent package from the NGINX Instance Manager host:

   {{< include "agent/installation/install-agent-api.md" >}}

3. Edit `/etc/nginx-agent/nginx-agent.conf` to enable `nap_monitoring`. Add this configuration:

   ```yaml
   dataplane:
      status:
         poll_interval: 30s
         report_interval: 24h
   events:
      enable: true
   metrics:
      bulk_size: 20
      report_interval: 1m
      collection_interval: 15s
      mode: aggregated
   config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"
   extensions:
      - nginx-app-protect
      - nap-monitoring
   nginx_app_protect:
      report_interval: 15s
      precompiled_publication: true
   nap_monitoring:
      collector_buffer_size: 50000
      processor_buffer_size: 50000
      syslog_ip: "127.0.0.1"
      syslog_port: 514
   ```

4. If `location /api` isn’t configured in `nginx.conf`, add this directive:

   ```nginx
   server {
      location /api {
         api write=on;
         allow 127.0.0.1;
         deny all;
      }
   }
   ```

   Restart NGINX:

   ```bash
   sudo systemctl restart nginx
   ```

5. **Important:** The `syslog:server=<syslog_ip>:<syslog_port>` must match the `syslog_ip` and `syslog_port` values in the NGINX Agent configuration file. The dashboards won’t display data if these settings don’t match. 

   - For NGINX App Protect Version 5, networking changes prevent using `127.0.0.1` as a syslog server address. Instead, use the `docker0` interface address (typically `192.0.10.1`) or the IP address of the data plane host.

6. Use the NGINX Agent installation script to add `nginx_app_protect` and `nap_monitoring` fields to the configuration. Follow these steps:

   ```bash
   # Download the installation script via API
   curl https://<NMS_FQDN>/install/nginx-agent > install.sh

   # Use the --nap-monitoring flag to set the child fields for nap_monitoring.
   # The values will match the example configuration above.
   # Use -m | --nginx-app-protect-mode to set up NGINX App Protect management.
   # Example: Specify 'precompiled-publication' for precompiled policy publication,
   # which sets 'precompiled_publication' to 'true'. To set it to 'false', use 'none'.

   sudo sh ./install.sh --nap-monitoring true --nginx-app-protect-mode precompiled-publication
   ```

   {{<note>}}The `--nap-monitoring` flag adds fields under `nap_monitoring`. The `--nginx-app-protect-mode` flag sets up management of NGINX App Protect with the following options:
   - Use `precompiled-publication` to enable precompiled policy publication (`precompiled_publication: true`).
   - Use `none` if you don’t want to enable precompiled publication (`precompiled_publication: false`).{{</note>}}

7. Restart the NGINX Agent:

   ```bash
   sudo systemctl restart nginx-agent
   ```

---

## Create instances for Security Monitoring only

Use these steps if you’re only monitoring security data without managing configurations in NGINX Instance Manager.

1. Connect to the data plane host via SSH.
2. Create a log format file at `/etc/app_protect/conf/log_sm.json`:

   ```json
   {
      "filter": {
         "request_type": "illegal"
      },
      "content": {
         "format": "user-defined",
         "format_string": "%blocking_exception_reason%,%dest_port%,%ip_client%,%severity%,%uri%",
         "escaping_characters": [
            {
               "from": ",",
               "to": "%2C"
            }
         ],
         "max_request_size": "2048",
         "max_message_size": "5k"
      }
   }
   ```

3. In the NGINX configuration, add:

   ```nginx
   app_protect_security_log_enable on;
   app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;
   ```

4. Restart NGINX Agent and NGINX:

   ```bash
   sudo systemctl restart nginx-agent
   sudo systemctl restart nginx
   ```

---

## Create instances for Security Monitoring with Instance Manager

Follow these steps to use Security Monitoring and Instance Manager together.

1. Log in to the NGINX Instance Manager interface.
2. Navigate to **Modules** > **Instance Manager**.
3. Select **Edit Config** for the desired instance or group.
4. Add the following to the configuration file:

   ```nginx
   app_protect_enable on;
   app_protect_policy_file "/etc/nms/NginxDefaultPolicy.tgz";
   app_protect_security_log_enable on;
   app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
   ```

5. **Important:** Add the `app_protect_policy_file` directive with a reference to a security policy. Use the `.tgz` file extension for precompiled publication or `.json` for non-precompiled configurations. Ensure the policy file exists at the specified location. If using custom policies, update them in NGINX Instance Manager.

6. Add the `app_protect_security_log_enable` and `app_protect_security_log` directives to log attack data. Ensure the configuration references the correct `syslog:server` values.

7. Select **Publish** to push updates to instances.

---

## See also

- [Add user access to Security Monitoring dashboards]({{< relref "/nim/nginx-app-protect/security-monitoring/give-access-to-security-monitoring-dashboards.md" >}})
- [Manage your app protect WAF configs]({{< relref "/nim/nginx-app-protect/setup-waf-config-management" >}})
