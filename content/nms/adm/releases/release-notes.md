---
title: "Release Notes"
description: "These release notes list and describe the new features, enhancements, and resolved issues in NGINX Management Suite App Delivery Manager."
weight: 100
url: /nginx-management-suite/adm/releases/release-notes/
toc: true
tags: [ "docs" ]
docs: "DOCS-1260"
categories: ["release notes"]
---

{{<rn-styles>}}

---


{{< include "adm/releases/ea-download.md" >}}

{{< include "adm/releases/upgrading.md" >}}
## 4.0.0 August 24, 2023

### What's New{#4-0-0-EA3-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Added pre-configured roles when App Delivery Manager is installed**<a name="4-0-0-EA3-whats-new-Added-pre-configured-roles-when-App-Delivery-Manager-is-installed"></a>

  We've made it easier to get started configuring role permissions by adding two predefined roles, App Delivery Manager Admin and App Delivery Manager Guest, when App Delivery Manager is installed. These roles can be modified to meet your needs.
  
- {{% icon-feature %}} **New feature for users to bring their own WAF policy**<a name="4-0-0-EA3-whats-new-New-feature-for-users-to-bring-their-own-WAF-policy"></a>

  This new feature allows you to set the appropriate controls for your apps by supporting BYO WAF policy, so that you can use your existing declarative JSON policies. To learn more see the [WAF Configuration Management]({{< relref "/nms/nim/getting-started/waf-config-management.md" >}}) documentation.
  
- {{% icon-feature %}} **Added correlation ID to logs to simplify troubleshooting**<a name="4-0-0-EA3-whats-new-Added-correlation-ID-to-logs-to-simplify-troubleshooting"></a>

  We have added support for contextual logging, which automatically includes a unique identifier. This identifier gets passed across processes to be able to perform searches for all relevant log entries referencing it. 
  
  The correlation ID is added to `stdout`, `nms.log`, and `agent.log` files.
  
- {{% icon-feature %}} **Added URI paths to Web Component list**<a name="4-0-0-EA3-whats-new-Added-URI-paths-to-Web-Component-list"></a>

  To help build and troubleshoot app delivery services, we have added the ability to view the URI path in the *Web Components* list of the web interface.
  
- {{% icon-feature %}} **New documentation on how to configure keepalived to enable data plane high availability**<a name="4-0-0-EA3-whats-new-New-documentation-on-how-to-configure-keepalived-to-enable-data-plane-high-availability"></a>

  We have added a tutorial explaining how to configure `keepalived` on NGINX Plus instances so that developers can enable gateway high availability by simply choosing the right instance group. To learn more see [Creating Highly Available Gateways]({{< relref "/nms/adm/tutorials/adm-high-availability.md" >}}).
  
- {{% icon-feature %}} **Improvements to the OIDC configuration options for the data plane**<a name="4-0-0-EA3-whats-new-Improvements-to-the-OIDC-configuration-options-for-the-data-plane"></a>

  We have made changes to prevent the misconfiguration or mishandling of SSL/TLS communication: 
  
    - We have updated the data plane OIDC template to enable the verification of IDP server certificate  (proxy_ssl_trusted_certificate and proxy_ssl_verify). 
    - We have added the option to configure the DNS of choice (resolver added to server block level).
  
- {{% icon-feature %}} **Template documentation now available in-product**<a name="4-0-0-EA3-whats-new-Template-documentation-now-available-in-product"></a>

  Templates are a powerful way to extend App Delivery Manager (ADM) functionality. We've made it easier to review the detailed descriptions of templates that are shipped with App Delivery Manager by using the API or web interface.
  

### Changes in Behavior{#4-0-0-EA3-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Improved usability of the Web Component APIs**<a name="4-0-0-EA3-changes-in-behavior-Improved-usability-of-the-Web-Component-APIs"></a>

  We now accept `paths` instead of `uris` and `path` instead or `uri` in the Web Component API payload. This will break any existing objects that make use of these APIs.
  
  For example:
  
  ```json
  "paths": [
        {
          "matchMethod": “prefix”,
          "path": "/foo",
          "customExtensions": {}
        }
      ]
  ```
  
