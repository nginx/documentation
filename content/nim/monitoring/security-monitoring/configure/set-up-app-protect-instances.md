---
title: Create App Protect WAF instances for Security Monitoring
description: Learn how to set up F5 NGINX App Protect data plane instances for use with
  the NGINX Security Monitoring and NGINX Instance Manager.
toc: true
weight: 100
type: how-to
product: NIM
docs: DOCS-1107
---

## Overview

F5 NGINX Security Monitoring supports the following use cases:

- **Security Monitoring only**: Use only the Security Monitoring module to monitor data from NGINX App Protect WAF instances. You will be able to review the security dashboards to assess potential threats and identify opportunities to fine-tune your policies. Your NGINX App Protect WAF configurations are managed outside of the NGINX Instance Manager context.
- **Security Monitoring and Instance Manager**: Use the Security Monitoring module with the NGINX Instance Manager. In addition to monitoring your application security, you will be able to manage your NGINX App Protect WAF  configurations and security policies in a single location and push pre-compiled updates to an instance or instance group.

---

## Before you begin

Complete the following prerequisites before proceeding with the steps in this guide.

1. If you are new to NGINX App Protect WAF, follow the instructions in the installation and configuration guides to get up and running:

   - [Install NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/admin-guide/install/) on one or more data plane instances. Each data plane instance must have connectivity to the NGINX Instance Manager host.
   - [Configure NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration-overview) according to your needs on each of the data plane instance.

1. Review the dependencies with NGINX App Protect WAF and NGINX Plus.

   {{< include "nim/tech-specs/security-data-plane-dependencies.md" >}}

1. Determine your use case: **Security Monitoring only** or **Security Monitoring and Configuration Management**.
1. [Install the NGINX Security Monitoring module]({{< relref "/nim/monitoring/security-monitoring/install-security-monitoring.md" >}}) and [upload your license]({{< relref "/nim/admin-guide/license/add-license.md" >}}).

---

## Install NGINX Agent

NGINX Agent is a companion daemon for NGINX Open Source or NGINX Plus instance that provides:

- Remote management of NGINX configurations
- Collection and reporting of real-time NGINX performance and operating system metrics
- Notifications of NGINX events

Repeat the steps in this section on each NGINX App Protect WAF data plane host to install and configure NGINX Agent for use with  Security Monitoring. **These settings apply to both of the Security Monitoring use cases.**

1. Use SSH to connect to the data plane host.
1. Install the NGINX Agent package from the NGINX Instance Manager host.

   {{< include "agent/installation/install-agent-api.md" >}}

1. Edit the `/etc/nginx-agent/nginx-agent.conf` file to add the `nap_monitoring` configuration.

   Add the lines below to the end of the file. This enables NGINX Agent to send NGINX App Protect messages to the NGINX Instance Manager management plane.

   ```yaml
   dataplane:
      status:
         # poll interval for data plane status - the frequency the NGINX Agent will query the data plane for changes
         poll_interval: 30s
         # report interval for data plane status - the maximum duration to wait before syncing data plane information if no updates have been observed
         report_interval: 24h
   events:
      # report data plane events back to the management plane
      enable: true
   metrics:
      # specify the size of a buffer to build before sending metrics
      bulk_size: 20
      # specify metrics poll interval
      report_interval: 1m
      collection_interval: 15s
      mode: aggregated

   # OSS NGINX default config path
   # path to aux file dirs can also be added
   config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"

   # Enable reporting NGINX App Protect details to the management plane.
   extensions:
     - nginx-app-protect
     - nap-monitoring

   # Enable reporting NGINX App Protect details to the control plane.
   nginx_app_protect:
      # Report interval for NGINX App Protect details - the frequency the NGINX Agent checks NGINX App Protect for changes.
      report_interval: 15s
      # Enable precompiled publication from the NGINX Instance Manager (true) or perform compilation on the data plane host (false).
      precompiled_publication: true

   # NGINX App Protect Monitoring config
   nap_monitoring:
      # Buffer size for collector. Will contain log lines and parsed log lines
      collector_buffer_size: 50000
      # Buffer size for processor. Will contain log lines and parsed log lines
      processor_buffer_size: 50000
      # Syslog server IP address the collector will be listening to
      syslog_ip: "127.0.0.1"
      # Syslog server port the collector will be listening to
      syslog_port: 514
   ```

