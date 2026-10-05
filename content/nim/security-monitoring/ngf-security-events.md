---
title: View NGINX Gateway Fabric security events
weight: 150
toc: true
f5-content-type: concept
f5-product: NGINX Instance Manager
f5-docs: 
description: "View F5 WAF security events from NGINX Gateway Fabric deployments in F5 NGINX Instance Manager's Security Dashboard."
f5-summary: >
  View F5 WAF security events from NGINX Gateway Fabric deployments in F5 NGINX Instance Manager's Security Dashboard.
  NGINX Gateway Fabric's NGINX Agent v3 exports security events directly to NGINX Instance Manager, giving you unified event visibility alongside F5 NGINX Ingress Controller.
---

## Overview

F5 NGINX Instance Manager shows F5 WAF security events from NGINX Gateway Fabric deployments in the **Security Dashboard**. NGINX Gateway Fabric's NGINX Agent v3 includes a built-in OpenTelemetry collector that exports security events directly to NGINX Instance Manager. You don't need NGINX Agent v2 to see F5 WAF activity on your NGINX Gateway Fabric instances.

You can view:

- F5 WAF security violations
- Bot detection events
- Policy violations
- Attack patterns
- Security event history

{{< call-out class="important" title="Important: Event visibility only" >}}
This integration covers security event visibility only. NGINX Instance Manager can't manage NGINX Gateway Fabric instances, instance groups, or F5 WAF policy deployments. F5 plans to add full NGINX Agent v3 support for these capabilities in a future release.
{{< /call-out >}}

## Requirements

- NGINX Instance Manager 2.23 or later
- NGINX Gateway Fabric running F5 WAF for NGINX with NGINX Agent v3, connected to NGINX Instance Manager. See [Connect NGINX Gateway Fabric to NGINX Instance Manager]({{< ref "/nim/connect-kubernetes/connect-ngf.md" >}}).
- Security Monitoring turned on in NGINX Instance Manager

## Set up event export from NGINX Gateway Fabric

NGINX Gateway Fabric generates and exports security events. NGINX Instance Manager doesn't pull or request them. Configure the export on the NGINX Gateway Fabric side.

This integration doesn't require changes to Gateway API resources.

See [Export security logs to F5 NGINX Instance Manager]({{< ref "/ngf/waf-integration/policy-sources.md#export-security-logs-to-f5-nginx-instance-manager" >}}).

## View events in the dashboard

Go to **WAF** > **Security Dashboard** in NGINX Instance Manager. The dashboard has four tabs: Main, Bots, Advanced, and Event Logs. These tabs cover aggregate attack statistics, bot activity, signature and threat detail, and individual events.

Use **Event Logs** for individual event details, including source IP, URI, and Support ID.

You can filter events across all four tabs by fields including instance, instance group, IP address, policy, signature, severity, and Support ID.

## See also

- [Export security logs to F5 NGINX Instance Manager]({{< ref "/ngf/waf-integration/policy-sources.md#export-security-logs-to-f5-nginx-instance-manager" >}})
- [Add user access to Security Monitoring dashboards]({{< ref "/nim/security-monitoring/give-access-to-security-monitoring-dashboards.md" >}})
- [Troubleshooting]({{< ref "/nim/security-monitoring/troubleshooting.md" >}})