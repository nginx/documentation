---
description: Learn about the new features, enhancements, resolved issues, and known
  issues in F5 NGINX Controller.
docs: DOCS-370
title: NGINX Controller v3.0.0–3.18.3
toc: true
weight: 10
type:
- reference
---

## Release Notes

Here you can find the release information for F5 NGINX Controller v3. NGINX Controller is NGINX's control-plane solution that manages the NGINX data plane. Built on a modular architecture, NGINX Controller enables you to manage the entire lifecycle of NGINX Plus, whether it’s deployed as a load balancer, API gateway, or a proxy in a service mesh environment.

We encourage you to install the latest version of NGINX Controller to take advantage of the newest features and updates.

Technical support is provided for earlier versions of NGINX Controller that were released within two years of the current release.

{{< see-also >}}
For related installation documentation, refer to the following publications:

- [NGINX Controller Installation Guide]({{< ref "/controller/admin-guides/backup-restore/_index.md" >}})
- [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}})
{{< /see-also >}}

&nbsp;

---

November 23, 2021

## NGINX Controller v3.18.3

### Updates

- Fixes a rare timeout issue that affected some customers.
- Performance improvements.

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

July 26, 2021

## NGINX Controller v3.18.2

### Resolved Issues

- Resolves an issue that created duplicate health checks for app components

  A health check is generated for each component that has monitoring enabled. If a backend workload is shared with multiple components, and monitoring is the same for two or more of those components, then only one health check is generated now. This is to avoid duplicating health checks.

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

July 19, 2021

## NGINX Controller v3.18.1

These release notes provide general information and describe known issues for NGINX Controller v3.18.1, in the following categories:

