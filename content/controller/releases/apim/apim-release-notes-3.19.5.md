---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
docs: DOCS-1113
title: Release Notes 3.19.5
toc: true
weight: 92
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

February 24, 2023

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}
  Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.
  {{< /warning >}}

## What's New

- This release includes stability and performance improvements.

## Changes in Default Behavior

- **Updated refresh interval in user interface**

  The user interface refresh interval has been updated to 25 seconds.

## Resolved Issues

This release fixes the following issues. To view the history for an issue, search the NGINX Docs website for the issue ID.

- Developer Portal fails to load when referencing a deleted API (38713)

## Supported NGINX Plus Versions

Refer to the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
