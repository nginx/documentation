---
title: Default log profile
description: Learn about the security dashboard default log profile and how to deploy it
weight: 200
nd-content-type: concept
nd-product: NONECO
---

The default log profile is a pre-configured F5 WAF for NGINX log profile designed specifically for security event monitoring in NGINX One Console. It captures security violation data in a standardized format optimized for analysis and troubleshooting.

## About the default log profile

The default log profile is similar to [other log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/_index.md" >}}) in structure and function, but has these key characteristics:

- **Immutable** — The default log profile cannot be edited or deleted. This ensures the security monitoring data format remains consistent across your deployment.
- **Pre-compiled** — NGINX One Console automatically compiles the default log profile for all available WAF compiler versions. This eliminates the need for on-demand compilation during deployment.
- **Standardized format** — It captures all necessary security telemetry fields for the security dashboard, including support IDs, violation details, signature information, and client context.

## When to use the default log profile

Use the default log profile when you want to:
- Send security violation data to NGINX One Console for centralized monitoring
- Analyze attack patterns and trends across your NGINX fleet
- Review violation details and raw request data for specific security events
- Generate baseline security metrics and trending reports

For specialized logging requirements beyond security monitoring, you can create and deploy custom log profiles alongside the default profile.

## Deploy the default log profile

To deploy the default log profile to your NGINX instances or Config Sync Groups, follow the same process described in [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}}).

The default log profile can be deployed using either of these methods:

1. **Direct deployment** — Go to **WAF** > **Log Profiles**, select the default log profile, and use **Actions** > **Deploy** to send it to your target instances or Config Sync Groups.

2. **During configuration editing** — When editing an instance or Config Sync Group configuration, you can select the default log profile from **Add File** > **Existing Log Profile** and specify the deployment path.

Since the default log profile is pre-compiled for all WAF compiler versions, deployment completes immediately without requiring additional compilation.

For detailed deployment instructions, see [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}}).

## Next steps

After deploying the default log profile:
- Monitor security events in the [F5 WAF for NGINX security monitoring dashboard]({{< ref "/nginx-one-console/waf-security-dashboard/" >}})
- Review security event details and identify attack patterns
- Fine-tune your F5 WAF for NGINX policies based on observed violations
