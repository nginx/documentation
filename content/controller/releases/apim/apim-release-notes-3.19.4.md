---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
docs: DOCS-888
title: Release Notes 3.19.4
toc: true
weight: 93
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

June 1, 2022

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## Resolved Issues

This release fixes the following newly found issues:

- **Verification error due to expired license certificate (34400)**

  Verification of licensing can fail due to an expired certificate. An entry is added to the logs confirming the verification error.

- **Published API fails to upsert when it contains multiple components with multiple IDP providers (34208)**

  Published API fails to upsert when the Published API has multiple components, which reference both JWT and API Key IDP provider types.

- **Published API fails to upsert when IDPs span multiple apps (34207)**

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Developer Portal fails to load when referencing a deleted API (38713)**

  If an API published to a developer portal is deleted, the developer portal will fail to load completely.

## Supported NGINX Plus Versions

Refer to the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
