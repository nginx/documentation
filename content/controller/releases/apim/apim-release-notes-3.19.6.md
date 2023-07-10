---

description: These release notes contain information about new features, improvements, known issues, and bug fixes in the NGINX Controller API Management Module.
title: Release Notes 3.19.6
toc: true
weight: 91

---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

July, 6, 2023

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}
  Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.
  {{< /warning >}}

## What's New

- This release includes stability and performance improvements.

## Supported NGINX Plus Versions

NGINX API Management Module 3.19.6 adds support for NGINX Plus R26, R27, R28 and R29.

Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by every release.
