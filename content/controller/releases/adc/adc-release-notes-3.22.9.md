---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
docs: DOCS-1341
title: Release Notes 3.22.9
toc: true
weight: 88
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

## 3.22.9
September 06, 2023

## Upgrade Paths

- NGINX Controller App Delivery Module 3.22.9 supports upgrades from 3.22.4 and newer versions.

  We recommend you [upgrade the NGINX Controller Agent]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent#update-the-nginx-controller-agent" >}}) whenever you upgrade NGINX Controller.

  If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}} Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

---

### What's New{#3-22-9-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Support for NGINX Plus R30**<a name="3-22-9-whats-new-Support-for-NGINX-Plus-R30"></a>

  NGINX Controller Application Delivery module 3.22.9 fully supports NGINX Plus R30


### Changes in Behavior{#3-22-9-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Kubernetes certificates valid for 2 years**<a name="3-22-9-changes-in-behavior-Kubernetes-certificates-valid-for-2-years"></a>

  {{< important >}}
  The Kubernetes certificates will now default to a 2-year validity, instead of the 1-year validity they had until now.

  This default can be overridden during product updates by setting the `CTR_CERT_RENEWAL_PERIOD` environment variable. For example:

  ```shell
  ./update.sh -e CTR_CERT_RENEWAL_PERIOD=3650
  ```

  {{< /important >}}


### Known Issues{#3-22-9-known-issues}

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Metric API shows incorrect dimension response_code with NGINX Plus R30 and WAF (44333)**

  When using NGINX Plus R30 and WAF is enabled, the metric APIs can return an incorrect dimension value for `http.response_code`.

  **Workaround**

  If you need correct `response_code` values for the metric dimensions and you have enabled WAF, do not upgrade to NGINX R30.

- **Restarting Kubernetes after an unsuccessful database switch may render Controller unusable (35914)**

  After a failed database switch, restarting Kubernetes before reverting the database config values will break the Controller installation, preventing users from logging in to the system.

  **Workaround**

  Before switching the database, ensure that the new database contains the schema and data in the original external database (for example, all of the users, tables, etc.)

  If there is any issue after the database switch, **do not** restart Kubernetes; revert the change back to the original database address using the `helper.sh` script with the old database config values.

- **Ignorable warning and error messages during NGINX Controller installation on Red Hat Enterprise Linux 8 (32804)**

  During the installation on RHEL 8, a warning is displayed while checking Kubernetes:

  ```text
  W0304 00:13:38.871876 1594252 helpers.go:553] --dry-run is deprecated and can be replaced with --dry-run=client.
  ```

  And an error similar to the following is displayed when starting NGINX Controller:

  ```text
  Error: unknown flag: --server-dry-run
  See 'kubectl apply --help' for usage.
  Detected an invalid patch for the analytics database. Resolving conflicts and restarting the analytics database before running the update.
  statefulset.apps/clickhouse patched
  ```

  Both of these messages can be safely ignored.

- **Running NGINX njs module 0.4.0 or earlier with NGINX Plus may cause application configuration errors (32568)**

  The `js_include` directive was deprecated in version 0.4.0 of the NGINX njs module and removed in version 0.7.1. You should use the `js_import` directive instead.

  NGINX ADC Controller 3.22.2 now writes the `js_import` directive when required. You should confirm that your NGINX Plus installations use njs module 0.4.0 or later, otherwise errors may occur.

  **Workaround**

  Upgrade the njs module to version 0.4.0 or higher. See the [njs module installation instructions](https://nginx.org/en/docs/njs/install.html) for more information.

- **Configuring components with an empty workload group can return the wrong HTTP status code (32373)**

  If a component is configured without referencing any gateways and with an empty workload group, the HTTP status code returned will be 500 (Internal Server Error).  Instead, it should return status code 400 (Bad Request).

- **Agent binding error occurs when creating BIG-IP Component (33934)**

  BIG-IP Component creation fails with the following error:

  ``` text
  Failed testing config before applying: nginx:
  the configuration file /etc/nginx/nginx.conf syntax is ok
  nginx: [emerg] bind() to <IP>:20001 failed (99: Cannot assign requested address)
  nginx: configuration file /etc/nginx/nginx.conf test failed
  ```

- **Gateway update fails when a Published API is associated with multiple gateways, and Authentication is enabled in the associated component (34027)**

  When a Published API is created with multiple gateways, and Authentication is enabled in the associated component, the update to any associated gateway will fail with an error similar to the following:

  ```text
  Failed testing config before applying
  ```

  **Workaround**

  Disable Authentication in the component before updating the gateway. Re-enable Authentication after the update.

- **The `reuseport` option is dropped from IPv6 listen directive in certain configurations (34285)**

  NGINX Controller requires listen directives to include the `reuseport` option to prevent potential port bind issues when changing configurations that modify the listen directive. Even if users add `reuseport` in a snippet, NGINX Controller may remove it under certain conditions. This happens, for example, when the IPv6 port matches an IPv4 port, and the IPv4 listen directive does not specify a specific IP address.

  **Workaround**

  To modify the IPv6 listen directive that doesn't have `reuseport` set, you should first delete the listen directive and apply the configuration. You can then re-add the directive and make the desired change.

---