1. If the `location /api` directive has not been set up in the `nginx.conf` file, follow the example below to add it:

   ```nginx
   server{
              location /api {
                  api write=on;
                  allow 127.0.0.1;
                  deny all;
              }
   }
   ```

   After adding the directive, restart NGINX to apply the changes:

   ```bash
   sudo systemctl restart nginx
   ```

   {{<important>}}You can change the values of `syslog_ip` and `syslog_port` to meet your needs.
   You must use the same values when configuring logging for the Security Monitoring module. If the `syslog:<server><port>` configuration does not match these settings, the monitoring dashboards will not display any data. Also, the networking changes for NGINX App Protect Version 5 preclude the use of `127.0.0.1` as a syslog server address. For Version 5, the address of the `docker0` interface (typically `192.0.10.1`) or the IP address of the data plane host can be used for the syslog server address.{{</important>}}

   {{<note>}}You can use the NGINX Agent installation script to add the fields for `nginx_app_protect` and `nap_monitoring`:

```bash
# Download install script via API
curl https://<NMS_FQDN>/install/nginx-agent > install.sh

# Use the flag --nap-monitoring to set the child fields for the field 'nap_monitoring', the
# child field values will be set to the values in the example configuration from above. Specify
# the -m | --nginx-app-protect-mode flag to set up management of NGINX App Protect on the instance.
# In the example below we specify 'precompiled-publication' for the flag value which will make the
# config field 'precompiled_publication' set to 'true', if you would like to set the config field
# 'precompiled_publication' to 'false' you can specify 'none' as the flag value.
sudo sh ./install.sh --nap-monitoring true --nginx-app-protect-mode precompiled-publication
```

   {{</note>}}

1. Restart NGINX Agent:

   ``` bash
   sudo systemctl restart nginx-agent
   ```

---

## Create instances for Security Monitoring only

Complete the steps in this section if you are only using the Security Monitoring module to monitor your application security. In this use case, you are **not using Instance Manager** to manage your WAF security policies.

Repeat the steps below on each NGINX App Protect WAF data plane instance.

1. Use SSH to connect to the data plane host.

1. Create a new log format definition file with the name `/etc/app_protect/conf/log_sm.json` and the contents shown below.
   This defines the log format for the Security Monitoring module.

   This configuration sets the maximum accepted request payload to 2048 bytes and the maximum message size to 5k. The latter setting truncates messages larger than 5k.
2. Add character escaping for the used separator `,` to be escaped with its standard URL encoding `%2C`.

   ``` json
   {
       "filter": {
           "request_type": "illegal"
       },
       "content": {
           "format": "user-defined",
           "format_string": "%blocking_exception_reason%,%dest_port%,%ip_client%,%is_truncated_bool%,%method%,%policy_name%,%protocol%,%request_status%,%response_code%,%severity%,%sig_cves%,%sig_set_names%,%src_port%,%sub_violations%,%support_id%,%threat_campaign_names%,%violation_rating%,%vs_name%,%x_forwarded_for_header_value%,%outcome%,%outcome_reason%,%violations%,%violation_details%,%bot_signature_name%,%bot_category%,%bot_anomalies%,%enforced_bot_anomalies%,%client_class%,%client_application%,%client_application_version%,%transport_protocol%,%uri%,%request%",
           "escaping_characters": [
               {
                   "from": ",",
                   "to": "%2C"
               }
           ],
           "max_request_size": "2048",
           "max_message_size": "5k",
           "list_delimiter": "::"
       }
   }
   ```

