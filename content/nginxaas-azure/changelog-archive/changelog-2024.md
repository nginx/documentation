---
title: "2024"
weight: 100
toc: true
url: /nginxaas/azure/changelog-archive/changelog-2024/
---

Learn about the updates, new features, and resolved bugs in F5 NGINX as a Service for Azure during the year 2024.

To see the latest changes, visit the [Changelog]({{< ref "/nginxaas-azure/changelog" >}}) page.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas-azure/known-issues.md" >}}) page.


## December 17, 2024

- {{% icon-feature %}} **NGINXaaS for Azure can integrate with Azure Network Security Perimeter**

   NGINXaaS can now integrate with [Azure Network Security Perimeter](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts). This integration allows users to set up access rules, so their NGINXaaS deployment can retrieve certificates from Azure Key Vault, while blocking all other public access to the key vault. For more information, please refer to the [Configure Network Security Perimeter]({{< ref "/nginxaas-azure/quickstart/security-controls/certificates.md#configure-network-security-perimeter-nsp" >}}) documentation.

## December 3, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports the GeoIP2 dynamic module**

   NGINXaaS now supports the [GeoIP2](https://github.com/leev/ngx_http_geoip2_module) dynamic module. For more information, see [GeoIP2 quickstart]({{< ref "/nginxaas-azure/quickstart/geoip2.md">}}). For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#configuration-directives-list" >}}).

## November 18, 2024

- {{% icon-resolved %}} **Consumed NCUs metric more accurately accounts for concurrent connections**

   The consumed NCUs metric now uses the `system.worker_connections` metric to more accurately determine the number of concurrent connections used by NGINX. Previously NGINXaaS was underreporting the number of concurrent connections used by NGINX, improperly omitting connections to upstreams.

   Users may notice an increase in their deployments' consumed NCUs if their deployments are handling a large number of connections. This fix will help to make autoscaling more responsive to changes in incoming traffic. Customers using autoscaling may notice that their deployments scale out if the number of concurrent connections increases significantly.

## November 8, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now improves visibility and management of protected files**

   Users can now view the file paths and associated metadata of protected files added to the NGINX configuration of an NGINXaaS deployment, while the file contents remain confidential. Users can also overwrite an existing protected file with new file contents or resubmit it without having to provide the file contents again.

   For more details on protected files, refer to the [Add an NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#add-an-nginx-configuration" >}}) section.

## October 23, 2024

- {{% icon-feature %}} **NGINXaaS Load Balancer for Kubernetes preview release**

  You can now use NGINXaaS as an external load balancer to direct traffic into Kubernetes. For details, see the [quickstart]({{< ref "/nginxaas-azure/quickstart/loadbalancer-kubernetes.md" >}}).

## October 10, 2024

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

  NGINXaaS for Azure is now available in the following additional regions:

  - Brazil South

  See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## September 18, 2024

- {{% icon-feature %}} **NGINXaaS is now running NGINX Plus Release 32 (R32) in the Stable Upgrade Channel**

  NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) have now been automatically upgraded to  [NGINX Plus Release 32 (R32)](https://docs.nginx.com/nginx/releases/#nginxplusrelease-32-r32). This upgrade also includes updates to the following NGINX Plus modules:
  - nginx-plus-module-headers-more
  - nginx-plus-module-image-filter
  - nginx-plus-module-lua
  - nginx-plus-module-ndk
  - nginx-plus-module-njs
  - nginx-plus-module-otel
  - nginx-plus-module-xslt

   For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

## September 13, 2024

- {{< icon-warning >}} **Standard plan retirement**<a name="standard-plan-retirement"></a>

NGINXaaS for Azure now supports the [Standard V2](https://docs.nginx.com/nginxaas/azure/billing/overview) plan. We encourage you to use the Standard V2 plan for all new NGINXaaS deployments from now on to take advantage of additional features like NGINX App Protect WAF and a higher number of listen ports. The Standard V2 plan follows a similar pricing model as the Standard plan.

{{<important>}}The Standard plan will be deprecated and will not be available for new deployments starting November 1, 2024.{{</important>}}

Your current deployments on the Standard plan will continue to function but won't include any of the new features we've introduced in the Standard V2 plan. Additionally, we intend to phase out the Standard plan in the future. When this happens, we will offer a migration path to the Standard V2 plan for existing NGINXaaS deployments on the Standard plan.

- **Recommended action:**

   Update your automation scripts to use the Standard V2 plan. The SKU for the Standard V2 pricing plan is `standardv2_Monthly`.

If you have any questions or concerns, please [contact us](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview).

## Aug 29, 2024

- {{% icon-feature %}} **The backend subnet of an NGINXaaS deployment can now be updated**

An NGINXaaS deployment can now be gracefully updated to a new subnet with zero downtime. Currently, this capability is available through ARM templates or the Azure CLI. Support through other client tools is coming soon.

## Aug 22, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports NGINX App Protect WAF in Preview**

  NGINXaaS now supports [NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect-waf/v5) in Preview as part of the [Standard v2 plan]({{< ref "/nginxaas-azure/billing/overview.md#standard-v2-plan">}}). For more information, see [enable WAF]({{< ref "/nginxaas-azure/app-protect/enable-waf.md">}}).

## Aug 16, 2024

- {{% icon-feature %}} **Notification on update to deployments using the Stable Upgrade Channel**

   NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) will be updated to [NGINX Plus Release 32 (R32)](https://docs.nginx.com/nginx/releases/#nginxplusrelease-32-r32) during the week of September 16-22, 2024. This will also include updates to the following NGINX Plus modules:
  - nginx-plus-module-headers-more
  - nginx-plus-module-image-filter
  - nginx-plus-module-lua
  - nginx-plus-module-ndk
  - nginx-plus-module-njs
  - nginx-plus-module-otel
  - nginx-plus-module-xslt

   Please review the [NGINX Plus Release 32 (R32)](https://docs.nginx.com/nginx/releases/#nginxplusrelease-32-r32) Release Notes carefully. If you have any concerns, it's recommended to validate your configuration against NGINX Plus R32 by setting up a test deployment using the **Preview** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}). See [these instructions]({{< ref "/nginxaas-azure/quickstart/recreate.md" >}}) on how to set up a deployment similar to your current one.

   If you have any questions or concerns, please [contact us]({{< ref "/nginxaas-azure/troubleshooting/troubleshooting.md" >}}).

## July 30, 2024

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

  NGINXaaS for Azure is now available in the following additional regions:

  - Central India
  - South India

  See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## July 23, 2024

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

  NGINXaaS for Azure is now available in the following additional regions:

  - Germany West Central

  See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## July 10, 2024

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

  NGINXaaS for Azure is now available in the following additional regions:

  - Southeast Asia
  - Sweden Central

  See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## June 28, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports the Lua dynamic module**

  NGINXaaS now supports the [Lua](https://github.com/openresty/lua-nginx-module) dynamic module `v0.10.25`. The `lua_capture_error_log` directive is not supported at this time. For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

## June 18, 2024

- {{% icon-feature %}} **NGINXaaS now supports NGINX Plus Release 31 (R31)**

  NGINXaaS now supports [NGINX Plus Release 31 (R31)](https://docs.nginx.com/nginx/releases/#nginxplusrelease-31-r31). For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

## June 17, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports the Headers-More dynamic module**

  NGINXaaS now supports the [Headers-More](https://github.com/openresty/headers-more-nginx-module) dynamic module. For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

## June 6, 2024

- {{% icon-feature %}} **Notification on update to deployments using the Stable Upgrade Channel**

   NGINXaaS for Azure deployments using the **Stable** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}) will be updated to [NGINX Plus Release 31 (R31)](https://docs.nginx.com/nginx/releases/#nginxplusrelease-31-r31) during the week of June 17-23, 2024. This will also include updates to the following NGINX Plus modules:

  - nginx-plus-module-headers-more
  - nginx-plus-module-image-filter
  - nginx-plus-module-lua
  - nginx-plus-module-ndk
  - nginx-plus-module-njs
  - nginx-plus-module-otel
  - nginx-plus-module-xslt

   Please review the [NGINX Plus Release 31 (R31)](https://docs.nginx.com/nginx/releases/#nginxplusrelease-31-r31) Release Notes carefully. If you have any concerns, it's recommended to validate your configuration against NGINX Plus R31 by setting up a test deployment using the **Preview** [Upgrade Channel]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}). See [these instructions]({{< ref "/nginxaas-azure/quickstart/recreate.md" >}}) on how to set up a deployment similar to your current one.

   If you have any questions or concerns, please [contact us]({{< ref "/nginxaas-azure/troubleshooting/troubleshooting.md" >}}).

## May 20, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports a Basic plan for dev/test purposes**

  For trial, development and testing purposes without SLA guarantees, redundancy or scaling, NGINXaaS provides the ability to choose a Basic plan deployment. For more information, see [pricing plans]({{< ref "nginxaas-azure/billing/overview.md#pricing-plans">}}).

## April 18, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports runtime state sharing**

   NGINXaaS instances can now synchronize shared memory zones when configured to enable [Runtime State Sharing](https://docs.nginx.com/nginx/admin-guide/high-availability/zone_sync/).

   This feature allows for some data to be shared between NGINXaaS instances including:

  - [Sticky‑learn session persistence](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn)
  - [Rate limiting](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone)
  - [Key‑value store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone)

   [Runtime State Sharing](https://docs.nginx.com/nginx/admin-guide/high-availability/zone_sync/) enables NGINXaaS to be configured for use cases such as [OIDC](https://github.com/nginxinc/nginx-openid-connect) and [SAML](https://github.com/nginxinc/nginx-saml) authentication.

   Refer to [Runtime State Sharing with NGINXaaS for Azure]({{< ref "/nginxaas-azure/quickstart/runtime-state-sharing.md" >}}) for the configuration guide.

- {{% icon-feature %}} **NGINXaaS for Azure now supports metrics from stream zone_sync statistics**

   For a complete catalog of metrics, see the [Metrics Catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md">}}).

## April 9, 2024

- {{% icon-feature %}} **NGINXaaS for Azure supports autoscaling and Upgrade Channels on all client tools**

   In addition to the Azure Portal and the ARM API version `2024-01-01-preview`, you can now use all other client tools, such as the Azure CLI or Terraform, to enable autoscaling or specify an Upgrade Channel.

   For more information on autoscaling, see the [Autoscaling documentation]({{< ref "/nginxaas-azure/quickstart/scaling.md#autoscaling">}}).
   For more information on Upgrade Channels, see [Upgrade Channels]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}).

- {{% icon-feature %}} **NGINXaaS for Azure can now accept a system assigned and a user assigned managed identity**

   NGINXaaS for Azure now allows using a system assigned managed identity and a user assigned managed identity at the same time per deployment. This provides flexibility in assigning role permissions for integrations that NGINXaaS for Azure require.

## March 21, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports Upgrade Channels**

   An Upgrade Channels lets you control the frequency at which your NGINXaaS deployment receives upgrades for NGINX Plus and its related modules. For more information, see [Upgrade Channels]({{< ref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}).

## March 20, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports autoscaling**

   Enable autoscaling to automatically adjust the size of your deployment based on the traffic requirements. Autoscaling can be enabled in the Azure Portal or the ARM API version `2024-01-01-preview`, with other client tools coming soon.

   For more information on autoscaling, see the [Autoscaling documentation]({{< ref "/nginxaas-azure/quickstart/scaling.md#autoscaling">}}).

## March 13, 2024

- {{% icon-resolved %}} **Fixed a known issue causing Terraform to show an error while trying to manage configuration of a new deployment (ID-891)**

  NGINXaaS for Azure now requires users to take an explicit action to create a default NGINX configuration with a deployment. We have added the "Apply default NGINX configuration" field in the [updated deployment creation workflow]({{< ref "/nginxaas-azure/getting-started/create-deployment/deploy-azure-portal.md#networking-tab" >}}) in the Azure portal. For other client tools like Terraform, NGINXaaS for Azure now requires users to explicitly create an NGINX configuration.

## March 5, 2024

- {{% icon-feature %}} **NGINXaaS for Azure now supports configuring NGINX Plus as a mail proxy server**

   Enhance your email service’s efficiency by utilizing NGINX Plus as a mail proxy for IMAP, POP3, and SMTP protocols, streamlining configuration for mail servers and external services.

   Please note that NGINXaaS does not support outbound connections on port 25, and an alternative port should be used for SMTP. Additionally, ensure network connectivity from the NGINXaaS deployment to both the mail server and authentication server to support  proper mail authentication.

   For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

- {{% icon-feature %}} **NGINXaaS for Azure now supports resolver statistics metrics**

   For a complete catalog of metrics, see the [Metrics Catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md">}}).

## February 15, 2024

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

  NGINXaaS for Azure is now available in the following additional regions:

  - Japan West
  - Korea South
  - Korea Central

   See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## February 8, 2024

- {{% icon-feature %}} ****NGINXaaS for Azure now supports [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings) to send NGINX logs to different destinations****

   An NGINXaaS deployment now supports adding Diagnostic Settings to export NGINX logs. See [Enable NGINX Logs]({{< ref "/nginxaas-azure/monitoring/enable-logging/" >}}) for more details.

## January 22, 2024

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

   NGINXaaS for Azure is now available in Canada Central.

   See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.