- {{% icon-feature %}} **Added passive health check options to the `f5-health-monitor-v1` use case, alongside the pre-existing `healthCheck` options**<a name="4-0-0-EA3-changes-in-behavior-Added-passive-health-check-options-to-the-`f5-health-monitor-v1`-use-case,-alongside-the-pre-existing-`healthCheck`-options"></a>

  To add passive health check options to the use case, the existing `healthCheck` options and the new passive health check options are now encompassed by `healthMonitor`.
  
  To preserve pre-existing `healthCheck` options after upgrading to this release, please update your requests. Wrap the `healthCheck` options with `healthMonitor`:
  
  EA2 and before:
  
  ```json
    ...
    "customExtensions": {
      ...
  	"healthCheck": {
  		...
  	}
  }
  ```
  
  EA3:
  
  ```json
  {
    ...
    "customExtensions": {
      ...
      "healthMonitor": {
  		"healthCheck": {
  			...
  		}
  	}
  }
  ```
  
- {{% icon-feature %}} **Updated f5-tls-settings-v1 use case options and inheritance behavior**<a name="4-0-0-EA3-changes-in-behavior-Updated-f5-tls-settings-v1-use-case-options-and-inheritance-behavior"></a>

  The `proxySetSni` options have been renamed and expanded:
  
  - Renamed `NGINX_HOST_VARIABLE` to `$host` 
  - Renamed `UPSTREAM_SERVER_ADDRESS` to `first_upstream_address`
  - Added `$server_name`
  - Added `$proxy_host`
  - Added `custom`
  - New field `proxySetSniCustomHeader` to specify the custom proxy host header and SNI value
  
  The settings specified at the top-level `customExtensions` apply to all URIs (server blocks). Settings within the ingress URI `customExtensions` apply only to that particular URI (server block) and will override the top-level settings. 
  We have improved inheritance to be more granular: It is now applied per the `sslCiphers`, `sslPreferServerCiphers`, `sslProtocols`, and `sslSessionCache` settings (instead of using all the `tlsSettings` at the top level or being overwritten by URI level settings).
  
  Example:
  
  ```json
  {
    "metadata": {
      "uid": "e5eb6e91-2746-4fa4-9655-bf1dca4c7e5c",
      "name": "gw1",
      "tags": []
    },
    "ingress": {
      "uris": [
        {
          "uri": "https://example.com:80",
          "matchMethod": "exact",
          "http2": false,
          "customExtensions": {
            "tlsSettings": {
              "sslProtocols": "TLSv1.3",
              "sslSessionCache": {
                "builtin": {
                  "size": 5000
                }
              }
            }
          }
        }
      ],
      "tls": {
        "certRef": {
          "ref": "0d131b67-f73d-4339-a7a7-c344f9bae945"
        }
      },
      "placement": {
        "instanceGroupRefs": [
          {
            "ref": "46e2a2d4-1bfb-43e4-bdad-a6f1416779ed",
            "listenIps": []
          }
        ]
      }
    },
    "customExtensions": {
      "tlsSettings": {
        "sslCiphers": "HIGH",
        "sslPreferServerCiphers": "on",
        "sslProtocols": "TLSv1.1",
        "sslSessionCache": {
          "clientSessionReuse": "off"
        }
      }
    }
  }
  ```
  
  The server block for `https://example.com:80` will now inherit the top-level settings for `sslCiphers` and `sslPreferServerCiphers` because these options were not specified at the URI level.
  
  After upgrading to this release, follow these steps to make sure your environment behaves correctly:
   
    - Update web-components that specify `NGINX_HOST_VARIABLE`, for `proxySetSni`, to `$host`.
    - Update web-components that specify `UPSTREAM_SERVER_ADDRESS`, for `proxySetSni`, to `first_upstream_address`.
    - Modify `sslCiphers`, `sslPreferServerCiphers`, `sslProtocols`, and `sslSessionCache` at the top and URI levels to achieve the desired inheritance under the new inheritance model.
  
- {{% icon-feature %}} **NGINX rewrite rules configuration template updated**<a name="4-0-0-EA3-changes-in-behavior-NGINX-rewrite-rules-configuration-template-updated"></a>

  The template used to configure the NGINX rewrite rules has been updated with a new name (`rewrite-rules`) and new return settings, to improve its usability.
  
