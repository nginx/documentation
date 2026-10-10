---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: F5 NGINXaaS
title: Set up security monitoring
description: "Forward F5 WAF for NGINX security events to the NGINXaaS Console security monitoring dashboard."
weight: 300
toc: true
f5-keywords: "F5 WAF for NGINX, security monitoring, security dashboard, default log profile, security events"
f5-summary: >
  Forward F5 WAF for NGINX security events from NGINX Plus instances in your deployment to the NGINXaaS Console security monitoring dashboard.
  You add the WAF directives to your NGINX configuration and verify events flow into the dashboard.
f5-audience: operator
---

## Overview

Use this guide to enable F5 WAF for NGINX security monitoring on an NGINXaaS deployment. After completing the steps, security events appear in the [security monitoring dashboard]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/_index.md" >}}), where you can review attacks, violations, and triggered signatures.

You add the F5 WAF for NGINX directives to the NGINX configuration using the console's config editor, generate test traffic, and confirm the resulting events appear in the dashboard. NGINX Agent automatically configures its OpenTelemetry collector to forward security events to NGINXaaS Console when it detects the correct directives in the NGINX configuration.

---

## Before you begin

Before you begin, ensure you have:

- **Deployment**: A deployment that has been created with the NGINXaaS Console.

---

## Deploy the `secops_dashboard` log profile

The security dashboard relies on the `secops_dashboard` log profile to capture security violations in a standardized format. It is created and maintained by F5, immutable, and available for every F5 WAF for NGINX version. For background, see [secops_dashboard log profile]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/default-log-profile.md" >}}).

1. Open the NGINX configuration file that handles the traffic you want to monitor (for example, `/etc/nginx/conf.d/default.conf`) and paste the snippet into the `http`, `server`, or `location` context where F5 WAF for NGINX is already enabled. The snippet looks like this:

    ```nginx
    app_protect_security_log_enable on;
    app_protect_security_log /etc/nginx/secops_dashboard.tgz syslog:server=127.0.0.1:1514;
    ```

    `app_protect_enable on;` and `app_protect_policy_file` must be present in the same context. These are covered in [Before you begin](#before-you-begin).

6. Review the configuration diff the console shows for the affected files, then select **Save**. NGINXaaS Console saves the updated configuration.

7. Edit your deployment and select the NGINX configuration and version, then select **Save Changes** to use your NGINX configuration in your deployment. 

---

## Verify the setup

When you select **Save Changes** in the previous step, NGINXaaS Console pushes the configuration change to the deployment and displays a confirmation message. At that point, the F5 WAF for NGINX policy and the `secops_dashboard` log profile are in place on the deployment, and the security log directive is wired to NGINX Agent.

Any request that F5 WAF for NGINX inspects on the instance produces a security event that flows to NGINXaaS Console. Use the following checks to confirm the pipeline end to end:

1. Send one or more requests through the protected application path on the instance you just configured. If you have a staging policy or a known test case that triggers a violation, use it so the event is easy to identify. Otherwise, normal inspected traffic is enough to confirm the pipeline.
2. In NGINXaaS Console, go to **WAF** > **Security Dashboard**.
3. Set the time window to **Last 5 minutes**, then add a global filter for the target **Deployment**, **Hostname**, or **Policy** so you only see events from the deployment you just configured.
4. Open the **Event Logs** tab and confirm at least one event appears for the request you just sent. Check that the row shows the expected URI, policy, and request status (`blocked`, `alerted`, or `passed`).
5. Open the event row to confirm the detail panel shows the request context, triggered violations or signatures, and the generated **Support ID**. If you need to verify a single event later, copy the Support ID and use [Find a security event by Support ID]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/find-event-by-support-id.md" >}}).

Events typically appear within about a minute of the request being processed.

### Example test requests for a default blocking policy

If the protected path uses the default F5 WAF for NGINX policy in blocking mode, the following requests commonly produce a `blocked` event because they match high-confidence attack signatures or raise the violation rating to a blocked threshold. Replace `https://app.example.com/` with a protected URL in your environment.

```shell
# Cross-site scripting (XSS) test
curl -G "https://app.example.com/" --data-urlencode "a=<script>alert(1)</script>"

# Path traversal test
curl -G "https://app.example.com/" --data-urlencode "file=../../../../etc/passwd"

# SQL injection test
curl -G "https://app.example.com/" --data-urlencode "id=1' UNION SELECT 1,2,3--"
```

For details on how the dashboard is organized and how to read each widget, see the [security dashboard reference]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/dashboard-metrics-reference.md" >}}).

---

## References

**Conceptual background**

- [Security monitoring overview]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/security-monitoring-overview.md" >}})

**Reference**

- [secops_dashboard log profile]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/default-log-profile.md" >}})
- [Dashboard metrics reference]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/dashboard-metrics-reference.md" >}})

**Related how-to guides**

- [Find a security event by Support ID]({{< ref "/nginxaas/overview/app-protect/waf-security-dashboard/find-event-by-support-id.md" >}})
