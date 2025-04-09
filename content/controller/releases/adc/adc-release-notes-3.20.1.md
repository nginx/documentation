---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
docs: DOCS-362
title: Release Notes 3.20.1
toc: true
weight: 99
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

October 19, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller App Delivery Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

  {{< caution >}}If you're upgrading from NGINX Controller 3.18 or earlier to the NGINX Controller App Delivery Module 3.20 or later, the Controller Agent will go offline during the upgrade process.{{< /caution >}}

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- Bug fixes
- Adds support for [NGINX Plus R25](https://docs.nginx.com/nginx/releases/#nginxplusrelease-25-r25)
- Adds support for [NAP 3.6](https://docs.nginx.com/nginx-app-protect/releases/#release-36)

## Known issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **When upgrading an NGINX Controller cluster, the system reports timeout errors waiting for services to scale up (27871)**

  When upgrading the third node of an NGINX Controller cluster, some services may take two or more minutes to scale up. During this period, the system displays an error similar to the following:

  ``` text
  While waiting for nats-streaming-cluster to scale up, the operation did not complete before timing out.
  ```

  You can safely ignore these warnings. The services will continue to scale up in the background and should not interfere with the upgrade.

- **NGINX Controller app-centric metrics may show inaccurate metrics data when HTTPS and TCP+TLS are configured on the same data path (28489)**

  Depending on whether connections close cleanly when both HTTP/HTTPS and TCP/TCP+TLS are configured on the same NGINX instance running the NGINX Controller Agent, inaccurate metrics values may be reported for either HTTP/HTTPS or TCP/TCP+TLS analytics data. The issue won't occur when only HTTP and HTTPS are configured on the same datapath.

## Supported NGINX Plus Versions

Check the [NGINX Controller Tech Specs guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
