---
title: "2026"
weight: 100
toc: true
nd-content-type: reference
nd-docs: "DOCS-870"
nd-product: NAZURE
url: /nginxaas/azure/changelog/
---

Learn about the latest updates, new features, and resolved bugs in F5 NGINXaaS for Azure.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas-azure/known-issues.md" >}}) page.

To review older entries, visit the [Changelog archive]({{< ref "/nginxaas-azure/changelog/archive" >}}) section.

## January 14, 2026

- {{% icon-feature %}} **Azure Resource Health is now automatically enabled on all NGINXaaS deployments**

  Customers can now monitor the health of their NGINXaaS deployments through [Azure Resource Health]({{< ref "/nginxaas-azure/monitoring/azure-resource-health.md" >}}). Azure Resource Health provides an up-to-date overview of deployment status and reveals ways in which NGINXaaS deployments may have become degraded over time. We encourage users to make full use of this functionality to maintain their deployments in a healthy state.

## January 08, 2026

- {{% icon-feature %}} **NGINXaaS is now running NGINX Plus Release 36 (R36) in the Stable Upgrade Channel**

  NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) have now been automatically upgraded to [NGINX Plus Release 36 (R36)]({{< ref "/nginx/releases.md#nginxplusrelease-36-r36" >}}). This upgrade also includes updates to the following NGINX Plus modules:
  - `nginx-plus-module-njs`
   For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#configuration-directives-list" >}}).

  {{< call-out "important" >}}

  The [ACME protocol support](https://nginx.org/en/docs/http/ngx_http_acme_module.html) feature, including the [ACME enhancements in NGINX Plus R36]({{< ref "/nginx/releases.md#nginxplusrelease-36-r36" >}}), is not currently supported in NGINXaaS due to active-active deployments.

  {{< /call-out >}}