- {{% icon-feature %}} **Updated the API to support all of the NGINX Plus load balancing methods**<a name="4-0-0-EA3-changes-in-behavior-Updated-the-API-to-support-all-of-the-NGINX-Plus-load-balancing-methods"></a>

  The load balancing API has undergone some changes in this release. *Please review the changes below, and update any existing API script accordingly.*
  
    Method changes:
  
    - Load balancing method `IPHASH` changed to `ip_hash`
    - Load balancing method `LEAST_CONNECTIONS` changed to `least_conn`
  
     Arguments to `least_time` method changes:
  
    - `header_inflight` changed to `header inflight`
    - `connect_inflight` changed to `connect inflight`
    - `first_byte_inflight` changed to `first_byte inflight`
    - `last_byte_inflight` changed to `last_byte inflight`
  
    Arguments to `random` method `twoServerLBMethod` option changes:
  
    - Adding option `two`
    - `least_connections` changed to `two least_conn`
    - `least_time_connect` changed to `two least_time=connect`
    - `least_time_header` changed to `two least_time=header`
    - `least_time_first_byte` changed to `two least_time=first_byte`
    - `least_time_last_byte` changed to `two least_time=last_byte`
  
- {{% icon-feature %}} **HTTP/2 configuration is now a native option in the App Delivery Manager API**<a name="4-0-0-EA3-changes-in-behavior-HTTP/2-configuration-is-now-a-native-option-in-the-App-Delivery-Manager-API"></a>

  Gateway configuration options now include enabling HTTP/2 without requiring a specific use case template. HTTP/2 is now a native configuration option in the App Delivery Manager API, and can also be enabled using the Web interface. When HTTP/2 is enabled, the corresponding `listen` directive will use `http2` in the resulting config.
  
- {{% icon-feature %}} **Use case templates have been renamed**<a name="4-0-0-EA3-changes-in-behavior-Use-case-templates-have-been-renamed"></a>

  We have changed the prefixes of the default templates provided with App Delivery Manager from `builtin` to `f5`.  After upgrading to the newer versions, both versions will be available. To avoid duplication, we advise using the newer `f5` templates and use cases in all environments. We also recommend removing the old `builtin` versions from these two locations:
  
  - `/etc/nms/modules/adm/templates/usecases/`
  - `/etc/nms/modules/adm/templates/base/`
  
- {{% icon-feature %}} **Enumerated constants have been changed from uppercase to lowercase**<a name="4-0-0-EA3-changes-in-behavior-Enumerated-constants-have-been-changed-from-uppercase-to-lowercase"></a>

  The enums (enumerated constants) in the API have been changed from uppercase to lowercase to better match NGINX terminology. If there are any existing API scripts, please update them with the correct values according to the updated [API documentation]({{< relref "/nms/adm/about/api-overview.md#access-the-api-documentation" >}}).
  

### Known Issues{#4-0-0-EA3-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/adm/releases/known-issues.md" >}}) topic.

## 4.0.0 July 06, 2023

### What's New{#4-0-0-EA2-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Added initial support for NGINX App Protect**<a name="4-0-0-EA2-whats-new-Added-initial-support-for-NGINX-App-Protect"></a>

  We have added the ability to enable NGINX  App Protect per location, use the default policy that provides OWASP Top 10 and Bot security protection, and a strict policy containing more restrictive criteria for blocking traffic. 
  
- {{% icon-feature %}} **Added support for rate limiting**<a name="4-0-0-EA2-whats-new-Added-support-for-rate-limiting"></a>

  We have added the ability to enable rate limiting per component to limit network traffic, prevent users from exhausting system resources, and make it harder for malicious actors to overburden components and cause attacks like Denial of Service.
  
- {{% icon-feature %}} **Added support for configuring OpenID Connect**<a name="4-0-0-EA2-whats-new-Added-support-for-configuring-OpenID-Connect"></a>

  We have added the ability to configure OIDC integration for NGINX Plus to communicate directly with an Identity Provider to perform authentication.
  
- {{% icon-feature %}} **Added new traffic setting template**<a name="4-0-0-EA2-whats-new-Added-new-traffic-setting-template"></a>

  We have added a new template, traffic-settings, that enables the configuration of `underscores_in_headers` and `ignore_invalid_headers` directives per URI. Users can now control whether header fields with invalid names should be ignored and if header fields whose names contain underscores are marked as invalid.
  

### Changes in Behavior{#4-0-0-EA2-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Updated the API to better support automation**<a name="4-0-0-EA2-changes-in-behavior-Updated-the-API-to-better-support-automation"></a>

  We have simplified the APIs for the Gateway and Component objects to use arrays instead of maps when specifying the URIs. This will break any existing automation scripts that make use of these APIs.
  