- [Resolved Issues](#3181-resolved)
- [Supported Versions](#3181-supported)

<span id="3181-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- The peer count alert needs to be configured with a multiplier of the reporting period (26507)
- Enabling WAF when creating or updating a component using the web interface might fail for non-admin users (26579)

<span id="3181-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

## NGINX Controller v3.18.0

June 15, 2021

NGINX Controller v3.18.0 includes the following new features, improvements, known issues, and bug fixes:

- [Updates](#3180-updates)
- [Vulnerability Fixes](#3180-vulnerability-fixes)
- [New Issues](#3180-issues)
- [Supported Versions](#3180-supported)

<span id="3180-updates"></a>

### Updates

- Bug fixes and improvements.
- Improvements to the [Data Explorer]({{< ref "/controller/analytics/data-explorer/how-to-use.md" >}}) make it easier to see your data's dimensions and preview the discrete values.
- Adds support for NGINX Plus R23 p1 and R24 p1.

<span id="3180-vulnerability-fixes"></a>

### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for details.

- Intra-cluster communication does not use TLS (5347)

  Intra-cluster communication does not use TLS. The services within the NGINX Controller namespace are using cleartext protocols inside the cluster.

  Solution Article: [K97002210](https://support.f5.com/csp/article/K97002210) | CVE-2021-23018

- Agent configuration is world-readable (6580)

  The agent configuration file `/etc/controller-agent/agent.conf` is world-readable with current permission bits set to `644`.

  Solution Article: [K36926027](https://support.f5.com/csp/article/K36926027) | CVE-2021-23021

- API Key generated with weak cryptography (8867)

  The NAAS API keys were generated using an insecure pseudo-random string and hashing algorithm that could lead to predictable keys.

  Solution Article: [K45263486](https://support.f5.com/csp/article/K45263486) | CVE-2021-23020

- The NGINX Controller admin password disclosed in supportpkg systemd logs (22633)

  The NGINX Controller Administrator password may be exposed in the `systemd.txt` file included in the NGINX support package.

  Solution Article: [K04884013](https://support.f5.com/csp/article/K04884013) | CVE-2021-23019

<span id="3180-issues"></a>

### New Issues

#### Alerts

- **The peer count alert needs to be configured with a multiplier of the reporting period (26507)**

  The `plus.upstream.peer.count` metric, when used as a basis of an alert, reports the total number of healthy upstream hosts in a deployment. The alert for this metric incorrectly uses a `SUM` aggregation method.

  **Workaround:**

  The threshold value must be configured with a multiplier of the number of minutes in the reporting period. If your alert is set to a 2m reporting period, for example, and you have two configured upstreams, your threshold should be set to 4, not 2. If your reporting period is 10m, your threshold should be set to 20, not 2.

#### App Security

- **Enabling WAF when creating or updating a component using the web interface might fail for non-admin users (26579)**

  Using the web interface to create or update an app component with WAF might fail for non-admin users. An error similar to the following example is displayed: "Error updating component comp1: API Error (1235): User is not permitted to access this resource. Contact the system administrator."
  **Workaround:**
  <br/><br/>
  Use the NGINX Controller REST API instead of the web interface, or upgrade to NGINX Controller v3.18.1 or later.

#### Documentation

- **Instance Groups API is not specified as a beta feature (25924)**

  The Instance Groups API was introduced as an experimental feature in NGINX Controller v3.17. The description does not explicitly state that the endpoints are in beta status. The Instance Groups API is a beta feature in both NGINX Controller v3.17 and v3.18 and is not recommended for use in production environments.

- **The `workloadGroup` section for the Components API is missing in the NGINX Controller REST API guide (26550)**

  In the NGINX Controller REST API guide, the `workloadGroup` section for the Components API is missing in both the Application Delivery and API Management specs.

  **Workaround:**

  Refer to the following OpenAPI Specification for the `workloadGroup`. There are two types of `workloadGroup`: {`WebWorkloadGroup` and `TcpUdpWorkloadGroup`}. Each type references a `WorkloadGroupCommon`, and then follows with its specific objects.

  ```text
  WebWorkloadGroup:
        description: Group of servers hosting a part of a Web application represented by a Component.
        allOf:
          - $ref: '#/components/schemas/WorkloadGroupCommon' # Settings common to Web and TCP/UDP workloadGroups.
          - type: object
            properties:
              proxy:
                $ref: '#/components/schemas/WebProxy' # Proxy retry and timeout settings applicable to servers in a Web workloadGroup.
              sessionPersistence:
                $ref: '#/components/schemas/SessionPersistence' # SessionPersistence settings in a Web workloadGroup.
              uris:
                type: object
                description: |
                  The URI for a server hosting a part of a Web application.
                  It must conform to the format `schema://address[:port]`
                  where schema is chosen from http or https, address is IP or hostname,
                  schema and address must be provided.
                  For example:
                  - `http://192.0.2.247`
                  - `https://192.0.2.247:8443`
                  - `https://www.f5workload.com`
                additionalProperties:
                  $ref: '#/components/schemas/WorkloadUri'
  TcpUdpWorkloadGroup:
        description: Group of servers hosting a part of a TCP/UDP application represented by a Component.
        allOf:
          - $ref: '#/components/schemas/WorkloadGroupCommon' # Settings common to Web and TCP/UDP workloadGroups.
          - type: object
            properties:
              proxy:
                $ref: '#/components/schemas/TcpUdpProxy' # Proxy retry and timeout settings applicable to servers in a TcpUdp workloadGroup.
              uris:
                type: object
                description: |
                  The URI for a server hosting a part of a TCP/UDP application.
                  The URI must conform to the format `schema://address:port`
                  where schema is chosen from tcp, udp, or tcp+tls, address is IP or hostname.
                  All three of schema, address, and port must be provided.
                  For example:
                  - `tcp://192.0.2.247:8443`
                  - `tcp+tls://192.0.2.247:8449`
                  - `udp://www.f5workload.com:989`
                additionalProperties:
                  $ref: '#/components/schemas/WorkloadUri'
      WorkloadGroupCommon:
        description: Settings common to Web and TCP/UDP workloadGroups.
        type: object
        properties:
          locationRefs:
            type: array
            items:
              $ref: 'https://gitlab.com/f5/nginx/controller/product/api-common/raw/master/schema/resource-common.yaml#/components/schemas/ResourceRef'
          loadBalancingMethod:
            $ref: '#/components/schemas/LoadBalancingMethod'
          dnsServiceDiscovery:
            $ref: '#/components/schemas/DNSServiceDiscovery'
      WorkloadUri:
        type: object
        properties:
          weight:
            type: integer
            minimum: 1
            default: 1
          maxConns:
            type: integer
            minimum: 0
            default: 0
          maxFails:
            type: integer
            minimum: 0
            default: 1
          failTimeout:
            x-f5-experimental: true
            type: string
            default: 10s
            pattern: '^[0-9]+[h|m|s]{1}$'
          isBackup:
            type: boolean
            default: false
          isDown:
            type: boolean
            default: false
          route:
            x-f5-experimental: true
            type: string
          srvService:
            type: string
          slowStart:
            x-f5-experimental: true
            type: integer
            minimum: 0
            default: 0
          isDrain:
            type: boolean
            default: false
  ```

<span id="3180-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.17.0

May 20, 2021

These release notes provide general information and describe known issues for NGINX Controller v3.17, in the following categories:

- [Updates](#3170-updates)
- [Resolved Issues](#3170-resolved)
- [New Issues](#3170-issues)
- [Supported Versions](#3170-supported)

<span id="3170-updates"></a>

### Updates

- **Adds support for NGINX Plus R24**

  NGINX Controller v3.17 fully supports [NGINX Plus R24](https://docs.nginx.com/nginx/releases/#r24) for configuration management and monitoring.

- **Adds support for NGINX App Protect 3.2**

  NGINX Controller v3.17 fully supports [NGINX App Protect 3.2](https://docs.nginx.com/nginx-app-protect/releases/#release-3-2).

- **(Technical preview) Adds Debian 10 support**

  NGINX Controller Agent v3.17 and [App Security Add-on v3.17](https://www.nginx.com/blog/introducing-nginx-controller-app-security-for-delivery/) support Debian 10 as a **technical preview**. Functionality has been verified; however more testing is needed to finalize this feature. Look for updates in future releases. See the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/) for requirements for Debian 10.

- **(Beta) Bring your own custom NGINX App Protect Policy to configure WAF**

  Now, you can [bring your own custom NGINX App Protect JSON declarative policy]({{< ref "/controller/app-delivery/security/concepts/bring-your-own-policy.md" >}}) to use as your WAF policy with NGINX Controller, in addition to using the default policy. F5 Advanced WAF and BIG-IP Application Security Module (ASM) customers can convert their standardized WAF policy to an App Protect policy to use with NGINX Controller. **Note**: This feature is available only through the NGINX Controller API for this beta release.

- **The new Data Explorer view unlocks an easier way to view metrics**

  The new [Data Explorer]({{< ref "/controller/analytics/data-explorer/how-to-use.md" >}}) view gets you to your data faster, so you can understand what's happening in your environment with ease. Effortlessly switch between contexts, metrics, and dimensions; specify a time range; set the aggregation mode; and more.

- **Improved user experience working with APIs**

  Working with APIs is easier now. We simplified navigating API definitions and related objects like versions and published APIs.

- **Easily enable or disable High Availability mode by updating gateways**

  Prior to NGINX Controller v3.17, you had to delete and recreate gateways to [enable or disable HA (high availability) mode]({{< ref "/controller/infrastructure/instances/ha-data-plane.md" >}}) . Now, you can enable or disable HA mode on the fly by simply updating the existing gateway.

- **Adds capability to view the total number of Security Events matching dimensional filters**

  You can now view the total number of WAF violations when filtering Security Events by selected dimensions for more efficient analysis.

<span id="3170-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- Installing NGINX Controller on a misconfigured NFS server fails with the error "Bundled DB did not start successfully" (22751)

- TCP/UPD traffic misreported as "Web (HTTP) Components" after upgrading to NGINX Controller v3.15 (22866)

- Update script reports "controller-postgres volume not found" if NGINX Controller uses external config database  (23739)

<span id="3170-issues"></a>

### New Issues

- **Red Hat Enterprise Linux 8 requires Xerces-C package to be installed before installing Controller Agent (25079)**

  When installing the NGINX Controller Agent on Red Hat Enterprise Linux 8, the metrics module fails to install if the Xerces-C library package hasn't been installed already. An error similar to the following is returned:

  ```bash
  Error:
  Problem: conflicting requests
    - nothing provides libxerces-c-3.2.so()(64bit) needed by avrd-0.21.2_297315219.release_3_17-1.el8.x86_64
  (try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)

  13. Installing metrics packages ... failed.
  ```

  Despite this error, the Controller Agent installs successfully; however, application-centric metrics won't be sent to NGINX Controller without this metrics module.

  **Workaround:**

  To resolve this issue, run the following commands to install Xerces-C from the EPEL Fedora repo:

  ```bash
  wget https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/x/xerces-c-3.2.2-3.el8.x86_64.rpm
  sudo rpm -Uvh xerces-c-3.2.2-3.el8.x86_64.rpm
  ```

  You can perform this workaround before installing the Controller Agent package. If you encounter the error while installing the Controller Agent, try installing Xerces-C and then re-run the Controller Agent installation.

<span id="3170-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.16.1

April 19, 2021

These release notes provide general information and describe known issues for NGINX Controller v3.16.1, in the following categories:

- [Updates](#3161-updates)
- [Resolved Issues](#3161-resolved)
- [New Issues](#3161-issues)
- [Supported Versions](#3161-supported)

<span id="3161-updates"></a>

### Updates

- **NGINX Controller with App Security Add-on supports NGINX App Protect 3.1**

  The App Security add-on now supports [NGINX App Protect 3.1](https://www.nginx.com/products/nginx-app-protect/) on [NGINX Plus R23](https://www.nginx.com/products/nginx/).

- **NGINX Controller with App Security Add-on supports Ubuntu 20.04 LTS on the data plane**

  The App Security add-on now supports Ubuntu 20.04 LTS on the data plane using the Controller Agent and [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/).

- **Association Token licenses no longer require port 8883**

  You no longer need to open port 8883 to license NGINX Controller with an Association Token. You still need to open port 443, however.

  See [Licensing NGINX Controller]({{< ref "/controller/platform/licensing-controller.md" >}}) for instructions.

- **Adds support for SSL settings in health checks when multiple virtual hosts are defined per workload group member**

  Auto-generated health check location blocks now include any `proxy_ssl` settings that have been defined in the TLS object in the web backend object. For example, using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}) to set

  ```json
  "tls":{"isServerNameEnabled": true, "name": "$host"}
  ```

  allows data plane traffic to have Server Name Indication (SNI) information that can be used where multiple virtual hosts exist per workload group member. Health checking also inherits these settings, so the SNI information is provided in the health checking context.

- **Active Directory integration adds support for LDAPS and unencrypted LDAP**

  Active Directory integration with NGINX Controller now supports LDAPS and unencrypted LDAP, in addition to StartTLS.

  Refer to [Configure Active Directory Integration]({{< ref "/controller/platform/access-management/manage-active-directory-auth-provider.md" >}}) for instructions on how to add an Active Directory provider to NGINX Controller for external authentication.

- **Data Forwarders are no longer restricted**

  While in beta, [Data Forwarders]({{< ref "/controller/analytics/forwarders" >}}) had restrictions to limit the number of stream sources that could be defined. These restrictions have been lifted.

<span id="3161-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- Links to API endpoints in the NGINX Controller API Reference docs don't work (22415)

- TCP/UDP component associated with multiple gateways on an instance  causes config to fail to load (22850)

<span id="3161-issues"></a>

### New Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Controller release notes.

#### Installation and Upgrade

- **Update script reports "controller-postgres volume not found" if NGINX Controller uses external config database  (23739)**

  You may see an error similar to the following when updating NGINX Controller if you use an external config database:

  ```bash
  Error from server (NotFound): persistentvolumes "controller-postgres" not found.
  ```

  This error relates to an internal test being conducted by the update script and doesn't affect the upgrade's success. You can safely ignore this error.

- **Harmless errors reported when joining a node to a multi-node resilient cluster (23789)**

  When joining a control plane node to a multi-node resilient cluster, errors similar to the following may be displayed:

  ``` bash
  Error from server (NotFound): pods "kube-controller-manager-<host>" not found
  ```

  ``` bash
  Error from server (NotFound): pods "kube-scheduler-<host>" not found
  ```

  These errors do not prevent the node from joining the cluster and can safely be ignored.

- **Upgrading NGINX Controller Agent fails with error "can't find %s" (24019)**

  In rare cases, upgrading the NGINX Controller Agent may fail with the error "can't find %s".

  If you look up the version for the `ngninx-controller-agent` service using `apt` or `yum`, you may see the version is `999`.

  **Workaround:**

  To resolve this error, you'll need to uninstall and then re-install the Controller Agent. Refer to the [NGINX Controller Agent Installation Guide]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}}) for instructions.

<span id="3161-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.15.0

March 11, 2021

These release notes provide general information and describe known issues for NGINX Controller v3.15.0, in the following categories:

- [Updates](#3150-updates)
- [Resolved Issues](#3150-resolved)
- [New Issues](#3150-issues)
- [Supported Versions](#3150-supported)

<span id="3150-updates"></a>

### Updates

- **Analytics now fully supports containers**

  Containers are now fully supported! You might notice some differences in the analytics for containers vs. full hosts. This is because containers are unable to report the same metrics.

  To get started using NGINX Controller with containers, see the [docker-nginx-controller README](https://github.com/nginxinc/docker-nginx-controller) on GitHub.

- **Introduces new metrics and dimensions for TCP/UDP**

  - NGINX Controller 3.15 adds four new metrics: `bytes_sent`, `bytes_rcvd`, `connection_count`, and `connection_duration`.

    - `bytes_sent` and `bytes_rcvd` are applicable to both TCP/UDP and HTTP; without any filtering, these metrics give aggregate values across HTTP and TCP/UDP.
    - `connection_count` and `connection_duration` are TCP specific.

  - We've also added three new metric dimensions: `proxied_protocol`, `family`, and `upstream_addr`.

  - For HTTP, metrics are collected at the end of a request/response interaction. For TCP/UDP, metrics are collected at the end of a connection setup/teardown interaction.

  - These new metrics will show data that's generated only after an upgrade to NGINX Controller v3.15. To view the metrics, you need to:

    - Upgrade NGINX Controller
    - Upgrade the Controller Agent
    - Republish all TCP/UDP components using the API or browser interface. Re-publishing is not required for HTTP gateways or components.

  - For UDP, `connection_duration` will be the NGINX default `proxy_timeout` value (10 minutes), except if an "ICMP destination unreachable" message is received.

- **Introduces NGINX Controller's own Dev Portal as the user interface for the NGINX Controller API Reference guide**

  The NGINX Controller docs are now using our own Dev Portal user interface to display the NGINX Controller API documentation. Check it out at:

  [https://docs.nginx.com/nginx-controller/api/reference/ctlr-v1/]({{< ref "/controller/api/_index.md" >}})

  Refer to the [API Management documentation]({{< ref "/controller/api-management" >}}) to learn more about using Dev Portals for your APIs.

<span id="3150-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- NGINX Controller update script reports a permission denied error when loading CA certificate (21211)
- Agent doesn't stash `auxfiles` in Docker container (21711)
- Agent can't marshal update payload in Docker container (21809)
- Custom dashboard filters are cleared when edited, need to be reapplied (21922)

<span id="3150-issues"></a>

### New Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Controller release notes.

#### Installation and Upgrade

- **Installing NGINX Controller on a misconfigured NFS server fails with the error "Bundled DB did not start successfully" (22751)**

  When installing NGINX Controller on an NFSv3 server, if the [NFS requirements]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-controller-database-requirements" >}}) are not met, the installation may fail with an error similar to the following: "Bundled DB did not start successfully."

  **Workaround:**

  See the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) for the NFS requirements. The `no_root_squash` option must be set for the mount point on the NFS server. If this is not allowed, the owner of the path used for the analytics database must be set to `101:101`, and the owner of the path for the config database must be set to `70:70`.

  After editing the exports file, the directories need to be removed to ensure no files are leftover from the previous installation. Then, enable the `rpc-statd` service and restart the NFS server.

#### Apps and Services

- **`connect_timeout` and `send_timeout` only take seconds as a specified value (21686)**

  If `connect_timeout` and `send_timeout` are specified in `hours:minutes:seconds`, the system returns an error response.

  **Workaround:**

  Only use seconds for these fields.

- **TCP/UDP component associated with multiple gateways on an instance  causes config to fail to load (22850)**

  If a TCP/UDP component is associated with multiple gateways on the same instance -- for example, an association of a unique listen IP per gateway placement, with a wildcard address defined in the URI within the component -- the configuration fails to load.

- **TCP/UPD traffic misreported as "Web (HTTP) Components" after upgrading to NGINX Controller v3.15 (22866)**

  On non-Ubuntu systems, after upgrading to NGINX Controller v3.15, the TCP/UDP component statistics are not reported correctly. TCP/UDP traffic may be misattributed as "Web (HTTP) Components" requests.

  **Workaround:**

  After upgrading to v3.15, in addition to republishing any TCP/UDP components, you must restart the `nginx` and `controller-agent` services on any data paths that serve as a gateway for defined TCP or UDP components.

  Complete the following steps in sequence:

  1. Stop the `nginx` service:

      ```bash
      systemctl stop nginx
      ```

  1. Stop the `controller-agent` service:

      ```bash
      systemctl stop controller-agent
      ```

  1. Start the `nginx` service:

      ```bash
      systemctl start nginx
      ```

  1. Start the `controller-agent` service:

      ```bash
      systemctl start controller-agent
      ```

  After stopping and restarting the services, your connection count (TCP), connection duration (TCP), and bytes in/bytes out (TCP/UDP) will be reported correctly.

#### Infrastructure

- **Ubuntu and Debian Docker hosts may need cgroup swap limit enabled (19514)**

  When running a [containerized instance that includes the NGINX Controller Agent](https://github.com/nginxinc/docker-nginx-controller) on an Ubuntu or Debian Docker host, you may need to enable cgroup swap limit capabilities so that the Controller Agent can report swap metrics for those instances. For instructions, refer to the Docker post-installation topic ["Your kernel does not support cgroup swap limit capabilities."](https://docs.docker.com/engine/install/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities)

#### Documentation

- **The `httpHttpsRedirect` property is not tagged as experimental in the API Reference (22561)**

  The `httpHttpsRedirect` property, which is part of the **Components > Programmability** schema for the NGINX Controller Application Delivery module, is currently experimental. The `x-f5-experimental` extension is, incorrectly, not displayed in the API Reference documentation for the property. Users should take note that this feature **is not currently supported** and may change in future versions with no guarantee of backward compatibility.

- **Links to API endpoints in the NGINX Controller API Reference docs don't work (22415)**

  In the new NGINX Controller API Reference documentation, using a direct URL to an API endpoint -- such as `https://docs.nginx.com/nginx-controller/api/reference/ctlr-v1/services/docs/devPortals/v1/paths` -- will return a 404 error. Once you've received a 404 error from a direct endpoint URL, navigating by using the back and forward browser buttons will also produce 404 errors.

  **Workaround:**

  To access information about the NGINX Controller REST API endpoints, navigate to the desired endpoint by using the browser interface instead of direct links.

- **The Catalogs and Dev Portals API docs overview pages return 404 errors in the NGINX Controller browser interface (22942)**

  In the NGINX Controller browser interface, certain API Reference docs pages are returning 404 errors. These include the "overview" and "all endpoints" pages for the Catalogs and Dev Portals APIs.

  **Workaround:**

  You can access the Catalogs and Dev Portals API overview pages in the NGINX Controller docs online. To do so, go to [https://docs.nginx.com/nginx-controller/api/reference/ctlr-v1]({{< ref "/controller/api/_index.md" >}}) and navigate to the overview page for the desired endpoint.

<span id="3150-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.14.0

February 10, 2021

These release notes provide general information and describe known issues for NGINX Controller v3.14.0, in the following categories:

- [Updates](#3140-updates)
- [Resolved Issues](#3140-resolved)
- [New Issues](#3140-issues)
- [Supported Versions](#3140-supported)

<span id="3140-updates"></a>

### Updates

- **Monitor your apps' metrics with Alert Rules**

  Now you can create [Alert Rules]({{< ref "/controller/analytics/alerts/about-alerts#alert-rules" >}}) for app-centric metrics using the NGINX Controller web interface or [REST API]({{< ref "/controller/api/_index.md" >}}). Also, the web interface for Alerts has a new and improved design.

  To create Alert Rules, refer to the [Manage Alerts]({{< ref "/controller/analytics/alerts/manage-alerts" >}}) topic. For information about the metrics that you can monitor, see the [NGINX Controller Metrics Catalog]({{< ref "/controller/analytics/catalogs/metrics" >}}).

- **NGINX Controller with App Security Add-on supports NGINX App Protect 3.0**

  The App Security add-on now supports [NGINX App Protect 3.0](https://docs.nginx.com/nginx-app-protect/) on [NGINX Plus R23](https://docs.nginx.com/nginx/).

- **View the percentage of requests that WAF has blocked or flagged**
  Now, the Security Analytics graphs show the percentage of requests that have been blocked or flagged by the Web Application Firewall (WAF). This allows you to identify spikes or abnormalities based on the proportion of traffic rejected or flagged traffic by the WAF even as traffic increases.

  Go to [View App Security Analytics]({{< ref "/controller/app-delivery/security/tutorials/view-app-security-analytics" >}}) to get started.

- **Upgrades to health checking for web apps**

  Health checking for web apps has been extended as follows:

  - A health check is sent for each virtual host on a workload group member/upstream member that is being monitored.
  - The host header in the health check is set to the server name's value in the server block from which the health check originated.
  - All virtual hosts on a particular workload group member/upstream member will inherit any failures on any other virtual host on that member due to the present shared state implementation. This will be addressed in future releases.

<span id="3140-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- Floating IP has to be removed to be updated (19011)
- Multi-node, resilient deployments and automated backups of embedded config DB are not supported on AWS (20052)
- NGINX Controller displays "Application Error" when new licenses with additional features are applied (20868)
- NGINX Controller deletes some alert rules on upgrade to v3.13 (20882)
- NGINX Controller may crash if control plane nodes are running different versions of NGINX Controller (21150)
- Alerts for `controller.agent.status` are inconsistent and unreliable (21276)

<span id="3140-issues"></a>

### New Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Controller release notes.

#### Backup and Restore

- **Restoring NGINX Controller from a backup without restoring the config and encryption keys causes the system to become unresponsive (22066)**

  When restoring NGINX Controller from a backup, you also need to restore the NGINX config and encryption keys; otherwise, the system may become unresponsive. For instructions, refer to [Back Up & Restore Cluster Config and Encryption Keys]({{< ref "/controller/admin-guides/backup-restore/backup-restore-cluster-config" >}}).

#### Analytics

- **Custom dashboard filters are cleared when edited, need to be reapplied (21922)**

  When editing a custom dashboard that has a filter, the filter settings are cleared. If you save the custom dashboard before reapplying the filter settings, the saved filter settings may be lost.

  **Workaround:**

  If you need to edit a custom dashboard with a filter, you should reapply any cleared filter settings before saving the dashboard.

#### Infrastructure

- **NGINX Controller Agent doesn't stash `auxfiles` in Docker container (21711)**

  In some cases, when running the NGINX Controller Agent in a Docker container, the Agent may fail to stash the `auxfiles` directory during a configuration change. If this happens, it may not be possible to roll back the update if the config change is unsuccessful.

- **NGINX Controller Agent can't marshal update payload in Docker container (21809)**

  In some cases, when running in a Docker container, the NGINX Controller Agent may fail to marshal an update payload. This can affect metrics and alerts.

#### Licensing

- **License Usage column does not appear in the NGINX Controller web interface after restarting platform-mgr pod (20907)**

  When the `platform-mgr` pod is restarted, the **Usage** column on the **Platform > License** page may not show usage data for a brief time.

  **Workaround:**

  Wait at least 30 seconds, then refresh the webpage. The usage data will display if there's any to data show.

#### Platform

- **Failovers on resilient NGINX Controller clusters on AWS can take up to 5 minutes (21586)**

  The automated failover from a failed control node to a working node can take up to 5 minutes on resilient NGINX Controller clusters on Amazon Web Services. During the failover, NGINX Controller may be unavailable while services are migrated and restarted.

#### Documentation

- **Steps to restore embedded config database from a specific backup file are incorrect (22044)**

  The steps to restore the embedded config database from a specific backup file, found in the user documentation that's installed with NGINX Controller, are incorrect.

  **Workaround:**

  To restore the embedded config database, follow the instructions in the [Backup & Restore Embedded Config Database]({{< ref "/controller/admin-guides/backup-restore/backup-restore-embedded-config-db#restore-embedded-config-database" >}}) guide that's online.

<span id="3140-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.13.0

January 20, 2021

These release notes provide general information and describe known issues for NGINX Controller v3.13.0, in the following categories:

- [Updates](#3-13-0-updates)
- [Resolved Issues](#3-13-0-resolved)
- [New Issues](#3-13-0-issues)
- [Supported Versions](#3-13-0-supported)

<span id="3-13-0-updates"></a>

### Updates

- **Adds support for NGINX Streams (TCP & UDP)**

  NGINX Controller now supports TCP/UDP load balancing and routing along with the coincident support for data path HA for these protocols. TCP/UDP does not support metrics at this time -- look for metrics support coming soon.

  To learn more, check out the [Manage Gateways]({{< ref "/controller/services/manage-gateways.md" >}}) and [About Application Delivery]({{< ref "/controller/app-delivery/about-app-delivery.md" >}}) topics.

- **Improved experience deploying the NGINX Controller with App Security Add-on**

  You no longer need to add `security = True` in the *agent.conf* file to get Security Events (WAF violation events) after installing the NGINX App Protect module on the data planes -- NGINX Controller takes care of the configuration for you.  **An Agent restart is still needed**.

  To begin using NGINX Controller with the Application Security Add-on, follow the steps in the [Trial NGINX Controller with App Security]({{< ref "/controller/admin-guides/install/try-nginx-controller-app-sec.md" >}}) quick start guide.

- **NGINX Controller with App Security Add-on supports Ubuntu 18.04 LTS on the data plane**

  The App Security add-on now supports Ubuntu 18.04 LTS on the data plane using the Controller Agent and [NGINX App Protect](https://docs.nginx.com/nginx-app-protect/).

- **NGINX Controller with App Security Add-on supports NGINX App Protect 2.3**

  The App Security add-on now supports [NGINX App Protect 2.3](https://docs.nginx.com/nginx-app-protect/) on [NGINX Plus R23](https://docs.nginx.com/nginx/).

- **Data forwarding for Splunk now includes NGINX Controller events**

  You can now forward all NGINX Controller events -- including system and security events -- to your Splunk HTTP Event Collector(s), similar to log forwarding.

  To get started, refer to [Forward Analytics Data to Splunk]({{< ref "/controller/analytics/forwarders/forward-analytics-to-splunk.md" >}}).

- **The data forwarder output format `SPLUNK_HEC` was renamed to `SPLUNK`**

  The output format type `SPLUNK_HEC` has been shortened to `SPLUNK` to make it more intuitive.

- **Usage information is now reported with licensing information**

  Now when you use the NGINX Controller web interface or the REST API to view licensing information, you'll also be able to view usage details to ensure compliance with your license.

  For instructions on how to view and manage your licenses, see [License NGINX Controller]({{< ref "/controller/platform/licensing-controller.md" >}}).

<span id="3-13-0-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- The `nginx.master.reloads` metric increments and sums incorrectly (14533)
- Gateway configuration stuck at `Configuring` if referenced instances aren't running App Protect processes (19441)
- APIM License limits may display incorrectly (19919)
- NGINX Controller reports missing `nginx.conf.bak` file when reloading NGINX Plus configuration times out (20227)
- API Reference does not specify that TCP/UDP App Components are experimental (20285)

<span id="3-13-0-issues"></a>

### New Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Controller release notes.

#### Installation and Upgrade

- **NGINX Controller may crash if control plane nodes are running different versions of NGINX Controller (21150)**

  When adding control plane nodes to the cluster, NGINX Controller may crash if different NGINX Controller versions are installed on the nodes. To add control plane nodes to the cluster, ensure you install the same NGINX Controller von all the nodes.

  **Workaround:**

  If you encounter this issue, contact NGINX Support for assistance.

#### Alerts

- **NGINX Controller web interface may not display events if an ad blocker is enabled (18841)**

  In some cases, the NGINX Controller web interface may not display analytics or security events if an ad blocker is enabled.

  **Workaround:**

  Turn off any ad blockers while using the NGINX Controller web interface.

- **NGINX Controller deletes some alert rules on upgrade to v3.13 (20882)**

  NGINX Controller v3.13 contains changes to the functionality of Alerts, including Alert Rules and Alert Notifications. Alert rules that use the following metric types will not be carried over into v3.13 on upgrade from previous versions:

  {{< deprecated >}}
  As of NGINX Controller v3.13, the following Alerts functionality is deprecated:

  - The [ServiceNow Alerts integration]({{< ref "/controller/analytics/alerts/service-now-notifications.md" >}}) is no longer supported. Subscribers of any type other than `email` will be ignored. Alert rules which do not have at least one email subscriber will not be migrated.
  - The alert rule operator `=` is no longer available. Any existing alert rules with `operator: =` will be ignored.
  - Alert rules created in versions prior to 3.13 that use the `RATE` aggregation will be removed on upgrade. These rules must be re-created manually. Alert rules that use the following metrics are affected:

    - `plus.stream.upstream.bytes_sent`
    - `plus.stream.upstream.bytes_rcvd`
    - `system.io.iops_w`
    - `system.io.kbs_w`
    - `system.io.iops_r`
    - `system.io.kbs_r`
    - `system.net.bytes_sent`
    - `system.net.bytes_rcvd`
    - `plus.stream.bytes_sent`
    - `plus.stream.bytes_rcvd`
    - `plus.upstream.bytes_sent`
    - `plus.upstream.bytes_rcvd`
    - `nginx.workers.io.kbs_r`
    - `nginx.workers.io.kbs_w`
    - `nginx.http.request.count`
    - `nginx.http.request.body_bytes_sent`
    - `nginx.http.request.bytes_sent`
    - `nginx.http.conn.accepted`
    - `nginx.http.conn.dropped`
    - `plus.http.request.bytes_sent`
    - `plus.http.request.bytes_rcvd`

    {{< /deprecated >}}

  Additionally, there is a change to the summary email schedule. Ongoing alert emails will not be sent every hour anymore. The summary email will only contain alerts that have started or expired in the past hour.

  **Workaround:**

  - Make note of any alerts that use the metrics types listed above.
  - Re-create the alert rules when the upgrade to v3.13 is complete.

- **Alerts for `controller.agent.status` are inconsistent and unreliable (21276)**

  The alerts for `controller.agent.status` are emitted inconsistently and are unreliable in NGINX Controller v3.13. We recommend that you do not configure alerts for `controller.agent.status` or that you mute these alerts if you're upgrading to or installing NGINX Controller v3.13.

#### App Security

- **NGINX Controller may fail to add an instance to a gateway if multiple components associated with the gateway have unique sets of WAF signature overrides (20752)**

  In cases where multiple components have unique sets of WAF signature overrides, adding a new instance reference to a gateway may result in a timeout.

  **Workaround:**

  To add an instance reference to a gateway, take the following steps:

  - For components that reference the default policy, remove all signature overrides from components associated with the gateway that’s being changed.

  - For components that reference a custom policy [Beta], replace the custom policy with the default policy without any signature override.

  - Add the instance to the gateway.

  - For components that referenced the default policy, add the signature overrides back to the components.

  - For components that previously referenced a custom policy [Beta], replace the default policy with the custom policy.

- **Configuration pushes may time out if components with security enabled are in an error state (20920)**

  If multiple components with security enabled and signature overrides are in an error state, pushing configuration changes for additional components may time out.

  **Workaround:**

  To push configuration changes, take the following steps:

  1. Remove the signature overrides from the components.
  2. Resolve the component errors one at a time, waiting for each error to resolve and the component state to become "configured."
  3. Restore the signature overrides for each component one at a time, waiting for the state for each component to become "configured."
<br/>

#### Licensing

- **NGINX Controller displays "Application Error" when new licenses with additional features are applied (20868)**

  Applying a new license with additional features to a previously licensed version of NGINX Controller causes the web interface to display the message "Application Error."

  **Workaround:**

  You can safely ignore this message. Wait approximately 30 seconds, and then refresh the page; the message should disappear.

#### Platform

- **Users with an environment-specific role can't create or update Components using the browser interface (22021)**

  Users who have an environment-specific role with read/write permissions may not be able to create or update Components using the NGINX Controller browser interface. The system displays an error similar to the following: "Error Fetching Component. API Error (403): unauthorized."

  **Workaround:**

  Use the `/platform/roles` endpoint in the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}) to add the following permissions to the custom role:

  ``` json
  {
    "path": "/api/v1/services/errorsets",
    "access": "READ"
  },
  {
    "path": "/api/v1/security/identity-providers",
    "access": "READ"
  }
  ```

  The `errorsets` resource is a newly added resource that's needed to create or modify Components. The `identity-providers` resource needs to have `READ` permission to work in the NGINX Controller browser interface.

<span id="3-13-0-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.12.1

December 30, 2020

This hotfix release resolves the known issue affecting version 3.12 described below.

*Upgrading to NGINX Controller v3.12 fails on systems that don't meet the minimum CPU requirements (20509)*:
<br/><br/>
NGINX Controller requires an [8-core CPU @ 2.4 GHz or higher]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#hardware-specifications" >}}).

If you've installed NGINX Controller on a system that does not have an 8-core CPU @ 2.4 GHz or higher, the upgrade to 3.12 may fail.

{{< caution >}}Installing or upgrading NGINX Controller on systems that do not meet the minimum hardware requirements may cause NGINX Controller to become unresponsive.

Refer to the [NGINX Controller Tech Specs]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs" >}}) guide for hardware requirements and system recommendations.

Following the workaround below will restore functionality. However, **running on a system that does not meet the documented minimum requirements is not supported or recommended**.

It is strongly recommended that you upgrade your system to meet the minimum requirements (8-core CPU). Doing so will ensure a successful upgrade to version 3.12. {{< /caution >}}

**Workaround:**

To restore a failed upgrade, take the steps below:

- Stop NGINX Controller by using the helper script:

  ```bash
  /opt/nginx-controller/helper.sh controller stop
  ```

- Wait for 1-2 minutes for all services to stop. You can run the command below to check the status:

  ```bash
  /opt/nginx-controller/helper.sh controller status
  ```

- Run the update script:

  ```bash
  /opt/nginx-controller/update.sh --passive
  ```

- Start NGINX Controller by using the helper script:

  ```bash
  /opt/nginx-controller/helper.sh controller start
  ```

- Wait 2-3 minutes for all services to start. Then, log in to the NGINX Controller user interface to verify that system functionality is restored.

{{< note >}}If you're not able to confirm that functionality has been restored by following the above steps once, try repeating them. In some test cases, repeating the steps was necessary to complete the upgrade.{{< /note >}}

&nbsp;

---

## NGINX Controller v3.12.0

December 15, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.12.0, in the following categories:

- [Updates](#3-12-0-updates)
- [Resolved Issues](#3-12-0-resolved)
- [New Issues](#3-12-0-issues)
- [Supported Versions](#3-12-0-supported)

<span id="3-12-0-updates"></a>

### Updates

NGINX Controller 3.12.0 includes the following updates:

- **Deploy NGINX Controller as a resilient cluster on a private cloud**

  <div data-proofer-ignore>

  Now you can [deploy NGINX Controller as a multi-node cluster on a private cloud]({{< ref "/controller/admin-guides/install/resilient-cluster-private-cloud" >}}) to provide uptime resiliency. A multi-node cluster ensures that NGINX Controller stays up even if one of the control-plane hosts becomes unavailable.

  </div>

- **Set up data plane high availability (HA)**

  <div data-proofer-ignore>

  [Configure a high-availability data plane for your apps]({{< ref "/controller/infrastructure/instances/ha-data-plane" >}}) in on-premises deployments using NGINX Controller, NGINX Plus, and keepalived. High-availability data planes help to ensure your apps operate continuously without service interruptions.

  Support for High Availability (HA) mode is limited to two NGINX Plus instances.

  </div>

- **Protect your apps with WAF**

  <div data-proofer-ignore>

  Now you can use the App Security add-on for the Application Delivery module to protect your apps with a web application firewall (WAF). The WAF protects your apps from various application-layer attacks such as cross-site scripting and SQL injection, among others. Organizations can start out-of-the-box with [OWASP Top 10 protection](https://owasp.org/www-project-top-ten/) with a default protection policy and minimal tuning required.

  To get started, check out the [Trial NGINX Controller with App Security]({{< ref "/controller/admin-guides/install/try-nginx-controller-app-sec" >}}) guide.

  </div>

- **Install NGINX Controller with an embedded config database**

  When [installing NGINX Controller]({{< ref "/controller/admin-guides/install" >}}), you can choose to use an embedded, self-hosted config database by default, or you can provide your own external PostgreSQL database. If you use the embedded config database, NGINX Controller will install and configure the database for you, significantly streamlining the installation process.

- **Automated backups for the embedded config database**

  <div data-proofer-ignore>

  If you install NGINX Controller using the embedded, self-hosted config database, NGINX Controller will back up the database at hourly intervals for you automatically. For more information about these automated backups and how to restore from them, see the [Backup & Restore Guide]({{< ref "/controller/admin-guides/backup-restore/backup-restore-embedded-config-db" >}}).

  </div>

- **Improved user experience for configuring apps**

  We enhanced the user experience for configuring a basic app and components by reorganizing the settings pages to show standard configuration options first and advanced configuration options when needed.

- **Improved user experience for routing API resources**

  The user experience for routing API resources has been improved to make it easier to drag and drop multiple resources. Resources can now be checked individually and then dragged over together.

- **APIM adds support for response and request header modifications**

  Response and request headers can now be added to or deleted from published APIs.

- **Added support for NGINX Plus and Ubuntu**

  - Adds support for NGINX Plus R23
  - Adds NGINX Controller Agent support for Ubuntu 20.04 LTS

<span id="3-12-0-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- All users require the built-in Guest role (6231)
- Canceling an installation on a system running NGINX Controller will uninstall NGINX Controller (17676)
- Type-1 directives ignored by UI for app components (17697)
- Deleting a license using the NGINX Controller API does not remove the license from NGINX Controller (19090)

<span id="3-12-0-issues"></a>

### New Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Controller release notes.

#### Installation and Upgrade

- **Upgrading to NGINX Controller v3.12 fails on systems with less than an 8-core CPU (20509)**

  NGINX Controller requires an [8-core CPU @ 2.4 GHz or higher]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#hardware-specifications" >}}).

  If you've installed NGINX Controller on a system that does not have an 8-core CPU @ 2.4 GHz or higher, **you should not upgrade to v3.12**.

  {{< caution >}}
Installing or upgrading NGINX Controller on systems that do not meet the minimum hardware requirements may cause NGINX Controller to become unresponsive.

Refer to the [NGINX Controller Tech Specs]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) guide for hardware requirements and system recommendations.
  {{< /caution >}}

  **Workaround:**

  Increase the number of CPUs to 8 or more @ 2.4 GHz or higher, then rerun the update script:

  ```bash
  cd controller-installer
  ./update.sh
  ```

  For help troubleshooting NGINX Controller upgrades, contact NGINX Support from the [MyF5 Customer Portal](https://account.f5.com/myf5).

- **NGINX Controller update script reports a permission denied error when loading CA certificate (21211)**

  When updating NGINX Controller, the update script may return an error similar to the following:

  ``` bash
  Error opening Certificate /etc/kubernetes/pki/ca.crt
  139998249641872:error:0200100D:system library:fopen:Permission denied:bss_file.c:402:fopen('/etc/kubernetes/pki/ca.crt','r')
  139998249641872:error:20074002:BIO routines:FILE_CTRL:system lib:bss_file.c:404:
  unable to load certificate
  Error: Kubernetes control plane is not ready after updating cloud provider configuration
  ```

  This error occurs if the Certificate Authority (CA) cert in `/etc/kubernetes/pki/ca.crt` does not have read permission set.

  **Workaround:**

  1. To allow read access for the CA file, run the following command:

      ``` bash
      sudo chmod 644 /etc/kubernetes/pki/ca.crt
      ```

  2. Re-run the update script:

      ```bash
      cd controller-installer
      ./update.sh
      ```

#### Analytics

- **The `nginx.master.reloads` metric increments and sums incorrectly (14533)**

  Previously the `nginx.master.reloads` metric remained `0` even when reloads were applied. Currently, this metric increases when reloads are *not* applied.

#### API Management

- **Object contains invalid IDP reference message (19943)**

  When upgrading from a version of NGINX Controller prior to and including v3.8, an error may be generated when updating a published API if it had an authentication policy.

  **Workaround:**

  Delete the published API and re-publish it.

- **To view Identity Providers and API Definitions, new users need at least `guest` role (20182)**

  New users will not see existing Identity Providers or API Definitions unless they are assigned one of the built-in roles (`admin`, `user`, `guest`). This is true even if the user is assigned a custom role with environment-level permissions.

  **Workaround:**

  When creating a new user, you must assign the `guest` role (or higher) for the user to view Identity Providers and API Definitions. Alternatively, if you're using a custom role, you can use the API to grant explicit permissions for the `/security/identity-providers` and `/services/api-definitions` endpoints. See the [Manage Roles and Role Groups]({{< ref "/controller/platform/access-management/manage-roles" >}}) topic details.

#### App Security

- **After enabling WAF, security violations aren't reported right away (10558)**

  When an App Component is initially enabled with WAF, there may be a few seconds where Security Events (that is, WAF violation events) are not mapped to the correct App Component and App. The following warning message is logged in `/var/log/nginx-controller/security-events-mgr.log`: *"Generating event without app-centric dimensions (that is, app, component, environment, gateway, correlationId)."*

- **Security events not mapped to App or App Component if combined length of resource IDs exceeds 445 characters (11112)**

  Security events might not be mapped to the correct App or App Component if the combined length of the resource IDs for Environment, App, App Component, and Gateway exceeds 445 characters.

- **NGINX service fails to start if SELinux enforcing mode is enabled after NGINX App Protect is deployed (16540)**

  Setting SElinux to enforcing mode on an NGINX App Protect Instance may cause the NGINX service to fail to start after the Instance is rebooted.

  **Workaround:**

  Enable SElinux enforcing mode before deploying NGINX App Protect.

- **The Instance hostname value is not available in the Security Events logs (17023)**

  The hostname value in the Security Events logs is incorrectly set to `N/A`.

- **Gateway configuration stuck at `Configuring` if referenced instances aren't running App Protect processes (19441)**

  In the cases where a Gateway references multiple instances, the Gateway configuration status may be stuck at `Configuring` after an update request is made if the App Protect processes are not running on one or more of the instances that the Gateway references.

  **Workaround:**

  Ensure all the instances that the Gateway references have App Protect processes running, then make a request to update the Gateway configuration again.

#### Infrastructure

- **Controller Agent fails to download when deploying instance on AWS with RHEL 7 and CentOS 7 (19423)**

  When deploying an instance to AWS with RHEL 7 and CentOS 7, the installation fails, and the following error is logged to `/var/log/agent_install.log`: "Failed to download the install script for the agent."

  **Workaround:**

  Ensure that the image referenced in the `instance_template` has wget installed.

- **NGINX Controller reports missing `nginx.conf.bak` file when reloading NGINX Plus configuration times out (20227)**

  In cases where reloading the backup NGINX Plus configuration file times out, NGINX Controller reports an error similar to the following:

  ```bash
  Failed to deploy to instance (<instance name>). Could not restore: nginx.conf.bak rename /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf: no such file or directory.
  ```

  This error is inaccurate and can be ignored. The `nginx.conf.bak` file cannot be found because the backup was successfully restored, and a subsequent attempt to restore from the file fails.

#### Licensing

- **APIM License limits may display incorrectly (19919)**

  After applying an NGINX Controller license, the license limits for API calls displayed in the web interface and the API are incorrect. You can safely ignore these incorrect license limits; you will have the correct entitlement on NGINX Controller.

#### Platform

- **Misleading error message when creating a node with a unique node name and an existing IP address (18838)**

  When creating a node with a unique name but with the same IP address as another node in a multi-node cluster, the following error is shown: *"Error creating node: the node already exists. Use a different node name, then try again."*

  **Workaround:**

  When adding a node to a multi-node cluster, both the node's name and IP address must be unique. If you encounter this error and you've used a unique name for the node, try using a different IP address.

- **Floating IP has to be removed to be updated (19011)**

  It's not possible to swap out the floating IP with a different value and have the changes take effect immediately. To update the floating IP, you must first remove the existing value and then add a new one.

  To change the floating IP, take the following steps:

  1. To remove the existing floating IP using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a PATCH request to the `/platform/global` endpoint. Submit an empty string for the `clusterFloatingIP` value.
  1. To remove the existing floating IP using the web interface:

      1. Open the NGINX Controller web interface and log in.
      1. Select the NGINX Controller menu icon, then select **Platform**.
      1. On the **Platform** menu, select **Cluster**.
      1. In the **Cluster Configuration** pane, select the edit icon (pencil).
      1. Select the **Use Floating IP** toggle to disable it.
      1. Select **Save**.

  1. Restart NGINX Controller:

      ```bash
      /opt/nginx-controller/helper.sh controller restart
      ```

- **Multi-node, resilient deployments and automated backups of embedded config DB are not supported on AWS (20052)**

  NGINX Controller does not support multi-node, resilient deployments on AWS at this time. Automated backups of the embedded config DB for multi-node, resilient clusters on AWS are also not supported.

- **Switching between roles in the Recent Roles and Groups menu shows incorrect permissions (20180)**

  If you select among the roles in the **Recent Roles and Groups** menu in the Platform web interface, the selected role's displayed permissions are incorrect and are for the previously selected role. For example, if you select a role called "role-a," and then select a role called "role-b", the permissions shown for "role-b" are the permissions for "role-a."

  The permissions have not changed and will not change so long as you do not select **Update**.

  **Workaround:**

  To view the correct permissions for a custom role, select **Roles Overview** in the **Roles** menu, then select a role in the **Roles** list.

#### Documentation

- **API Reference does not specify that TCP/UDP App Components are experimental (20285)**

  In the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}), the schema for App Components includes two objects related to TCP/UDP support that are missing the **x-f5-experimental** extension: `ComponentTcpUdpDesiredState` and `ComponentTcpUdpCurrentState`. TCP/UDP App Components are not supported in NGINX Controller v3.12.

<span id="3-12-0-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.10.0

October 27, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.10.0, in the following categories:

- [Updates](#3-10-0-updates)
- [Resolved Issues](#3-10-0-resolved)
- [New Issues](#3-10-0-issues)
- [Supported Versions](#3-10-0-supported)

<span id="3-10-0-updates"></a>

### Updates

NGINX Controller 3.10.0 includes the following updates:

- Bug fixes and improvements.
- Improves uninstalling NGINX Controller by deleting Kubernetes by default.
- Optimizes health checks. Health checks are instantiated only once on an NGINX Plus instance for each upstream group of app servers.
- Adds new request and response schema viewers to the Dev Portal, making it easier to understand each endpoint.
- Adds support for API documentation on the Dev Portal when  API definitions are published multiple times with different base paths.
- Adds rate aggregation to the metrics API.
- Adds an app-centric Analytics Overview Page.
- Adds a new connected licensing option, which allows pricing based on usage.
- Adds support for long hostnames -- with a length of 255 octets, including separators -- for Gateway URIs.

<span id="3-10-0-resolved"></a>

### Resolved Issues

#### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for details.

- The NGINX Controller Agent does not use absolute paths when calling system utilities (16119)

  - Solution Article: [K43530108](https://support.f5.com/csp/article/K43530108) | CVE-2020-27730

#### Additional Fixes

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- Selecting between recent API Definitions and Dev Portals doesn't refresh the webpage (14602)
- Once registered with NGINX Controller, a data path instance cannot be renamed (15835)
- Create App Component settings for URI rewrites and header modification display URIs for non-referenced gateways (16103)
- The NGINX Controller OpenAPI Spec fails OAS 3 validation (16366)
- Increase the default PostgreSQL max database connections for production deployments (16386)
- URI rewrites are not supported with API Key auth policy (16510)
- Error tells users to check username and/or password when bind user credentials are incorrect (16602)
- Long hostnames are not supported in Gateway URIs  (16759)
- The NGINX HTTP Errors graph per instance renders 4xx and 5xx error stats for upstreams in the same color (16884)
- Add an Instance Using a Template procedure is missing a step (16920)

<span id="3-10-0-issues"></a>

### New Issues

#### Installation and Upgrade

- **Canceling an installation on a system running NGINX Controller will uninstall NGINX Controller (17676)**

  If you run the `install.sh` script on a system with NGINX Controller installed, and then press `Ctrl+C` to cancel the installation, the installer will roll back any changes and completely remove NGINX Controller.

- **On Red Hat Enterprise Linux, the `/var/log/messages` file fills up with errors related to `db-rollup-job` (17716)**

  On Red Hat Linux Enterprise (RHEL) systems running Docker CE and  NGINX Controller, the `/var/log/messages` file is filled with errors related to `db-rollup-job` that look similar to the following:

  ```bash
  docker_sandbox.go:384] failed to read pod IP from plugin/docker: NetworkPlugin cni failed on the status hook for pod "db-rollup-job-1600982700-kpnzx_nginx-controller"
  ```

  **Workaround:**

  Docker CE is not officially supported on Red Hat Enterprise Linux (RHEL). **To use Docker on RHEL, you must install Docker from the RHEL Extras repository.**

  Take the following steps to resolve this issue:

  To resolve this issue:

  1. Uninstall NGINX Controller:

      ```bash
      /opt/nginx-controller/uninstall.sh
      ```

  1. Remove Docker CE.
  1. Install the supported Docker version from the RHEL Extras repository. See the [Red Hat "Getting Started with Containers"](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index#getting_docker_in_rhel_7) guide for instructions.
  1. Re-install NGINX Controller:

      ```bash
      cd controller-installer
      ./install.sh
      ```

#### API Management

<span id="apim-17124"></a>

- **Specifying a URI to a JWK Set file is not supported on instances with multiple gateways (17124)**

  A JWT identity provider that's configured to upload the JWT Set from a file referenced by a URI is not supported on NGINX Plus instances that have multiple gateways.

  **Workaround:**

  Ensure that only a single gateway resides on the NGINX+ instance.

#### Apps and Services

- **Type-1 directives ignored by UI for app components (17697)**

  There are many NGINX directives that are supported by the Components API that are not yet available within the web interface. To set any of these directives, you must make an explicit REST call to the Component endpoint. Because the web interface does not take this into account, any changes made to a Component via the web interface results in these settings being removed.

  **Workaround:**

  To take advantage of these new NGINX directives for Components, you must make any changes via the web interface first (or not use the web interface for Components). You can then use the explicit REST call for the Component to set the additional NGINX directives.

#### Infrastructure

- **System Properties dialog showing current and available Agent versions was removed (17998)**

  On NGINX Controller 3.10 and earlier, you could view the current Agent version and available Agent versions (for upgrades) by going to **Infrastructure** > **Instance** > **Graphs**, choosing a system in the list, and then selecting the gear icon to show the System Properties dialog. This dialog was removed in NGINX Controller 3.10.

  **Workaround:**

  When you upgrade NGINX Controller, you must upgrade the Controller Agent as well to keep the versions in sync, following the instructions here:  [Controller Agent Installation Guide]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}}).

  To determine the Agent version that's running on an instance, log into the instance and run the following command for your distribution type:

  - On Ubuntu/Debian:

    ```bash
    dpkg --list nginx-controller-agent
    ```

    The output looks similar to the following:

    ```bash
    Desired=Unknown/Install/Remove/Purge/Hold
    | Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
    |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
    ||/ Name Version Architecture Description
    +++-=====================================================-===============================-===============================-===============================================================================================================
    ii nginx-controller-agent 3.10.0-13964801~bionic amd64 NGINX Controller Agent
    ```

  - On RHEL/CentOS:

    ```bash
    sudo yum list installed nginx-controller-agent
    ```

    The output looks similar to the following:

    ```bash
    Loaded plugins: fastestmirror, versionlock
    Loading mirror speeds from cached hostfile
    * base: d36uatko69830t.cloudfront.net
    * epel: d2lzkl7pfhq30w.cloudfront.net
    * extras: d36uatko69830t.cloudfront.net
    * updates: d36uatko69830t.cloudfront.net
    Installed Packages
    nginx-controller-agent.x86_64 3.10.0-13964792.el7 @nginx-controller
    ```

  The leading part of the version string -- that is, the part before the initial '`-`' character (for example, 3.10.0) -- should match your NGINX Controller vstring.

#### Platform

- **Users aren't notified when an admin changes users' passwords (18088)**

  When an administrator changes a user's account password, the user is not notified about the password change. The user must contact the administrator to get the new password to log back into the system.

<span id="3-10-0-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.9.0

September 24, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.9.0, in the following categories:

- [Updates](#390-updates)
- [Resolved Issues](#390-resolved)
- [New Issues](#390-issues)
- [Supported Versions](#390-supported)

<span id="390-updates"></a>

### Updates

NGINX Controller 3.9.0 includes the following updates:

- Bug fixes and improvements.
- Adds support for PostgreSQL 12.3.
- Adds support for multiple gateway refs on a published API.
- Adds the capability to publish API documentation simultaneously when you publish an API, keeping your docs and API in sync.
- Adds the ability to redirect incoming HTTP requests, including the ability to associate redirect rules with specific component and/or gateway URIs.
- Adds support for TLS tuning on the proxy side of the NGINX reverse proxy.
- Adds support for acting on or ignoring specific response header fields from proxied servers.

<span id="390-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- The Analyzer page reports 0 certificates when a cert is configured (14017)
- NGINX Controller install script provides wrong commands for installing Docker CE on Red Hat Enterprise Linux 7 (15666)
- Custom Dashboards must be re-created after upgrading from NGINX Controller 3.7 to 3.8 (15815)
- Per-environment and guest user access is broken for upgrades from NGINX Controller 3.4 or earlier (15941)
- NGINX Controller Agent troubleshooting guide incorrectly refers to stub_status module (16028)
- After upgrading to NGINX Controller 3.8, some statistics aren't updated on the Graphs page (16064)

<span id="390-issues"></a>

### New Issues

#### Analytics

- **The NGINX HTTP Errors graph per instance renders 4xx and 5xx error stats for upstreams in the same color (16884)**

  On the **Infrastructure** > **Instances** > *Graphs* page in the NGINX Controller web interface, the **NGINX HTTP Errors** graph per instance uses the same color for both 4xx and 5xx error statistics.

  **Workaround:**

  To see the 4XX errors, you can disable the 5XX errors by selecting **http.status.5XX** on the chart's legend. Similarly, if you want to see the 5XX errors, disable the 4XX errors by selecting **http.status.4XX** on the chart's legend.

#### API Management

- **URI rewrites are not supported with API Key auth policy (16510)**

  A published API cannot have URI rewrites and an API Key authentication policy specified in the same component.

#### Apps and Services

- **Long hostnames are not supported in Gateway URIs  (16759)**

Using long hostnames in the Gateway URI results in errors that cause the configuration to fail.

#### Infrastructure

- **Increase the default PostgreSQL max database connections for production deployments (16386)**

  When deploying NGINX Controller in production environments, the default PostgreSQL `max_connections` of 100 is too low to support more than 20 NGINX Plus instances.

  **Workaround:**

  Edit the PostgreSQL database configuration file to increase the `max_connections` value from the default of 100 to 200. See the [PostgreSQL "Tuning your PostgreSQL Server"](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server) guide for instructions.

- **New instances stay in Configuring state if they exceed the license limit (16881)**

  When adding a data-path instance -- for example, adding an NGINX Plus instance with the Controller Agent -- that exceeds your license limit, the instance stays in a Configuring state and cannot be deleted. This unconfigured instance does not affect the ability to manage registered, licensed instances.

  **Workaround:**

  Contact NGINX Support via the [MyF5 Customer Portal](https://account.f5.com/myf5) if you need to acquire more licenses. Once you have enough licenses, reinstall the Controller Agent on the instance that's stuck in a Configuring state, using a different name for the instance than you used before. After the Controller Agent installs, the instance will register with NGINX Controller, where you'll see the registered instance as well as the instance that's stuck in a Configuring state. You can ignore the stuck instance.

#### Platform

- **Error tells users to check username and/or password  when bind user credentials are incorrect (16602)**

  When Active Directory is used for external authentication, if the Bind user credentials or URI information are updated with invalid information, users are shown an error when logging on the NGINX Controller that their username or password is invalid. The error should say that the authentication provider cannot be reached and to try again later or contact the system administrator for assistance.

#### Documentation

- **The NGINX Controller OpenAPI Spec fails OAS 3 validation (16366)**

  The NGINX Controller OpenAPI specification that's provided as a download from in the API Reference guide fails OAS 3 validation and cannot be imported into NGINX Controller.

- **Users endpoints aren't shown in the NGINX Controller API reference guide (16705)**

  When viewing the NGINX Controller API reference guide, the Users endpoints might not display in the endpoints list. When scrolling to the bottom of the list, the list ends at Services.

  **Workaround:**

  Expand the Services endpoints. The endpoints list will refresh, and the Users endpoints are shown just below Services.

- **Add an Instance Using a Template procedure is missing a step (16920)**

  The *Add an Instance Using a Template* procedure is missing a step. The complete procedure is as follows:

  1. Select the NGINX Controller menu icon, then select **Infrastructure**.
  1. On the **Infrastructure** menu, select **Instances**.
  1. On the **Instances** overview page, select **Create**.
  1. Select **Create a new instance using a template**.
  1. Add a name.
  1. Select a Location in the list, or select **Create New** to create a Location.
  1. Select an Instance Template in the list, or select **Create New** to create an Instance Template.
  1. Select **Submit**.

<span id="390-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.8.0

September 1, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.8.0, in the following categories:

- [Updates](#380-updates)
- [Resolved Issues](#380-resolved)
- [New Issues](#380-issues)
- [Supported Versions](#380-supported)

<span id="380-updates"></a>

### Updates

NGINX Controller 3.8.0 includes the following updates:

- Bug fixes and improvements.
- Adds stricter password requirements. Passwords for local users must be between 8–64 characters; [commonly used passwords](https://en.wikipedia.org/wiki/List_of_the_most_common_passwords) are rejected. **All existing users must update their passwords to adhere to the updated password policy.**
- Adds SELinux support for data plane hosts.
- Adds support for an internal PostgreSQL database for NGINX Controller, for demo and trial purposes only.
- Adds support for basepath within a Published API.
- Adds data forwarder for Datadog (beta).
- Adds improved filtering for data forwarders.
- Adds custom dashboards for Apps.
- Adds full support for request URI rewrites for web apps, including:
  - The ability to scope rewrite rules by associating rules with specific component and/or gateway URIs;
  - The ability to specify rewrite flags.
- Adds support for performance and interaction tuning (buffering, timeouts) between the NGINX+ data plane and the back-end (upstream) workloads.
- Adds support for compressing responses using the ["gzip" method](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip). This often helps to reduce the size of transmitted data by half or even more.
- Adds support for running the NGINX Plus data plane as a particular user.
- Adds support for retrieving an NGINX Plus certificate and key via the REST API. You can download the certificate and key as a JSON or gzip file.

<span id="380-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- The rewrite directive is not associated with a particular URI or location block in the generated configuration (10473)
- SELinux settings can prevent statistics flow from agents (10342)
- Code sample in the Dev Portal may have unintended URL encodings (13908)
- Configuration changes are not deployed to all instances when one instance is unavailable (14227)
- Note for PUT Update An Authentication Provider is incorrect (14576)
- Cannot log in to the NGINX Controller web interface using Firefox v77 (14800)
- Controller Agent fails to download when deploying an instance to AWS on Red Hat Enterprise Linux 7 (14886)
- Upgrading Controller Agent returns an error that named instance already exists (14932)

<span id="380-issues"></a>

### New Issues

#### Installation and Upgrade

- **NGINX Controller install script provides wrong commands for installing Docker CE on Red Hat Enterprise Linux 7 (15666)**

  When installing NGINX Controller on Red Hat Enterprise Linux 7, the install script displays commands for installing Docker CE that are for are an older, unsupported version of Docker CE.

  **Workaround:**

  Before installing NGINX  Controller on Red Hat Enterprise Linux 7, you should install Docker CE 18.09 (recommended version).

- **Custom Dashboards must be re-created after upgrading from NGINX Controller 3.7 to 3.8 (15815)**

  When upgrading from NGINX Controller 3.7 to 3.8, Custom Dashboards are not migrated. You must re-create any Custom Dashboards after completing the upgrade.

#### Analytics

- **Alerts set using NGINX Controller 3.6 or earlier need to be updated after upgrading to NGINX Controller 3.8 (14565)**

  Alerts that are set using NGINX Controller 3.6 and earlier are not checked after upgrading to NGINX Controller 3.8; the "last checked" dates for these alerts are from before the upgrade.

  **Workaround:**

  To resume checking the alerts, go to the **Analytics** > **Alerts** page in the NGINX Controller user interface, then mute and unmute the alerts.

#### Apps and Services

- **Create App Component settings for URI rewrites and header modification display URIs for non-referenced gateways (16103)**

  The **Applicable URIs** list for URI rewrites and header modifications on the **Create App Component** page shows both referenced and non-referenced gateway URIs to choose from. If the URI for a non-referenced gateway is selected, NGINX Controller returns an error like the following: "Applied URI: <non-referenced URI> is not a part of the ingress URI."

  **Workaround:**

  When selecting a gateway URI from the **Applicable URIs** list, select only URIs for gateways that the component references.

#### Infrastructure

- **The Analyzer page reports 0 certificates when a cert is configured (14017)**

  The Analyzer misevaluates SSL certificates associated with instances. The Analyzer page reports the number of certificates as 0 in the SSL block, even when certificates have been configured.

  **Workaround:**

  To see if your configuration is using a certificate:

  1. Open the NGINX Controller web interface and log in.
  1. From the NGINX Controller menu, select **Services** > **Certs** > **Overview**.
  1. On the Certs Overview page, select a certificate from the list. This opens a side panel where you can view the certificate's details, including whether the certificate is associated with an app component and/or gateway.

- **Once registered with NGINX Controller, a data path instance cannot be renamed (15835)**

  The name of your data-path instance -- that is, the location where you install the NGINX Controller Agent -- is fixed and cannot be changed once the instance is registered with NGINX Controller.

  When upgrading the Controller Agent, the install script allows entering a different instance name; however, this name is meant for adding new instances only. Attempting to provide another instance name when upgrading the Controller Agent could cause metrics to be misreported.

  **Workaround:**

  When upgrading the Controller Agent you can omit the instance name, or if you include the name, you must use the existing instance name.

- **After upgrading to NGINX Controller 3.8, some statistics aren't updated on the Graphs page (16064)**

  After upgrading from NGINX Controller 3.7 to 3.8, you may notice that some statistics on the Instances Graphs page -- in the web interface, select **Instances** > **Graphs** -- aren't updated for some configurations.

  **Workaround:**

  To resolve this issue, restart the `nginx` and `controller-agent` services on the NGINX Plus instance:

  - `service nginx restart`
  - `service controller-agent restart`

  After restarting these services, NGINX Controller should start reporting the statistics again.

#### Platform

- **Per-environment and guest user access is broken for upgrades from NGINX Controller 3.4 or earlier (15941)**

  Due to a change to the permission structure in NGINX Controller 3.4, upgrades from pre-3.4 versions to post-3.4 versions -- including upgrades to NGINX Controller 3.8 -- can break access for guest users and for users with “per-environment” roles.

  **Workaround:**

  There are two workarounds for this issue, depending on your upgrade history and risk tolerance.

  - Option 1 (recommended): If you have not yet upgraded NGINX Controller from a pre-3.4 release, first upgrade to NGINX Controller 3.4, and then upgrade again to the latest release.

  - Option 2: If you have already upgraded from a pre-3.4 release to a post-3.4 release without upgrading *to* 3.4 in the interim, you can only work around this issue by elevating the permissions of your guest users to regular users.

    {{< warning >}}This change involves a **significant elevation of privilege** and should be undertaken only with careful consideration. The regular user role has all the same admin role permissions except for the ability to promote new admins. If this change is acceptable for your installation -- for any guest role users and any per-environment users with the guest role -- these users should be edited by the default admin account to remove the guest role and replace it with the user role.{{< /warning >}}

#### Documentation

- **NGINX Controller Agent troubleshooting guide incorrectly refers to stub_status module (16028)**

  In the NGINX Controller troubleshooting guide, which you can find at `https://<Controller-FQDN>/docs/support/troubleshooting-controller`, some of the information in the section covering metrics is incorrect.

  See the following steps and corrections:

  - Step 4. Make sure the Controller Agent is using the same user ID as the NGINX worker processes. The default user ID is `nginx`.

    > **Correction**: The default user ID for the NGINX Controller Agent is `root`.

  - Step 8. Make sure `stub_status` is configured, and the **stub_status module** is included in the NGINX build. To check, run the following command:

    ```bash
    nginx -V
    ```

    The output should mention `--with-http_stub_status_module`.

    > **Correction**: The NGINX Controller Agent gathers metrics via the NGINX Plus API, not via the `stub_status` module.

  **Workaround:**

    When troubleshooting issues with metrics, instead of checking that `stub_status` is enabled, you should verify that `nginx api` is enabled.

- **The applies-to version list at the bottom of some docs doesn't include NGINX Controller 3.8 (16795)**

  At the bottom of the NGINX Controller docs, there's a list of NGINX Controller versions that each doc applies to. For some docs installed with NGINX Controller 3.8, this list wasn't updated. All of the docs installed with NGINX Controller 3.8 apply to that version.

<span id="380-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.7.0

July 30, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.7.0, in the following categories:

- [Updates](#370-updates)
- [Resolved Issues](#370-resolved)
- [New Issues](#370-issues)
- [Supported Versions](#370-supported)

<span id="370-updates"></a>

### Updates

NGINX Controller 3.7.0 includes the following updates:

- Bug fixes and improvements.
- Bundles Kubernetes dependencies with the NGINX Controller installer, making installations more straightforward and reliable.
- Disables port 80 for the NGINX Controller API gateway. Previously, NGINX Controller used port 80 to make initial redirects to HTTPS on port 443. Now, port 80 is disabled for the API gateway, and redirects aren’t supported. Port 443 is required to explicitly add `https://` when pasting the FQDN in the address of the browser or when making API calls. **Note: When you upgrade NGINX Controller, you also need to upgrade the NGINX Controller Agent software on each monitored NGINX Plus Instance.**
- Updates the Controller Agent to use golang instead of Python.
- Adds Role Groups. Role Groups act as a collection of Roles that you can manage as a single resource. Role Groups can be mapped only to external auth provider groups; they cannot be assigned to local users.
- Adds unique, individual salt to secure account passwords. **Note**: **We recommend that users update their existing passwords** to take full advantage of this enhancement.
- Adds "Top X" functionality to limit the number of returned series in metrics queries to the top X data of probes. Multiple series that don't fit into a limit are collapsed into a single series.
- Adds a 'dimension' query parameter to the metrics API, which can be used to define the dimensions list to return for each metric series.
- Adds a filtering option for refining the data that's forwarded to Splunk using the data forwarder.
- Introduces a new user interface for the Dev Portal. Create and manage beautiful, easy-to-use API reference documentation to support your published APIs.
- Adds support for importing OpenAPI v2 specs (OAS) for your APIs.
- Adds Total Latency metrics to the Environments, Apps, and App Components overview pages.

<span id="370-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- Upgrading from Controller 3.0.0 to 3.1.0 breaks application-centric metrics (8669)
- Certificates imported out of order using drag-and-drop cause an error when creating a cert bundle (10761)
- Importing API specs fails when done in the web interface (13501)
- Cannot log in to NGINX Controller when admin email address contains uppercase letters (13775)

<span id="370-issues"></a>

### New Issues

#### General

- **Cannot log in to the NGINX Controller web interface using Firefox v77 (14800)**

  When trying to log in to the NGINX Controller web interface using Firefox v77, the following error occurs: `SyntaxError: invalid regexp group IdentityProvider.form.tsx:364:17 <anonymous> IdentityProvider.form.tsx:364 Webpack 28`.

  **Workaround:**

  Upgrade to Firefox v78.

#### API Management

- **Code sample in the Dev Portal may have unintended URL encodings (13908)**

  In some cases, the example code snippet in the Dev Portal is URL encoded when the API has path parameters. For example, the code snippet might look similar to the following:

  ```bash
  curl --request GET --url http://sportsapp.example.com/api/f1/drivers/%7BdriverId%7D
  ```

  **Workaround:**

  You must remove the URL encoding before running the example code snippet, like so:

   ```bash
   curl --request GET --url http://sportsapp.example.com/api/f1/drivers/{driverId}
   ```

- **Known issues creating a Dev Portal using the NGINX Controller API (14385)**

  - When passing a partial or incomplete theme customization payload to Dev Portal CRUD operations, the Dev Portal uses the missing settings' default values. To customize fully, include the complete payload.

  - The Dev Portal supports only a curated list of fonts. You can see the list of accepted fonts while configuring a Dev Portal theme using the NGINX Controller web interface. If an invalid font value is submitted using the API, there's no validation on the font value, and the default font is used instead.

  **Workaround**:

  Use the NGINX Controller web interface to construct a valid payload for creating and customizing the Dev Portal.

- **Error status of Published API component affects publishing to Dev Portal (14452)**

  The Dev Portal can be created and associated with a Published API at the same time. However, if the Published API is in an error state when the Dev Portal is created, an error is issued that incorrectly says that creating the Dev Portal failed. Then if the Dev Portal is resubmitted, the association fails with an "object exists" error. Furthermore, if the Published API is in an error state, publishing documentation to the Dev Portal for that API also fails.

  **Workaround:**

  Check the component status for the Published API before creating and associating a Dev Portal for it.

- **Selecting between recent API Definitions and Dev Portals doesn't refresh the webpage (14602)**

  On the APIs page, selecting between items in the **Recent  API Definitions and Dev Portals** quick list doesn't refresh the page. Whichever item is displayed first is persistent.

  **Workaround:**

  To view specific API Definitions, select **APIs** > **API Definitions**. Then from the API Definitions list page, choose the API Definition that you want to view. Likewise, to view specific Dev Portals, select **APIs** > **Dev Portals**. Then from the Dev Portal list page, choose the Dev Portal that you want to view.

#### Infrastructure

- **Configuration changes are not deployed to all instances when one instance is unavailable (14227)**

  In multi-instance environments, when a configuration change cannot be deployed to one instance, such as when an instance is not available, the configuration is not deployed to any of the other instances.

- **Controller Agent fails to download when deploying an instance to AWS on Red Hat Enterprise Linux 7 (14886)**

  When deploying an instance to Amazon Web Services (AWS) on Red Hat Enterprise Linux 7, the installation fails, and the following error is logged to `/var/log/agent_install.log`: "Failed to download the install script for the agent."

  **Workaround:**

  - Ensure that ports 443 and 8443 are open between NGINX Controller and the network where the instance is being deployed.

  - Verify that NGINX Controller can be accessed from the instance using the FQDN that was provided when NGINX Controller was installed

  - Ensure that the image referenced in the `instance_template` has a cURL version of 7.32 or newer.

- **Upgrading Controller Agent returns an error that named instance already exists (14932)**

  When Upgrading the Controller Agent, the install script warns that the named instance already exists and says to choose another name or remove the existing instance.

  **Workaround:**

  This error can be ignored for Controller Agent upgrades.

#### Documentation

- **Note for PUT Update An Authentication Provider is incorrect (14576)**

  In the NGINX Controller API reference guide, the description for the PUT `/platform/auth/providers/{providerName}` endpoint incorrectly says, "You must provide the full request body, including all configuration options, in a PUT request."

  As long as the required parameters are included in the PUT request, the update works.

<span id="370-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.6.0

July 1, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.6.0, in the following categories:

- [Updates](#360-updates)
- [Resolved Issues](#360-resolved)
- [New Issues](#360-issues)
- [Supported Versions](#360-supported)

<span id="360-updates"></a>

### Updates

NGINX Controller 3.6.0 includes the following updates:

- Bug fixes and improvements.
- Adds external authentication using Active Directory (beta).

  {{< note >}} Active Directory users are given user-level access to NGINX Controller in this beta implementation.{{< /note >}}

- Adds ability to create orchestrated Instances on AWS using Instance Templates.
- Adds metrics forwarding for Splunk (beta).
- Adds ability to secure published APIs by configuring authentication, conditional access, and rate limiting at the Component level.
- Adds ability to configure DNS Service Discovery at the Component level.
- Introduces a new user interface for Identity Providers.
- Adds `./opt/nginx-controller/helper.sh repository-cred` for getting the repo key and cert, needed for installing NGINX Plus.
- Changes the default security option for Instance registration. Registration of NGINX Plus Instances is now performed over a secure connection by default. A new option -- **Allow insecure server connections to NGINX Controller using TLS** -- is available in the user interface. This option allows you to use self-signed certificates with the Controller Agent. For security purposes, we recommend that you secure the Controller Agent with signed certificates when possible.

> **End of Support:** Debian 8 (i386, x86_64) is [unsupported as of June 30, 2020](https://wiki.debian.org/LTS/Jessie). As such, NGINX Controller Agent support for Debian 8 will end with NGINX Controller v3.7. End of Support means that NGINX will not fix bugs related to Debian 8 in NGINX Controller 3.7 and later.

<span id="360-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

#### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for each issue.

- Command to install Controller Agent includes `--no-check-certificate` by default (4166)

  - Solution Article: [K31150658](https://support.f5.com/csp/article/K31150658) | CVE-2020-5909

- NATS services do not require authentication (6404)

  - Solution Article: [K59209532](https://support.f5.com/csp/article/K31044532) | CVE-2020-5910

- On Debian and Ubuntu, Kubernetes packages are downloaded over plaintext HTTP (11771)

  - Solution Article: [K84084843](https://support.f5.com/csp/article/K84084843) | CVE-2020-5911

#### Additional Fixes

- REGEX and REGEX_CASE_SENSITIVE match method logic is reversed for REGEX-based Component URIs (8455)
- When there's a communication error between NGINX Controller and the Controller Agent, the problem system is identified as "None" (8564)
- Database certs with an IP address or an invalid CN cause NGINX Controller to become unresponsive (12173)
- Component URI rewrites that are added and removed using the user interface cause a rewrite error (12527)
- The match method for an API Definition resource is removed (defaults to PREFIX) when an API is published (12594)
- Removing `nginx-controller-agent` package with `apt-get purge` causes NGINX Plus instance to become unresponsive (12603)
- API resources with POST method must be defined using the NGINX Controller API (12652)

<span id="360-issues"></a>

### New Issues

#### Installation and Upgrade

- **Controller Agent warns that Instance name already exists during upgrade (13350)**

  When upgrading the Controller Agent, the `install.sh` script issues a warning that the Instance name already exists. This validation is a safeguard for new installations. You can safely disregard this warning for upgrades.

- **Cannot log in to NGINX Controller when admin email address contains uppercase letters (13775)**

  The installer for NGINX Controller allows users to create admin accounts with email addresses that contain uppercase letters. However, NGINX Controller expects emails to be only lowercase and prevents admin accounts with differently formatted email addresses from logging in.

  **Workaround:**

  You can reinstall NGINX Controller and enter a lowercase email address for the admin account. If that doesn’t work, contact NGINX Support for assistance.

#### API Management

- **Published APIs do not go into an error state when the Instance they are using is deleted (10616)**

  If you delete the last Instance serving a published API, and then edit the published API, the published API gets stuck in the `Configuring` state. Attempting to delete the published API causes the published API to get stuck in a `Deleting` state.

- **Rate-limit policies are lost after upgrading to NGINX Controller v3.6 (12962)**

  Existing rate-limiting policies applied to published APIs are lost when upgrading to NGINX Controller 3.6. The policies must be reconfigured at the Component level following the upgrade.

- **JWK files need to be resubmitted after upgrading from NGINX Controller v3.4 to v3.6 (13289)**

  Existing JWK files applied to Identity Providers are lost when upgrading from v3.4 to v3.6 and must be resubmitted following the upgrade.

- **Importing API specs fails when done in the web interface (13501)**

  Importing API specs from within the NGINX Controller user interface fails because of how the interface parses the text.

  **Workaround**:

  Import API specs using the NGINX Controller REST API.

#### Infrastructure

- **Restarting the Controller Agent service leaves behind PID file with errors logged to `agent.log` (13390)**

  When the Controller Agent service is restarted, the `controller-agent.pid` file is left behind, and errors about the PID file are logged in `agent.log`.

  **Workaround**:

  Manually remove `/var/run/controller-agent/controller-agent.pid`, then restart the Controller Agent service again. The Controller Agent will work normally after it restarts.

<span id="360-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.5.0

June 9, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.5.0, in the following categories:

- [Updates](#350-updates)
- [Resolved Issues](#350-resolved)
- [New Issues](#350-issues)
- [Supported Versions](#350-supported)

<span id="350-updates"></a>

### Updates

NGINX Controller 3.5.0 includes the following updates:

- Bug fixes and improvements.
- Adds support for NGINX Controller on Red Hat Enterprise Linux 7.
- Deprecates support for NGINX Controller Agent on CentOS 6.
- NGINX Controller requires the `yum-plugin-versionlock` package on Red Hat Enterprise Linux and CentOS.
- Adds Gateway dimension to the metrics API.
- Adds proxy parameters for Gateways and Components to manage retry attempts on error conditions.
- Adds socket parameters for Gateways and Components to manage incoming TCP connections for the data plane.
- Introduces a new user interface and declarative API for API Management.
- Adds support for importing an OpenAPI specification when creating an API Definition.
- Adds versioning for your API Definitions.
- The Global Settings endpoint supports configuring API Gateway certificates and database settings.
- Group your NGINX Instances by their physical locations using the Locations setting.

<span id="350-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

#### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for details.

- The NGINX Controller web interface doesn’t have sufficient protection against a Cross-Site Request Forgery (CSRF) attack. (4882, 9721)

  - Solution Article: [K31044532](https://support.f5.com/csp/article/K31044532) | CVE-2020-5900

- The account recovery code for NGINX Controller that's sent in email is not secure (11092)

  - Solution Article: [K25434422](https://support.f5.com/csp/article/K25434422) | CVE-2020-5899

- Undisclosed API endpoints may allow for a reflected Cross-Site Scripting (XSS) attack (12021)

  - Solution Article: [K43520321](https://support.f5.com/csp/article/K43520321) | CVE-2020-5901

#### Additional Fixes

- Cannot delete an instance that doesn't have NGINX Plus installed (7704)
- NGINX Controller registers an existing instance as a new instance when compute VM changes (7844)
- Cannot change SMTP password using the `platform/global` endpoint (11049)
- NGINX Controller v3 does not support Red Hat Enterprise Linux 7 (11282)
- Identity Provider API keys are not migrated during full or incremental upgrades from NGINX Controller v3.0 to v3.4 (11286)
- Security section appears in the documentation but has no content (11294)

<span id="350-issues"></a>

### New Issues

#### Installation and Upgrade

- **Package error when installing `nginx-plus-module-njs` on CentOS 7 (12638)**

  When installing `nginx-plus-module-njs` on CentOS 7, the installer returns a package error.

  **Workaround:**

  1. Uninstall the existing `nginx-plus-module-metrics` module:

      ```bash
      sudo yum remove -y nginx-plus-module-metrics
      ```

  1. Install the latest version of `nginx-plus-module-njs`:

      ```bash
      sudo yum install -y nginx-plus-module-njs
      ```

  1. Install the `nginx-plus-module-metrics` module, specifying the version as 1.19:

      ```bash
      sudo yum install -y nginx-plus-module-metrics-1.19*
      ```

  **Verification:**

  1. To confirm that the correct versions are installed, run the following command:

      ```bash
      yum list installed | egrep 'nginx|metrics'
      ```

      The expected output looks similar the following:

      ```bash
      avrd-libs.x86_64 0.15.5_1850598.release_3_5-1 @nginx-controller-metrics
      nginx-controller-agent.x86_64 3.5.0-10484161.el7 @nginx-controller
      nginx-plus.x86_64 22-1.el7.ngx @nginx-plus
      nginx-plus-module-metrics.x86_64 1.19.0-1850598.el7.ngx @nginx-controller-metrics
      nginx-plus-module-njs.x86_64 22+0.4.1-1.el7.ngx @nginx-plus
      ```

#### API Management

- **The match method for an API Definition resource is removed (defaults to PREFIX) when an API is published (12594)**

  The URIs for a Published API use the `PREFIX` match method, regardless of the resource match method that was specified in the API Definition.

- **API resources with POST method must be defined using the NGINX Controller API (12652)**

  When defining an API Definition version with a resource that uses the POST method and specifies an example request, the generated API spec in the web interface is invalid.

  **Workaround**:

  Use the NGINX Controller API to define API Definition version resources that use the POST method and contain an example request in the API documentation.

#### Apps and Services

- **Component URI rewrites that are added and removed using the web interface cause a rewrite error (12527)**

  If a URI rewrite for a Component is added and then deleted using the NGINX Controller web interface, the API spec that's sent to NGINX Controller includes an empty `programmability` section. This results in an `Error` status for the Component, and an error similar to the following is returned: `"Error: Arguments of rewrite : incomingPattern or rewritePattern is missing."`

  **Workaround:**

  - Option 1 (Recommended): Send a PUT request to the Components endpoint that excludes the `programmability` section.

  - Option 2: Configure a placeholder rewrite that writes from a pattern to a pattern. Using a pattern that doesn't match any request is best.

#### Infrastructure

- **Controller Agent installation doesn't warn about duplicate instance names until an Instance has been registered with NGINX Controller (12370)**

  The Controller Agent installation script typically fails with a warning if the provided instance name already exists for the specified location. However, a race condition occurs if the installation script is run on two instances at the same time with the same name for the same location. When this happens, the failed installation doesn't issue a warning, but only one instance is added to NGINX Controller.

  **Workaround:**

  No workaround is necessary. The behavior is the same as if the installation script displayed the warning.

- **Removing `nginx-controller-agent` package with `apt-get purge` causes NGINX Plus instance to become unresponsive (12603)**

  When the `nginx-controller-agent` package is removed on an NGINX Plus instance using `apt-get-purge`, the `/etc/controller-agent` directory and its contents are deleted. This directory is where NGINX Controller places certificates when NGINX Controller is used to configure and manage NGINX Plus instances. When this directory is deleted, the NGINX Plus instance becomes unresponsive and the NGINX service fails to start.

#### Platform

- **Database certs with an IP address or an invalid CN cause NGINX Controller to become unresponsive (12173)**

  When a database certificate is added that uses an IP address instead of an FQDN, or if the certificate Common Name (CN) is invalid, the NGINX Controller database services reject the invalid cert and refuse database connections. In this case, the system becomes unresponsive until a valid cert is provided.

  **Workaround**:

  Use the hostname instead of an IP address, or use a certificate where the IP address is mentioned in Subject Alternative Name (SAN) as `DNS` type.

- **NGINX Controller Agent and AVRD do not work on 32-bit distributions (12605)**

  The Analytics, Visibility, and Reporting daemon (AVRD) is compiled as a 64-bit app and does not run on 32-bit distributions. Configuration Management using the Controller Agent is possible on 32-bit distributions; however, metrics are not reported.

  **Workaround:**

  Install the NGINX Controller Agent and AVRD on a 64-bit distribution.

  {{< important >}} NGINX Controller support for 32-bit distributions will be deprecated in a future release.{{< /important >}}

<span id="350-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19

&nbsp;

---

## NGINX Controller v3.4.0

May 6, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.4.0, in the following categories:

- [Updates](#340-updates)
- [Resolved Issues](#340-resolved)
- [New Issues](#340-issues)
- [Supported Versions](#340-supported)

<span id="340-updates"></a>

### Updates

NGINX Controller 3.4.0 includes the following updates:

- Bug fixes and improvements.

- Improved Controller Agent error messages that make it easier to troubleshoot connectivity issues during installation.

- Write permissions for the `platform/global` endpoint are limited only to the Admin role now, to safeguard against changes to critical server and database configurations.

- Audit events are exposed using the `/events` endpoint.

- Write permissions for the `platform/global` endpoint are limited only to the Admin role now, to safeguard against changes to critical server and database configurations.

<span id="340-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

#### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for details.

- Malformed messages lead to segmentation fault of the Analytics, Visibility, and Reporting daemon (AVRD) (9068)

  - Solution Article: [K95120415](https://support.f5.com/csp/article/K95120415) | CVE-2020-5895

- The Analytics, Visibility, and Reporting daemon (AVRD) is world-readable and writeable (9067)

  - Solution Article: [K95120415](https://support.f5.com/csp/article/K95120415) | CVE-2020-5895

- The NGINX Controller webserver does not invalidate the the server-side session token when users log out (8576)

  - Solution Article: [K13028514](https://support.f5.com/csp/article/K13028514) | CVE-2020-5894

#### Additional Fixes

- API Management module doesn't need to run on dedicated NGINX Plus instances (8665)

<span id="340-issues"></a>

### New Issues

#### Installation and Upgrade

- **Identity Provider API keys are not migrated during full or incremental upgrades from NGINX Controller v3.0 to v3.4 (11286)**

  When the conditions noted below are met, the Identity Provider API keys are not migrated and must be re-entered.

  **Conditions:**

  This issue applies when the following conditions are true:

  - You are running NGINX Controller v3.0.
  - You are running NGINX Controller v3.2, which you previously upgraded from NGINX Controller v3.0.
  - You are running NGINX Controller v3.3, which you previously upgraded from NGINX Controller v3.0.

  **Workaround:**

  Step 1: Copy and save your API Identity Profile keys

  Before upgrading, you must complete the following steps to copy and save any API Identity Profile keys that you have.

  1. Open the NGINX Controller web interface and log in.
  1. Select the NGINX Controller menu icon, then select **Services**.
  1. On the **Services** menu, select **APIs**.
  1. On the **API Management** menu, select **Identity Provider**. The Identity Provider Overview page is displayed.
  1. Locate the Identity Provider that contains the API key that you need to migrate, then select the pencil (edit) icon.
  1. In the API Clients pane, select the **Edit** button to display the Identity Provider API key.
  1. Copy the Identity Provider API key value and save it locally. **You'll need to re-enter this value after you upgrade.**

  <p style="padding-top: 10px;">You can now complete the upgrade to NGINX Controller v3.4.</p>

  Step 2: Restore your API Identity Profile keys

  After you've upgraded to NGINX Controller v3.4, you can restore the API Identity profile keys that you saved.

  1. Open the NGINX Controller web interface and log in.
  1. Select the NGINX Controller menu icon, then select **Services**.
  1. On the **Services** menu, select **APIs**.
  1. On the **API Management** menu, select **Identity Provider**. The Identity Provider Overview page is displayed.
  1. Locate the Identity Provider that contains the API key that you need to migrate, then select the pencil (edit) icon.
  1. In the API Clients pane, select the **Edit** button to display the Identity Provider API key.
  1. Paste the copied Identity Provider API key that you saved in the previous procedure into the **key** field. Then, click **Save**.


- **NGINX Controller v3 does not support Red Hat Enterprise Linux 7 (11282)**

  NGINX Controller v3 does not support Red Hat Enterprise Linux (RHEL) v7. The NGINX Controller installation fails during the Docker version check. Manually updating the Docker version on Red Hat Enterprise Linux 7 does not solve the problem.

#### Apps and Services

- **Certificates imported out of order using drag-and-drop cause an error when creating a cert bundle (10761)**

  When certificates are imported using the drag-and-drop feature in the NGINX Controller web interface, the system expects the first certificate that's added to be the public certificate. Additional certificates that are added are treated as intermediate CA certs.

  If the certificates aren't added in order, with the public certificate added first, the resulting API request has transposed values for the `publicCert` and `caCert` parameters.

  **Workaround:**

  When adding certificates using drag-and-drop, always drag the public cert file in first, followed by any additional CA certificates. The private key can be dragged in either before or after the certificates. Alternatively, you can choose to copy and paste the PEM text into the corresponding fields.

#### Platform

- **Cannot change SMTP password using the `platform/global` endpoint (11049)**

  Sending the SMTP password in a PATCH request to the `platform/global` endpoint has no effect.

  **Workaround:**

  To change the SMTP password, you can use the `help.sh` script that's located in `/opt/nginx-controller/` on the NGINX Controller host. For instructions, see the documentation that's installed with NGINX Controller: `https://<Controller-FQDN>/docs/platform/using-helper-script/#update-smtp-settings`.

#### Documentation

- **Security section appears in the documentation but has no content (11294)**

  In NGINX Controller v3.4, a "Security" panel appears in the "Services" section of the onboard documentation. If you click on the Security panel, you will not see any content listed because there is no security documentation for this release. Users should disregard the "Security" panel in the documentation for this release.

<span id="340-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R19
- NGINX Plus R20
- NGINX Plus R21

&nbsp;

---

## NGINX Controller v3.3.0

April 09, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.3.0, in the following categories:

- [Updates](#330-updates)
- [Resolved Issues](#330-resolved)
- [New Issues](#330-issues)
- [Supported Versions](#330-supported)

<span id="330-updates"></a>

### Updates

NGINX Controller 3.3.0 includes the following updates:

- Bug fixes and improvements.
- Adds support for certificate chains for TLS connections.
- Adds an API catalog for the Metrics API.
- Adds new dimensions for filtering metrics on the Application Summary page.

<span id="330-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

#### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for details.

- The NGINX Controller Agent installer script 'install.sh' uses HTTP instead of HTTPS to check and install packages (8587)

  - Solution Article: [K00958787](https://support.f5.com/csp/article/K00958787) | CVE-2020-5867

- The `helper.sh` script, which is used optionally in NGINX Controller to change settings, uses sensitive items as command-line arguments (7436)

  - Solution Article: [K11922628](https://support.f5.com/csp/article/K11922628) | CVE-2020-5866

- NGINX Controller uses insecure connection for communications with PostgreSQL database by default (6509)

  - Solution Article: [K21009022](https://support.f5.com/csp/article/K21009022) | CVE-2020-5865

#### Additional Fixes

- Creation of eventually consistent objects returns 201 instead of 202 (7052)
- Can't delete a configured gateway when there is a gateway in an error state (7058)
- Dependencies Missing from Open Source Dependencies Report (7404)
- Unreachable instance leads to stuck isConfiguring/isDeleting state (7498)
- Intermediate certificates not pushed to NGINX Plus instance (7500)
- Experimental APIs are not distinguished from supported APIs in the API Reference docs (7734)
- Agent warns about failed connection to receiver after update (9152)
- Certificate expiration shows expired warning and expiration date that doesn't match the final certificate (9167)
- Agent fails to connect to NGINX Controller if using certs signed with a custom CA (9304)
- Login endpoint has inaccurate session information in the API Reference Guide (9482)
- A volume of more than 90 pending CUD operations for Gateways and Components could cause NGINX Controller to become unresponsive (9574)

<span id="330-issues"></a>

### New Issues

#### Apps and Services

- **NGINX Controller web interface shows "Error fetching apps" after a restart (10013)**

  In some cases, after NGINX Controller restarts, you might see an error in the web interface that says, "Error fetching apps: Network Error."

  **Workaround:**

  Log out of the web interface and then log back in.

- **Gateways configured with duplicate ingress URIs error out with condition of "config" (10425)**

  When upserting a Gateway, if the ingress URI (`desiredState.ingress.uris`) is a duplicate of another Gateway's ingress URI, the upsert errors out as expected; however, the condition type (`state.conditions.type`) that's reported is simply  `config`, instead of an explanation for the condition that's occurred.

  ``` json
  "state": {
      "conditions": [
          {
              "type": "config"
          }
      ],
      "selfConfigState": {
          "configured": 0,
          "configuring": 0,
          "deleting": 0,
          "error": 1,
          "isConfigured": false,
          "isConfiguring": false,
          "isDeleting": false,
          "isError": true,
          "total": 1
      }
  }
  ```

  **Workaround:**

  To resolve the error, remove the Gateway with the duplicate ingress URI that's in the error state. You can do this by issuing a PUT request and applying a new config with a unique ingress URI, or you can issue a DELETE request to remove the Gateway with the duplicate ingress URI.

- **Component fails to configure when its Gateway URI collides with another Gateway's URI (10430)**

  In situations where a Component for one Gateway uses the FQDN of a different Gateway on the same host, NGINX Controller doesn't push the config to NGINX Plus.

  **Scenario**

  1. Create a Gateway for `foo.com` with the hostname `http://foo.com`, and deploy to NGINX Plus 'Instance 2'.
  1. Create a Component for `foo.com` with the URI `http://foo.com/`, and associate the Component with the Gateway `foo.com` and assign a workload.
  1. Create a Gateway for `bar.com` with the hostname `http://bar.com`, and deploy to NGINX Plus 'Instance 2'.
  1. Create a Component for `bar.com` with the URI `http://foo.com/baz`, and associate the Component with the Gateway `bar.com` and assign a workload.

  In this scenario, the configuration should expose the location for `/baz`. However, although the Component is reported as configured, nothing happens.

- **App Services API Known Issues (10473)**

  The App Services API has known issues for certain attributes and objects, in particular:

  - Socket parameters defined in the API should not be used at all. This includes the `receivBufferSize` and `sendBufferSize` parameters that are common to Gateway ingress and Component ingress.

  - Session persistence works only for `SessionPersistenceCookie`. Using `SessionPersistenceRoute` or `SessionPersistenceCookieLearn` results in configuration errors.

  - When configuring workload monitoring, and when using the API to check headers in the response, it's necessary to check for an exact match for the header. Matching with a regular expression or checking only for the existence of a header does not work.

  - A Load Balancing method of `HASH` won't work if it contains a variable such as `$request_URI` for the `userKey`.

  The existing URI Rewrite capability in the App Services API has the following limitations:

  - The Rewrite directive is not associated with a particular URI or location block in the generated configuration.

  - The break flag is not supported.

#### Analytics

- **SELinux settings can prevent statistics flow from agents (10342)**

  Depending on the SELinux settings, an NGINX instance might not have permission to submit statistics to your NGINX Controller.

  If you have a properly configured environment, application, and component for which no metrics are being passed to NGINX Controller after more than 30 seconds of traffic have transpired, try the suggested workaround steps.

  See the NGINX blog post [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) for additional general guidance.

  **Workaround:**

  1. On the instance(s) associated with your Gateway, run the following command as root:

      ```bash
      # grep nginx /var/log/audit/audit.log | audit2allow -M nginx`
      ```

  1. Then, run this command:

      ```bash
      # semodule -i nginx.pp
      ```

<span id="330-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R19
- NGINX Plus R20
- NGINX Plus R21

&nbsp;

---

## NGINX Controller v3.2.0

March 17, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.2.0, in the following categories:

- [Updates](#320-updates)
- [Resolved Issues](#320-resolved)
- [New Issues](#320-issues)
- [Supported Versions](#320-supported)

<span id="320-updates"></a>

### Updates

NGINX Controller 3.2.0 includes the following updates:

- Bug fixes and improvements.

- API definition URIs support substitutions. When creating or editing a URI within an API Definition, you can enter substitution patterns by using the `{}` notation.

- Adds support for tagging instances.

<span id="320-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

#### Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 Solution Article for details.

- API allows for unauthenticated account creation (9428)

  - Solution Article: [K14631834](https://support.f5.com/csp/article/K14631834) | CVE-2020-5863

- NGINX Controller Agent uses insecure connection for communications between NGINX Controller and NGINX Plus instances by default (5899)

  - Solution Article: [K27205552](https://support.f5.com/csp/article/K27205552) | CVE-2020-5864

#### Additional Fixes

- Stack trace error occurs when accessing the Login credentials schema in the API reference docs. (6409)
- JWT and API Key Authentication Policies Cannot Be Combined when Creating an Identity Provider in the user interface (6432)
- Links to metrics descriptions from user interface point to the metrics reference landing page (7255)
- Usage of API key authentication policies requires the njs module on data-plane instances (7298)
- Omitting URI when defining a component may result in unexpected behavior (7308)
- Experimental APIs are not distinguished from supported APIs in the API Reference docs (7734)

<span id="320-issues"></a>

### New Issues

#### Apps and Services

- **Certificate expiration shows expired warning and expiration date that doesn't match the end-entity certificate (9167)**

  A certificate might appear as expired on the certificate detail page, although the `Valid To` date is in the future. This happens because the summary status and expiration date are calculated based on the entire certificate chain from which the certificate is derived. So, if you have an intermediate CA cert in your chain, the expiration summary status and summary expiration date may reflect the status/date of any intermediate certificate. If you see such a status or expiration date, you should check the status of your entire certificate chain, including that of any intermediate CA.

- **A volume of more than 90 pending CUD operations for Gateways and Components could cause NGINX Controller to become unresponsive (9574)**

  A high volume of Create, Update, and Delete (CUD) operations -- for example, more than 90 -- performed on Gateways and Components could create a condition in which NGINX Controller becomes unresponsive.

  NGINX Controller limits queued operations at 100 and then returns an HTTP 429 error: "Too many requests; wait, and try again."  If, subsequently, additional CUD operations are submitted at a rapid rate (more than 1 per second), the queue may be overrun, creating a condition where no further changes can be processed without involvement from NGINX Support.

  **Workaround:**

  To avoid this situation, limit the amount of API Create, Update, and Delete (CUD) operations sent to the Component and Gateway endpoints to fewer than 100 open actions. The queue should clear 1 action per 7 seconds, on average.

#### Infrastructure

- **Agent warns about failed connection to receiver after update (9152)**

  After updating NGINX Controller and the Controller Agent to v3.2.0, the system warns that the Agent "Failed to connect to the receiver." However, if you look in the `agent.log` file, the Agent is logging communication with the receiver, as expected.

  This warning occurs when a TLS certificate signed with a custom CA is used for the NGINX Controller. Before v3.2.0, the Controller Agent did not verify server certificates.

  To determine the status of the Agent, perform the following on the Agent host:

  - Check the log file `/var/log/nginx-controller/agent.log` for errors.

  - Check the status of the Controller Agent service:

      `systemctl status controller-agent`

      The output should include the status `running`.

- **Agent fails to connect to NGINX Controller if using certs signed with a custom CA (9304)**

  If a TLS certificate for NGINX Controller is signed with a custom CA, the Agent fails to verify the cert and returns an error similar to the following:

  ``` bash
  2020-03-09 20:38:28,803 [5089] MainThread failed POST "https://<fqdn>:8443/1.4/<uuid>/agent/",
  exception: "HTTPSConnectionPool(host='<fqdn>', port=8443): Max retries exceeded with url: /1.4/<uuid>/agent/
  (Caused by SSLError(SSLError(1, u'[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:727)'),))"
  ```

  **Workaround:**

  1. Place the CA on the Agent host.
  1. On the Agent host, edit the `/etc/controller-agent/agent.conf` file. In the `cloud` directive section, make the following changes:

      - Add or set the `requests_ca_bundle` option to point to the CA file.

      - Set `verify_ssl_cert` to `True`. (**Note**: If this setting is set to `False`, then server certificate validation is disabled, which we don't recommend.)

      ```nginx
      [cloud]
      ...
      verify_ssl_cert = True
      requests_ca_bundle = <path-to-ca-bundle-file>
      ```

  1. Save the changes to the `agent.conf` file.
  1. Restart the agent:

      `systemctl restart controller-agent`

  1. Verify that the Agent can connect to the NGINX Controller host:

      `systemctl status controller-agent`

      The output should include the status `running`. You can also check the log file `/var/log/nginx-controller/agent.log` for errors.

#### Documentation

- **Login endpoint has inaccurate session information in the API Reference Guide (9482)**

  The API reference documentation for the Login endpoint describes new session behavior that hasn't been implemented yet. At this time, the default maximum session lifetime is 8 hours. Once the session lifetime limit is exceeded, you must log in to obtain a new session token.

<span id="320-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R19
- NGINX Plus R20

&nbsp;

---

## NGINX Controller v3.1.0

February 26, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.1.0, in the following categories:

- [Updates](#3-1-0-updates)
- [Resolved Issues](#3-1-0-resolved)
- [New Issues](#3-1-0-issues)
- [Supported Versions](#3-1-0-supported)

<span id="3-1-0-updates"></a>

### Updates

NGINX Controller 3.1.0 includes the following updates:

- Bug fixes and improvements.

- The Components resource adds experimental `strategyRef` and `waf` placeholder objects.

  The `strategyRef` and `waf` objects for the Components resource are experimental placeholder objects.  Including the `strategyRef` and/or `waf` blocks in the component specification should not enable additional security-related application traffic services, even if there are no errors. If you see the error “Security module not found on the NGINX instance,” you should remove these blocks.

  {{< note >}} The NGINX Controller REST API may contain API endpoints that are not fully supported. These endpoints are marked with the `x-f5-experimental` vendor extension.{{< /note >}}

- This release adds new app-centric metrics and a new summary page in the UI for viewing these metrics. You can use these app metrics to monitor and evaluate the condition of your apps.

<span id="3-1-0-resolved"></a>

### Resolved Issues

This release includes the following fixes. Search by the issue ID -- the number in parentheses -- to locate the details for an issue.

- Cannot add tags to users with the NGINX Controller web interface (7165)
- Gateway accepts a relative path instead of a URI (7212)
- A component with no URIs will result in an errored deployment (7311)
- NGINX Controller install.sh shows the incorrect version of Docker that's installed (7315)
- Instance Overview page in the web interface is unresponsive and displays "Loading Instances" (7358)
- Referencing a non-existing identity provider for a component does not generate an error (7397)
- GUI incorrectly shows default error log state as enabled (7447)
- Component-based access logging format specification is non-functional (7646)
- Component-level access log enablement results in component getting stuck in an isConfiguring state (7647)
- Manage Apps doc incorrectly states that CRUD operation permissions are determined by RBAC (7651)
- API definitions base path is not imported from OAS spec file (7671)
- The API Reference documentation omits the "Get a Location" endpoint (7747)

<span id="3-1-0-issues"></a>

### New Issues

#### Installation and Upgrade

- **Could not initialize a Kubernetes cluster when installing NGINX Controller on CentOS 7 (5863)**

  There is an issue in CentOS 7 that creates a mismatch between the optimum Docker settings and optimum Kubernetes settings.  This mismatch prevents Kubernetes from initializing during the installation of NGINX Controller on CentOS 7.

  The NGINX Controller installation fails after Docker and Kubernetes are installed, with the following error: "execution phase wait-control-plane: couldn't initialize a Kubernetes cluster."

  **Workaround:**

  - Solution one:

    - Run `sudo yum update`. This updates the components to the latest version and patches the issue.

  - Solution two:

    1. Run `controller-installer/install.sh` and  follow the instructions.  Allow the installation to fail.  This establishes Docker and Kubernetes.
    1. Stop Docker: `sudo systemctl stop docker`
    1. Edit `/etc/docker/daemon.json` and make the the following change: `native.cgroupdriver=systemd to native.cgroupdriver=cgroupfs`
    1. Start Docker: `sudo systemctl start docker`
    1. Reset the Kubernetes configuration: `sudo kubeadm reset -f`
    1. Run `controller-installer/install.sh` and follow the instructions. Rerunning the installation does not update the version of any of the packages on the machine.

#### Apps and Services

- **When committing a gateway with REGEX matchMethod, whose URI includes an explicit port and a path, the error message incorrectly states that the port is invalid (8452)**

  In the context of configuring a gateway, only the protocol, domain, and optional port have any meaning. If the URI specified when configuring a REGEX matchMethod gateway includes a path, including a final `/` after the port, you will receive an error stating:
`Port value is invalid for hostname .*\\.example\\.com`,  where the hostname string corresponds to the data you provided for the domain.

  **Workaround:**

  - Specify your REGEX URI for a gateway as only the protocol, domain, and port with no trailing path.

- **REGEX and REGEX_CASE_SENSITIVE match method logic is reversed for REGEX-based Component URIs (8455)**

  The logic for interpreting `REGEX` and `REGEX_CASE_SENSITIVE` match methods for REGEX-based Component URIs is reversed.

  REGEX-based Component URIs are converted into a case-insensitive location block in `nginx.conf` when the URI is specified as a relative URI (leads with a path, not a domain) and when the match method is specified as `REGEX_CASE_SENSITIVE`. Conversely, when the match method is `REGEX`, the REGEX-based Component URI is interpreted as case sensitive.

  If you need your REGEX-based Component URI to be interpreted as case sensitive, then you can specify the match method as `REGEX` for now. However, keep in mind that when this logic mismatch is fixed in a later release of NGINX Controller, you'll need to revert the match method accordingly.

- **When there's a communication error between NGINX Controller and the Controller Agent, the problem system is identified as "None" (8564)**

  In some cases, when communication between NGINX Controller and the Controller Agent is interrupted, an error similar to the following is returned: "Error: Failed to deploy to instance, Could not find the targeted NGINX running on the system None". This error neglects to indicate the name of the system or systems for which the communication has failed.

  **Workaround:**

  - Communication difficulties can be persistent or temporary, depending on the nature of the failure. It is possible to see some more persistent communication failures by looking at the **Infrastructure** > **Graphics** pane in NGINX Controller. If the hostname and nginx-plus instance are down, these items will appear with a red background.

  - If all the systems and nginx-plus instances have with a white background, the communication problem could be temporary or intermittent, and won't necessarily show in the interface.

    Things to check in order are:

    - Ensure the agent host/container is up
    - Ensure the controller-agent process is running
    - Ensure the nginx-plus process is running
    - Verify network communication between NGINX Controller and the Controller Agent on port 443.

#### Analytics

- **Upgrading from Controller 3.0.0 to 3.1.0 breaks application-centric metrics (8669)**

  When upgrading from NGINX Controller 3.0.0 to 3.1.0, the app-centric metrics are not sent from the NGINX instances to NGINX Controller until a new configuration push is performed.

  **Workaround:**

  - Perform a Put to an object on each NGINX instance to update the config.

#### Documentation

- **API Management module doesn't need to run on dedicated NGINX Plus instances (8665)**

  The API Management documentation states that the API Management module requires a dedicated NGINX Plus instance. This is no longer the case. As of v3.0, the API Management module no longer needs to run on a dedicated instance.

- **Experimental APIs are not distinguished from supported APIs in the API Reference docs (7734)**

  The NGINX Controller REST API may contain API endpoints that are not fully supported. These endpoints are marked with the `x-f5-experimental` vendor extension. The vendor extensions are not displayed in the on-box API reference documentation.

  The following API actions are considered "experimental" features; use is not supported and functionality may change.

  - Create an Environment
  - Create an App
  - Create or update an App Component with the following properties defined in `desiredState`:

    - `ingress.tcpKeepAlive`
    - `backend.workloadGroups.uris.failTimeout`
    - `backend.workloadGroups.uris.resolve`
    - `backend.workloadGroups.uris.route`
    - `backend.workloadGroups.uris.service`
    - `backend.workloadGroups.uris.slowStart`
    - `backend.workloadGroups.serviceDiscovery`
    - `backend.workloadGroups.serviceDiscovery.dnsResolver`
    - `backend.workloadGroups.serviceDiscovery.dnsResolver.uris`
    - `backend.preserveHostHeader`
    - `backend.queue`
    - `backend.httpVersion`
    - `backend.ntlmAuthentication`
    - `backend.persistentState`
    - `programmability.httpHttpsRedirect`
    - `programmability.uriRedirects`
    - `programmability.cookieModifications`
    - `programmability.requestHeaderModifications`
    - `programmability.responseHeaderModifications`
    - `security`
    - `security.waf`
    - `security.conditionalAuth`
    - `security.interceptWorkloadErrors`

  - Create or update a Gateway with the following properties defined in `desiredState`:

    - `ingress.headers`
    - `ingress.http2`
    - `ingress.spdy`
    - `ingress.proxyProtocol`
    - `ingress.setFib`
    - `ingress.fastOpen`
    - `ingress.backlog`
    - `ingress.acceptFilter`
    - `ingress.deferred`
    - `ingress.isIpv6Only`
    - `ingress.reusePort`
    - `ingress.notFoundStatusCode`

- **Stack trace errors occur in the API reference docs (8481)**

  In NGINX Controller, you can access the API reference documentation in-product via the path `http://<controller-FQDN>/docs/api/`.

  For a number of elements, clicking on an object to view the nested content will result in a ReDoc stack trace error.

  **Workaround:**

  Refresh the page to reload the reference documentation. To view the desired schema, look at the example panel instead of clicking to expand the element.

- **Dependencies Missing from Open Source Dependencies Report (7404)**

  In NGINX Controller v3.1, the following open source dependencies were omitted from the open source acknowledgements PDF:

  - [nats version 2.1.0](https://github.com/nats-io/nats.c)
  - [protobuf version 3.10.1](https://github.com/protocolbuffers/protobuf)
  - [protobuf-c version 1.3.2](https://github.com/protobuf-c/protobuf-c)

<span id="3-1-0-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R19
- NGINX Plus R20

&nbsp;

---

## NGINX Controller v3.0.0

January 20, 2020

These release notes provide general information and describe known issues for NGINX Controller v3.0.0, in the following categories:

- [Updates](#300-updates)
- [New Issues](#300-issues)
- [Supported Versions](#300-supported)

<span id="300-updates"></a>

### Updates

- **NGINX Controller Upgrade not supported in v3.0.0**

  For NGINX Controller v3.0.0, upgrade from previous versions is not supported. Breaking changes were introduced between v2.9 and v3.0.0; as such, the `upgrade.sh` script is not present in v3.0.0.

- **New look for the web interface and docs**

  The NGINX Controller v3.0.0 web interface has a brand-new look that we're excited to share. Intuitive forms help guide you through your tasks. You'll notice that features are arranged into four categories to match your workflow:

  - **Analytics** - View your application health score, alerts, and events
  - **Services**: Define your apps and their services
  - **Infrastructure** - Manage your NGINX Plus instances
  - **Platform** - Manage your NGINX Controller settings and user accounts

  The documentation also has a new look. There's an API reference guide that documents the REST API endpoints. If you use the web interface, the related documentation is organized by the same categories that you see in the UI so that you can quickly find the topics related to your tasks.

- **Generate Support Package by Using the "helper" Script**

  New in NGINX Controller v3.0.0, you can pass the `supportpkg` argument to the `helper.sh` script to create a support package. The script gathers NGINX Controller configuration files, logs, and system command output into a tarball. You can use this information to diagnose NGINX Controller issues and/or send the tarball to NGINX Support for troubleshooting assistance. Certs are excluded from the support package.

  Example usage:

    ``` console
    ubuntu@testenv-70389b9b-ctrl-1:/var/tmp$ /opt/nginx-controller/helper.sh supportpkg
    Gathering System Diagnostics: Please wait ...
    Finished: /var/tmp/supportpkg-20191231T053348MST.tar.gz
    ```

- **Events API**

  This release adds an API for the events that were present in Controller version 2.x.

- **Metrics API**

  This release adds an API for the metrics that were present in Controller version 2.x.

<span id="300-issues"></a>

### New Issues

#### API Management

<span id="apim-mismatch"></a>

- **Data displayed by the user interface does not match that returned by the REST API for some API Management endpoints (7117)**

  When working with API Definitions and Published APIs in the API Management module, the following mismatches between the NGINX Controller user interface and the REST API have been reported. These are dependent on where the user created or modified the affected objects.

  - **Identity Provider - API Key**: When you create an Identity Provider that uses API Key authentication by using the REST API, the name of the Identity Provider group will not display in the user interface. This behavior resolves if you modify the Identity Provider resource by using the REST API.

  - **Identity Provider Client - API Key**: When you create an Identity Provider Client that uses API Key authentication by using the user interface, you will receive a "404 - Not Found" error in response to an HTTP GET request for the resource.

  - **Published API**: When you create a Published API by using the user interface, the Environment, Application, Gateway, Policy, and Routes will be missing from the response to an HTTP GET request for the resource.

  - **API Definition**: When you create an API Definition by using the REST API, the name of the API Definition is not displayed in the user interface. When you create an API Definition by using the user interface, the URIs will be missing from the response to an HTTP GET request for the resource.

- **Usage of API key authentication policies requires the njs module on data-plane instances (7298)**

  In the NGINX Controller documentation for the API Management module, we state that "You must install the njs JavaScript module on each NGINX Plus instance to enable API key hashing" when using API key authentication for an Identity Provider. This information is not accurate.

  You must install the `njs` module on all NGINX Plus instances if you want to use API key authentication for any element of NGINX Controller (not just for API Management). This enables cryptographically-protected storage of API keys in the NGINX Plus configuration.

  If you do not install the `njs` module and use API key authentication, whether for API Management or elsewhere, the system may experience errors that are not reported in the user interface. See the [NGINX Admin Guide](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) for `njs` installation instructions.

- **API definitions base path is not imported from OAS spec file (7671)**

  After you use the API Management REST API to create an API Definitions from an OpenAPI 3.0 spec file, the base path is empty.

  **Workaround:**

  - You must manually edit the API Definition and provide the base path for API definitions that are created from imported OAS spec files.

- **JWT and API Key Authentication Policies Cannot Be Combined when Creating an Identity Provider in the user interface (6432)**

  Within a single Published API, configuring both an API key authentication policy and a JWT authentication policy results in an error, and you will not be able to publish.

  **Workaround:**

  - If you're using the NGINX Controller user interface, only add one type of authentication policy (API Key or JWT) per Published API.
  - If you need to use an API key policy and a JWT policy within a single Published API, you can configure those policies using the external API, on condition that the keys are presented in the header or header/bearer, respectively.

#### Installation and Upgrade

- **NGINX Controller install.sh shows the incorrect version of Docker that’s installed (7315)**

  When installing NGINX Controller, the `install.sh` script misidentifies the Docker version that's installed as 19.03.5. NGINX Controller actually installs docker-ce 18.09 and docker-ce-cli 19.03.5. These versions are supported.

  **Note**: The Docker Command Line Interface (docker-ce-cli) is not an NGINX Controller requirement. Rather, it's an interface for the administrator to use when working with the Docker Daemon (docker-ce).

#### Apps and Services

- **Creation of eventually consistent objects returns 201 instead of 202 (7052)**

  Component and gateway objects are considered eventually consistent and will not be immediately configured when created. Currently, these endpoints always return a 201 HTTP code (status created) after a PUT (create) or POST. A 202 HTTP code (status accepted) should be expected instead.

- **User interface cannot be used to correct some error cases from direct API calls (7247)**

  A direct API call can result in an errored state that cannot be subsequently corrected via the user interface. For example, when creating a component, if the protocol in the workload URI is missing, the component is created and goes into the `isError` state. When the user interface is then used to try to add the protocol, the Publish button never becomes green to allow the change to be pushed.

  **Workaround:**

  - Via the API, use a PUT request to correct the error.

- **A component with no URIs will result in an errored deployment (7311)**

  A component must have one or more URIs in its definition. If a component has no URIs, it will result in an error when being deployed, resulting in a failed deployment.

  **Workaround:**

  - Include one or more URIs in the definition of a component.

- **Component-level access log enablement results in component getting stuck in an isConfiguring state (7647)**

  When component-level access logging is enabled, either through the web interface or via the public API, publishing the configuration gets stuck in an `inConfiguring` state. It never advances to a `Configured` state.

  This condition will block updates to the relevant gateway until the underlying condition with the component is resolved.

  **Workaround:**

  - Do not enable component-level access logging.

    If you find yourself in this situation, you can perform a PUT using the public API -- or republish via the web interface -- for the relevant component with component-level access logging disabled. This will result in a configured system and will allow other updates to proceed correctly.

- **Component-based access logging format specification is non-functional (7646)**

  When specified via the NGINX Controller public API (it is not available through the web interface), the format string for the component-level access log always errors out with an invalid string format error, regardless of the validity of the string that's specified.

  **Workaround:**

  - For components to deploy and successfully be configured, avoid setting the component `desiredState.logging.accessLog.format`.

- **Gateway ingress URIs must specify either HTTP:// or HTTPS://, otherwise the gateway becomes stuck in Configuring state (7416)**

  Gateway ingress URIs must specify either `HTTP://` or `HTTPS://` as the protocol for the `ingress.uri`. If the protocol is mistyped in a POST or PUT for a gateway, the gateway can become stuck in a `Configuring` state that never resolves nor issues an error.

  **Workaround:**

  - If you mistyped the ingress URI protocol, you can submit another PUT request to change the protocol to `HTTP://` or `HTTPS://` and the gateway will transition from a `Configuring` state to a `Configured` state.

- **Omitting URI when defining a component may result in unexpected behavior (7308)**

  When defining components, failure to define the protocol and URI fields may result in errors and/or unexpected behaviors. Make sure all components have one or more URIs.  Having a component without a URI can have a cascading effect that causes missing conditions fields for other components with errors.

  If you don't include a URI for one component, and then for a subsequent component you define a URI without designating the protocol, the `currentStatus.state.conditions` field in the JSON response may not be present for the second component, for which the current state is `isError`. This makes it challenging to determine the root cause of the issue.

- **REGEX can only be used for path-based URIs and only in components (5747)**

  Gateways or components that use match methods of `REGEX` or `REGEX_CASE_SENSITIVE` are failing either by erroring out or by getting stuck in a configuring state.

  Ingress URIs using a match method of `REGEX` or `REGEX_CASE_SENSITIVE` can be used only in a component (and not in gateways), and will work only when the URIs specify relative paths starting with `/` or `\/`.

  For example:

    ``` json
      "uris": {
        "/*.jpg": {
          "matchMethod": "REGEX"
        }
      },
    ```

  **Workaround:**

  - If you have a gateway that is unresponsive for more than a few minutes, make sure it doesn't use `REGEX` or `REGEX_CASE_SENSITIVE` as a match method in any of its URIs.

  - If you have a component that is unresponsive, make sure that it complies with the regex guidelines above if `REGEX` or `REGEX_CASE_SENSITIVE` is used as a match method.

  - If you need to change the match method to resolve regex issues, you can use the NGINX web interface or send a PUT request using the API to the appropriate gateway or component, and specify a match method of  `EXACT`, `PREFIX`, or `SUFFIX`. For a gateway, change your URI string to a string that specifies a full protocol--HTTP or HTTPS--and host. For components, the URI string can specify a relative path; a full protocol and host; or a full protocol and host and path.

- **Web user interface incorrectly shows default error log state as enabled (7447)**

  The default setting for the errorLog for a component is `Disabled`; however, the web interface shows the setting as `Enabled` when no action has been taken to change it.

  **Workaround:**

  - Explicitly set the errorLog to the state that is desired, either`Disabled` or `Enabled`. The web interface will then display an errorLog state that is consistent with what is deployed on the component.

- **Current status does not always give an accurate account of the NGINX Controller configuration (7497)**

  Current status does not always reflect the NGINX Controller configuration. This happens, for example, when multiple actions are scripted in a short period (less than 10 seconds) for the same NGINX instance. Examples of inaccurate representations:

  - Components showing that they are in the `isConfigured` state when the configuration is still being deployed
  - Components don't show that they are in the `isDeleting` state while the configuration is being deleted

  **Workaround:**

  - Avoid scripting multiple actions that run in combination in a short period.

- **Intermediate certificates not pushed to NGINX Plus instance (7500)**

  When you upload a certificate chain that includes a CA cert, then associate that cert with a gateway or component, only the end-entity certificate (server cert) is pushed to the NGINX Plus instance. The intermediate CA certs are not pushed when present.  As a result, the chain of trust cannot be established.

  **Workaround:**

  - Manually deploy certificates and keys to the NGINX Plus instance's local filesystem. For example, copy the key file to NGINX Plus at `/etc/ssl/mycert.key`, and the server cert along with all cacerts in a single file at `/etc/ssl/mycert.crt`.

    On NGINX Controller, create a cert object of type `REMOTE_FILE` (use "Add a remote file" in the UI). Use the full path to the files on the NGINX Plus instance for privateKey and publicCert.

- **Gateway accepts a relative path instead of a URI (7212)**

  When creating or updating a gateway, you must provide a URI as the value for the URI field; URI's MUST start with a protocol scheme HTTP or HTTPS. If you provide a relative path you will not see any error messages, but NGINX Controller will not write the desired config to the NGINX Plus instance(s).

  **Workaround:**

  - Do not provide a relative path when defining the URI field for a gateway.

    When defining components, failure to have at least one URI and having URIs with missing protocol fields may result in errors and/or unexpected behaviors. Make sure all components have one or more URIs.  Having a component without a URI can have a cascading effect that causes missing conditions fields for other components with errors.

- **Referencing a non-existing identity provider for a component does not generate an error (7397)**

  Referencing a non-existing identity provider when defining a component does not generate an error.  The status for the component will remain at `Configuring`.

  **Workaround:**

  - Remove the reference to the non-existing identity provider.

- **Can't delete a configured gateway when there is a gateway in an error state (7058)**

  When an entity-- for example, a gateway, component, or published API--references an instance and is in an error state, requests to DELETE other entities that also reference the instance are accepted but not performed.

  **Workaround:**

  - Resolve any errors for the entity that references an instance, and then perform the DELETE request on the entity that you want to remove.

#### Infrastructure

- **Cannot delete an instance that doesn't have NGINX Plus installed (7704)**

  An instance added to NGINX Controller that doesn't already have NGINX Plus installed cannot be deleted from NGINX Controller.

- **Instance Overview page in the web interface is unresponsive and displays "Loading Instances" (7358)**

  The Instance Overview page in the NGINX Controller web interface can become unresponsive if the network interface for any data plane instance is configured only for IPv6. The Instance Overpage page hangs and continually displays the message "Loading Instances."

- **Unreachable instance leads to stuck isConfiguring/isDeleting state (7498)**

  When a create, update, or delete request is sent to a gateway or component of an instance that cannot be reached, the `currentStatus.state.selfConfigState` reports `true` for `isConfiguring` (for create or update) and `true` for `isDeleting` (for delete) indefinitely.

  The state will advance if and only if the instance becomes reachable.

- **Controller Agent stops running on CentOS 6.x (1659)**

  When running the Controller Agent on CentOS 6.x the Agent starts and then stops.

  **Workaround:**

  - Edit the file `/etc/controller-agent/agent.conf`.
  - Add the lines `level = INFO` and `level = DEBUG` to the end of the file.
    This will keep the Controller Agent stable.

- **NGINX Controller registers an existing instance as a new instance when compute VM changes (7844)**

  If the compute VM for an NGINX Plus instance changes, NGINX Controller registers the instance as a new instance instead of honoring the existing agent.conf.

#### Platform

- **Session duration is limited to 8 hours (7239)**

  The current session lifetime is limited to a maximum of 8 hours. This limit cannot be configured for longer or shorter durations. Once the session lifetime limit has been exceeded, users must log in again to receive a new session token.

- **Cannot add tags to users with the NGINX Controller web interface (7165)**

  In NGINX Controller 3.0.0, you cannot add tags to users when creating or updating users using the web interface, and any tags that are created for a user using the API are not displayed.

- **NGINX Controller returns 429 response to new requests when the queue of unprocessed requests is above threshold (7526)**

  NGINX Controller will return a response of 429 "Too many requests" to new PUT, POST, or DELETE requests when its queue depth of unprocessed requests is above a threshold.

  **Workaround:**

  - Retry the request to which the 429 was received after allowing time for the queue to be processed.

- **All users require the built-in Guest role (6231)**

  It's not possible to create a user without a role. By default, all users have the built-in Guest role when they're created if another role isn't specified. The Guest role has read access to environments.

#### Documentation

- **The API Reference documentation omits the "Get a Location" endpoint (7747)**

  In the API Reference documentation located at `<FQDN/docs/api/` on NGINX Controller, the GET Location endpoint is omitted. The missing information is provided below.

  ``` bash
  GET <FQDN>/api/v2/infrastructure/locations/{locationName}
  ```

  *Get a Location*:
  - Returns information about a specified Location resource.
  - PATH PARAMETER(S):
    `locationName`
    - required
    - string
    - The name of the Location that you want to view.

- **Manage Apps doc incorrectly states that CRUD operation permissions are determined by RBAC (7651)**

  In NGINX Controller v3.0.0, the "Manage Apps" document (`<FQDN>/docs/services/apps/manage-apps/`) contains a line that states "CRUD (Create, Read, Update, Delete) operations on an application are determined by RBAC role authorization."

  This statement is incorrect. RBAC permissions are not applied at the Apps level in this release. Instead, the ability to perform CRUD operations is granted by the legacy Admin or User Roles.

- **Stack trace errors occur in the API reference docs (6409)**

  In NGINX Controller v3.0.0, you can access the API reference documentation in-product via the path `http://<controller-FQDN>/docs/api/3.0.0`.

  For several elements -- most notably the login credentials schema -- clicking on an object to expand it will result in a ReDoc stack trace error.

  **Workaround:**

  - Refresh the page to reload the reference documentation. To view the desired schema, look at the example panel instead of clicking to expand the element.

- **Links to metrics descriptions from user interface point to the metrics reference landing page (7255)**

  When you create a new Dashboard using the NGINX Controller user interface, you can click on the "i" (info) symbol to view a description of specific metrics. Clicking the info symbol should bring you to the metrics catalog entry for that metric. In v3.0.0 of NGINX Controller, all of the links point to the metrics reference landing page.

<span id="300-supported"></a>

### Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R19
- NGINX Plus R20

{{< versions "3.0" "latest" "ctrlvers" >}}