1. Find the context in your NGINX configuration where NGINX App Protect WAF logging is enabled.
   In the same context, add the `app_protect_security_log` directive shown in the example below to configure attack data logging for use with the Security Monitoring dashboards.

   ```nginx
      app_protect_security_log_enable on;
      app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;
   ```

   {{<important>}}The `syslog:server=<syslog_ip>:<syslog_port>` must match the `syslog_ip` and `syslog_port` values specified in the [NGINX Agent configuration file](#agent-config). The dashboards won't display any data if these settings don't match. Also, the networking changes for NGINX App Protect Version 5 preclude the use of `127.0.0.1` as a syslog server address. For Version 5, the address of the `docker0` interface (typically `192.0.10.1`) or the IP address of the data plane host can be used for the syslog server address.{{</important>}}

1. Restart NGINX Agent and the NGINX web server.

   ```bash
   sudo systemctl restart nginx-agent
   sudo systemctl restart nginx
   ```

You should now be able to view data from your NGINX App Protect instances in the NGINX Security Monitoring dashboards.

---

## Create instances for Security Monitoring with Instance Manager

Complete the steps in this section if you want to use the Security Monitoring module **and** Instance Manager. In this use case, you will use NGINX Instance Manager to monitor threats and to manage your NGINX App Protect WAF configurations and security policies.

Take the steps below to update your NGINX App Protect WAF configurations by using Instance Manager.

1. Log in to the NGINX Instance Manager user interface and go to **Modules** > **Instance Manager**.
1. Select **Instances** or **Instance Groups**, as appropriate.
1. Select **Edit Config** from the **Actions** menu for the desired instance or instance group.
1. Next, edit the desired configuration file. You will add directives that reference the security policies bundle and enable the NGINX App Protect WAF logs required by the Security Monitoring dashboards. An example configuration is provided below.

   ```nginx
      app_protect_enable on;
      app_protect_enable on;
      app_protect_policy_file "/etc/nms/NginxDefaultPolicy.tgz";
      app_protect_security_log_enable on;
      app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
   ```

   - Add the `app_protect_policy_file` directive with a reference to a security policy.

      The policy reference must use the `.tgz` file extension when using Instance Manager to perform precompiled publication of NGINX App Protect WAF policies and log profiles. The file path referenced must exist on the NGINX Instance Manager host, but it's ok if the policy file doesn't exist yet. If your Instance is not configured for precompiled publication, then use the `.json` file extension for polcies and log profiles. In this case, the file path referenced in the NGINX configuration must reside on the Instance.

      If you are using custom security policies, at this stage, it's fine to use the default security policy shown in the example above. After completing the steps in this guide, refer to the instructions in [Set Up App Protect WAF Configuration Management]({{< relref "/nim/nginx-app-protect/setup-waf-config-management#add-waf-config" >}}) to add your custom security policy files to NGINX Instance Manager and update your NGINX configuration.

   - Add the `app_protect_security_log_enable on` and the `app_protect_security_log` directive to any NGINX context where NGINX App Protect WAF is enabled and you want to be able to review attack data.

      The logging configuration must reference `"/etc/nms/secops_dashboard.tgz"`, as shown in the example.

      If the `app_protect_security_log_enable` setting is already present, just add the `app_protect_security_log` beneath it in the same context.

      {{<important>}}The `syslog:server=<syslog_ip>:<syslog_port>` must match the `syslog_ip` and `syslog_port` values specified in the [NGINX Agent configuration file](#agent-config). The Security Monitoring dashboards won't display any data if these settings don't match. Also, the networking changes for NGINX App Protect Version 5 preclude the use of `127.0.0.1` as a syslog server address. For Version 5, the address of the `docker0` interface (typically `192.0.10.1`) or the IP address of the data plane host can be used for the syslog server address.{{</important>}}

1. Select **Publish** to immediately push the configuration file updates out to your NGINX instance or instance group.

You should now be able to view data from your NGINX App Protect WAF instances in the Security Monitoring dashboard.

## See also

- [Grant Users Access to the Security Monitoring Dashboards]({{< relref "create-role-security-monitoring" >}}): Follow the steps in this guide to allow other users in your organization to access the Security Monitoring Dashboards.

- If you are using Security Monitoring with Instance Manager, proceed to the [Set Up App Protect WAF Configuration Management]({{< relref "/nim/nginx-app-protect/setup-waf-config-management" >}}) guide.
