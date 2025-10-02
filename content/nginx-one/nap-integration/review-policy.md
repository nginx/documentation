---
# We use sentence case and present imperative tone
title: "Review policy"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGINX One
---

Before you implement a policy on an NGINX instance or Config Sync Group, you may want to review it. F5 NGINX One Console creates a policy for your F5 WAF for NGINX system.

## Review NGINX App Protect policies

From NGINX One Console, select **App Protect** > **Policies**. Select the name of the policy that you want to review. You'll see the following tabs:

- Details, which includes:
  - Policy Details: Descriptions, status, enforcement type, latest version, and last deployed time.
  - Deployments: List of instances and Config Sync Groups where the NGINX App Protect policy is deployed.
- Policy JSON: The policy, in JSON format. With the **Edit** button, you can modify this policy.
- Versions: Policy versions that you've written. You can apply an older policy to your deployments.

## Modify existing policies

From the NGINX One Console, you can also manage existing policies. In the Policies screen, identify a policy, and select **Actions**. From the menu that appears, you can:

- **Edit** an existing policy.
- **Save As** to save an existing policy with a new name. You can use an existing policy as a baseline for further customization.
- **Deploy Latest Version** to apply the latest revision of an existing policy to the configured instances and Config Sync Groups.
- **Export** the policy in JSON format.
- **Delete** the policy. Once confirmed, you'll lose all work you've done on that policy.

{{< call-out "note" >}}
If you use **Save As** to create a new policy, include the `app_protect_cookie_seed` [directive]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#directives" >}}).
{{< /call-out >}}

