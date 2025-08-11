---
description: Learn about the F5 NGINX App Protect DoS Logs Overview.
nd-docs: DOCS-671
title: NGINX App Protect DoS Logs Overview
toc: true
weight: 130
type:
- how-to
---

There are 4 types of logs corresponding to App Protect DoS:

- [Security Log](#security-log): The general picture of the site and how App Protect DoS processed it, including anomalies and signatures found.
- [Operation Log](#operation-log): Events such as configuration errors or warnings.
- [Debug Logs](#debug-log): Technical messages at different levels of severity used to debug and resolve incidents and error behaviors.
- [Request Logging](#request-log): F5 NGINX App Protect DoS adds information to each request logged to NGINX's access logging mechanism.

{{< call-out "note" >}}
NGINX does not have audit logs in the sense of *"**who** did **what**"*. This can be done either from the orchestration system controlling NGINX (such as NGINX Controller) or by tracking the configuration files and the systemd invocations using Linux tools.
{{< /call-out >}}

 {{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Type|Log Configuration| Configuration Contexts| File Destination| Syslog Destination |
|----|-----------------|-----------------------|-----------------|--------------------|
| Debug | Log file name is the redirection in the invocation of the `admd` command line in the start script | Global (not part of `nginx.conf`)|Yes. Log file is in /var/log/adm/admd.log directory. There is currently no file rotation capability available for this log.|  No |
|  Operation  |  `error_log` directive, part of core NGINX | `nginx.conf` - global | Yes, NGINX error log | Yes, NGINX error log   |
|Request |NGINX has two directives for the access log: <br> - **access_log** - to turn [on\|off] <br> - **log_format** - to specify the required information regarding each request <br><br> NGINX App Protect DoS has several variables that can be added to the log_format directive, such as $app_protect_dos_outcome. <br><br> For more information refer to [NGINX App Protect DoS Access Log]({{< ref "/nap-dos/monitoring/access-log.md" >}}) | `nginx.conf` - global| Yes, NGINX access log | Yes, NGINX access log |
| Security  | NGINX App Protect DoS has two directives in `nginx.conf`: <br> - app_protect_dos_security_log_enable to turn logging [on\|off] <br> - app_protect_dos_security_log to set it's logging configuration and destination <br><br> For more information refer: <br> - **Configuration**: [App Protect DoS - Directives and Policy]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md">}}) <br> - **Usage**: [NGINX App Protect DoS - Security Log]({{< ref "/nap-dos/monitoring/security-log.md" >}}) | `nginx.conf`: http, server, location  | Yes, either stderr, or an absolute path to a local file are supported | Yes |

 {{</bootstrap-table>}}

## Security Log
 The security logs contain information about the status of the protected objects. It gives a general picture about each protected object in terms of traffic intensity, health of the backend server, learning and mitigations. For more information refer to [NGINX App Protect DoS Security Log]({{< ref "/nap-dos/monitoring/security-log.md" >}}) documentation.

## Operation Log
 The operation logs consists of system operational and health events. The events are sent to the NGINX error log and are distinguished by the `APP_PROTECT_DOS` prefix followed by JSON body. The log level depends on the event: success is usually indicated by `notice`, while failure is indicated by `error`. The timestamp is inherent in the error log. For more information refer to [App Protect DoS Operation Log]({{< ref "/nap-dos/monitoring/operation-log.md" >}}) documentation.

## Request Log
 Access log is NGINX’s request log mechanism. It is controlled by two directives.

### log_format
 This directive determines the format of the log messages using predefined variables. App Protect DoS will enrich this set of variables with several security log attributes that are available to be included in the `log_format`. If `log_format` is not specified then the built-in format `combined` is used but, because that format does not include the extended App Protect DoS variables, this directive must be used when the user wants to add App Protect DoS information to the log.

### access_log
This directive determines the destination of the `access_log` and the name of the format. The default is the file `/var/log/nginx/access.log` using the combined format. In order to use the custom format that includes the NGINX App Protect DoS variables, use this directive with the name of the desired format.

### App Protect DoS Variables
These are the variables added to Access Log. They are a subset of the Security log attributes. The Security log names are prefixed with `$app_protect_dos`. <br> For more information refer to [NGINX App Protect DoS Access Log]({{< ref "/nap-dos/monitoring/access-log.md" >}})

## Debug Log - NGINX App Protect DoS
The NGINX App Protect DoS Debug log is used to troubleshoot the functionality of the product. <br>

The path of the log is at a fixed location: `/var/log/adm/admd.log`.

There are several log levels - `error`, `warning`, `info` and `debug`. The default is `info`.

In order to change the log level at run time, the following command can be called:

```shell
admd -l DEBUG_LEVEL
```

{{< call-out "note" >}}
`nginx.conf` does not refer to the NGINX App Protect DoS debug log configuration neither directly nor indirectly.
{{< /call-out >}}

## NGINX Error log

The NGINX Error log is used to troubleshoot the configuration portion of NGINX App Protect DoS.

The file is called `error.log` and its path and debug level is determined in `nginx.conf` by the directive `error_log`. <br>

For example:

```shell
error_log /var/log/nginx/error.log debug;
```
