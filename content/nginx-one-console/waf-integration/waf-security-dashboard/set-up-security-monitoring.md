---
nd-content-type: how-to
nd-docs: DOCS-000
nd-product: NONECO
title: Set up security monitoring
description: "Forward F5 WAF for NGINX security events to the NGINX One Console security monitoring dashboard."
weight: 300
toc: true
nd-keywords: "F5 WAF for NGINX, security monitoring, security dashboard, default log profile, security events"
nd-summary: >
  Forward F5 WAF for NGINX security events from an NGINX Plus instance to the NGINX One Console security monitoring dashboard.
  You deploy the `secops_dashboard` log profile through the console, add the WAF directives to your NGINX configuration, and verify events flow into the dashboard.
  Repeat these steps for each data plane you want to monitor.
nd-audience: operator
---

## Overview

This guide walks you through enabling F5 WAF for NGINX security monitoring on an NGINX Plus instance that is already connected to NGINX One Console. After you complete the steps, security events appear in the [security monitoring dashboard]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/_index.md" >}}), where you can review attacks, violations, and triggered signatures.

The flow uses the NGINX One Console UI end to end. You deploy the [`secops_dashboard` log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}}) to the instance, add the F5 WAF for NGINX directives to the NGINX configuration through the console's config editor, and verify the pipeline by triggering test violations. NGINX Agent automatically configures its OpenTelemetry collector to forward security events to NGINX One Console once it sees the correct directives in the NGINX configuration — you do not need to edit the agent configuration by hand.

---

## Before you begin

Before you begin, ensure you have:

- **NGINX Plus**: NGINX Plus installed and running on your data plane. See the [NGINX Plus installation guide]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).
- **F5 WAF for NGINX installed and loaded**: F5 WAF for NGINX installed on the same host as NGINX Plus, with the `load_module` directive added to `nginx.conf` and `app_protect_enable on;` set in the contexts you want WAF to inspect. See [Install F5 WAF for NGINX]({{< ref "/waf/install/virtual-environment.md" >}}) and [Update configuration files]({{< ref "/waf/install/virtual-environment.md#update-configuration-files" >}}).
- **A WAF policy deployed to the instance**: An F5 WAF for NGINX policy referenced by an `app_protect_policy_file` directive in the same context where you enable WAF. See [WAF policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}) for how to create and deploy a policy through NGINX One Console.
- **Instance connected to NGINX One Console**: The data plane is registered with NGINX One Console and NGINX Agent is running on it. See [Add an instance]({{< ref "/nginx-one-console/connect-instances/add-instance.md" >}}).
- **NGINX Agent 3.9.0 or later**: Security event forwarding to NGINX One Console requires NGINX Agent 3.9.0 or later. See the [NGINX Agent install and upgrade guide]({{< ref "/nginx-one-console/agent/install-upgrade/_index.md" >}}) to upgrade an existing agent.

---

## Deploy the `secops_dashboard` log profile

The security dashboard relies on the `secops_dashboard` log profile to capture security violations in a standardized format. It is created and maintained by F5, immutable, and pre-compiled for every available WAF compiler version, so it deploys exactly the same way as a custom log profile but completes immediately without an on-demand compile. For background, see [secops_dashboard log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}}).

1. In NGINX One Console, go to **WAF** > **Log Profiles** and select **`secops_dashboard`**.

2. From **Actions**, select **Deploy**. The **Deploy Log Profile** wizard opens.

3. In the wizard:

    - Confirm `secops_dashboard` is selected under **Log Profile**.
    - Under **Target**, choose **Instance** or **Config Sync Group** and select your target.
    - In **Log Profile File Path**, specify the path where the compiled bundle should be deployed on the data plane (for example, `/etc/nginx/secops_dashboard.tgz`).

4. Select **Next**. The wizard displays the F5 WAF for NGINX directive snippet to paste into your NGINX configuration, along with the config editor for the target instance.

5. Open the server block where you want to enable F5 WAF for NGINX (for example, `/etc/nginx/conf.d/default.conf`) and paste the snippet into the `server`, `http`, or `location` context. The snippet looks like this:

    ```nginx
    app_protect_security_log_enable on;
    app_protect_security_log /etc/nginx/secops_dashboard.tgz syslog:server=127.0.0.1:1514;
    ```

    Make sure `app_protect_enable on;` and `app_protect_policy_file` are already present in the same context (covered by the prerequisites above).

