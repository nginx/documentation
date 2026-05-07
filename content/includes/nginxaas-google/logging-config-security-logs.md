---
f5-product: NGOOGL
f5-files:
- content/nginxaas-google/monitoring/enable-nginx-logs.md
---

You can enable security logs by adding **app_protect_security_log** directives to your NGINX configuration to specify the location of the logs and formats. The log path should always be configured to be inside **/var/log/app_protect**.

```nginx
app_protect_security_log_enable on;
app_protect_security_log log_default /var/log/app_protect/security.log;
```

NGINXaaS does not support custom logging profiles and is limited to the [default logging profiles](https://docs.nginx.com/waf/logging/logs-overview/#default-logging-profile-bundles).

{{< call-out "warning" >}}Keep F5 WAF for NGINX logs in the **/var/log/app_protect** directory. Otherwise, you may lose data from your logs.
{{< /call-out >}}
