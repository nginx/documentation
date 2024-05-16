---
description: ''
docs: DOCS-1273
doctypes:
- task
tags:
- docs
title: Assign Roles to Users or User Groups
toc: true
weight: 210
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Before You Begin

This topic assumes you have already created users or user groups that can be assigned roles. If you need to complete these steps, choose one of the links below:

- To create users, follow the instructions in the [Set Up Basic Authentication]({{< relref "/nms/admin-guides/authentication/basic-authentication.md" >}}).
- To create user groups, follow the instructions in [Getting Started with OIDC]({{< relref "/nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}}).


## Assign Roles to Users (Basic Authentication)

{{< include "admin-guides/rbac/assign-roles-to-users.md" >}}

## Assign Roles to User Groups (OIDC)

{{< include "admin-guides/rbac/assign-roles-to-user-groups.md" >}}
