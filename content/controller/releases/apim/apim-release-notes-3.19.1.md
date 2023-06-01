---
authors: []
categories:
- installation
- api management
date: "2021-09-15T15:32:41-00:00"
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
docs: DOCS-367
doctypes:
- reference
draft: false
journeys:
- researching
- getting started
- using
- renewing
- self service
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
- read-only
tags:
- docs
title: Release Notes 3.19.1
toc: true
weight: 96
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

September 15, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **Adds support for NGINX App Protect 3.5**

  NGINX Controller API Management module 3.19 & 3.19.1 fully support [NGINX App Protect 3.5](https://docs.nginx.com/nginx-app-protect/releases/#release-35)

## Resolved Issues

This release includes the following fixes. To locate the details for an issue when it was first reported, search the NGINX Docs for the issue ID.

- Bug fix for published APIs. This bug was introduced in NGINX Controller API Management Module release 3.18. (28301)

## Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19
