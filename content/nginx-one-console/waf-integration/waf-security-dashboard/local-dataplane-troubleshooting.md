---
nd-content-type: how-to
nd-docs: DOCS-000
nd-product: NONECO
title: Troubleshoot security monitoring on the local data plane
description: "Check the local NGINX Agent and OpenTelemetry Collector configuration when F5 WAF for NGINX security events do not appear in NGINX One Console."
weight: 450
toc: true
nd-keywords: "security monitoring, troubleshooting, local data plane, nginx-agent, opentelemetry collector, secops_dashboard, WAF events"
nd-summary: >
  Use this guide when F5 WAF for NGINX security events do not appear in the NGINX One Console security dashboard even after you complete the setup flow.
  It walks through the local data plane checks for invalid log profiles, missing OpenTelemetry log pipelines, and debug logging.
  These checks help confirm whether NGINX Agent is receiving, parsing, and forwarding security events correctly.
nd-audience: operator
---

## Overview

Use this guide when you completed [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}}), sent test traffic, and still do not see F5 WAF for NGINX security events in the NGINX One Console dashboard.

This guide focuses on the **local data plane**. It helps you verify four things:

1. Whether the embedded OpenTelemetry Collector is dropping security logs because the deployed log profile format is wrong.
2. Whether the NGINX Agent embedded OpenTelemetry Collector is the only process listening on port `1514`.
3. Whether the NGINX agent generated OpenTelemetry Collector config has the expected security log pipeline.
4. Whether debug logging shows the collector forwarding security logs to NGINX One Console.

---

## Before you begin

Before you begin, ensure you have:

- Access to the data plane host where NGINX Plus, F5 WAF for NGINX, and NGINX Agent are running.
- Permission to read `/var/log/nginx-agent/` and `/etc/nginx-agent/`.
- Security monitoring already configured by following [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}}).

---

## 1. Check for invalid log profile errors

The first check is whether NGINX Agent's embedded OpenTelemetry Collector is rejecting the incoming F5 WAF for NGINX security logs because they do not match the format expected by the security monitoring pipeline.

Open the collector log on the data plane:

```shell
sudo tail -f /var/log/nginx-agent/opentelemetry-collector-agent.log
```

Look for either of the following errors:

```text
Security violation log body is not a string. All security violation logs will be dropped until the collector is restarted.
```

```text
Security violation log does not appear to be CSV format. Ensure the NAP logging profile uses the secops-dashboard-log format. All security violation logs will be dropped until the collector is restarted.
```

If you see either message, the most likely cause is that the data plane is not using the NGINX One Console default `secops_dashboard` log profile for the `app_protect_security_log` directive. Ensure that the http, server, or location block in which the security violation should be generated uses this log profile.

### Fix

1. In NGINX One Console, redeploy the default [`secops_dashboard` log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}}) to the affected instance.
2. Update the NGINX configuration so `app_protect_security_log` points to that deployed bundle.
3. Restart NGINX Agent to reset the embedded OpenTelemetry Collector after you correct the log profile.

After the restart, send a new test request and check the dashboard again.

---

## 2. Check that port `1514` is reserved for the collector

F5 WAF for NGINX sends security logs to `syslog:server=127.0.0.1:1514`. If another process is listening on port `1514`, the NGINX Agent embedded OpenTelemetry Collector may never receive the security logs.

Run the following command on the data plane:

```shell
sudo ss -ltnp | grep 1514
```

Confirm that no unexpected process is listening on port `1514`. If another service is bound to that port, stop or reconfigure it so the embedded collector can receive the F5 WAF for NGINX security logs.

---

## 3. Verify the generated OpenTelemetry log pipeline

If the collector log does **not** show either invalid-log-profile error, verify that the generated OpenTelemetry Collector config still contains the security log pipeline.

{{< call-out "note" >}}NGINX Agent generates this security log pipeline only when at least one `http`, `server`, or `location` block is configured with `app_protect_security_log` pointing to `syslog:server=127.0.0.1:1514`. If no protected context uses that syslog destination, the pipeline is not generated in the collector config, and hence no WAF security logs will be forwarded to NGINX One Console.{{< /call-out >}}

Open the generated collector config:

```shell
sudo grep -A 12 "logs/default:" /etc/nginx-agent/opentelemetry-collector-agent.yaml
```

Confirm it includes the following pipeline:

```yaml
logs/default:
  receivers:
    - tcplog/nginx_app_protect
  processors:
    - securityviolationsfilter/default
    - batch/default_logs
    - resource/default
  exporters:
    - otlp/default
```

This pipeline is the path that accepts the F5 WAF for NGINX security logs from `tcplog/nginx_app_protect`, filters and batches them, and exports them to NGINX One Console through `otlp/default`.

If this pipeline is missing or materially different, the collector is not configured as expected for security monitoring. In that case, review any custom collector configuration merged through `nginx-agent.conf`, then restart NGINX Agent so it regenerates the collector config.

---

## 4. Enable debug logging for the collector pipeline

If the collector log does not show the invalid-log-profile errors and the generated pipeline looks correct, enable debug logging so you can verify that the embedded collector is processing and forwarding security logs.

Add the following configuration to the end of `/etc/nginx-agent/nginx-agent.conf`:

```yaml
collector:
  exporters:
    debug: {}
  pipelines:
    logs:
      default:
        receivers:
          - tcplog/nginx_app_protect
        processors:
          - securityviolationsfilter/default
          - batch/default_logs
        exporters:
          - otlp/default
          - debug
```

Restart NGINX Agent so the updated collector configuration is applied.

The `debug` exporter causes the embedded OpenTelemetry Collector to write its processed log output to:

```text
/var/log/nginx-agent/opentelemetry-collector-agent.log
```

This lets you verify that the collector is handling the F5 WAF for NGINX security events locally while still forwarding them to NGINX One Console through `otlp/default`.

{{< call-out "note" >}}The debug exporter increases log volume. Remove it after troubleshooting so the collector log returns to its normal verbosity.{{< /call-out >}}

---

## What to do next

After any action performed based on the above guide:

1. Restart NGINX Agent.
2. Send a new test request through the protected application path. For example requests, see [Example test requests for a default blocking policy]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md#example-test-requests-for-a-default-blocking-policy" >}}).
3. Check `/var/log/nginx-agent/opentelemetry-collector-agent.log`.
4. Recheck the **WAF** > **Security Dashboard** and **Event Logs** tab in NGINX One Console.

If the collector is processing events locally but the dashboard remains empty, gather the following and provide them to F5 support:

- NGINX Agent configuration: `/etc/nginx-agent/nginx-agent.conf`
- Generated OpenTelemetry Collector configuration: `/etc/nginx-agent/opentelemetry-collector-agent.yaml`
- NGINX Agent log: `/var/log/nginx-agent/agent.log`
- Embedded OpenTelemetry Collector log: `/var/log/nginx-agent/opentelemetry-collector-agent.log`

---

## References

For more information, see:

- [Set up security monitoring]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring.md" >}})
- [secops_dashboard log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}})
- [Security dashboard reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}})
- [Export NGINX instance metrics]({{< ref "/nginx-one-console/agent/configure-otel-metrics.md" >}})
