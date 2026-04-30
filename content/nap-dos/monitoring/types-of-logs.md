---
title: Logs overview
description: "Overview of the four log types in F5 DoS for NGINX: security, operation, request, and debug logs, with configuration and destination options."
keywords: "F5 DoS for NGINX, logs, security log, operation log, request log, debug log, monitoring, logging"
nd-docs: DOCS-671
toc: true
weight: 130
nd-content-type: reference
nd-product: F5DOSN
---

F5 DoS for NGINX has four log types:

- [Security log](#security-log): The overall picture of the site and how F5 DoS for NGINX processed it, including anomalies and signatures found.
- [Operation log](#operation-log): Events such as configuration errors or warnings.
- [Request log](#request-log): Per-request information added to the NGINX access log.
- [Debug log](#debug-log): Technical messages at different severity levels used to debug and resolve issues.

{{< call-out "note" >}}
NGINX does not have audit logs in the sense of *"**who** did **what**"*. This can be done either from the orchestration system controlling NGINX (such as NGINX Controller) or by tracking the configuration files and the systemd invocations using Linux tools.
{{< /call-out >}}

 {{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Type|Log Configuration| Configuration Contexts| File Destination| Syslog Destination |
|----|-----------------|-----------------------|-----------------|--------------------|
| Debug | Log file name is the redirection in the invocation of the `admd` command line in the start script | Global (not part of `nginx.conf`)|Yes. Log file is in /var/log/adm/admd.log directory. There is currently no file rotation capability available for this log.|  No |
|  Operation  |  `error_log` directive, part of core NGINX | `nginx.conf` - global | Yes, NGINX error log | Yes, NGINX error log   |
|Request |NGINX has two directives for the access log: <br> - **access_log** - to turn [on\|off] <br> - **log_format** - to specify the required information regarding each request <br><br> F5 DoS for NGINX has several variables that can be added to the log_format directive, such as $app_protect_dos_outcome. <br><br> For more information refer to [F5 DoS for NGINX Access Log]({{< ref "/nap-dos/monitoring/access-log.md" >}}) | `nginx.conf` - global| Yes, NGINX access log | Yes, NGINX access log |
| Security  | F5 DoS for NGINX has two directives in `nginx.conf`: <br> - `app_protect_dos_security_log_enable` to turn logging on or off <br> - `app_protect_dos_security_log` to set its logging configuration and destination <br><br> For more information see: <br> - **Configuration**: [Directives and Policy]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md">}}) <br> - **Usage**: [F5 DoS for NGINX Security Log]({{< ref "/nap-dos/monitoring/security-log.md" >}}) | `nginx.conf`: http, server, location  | Yes — either stderr or an absolute file path | Yes |

 {{</bootstrap-table>}}

## Security log

The security log contains information about protected objects: traffic intensity, backend health, learning progress, and active mitigations. For more information, see [F5 DoS for NGINX Security Log]({{< ref "/nap-dos/monitoring/security-log.md" >}}).

## Operation log

The operation log contains system operational and health events. Events are sent to the NGINX error log with the `APP_PROTECT_DOS` prefix followed by a JSON body. The log level depends on the event: success is usually `notice`; failure is `error`. The timestamp comes from the error log. For more information, see [Operation Log]({{< ref "/nap-dos/monitoring/operation-log.md" >}}).

## Request Log
 Access log is NGINX’s request log mechanism. It is controlled by two directives.

### log_format
 This directive determines the format of the log messages using predefined variables. App Protect DoS will enrich this set of variables with several security log attributes that are available to be included in the `log_format`. If `log_format` is not specified then the built-in format `combined` is used but, because that format does not include the extended App Protect DoS variables, this directive must be used when the user wants to add App Protect DoS information to the log.

### access_log
This directive determines the destination of the `access_log` and the name of the format. The default is the file `/var/log/nginx/access.log` using the combined format. In order to use the custom format that includes the F5 DoS for NGINX variables, use this directive with the name of the desired format.

### App Protect DoS Variables
These are the variables added to Access Log. They are a subset of the Security log attributes. The Security log names are prefixed with `$app_protect_dos`. <br> For more information refer to [F5 DoS for NGINX Access Log]({{< ref "/nap-dos/monitoring/access-log.md" >}})

## Debug log

Use the debug log to troubleshoot F5 DoS for NGINX. The log is always at `/var/log/adm/admd.log`.

Available log levels are `error`, `warning`, `info`, and `debug`. The default is `info`.

To change the log level at runtime, run:

```shell
admd -l DEBUG_LEVEL
```

{{< call-out "note" >}}
`nginx.conf` does not refer to the F5 DoS for NGINX debug log configuration neither directly nor indirectly.
{{< /call-out >}}

## NGINX error log

Use the NGINX error log to troubleshoot the configuration of F5 DoS for NGINX.

The file is `error.log`. Its path and debug level are set in `nginx.conf` by the `error_log` directive.

For example:

```shell
error_log /var/log/nginx/error.log debug;
```
