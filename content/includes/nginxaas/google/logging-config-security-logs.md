---
f5-product: NGINXaaS for Google Cloud
f5-files:
- content/nginxaas/google/monitoring/enable-nginx-logs.md
---

You can enable security logs by adding **app_protect_security_log** directives to your NGINX configuration to specify the location of the logs and logging formats. The log path should always be configured under **/var/log/app_protect**.

```nginx
app_protect_security_log_enable on;
app_protect_security_log log_default /var/log/app_protect/security.log;
```

NGINXaaS does not support custom logging profiles and is limited to the [default logging profiles]({{< ref "/waf/logging/logs-overview.md#default-logging-profile-bundles" >}}).

{{< call-out class="warning" >}}WAF logs should always be stored under the **/var/log/app_protect** directory. You may lose logging data if you choose any other log paths.
{{< /call-out >}}
