---
description: Learn about the F5 NGINX App Protect WAF Logs Overview.
nd-docs: DOCS-911
title: NGINX App Protect WAF Logs Overview
toc: true
weight: 510
type:
- concept
---

## Overview

There are 3 types of logs that F5 NGINX App Protect on NGINX generates:
- [Security log or Request log]({{< ref "/nap-waf/v4/logging-overview/security-log" >}}): The HTTP requests and how App Protect processed them, including violations and signatures found.
- [Operation logs]({{< ref "/nap-waf/v4/logging-overview/operation-logs" >}}): Events such as startup, shutdown and reconfiguration.
- [Debug logs]({{< ref "/nap-waf/v4/logging-overview/debug-logs" >}}): technical messages at different levels of severity used to debug and resolve incidents and error behaviors.

In addition, NGINX App Protect WAF can be configured to add additional data to NGINX [Access log]({{< ref "/nap-waf/v4/logging-overview/access-log" >}}).

Note that NGINX does not have audit logs in the sense of who did what. This can be done either from the orchestration system controlling NGINX (such as NGINX Controller) or by tracking the configuration files and the systemd invocations using Linux tools.

App Protect uses its own logging mechanism for request logging rather than NGINX's access logging mechanism (which is NGINX's default logging mechanism).

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Type | Log Configuration | Configuration contexts | File Destination | Syslog Destination |
| ---| ---| ---| ---| --- |
|Security | `app_protect_security_log` directive referencing `security_log.json` file | `nginx.conf`: http, server, location | Yes, either `stderr`, or an absolute path to a local file are supported | Yes |
|Operation | `error_log` directive, part of core NGINX | `nginx.conf` - global | Yes, NGINX error log | Yes, NGINX error log |
|Debug | `/etc/app_protect/bd/logger.cfg.` Log file name is the redirection in the invocation of the bd command line in the start script | Global (not part of nginx.conf) | Yes. Log file is in `/var/log/app_protect` default debug directory.  No file rotation currently | No |

{{</bootstrap-table>}}

## Log Rotate

NGINX App Protect WAF supports log rotation.
If you already have logrotate running, NGINX App Protect WAF log files will be rotated automatically according to the configuration file described below.
To install logrotate:

For CentOS:

  ```shell
  sudo yum install logrotate
  ```

For Debian / Ubuntu:

  ```shell
  sudo apt-get install logrotate
  ```

For Alpine:

  ```shell
  sudo apk add logrotate
  ```

By default the logrotate configuration file included in NGINX App Protect WAF is:

```none
/var/log/app_protect/*.log {
        size 1M
        copytruncate
        notifempty
        create 644 nginx nginx
        rotate 20
}
```

- size _size_ - log files are rotated only if they grow larger than size.
- copytruncate - truncate the original log file in place after creating a copy, instead of moving the old log file and creating a new one.
- create _mode owner group_ - the log file is created immediately after rotation with the permissions specified by _mode_. _owner_ specifies the user name who will own the log file, and _group_ specifies the group the log file will belong to.
- rotate _count_ - log files are rotated count times before being removed.

You can modify the attributes and add directories to rotate in `/etc/logrotate.d/app_protect.conf`.

Normally you would run logrotate periodically using a cron job. For more information about logrotate refer to [Linux man page](https://linux.die.net/man/8/logrotate).

All logs in the `/var/log/app_protect/` folder will be rotated, including the security log, if the file destination is configured to be under this directory.

Example of configuring security log to be under `/var/log/app_protect/`:

In `/etc/nginx/nginx.conf`:

  ```none
  app_protect_security_log_enable on;
  app_protect_security_log "/opt/app_protect/share/defaults/log_illegal.json" /var/log/app_protect/security.log;
  ```

{{< call-out "note" >}} The log rotation policy is provided as a default policy. Users can customize to adapt to their need. {{< /call-out >}}
