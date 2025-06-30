---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
nd-docs: DOCS-834
title: Release Notes 3.22.1
toc: true
weight: 96
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

January 13, 2022

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller App Delivery Module:

- NGINX Controller App Delivery Module 3.22.1 does not support NGINX App Protect v3.8.

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

  {{< caution >}} If you're upgrading from NGINX Controller 3.18 or earlier to the NGINX Controller App Delivery Module 3.20 or later, the Controller Agent will go offline during the upgrade process.{{< /caution >}}

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}} Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **Support added for APIM Advanced Security licenses**

  NGINX API Management Module with Advanced Security licenses are now supported.

## Resolved Issues

This release includes the following fixes. To locate the details for an issue when it was first reported, search the NGINX Docs for the issue ID.

- **Adding or changing an Identity Provider resets configurations when placed on an Instance Group (31396)**

  Adding or changing an Identity Provider resets configurations placed on Instance Groups in the same environment as the Identity Provider.

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

- **Resubmitting snippets via the web interface can fail for gateways and components (32629)**

  In specific circumstances, where special characters or empty strings are used in the directives, resubmitting snippets via the web interface might fail. This failure is due to information lost during the conversion of NGINX directives. This issue affects only snippets resubmitted using the web interface. Direct API submissions are not affected.

  **Workaround:**

  When updating a component or gateway that uses snippets, verify that the snippet is specified exactly as desired. If not, update the snippet before submitting the request.

- **The `reuseport` option is dropped from IPv6 listen directive in certain configurations (34285)**

  NGINX Controller requires listen directives to include the `reuseport` option to prevent potential port bind issues when changing configurations that modify the listen directive. Even if users add `reuseport` in a snippet, NGINX Controller may remove it under certain conditions. This happens, for example, when the IPv6 port matches an IPv4 port, and the IPv4 listen directive does not specify a specific IP address.

  **Workaround**:

  To modify the IPv6 listen directive that doesn't have `reuseport` set, you should first delete the listen directive and apply the configuration. You can then re-add the directive and make the desired change.

## Supported NGINX Plus Versions

Check the [NGINX Controller Tech Specs guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
