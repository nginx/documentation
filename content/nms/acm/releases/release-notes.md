---
title: "Release Notes"
date: 2022-07-10T12:38:24-08:00
draft: false
description: "These release notes list and describe the new features, enhancements, and resolved issues in NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 1
toc: true
tags: [ "docs" ]
docs: "DOCS-931"
categories: ["release notes"]
---

{{<rn-styles>}}

---

## 1.7.0
June 21, 2023

### Upgrade Paths {#1-7-0-upgrade-paths}

API Connectivity Manager  supports upgrades from these previous versions:

- 1.5.0 - 1.6.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

### What's New
This release includes the following updates:

- {{% icon-feature %}} **Advanced Security Policy**

  The new [Advanced Security policy]({{< relref "/nms/acm/how-to/policies/advanced-security.md" >}}) can be used to add a pre-defined NGINX App Protect configuration to your deployment.  Doing so will apply the rules specified in the policy to your APIs.
  
- {{% icon-feature %}} **Option added to allow API proxy to ignore invalid headers**

  The [Request Header Specification policy]({{< relref "/nms/acm/how-to/policies/request-header-specification.md" >}}) allows headers with (.) and (_) characters to be proxied to backend services.

  By default, the NGINX server will drop all headers that contain (.) and (_) characters in the header name. Though not common, it is a legal character in headers. This feature instructs NGINX to allow such headers to be proxied.
  
- {{% icon-feature %}} **Regex support added to access control routing claims**

  Access control routing claims can be arrays. For example, roles and groups are typically represented as an array. You can now use a regular expression to match against claims embedded in arrays.
  
- {{% icon-feature %}} **Ingress routing rules now allow using regular expressions**

  Regular expressions are now supported in routing rules. This will enable routing of requests that match against strings like '?wsdl'.
  


### Resolved Issues
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} The routes filter under the proxy metrics page won’t work with params [(42471)]({{< relref "/nms/acm/releases/known-issues.md#42471" >}})
- {{% icon-resolved %}} Multiple entries selected when gateway proxy hostnames are the same [(42515)]({{< relref "/nms/acm/releases/known-issues.md#42515" >}})

### Known Issues

You can find information about known issues in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---


## 1.6.0

5/11/2023

### Upgrade Paths {#1-6-0-upgrade-paths}

API Connectivity Manager 1.6.0 supports upgrades from these previous versions:

