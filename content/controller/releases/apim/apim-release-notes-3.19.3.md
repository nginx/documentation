---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
nd-docs: DOCS-887
title: Release Notes 3.19.3
toc: true
weight: 94
---

+++

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

April 5, 2022

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< call-out "warning" >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /call-out >}}

## Resolved Issues

This release fixes the following issues. To view the history for an issue, search the NGINX Docs website for the issue ID.

- Managed instances go offline or become unresponsive after registering an NGINX Plus R25 instance with NGINX Controller (33356)

## Supported NGINX Plus Versions

This version of NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R25
- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19
