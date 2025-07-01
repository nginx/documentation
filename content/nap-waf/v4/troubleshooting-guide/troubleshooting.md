---
description: Learn about the F5 NGINX App Protect WAF Troubleshooting Guide.
nd-docs: DOCS-665
title: NGINX App Protect WAF Troubleshooting Guide
toc: true
weight: 400
type:
- concept
---

## Overview

This Troubleshooting Guide is intended to provide guidance to customers in the detection and correction of programming issues in F5 NGINX App Protect. It may also be useful to IT in resolving any installation or configuration problems. <br>

Refer to the below table for any NGINX App Protect WAF installation or configuration known problems.

## Resolving Known Problems

### Installation

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Problem|Solution|
|-------|--------|
| Starting version 3.12, installation steps and Docker deployment examples were changed in the [Admin Guide]({{< ref "/nap-waf/v4/admin-guide/install.md" >}}). You may encounter one of the following error messages:<br><br># example of yum installation error when the app-protect-security-updates repository is missing:<br><pre><code>`Error: Package: app-protect-compiler-1.234.0-1.el7.ngx.x86_64 (app-protect)`<br>`Requires: app-protect-attack-signatures`<br>`Error: Package: app-protect-compiler-1.234.0-1.el7.ngx.x86_64 (app-protect)`<br>`Requires: app-protect-threat-campaigns`</code></pre><br># example of apt installation error when the app-protect-security-updates repository is missing:<br><pre><code>`The following packages have unmet dependencies:`<br>`app-protect-compiler : Depends: app-protect-attack-signatures`<br> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; `Depends: app-protect-threat-campaigns`<br>`Error: Unable to correct problems, you have held broken packages.`</pre></code>| Enable the [app-protect-security-updates repository]({{< ref "/nap-waf/v4/admin-guide/install.md#updating-app-protect-attack-signatures" >}}). |
{{</bootstrap-table>}}

### Configuration

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Problem|Solution|
|-------|--------|
| NGINX is not running (ps -aux)<br><br> Reloading NGINX fails| Check the error log at `/var/log/nginx/error.log`<br>Fix the problem and re-run NGINX. |
| NGINX App Protect WAF functionality is not as expected| NGINX App Protect WAF has several logs which can be used for troubleshooting. <br> Usually, it is best to look for any warning or error messages within the logs. <br> Refer to [Logs Overview]({{< ref "/nap-waf/v4/logging-overview/logs-overview.md">}}) |
| `Too many open files` error message | Increase number of file descriptors. <br> For example: `worker_rlimit_nofile 65535;` in the main context of `nginx.conf` file. <br> Refer to [worker_rlimit_nofile directive](https://www.nginx.com/blog/using-nginx-plus-with-selinux/#Issue-4:-%3Ccode%3EToo-many-files-are-open%3C/code%3E-Error)|
| `setrlimit ... failed (Permission denied)` error message | Increase the limit using the following command as the root user:<br> `setsebool -P httpd_setrlimit 1;` <br> Refer to [Issue 4: Too many files are open Error](https://www.nginx.com/blog/using-nginx-plus-with-selinux/#Issue-4:-%3Ccode%3EToo-many-files-are-open%3C/code%3E-Error) |
| unknown directive `app_protect_xxx` error message  | App Protect module is not loaded. Add this line to the main (global) context of nginx.conf:<br>`load_module "/etc/nginx/modules/ngx_http_app_protect_module.so";`  |

{{</bootstrap-table>}}

## ELK issues

ELK issues are addressed directly in GitHub by posting the issue to [Kibana dashboards for F5 App Protect WAF GitHub repo](https://github.com/464d41/f5-waf-elk-dashboards).

## SELinux
App Protect files and processes are labeled with the following two contexts:

- `nap-compiler_t`
- `nap-engine_t`

NGINX Plus is labeled with the `httpd_t` context.

If you run into a situation where SELinux denies access to something, start the troubleshooting by searching for audit denials related to one of the above contexts.

For example:

```none
ausearch --start recent -m avc --raw -se nap-engine_t
```

> `--start recent` here means to start the search from 10 minutes ago

For more information about how to use NGINX Plus with SELinux - check our [blog](https://www.nginx.com/blog/using-nginx-plus-with-selinux/)

## Opening a Support Ticket

In order to open a support ticket, collect the troubleshooting information in a tarball and send it to your customer support engineer.

 1. Tarball preparation to collect data for troubleshooting:
     - Get all versions via:

     ```none
     cat /opt/app_protect/VERSION /opt/app_protect/RELEASE > package_versions.txt
     ```

     For CentOS:

     ```none
     rpm -qa nginx-plus* app-protect* >> package_versions.txt
     ```

     For Debian:

     ```none
     apt list --installed | grep -E 'nginx-plus|app-protect' >> package_versions.txt
     ```

     - Get OS via:

     ```none
     cat /etc/os-release > system_version.txt && uname -r >> system_version.txt && cat /proc/version >> system_version.txt
     ```

 2. Create a list of files for tarball in a file called logs.txt:
     - `package_versions.txt`
     - `system_version.txt`
     - `/var/log/app_protect/*` (all app protect files)
     - `/var/log/nginx/*` (all NGINX files)

 3. Add all policies and log file configuration

 4. Add all nginx configuration including all references such as `/etc/nginx/nginx.conf`

 5. Create the tarball:

     ```none
     tar cvfz logs.tgz `cat logs.txt`
     ```

 7. Attach `logs.tgz` to support ticket.

 8. On the support ticket, in the NGINX App Protect WAF, set the release version according to the `opt/app_protect/RELEASE` file.
