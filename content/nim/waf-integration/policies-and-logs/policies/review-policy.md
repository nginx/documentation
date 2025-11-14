---
title: Review policy
description: Review and manage stored F5 WAF for NGINX policies and their version history in NGINX Instance Manager.
toc: true
weight: 600
nd-content-type: how-to
nd-product: NIM
nd-docs:
---

Before deploying a policy to an NGINX instance or instance group, you can review it in NGINX Instance Manager. The system stores all F5 WAF for NGINX policies and their version history, so you can review details or roll back to an earlier version if needed.

## Review policies

In the NGINX Instance Manager web interface, go to **WAF > Policies**, then select the security policy you want to review. The **Security Policies** page includes the following tabs:

- **Details**, which includes:
  - Policy Details: Descriptions, status, enforcement type, latest version, and last deployed time.
  - Deployments: List of instances and instance groups where the F5 WAF for NGINX policy is deployed.
- **Policy JSON** – Shows the full security policy in JSON format. Select **Edit** to make changes directly.  
- **Versions** – Displays previous revisions of the security policy. You can redeploy an older version if necessary.

## Manage existing policies

From **WAF > Policies**, you can manage your existing policies. On the **Security Policies** page, locate the security policy and select the **Actions** (...) menu. The following options are available:

- **Edit** – Modify the selected security policy.
- **Compile** – Precompile the complete WAF configuration — including security policies, attack signatures, threat campaigns, and log profiles — into a single `.tgz` bundle and push it to the selected F5 WAF for NGINX instances.
- **Save As** – Create a copy of the security policy under a new name to use as a baseline for customization.  
- **Export as JSON** – Download the security policy definition in JSON format.
- **Download Bundle** – Download the compiled `.tgz` security bundle for reuse or offline deployment.
- **Delete** – Permanently remove the security policy from NGINX Instance Manager.  

{{< call-out "note" "Note" >}}
If you use **Save As** to create a new policy, include the `app_protect_cookie_seed` [directive]({{< ref "/waf/policies/directives.md" >}}).
{{< /call-out >}}

{{< call-out "note" "See also" >}}For a full overview of how NGINX Instance Manager handles WAF policy management, compilation, and deployment, see [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}).{{< /call-out >}}