- {{% icon-feature %}} **Improved usability of caching template**<a name="4-0-0-EA2-changes-in-behavior-Improved-usability-of-caching-template"></a>

  The `proxy_cache_valid` setting in the built-in `caching` template has been updated to an array so that the directive can be easily used to specify different timeouts per response code. For example:
  
  ```json
  "proxyCacheValids": [
    {
     "responseCodes": "200",
     "time": "10m"
    },
   {   
     "responseCodes": "300,302",
     "time": "1m"
   }
  ]
  ```
  

### Resolved Issues{#4-0-0-EA2-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates [(42517)]({{< relref "/nms/adm/releases/known-issues.md#42517" >}})<a name="4-0-0-EA2-resolved-issues-Duplicate-Certificate-and-Key-published-for-managed-certificates"></a>

### Known Issues{#4-0-0-EA2-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/adm/releases/known-issues.md" >}}) topic.

## 4.0.0 May 18, 2023

### What's New{#4-0-0-EA-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **App Delivery Manager Early Access Features**<a name="4-0-0-EA-whats-new-App-Delivery-Manager-Early-Access-Features"></a>

  - Provides an easy-to-use graphical user interface for Application Delivery.
  
  - Introduces [App Delivery Manager abstractions]({{< relref "/nms/adm/about/api-overview.md" >}}) for the configuration and use of NGINX Plus directives:
  
      - Create and manage production and non-production environments for classes of applications, business units, and development teams. [**Environments**]({{< relref "/nms/adm/about/api-overview.md#environments" >}}) are logical containers used to group Applications, and Gateways into a domain associated with common goals, resource needs, usage constraints, and access controls. Environments typically map closely to organizational boundaries such as “dev” and “prod”.
      - Create and manage [**gateways**]({{< relref "/nms/adm/about/api-overview.md#gateways" >}}), which correspond to server blocks in nginx.conf file, which represents the initial network entry point of application and/or API traffic into an NGINX instance in the traffic data path. You can share the same gateway for both application and API traffic.
      - Create and manage [**apps**]({{< relref "/nms/adm/about/api-overview.md#apps" >}}) that are logical containers for components.
      - Create and manage [**components**]({{< relref "/nms/adm/about/api-overview.md#components" >}}) that support HTTP and TCP/UDP protocols. Web components correspond to location blocks in nginx.conf. Web, for example, HTTP components allow users to define routing behavior for the URIs under the Apps. Each component can define URIs and specify which FQDNs these need to attach to via Gateway references. Components also allow specifying the Backend and can control the configuration for load balancing traffic to the backend servers. TCP/UDP components define stream server blocks. Similar to web components can attach to one or more Gateways.
      - Create and manage [**sites**]({{< relref "/nms/adm/about/api-overview.md#sites" >}}) that allow the grouping of instance-groups by a physical location. Sites provide the ability to load balance to backend servers that are geographically close to the data plane.
  
  - Control the lifecycle of applications across groups of NGINX Plus instances.
  
  - [Apply role-based access controls]({{< relref "/nms/adm/about/rbac-overview.md" >}}) across all App Delivery Manager features to enable users and teams to self-service app delivery needs.
  
  - Monitor HTTP system and traffic metrics at the instance level and view aggregated and near-real-time insights into system and app traffic:
  
     - System Metrics: Average CPU and Average Memory
     - App Metrics: Network Bytes In and Network Bytes Out
     - HTTP Metrics: Total Requests, HTTP 5xx Errors, and HTTP 4xx Errors
  
  - Deploy app services for [load balancing HTTP and TCP/UDP applications]({{< relref "/nms/adm/tutorials/create-http-app.md" >}}) and select the appropriate method:
  
      - Round Robin
      - Least Connections
      - IP Hash
      - Hash
      - Least Time
      - Random
  
  - Unlock the full capability of NGINX [using templates]({{< relref "/nms/adm/about/template-overview.md" >}}). The following template use cases come prebuilt:
  
      - Enabling cache by configuring proxy_cache_path, split_clients, and map to improve app performance
      - Add DNS for service discovery
      - Health monitoring of upstreams with health_check and match block
      - Extending listen options for HTTP/2, fastopen, sndbuf, and rcvbuf
      - Modifying headers and configuring rewrites and redirects
      - Configure advanced TLS settings to enable ciphers and protocols for requests to the proxied server
  
  - Ability to [create custom templates]({{< relref "/nms/adm/about/template-overview.md" >}}) to use any NGINX Plus directive.
  

### Known Issues{#4-0-0-EA-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/adm/releases/known-issues.md" >}}) topic.

