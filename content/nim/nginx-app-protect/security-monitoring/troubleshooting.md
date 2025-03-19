---
title: Troubleshooting
weight: 500
toc: true
type: how-to
product: NIM
docs: DOCS-1226
---

## Security event log backup with Security Monitoring

### Description

If a Security Violation event is not received by the Security Monitoring module, the attack data is lost.

### Resolution

F5 NGINX App Protect supports logging to multiple destinations. This allows users to send logs to the NGINX agent and store a backup. If Security Monitoring fails to receive Security Events, you can check the backup log to verify attack details. Use the following settings to enable backup logging:

1. **For an instance with Security Monitoring only:**

   ```nginx
   app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json";
   app_protect_security_log_enable on;
   app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;
   app_protect_security_log "/etc/app_protect/conf/log_sm.json" <Path to store log file>;
   # Example: app_protect_security_log "/etc/app_protect/conf/log_sm.json" /var/log/app_protect/security.log;
   ```

2. **For an instance with Security Monitoring and NGINX Instance Manager:**

   ```nginx
   app_protect_policy_file "/etc/nms/NginxDefaultPolicy.tgz";
   app_protect_security_log_enable on;
   app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
   app_protect_security_log "/etc/nms/secops_dashboard.tgz" <Path to store log file>;
   # Example: app_protect_security_log "/etc/nms/secops_dashboard.tgz" /var/log/app_protect/security.log;
   ```

---

## How to get support

{{< include "support/how-to-get-support.md" >}}
