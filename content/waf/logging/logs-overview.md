---
title: Log types
toc: true
weight: 100
nd-content-type: reference
nd-product: NAP-WAF
---

F5 WAF for NGINX generates three types of logs:

- [Security logs]({{< ref "/waf/logging/security-logs.md" >}}), which record HTTP requests and how F5 WAF processed them, including violations and detected signatures.
- [Operation logs]({{< ref "/waf/logging/operation-logs.md" >}}), covering F5 WAF events such as startup, shutdown and reconfiguration.
- [Debug logs]({{< ref "/waf/logging/debug-logs.md" >}}), recording technical messages at different levels of severity used to debug and resolve incidents and error behaviors.

F5 WAF for NGINX can also be configured to add additional data to the NGINX [access logs]({{< ref "/waf/logging/access-logs.md" >}}).

{{< call-out "note" >}}

F5 WAF for NGINX and NGINX itself do not have logs for auditing system user interactions.

These events should be examined in the orchestration system controlling NGINX (such as NGINX Ingress Controller), or by tracking configuration files and their systemd invocations.

{{< /call-out>}}

F5 WAF for NGINX uses a separate logging mechanism to NGINX's default one, which is responsible for access logs.

| Type      | Log configuration | Configuration contexts | File destination | Syslog destination |
| --------- | ----------------- | -----------------------| ---------------- | ------------------ |
| Security  | `app_protect_security_log` directive referencing `security_log.json` file | `nginx.conf`: http, server, location | Yes, either `stderr`, or an absolute path to a local file are supported | Yes |
| Operation | `error_log` directive, part of core NGINX | `nginx.conf` - global | Yes, NGINX error log | Yes, NGINX error log |
| Debug     | `/etc/app_protect/bd/logger.cfg.` Log file name is the redirection in the invocation of the bd command line in the start script | Global (not part of nginx.conf) | Yes. Log file is in `/var/log/app_protect` default debug directory.  No file rotation currently | No |


## Log Types

Logs in F5 WAF for NGINX v5 can be accessed and configured similarly to F5 WAF for NGINX, though there are some differences in the process.

### Security Logs

A key change in configuring [Security logs]({{< ref "/nap-waf/v5/logging-overview/security-log" >}}) is the requirement to [compile JSON logging profiles]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#logging-profile-compilation" >}}) into a bundle file before applying them.

#### Default Logging Profile Bundles

There are several pre-compiled logging profile bundles available:

- log_default (equivalent to log_illegal)
- log_all
- log_illegal
- log_blocked
- log_grpc_all
- log_grpc_blocked
- log_grpc_illegal

These logging profiles can be referenced by their names, excluding the file path and the `tgz` extension.

For instance:

```nginx
    ...
    location / {

        # F5 WAF for NGINX
        app_protect_enable on;
        app_protect_security_log_enable on;
        app_protect_security_log log_blocked syslog:server=log-server:514;

        proxy_pass http://127.0.0.1:8080/;
    }
```

#### Security Log Destination

Please refer to [Security logs]({{< ref "/nap-waf/v5/logging-overview/security-log" >}}) page for details.

#### WAF Enforcer Container Logs

When `stderr` is set as the destination for security logs in the `app_protect_security_log` directive, these logs are accessible via the `waf-enforcer` container. To view them, use the following command:

```shell
docker logs waf-enforcer
```

Or in Kubernetes:

```shell
kubectl logs deployment.apps/nap5-deployment -c waf-enforcer
```

### Debug Logs

Logs for internal components of NGINX App Protect 5 can be accessed by executing `docker logs` or `kubectl logs` on one of the deployment containers. For example:

```shell
docker logs waf-config-mgr
```

### NGINX Access Log

F5 WAF for NGINX v5 can be configured to add additional data to NGINX [Access log]({{< ref "/nap-waf/v5/logging-overview/access-log" >}}).

## logrotate support

F5 WAF for NGINX supports logrotate. It is typically run periodically using a cron job: more information is available in its [Linux man page](https://linux.die.net/man/8/logrotate).

If your system has logrotate available, F5 WAF for NGINX log files will rotate automatically based on the default configuration file.

The default logrotate configuration file is `/var/log/app_protect/*.log`:

```none
{
    size 1M
    copytruncate
    notifempty
    create 644 nginx nginx
    rotate 20
}
```

| Option name | Description |
| ----------- | ------------| 
| _size_      | Log files are rotated only if they grow larger than the value of _size_.
| _copytruncate_ | Truncate the original log file in place after creating a copy, instead of moving the old log file and creating a new one.
| _create_ | _mode owner group_ - The log file is created immediately after rotation with the permissions specified by _mode_. _owner_ specifies the user name who will own the log file, and _group_ specifies the group the log file will belong to.
| _rotate_  | _count_ - Log files are rotated _count_ times before being removed.

You can modify the attributes and add directories to rotate in the file `/etc/logrotate.d/app_protect.conf`.

All logs in the `/var/log/app_protect/` folder will be rotated, which can include the security log if configured accordingly.

{{< call-out "note" >}} The default log rotation policy is provided as a default policy can be customized for your use cases. {{< /call-out >}}

To output security logs to the `/var/log/app_protect/` folder, update `/etc/nginx/nginx.conf`:

```nginx
app_protect_security_log_enable on;
app_protect_security_log "/opt/app_protect/share/defaults/log_illegal.json" /var/log/app_protect/security.log;
```