- 1.3.0–1.5.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New {#1-6-0-whats-new}

This release includes the following updates:

- {{% icon-feature %}} **Create security policies using an OAS specification**

  With the latest update, you can now create APIKey and Basic Auth security policies using an OAS specification. This enhancement streamlines the process for creating policies, reduces errors, and improves system security. API Connectivity Manager and NGINX can be integrated into the build pipeline where you generate OpenAPI specs.

- {{% icon-feature %}} **New buffer settings were added to the HTTP Backend Configuration Proxy policy to enhance performance**

  With the latest HTTP Backend Configuration Proxy policy update, you can now modify the size and location of buffer temporary files or turn off buffering altogether. This enhancement offers greater flexibility and control to API Connectivity Manager users, allowing them to optimize their system's performance and improve the overall end-user experience.

- {{% icon-feature %}} **Gain deeper insights into your environments with enhanced analytics and metrics**

  With this release, you can view more information about your environments. This includes the number of clusters and runtimes, the number of APIs available, and the total amount of data transmitted in and out of each cluster. Additionally, you can view graphs displaying crucial analytics, including traffic metrics, which can help you better understand your system's performance.

### Resolved Issues {#1-6-0-resolved-issues}

This release fixes the following issues. Select an issue's ID link to view its details.


- {{% icon-resolved %}} CORS policy doesn't support proxying preflight requests to the backend when combined with an authentication policy [(34449)]({{< relref "/nms/acm/releases/known-issues.md#34449" >}})

- {{% icon-resolved %}} TLS setting on listener is not reset when TLS policy is removed [(41426)]({{< relref "/nms/acm/releases/known-issues.md#41426" >}})

- {{% icon-resolved %}} Developer Portal: When typing the links to use for the footer, the text boxes keep losing focus [(41626)]({{< relref "/nms/acm/releases/known-issues.md#41626" >}})

- {{% icon-resolved %}} Array values in token claims are treated as string values [(42388)]({{< relref "/nms/acm/releases/known-issues.md#42388" >}})


---

## 1.5.0

3/28/2023

### Upgrade Paths {#1-5-0-upgrade-paths}

API Connectivity Manager 1.5.0 supports upgrades from these previous versions:

- 1.2.0–1.4.1

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New {#1-5-0-whats-new}

This release includes the following updates:

- {{% icon-feature %}} **Runtime state sharing in an API gateway or Developer Portal**

  Administrators can use [cluster-wide policies]({{< relref "/nms/acm/how-to/policies/cluster-wide-config.md" >}}) to configure uniform settings across all instances in the cluster, such as worker connections, hash table size, and keepalive settings, to optimize performance. Furthermore, using the [Cluster Zone Sync policy]({{< relref "/nms/acm/how-to/policies/cluster-zone-sync.md" >}}), the cluster can be configured to share the runtime state and sync data across all instances, allowing for cluster-wide rate limits and sticky sessions.

- {{% icon-feature %}} **Use role-based access control for enhanced security and governance**

  With new [built-in RBAC roles for API Connectivity Manager]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md#build-in-roles" >}}), administrators can grant or restrict user access to workspaces and features, empowering teams to manage their own workflows.

  {{<see-also>}}
  - [Set Up RBAC for API Owners]({{< relref "/nms/acm/tutorials/rbac-api-owners.md" >}})
  - [Set Up RBAC for Infra Admins]({{< relref "/nms/acm/tutorials/rbac-infra-admins.md" >}})
  {{</see-also>}}

- {{% icon-feature %}} **Secure handling of sensitive data**

  API Connectivity Manager now provides enhanced security for sensitive data, including credentials used in APIKeys, Basic Auth, OAuth2, and JWT policies. All secrets are stored in a secure Vault and encrypted for added protection.

- {{% icon-feature %}} **Multiple hostname support**

  Proxy clusters can be shared across multiple environments (hostnames).

- {{% icon-feature %}} **Improved certificate handling**

  API Connectivity Manager will not generate new certificates if any have already been specified in the TLS policy; instead, API Connectivity Manager will reference the existing certificates. In this way, wildcard certificates may be employed.

- {{% icon-feature %}} **Add a Health Check policy to your gRPC proxy to ensure optimal performance**

  The [gRPC proxy can be enabled with a Health Check policy]({{< relref "/nms/acm/how-to/policies/grpc-policies.md#health-check" >}}), allowing it to check the health status of backend gRPC services and route requests accordingly.

- {{% icon-feature %}} **Performance improvements for the web interface**

  A number of improvements have been made to how the web interface queries the backend services when fetching data.

### Security Update {#1-5-0-security-update}

{{< important >}}For the protection of our customers, NGINX doesn't disclose security issues until an investigation has occurred and a fix is available.{{< /important >}}

This release includes the following security update:

{{< include "release-notes/41215.md" >}}

### Changes in Default Behavior {#1-5-0-changes-default-behavior}

API Connectivity Manager 1.5.0 has the following changes in default behavior:

- {{% icon-feature %}} **ACL IP Policy denies IP addresses by default**

  Updates the ACL IP policy to deny IP addresses by default instead of allowing them by default.

### Resolved Issues {#1-5-0-resolved-issues}

This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Configurations aren't pushed to newly onboarded instances if another instance is offline [(40035)]({{< relref "/nms/acm/releases/known-issues.md#40035" >}})

- {{% icon-resolved %}} The Proxy Cluster API isn't ready to be used [(40097)]({{< relref "/nms/acm/releases/known-issues.md#40097" >}})

### Known Issues {#1-5-0-known-issues}

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.4.1

February 2, 2023

### Upgrade Paths

API Connectivity Manager 1.4.1 supports upgrades from these previous versions:

- 1.1.0–1.4.0

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

<details open>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**

  This release includes stability and performance improvements.


### Resolved Issues

This release fixes the following issue. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/acm/releases/known-issues.md" >}}).


- {{% icon-resolved %}} Cluster and Environment deletion issues when Portal Docs are published (40163)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.4.0

January 23, 2023

### Upgrade Paths

API Connectivity Manager 1.4.0 supports direct upgrades from these previous versions:

- 1.1.0–1.3.1

If your installed version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New

This release features the following updates:

- {{% icon-feature %}} **OAuth2 Introspection policy now supports token claim verification**

  API admins can configure an OAuth2 Introspection policy with token claim verification. If the value of an introspected token claim matches the values in the policy configuration, the request will be allowed to proceed to the backend. If not, the request will be denied, and `403 Forbidden` will be returned.

- {{% icon-feature %}} **Adds support for NGINX Plus R28**

  API Connectivity Manager 1.4.0 is compatible with NGINX Plus R28. For requirements related to NGINX Management Suite and API Connectivity Manager, please refer to the [Technical Specifications]({{< relref "/nms/tech-specs.md" >}}) guide.

- {{% icon-feature %}} **Allow or deny access to APIs for specified consumers**

  Control access to APIs to prevent unauthorized requests from designated consumers.

### Resolved Issues

This release fixes the following issues. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/acm/releases/known-issues.md" >}}).

- {{% icon-resolved %}} OIDC policy cannot be applied alongside a proxy authentication policy (39604)

- {{% icon-resolved %}} A JWT token present in a query parameter is not proxied to the backend for advanced routes  (39328)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.3.1

December 16, 2022

### Upgrade Paths

API Connectivity Manager 1.3.1 supports upgrades from the following versions:

- 1.0.0 – 1.3.0

If you are using an older version of API Connectivity Manager, you may need to upgrade to an intermediate version before upgrading to the target version.

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

### What's New

- This release includes stability and performance improvements.

### Resolved Issues

This release fixes the following issues:

- {{% icon-resolved %}} Developer Portal backend information is unintentionally updated when editing clusters within an environment (39409)

- {{% icon-resolved %}} The web interface doesn't pass the `enableSNI` property for the TLS backend policy (39445)

- {{% icon-resolved %}} The Inbound TLS policy breaks when upgrading from API Connectivity Manager 1.2.0 to 1.3.0. (39426)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.3.0

December 12, 2022

### Upgrade Paths

API Connectivity Manager 1.3.0 supports upgrades from the following versions:

- 1.0.0 – 1.2.0

If you are using an older version of API Connectivity Manager, you may need to upgrade to an intermediate version before upgrading to the target version.

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Configure access-controlled routing**

    API lifecycle management requires routing API traffic with fine-level control, which is something that token-based authentication schemes that leverage JWT claims do well. Permissions can be encoded as custom claims in the token. Then, once the API proxy validates the token (JWT), it can access all the fields in the token as variables. Decisions can be made based on matching the claims.

  - Applying Fine-Grained Access Control

    API Owners can apply fine-grained access control and restrict access to their APIs based on specific claims in the token. The policy can be configured to enforce fine-grained control for specific routes or be fine-tuned to support particular methods per route. 

  - Header-Based Routing

    Routing decisions can be made based on headers in the incoming requests. API owners can configure rules and conditions that must be matched before routing requests.

  See [Configure Access Control Routing]({{< relref "/nms/acm/how-to/policies/access-control-routing.md" >}}) to learn how to restrict access to your application servers based on JWT claims or header values.

- {{% icon-feature %}} **Use the web interface to publish and manage gRPC services**

  With API Connectivity Manager 1.2, we introduced support for [publishing and managing gRPC services]({{< relref "/nms/acm/how-to/policies/grpc-policies.md" >}}). Now, in this release, we extend that capability to the web interface. 

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

- {{% icon-feature %}} **Secure communication between API Connectivity Manager and Developer Portal with mTLS**

  API Connectivity Manager communicates with the Developer Portal host to publish API docs and create API credentials. Now, PlatformOps can secure this communication channel by enabling mTLS between the hosts.

  Previously, mTLS required a TLS backend policy on the internal portal proxy cluster. API Connectivity Manager 1.3 removes that restriction. The TLS inbound policy on the internal portal allows providing a client certificate for API Connectivity Manager when mTLS is enabled. API Connectivity Manager presents this client certificate when connecting to the Developer Portal, identifying itself as a trusted client.

- {{% icon-feature %}} **Other Enhancements**

  - **Improved policy layout**

    The Policy user interface has been improved with highlights for the different policy sections.

  - **NGINX Management Suite config changes are preserved during upgrade**

    Upgrades no longer overwrite customized configurations unless instructed to by the user.

  - **Support for chained certificates**

    Infrastructure administrators can now upload public certificates in PEM format, along with an optional list of intermediate certificates for validating the public certificate.

  - **Support for SNI requirements from hosted services**

    API owners can now use the OAuth2 policy with hosted Identity Provider services that enforce Server Name Indication (SNI).

### Resolved Issues

This release fixes the following issues:

- {{% icon-resolved %}} No validation when conflicting policies are added (34531)

- {{% icon-resolved %}} Installing NGINX Agent on Ubuntu 22.04 LTS fails with `404 Not Found` error (35339)

- {{% icon-resolved %}} New users are unable to see pages even though they have been given access. (36607)

- {{% icon-resolved %}} Portals secured with TLS policy require additional environment configuration prior to publishing API docs (38028)

- {{% icon-resolved %}} The user interface is erroneously including irrelevant information on the TLS inbound policy workflow (38046)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.2.0

October 18, 2022

### Upgrade Paths

API Connectivity Manager 1.2.0 supports upgrades from these previous versions:

- 1.0.0 – 1.1.1

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New

- {{% icon-feature %}} **Secure API access with OAuth2 tokens**

  API Owners can [restrict access to their APIs with OAuth2 tokens]({{< relref "/nms/acm/how-to/policies/introspection.md" >}}) by swapping an opaque token for claims or a JWT token to be proxied to the backend service. The policy can be configured to grant access to APIs after having the tokens introspected. In addition, the claims in the token can be extracted and forwarded to the backend service.

  {{<tip>}}Learn how to [set up an OAuth2 Introspection policy with Keycloak]({{< relref "/nms/acm/tutorials/introspection-keycloak.md" >}}) as the authorization server.{{</tip>}}

- {{% icon-feature %}} **Restrict access to APIs based on IP address**

  Using the [ACL-IP policy]({{< relref "/nms/acm/how-to/policies/api-access-control-lists.md" >}}), API owners can now restrict access to APIs based on IP addresses. APIs can be protected by quickly blocking rogue requests from certain IPs or allowing access to only known IPs.
  
- {{% icon-feature %}} **Support for HTTP/2**

  To improve the performance and efficiency of client-server interactions, HTTP/2 can be enabled on the [API proxies]({{< relref "/nms/acm/getting-started/publish-api-proxy.md#set-up-api-proxy" >}}). With HTTP/2 enabled, API Proxies will continue to maintain backward compatibility with older browsers.

- {{% icon-feature %}} **Publish and manage gRPC services - preview release**

  {{<important>}}This is a **preview** feature for you to try out. You shouldn't use preview features for production purposes.{{</important>}}
  
  To handle gRPC traffic, you can now [publish and manage gRPC proxies]({{< relref "/nms/acm/getting-started/publish-grpc-proxy.md" >}}).

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

- {{% icon-feature %}} **Out-of-the-box protection for Developer Portals**

  Developer Portals are now deployed with out-of-the-box protection against rapid requests/overuse and server fingerprinting:

  1. Protection against server fingerprinting

      The proxy response header policy is now applied by default to a Developer Portal. The default policy disables server tokens from being returned in the proxy response.

  2. Protection against rapid requests and over-use

      To protect the portal application, the default rate limit policy limits the number of requests a client can make in a time period. Platform admins can customize the policy to meet their SLAs.

- {{% icon-feature %}} **Support for multi-host deployment pattern for Developer Portals**

  Developer Portals can support multiple deployment patterns. The portal backend API service can be scaled to multiple hosts and can be load-balanced using host IP addresses or internal DNS.

  To support the deployment patterns, `configs -> proxyConfig -> backends ` object has been introduced in the Portal Proxy runtime. The existing `backend` object in the `proxyCluster` object of the Portal Proxy runtime is being deprecated and will not be available in the next major release version.  

- {{% icon-feature %}} **Enhanced API documentation on Developer Portals**

  The API documentation published to the Developer Portal now displays detailed security schema information for each API.

- {{% icon-feature %}} **Express API payload size with unit of measure**

  The maximum allowed size for the client request body can now be configured in bytes, kilobytes(K) or megabytes(M).

  The `maxRequestBodySizeLimit` attribute of the policy is deprecated and will be removed in the next major API Connectivity Manager release. `Size` is the new attribute that supports bytes, megabytes(M), and kilobytes(K). The default setting is 1M.

- {{% icon-feature %}} **Database backup included in support packages**

  The [Developer Portal support package]({{< relref "/nms/support/support-package.md" >}}) now includes the option to back up the PostgreSQL database.

- {{% icon-feature %}} **Improved visualizations for resource credentials**

  API owners can now view the origin of resource credentials. The source field indicates where the credentials were created. For security reasons, the credentials created on the Developer Portal will be masked, but the API owners can view the origin of the resource credentials.

### Resolved Issues

This release fixes the following issues. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/acm/releases/known-issues.md" >}}).

- {{% icon-resolved %}} To see updates to the Listener's table, forced refresh of the cluster details page is required. (36540)

- {{% icon-resolved %}} Using labels to specify the backend is partially available. (36317)

- {{% icon-resolved %}} Ratelimit policy cannot be applied with OAuth2 JWT Assertion policy. (36095)

- {{% icon-resolved %}} Unable to delete an environment that is stuck in a Configuring state. (35546)

- {{% icon-resolved %}} Enums are not supported in Advanced Routing. (34854)

- {{% icon-resolved %}} Credentials endpoint is disabled by default. (35630)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.1.1

August 31, 2022

### Upgrade Paths

API Connectivity Manager 1.1.1 supports upgrades from these previous versions:

- 1.0.0 – 1.1.0

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New

- This release includes stability and performance improvements.

### Resolved Issues

This release fixes the following issues. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/acm/releases/known-issues.md" >}}).

- {{% icon-resolved %}} Advanced routing ignores the Context Root setting for backend proxies (36775)

- {{% icon-resolved %}} Traffic is not secured between the API Proxy and backend servers (36714)

- {{% icon-resolved %}} OIDC policy doesn't work with Auth0 Identity Providers (36058)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.1.0

August 18, 2022

### Upgrade Paths

API Connectivity Manager 1.1.0 supports upgrades from these previous versions:

- 1.0.0

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md#upgrade-api-connectivity-manager" >}}) for important information and steps to follow when upgrading API Connectivity Manager.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manager</summary>

{{< include "tech-specs/acm-nim-dependencies.md" >}}

</details>

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Advanced Cluster Management**

  Including more than one proxy cluster with the same hostname in an environment replicates configuration across all clusters and assists with blue-green deployments. With advanced cluster management, you can use a load balancer in front of the clusters to slowly move to the newer version of the API gateway. For example, one cluster may belong to NGINX Plus version R26 and another to R27. See the [Technical Specifications]({{< relref "/nms/tech-specs.md#data-plane-dev-portal" >}}).

- {{% icon-feature %}} **Advanced Routing feature is available now**

  Advanced routing feature is available now. You can use it to publish an API Proxy and route specific URIs/endpoints precisely to a backend service. Advanced routing with OAS Specification allows you to import a specification file, parse all the URIs/endpoints in the file and publish API proxy by routing each URI/endpoint precisely to a backend service. To use the advanced routing feature without an OAS specification file, add the URI/endpoints while publishing the API proxy. See the [Advanced Configurations]({{< relref "/nms/acm/how-to/services/publish-api.md#advanced-configurations" >}}) section.

- {{% icon-feature %}} **SQLite is supported for Developer Portal**

  SQLite is now supported as a database for [Developer Portal installations]({{< relref "/nms/acm/getting-started/add-devportal.md" >}}).

- {{% icon-feature %}} **Support for NGINX Plus Release 27 (R27)**

  This release supports NGINX Plus Release 27 (R27) version for Data Plane instances. See the [Technical Specifications]({{< relref "tech-specs.md" >}}).

### Resolved Issues

This release fixes the following issues. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/acm/releases/known-issues.md" >}}).

- {{% icon-resolved %}} JWT Assertion policy accepts an empty string value for tokenName property (35419)

- {{% icon-resolved %}} Environment is in a premature success state even though all proxy clusters may not be onboarded (35430)

- {{% icon-resolved %}} Cannot add, remove, or edit proxy clusters from an environment that has a published API proxy  (35463)

- {{% icon-resolved %}} Features in the web interface are not displayed after uploading license (35525)

- {{% icon-resolved %}} DEVPORTAL_OPTS in /etc/{default,sysconfig}/nginx-devportal does not work if value has multiple words (36040)

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.

---

## 1.0.0

July 19, 2022

### What's New

This release introduces the following features:

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

### Known Issues

- You can find information about known issues with API Connectivity Manager in the [Known Issues]({{< relref "/nms/acm/releases/known-issues.md" >}}) topic.
