---
title: "2026"
weight: 100
toc: true
f5-content-type: reference
f5-docs: "DOCS-870"
f5-product: NGINXaaS for Azure
url: /nginxaas-azure/changelog/
---

Learn about the latest updates, new features, and resolved bugs in F5 NGINXaaS for Azure.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas-azure/known-issues" >}}) page.

To review older entries, visit the [Changelog archive]({{< ref "/nginxaas-azure/changelog/archive" >}}) section.

## August 17, 2026

- {{% icon-feature %}} **NGINXaaS is now running NGINX Plus 37.0.4 in the Stable Upgrade Channel**

  NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) have now been automatically upgraded to [NGINX Plus 37.0.4]({{< ref "/nginx/releases.md#pls.37.0.4" >}}). This upgrade also includes the following new directives:
  - [`error_log_tag`](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_log_tag)
  - [`max_headers`](https://nginx.org/en/docs/http/ngx_http_core_module.html#max_headers)
  - [`ssl_ech_file`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ech_file)

  Upstream response time histogram metrics are now available in Azure Monitor. For more information, see the [Metrics catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}). For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview.md#configuration-directives-list" >}}).

  If your deployment is affected by the R37 behavior changes, see the [NGINX Plus 37.0 behavior impact]({{< ref "/nginxaas-azure/known-issues.md#nginx-plus-370-behavior-impact" >}}) section of the **Known issues** page.

  {{< call-out class="important" >}}

  The [ACME protocol support](https://nginx.org/en/docs/http/ngx_http_acme_module.html) feature is not currently supported in NGINXaaS due to active-active deployments.

  {{< /call-out >}}

## July 29, 2026
  NGINX Plus 37.0.4 is now available on the **Preview** [upgrade channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels" >}}) and will be promoted to the **Stable** upgrade channel starting the week of August 17, 2026.

  NGINX Plus 37.0 introduced [several changes](https://docs.nginx.com/nginx/releases/#pls.37.0.4) including new default settings that can affect the behavior of your deployment and it is imperative that you take one of the following steps before your deployment is upgraded:
- Test your configuration on the Preview channel to confirm the new changes do not adversely affect the operation of your applications.
- Preserve your R36 behavior by following the recommendations in the [NGINX Plus 37.0 behavior impact]({{< ref "/nginxaas-azure/known-issues/#nginx-plus-370-behavior-impact" >}}) section of the **Known issues** page.

## July 2, 2026

  NGINX Plus 37.0 (PLS.37.0) introduced [updated defaults](https://docs.nginx.com/nginx/releases/#r37.0) that affected some users. Deployments on the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) have been reverted to NGINX Plus Release 36 (R36) while we work with affected users to resolve concerns.
  In the meantime, you can test NGINX Plus 37.0 on the **Preview** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) to check compatibility.

## July 1, 2026

- {{% icon-feature %}} **User-assigned managed identities are now supported on the data plane**

  NGINXaaS for Azure now supports using either a system-assigned or user-assigned managed identity for data plane access to Azure resources through IMDS token retrieval. For setup instructions, see [NGINXaaS Managed Identity on dataplane]({{< ref "/nginxaas-azure/quickstart/dataplane-mi.md" >}}).

## May 1, 2026

- {{% icon-feature %}} **CVE-2026-31431 Copy Fail Fix**

  A Linux kernel local privilege escalation vulnerability known as "Copy Fail" has been mitigated and the fix was rolled out to all healthy deployments.

## April 29, 2026

- {{% icon-feature %}} **IP Intelligence is now available on Standard V3 plans**

  NGINXaaS for Azure now supports IP Intelligence for F5 WAF for NGINX on **Standard V3** deployments. Use IP Intelligence to block or log requests from IP addresses associated with known threat categories, such as botnets, scanners, and phishing proxies. No extra license is required—the threat database updates automatically every 60 minutes. For more information, see [IP Intelligence]({{< ref "/nginxaas-azure/app-protect/ip-intelligence.md" >}}).

## April 10, 2026

- {{% icon-resolved %}} **Azure Resource Health alerts fully functional**

Users can now successfully set up alerts about the health of their NGINXaaS deployments through [Azure Resource Health]({{< ref "/nginxaas-azure/monitoring/azure-resource-health.md" >}}). We encourage users to set up alerts so that they can react quickly to health events that may impact their deployment.

## February 03, 2026

- {{% icon-feature %}} **In-place plan migrations to Standard V3 and Developer Plans**

You can now migrate NGINXaaS for Azure deployments between pricing plans without any downtime. Supported migrations include `Basic` to `Developer`, `Standard` to `Standard V3`, and `Standard V2` to `Standard V3`. We encourage you to migrate your existing deployments to the new plans as legacy plans will be deprecated soon. For migration steps, see [Migrate to new pricing plans]({{< ref "/nginxaas-azure/billing/change-plan/migrate-from-standardv2.md">}}).

## January 30, 2026

- {{% icon-feature %}} **System-assigned managed identity is now required for all NGINXaaS deployments**

  All new NGINXaaS for Azure deployments now require a system-assigned managed identity. Deployments created through the Azure Portal automatically have the system-assigned managed identity enabled. For deployments created using ARM templates, Bicep, or Terraform, you must explicitly enable the system-assigned managed identity.

  Legacy deployments created before this requirement will continue to function normally, but logging and monitoring features will not work without a system-assigned managed identity. You can add a system-assigned managed identity to existing deployments through the Identity page in the Azure Portal. For step-by-step instructions, see [Add a system-assigned managed identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md#add-system-assigned-managed-identity" >}}).

  For more information, see [Assign Managed Identities]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}).

## January 15, 2026

- {{% icon-feature %}} **NGINXaaS for Azure now supports the `mqtt_buffers` directive**

  The [`mqtt_buffers`](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html#mqtt_buffers) directive is now supported in NGINXaaS for Azure, allowing users to configure the number and size of buffers used for MQTT protocol traffic. For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview.md#configuration-directives-list" >}}).

## January 14, 2026

- {{% icon-feature %}} **Azure Resource Health is now automatically enabled on all NGINXaaS deployments**

  Customers can now monitor the health of their NGINXaaS deployments through [Azure Resource Health]({{< ref "/nginxaas-azure/monitoring/azure-resource-health.md" >}}). Azure Resource Health provides an up-to-date overview of deployment status and reveals ways in which NGINXaaS deployments may have become degraded over time. We encourage users to make full use of this functionality to maintain their deployments in a healthy state.

## January 08, 2026

- {{% icon-feature %}} **NGINXaaS is now running NGINX Plus Release 36 (R36) in the Stable Upgrade Channel**

  NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) have now been automatically upgraded to [NGINX Plus Release 36 (R36)]({{< ref "/nginx/releases.md#nginxplusrelease-36-r36" >}}). This upgrade also includes updates to the following NGINX Plus modules:
  - `nginx-plus-module-njs`
   For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#configuration-directives-list" >}}).

  {{< call-out class="important" >}}

  The [ACME protocol support](https://nginx.org/en/docs/http/ngx_http_acme_module.html) feature, including the [ACME enhancements in NGINX Plus R36]({{< ref "/nginx/releases.md#nginxplusrelease-36-r36" >}}), is not currently supported in NGINXaaS due to active-active deployments.

  {{< /call-out >}}
