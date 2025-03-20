---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
docs: DOCS-844
title: Release Notes 3.22.2
toc: true
weight: 95
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

March 9, 2022

## Upgrade Considerations

NGINX Controller App Delivery Module release 3.22.2 supports the latest (at the time of release) following four NGINX Plus versions: R23, R24, R25, and R26.

We recommend you [upgrade the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent.md#update-the-nginx-controller-agent" >}}) whenever you upgrade NGINX Controller App Delivery Module.

If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}} Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## Resolved Issues

This release fixes the following issue. To view the history for an issue, search the NGINX Docs website for the issue ID.


- Resubmitting snippets via the UI can fail for gateways and components (31629)


This release also fixes the following new-found issue:


- **Component FQDN URI matchMethod is inconsistent between Controller versions before and since 3.20.0 (32566)**

  The implementation of component ingress FQDN URIs when the matchMethod property is specified is incorrect both for NGINX Controller versions before and after 3.20.0.  Furthermore, the handling is different for each of these NGINX Controller release series.

  The correct handling is for the URI matchMethod within the component to always apply to only the path portion of the ingress URI. If the URI specifies a FQDN, the hostname portion is ignored when applying the match and is always treated as an EXACT match.



  {{< warning >}} Before upgrading to 3.22.2, make sure the expectation for the matchMethod for component FQDN URIs matches the rule mentioned above. If not, the URI needs to be rewritten by putting the hostname portion of the URI in the gateway and using a relative URI in the component. {{< /warning >}}

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **When upgrading an NGINX Controller cluster, the system reports timeout errors waiting for services to scale up (27871)**

  When upgrading the third node of an NGINX Controller cluster, some services may take two or more minutes to scale up. During this period, the system displays an error similar to the following:

  ``` text
  While waiting for nats-streaming-cluster to scale up, the operation did not complete before timing out.
  ```

  You can safely ignore these warnings. The services will continue to scale up in the background and should not interfere with the upgrade.

- **NGINX Controller app-centric metrics may show inaccurate metrics data when HTTPS and TCP+TLS are configured on the same data path (28489)**

  Depending on whether connections close cleanly when both HTTP/HTTPS and TCP/TCP+TLS are configured on the same NGINX instance running the NGINX Controller Agent, inaccurate metrics values may be reported for either HTTP/HTTPS or TCP/TCP+TLS analytics data. The issue won't occur when only HTTP and HTTPS are configured on the same datapath.

- **Some Features of Gateway and Component APIs marked as `Experimental` are not implemented (32246)**

  The following properties within the Gateway and Component APIs are marked as `experimental` but have not been implemented:

  ```none
  gateway.desiredState.ingress.headers
  gateway.desiredState.ingress.http2
  gateway.desiredState.ingress.spdy
  gateway.desiredState.ingress.proxyProtocol
  gateway.desiredState.ingress.notFoundStatusCode
  gateway.desiredState.ingress.setFib
  gateway.desiredState.ingress.fastOpen
  gateway.desiredState.ingress.acceptFilter
  gateway.desiredState.ingress.deferred
  gateway.desiredState.ingress.backlog
  gateway.desiredState.ingress.isIpv6Only
  gateway.desiredState.ingress.reusePort (set by controller for all listen directives)
  components.desiredState.ingress.headers
  components.desiredState.ingress.http2
  components. desiredState.ingress.spdy
  components.desiredState.ingress.proxyProtocol
  components.desiredState.ingress.notFoundStatusCode
  components.desiredState.backend.preserveHostHeader
  components.desiredState.backend.queue
  components. desiredState.backend.persistentState
  components.desiredState.backend.workloadGroups.uris.route
  components.desiredState.programmability.httpHttpsRedirect
  components.desiredState.programmability.cookieModifications
  components.desiredState.security.interceptWorkloadErrors
  ```

  The following properties are marked as `experimental` and have been implemented, but have not been thoroughly tested:

  ```none
  components.desiredState.backend.workloadGroups.uris.failTimeout
  components.desiredState.backend.workloadGroups.uris.slowStart
  components.desiredState.programmability.uriRedirects
  ```

  **Workaround:**

  Snippets can typically be used for properties that map to standalone NGINX directives which Controller does not manage.

  For properties that map to attributes within directives that Controller manages, there are no workarounds currently.

- **Configuring components with an empty workload group can return the wrong HTTP status code (32373)**

  If a component is configured without referencing any gateways and with an empty workload group, the HTTP status code returned will be 500 (Internal Server Error).  Instead, it should return status code 400 (Bad Request).

  **Workaround:**

  Currently there is no workaround for this issue.

- **Running NGINX njs module 0.4.0 or earlier with NGINX Plus may cause application configuration errors (32568)**

  The `js_include` directive was deprecated in version 0.4.0 of the NGINX njs module and removed in version 0.7.1. You should use the `js_import` directive instead.

  NGINX ADC Controller 3.22.2 now writes the `js_import` directive when required. You should confirm that your NGINX Plus installations use njs module 0.4.0 or later, otherwise errors may occur.

  **Workaround:**

  Upgrade the njs module to version 0.4.0 or higher. See the [njs module installation instructions](https://nginx.org/en/docs/njs/install.html) for more information.

- **Ignorable warning and error messages during NGINX Controller installation on Red Hat Enterprise Linux 8 (32804)**

  During the installation on RHEL 8, a warning is displayed while checking Kubernetes:

  ```none
  W0304 00:13:38.871876 1594252 helpers.go:553] --dry-run is deprecated and can be replaced with --dry-run=client.
  ```

  And an error is presented while starting the NGINX Controller stack:

  ```none
  Error: unknown flag: --server-dry-run
  See 'kubectl apply --help' for usage.
  Detected an invalid patch for the analytics database. Resolving conflicts and restarting the analytics database before running the update.
  statefulset.apps/clickhouse patched
  ```

  Both of these messages can be safely ignored.

- **APT does not ask again for a confirmation prompt after an invalid input (32808)**

  The NGINX Controller Agent installation process periodically prompts to assent to the installation of given packages:

  ```none
  Do you want to continue? [Y/n]
  ```

  If you accidentally mistype the response, the package installation will abort:

  ```none
  Do you want to continue? [Y/n] u
  Abort.
  ```

  This may result in a partially installed Controller Agent.

  **Workaround:**

   If you provide a wrong answer by mistake, re-run the agent installation and respond with **Y** to the APT package install prompt.

- **The `reuseport` option is dropped from IPv6 listen directive in certain configurations (34285)**

  NGINX Controller requires listen directives to include the `reuseport` option to prevent potential port bind issues when changing configurations that modify the listen directive. Even if users add `reuseport` in a snippet, NGINX Controller may remove it under certain conditions. This happens, for example, when the IPv6 port matches an IPv4 port, and the IPv4 listen directive does not specify a specific IP address.

  **Workaround**:

  To modify the IPv6 listen directive that doesn't have `reuseport` set, you should first delete the listen directive and apply the configuration. You can then re-add the directive and make the desired change.

## Supported NGINX Plus Versions

Check the [NGINX Controller Tech Specs guide]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
