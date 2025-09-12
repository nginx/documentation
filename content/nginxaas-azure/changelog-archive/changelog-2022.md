---
title: "2022"
weight: 300
toc: true
url: /nginxaas/azure/changelog-archive/changelog-2022/
---

Learn about the updates, new features, and resolved bugs in F5 NGINXaaS for Azure during the year 2022.

To see the latest changes, visit the [Changelog]({{< ref "/nginxaas-azure/changelog" >}}) page.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas-azure/known-issues.md" >}}) page.

## December 14, 2022

- {{% icon-resolved %}} **New customer deployments are now functional.**

   We have rolled out a fix that addresses the issue, and new customers or existing customers in a new region can create deployments.

## December 7, 2022

- {{% icon-resolved %}} **System Assigned Managed Identitiy can now be used with a deployment.**

   Users can now leverage System Assigned Managed Identities with their deployment. The lifecycle of the identity is tied to the lifecycle of the corresponding deployment. See [Managed Identity Types](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) for more information.

## November 29, 2022

- {{% icon-resolved %}} **Absolute paths may now be used with the `js_import` directive.**

   NGINXaaS for Azure has new restrictions on file paths for certificate files, njs files, etc. See the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}) for more information. Existing configurations will not be affected unless they need to be updated.

## November 22, 2022

- {{% icon-feature %}} **Logging support is now available**

   Please visit the [Logging Support]({{< ref "/nginxaas-azure/monitoring/enable-logging/" >}}) documentation for more information on exporting NGINX logs with NGINXaaS for Azure.

- {{% icon-resolved %}} **NGINXaaS for Azure ARM API schema supports previously unused fields `protectedFiles` and `logging`.**

## November 14, 2022

- {{% icon-feature %}} NGINX deployment can be configured to send [metrics-based alerts]({{< ref "/nginxaas-azure/monitoring/configure-alerts.md" >}}).

## November 7, 2022

- {{% icon-feature %}} New deployments utilize [Availability Zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview) to ensure data planes are highly available.
- {{% icon-feature %}} Files containing sensitive data can be uploaded as a "Protected File", see: [NGINX Configuration]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}})

## October 24, 2022

- {{% icon-feature %}} __NGINXaaS for Azure is now generally available in more regions__

  NGINXaaS for Azure is now available in the following additional regions:

  - West US 2
  - East US
  - Central US
  - North Central US

  See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of supported regions.

## October 11, 2022

- {{% icon-resolved %}} **Resolved known njs filepath issues**

    Affecting new deployments only, two njs files in different subdirectories may share the same filename. For example:
    ```
        js_path "njs";
        js_import d1 as d1/test.js;
        js_import d2 as d2/test.js;
    ```

## October 5, 2022

- {{% icon-feature %}} __Updated the error returned when a certificate cannot be applied to the NGINX Configuration__

  This change improves the readability of some errors that may be returned when a certificate cannot be applied.

## September 22, 2022

- {{% icon-feature %}} **NGINX configurations have default logging directives**

  Added default `access_log` and `error_log` to NGINX configurations in preparation for upcoming logging features. Requires a config push to be applied.

- {{% icon-feature %}} **Improved likelihood of deployment success**
- {{% icon-feature %}} **Improved performance and reliability of backend services**
- {{% icon-resolved %}} **Fixed bug where NGINX version appeared empty**

## July 21, 2022

- {{% icon-feature %}} **Basic caching is now supported**

  For more information on caching with NGINXaaS for Azure, please visit the [Basic Caching]({{< ref "/nginxaas-azure/quickstart/basic-caching.md" >}}) documentation.

- {{% icon-feature %}} **Rate Limiting is now supported**

  For information on rate limiting with NGINXaaS for Azure, please visit the [Rate Limiting]({{< ref "/nginxaas-azure/quickstart/rate-limiting.md" >}}) documentation.


## May 24, 2022

### Welcome to the NGINXaaS Public Preview

NGINXaaS for Azure is now available for public preview. Give it a try! If you find any issues please let us know by [raising a support ticket]({{< ref "/nginxaas-azure/get-help.md" >}}).

Visit the [Known issues]({{< ref "/nginxaas-azure/known-issues.md" >}}) section to learn about the issues present in this release.
