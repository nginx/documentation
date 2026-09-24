---
title: Troubleshooting
weight: 500
toc: true
f5-content-type: reference
f5-product: NGINX Instance Manager
f5-docs: DOCS-1226
description: "Troubleshoot Security Monitoring issues in F5 NGINX Instance Manager when security violation events are not received or dashboards are not populated."
f5-summary: >
  Diagnose and resolve common Security Monitoring issues in F5 NGINX Instance Manager.
  This reference covers the most likely causes when the Security Monitoring module doesn't receive security violation events and how to fix each one.
---

## Security event log backup with Security Monitoring

### Description

If the Security Monitoring module doesn't receive a security violation event, the attack data is lost.

### Resolution

F5 WAF for NGINX supports logging to multiple destinations. You can send logs to NGINX Agent and keep a backup. If Security Monitoring doesn't receive security events, check the backup log to verify attack details. Use the following settings to turn on backup logging:

1. **For an instance with Security Monitoring only:**

   ```nginx
   app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json";
   app_protect_security_log_enable on;
   app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;
   app_protect_security_log "/etc/app_protect/conf/log_sm.json" <Path to store log file>;
   # Example: app_protect_security_log "/etc/app_protect/conf/log_sm.json" /var/log/app_protect/security.log;
   ```

2. **For an instance with Security Monitoring and F5 NGINX Instance Manager:**

   ```nginx
   app_protect_policy_file "/etc/nms/NginxDefaultPolicy.tgz";
   app_protect_security_log_enable on;
   app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
   app_protect_security_log "/etc/nms/secops_dashboard.tgz" <Path to store log file>;
   # Example: app_protect_security_log "/etc/nms/secops_dashboard.tgz" /var/log/app_protect/security.log;
   ```

---

## NGINX Gateway Fabric security events don't appear in the dashboard

### Description

If NGINX Instance Manager doesn't receive security events from a NGINX Gateway Fabric deployment, the Security Monitoring dashboard shows no data for that deployment.

### Resolution

Check the following on NGINX Instance Manager, in order:

1. Confirm the embedded OpenTelemetry collector is turned on. In `nms.conf`, verify `collector_config.enable` is set to `true`:

   ```yaml
      collector_config:
         enable: true
   ```

   If you change this setting, restart the service:

   ```shell
      sudo systemctl restart nms
   ```

2. Confirm NGINX Instance Manager is reachable from the Kubernetes cluster on port `4317` (gRPC).

3. Confirm the log profile referenced in the `WAFPolicy` resource exists in NGINX Instance Manager and matches exactly. A mismatched or missing profile name causes events to arrive without expected fields, or not arrive at all.

If these checks pass and events still don't appear, the problem is likely on the NGINX Gateway Fabric side. See [Security events aren't reaching NGINX Instance Manager]({{< ref "/ngf/waf-integration/troubleshooting.md#security-events-arent-reaching-nginx-instance-manager" >}}) <!-- SME REVIEW: anchor forward-references doc 4, not yet added --> and [Export security logs to F5 NGINX Instance Manager]({{< ref "/ngf/waf-integration/policy-sources.md#export-security-logs-to-f5-nginx-instance-manager" >}}). <!-- SME REVIEW: anchor forward-references doc 6, not yet added -->

---

## How to get support

{{< include "nim/support/how-to-get-support.md" >}}
