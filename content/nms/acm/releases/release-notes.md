---
description: These release notes list and describe the new features, enhancements,
  and resolved issues in NGINX Management Suite API Connectivity Manager.
nd-docs: DOCS-931
title: Release Notes
toc: true
weight: 100
---

---

## 1.9.3

November 06, 2024

### Upgrade Paths {#1-9-3-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.6.0 - 1.9.2

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-9-3-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-9-3-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Known Issues{#1-9-3-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.9.2

March 14, 2024

### Upgrade Paths {#1-9-2-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.6.0 - 1.9.1

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-9-2-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-9-2-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Resolved Issues{#1-9-2-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} JWT tokens are overwritten when multiple proxies are assigned to one gateway [(44636)]({{< ref "/nms/acm/releases/known-issues.md#44636" >}})<a name="1-9-2-resolved-issues-JWT-tokens-are-overwritten-when-multiple-proxies-are-assigned-to-one-gateway"></a>

### Known Issues{#1-9-2-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.9.1

October 05, 2023

### Upgrade Paths {#1-9-1-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.6.0 - 1.9.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-9-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-9-1-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Resolved Issues{#1-9-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Module crashes when an OpenAPI spec is uploaded with a global security requirement that contains an empty security requirement object [(44393)]({{< ref "/nms/acm/releases/known-issues.md#44393" >}})<a name="1-9-1-resolved-issues-Module-crashes-when-an-OpenAPI-spec-is-uploaded-with-a-global-security-requirement-that-contains-an-empty-security-requirement-object"></a>

### Known Issues{#1-9-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.9.0

September 07, 2023

### Upgrade Paths {#1-9-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.6.0 - 1.8.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-9-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Server URL templating in OpenAPI specification file**<a name="1-9-0-whats-new-Server-URL-templating-in-OpenAPI-specification-file"></a>

  Now you can use templating for the server URL in a supplied OpenAPI specification. You must supply the full explicit `basePath` as part of the server URL in the OpenAPI specification file.

  When creating an API proxy using an OAS file, the following values will not be editable in the web interface if they are provided via the OAS spec file:

  ```json
  servers:
   url: http://{server}.hostname.com/api/{version}
    variables:
      server:
        default: customers
      version:
        default: v1
      basePathVersionAppendRule:
        default : none
      stripBasePathVersion:
        default : false
  ```

- {{% icon-feature %}} **OpenAPI specification support for OAuth2 JWT assertion policy**<a name="1-9-0-whats-new-OpenAPI-specification-support-for-OAuth2-JWT-assertion-policy"></a>

  You can now specify an OAuth2 JWT assertion policy to apply to the API Proxy being created using an OpenAPI specification file.

- {{% icon-feature %}} **Backend server configuration from OpenAPI specification file**<a name="1-9-0-whats-new-Backend-server-configuration-from-OpenAPI-specification-file"></a>

  You can provide the backend server configuration for upstream servers in an OpenAPI specification file using extensions specific to API Connectivity Manager. See the [Publish an API Proxy]({{< ref "/nms/acm/getting-started/publish-api-proxy.md#publish-api-proxy-with-spec" >}}) documentation.


### Resolved Issues{#1-9-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}}  A proxy deployed with a `specRef` field (OAS) and `basePathVersionAppendRule` set to other than `NONE` may cause versions to appear twice in the deployed location block [(36666)]({{< ref "/nms/acm/releases/known-issues.md#36666" >}})<a name="1-9-0-resolved-issues--A-proxy-deployed-with-a-`specRef`-field-(OAS)-and-`basePathVersionAppendRule`-set-to-other-than-`NONE`-may-cause-versions-to-appear-twice-in-the-deployed-location-block"></a>
- {{% icon-resolved %}} Resources deployed to a Developer Portal which has had its database reset cannot be updated or removed [(43140)]({{< ref "/nms/acm/releases/known-issues.md#43140" >}})<a name="1-9-0-resolved-issues-Resources-deployed-to-a-Developer-Portal-which-has-had-its-database-reset-cannot-be-updated-or-removed"></a>
- {{% icon-resolved %}} Certificates associated with empty instance groups can be deleted, resulting in a broken reference in the API Connectivity Manager module [(43671)]({{< ref "/nms/acm/releases/known-issues.md#43671" >}})<a name="1-9-0-resolved-issues-Certificates-associated-with-empty-instance-groups-can-be-deleted,-resulting-in-a-broken-reference-in-the-API-Connectivity-Manager-module"></a>
- {{% icon-resolved %}} Deployment fails due to duplicate locations [(43673)]({{< ref "/nms/acm/releases/known-issues.md#43673" >}})<a name="1-9-0-resolved-issues-Deployment-fails-due-to-duplicate-locations"></a>
- {{% icon-resolved %}} Cannot use TLS enabled backend with HTTP backend-config policy [(44212)]({{< ref "/nms/acm/releases/known-issues.md#44212" >}})<a name="1-9-0-resolved-issues-Cannot-use-TLS-enabled-backend-with-HTTP-backend-config-policy"></a>

### Known Issues{#1-9-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.8.0

July 27, 2023

### Upgrade Paths {#1-8-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.5.0 - 1.7.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-8-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Advanced security policy for proxies**<a name="1-8-0-whats-new-Advanced-security-policy-for-proxies"></a>

  You can use the [Advanced Security policy]({{< ref "/nms/acm/how-to/policies/advanced-security.md" >}}) to add a pre-defined NGINX App Protect to your deployment. This enhancement allows you to specify the rules for each API.

- {{% icon-feature %}} **Publish APIs using OpenAPI Specification version 3.0 or 3.1**<a name="1-8-0-whats-new-Publish-APIs-using-OpenAPI-Specification-version-3-0-or-3-1"></a>

   Now, you can publish APIs using OpenAPI Specification version 3.0 or 3.1

- {{% icon-feature %}} **Added `matchRule` field to the `route` items in `proxyConfig.ingress`**<a name="1-8-0-whats-new-Added-`matchRule`-field-to-the-`route`-items-in-`proxyConfig-ingress`"></a>

  The `matchRule` field is now available in the `route` items in `proxyConfig.ingress`. This field is optional and allows you to define a path matching rule for advanced routes.

  The OpenAPI Specification now supports the `x-acm-match-rule` extension for defining match rules for paths within routes. If you don't specify a value for this extension, it will default to `EXACT`. The only allowed values for `matchRule` are the strings `EXACT` and `PREFIX`.


### Changes in Default Behavior{#1-8-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Proxy labels removed**<a name="1-8-0-changes-in-behavior-Proxy-labels-removed"></a>

  Labels on proxies were added with future use cases in mind although without a current need. The proxy labels have been removed to avoid confusion as to their purpose.


### Resolved Issues{#1-8-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Environments with WAF enabled may transition to a Failed status when a Developer Portal cluster is added. [(43231)]({{< ref "/nms/acm/releases/known-issues.md#43231" >}})<a name="1-8-0-resolved-issues-Environments-with-WAF-enabled-may-transition-to-a-Failed-status-when-a-Developer-Portal-cluster-is-added-"></a>

### Known Issues{#1-8-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.7.0

June 21, 2023

### Upgrade Paths {#1-7-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.4.0 - 1.6.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-7-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Advanced Security Policy**<a name="1-7-0-whats-new-Advanced-Security-Policy"></a>

  The new [Advanced Security policy]({{< ref "/nms/acm/how-to/policies/advanced-security.md" >}}) can be used to add a pre-defined NGINX App Protect configuration to your deployment.  Doing so will apply the rules specified in the policy to your APIs.

- {{% icon-feature %}} **Option added to allow API proxy to ignore invalid headers**<a name="1-7-0-whats-new-Option-added-to-allow-API-proxy-to-ignore-invalid-headers"></a>

  The [Request Header Specification policy]({{< ref "/nms/acm/how-to/policies/request-header-specification.md" >}}) allows headers with (.) and (\_) characters to be proxied to backend services.

  By default, NGINX server will drop all headers that contain (.) and (\_) characters in the header name. Though not common, it is a legal character in headers. This feature will allow users to instruct NGINX to allow such headers to be proxied.

- {{% icon-feature %}} **Regex support added to access control routing claims**<a name="1-7-0-whats-new-Regex-support-added-to-access-control-routing-claims"></a>

  Access control routing claims can be arrays. For example, roles and groups are typically represented as an array. You can now use a regular expression to match against claims embedded in arrays.

- {{% icon-feature %}} **Ingress routing rules now allow using regular expressions**<a name="1-7-0-whats-new-Ingress-routing-rules-now-allow-using-regular-expressions"></a>

  Regular expressions are now supported in routing rules. This will enable routing of requests that match against strings like `?wsdl`.


### Resolved Issues{#1-7-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} The routes filter under the proxy metrics page won’t work with params [(42471)]({{< ref "/nms/acm/releases/known-issues.md#42471" >}})<a name="1-7-0-resolved-issues-The-routes-filter-under-the-proxy-metrics-page-won’t-work-with-params"></a>
- {{% icon-resolved %}} Multiple entries selected when gateway proxy hostnames are the same [(42515)]({{< ref "/nms/acm/releases/known-issues.md#42515" >}})<a name="1-7-0-resolved-issues-Multiple-entries-selected-when-gateway-proxy-hostnames-are-the-same"></a>

### Known Issues{#1-7-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.6.0

May 11, 2023

### Upgrade Paths {#1-6-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.3.0 - 1.5.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-6-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Create security policies using an OAS specification**<a name="1-6-0-whats-new-Create-security-policies-using-an-OAS-specification"></a>

  With the latest update, you can now create APIKey and Basic Auth security policies using an OAS specification. This enhancement streamlines the process for creating policies, reduces errors, and improves system security. API Connectivity Manager and NGINX can be integrated into the build pipeline where you generate OpenAPI specs.

- {{% icon-feature %}} **New buffer settings were added to the HTTP Backend Configuration Proxy policy to enhance performance**<a name="1-6-0-whats-new-New-buffer-settings-were-added-to-the-HTTP-Backend-Configuration-Proxy-policy-to-enhance-performance"></a>

  With the latest HTTP Backend Configuration Proxy policy update, you can now modify the size and location of buffer temporary files or turn off buffering altogether. This enhancement offers greater flexibility and control to API Connectivity Manager users, allowing them to optimize their system's performance and improve the overall end-user experience.

- {{% icon-feature %}} **Gain deeper insights into your environments with enhanced analytics and metrics**<a name="1-6-0-whats-new-Gain-deeper-insights-into-your-environments-with-enhanced-analytics-and-metrics"></a>

  With this release, you can view more information about your environments. This includes the number of clusters and runtimes, the number of APIs available, and the total amount of data transmitted in and out of each cluster. Additionally, you can view graphs displaying crucial analytics, including traffic metrics, which can help you better understand your system's performance.


### Resolved Issues{#1-6-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} CORS policy doesn't support proxying preflight requests to the backend when combined with an authentication policy [(34449)]({{< ref "/nms/acm/releases/known-issues.md#34449" >}})<a name="1-6-0-resolved-issues-CORS-policy-doesn&#39;t-support-proxying-preflight-requests-to-the-backend-when-combined-with-an-authentication-policy"></a>
- {{% icon-resolved %}} TLS setting on listener is not reset when TLS policy is removed [(41426)]({{< ref "/nms/acm/releases/known-issues.md#41426" >}})<a name="1-6-0-resolved-issues-TLS-setting-on-listener-is-not-reset-when-TLS-policy-is-removed"></a>
- {{% icon-resolved %}} Developer Portal: When typing the links to use for the footer, the text boxes keep losing focus [(41626)]({{< ref "/nms/acm/releases/known-issues.md#41626" >}})<a name="1-6-0-resolved-issues-Developer-Portal:-When-typing-the-links-to-use-for-the-footer,-the-text-boxes-keep-losing-focus"></a>
- {{% icon-resolved %}} Array values in token claims are treated as string values [(42388)]({{< ref "/nms/acm/releases/known-issues.md#42388" >}})<a name="1-6-0-resolved-issues-Array-values-in-token-claims-are-treated-as-string-values"></a>

### Known Issues{#1-6-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.5.0

March 28, 2023

### Upgrade Paths {#1-5-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.2.0 - 1.4.1

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-5-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Use role-based access control for enhanced security and governance**<a name="1-5-0-whats-new-Use-role-based-access-control-for-enhanced-security-and-governance"></a>

  With new [built-in RBAC roles for API Connectivity Manager]({{< ref "/nim/admin-guide/rbac/overview-rbac.md#build-in-roles" >}}), administrators can grant or restrict user access to workspaces and features, empowering teams to manage their own workflows.

  {{< call-out "note" >}}
  - [Set Up RBAC for API Owners]({{< ref "/nms/acm/tutorials/rbac-api-owners.md" >}})
  - [Set Up RBAC for Infra Admins]({{< ref "/nms/acm/tutorials/rbac-infra-admins.md" >}})
  {{< /call-out>}}

- {{% icon-feature %}} **Multiple hostname support**<a name="1-5-0-whats-new-Multiple-hostname-support"></a>

  Proxy clusters can be shared across multiple environments (hostnames).

- {{% icon-feature %}} **Secure handling of sensitive data**<a name="1-5-0-whats-new-Secure-handling-of-sensitive-data"></a>

  API Connectivity Manager now provides enhanced security for sensitive data, including credentials used in APIKeys, Basic Auth, OAuth2, and JWT policies. All secrets are stored in a secure Vault and encrypted for added protection.

- {{% icon-feature %}} **Runtime state sharing in an API gateway or Developer Portal**<a name="1-5-0-whats-new-Runtime-state-sharing-in-an-API-gateway-or-Developer-Portal"></a>

  Administrators can use [cluster-wide policies]({{< ref "/nms/acm/how-to/policies/cluster-wide-config.md" >}}) to configure uniform settings across all instances in the cluster, such as worker connections, hash table size, and keepalive settings, to optimize performance. Furthermore, using the [Cluster Zone Sync policy]({{< ref "/nms/acm/how-to/policies/cluster-zone-sync.md" >}}), the cluster can be configured to share the runtime state and sync data across all instances, allowing for cluster-wide rate limits and sticky sessions.

- {{% icon-feature %}} **Performance improvements for the web interface**<a name="1-5-0-whats-new-Performance-improvements-for-the-web-interface"></a>

  A number of improvements have been made to how the web interface queries the backend services when fetching data.

- {{% icon-feature %}} **Add a Health Check policy to your gRPC proxy to ensure optimal performance**<a name="1-5-0-whats-new-Add-a-Health-Check-policy-to-your-gRPC-proxy-to-ensure-optimal-performance"></a>

  The [gRPC proxy can be enabled with a Health Check policy]({{< ref "/nms/acm/how-to/policies/grpc-policies.md#health-check" >}}), allowing it to check the health status of backend gRPC services and route requests accordingly.

- {{% icon-feature %}} **Improved certificate handling**<a name="1-5-0-whats-new-Improved-certificate-handling"></a>

  API Connectivity Manager will not generate new certificates if any have already been specified in the TLS policy; instead, ACM will reference the existing certificates. In this way, wildcard certificates may be employed.


### Security Updates{#1-5-0-security-updates}

{{< call-out "important" >}}
For the protection of our customers, NGINX doesn’t disclose security issues until an investigation has occurred and a fix is available.
{{< /call-out >}}

This release includes the following security updates:

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2023-1550**<a name="1-5-0-security-updates-Instance-Manager-vulnerability-CVE-2023-1550"></a>

  NGINX Agent inserts sensitive information into a log file ([CVE-2023-1550](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-1550)). An authenticated attacker with local access to read NGINX Agent log files may gain access to private keys. This issue is exposed only when the non-default trace-level logging is enabled.

  NGINX Agent is included with NGINX Instance Manager, and used in conjunction with API Connectivity Manager and the Security Monitoring module.

  This issue has been classified as [CWE-532: Insertion of Sensitive Information into Log File](https://cwe.mitre.org/data/definitions/532.html).

  - Mitigation:

    - Avoid configuring trace-level logging in the NGINX Agent configuration file. For more information, refer to the [Configuring the NGINX Agent]({{< ref "/nms/nginx-agent/install-nginx-agent.md#configuring-the-nginx-agent ">}}) section of NGINX Management Suite documentation. If trace-level logging is required, ensure only trusted users have access to the log files.

  - Fixed in:

    - NGINX Agent 2.23.3
    - Instance Manager 2.9.0

  For more information, refer to the MyF5 article [K000133135](https://my.f5.com/manage/s/article/K000133135).


### Changes in Default Behavior{#1-5-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **ACL IP Policy denies IP addresses by default**<a name="1-5-0-changes-in-behavior-ACL-IP-Policy-denies-IP-addresses-by-default"></a>

  Updates the ACL IP policy to deny IP addresses by default instead of allowing them by default.


### Resolved Issues{#1-5-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Configurations aren't pushed to newly onboarded instances if another instance is offline [(40035)]({{< ref "/nms/acm/releases/known-issues.md#40035" >}})<a name="1-5-0-resolved-issues-Configurations-aren&#39;t-pushed-to-newly-onboarded-instances-if-another-instance-is-offline"></a>
- {{% icon-resolved %}} The Proxy Cluster API isn't ready to be used [(40097)]({{< ref "/nms/acm/releases/known-issues.md#40097" >}})<a name="1-5-0-resolved-issues-The-Proxy-Cluster-API-isn&#39;t-ready-to-be-used"></a>

### Known Issues{#1-5-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.4.1

February 02, 2023

### Upgrade Paths {#1-4-1-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.1.0 - 1.4.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-4-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-4-1-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Resolved Issues{#1-4-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Cluster and Environment deletion issues when Portal Docs are published [(40163)]({{< ref "/nms/acm/releases/known-issues.md#40163" >}})<a name="1-4-1-resolved-issues-Cluster-and-Environment-deletion-issues-when-Portal-Docs-are-published"></a>

### Known Issues{#1-4-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.4.0

January 23, 2023

### Upgrade Paths {#1-4-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.1.0 - 1.3.1

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-4-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Allow or deny access to APIs for specified consumers**<a name="1-4-0-whats-new-Allow-or-deny-access-to-APIs-for-specified-consumers"></a>

  Control access to APIs to prevent unauthorized requests from designated consumers.

- {{% icon-feature %}} **OAuth2 Introspection policy now supports token claim verification**<a name="1-4-0-whats-new-OAuth2-Introspection-policy-now-supports-token-claim-verification"></a>

  API admins can configure an OAuth2 Introspection policy with token claim verification. If the value of an introspected token claim matches the values in the policy configuration, the request will be allowed to proceed to the backend. If not, the request will be denied, and `403 Forbidden` will be returned.

- {{% icon-feature %}} **Adds support for NGINX Plus R28**<a name="1-4-0-whats-new-Adds-support-for-NGINX-Plus-R28"></a>

  API Connectivity Manager 1.4.0 is compatible with NGINX Plus R28. For requirements related to NGINX Management Suite and API Connectivity Manager, please refer to the [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs.md" >}}) guide.


### Resolved Issues{#1-4-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} A JWT token present in a query parameter is not proxied to the backend for advanced routes  [(39328)]({{< ref "/nms/acm/releases/known-issues.md#39328" >}})<a name="1-4-0-resolved-issues-A-JWT-token-present-in-a-query-parameter-is-not-proxied-to-the-backend-for-advanced-routes-"></a>
- {{% icon-resolved %}} OIDC policy cannot be applied alongside a proxy authentication policy [(39604)]({{< ref "/nms/acm/releases/known-issues.md#39604" >}})<a name="1-4-0-resolved-issues-OIDC-policy-cannot-be-applied-alongside-a-proxy-authentication-policy"></a>

### Known Issues{#1-4-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.3.1

December 16, 2022

### Upgrade Paths {#1-3-1-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.0.0 - 1.3.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-3-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-3-1-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Resolved Issues{#1-3-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Developer Portal backend information is unintentionally updated when editing clusters within an environment [(39409)]({{< ref "/nms/acm/releases/known-issues.md#39409" >}})<a name="1-3-1-resolved-issues-Developer-Portal-backend-information-is-unintentionally-updated-when-editing-clusters-within-an-environment"></a>
- {{% icon-resolved %}} The Inbound TLS policy breaks when upgrading from API Connectivity Manager 1.2.0 to 1.3.0. [(39426)]({{< ref "/nms/acm/releases/known-issues.md#39426" >}})<a name="1-3-1-resolved-issues-The-Inbound-TLS-policy-breaks-when-upgrading-from-API-Connectivity-Manager-1-2-0-to-1-3-0-"></a>
- {{% icon-resolved %}} The web interface doesn't pass the `enableSNI` property for the TLS backend policy [(39445)]({{< ref "/nms/acm/releases/known-issues.md#39445" >}})<a name="1-3-1-resolved-issues-The-web-interface-doesn&#39;t-pass-the-`enableSNI`-property-for-the-TLS-backend-policy"></a>

### Known Issues{#1-3-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.3.0

December 12, 2022

### Upgrade Paths {#1-3-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.0.0 - 1.2.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-3-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Configure access-controlled routing**<a name="1-3-0-whats-new-Configure-access-controlled-routing"></a>

  API lifecycle management requires routing API traffic with fine-level control, which is something that token-based authentication schemes that leverage JWT claims do well. Permissions can be encoded as custom claims in the token. Then, once the API proxy validates the token (JWT), it can access all the fields in the token as variables. Decisions can be made based on matching the claims.

  - Applying Fine-Grained Access Control

      API Owners can apply fine-grained access control and restrict access to their APIs based on specific claims in the token. The policy can be configured to enforce fine-grained control for specific routes or be fine-tuned to support particular methods per route.

  - Header-Based Routing

      Routing decisions can be made based on headers in the incoming requests. API owners can configure rules and conditions that must be matched before routing requests.

  See [Configure Access Control Routing]({{< ref "/nms/acm/how-to/policies/access-control-routing.md" >}}) to learn how to restrict access to your application servers based on JWT claims or header values.

- {{% icon-feature %}} **Use the web interface to publish and manage gRPC services**<a name="1-3-0-whats-new-Use-the-web-interface-to-publish-and-manage-gRPC-services"></a>

  With API Connectivity Manager 1.2, we introduced support for [publishing and managing gRPC services]({{< ref "/nms/acm/how-to/policies/grpc-policies.md" >}}). Now, in this release, we extend that capability to the web interface.

  You can secure gRPC services with the following policies:

  - gRPC environment policies

    - Error Response Format
    - Log Format
    - Proxy Response Headers
    - Request Body Size Limit
    - Request Correlation ID
    - TLS Backend
    - TLS Inbound

  - gRPC proxy policies:

    - ACL IP Restriction
    - APIKey Authentication
    - Basic Authentication
    - GRPC Backend Config
    - JSON Web Token Assertion
    - OAuth2 Introspection
    - Proxy Request Headers
    - Rate Limit

- {{% icon-feature %}} **Secure communication between API Connectivity Manager and Developer Portal with mTLS**<a name="1-3-0-whats-new-Secure-communication-between-API-Connectivity-Manager-and-Developer-Portal-with-mTLS"></a>

  API Connectivity Manager communicates with the Developer Portal host to publish API docs and create API credentials. Now, PlatformOps can secure this communication channel by enabling mTLS between the hosts.

  Previously, mTLS required a TLS backend policy on the internal portal proxy cluster. API Connectivity Manager 1.3 removes that restriction. The TLS inbound policy on the internal portal allows providing a client certificate for API Connectivity Manager when mTLS is enabled. API Connectivity Manager presents this client certificate when connecting to the Developer Portal, identifying itself as a trusted client.

- {{% icon-feature %}} **Other Enhancements**<a name="1-3-0-whats-new-Other-Enhancements"></a>

  - **Improved policy layout**

    The Policy user interface has been improved with highlights for the different policy sections.

  - **NGINX Management Suite config changes are preserved during upgrade**

      Upgrades no longer overwrite customized configurations unless instructed to by the user.

  - **Support for chained certificates**

    Infrastructure administrators can now upload public certificates in PEM format, along with an optional list of intermediate certificates for validating the public certificate.

  - **Support for SNI requirements from hosted services**

    API owners can now use the OAuth2 policy with hosted Identity Provider services that enforce Server Name Indication (SNI).


### Resolved Issues{#1-3-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} No validation when conflicting policies are added [(34531)]({{< ref "/nms/acm/releases/known-issues.md#34531" >}})<a name="1-3-0-resolved-issues-No-validation-when-conflicting-policies-are-added"></a>
- {{% icon-resolved %}} Installing NGINX Agent on Ubuntu 22.04 LTS fails with `404 Not Found` error [(35339)]({{< ref "/nms/acm/releases/known-issues.md#35339" >}})<a name="1-3-0-resolved-issues-Installing-NGINX-Agent-on-Ubuntu-22-04-LTS-fails-with-`404-Not-Found`-error"></a>
- {{% icon-resolved %}} New users are unable to see pages even though they have been given access. [(36607)]({{< ref "/nms/acm/releases/known-issues.md#36607" >}})<a name="1-3-0-resolved-issues-New-users-are-unable-to-see-pages-even-though-they-have-been-given-access-"></a>
- {{% icon-resolved %}} Portals secured with TLS policy require additional environment configuration prior to publishing API docs [(38028)]({{< ref "/nms/acm/releases/known-issues.md#38028" >}})<a name="1-3-0-resolved-issues-Portals-secured-with-TLS-policy-require-additional-environment-configuration-prior-to-publishing-API-docs"></a>
- {{% icon-resolved %}} The user interface is erroneously including irrelevant information on the TLS inbound policy workflow [(38046)]({{< ref "/nms/acm/releases/known-issues.md#38046" >}})<a name="1-3-0-resolved-issues-The-user-interface-is-erroneously-including-irrelevant-information-on-the-TLS-inbound-policy-workflow"></a>

### Known Issues{#1-3-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.2.0

October 18, 2022

### Upgrade Paths {#1-2-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.0.0 - 1.1.1

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-2-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Restrict access to APIs based on IP address**<a name="1-2-0-whats-new-Restrict-access-to-APIs-based-on-IP-address"></a>

  Using the [ACL-IP policy]({{< ref "/nms/acm/how-to/policies/api-access-control-lists.md" >}}), API owners can now restrict access to APIs based on IP addresses. APIs can be protected by quickly blocking rogue requests from certain IPs or allowing access to only known IPs.

- {{% icon-feature %}} **Secure API access with OAuth2 tokens**<a name="1-2-0-whats-new-Secure-API-access-with-OAuth2-tokens"></a>

  API Owners can [restrict access to their APIs with OAuth2 tokens]({{< ref "/nms/acm/how-to/policies/introspection.md" >}}) by swapping an opaque token for claims or a JWT token to be proxied to the backend service. The policy can be configured to grant access to APIs after having the tokens introspected. In addition, the claims in the token can be extracted and forwarded to the backend service.

  {{< call-out "tip" >}}Learn how to [set up an OAuth2 Introspection policy with Keycloak]({{< ref "/nms/acm/tutorials/introspection-keycloak.md" >}}) as the authorization server.{{< /call-out >}}

- {{% icon-feature %}} **Enhanced API documentation on developer portal**<a name="1-2-0-whats-new-Enhanced-API-documentation-on-developer-portal"></a>

  The API documentation published to the Developer Portal now displays detailed security schema information for each API.

- {{% icon-feature %}} **Support for HTTP/2**<a name="1-2-0-whats-new-Support-for-HTTP/2"></a>

  To improve the performance and efficiency of client-server interactions, HTTP/2 can be enabled on the [API proxies]({{< ref "/nms/acm/getting-started/publish-api-proxy.md#set-up-api-proxy" >}}). With HTTP/2 enabled, API Proxies will continue to maintain backward compatibility with older browsers.

- {{% icon-feature %}} **Improved visualizations for resource credentials**<a name="1-2-0-whats-new-Improved-visualizations-for-resource-credentials"></a>

  API owners can now view the origin of resource credentials. The source field indicates where the credentials were created. For security reasons, the credentials created on the Developer Portal will be masked, but the API owners can view the origin of the resource credentials.

- {{% icon-feature %}} **Express API payload size with unit of measure**<a name="1-2-0-whats-new-Express-API-payload-size-with-unit-of-measure"></a>

  The maximum allowed size for the client request body can now be configured in bytes, kilobytes(K) or megabytes(M).

  The `maxRequestBodySizeLimit` attribute of the policy is deprecated and will be removed in API Connectivity Manager 1.3.0. `Size` is the new attribute that supports bytes, megabytes(M), and kilobytes(K). The default setting is 1M.

- {{% icon-feature %}} **Database backup included in support packages**<a name="1-2-0-whats-new-Database-backup-included-in-support-packages"></a>

  The [Developer Portal support package]({{< ref "/nms/support/support-package.md" >}}) now includes the option to back up the PostgreSQL database.

- {{% icon-feature %}} **Publish and manage gRPC services - preview release**<a name="1-2-0-whats-new-Publish-and-manage-gRPC-services---preview-release"></a>

  {{< call-out "important" >}}This is a **preview** feature for you to try out. You shouldn't use preview features for production purposes.{{< /call-out >}}

  To handle gRPC traffic, you can now [publish and manage gRPC proxies]({{< ref "/nms/acm/how-to/services/publish-grpc-proxy.md" >}}).

  Publish gRPC proxies and route gRPC traffic to support the following use cases:

  - Simple RPC (single request‑response)
  - Response‑streaming RPC
  - Request‑streaming RPC
  - Bidirectional‑streaming RPC
  - Route to all services in a gRPC service package
  - Route to a single gRPC service
  - Route to individual gRPC methods
  - Route to multiple gRPC services
  - Respond to errors with custom gRPC error response format policy

- {{% icon-feature %}} **Out-of-the-box protection for Developer Portals**<a name="1-2-0-whats-new-Out-of-the-box-protection-for-Developer-Portals"></a>

  Developer Portals are now deployed with out-of-the-box protection against rapid requests/overuse and server fingerprinting:

  1. Protection against server fingerprinting

    The proxy response header policy is now applied by default to a Developer Portal. The default policy disables server tokens from being returned in the proxy response.

  2. Protection against rapid requests and over-use

    To protect the portal application, the default rate limit policy limits the number of requests a client can make in a time period. Platform admins can customize the policy to meet their SLAs.

- {{% icon-feature %}} **Support for multi-host deployment pattern for Developer Portals**<a name="1-2-0-whats-new-Support-for-multi-host-deployment-pattern-for-Developer-Portals"></a>

  Developer Portals can support multiple deployment patterns. The portal backend API service can be scaled to multiple hosts and can be load-balanced using host IP addresses or internal DNS.

  To support the deployment patterns, `configs -> proxyConfig -> backends ` object has been introduced in the Portal Proxy runtime. The existing `backend` object in the `proxyCluster` object of the Portal Proxy runtime is being deprecated and will not be available in the next major release version.


### Resolved Issues{#1-2-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Enums are not supported in Advanced Routing. [(34854)]({{< ref "/nms/acm/releases/known-issues.md#34854" >}})<a name="1-2-0-resolved-issues-Enums-are-not-supported-in-Advanced-Routing-"></a>
- {{% icon-resolved %}} Unable to delete an environment that is stuck in a Configuring state. [(35546)]({{< ref "/nms/acm/releases/known-issues.md#35546" >}})<a name="1-2-0-resolved-issues-Unable-to-delete-an-environment-that-is-stuck-in-a-Configuring-state-"></a>
- {{% icon-resolved %}} Credentials endpoint is disabled by default [(35630)]({{< ref "/nms/acm/releases/known-issues.md#35630" >}})<a name="1-2-0-resolved-issues-Credentials-endpoint-is-disabled-by-default"></a>
- {{% icon-resolved %}} Ratelimit policy cannot be applied with OAuth2 JWT Assertion policy. [(36095)]({{< ref "/nms/acm/releases/known-issues.md#36095" >}})<a name="1-2-0-resolved-issues-Ratelimit-policy-cannot-be-applied-with-OAuth2-JWT-Assertion-policy-"></a>
- {{% icon-resolved %}} Using labels to specify the backend is partially available [(36317)]({{< ref "/nms/acm/releases/known-issues.md#36317" >}})<a name="1-2-0-resolved-issues-Using-labels-to-specify-the-backend-is-partially-available"></a>
- {{% icon-resolved %}} To see updates to the Listener's table, forced refresh of the cluster details page is required. [(36540)]({{< ref "/nms/acm/releases/known-issues.md#36540" >}})<a name="1-2-0-resolved-issues-To-see-updates-to-the-Listener&#39;s-table,-forced-refresh-of-the-cluster-details-page-is-required-"></a>

### Known Issues{#1-2-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.1.1

August 31, 2022

### Upgrade Paths {#1-1-1-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.0.0 - 1.1.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-1-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-1-1-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Resolved Issues{#1-1-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} OIDC policy doesn't work with Auth0 Identity Providers [(36058)]({{< ref "/nms/acm/releases/known-issues.md#36058" >}})<a name="1-1-1-resolved-issues-OIDC-policy-doesn&#39;t-work-with-Auth0-Identity-Providers"></a>
- {{% icon-resolved %}} Traffic is not secured between the API Proxy and backend servers [(36714)]({{< ref "/nms/acm/releases/known-issues.md#36714" >}})<a name="1-1-1-resolved-issues-Traffic-is-not-secured-between-the-API-Proxy-and-backend-servers"></a>
- {{% icon-resolved %}} Advanced routing ignores the Context Root setting for backend proxies [(36775)]({{< ref "/nms/acm/releases/known-issues.md#36775" >}})<a name="1-1-1-resolved-issues-Advanced-routing-ignores-the-Context-Root-setting-for-backend-proxies"></a>

### Known Issues{#1-1-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.1.0

August 18, 2022

### Upgrade Paths {#1-1-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.0.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-1-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Advanced Cluster Management**<a name="1-1-0-whats-new-Advanced-Cluster-Management"></a>

  Including more than one proxy cluster with the same hostname in an environment replicates configuration across all clusters and assists with blue-green deployments. With advanced cluster management, you can use a load balancer in front of the clusters to slowly move to the newer version of the API gateway. For example, one cluster may belong to NGINX Plus version R26 and another to R27. See the [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs.md#data-plane-dev-portal" >}}).

- {{% icon-feature %}} **Advanced Routing feature is available now**<a name="1-1-0-whats-new-Advanced-Routing-feature-is-available-now"></a>

  Advanced routing feature is available now. You can use it to publish an API Proxy and route specific URIs/endpoints precisely to a backend service. Advanced routing with OAS Specification allows you to import a specification file, parse all the URIs/endpoints in the file and publish API proxy by routing each URI/endpoint precisely to a backend service. To use the advanced routing feature without an OAS specification file, add the URI/endpoints while publishing the API proxy. See the [Advanced Configurations]({{< ref "/nms/acm/how-to/services/publish-api.md#advanced-configurations" >}}) section.

- {{% icon-feature %}} **SQLite is supported for Developer Portal**<a name="1-1-0-whats-new-SQLite-is-supported-for-Developer-Portal"></a>

  SQLite is now supported as a database for [Developer Portal installations]({{< ref "/nms/acm/getting-started/add-devportal.md" >}}).

- {{% icon-feature %}} **Support for NGINX Plus Release 27 (R27)**<a name="1-1-0-whats-new-Support-for-NGINX-Plus-Release-27-(R27)"></a>

  This release supports NGINX Plus Release 27 (R27) version for Data Plane instances. See the [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs.md" >}}).


### Resolved Issues{#1-1-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} JWT Assertion policy accepts an empty string value for tokenName property [(35419)]({{< ref "/nms/acm/releases/known-issues.md#35419" >}})<a name="1-1-0-resolved-issues-JWT-Assertion-policy-accepts-an-empty-string-value-for-tokenName-property"></a>
- {{% icon-resolved %}} Environment is in a premature success state even though all proxy clusters may not be onboarded [(35430)]({{< ref "/nms/acm/releases/known-issues.md#35430" >}})<a name="1-1-0-resolved-issues-Environment-is-in-a-premature-success-state-even-though-all-proxy-clusters-may-not-be-onboarded"></a>
- {{% icon-resolved %}} Cannot add, remove, or edit proxy clusters from an environment that has a published API proxy  [(35463)]({{< ref "/nms/acm/releases/known-issues.md#35463" >}})<a name="1-1-0-resolved-issues-Cannot-add,-remove,-or-edit-proxy-clusters-from-an-environment-that-has-a-published-API-proxy-"></a>
- {{% icon-resolved %}} Features in the web interface are not displayed after uploading license [(35525)]({{< ref "/nms/acm/releases/known-issues.md#35525" >}})<a name="1-1-0-resolved-issues-Features-in-the-web-interface-are-not-displayed-after-uploading-license"></a>
- {{% icon-resolved %}} DEVPORTAL_OPTS in /etc/{default,sysconfig}/nginx-devportal does not work if value has multiple words [(36040)]({{< ref "/nms/acm/releases/known-issues.md#36040" >}})<a name="1-1-0-resolved-issues-DEVPORTAL_OPTS-in-/etc/{default,sysconfig}/nginx-devportal-does-not-work-if-value-has-multiple-words"></a>

### Known Issues{#1-1-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.0.0

July 19, 2022


<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>


### What's New{#1-0-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **API Connectivity Manager is now available**<a name="1-0-0-whats-new-API-Connectivity-Manager-is-now-available"></a>

  - Create and manage isolated workspaces for business units, development teams, etc., so each team can develop and deploy at its own pace without affecting other teams.
  - Create and manage API infrastructure in isolated workspaces.
  - Create and manage production and non-production environments within team workspaces and control who can access APIs at various lifecycle stages. For example, keep APIs under development private and publish production-ready APIs for public access.
  - Enforce uniform security policies across all workspaces by applying global policies.
  - Create Developer Portals that align with your brand, with custom color themes, logos, and favicons.
  - On-board your APIs, publish to an API gateway, and publish your API documentation to the Developer Portal.
  - Let teams apply policies to their API proxies to provide custom quality of service for individual applications.
  - On-board API documentation by uploading an OpenAPI spec.
  - Publish your API docs to a Developer Portal without giving the public access to your API.
  - Monitor system and traffic metrics at the instance level.
  - Self-service credential issuance for API Keys and Basic Authentication.
  - Test API calls to your system using the "Try it out" feature in the Developer Portal.


### Known Issues{#1-0-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nms/acm/releases/known-issues.md" >}}) topic.

