---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
nd-docs: DOCS-903
title: Release Notes 3.22.3
toc: true
weight: 94
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

May 12, 2022

## Upgrade Paths

NGINX Controller App Delivery Module 3.22.3 supports upgrades from 3.6.0 and newer versions.

We recommend you [upgrade the NGINX Controller Agent]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent#update-the-nginx-controller-agent" >}}) whenever you upgrade NGINX Controller.

If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

{{< call-out "warning" >}} Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /call-out >}}

## Changes in Default Behavior

NGINX Controller App Deliver Module 3.22.3 has the following change in default behavior:

- **Removed the ability to specify instances directly that are assigned to an instance group. (33712)**

  Documentation for instance groups mentions that instances that belong to an instance group should not be specified directly from a gateway. This is now being enforced during the creation or update of a gateway. If you try to configure a gateway specifying the instance directly, you will receive an http status code of 400 (Bad Request) with an error message similar to the example below:

  ```none
  Error upserting gateway:
    Object contains invalid instance reference:
      instances cannot be directly referenced if already registered with an instance group:
      'locations/east-loc/instances/east1' is in instance group 'east-ig'
  ```

## Resolved Issues

This release fixes the following new-found issues:


- **Editing a Gateway placement between an instance and instance groups via the UI results in duplication. (33741)**

- When the web interface was being used to modify a placement within the gateway so that an instance is changed to an instance group (or vice-versa), then both placements were showing up in the API request. This has now been corrected and editing results in a single updated entry.

- **"Host not found in upstream" error with legal component configurations. (33584)**

  When a component was configured to use instance affinity with instance groups, made use of FQDN ingress URIs, and also specified a health monitor, the component would be incorrectly configured. This has now been fixed.

- **Improved IDP Client Handling. (33555)**

  There were several issues related to IDP clients that have been cleaned up in this release:

  1. When multiple IDP clients existed for a particular IDP, they could not be individually deleted.

  2. The key associated with an IDP client could not be changed.

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Ignorable warning and error messages during NGINX Controller installation on Red Hat Enterprise Linux 8 (32804)**

  During the installation on RHEL 8, a warning is displayed while checking Kubernetes:

  ```none
  W0304 00:13:38.871876 1594252 helpers.go:553] --dry-run is deprecated and can be replaced with --dry-run=client.
  ```

  And an error similar to the following is displayed when starting NGINX Controller:

  ```none
  Error: unknown flag: --server-dry-run
  See 'kubectl apply --help' for usage.
  Detected an invalid patch for the analytics database. Resolving conflicts and restarting the analytics database before running the update.
  statefulset.apps/clickhouse patched
  ```

  Both of these messages can be safely ignored.

- **Running NGINX njs module 0.4.0 or earlier with NGINX Plus may cause application configuration errors (32568)**

  The `js_include` directive was deprecated in version 0.4.0 of the NGINX njs module and removed in version 0.7.1. You should use the `js_import` directive instead.

  NGINX ADC Controller 3.22.2 now writes the `js_import` directive when required. You should confirm that your NGINX Plus installations use njs module 0.4.0 or later, otherwise errors may occur.

  **Workaround:**

  Upgrade the njs module to version 0.4.0 or higher. See the [njs module installation instructions](https://nginx.org/en/docs/njs/install.html) for more information.

- **Configuring components with an empty workload group can return the wrong HTTP status code (32373)**

  If a component is configured without referencing any gateways and with an empty workload group, the HTTP status code returned will be 500 (Internal Server Error).  Instead, it should return status code 400 (Bad Request).

  **Workaround:**

  None

- **Agent binding error occurs when creating BIG-IP Component (33934)**

  BIG-IP Component creation fails with the following error:

  ```none
  Failed testing config before applying: nginx:
  the configuration file /etc/nginx/nginx.conf syntax is ok
  nginx: [emerg] bind() to <IP>:20001 failed (99: Cannot assign requested address)
  nginx: configuration file /etc/nginx/nginx.conf test failed
  ```

  **Workaround:**

  None

- **Gateway update fails when a Published API is associated with multiple gateways, and Authentication is enabled in the associated component (34027)**

  When a Published API is created with multiple gateways, and Authentication is enabled in the associated component, the update to any associated gateway will fail with an error similar to the following:

  ```none
  Failed testing config before applying
  ```

  **Workaround:**

  Disable Authentication in the component before updating the gateway. Re-enable Authentication after the update.

- **The `reuseport` option is dropped from IPv6 listen directive in certain configurations (34285)**

  NGINX Controller requires listen directives to include the `reuseport` option to prevent potential port bind issues when changing configurations that modify the listen directive. Even if users add `reuseport` in a snippet, NGINX Controller may remove it under certain conditions. This happens, for example, when the IPv6 port matches an IPv4 port, and the IPv4 listen directive does not specify a specific IP address.

  **Workaround**:

  To modify the IPv6 listen directive that doesn't have `reuseport` set, you should first delete the listen directive and apply the configuration. You can then re-add the directive and make the desired change.

### Supported NGINX Plus Versions

Refer to the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
