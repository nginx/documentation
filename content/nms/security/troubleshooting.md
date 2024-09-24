---
description: This topic describes possible issues users might encounter when using
  the Security Monitoring module. When possible, suggested workarounds are provided.
docs: DOCS-1226
doctypes:
- reference
tags:
- docs
title: Troubleshooting
toc: true
weight: 1000
---

## Security Event log backup with Security Monitoring

### Description

If a Security Violation event is not received by the Security Monitoring module, the data representing the attack is lost.

### Resolution

F5 NGINX App Protect supports logging to multiple destinations, enabling the user to send a log to NGINX agent and a copy to be stored as a backup. In the event of a failure to receive Security Events in Security Monitoring, the backup log can be checked to verify attack details. Change the settings below to enable backup logging:

1. Instance with Security Monitoring only

```nginx
app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json";
app_protect_security_log_enable on;
app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;
app_protect_security_log "/etc/app_protect/conf/log_sm.json" <Path to store log file>;
# Example: app_protect_security_log "/etc/app_protect/conf/log_sm.json" /var/log/app_protect/security.log;
```

1. Instance with Security Monitoring and Instance Manager

```nginx
app_protect_policy_file "/etc/nms/NginxDefaultPolicy.tgz";
app_protect_security_log_enable on;
app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
app_protect_security_log "/etc/nms/secops_dashboard.tgz" <Path to store log file>;
# Example: app_protect_security_log "/etc/nms/secops_dashboard.tgz" /var/log/app_protect/security.log;
```

---

## How to Get Support

{{< include "support/how-to-get-support.md" >}}