6. Review the configuration diff the console shows for the affected files, then select **Publish**. NGINX One Console pushes the updated configuration to the instance and reloads NGINX.

For more on the deployment wizard and the alternative **Add File** > **Existing Log Profile** flow, see [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}}).

---

## Verify the setup

When you select **Publish** in the previous step, NGINX One Console pushes the configuration change to the instance and displays a confirmation toast indicating the publish succeeded. At that point both the F5 WAF for NGINX policy and the `secops_dashboard` log profile are in place on the data plane, and the security log directive is wired up to NGINX Agent.

From this point on, any request that F5 WAF for NGINX inspects on the instance produces a security event that flows to NGINX One Console. To see those events:

1. In NGINX One Console, go to **WAF** > **Security Dashboard**.
2. As your instance handles traffic, attacks, violations, and triggered signatures appear on the dashboard within about a minute of the request being processed.

For details on how the dashboard is organized and how to read each widget, see the [security dashboard reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}}).

---

## Troubleshooting

### Publish fails with a configuration validation error

**Symptom**: When you select **Publish** in the deployment wizard, NGINX One Console reports a configuration validation error such as `unknown directive "app_protect_enable"`, `unknown directive "app_protect_security_log"`, or a parser error referencing the WAF directives.

**Cause**: One or more of the F5 WAF for NGINX prerequisites is not in place on the instance — typically the `load_module` line is missing from `nginx.conf`, `app_protect_enable on;` is not set in the context where the security log directive was pasted, or `app_protect_policy_file` references a path the data plane cannot resolve.

**Fix**: Re-check the items in [Before you begin](#before-you-begin):

- Confirm `load_module modules/ngx_http_app_protect_module.so;` is present in the main context of `nginx.conf`. See [Update configuration files]({{< ref "/waf/install/virtual-environment.md#update-configuration-files" >}}).
- Confirm `app_protect_enable on;` is set in the same `server`, `http`, or `location` context where you pasted the security log snippet.
- Confirm an `app_protect_policy_file` directive references a policy already deployed to the instance. See [WAF policies]({{< ref "/nginx-one-console/waf-integration/policy/_index.md" >}}).

Re-run the deployment wizard after fixing the configuration.

### Publish succeeded but no events appear in the dashboard

**Symptom**: The publish toast confirmed success, the instance is online in NGINX One Console, but the **WAF > Security Dashboard** shows no events for your instance.

**Cause**: The most common causes are that NGINX Agent on the instance is older than 3.9.0 and does not include the auto-configured security event pipeline, the `secops_dashboard` log profile is not deployed to that instance, the `app_protect_security_log` directive is in a context that does not handle traffic, or the instance has not yet processed any requests F5 WAF for NGINX would inspect.

**Fix**:

1. Confirm NGINX Agent on the instance is **3.9.0 or later**. Earlier 3.x releases publish the configuration successfully but do not forward security events to NGINX One Console. See the [NGINX Agent install and upgrade guide]({{< ref "/nginx-one-console/agent/install-upgrade/_index.md" >}}) to upgrade.
2. Go to **WAF** > **Log Profiles** and confirm `secops_dashboard` is listed as deployed to the target instance under **Deployed To**.
3. Open the instance configuration and confirm the `app_protect_security_log` directive sits in a `server` or `location` block that actually handles request traffic — not in a context the data plane never enters.
4. Confirm the instance is receiving traffic. Until F5 WAF for NGINX inspects a request, the dashboard has nothing to display.
5. Apply a global filter on the dashboard to scope to your instance hostname or policy, in case events are present but hidden by an existing filter.

If events still do not appear after a request is processed, contact F5 support with the instance hostname and the time window you tested.

---

## References

For more information, see:

- [Security monitoring overview]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/security-monitoring-overview.md" >}})
- [secops_dashboard log profile]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/default-log-profile.md" >}})
- [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}})
- [Add an instance]({{< ref "/nginx-one-console/connect-instances/add-instance.md" >}})
- [Dashboard metrics reference]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/dashboard-metrics-reference.md" >}})
- [Find a security event by Support ID]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/find-event-by-support-id.md" >}})
- [Query security events through the API]({{< ref "/nginx-one-console/waf-integration/waf-security-dashboard/query-events-api.md" >}})
